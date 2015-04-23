#!/usr/bin/perl
eval 'exec perl -S $0 ${1+"$@"}'
if 0;
#!perl

use strict;
use DBI;
use Getopt::Long;
use File::Basename;
use Fcntl;
use Encode;
 
$^W = 1;

my $program = basename($0);
my $scriptdir = dirname($0);

my %opt = (
	debug => 0,
	verbose => 0,
	quiet => 0,
	help => 0,
	user => "root",
	password => "root",
	host => "localhost",
	socket => "",
	port => 0,
	execute => 1,
	delete => 0,
	import => 0,
	export => 0,
	insert => 0,
	update => 0,
	delete_all => 0,
	create => 0,
	drop => 0,
	printout => 0,
	language => "",
	dbd => "mysql",
	database => "udo",
	rootdir => "",
);

my $available_drivers = join(", ", DBI->available_drivers);

my $USAGE = <<"_USAGE";
usage: $program [<options>] <command> [<files>]

command:
   --import            import all files (deletes database first!!)
   --export            export complete database
   --insert            insert new command
   --update            update existing command
   --delete            delete command
   --delete_all        delete all commands in database
   
options:
  -?, --help           display this helpscreen and exit
  -u, --user=#         user for database login if not current user
  -p, --password=#     password to use when connecting to server
  -P, --port=#         port to use when connecting to local server
  -S, --socket=#       socket to use when connecting to local server
  --host=#             host to connect to (default: $opt{host})
  --database=#         database name to use (default: $opt{database})
  --dbd=#              database driver to use (default: $opt{dbd}; available: $available_drivers)
  
  --debug              enable debug
  --verbose            print progress messages
  --printout           prints the SQL statements executed on stdout
  --language=#         handle only files for that language
_USAGE


read_my_cnf();		# Read options from ~/.my.cnf

Getopt::Long::Configure(qw(no_ignore_case)); # disambiguate -p and -P
GetOptions(\%opt,
	"import",
	"export",
	"insert",
	"update",
	"delete",
	"delete_all",
	"create",
	"drop",
	
	"debug|d",
	"verbose|v",
	"execute=i",
	"printout",
	"language=s",
	
	"help|h|?",
	"user|u=s",
	"password|p=s",
	"host=s",
	"socket|S=s",
	"database=s",
	"dbd=s",
	"port|P=i") or usage();

usage() if ($opt{help});


if (($opt{import} + $opt{export} + $opt{insert} + $opt{update} + $opt{delete} + $opt{delete_all} + $opt{drop} + $opt{create}) == 0)
{
	printf STDERR "%s: nothing to do\nuse $0 --help for help\n", $program;
	exit(1);
}
if (($opt{import} + $opt{export} + $opt{insert} + $opt{update} + $opt{delete} + $opt{delete_all} + $opt{drop} + $opt{create}) > 1)
{
	printf STDERR "%s: more than one action\n", $program;
	exit(1);
}


my %dbd = (
	Oracle => {
		NVL => "NVL",
		drop_table => "DROP TABLE %s CASCADE CONSTRAINTS;",
	},
	mysql => {
		NVL => "COALESCE",
		drop_table => "DROP TABLE %s;",
	},
	SQLite => {
		NVL => "COALESCE",
		drop_table => "DROP TABLE %s;",
	},
	CSV => {
		NVL => "NVL",
	},
);

my $NVL = $dbd{$opt{dbd}}{NVL} || die "unsupported database driver $opt{dbd}";

my $dbh = dbh_connect();

my %lang;
my %vers;
my $status;

if (! $opt{drop} && ! $opt{create})
{
	read_languages();
	read_versions();
	get_language();
}

$status = import_commands() if ($opt{import});
$status = export_commands() if ($opt{export});
$status = insert_commands() if ($opt{insert});
$status = delete_all_commands() if ($opt{delete_all});
$status = delete_commands() if ($opt{delete});
$status = drop_tables() if ($opt{drop});
$status = 1 if (!defined($status));

$dbh->disconnect;

exit($status);


sub delete_all_commands()
{
	if ($opt{lang_id} == 0)
	{
		do_command("DELETE FROM DESCRIPTION;");
		do_command("DELETE FROM EXAMPLE;");
		do_command("DELETE FROM SYNTAX;");
		do_command("DELETE FROM LABEL;");
		do_command("DELETE FROM HEADER;");
		do_command("DELETE FROM XREF;");
		do_command("DELETE FROM COMMAND;");
	} else
	{
		do_command(sprintf("DELETE FROM DESCRIPTION WHERE LANG_ID = %d;", $opt{lang_id}));
		do_command(sprintf("DELETE FROM EXAMPLE WHERE LANG_ID = %d;", $opt{lang_id}));
		do_command(sprintf("DELETE FROM SYNTAX WHERE LANG_ID = %d;", $opt{lang_id}));
		do_command(sprintf("DELETE FROM LABEL WHERE LANG_ID = %d;", $opt{lang_id}));
		do_command(sprintf("DELETE FROM HEADER WHERE LANG_ID = %d;", $opt{lang_id}));
		do_command(sprintf("DELETE FROM XREF WHERE LANG_ID = %d;", $opt{lang_id}));
		
		# following should be do_command(sprintf("DELETE FROM COMMAND WHERE COMMAND_ID NOT IN (SELECT COMMAND_ID FROM DESCRIPTION);"));
		# but MySQL can't do subqueries
		my @row;
		my $sth = $dbh->prepare("SELECT COMMAND_ID FROM COMMAND;") || die $dbh->errstr;
		$sth->execute || die $dbh->errstr;
		while (@row = $sth->fetchrow_array())
		{
			my $command_id = $row[0];
			if (! row_exists(sprintf("SELECT 'X' FROM DESCRIPTION WHERE COMMAND_ID = %d;", $command_id)))
			{
				do_command(sprintf("DELETE FROM COMMAND WHERE COMMAND_ID = %d;", $command_id));
			}
		}
		$sth->finish;
	}
	
	commit();
	
	return 0;
}


sub delete_commands()
{
	my $command_id;
	my $file;
	my @row;
	my $status;
	
	$status = 0;
	foreach $file (@ARGV)
	{
		@row = fetchrow(sprintf("SELECT COMMAND_ID FROM COMMAND WHERE FILENAME = %s;",
			$dbh->quote(basename($file))));
		if ($#row < 0)
		{
			printf STDERR "%s: unknown filename\n", $file;
			$status = 2;
		} else
		{
			printf STDERR "deleting %s\n", $file if $opt{verbose};
			$command_id = $row[0];
			if ($opt{lang_id} == 0)
			{
				do_command(sprintf("DELETE FROM SYNTAX WHERE COMMAND_ID = %d;", $command_id));
				do_command(sprintf("DELETE FROM DESCRIPTION WHERE COMMAND_ID = %d;", $command_id));
				do_command(sprintf("DELETE FROM EXAMPLE WHERE COMMAND_ID = %d;", $command_id));
				do_command(sprintf("DELETE FROM LABEL WHERE COMMAND_ID = %d;", $command_id));
				do_command(sprintf("DELETE FROM HEADER WHERE COMMAND_ID = %d;", $command_id));
				do_command(sprintf("DELETE FROM XREF WHERE COMMAND_ID = %d;", $command_id));
				do_command(sprintf("DELETE FROM XREF WHERE XREF_TO = %d;", $command_id));
			} else
			{
				do_command(sprintf("DELETE FROM SYNTAX WHERE COMMAND_ID = %d AND LANG_ID = %d;", $command_id, $opt{lang_id}));
				do_command(sprintf("DELETE FROM DESCRIPTION WHERE COMMAND_ID = %d AND LANG_ID = %d;", $command_id, $opt{lang_id}));
				do_command(sprintf("DELETE FROM EXAMPLE WHERE COMMAND_ID = %d AND LANG_ID = %d;", $command_id, $opt{lang_id}));
				do_command(sprintf("DELETE FROM LABEL WHERE COMMAND_ID = %d AND LANG_ID = %d;", $command_id, $opt{lang_id}));
				do_command(sprintf("DELETE FROM HEADER WHERE COMMAND_ID = %d AND LANG_ID = %d;", $command_id, $opt{lang_id}));
				do_command(sprintf("DELETE FROM XREF WHERE COMMAND_ID = %d AND LANG_ID = %d;", $command_id, $opt{lang_id}));
				do_command(sprintf("DELETE FROM XREF WHERE XREF_TO = %d AND LANG_ID = %d;", $command_id, $opt{lang_id}));
			}
			if (! row_exists(sprintf("SELECT 'X' FROM DESCRIPTION WHERE COMMAND_ID = %d;", $command_id)))
			{
				do_command(sprintf("DELETE FROM COMMAND WHERE COMMAND_ID = %d;", $command_id));
			}
		}
	}
	commit();
	return $status;
}


sub import_commands()
{
	my $input_file = { };

	delete_all_commands();
	
	$input_file->{command_id} = 1;
	$input_file->{example_id} = 1;
	$input_file->{description_id} = 1;
	$input_file->{syntax_id} = 1;
	$input_file->{label_id} = 1;
	$input_file->{header_id} = 1;
	$input_file->{xref_id} = 1;
	
	$input_file->{do_delete} = 0;
	
	return import_files($input_file);	
}


sub insert_commands()
{
	my $input_file = { };

	$input_file->{command_id} = (fetchrow("SELECT $NVL(MAX(COMMAND_ID), 0) + 1 FROM COMMAND;"))[0];
	$input_file->{example_id} = (fetchrow("SELECT $NVL(MAX(EXAMPLE_ID), 0) + 1 FROM EXAMPLE;"))[0];
	$input_file->{description_id} = (fetchrow("SELECT $NVL(MAX(DESCRIPTION_ID), 0) + 1 FROM DESCRIPTION;"))[0];
	$input_file->{syntax_id} = (fetchrow("SELECT $NVL(MAX(SYNTAX_ID), 0) + 1 FROM SYNTAX;"))[0];
	$input_file->{label_id} = (fetchrow("SELECT $NVL(MAX(LABEL_ID), 0) + 1 FROM LABEL;"))[0];
	$input_file->{header_id} = (fetchrow("SELECT $NVL(MAX(HEADER_ID), 0) + 1 FROM HEADER;"))[0];
	$input_file->{xref_id} = (fetchrow("SELECT $NVL(MAX(XREF_ID), 0) + 1 FROM XREF;"))[0];
	
	$input_file->{do_delete} = 1;
	
	return import_files($input_file);
}


sub import_files($)
{
	my ($input_file) = @_;
	my $lang_id;
	my $file;
	my @files;
	my $status;
	my $res;
	my $dir;
	
	if ($opt{rootdir} eq "")
	{
		$opt{rootdir} = "$scriptdir/..";
	}
	if (@ARGV)
	{
		@files = @ARGV;
	} else
	{
		@files = ();
		if ($opt{lang_id} == 0)
		{
			$dir = $lang{1}{dir};
		} else
		{
			$dir = $lang{$opt{lang_id}}{dir};
		}
		opendir(COMMANDS, "$opt{rootdir}/$dir/commands") || die "can't open dir $opt{rootdir}/$dir/commands";
		map { ( /.*\.ui/ ? ( $files[$#files + 1] = $_ ) : () ) } readdir(COMMANDS);
		closedir(COMMANDS);
		@files = sort @files;
	}
	$status = 0;
	foreach $file (@files)
	{
		$input_file->{do_insert} = 1;
		foreach $lang_id (sort keys %lang)
		{
			$dir = $lang{$lang_id}{dir};
			if (-d "$opt{rootdir}/$dir/commands")
			{
				$input_file->{filename} = "$opt{rootdir}/$dir/commands/$file";
				$input_file->{lang_id} = $lang_id;
				$res = parse_input($input_file);
				$status = $res if $res > $status;
				
				if ($res < 2)
				{
					$res = insert_or_update($input_file);
					$status = $res if $res > $status;
					
					$input_file->{do_insert} = 0;
				}
				
			}
		}
		++$input_file->{command_id};
	}
	
	if ($status < 2 && $opt{import})
	{
		$res = resolve_xrefs();
		$status = $res if $res > $status;
	}
	
	commit();
	
	return $status;
}


sub resolve_xrefs()
{
	my @all_files;
	my $status;
	my $sth;
	my @row;
	my $command_id;
	my $res;
	my @languages;
	my $lang_id;
	my $i;
	my $filename;
	
	@all_files = ();
	
	if ($opt{lang_id} == 0)
	{
		$sth = $dbh->prepare("SELECT DISTINCT LANG_ID FROM DESCRIPTION;") || die $dbh->errstr;
		$sth->execute || die $dbh->errstr;
		@languages = ();
		while (@row = $sth->fetchrow_array())
		{
			$lang_id = $row[0];
			push @languages, $lang_id;
		}
		$sth->finish;
	} else
	{
		@languages = ($opt{lang_id});
	}
	
	$status = 0;
	$sth = $dbh->prepare("SELECT COMMAND_ID, FILENAME FROM COMMAND;") || die $dbh->errstr;
	$sth->execute() || die $dbh->errstr;
	while (@row = $sth->fetchrow_array())
	{
		$command_id = $row[0];
		$filename = $row[1];
		foreach $lang_id (@languages)
		{
			my $input_file = { };
			$input_file->{lang_id} = $lang_id;
			$input_file->{command_id} = $command_id;
			$input_file->{filename} = "$lang{$lang_id}{dir}/commands/$filename";
			load_from_database($input_file);
			for ($i = 1; $i <= $input_file->{num_xref}; $i++)
			{
				$res = find_xref($input_file, $i);
				$status = $res if $res > $status;
				if ($res < 2)
				{
					do_command(sprintf("UPDATE XREF SET XREF = %s, XREF_TO = %s WHERE COMMAND_ID = %d AND LANG_ID = %d AND LINE = %d;",
						$input_file->{xref}[$i]{xref} eq '' ? "NULL" : $dbh->quote($input_file->{xref}[$i]{xref}),
						defined($input_file->{xref}[$i]{xref_to}) ? $input_file->{xref}[$i]{xref_to} : "NULL",
						$command_id,
						$lang_id,
						$i));
				}
			}
		}
	}
	$sth->finish();
	return $status;
}


sub find_xref($$)
{
	my ($input_file, $i) = @_;
	my $status;
	my @row;
	
	$status = 0;
	undef $input_file->{xref}[$i]{xref_to};
	if ($input_file->{xref}[$i]{xref_type} eq "A")
	{
		@row = fetchrow(sprintf("SELECT COMMAND_ID FROM LABEL WHERE LANG_ID = %d AND LABEL = %s;",
			$input_file->{lang_id},
			$dbh->quote($input_file->{xref}[$i]{xref})));
		if ($#row >= 0)
		{
			$input_file->{xref}[$i]{xref} = '';
			$input_file->{xref}[$i]{xref_to} = $row[0];
		} else
		{
            # printf STDERR "unknown label reference '%s' in %s\n", $input_file->{xref}[$i]{xref}, $input_file->{filename};
            # not an error, label may be defined elsewhere in documentation
 			# $status = 2;
		}
	} elsif ($input_file->{xref}[$i]{xref_type} eq "B" ||
	         $input_file->{xref}[$i]{xref_type} eq "D" ||
	         $input_file->{xref}[$i]{xref_type} eq "N" ||
	         $input_file->{xref}[$i]{xref_type} eq "1")
	{
		@row = fetchrow(sprintf("SELECT COMMAND_ID FROM COMMAND WHERE COMMAND = %s AND COMMAND_TYPE = %s;",
			$dbh->quote($input_file->{xref}[$i]{xref}),
			$dbh->quote($input_file->{xref}[$i]{xref_type})));
		if ($#row >= 0)
		{
			$input_file->{xref}[$i]{xref} = '';
			$input_file->{xref}[$i]{xref_to} = $row[0];
		} else
		{
			printf STDERR "unknown command reference '%s' in %s\n", $input_file->{xref}[$i]{xref}, $input_file->{filename};
			$status = 2;
		}
	} elsif ($input_file->{xref}[$i]{xref_type} eq "L")
	{
	}
	return $status;
}


sub export_commands()
{
	my $lang_id;
	my $file;
	my @files;
	my $status;
	my $res;
	my $dir;
	my $sth;
	my @row;
	my $output_file = { };
	my @languages;
	
	if ($opt{rootdir} eq "")
	{
		$opt{rootdir} = "tmp";
	}
	if (@ARGV)
	{
		@files = @ARGV;
	} else
	{
		@files = ();
		$sth = $dbh->prepare("SELECT FILENAME FROM COMMAND ORDER BY FILENAME;") || die $dbh->errstr;
		$sth->execute || die $dbh->errstr;
		while (@row = $sth->fetchrow_array())
		{
			push @files, $row[0];
		}
		$sth->finish;
	}
	
	if ($opt{lang_id} == 0)
	{
		$sth = $dbh->prepare("SELECT DISTINCT LANG_ID FROM DESCRIPTION;") || die $dbh->errstr;
		# TODO: and COMMAND_ID IN (selected_filenames)
		$sth->execute || die $dbh->errstr;
		@languages = ();
		while (@row = $sth->fetchrow_array())
		{
			$lang_id = $row[0];
			push @languages, $lang_id;
		}
		$sth->finish;
	} else
	{
		@languages = ($opt{lang_id});
	}
	
	if (not -d "$opt{rootdir}")
	{
		mkdir "$opt{rootdir}", 0755 || die "$program: can't create directory $opt{rootdir}";
	}
	foreach $lang_id (@languages)
	{
		$dir = $lang{$lang_id}{dir};
		if (not -d "$opt{rootdir}/$dir/commands")
		{
			if (not -d "$opt{rootdir}/$dir")
			{
				mkdir "$opt{rootdir}/$dir", 0755 || die "$program: can't create directory $opt{rootdir}/$dir";
			}
			mkdir "$opt{rootdir}/$dir/commands", 0755 || die "$program: can't create directory $opt{rootdir}/$dir/commands";
		}
		if (not -d "$opt{rootdir}/$dir/appendix/commands")
		{
			if (not -d "$opt{rootdir}/$dir/appendix")
			{
				mkdir "$opt{rootdir}/$dir/appendix", 0755 || die "$program: can't create directory $opt{rootdir}/$dir/appendix";
			}
			mkdir "$opt{rootdir}/$dir/appendix/commands", 0755 || die "$program: can't create directory $opt{rootdir}/$dir/appendix/commands";
		}
	}
	
	$status = 0;
	foreach $file (@files)
	{
		foreach $lang_id (@languages)
		{
			$dir = $lang{$lang_id}{dir};
			$output_file->{filename} = "$opt{rootdir}/$dir/commands/$file";
			$output_file->{lang_id} = $lang_id;
			$output_file->{command_id} = 0;
			$res = load_from_database($output_file);
			$status = $res if $res > $status;
			
			if ($res < 2)
			{
				$res = export_file($output_file);
				$status = $res if $res > $status;
			}
		}
	}
	
	# export the index file(s)
	if ($status < 2)
	{
		my $filename;
		my $sth;
		my @row;
		my $sort;
		
		foreach $lang_id (@languages)
		{
			$dir = $lang{$lang_id}{dir};
			$filename = "$opt{rootdir}/$dir/appendix/commands/01_index.ui";
			if (! sysopen (OUTFILE, "$filename", O_WRONLY | O_CREAT | O_TRUNC | O_BINARY))
			{
				printf STDERR "can't create %s\n", $filename;
				$status = 2;
			} else
			{
				for $sort ("A".."Z", "*")
				{
					printf OUTFILE "!begin_node %s!..\n", $sort;
					if ($sort eq "*")
					{
						printf OUTFILE "!html_name cmds_other\n";
					} else
					{
						printf OUTFILE "!html_name cmds_%s\n", lc($sort);
					}
					$sth = $dbh->prepare(sprintf("SELECT FILENAME, DESCRIPTION FROM COMMAND, DESCRIPTION WHERE SORT = %s AND COMMAND.COMMAND_ID = DESCRIPTION.COMMAND_ID AND DESCRIPTION.LINE = 0 AND DESCRIPTION.LANG_ID = %d ORDER BY COMMAND, COMMAND_TYPE;", $dbh->quote($sort), $lang_id)) || die $dbh->errstr;
					$sth->execute || die $dbh->errstr;
					while (@row = $sth->fetchrow_array())
					{
						printf OUTFILE "%s!include commands/%s\n", $row[1] eq "(!MISS)" ? "#" : "", $row[0];
					}
					$sth->finish;
					printf OUTFILE "!end_node\n";
					printf OUTFILE "\n" if $sort ne "*";
				}
				close(OUTFILE);
			}
		}
	}
	
	printf "exported database into $opt{rootdir}/\n";
	
	return $status;
}


sub export_file($)
{
	my ($output_file) = @_;
	my $status;
	my $i;
	my $language;
	my @row;
	my $found;
	my $outfile;
	my $did_example;
	
	my %items = (
		"german" => {
			"type_position" => "[(!TYPEPOSITION)]",
			"syntax" => "[(!SYNTAX)]",
			"description" => "[(!DESCRIPTION)]",
			"example" => [
				"[(!EXAMPLE)]", "[(!EXAMPLE2)]",
			],
			"seealso" => "[(!SEEALSO)]",
			"type" => {
				"C" => "(!COMMAND)",
				"A" => "(!COMMANDABBREV)",
				"P" => "(!PLACEHOLDER)",
				"S" => "(!SPECIALCHAR)",
				"W" => "(!SWITCH)",
			},
			"position" => {
				"P" => "(!PREAMBLE)",
				"M" => "(!MAINPART)",
				"B" => "(!PREAMBLE) & (!MAINPART)",
			},
			"existed_until" => "[(!EXISTEDUNTIL)]",
			"exists_since" => "[(!EXISTSSINCE)]",
		},
		"english" => {
			"type_position" => "[(!TYPEPOSITION)]",
			"syntax" => "[(!SYNTAX)]",
			"description" => "[(!DESCRIPTION)]",
			"example" => [
				"[(!EXAMPLE)]", "[(!EXAMPLE2)]",
			],
			"seealso" => "[(!SEEALSO)]",
			"type" => {
				"C" => "(!COMMAND)",
				"A" => "(!COMMANDABBREV)",
				"P" => "(!PLACEHOLDER)",
				"S" => "(!SPECIALCHAR)",
				"W" => "(!SWITCH)",
			},
			"position" => {
				"P" => "(!PREAMBLE)",
				"M" => "(!MAINPART)",
				"B" => "(!PREAMBLE) & (!MAINPART)",
			},
			"existed_until" => "[(!EXISTEDUNTIL)]",
			"exists_since" => "[(!EXISTSSINCE)]",
		},
	);
	
	if (! sysopen ($outfile, "$output_file->{filename}", O_WRONLY | O_CREAT | O_TRUNC | O_BINARY))
	{
		printf STDERR "can't create %s\n", $output_file->{filename};
		$status = 2;
	} else
	{
		my $s = "";
		
		$status = 0;
		$did_example = 0;
		$language = $lang{$output_file->{lang_id}}{name};
		
		printf STDERR "creating %s (%s)\n", basename($output_file->{filename}), $lang{$output_file->{lang_id}}{name} if ($opt{verbose});
		
		if ($output_file->{existed_until})
		{
			$s .= "!ifnset NoOldKeywords\n";
		}
		
		$s .= "!begin_node ";
		if ($output_file->{command_type} eq "S")
		{
			$s .= $output_file->{command};
		} elsif ($output_file->{command_type} eq "D")
		{
			$s .= sprintf("(!kkkw [%s] [%s])", $output_file->{command}, lc($output_file->{command}));
		} elsif ($output_file->{command_type} eq "B")
		{
			$s .= sprintf("(!kkw [%s])", $output_file->{command});
		} elsif ($output_file->{command_type} eq "1")
		{
			$s .= sprintf("(!k1 [/%s])", $output_file->{command});
			
		} elsif ($output_file->{command_type} eq "Q")
		{
			$s .= $output_file->{command};
		} elsif ($output_file->{command_type} eq "N")
		{
			if (substr($output_file->{command}, -1) eq "!")
			{
				$s .= sprintf("(!kw [%s ])", $output_file->{command});
			} elsif (substr($output_file->{command}, -3) eq "[ ]")
			{
				$s .= sprintf("(!kw [%s [~!]])", substr($output_file->{command}, 0, length($output_file->{command}) - 3));
			} elsif ($output_file->{command} eq "..") # grrr
			{
				$s .= sprintf("(!kw [/%s])", $output_file->{command});
			} else
			{
				$s .= sprintf("(!kw [%s])", $output_file->{command});
			}
		} else
		{
			printf STDERR "unknown command_type %s for command %s\n", $output_file->{command_type}, $output_file->{command};
		}
		$s .= "\n";

		for ($i = 1; $i <= $output_file->{num_header}; $i++)
		{
			$s .= sprintf("%s\n", $output_file->{header}[$i]);
		}

		if ($output_file->{html_name} ne "")
		{
			$s .= sprintf("!html_name %s\n", $output_file->{html_name});
		}
		
		for ($i = 1; $i <= $output_file->{num_label}; $i++)
		{
			$s .= sprintf("!label %s\n", $output_file->{label}[$i]);
		}
		$s .= "\n";
		
		$s .= sprintf("%s\n", $output_file->{short_description});
		$s .= "\n";
		
		$s .= sprintf("!begin_xlist %s\n", $items{$language}{type_position});
		$s .= "\n";

		$s .= sprintf("!item %s %s, %s\n",
			$items{$language}{type_position},
			$items{$language}{type}{$output_file->{type}},
			$items{$language}{position}{$output_file->{position}});
		$s .= "\n";

		$s .= sprintf("!item %s (!T)%s(!t)\n",
			$items{$language}{syntax},
			$output_file->{syntax});
		$s .= "\n";

		$s .= sprintf("!item %s\n", $items{$language}{description});
		for ($i = 1; $i <= $output_file->{num_description}; $i++)
		{
			$s .= sprintf("%s\n", $output_file->{description}[$i]);
		}
		$s .= "\n";

		# old format, examples as part of the xlist
		if ($output_file->{num_example} > 0 && $output_file->{example}[1] ne "(!EXAMPLE)" && substr($output_file->{example}[1], 0, 7) ne "!ifdest")
		{
			$s .= sprintf("!item %s\n",
				$items{$language}{example}[$output_file->{num_example} > 1 ? 1 : 0]);
			for ($i = 1; $i <= $output_file->{num_example}; $i++)
			{
				$s .= sprintf("%s\n", $output_file->{example}[$i]);
			}
			$s .= "\n";
			$did_example = 1;
		}
		
		if ($output_file->{exists_since} > 0)
		{
			$s .= sprintf("!item %s %s\n", $items{$language}{exists_since}, $vers{$output_file->{exists_since}});
			$s .= "\n";
		}
		
		if ($output_file->{existed_until} > 1)
		{
			$s .= sprintf("!item %s %s\n", $items{$language}{existed_until}, $vers{$output_file->{existed_until}});
			$s .= "\n";
		}
		
		if ($output_file->{num_xref} > 0)
		{	
			$s .= sprintf("!item %s\n", $items{$language}{seealso});
			for ($i = 1; $i <= $output_file->{num_xref}; $i++)
			{
				$s .= ", " if ($i > 1);
				$found = 0;
				if ($output_file->{xref}[$i]{xref_type} eq "L")
				{
					$s .= sprintf("(!link [%s] [%s])", $output_file->{xref}[$i]{xref}, $output_file->{xref}[$i]{xref});
					$found = 1;
				} elsif ($output_file->{xref}[$i]{xref_type} eq "A")
				{
					if (defined($output_file->{xref}[$i]{xref_to}))
					{
						@row = fetchrow(sprintf("SELECT COMMAND FROM COMMAND WHERE COMMAND_ID = %d;",
							$output_file->{xref}[$i]{xref_to}));
						if ($#row >= 0)
						{
							my $txt = $row[0];
							@row = fetchrow(sprintf("SELECT LABEL FROM LABEL WHERE COMMAND_ID = %d AND LANG_ID = %d;",
								$output_file->{xref}[$i]{xref_to},
								$output_file->{lang_id}));
							if ($#row >= 0)
							{
								$s .= sprintf("(!link [%s] [%s])", $txt, $row[0]);
								$found = 1;
							}
						} else
						{
							$s .= sprintf("(!link [%s] [%s])", $output_file->{xref}[$i]{target}, $output_file->{xref}[$i]{xref});
							$found = 1;
						}
					} else
					{
						$s .= sprintf("(!link [%s] [%s])", $output_file->{xref}[$i]{target}, $output_file->{xref}[$i]{xref});
						$found = 1;
					}
				} elsif ($output_file->{xref}[$i]{xref_type} eq "D")
				{
					@row = fetchrow(sprintf("SELECT COMMAND FROM COMMAND WHERE COMMAND_ID = %d;",
						$output_file->{xref}[$i]{xref_to}));
					if ($#row >= 0)
					{
						$s .= sprintf("(!KKKW [%s] [%s])", $row[0], lc($row[0]));
						$found = 1;
					}
				} elsif ($output_file->{xref}[$i]{xref_type} eq "B")
				{
					@row = fetchrow(sprintf("SELECT COMMAND FROM COMMAND WHERE COMMAND_ID = %d;",
						$output_file->{xref}[$i]{xref_to}));
					if ($#row >= 0)
					{
						$s .= sprintf("(!KKW [%s])", $row[0]);
						$found = 1;
					}
				} elsif ($output_file->{xref}[$i]{xref_type} eq "N")
				{
					@row = fetchrow(sprintf("SELECT COMMAND FROM COMMAND WHERE COMMAND_ID = %d;",
						$output_file->{xref}[$i]{xref_to}));
					if ($#row >= 0)
					{
						if (substr($row[0], -3) eq "[ ]")
						{
							$s .= sprintf("(!KW [%s] [[~!!]])", substr($row[0], 0, length($row[0]) - 3));
						} else
						{
							$s .= sprintf("(!KW [%s])", $row[0]);
						}
						$found = 1;
					}
				} elsif ($output_file->{xref}[$i]{xref_type} eq "1")
				{
					@row = fetchrow(sprintf("SELECT COMMAND FROM COMMAND WHERE COMMAND_ID = %d;",
						$output_file->{xref}[$i]{xref_to}));
					if ($#row >= 0)
					{
						$s .= sprintf("(!K1 [/%s])", $row[0]);
						$found = 1;
					}
				}
				if (! $found)
				{
					printf STDERR "%s: warning: can't find reference\n", $output_file->{filename};
					$status = 1;
				}
			}
			$s .= "\n";
			$s .= "\n";
		}
					
		$s .= "!end_xlist\n";
		$s .= "\n";
		
		# new format, examples after the xlist
		if ($output_file->{num_example} > 0 && !$did_example)
		{
			for ($i = 1; $i <= $output_file->{num_example}; $i++)
			{
				$s .= sprintf("%s\n", $output_file->{example}[$i]);
			}
			$s .= "\n";
		}
		
		$s .= "!end_node\n";
		
		if ($output_file->{existed_until})
		{
			$s .= "!endif\n";
		}
		my $e = encode("latin1", $s);
		syswrite($outfile, $e, length($e));
		close($outfile);
	}
	
	return $status;
}


sub load_from_database($)
{
	my ($output_file) = @_;
	my $sth;
	my @row;
	my $status;
	
	$output_file->{existed_until} = 0;
	$output_file->{exists_since} = 0;
	
	$output_file->{num_description} = 0;
	$output_file->{description} = ();
	$output_file->{num_example} = 0;
	$output_file->{example} = ();
	$output_file->{num_xref} = 0;
	$output_file->{xref} = ();
	$output_file->{num_label} = 0;
	$output_file->{label} = ();
	$output_file->{num_header} = 0;
	$output_file->{header} = ();
	
	$output_file->{command} = "";
	$output_file->{command_type} = "";
	$output_file->{type} = "";
	$output_file->{position} = "";
	$output_file->{syntax} = "";
	$output_file->{short_description} = "";
	$output_file->{sort} = "";
	$output_file->{html_name} = "";
	
	$status = 0;
	if ($output_file->{command_id} == 0)
	{
		@row = fetchrow(sprintf("SELECT COMMAND_ID FROM COMMAND WHERE FILENAME = %s;",
			$dbh->quote(basename($output_file->{filename}))));
		if ($#row < 0)
		{
			printf STDERR "%s: unknown filename\n", basename($output_file->{filename});
			$status = 2;
		} else
		{
			$output_file->{command_id} = $row[0];
		}
	}
	if ($status == 0)
	{
		@row = fetchrow(sprintf("SELECT COMMAND, COMMAND_TYPE, TYPE, POS, $NVL(EXISTED_UNTIL, 0), $NVL(EXISTS_SINCE, 0), SORT, HTML_FILENAME FROM COMMAND WHERE COMMAND_ID= %d;",
			$output_file->{command_id}));
		$output_file->{command} = $row[0];
		$output_file->{command_type} = $row[1];
		$output_file->{type} = $row[2];
		$output_file->{position} = $row[3];
		$output_file->{existed_until} = $row[4];
		$output_file->{exists_since} = $row[5];
		$output_file->{sort} = $row[6];
		$output_file->{html_name} = $row[7];
		
		@row = fetchrow(sprintf("SELECT SYNTAX FROM SYNTAX WHERE COMMAND_ID = %d AND LANG_ID = %d;",
			$output_file->{command_id},
			$output_file->{lang_id}));
		if ($#row >= 0)
		{
			$output_file->{syntax} = $row[0];
		}
		
		@row = fetchrow(sprintf("SELECT DESCRIPTION FROM DESCRIPTION WHERE COMMAND_ID = %d AND LANG_ID = %d AND LINE = 0;",
			$output_file->{command_id},
			$output_file->{lang_id}));
		if ($#row >= 0)
		{
			$output_file->{short_description} = $row[0];
		}
		
		$sth = $dbh->prepare(sprintf("SELECT DESCRIPTION FROM DESCRIPTION WHERE COMMAND_ID = %d AND LANG_ID = %d AND LINE > 0 ORDER BY LINE;",
			$output_file->{command_id},
			$output_file->{lang_id})) || die $dbh->errstr;
		$sth->execute || die $dbh->errstr;
		while (@row = $sth->fetchrow_array())
		{
			++$output_file->{num_description};
			$output_file->{description}[$output_file->{num_description}] = $row[0];
		}
		$sth->finish;
		
		$sth = $dbh->prepare(sprintf("SELECT EXAMPLE FROM EXAMPLE WHERE COMMAND_ID = %d AND LANG_ID = %d ORDER BY LINE;",
			$output_file->{command_id},
			$output_file->{lang_id})) || die $dbh->errstr;
		$sth->execute || die $dbh->errstr;
		while (@row = $sth->fetchrow_array())
		{
			++$output_file->{num_example};
			$output_file->{example}[$output_file->{num_example}] = $row[0];
		}
		$sth->finish;
		
		$sth = $dbh->prepare(sprintf("SELECT LABEL FROM LABEL WHERE COMMAND_ID = %d AND LANG_ID = %d ORDER BY LINE;",
			$output_file->{command_id},
			$output_file->{lang_id})) || die $dbh->errstr;
		$sth->execute || die $dbh->errstr;
		while (@row = $sth->fetchrow_array())
		{
			++$output_file->{num_label};
			$output_file->{label}[$output_file->{num_label}] = $row[0];
		}
		$sth->finish;
		
		$sth = $dbh->prepare(sprintf("SELECT HEADER FROM HEADER WHERE COMMAND_ID = %d AND LANG_ID = %d ORDER BY LINE;",
			$output_file->{command_id},
			$output_file->{lang_id})) || die $dbh->errstr;
		$sth->execute || die $dbh->errstr;
		while (@row = $sth->fetchrow_array())
		{
			++$output_file->{num_header};
			$output_file->{header}[$output_file->{num_header}] = $row[0];
		}
		$sth->finish;
		
		$sth = $dbh->prepare(sprintf("SELECT XREF_TYPE, XREF, XREF_TO, TARGET FROM XREF WHERE COMMAND_ID = %d AND LANG_ID = %d ORDER BY LINE;",
			$output_file->{command_id},
			$output_file->{lang_id})) || die $dbh->errstr;
		$sth->execute || die $dbh->errstr;
		while (@row = $sth->fetchrow_array())
		{
			++$output_file->{num_xref};
			$output_file->{xref}[$output_file->{num_xref}]{xref_type} = $row[0];
			$output_file->{xref}[$output_file->{num_xref}]{xref} = $row[1];
			$output_file->{xref}[$output_file->{num_xref}]{xref_to} = $row[2];
			$output_file->{xref}[$output_file->{num_xref}]{target} = $row[3];
		}
		$sth->finish;
	}
	
	return $status;
}


sub read_languages()
{
	my $sth;
	my @row;
	my $lang_id;
	
	%lang = ();
	$sth = $dbh->prepare("SELECT LANG_ID, DIR, NAME FROM LANG ORDER BY LANG_ID;") || die $dbh->errstr;
	$sth->execute || die $dbh->errstr;
	while (@row = $sth->fetchrow_array())
	{
		$lang_id = $row[0];
		$lang{$lang_id}{lang_id} = $lang_id;
		$lang{$lang_id}{dir} = $row[1];
		$lang{$lang_id}{name} = $row[2];
	}
	$sth->finish;
}


sub get_language()
{
	my $lang_id;
	
	if ($opt{language} ne "")
	{
		$opt{lang_id} = 0;
		foreach $lang_id (keys %lang)
		{
			if ($opt{language} eq $lang{$lang_id}{name})
			{
				$opt{lang_id} = $lang_id;
			}
		}
		if ($opt{lang_id} == 0)
		{
			$opt{lang_id} = $opt{language};
		}
		if (not defined($lang{$opt{lang_id}}))
		{
			printf STDERR "$program: unknown language %s\n", $opt{language};
			exit(1);
		}
	} else
	{
		$opt{lang_id} = 0;
	}
}


sub read_versions()
{
	my $sth;
	my @row;
	my $vers_id;
	my $vers_text;
	
	%vers = ();
	$sth = $dbh->prepare("SELECT VERS_ID, VERS FROM VERS;") || die $dbh->errstr;
	$sth->execute || die $dbh->errstr;
	while (@row = $sth->fetchrow_array())
	{
		$vers_id = $row[0];
		$vers_text = $row[1];
		$vers{$vers_id} = $vers_text;
		$vers{$vers_text} = $vers_id;
	}
	$sth->finish;
}


sub insert_or_update($)
{
	my ($input_file) = @_;
	my $i;
	my $status;
	my $res;
	
	$status = 0;
	if ($input_file->{do_insert})
	{
		if (row_exists(sprintf("SELECT COMMAND_ID FROM COMMAND WHERE FILENAME = %s",
			$dbh->quote(basename($input_file->{filename})))))
		{
			printf STDERR "filename %s already exists\n", $dbh->quote(basename($input_file->{filename}));
			$status = 2;
		}
		if ($input_file->{html_name} ne "")
		{
			if (row_exists(sprintf("SELECT COMMAND_ID FROM COMMAND WHERE HTML_FILENAME = %s",
				$dbh->quote($input_file->{html_name}))))
			{
				printf STDERR "html filename %s already exists\n", $dbh->quote($input_file->{html_name});
				$status = 2;
			}
		}
		if (row_exists(sprintf("SELECT COMMAND_ID FROM COMMAND WHERE COMMAND = %s AND COMMAND_TYPE = %s",
			$dbh->quote($input_file->{command}),
			$dbh->quote($input_file->{command_type}))))
		{
			printf STDERR "command %s already exists\n", $dbh->quote($input_file->{command});
			$status = 2;
		}
		do_command(sprintf("INSERT INTO COMMAND(COMMAND_ID, COMMAND, COMMAND_TYPE, TYPE, POS, FILENAME, SORT, HTML_FILENAME)  VALUES(%d, %s, %s, %s, %s, %s, %s, %s);",
		   $input_file->{command_id},
		   $dbh->quote($input_file->{command}),
		   $dbh->quote($input_file->{command_type}),
		   $dbh->quote($input_file->{type}),
		   $dbh->quote($input_file->{position}),
		   $dbh->quote(basename($input_file->{filename})),
		   $dbh->quote($input_file->{sort}),
		   $dbh->quote($input_file->{html_name})));
	} else
	{
	}
	
	if ($status < 2)
	{
		if ($input_file->{existed_until})
		{
			if ($input_file->{existed_until} == 1)
			{
				printf STDERR "%s: warning: no !item [Existed until:] found\n", $input_file->{filename};
				$status = 1 if $status < 1;
			}
			do_command(sprintf("UPDATE COMMAND SET EXISTED_UNTIL = %d WHERE COMMAND_ID = %d;", $input_file->{existed_until}, $input_file->{command_id}));
		}
		if ($input_file->{exists_since})
		{
			do_command(sprintf("UPDATE COMMAND SET EXISTS_SINCE = %d WHERE COMMAND_ID = %d;", $input_file->{exists_since}, $input_file->{command_id}));
		}
		
		if ($input_file->{do_delete})
		{
			do_command(sprintf("DELETE FROM SYNTAX WHERE COMMAND_ID = %d AND LANG_ID = %d;", $input_file->{command_id}, $input_file->{lang_id}));
			do_command(sprintf("DELETE FROM DESCRIPTION WHERE COMMAND_ID = %d AND LANG_ID = %d;", $input_file->{command_id}, $input_file->{lang_id}));
			do_command(sprintf("DELETE FROM EXAMPLE WHERE COMMAND_ID = %d AND LANG_ID = %d;", $input_file->{command_id}, $input_file->{lang_id}));
			do_command(sprintf("DELETE FROM LABEL WHERE COMMAND_ID = %d AND LANG_ID = %d;", $input_file->{command_id}, $input_file->{lang_id}));
			do_command(sprintf("DELETE FROM HEADER WHERE COMMAND_ID = %d AND LANG_ID = %d;", $input_file->{command_id}, $input_file->{lang_id}));
			do_command(sprintf("DELETE FROM XREF WHERE COMMAND_ID = %d AND LANG_ID = %d;", $input_file->{command_id}, $input_file->{lang_id}));
		}
		
		do_command(sprintf("INSERT INTO SYNTAX(SYNTAX_ID, COMMAND_ID, LANG_ID, SYNTAX)  VALUES(%d, %d, %d, %s);",
		   $input_file->{syntax_id},
		   $input_file->{command_id},
		   $input_file->{lang_id},
		   $dbh->quote($input_file->{syntax})));
		++$input_file->{syntax_id};
		
		if ($input_file->{short_description} ne "")
		{
			do_command(sprintf("INSERT INTO DESCRIPTION(DESCRIPTION_ID, COMMAND_ID, LANG_ID, LINE, DESCRIPTION)  VALUES(%d, %d, %d, %d, %s);",
				$input_file->{description_id},
				$input_file->{command_id},
				$input_file->{lang_id},
				0,
				$dbh->quote($input_file->{short_description})));
			++$input_file->{description_id};
		}
		
		for ($i = 1; $i <= $input_file->{num_description}; $i++)
		{
			do_command(sprintf("INSERT INTO DESCRIPTION(DESCRIPTION_ID, COMMAND_ID, LANG_ID, LINE, DESCRIPTION)  VALUES(%d, %d, %d, %d, %s);",
				$input_file->{description_id},
				$input_file->{command_id},
				$input_file->{lang_id},
				$i,
				$dbh->quote($input_file->{description}[$i])));
			++$input_file->{description_id};
		}
		
		for ($i = 1; $i <= $input_file->{num_example}; $i++)
		{
			do_command(sprintf("INSERT INTO EXAMPLE(EXAMPLE_ID, COMMAND_ID, LANG_ID, LINE, EXAMPLE)  VALUES(%d, %d, %d, %d, %s);",
				$input_file->{example_id},
				$input_file->{command_id},
				$input_file->{lang_id},
				$i,
				$dbh->quote($input_file->{example}[$i])));
			++$input_file->{example_id};
		}
		
		for ($i = 1; $i <= $input_file->{num_label}; $i++)
		{
			do_command(sprintf("INSERT INTO LABEL(LABEL_ID, COMMAND_ID, LANG_ID, LINE, LABEL)  VALUES(%d, %d, %d, %d, %s);",
				$input_file->{label_id},
				$input_file->{command_id},
				$input_file->{lang_id},
				$i,
				$dbh->quote($input_file->{label}[$i])));
			++$input_file->{label_id};
		}
		
		for ($i = 1; $i <= $input_file->{num_header}; $i++)
		{
			do_command(sprintf("INSERT INTO HEADER(HEADER_ID, COMMAND_ID, LANG_ID, LINE, HEADER)  VALUES(%d, %d, %d, %d, %s);",
				$input_file->{header_id},
				$input_file->{command_id},
				$input_file->{lang_id},
				$i,
				$dbh->quote($input_file->{header}[$i])));
			++$input_file->{header_id};
		}
		
		for ($i = 1; $i <= $input_file->{num_xref}; $i++)
		{
			if ($status < 2)
			{
				if (! $opt{import})
				{
					$res = find_xref($input_file, $i);
					$status = $res if $res > $status;
				}
			}
			if ($status < 2)
			{
				do_command(sprintf("INSERT INTO XREF(XREF_ID, COMMAND_ID, LANG_ID, LINE, XREF_TYPE, XREF, XREF_TO, TARGET)  VALUES(%d, %d, %d, %d, %s, %s, %s, %s);",
					$input_file->{xref_id},
					$input_file->{command_id},
					$input_file->{lang_id},
					$i,
					$dbh->quote($input_file->{xref}[$i]{xref_type}),
					$dbh->quote($input_file->{xref}[$i]{xref}),
					defined($input_file->{xref}[$i]{xref_to}) ? $input_file->{xref}[$i]{xref_to} : "NULL",
					$input_file->{xref}[$i]{target} ne "" ? $dbh->quote($input_file->{xref}[$i]{target}) : "NULL"));
				++$input_file->{xref_id};
			}
		}
	}
		
	return $status;
}


sub parse_input($)
{
	my ($input_file) = @_;
	my $xlist_level;
	my $description_level;
	my $blist_level;
	my $itemize_level;
	my $if_level;
	my $name;
	my $language;
	my $parse_state = { };
	my $status;
	my $res;
	my $base_name;
	my $input_line;
	
	my %items = (
		"german" => {
			"type_position" => {
				"[Typ & Position:]" => 1,
				"[(!TYPEPOSITION)]" => 1,
			},
			"syntax" => {
				"[Syntax:]" => 1,
				"[(!SYNTAX)]" => 1,
			},
			"description" => {
				"[Beschreibung:]" => 1,
				"[(!DESCRIPTION)]" => 1,
			},
			"example" => {
				"[Beispiel:]" => 1,
				"[Beispiele:]" => 1,
				"[(!EXAMPLE)]" => 1,
				"[(!EXAMPLE2)]" => 1,
				"(!EXAMPLE)" => 1,
				"(!EXAMPLE_BEFORE)" => 1,
			},
			"example_end" => {
				"(!EXAMPLE_END)" => 1,
			},
			"seealso" => {
				"[Siehe auch:]" => 1,
				"[(!SEEALSO)]" => 1,
			},
			"type" => {
				"Kommando" => "C",
				"Kommando-Abkürzung" => "A",
				"Platzhalter" => "P",
				"Sonderzeichen" => "S",
				"Schalter" => "W",
				"(!COMMAND)" => "C",
				"(!COMMANDABBREV)" => "A",
				"(!PLACEHOLDER)" => "P",
				"(!SPECIALCHAR)" => "S",
				"(!SWITCH)" => "W",
			},
			"position" => {
				"Vorspann" => "P",
				"Hauptteil" => "M",
				"Vorspann & Hauptteil" => "B",
				"(!PREAMBLE)" => "P",
				"(!MAINPART)" => "M",
				"(!PREAMBLE) & (!MAINPART)" => "B",
			},
			"existed_until" => {
				"[Existierte bis:]" => 1,
				"[(!EXISTEDUNTIL)]" => 1,
			},
			"exists_since" => {
				"[Existiert seit:]" => 1,
				"[(!EXISTSSINCE)]" => 1,
			},
		},
		"english" => {
			"type_position" => {
				"[Type & position:]" => 1,
				"[(!TYPEPOSITION)]" => 1,
			},
			"syntax" => {
				"[Syntax:]" => 1,
				"[(!SYNTAX)]" => 1,
			},
			"description" => {
				"[Description:]" => 1,
				"[(!DESCRIPTION)]" => 1,
			},
			"example" => {
				"[Example:]" => 1,
				"[Examples:]" => 1,
				"[(!EXAMPLE)]" => 1,
				"[(!EXAMPLE2)]" => 1,
				"(!EXAMPLE)" => 1,
				"(!EXAMPLE_BEFORE)" => 1,
			},
			"example_end" => {
				"(!EXAMPLE_END)" => 1,
			},
			"seealso" => {
				"[See also:]" => 1,
				"[(!SEEALSO)]" => 1,
			},
			"type" => {
				"command" => "C",
				"command abbreviation" => "A",
				"placeholder" => "P",
				"special characters" => "S",
				"switch" => "W",
				"(!COMMAND)" => "C",
				"(!COMMANDABBREV)" => "A",
				"(!PLACEHOLDER)" => "P",
				"(!SPECIALCHAR)" => "S",
				"(!SWITCH)" => "W",
			},
			"position" => {
				"preamble" => "P",
				"main part" => "M",
				"preamble & main part" => "B",
				"(!PREAMBLE)" => "P",
				"(!MAINPART)" => "M",
				"(!PREAMBLE) & (!MAINPART)" => "B",
			},
			"existed_until" => {
				"[Existed until:]" => 1,
				"[(!EXISTEDUNTIL)]" => 1,
			},
			"exists_since" => {
				"[Exists since:]" => 1,
				"[(!EXISTSSINCE)]" => 1,
			},
		},
	);
	
	if (! open (INFILE, "<:encoding(latin1)", "$input_file->{filename}"))
	{
		printf STDERR "can't open %s\n", $input_file->{filename};
		$status = 2;
	} else
	{
		printf STDERR "parsing %s\n", $input_file->{filename} if $opt{verbose};
		$parse_state->{filename} = $input_file->{filename};
		$parse_state->{lineno} = 0;
		$parse_state->{in_node} = 0;
		$parse_state->{in_xref} = 0;
		$parse_state->{in_description} = 0;
		$parse_state->{in_example} = 0;
		$xlist_level = 0;
		$description_level = 0;
		$blist_level = 0;
		$if_level = 0;
		$itemize_level = 0;
		
		$input_file->{existed_until} = 0;
		$input_file->{exists_since} = 0;
		
		$input_file->{num_description} = 0;
		$input_file->{description} = ();
		$input_file->{num_example} = 0;
		$input_file->{example} = ();
		$input_file->{num_xref} = 0;
		$input_file->{xref} = ();
		$input_file->{num_label} = 0;
		$input_file->{label} = ();
		$input_file->{num_header} = 0;
		$input_file->{header} = ();
		
		$status = 0;

		$input_file->{command} = "";
		$input_file->{command_type} = "";
		$input_file->{type} = "";
		$input_file->{position} = "";
		$input_file->{syntax} = "";
		$input_file->{short_description} = "";
		$input_file->{sort} = "";
		$input_file->{html_name} = "";
		
		$language = $lang{$input_file->{lang_id}}{name};
		
		while (<INFILE>)
		{
			my @line;
			
			++$parse_state->{lineno};
			
# chomp($_);
			$_ =~ s/\012$//g;
			$_ =~ s/\015$//g;
			$input_line = $_;
			
			@line = split(/ /);
			@{$parse_state->{line}} = @line;
			if ($#line >= 0 && $line[0] eq "!begin_node" && $parse_state->{in_example} < 2)
			{
				if ($#{$parse_state->{line}} == 1 &&
					($parse_state->{line}[1] eq "(\"\")" ||
				     $parse_state->{line}[1] eq "((\"\"))" ||
				     $parse_state->{line}[1] eq "('')" ||
				     $parse_state->{line}[1] eq "((''))" ||
				     $parse_state->{line}[1] eq "(--)" ||
				     $parse_state->{line}[1] eq "((--))" ||
				     $parse_state->{line}[1] eq "(---)" ||
				     $parse_state->{line}[1] eq "((---))" ) )
				{
					$input_file->{command} = $parse_state->{line}[1];
					$input_file->{command_type} = "S";
					$input_file->{sort} = "*";
				} elsif ($#{$parse_state->{line}} == 3 && $parse_state->{line}[1] eq "(!kkkw")
				{
					$input_file->{command} = substr($parse_state->{line}[2], 1, -1);
					if (uc(substr($parse_state->{line}[3], 1, -2)) ne $input_file->{command})
					{
						printf STDERR "%s: %s not lowercase version of %s in line %d\n", $input_file->{filename}, substr($parse_state->{line}[3], 1, -2), $input_file->{command}, $parse_state->{lineno};
						$status = 2;
					}
					$input_file->{command_type} = "D";
				} elsif ($#{$parse_state->{line}} == 2 && $parse_state->{line}[1] eq "(!kkw")
				{
					$name = substr($parse_state->{line}[2], 1, length($parse_state->{line}[2]) - 3);
					if (substr($name, 0, 1) eq "/")
					{
						$name = substr($name, 1);
					}
					$input_file->{command} = $name;
					$input_file->{command_type} = "B";
				} elsif ($#{$parse_state->{line}} == 2 && $parse_state->{line}[1] eq "(!k1")
				{
					$name = substr($parse_state->{line}[2], 1, length($parse_state->{line}[2]) - 3);
					if (substr($name, 0, 1) eq "/")
					{
						$name = substr($name, 1);
					}
					$input_file->{command} = $name;
					$input_file->{command_type} = "1";
				} elsif ($#{$parse_state->{line}} == 1)
				{
					$name = $parse_state->{line}[1];
					if (substr($name, 0, 1) eq "/")
					{
						$name = substr($name, 1);
					}
					$input_file->{command} = $name;
					$input_file->{command_type} = "Q";
				} elsif ($#{$parse_state->{line}} == 2 && $parse_state->{line}[1] eq "(!kw")
				{
					$name = substr($parse_state->{line}[2], 1, length($parse_state->{line}[2]) - 3);
					if (substr($name, 0, 1) eq "/")
					{
						$name = substr($name, 1);
					}
					$input_file->{command} = $name;
					$input_file->{command_type} = "N";
				} elsif ($#{$parse_state->{line}} == 3 && $parse_state->{line}[1] eq "(!kw" && $parse_state->{line}[3] eq "])")
				{
					$name = substr($parse_state->{line}[2], 1, length($parse_state->{line}[2]) - 1);
					if (substr($name, 0, 1) eq "/")
					{
						$name = substr($name, 1);
					}
					$input_file->{command} = $name;
					$input_file->{command_type} = "N";
				} elsif ($#{$parse_state->{line}} == 3 && $parse_state->{line}[1] eq "(!kw" && $parse_state->{line}[3] eq "[~!]])")
				{
					$name = substr($parse_state->{line}[2], 1, length($parse_state->{line}[2]) - 1) . "[ ]";
					if (substr($name, 0, 1) eq "/")
					{
						$name = substr($name, 1);
					}
					$input_file->{command} = $name;
					$input_file->{command_type} = "N";
				} else
				{
					printf STDERR "%s: unknown command %s (%s)\n", $input_file->{filename}, $_, $#{$parse_state->{line}};
					$status = 2;
				}
				if ($input_file->{sort} eq "")
				{
					$input_file->{sort} = uc(substr($input_file->{command}, 0, 1));
					if ($input_file->{sort} eq "=")
					{
						$input_file->{sort} = uc(substr($input_file->{command}, 1, 1));
					}
					$input_file->{sort} = "*" unless $input_file->{sort} =~ /[A-Z]/;
				}
				printf STDERR "%s: command_type=%s, command=%s, sort=%s\n", $input_file->{filename}, $input_file->{command_type}, $input_file->{command}, $input_file->{sort} if ( $opt{debug} );
				
				$parse_state->{in_node} = 1;
			} elsif ($#line >= 0 && $parse_state->{line}[0] eq "!begin_xlist" && $parse_state->{in_example} < 2)
			{
				if ($xlist_level > 0)
				{
					$res = add_input_line($parse_state, $input_file, $input_line);
					$status = $res if $res > $status;
				}
				++$xlist_level;
			} elsif ($#line >= 0 && $parse_state->{line}[0] eq "!end_xlist" && $parse_state->{in_example} < 2)
			{
				if ($xlist_level == 0)
				{
					printf STDERR "%s: unexpected end_xlist in line %d\n", $input_file->{filename}, $parse_state->{lineno};
					$status = 2;
				} else
				{
					--$xlist_level;
					if ($xlist_level == 0)
					{
						$parse_state->{in_description} = 0;
						$parse_state->{in_example} = 0;
						$parse_state->{in_xref} = 0;
					}
				}
				if ($xlist_level > 0)
				{
					$res = add_input_line($parse_state, $input_file, $input_line);
					$status = $res if $res > $status;
				}
			} elsif ($#line >= 0 && $parse_state->{line}[0] eq "!begin_description" && $parse_state->{in_example} < 2)
			{
				if ($xlist_level > 0)
				{
					$res = add_input_line($parse_state, $input_file, $input_line);
					$status = $res if $res > $status;
				}
				++$description_level;
			} elsif ($#line >= 0 && $parse_state->{line}[0] eq "!end_description" && $parse_state->{in_example} < 2)
			{
				if ($description_level == 0)
				{
					printf STDERR "%s: unexpected end_description in line %d\n", $input_file->{filename}, $parse_state->{lineno};
					$status = 2;
				} else
				{
					--$description_level;
				}
				if ($xlist_level > 0)
				{
					$res = add_input_line($parse_state, $input_file, $input_line);
					$status = $res if $res > $status;
				}
			} elsif ($#line >= 0 && $parse_state->{line}[0] eq "!begin_blist" && $parse_state->{in_example} < 2)
			{
				if ($xlist_level > 0)
				{
					$res = add_input_line($parse_state, $input_file, $input_line);
					$status = $res if $res > $status;
				}
				++$blist_level;
			} elsif ($#line >= 0 && $parse_state->{line}[0] eq "!end_blist" && $parse_state->{in_example} < 2)
			{
				if ($blist_level == 0)
				{
					printf STDERR "%s: unexpected end_blist in line %d\n", $input_file->{filename}, $parse_state->{lineno};
					$status = 2;
				} else
				{
					--$blist_level;
				}
				if ($xlist_level > 0)
				{
					$res = add_input_line($parse_state, $input_file, $input_line);
					$status = $res if $res > $status;
				}
			} elsif ($#line >= 0 && $parse_state->{line}[0] eq "!begin_itemize" && $parse_state->{in_example} < 2)
			{
				if ($xlist_level > 0)
				{
					$res = add_input_line($parse_state, $input_file, $input_line);
					$status = $res if $res > $status;
				}
				++$itemize_level;
			} elsif ($#line >= 0 && $parse_state->{line}[0] eq "!end_itemize" && $parse_state->{in_example} < 2)
			{
				if ($itemize_level == 0)
				{
					printf STDERR "%s: unexpected end_itemize in line %d\n", $input_file->{filename}, $parse_state->{lineno};
					$status = 2;
				} else
				{
					--$itemize_level;
				}
				if ($xlist_level > 0)
				{
					$res = add_input_line($parse_state, $input_file, $input_line);
					$status = $res if $res > $status;
				}
			} elsif ($#line >= 0 && $parse_state->{line}[0] eq "!ifdest" && $parse_state->{in_example} < 2)
			{
				if ($xlist_level > 0)
				{
					$res = add_input_line($parse_state, $input_file, $input_line);
					$status = $res if $res > $status;
				} elsif ($input_file->{num_description} == 0)
				{
					$input_file->{num_header}++;
					$input_file->{header}[$input_file->{num_header}] = ltrim($_);
					printf STDERR "%s: header[%s]=%s\n", $input_file->{filename}, $input_file->{num_header}, $input_file->{header}[$input_file->{num_header}] if $opt{debug};
				} else
				{
					$parse_state->{in_example} = 2;
					$res = add_input_line($parse_state, $input_file, $input_line);
					$status = $res if $res > $status;
				}
				++$if_level;
			} elsif ($#line >= 0 && $parse_state->{line}[0] eq "!ifndest" && $parse_state->{in_example} < 2)
			{
				if ($xlist_level > 0)
				{
					$res = add_input_line($parse_state, $input_file, $input_line);
					$status = $res if $res > $status;
				}
				++$if_level;
			} elsif ($#line >= 0 && $parse_state->{line}[0] eq "!ifnset" && $parse_state->{in_example} < 2)
			{
				if ($parse_state->{line}[1] eq "NoOldKeywords")
				{
					$input_file->{existed_until} = 1;
				} else
				{
					if ($xlist_level > 0)
					{
						$res = add_input_line($parse_state, $input_file, $input_line);
						$status = $res if $res > $status;
					}
				}
				++$if_level;
			} elsif ($#line >= 0 && $parse_state->{line}[0] eq "!endif" && $parse_state->{in_example} < 2)
			{
				if ($if_level == 0)
				{
					printf STDERR "%s: unexpected endif in line %d\n", $input_file->{filename}, $parse_state->{lineno};
					$status = 2;
				} else
				{
					--$if_level;
				}
				if ($xlist_level > 0)
				{
					$res = add_input_line($parse_state, $input_file, $input_line);
					$status = $res if $res > $status;
				} elsif ($input_file->{existed_until} == 0)
				{
					$input_file->{num_header}++;
					$input_file->{header}[$input_file->{num_header}] = ltrim($_);
					printf STDERR "%s: header[%s]=%s\n", $input_file->{filename}, $input_file->{num_header}, $input_file->{header}[$input_file->{num_header}] if $opt{debug};
				}
			} elsif ($#line >= 0 && $parse_state->{line}[0] eq "!item")
			{
				if ($xlist_level > 0)
				{
					if ($xlist_level == 1 && $description_level == 0 && $itemize_level == 0 && $blist_level == 0)
					{
						my $pos1 = index($_, "[");
						my $pos2 = index($_, "]");
						if ($pos1 < 0 || $pos2 < 0)
						{
							printf STDERR "%s: invalid item in line %d\n", $input_file->{filename}, $parse_state->{lineno};
							$status = 2;
						} else
						{
							my $item;
							my $release;
							
							$item = substr($_, $pos1, $pos2 - $pos1 + 1);
							if (defined $items{$language}{"type_position"}{$item})
							{
								$input_file->{type} = ltrim(substr($_, $pos2 + 1));
								$pos2 = index($input_file->{type}, ",");
								if ($pos2 < 0)
								{
									printf STDERR "%s: invalid type item %s in line %d\n", $input_file->{filename}, $input_file->{type}, $parse_state->{lineno};
									$status = 2;
								} else
								{
									$input_file->{position} = ltrim(substr($input_file->{type}, $pos2 + 1));
									$input_file->{type} = substr($input_file->{type}, 0, $pos2);
									if (defined $items{$language}{"type"}{$input_file->{type}})
									{
										$input_file->{type} = $items{$language}{"type"}{$input_file->{type}};
									} else
									{
										printf STDERR "%s: unknown type %s\n", $input_file->{filename}, $input_file->{type};
										$status = 2;
									}
									if (defined $items{$language}{"position"}{$input_file->{position}})
									{
										$input_file->{position} = $items{$language}{"position"}{$input_file->{position}};
									} else
									{
										printf STDERR "%s: unknown position '%s'\n", $input_file->{filename}, $input_file->{position};
										$status = 2;
									}
									printf STDERR "%s: type=%s position=%s\n", $input_file->{filename}, $input_file->{type}, $input_file->{position} if $opt{debug};
								}
							} elsif (defined $items{$language}{"syntax"}{$item})
							{
								$input_file->{syntax} = ltrim(substr($_, $pos2 + 1));
								if (substr($input_file->{syntax}, 0, 4) eq "(!T)")
								{
									if (substr($input_file->{syntax}, length($input_file->{syntax}) - 4) ne "(!t)")
									{
										printf STDERR "%s: inconsistent syntax item in line %d\n", $input_file->{filename}, $parse_state->{lineno};
										$status = 2;
									} else
									{
										$input_file->{syntax} = substr($input_file->{syntax}, 4, length($input_file->{syntax}) - 8);
										printf STDERR "%s: syntax=%s\n", $input_file->{filename}, $input_file->{syntax} if $opt{debug};
									}
								}
							} elsif (defined $items{$language}{"description"}{$item})
							{
								$parse_state->{in_description} = 1;
								$parse_state->{in_example} = 0;
								$parse_state->{in_xref} = 0;
							} elsif (defined $items{$language}{"example"}{$item})
							{
								$parse_state->{in_description} = 0;
								$parse_state->{in_example} = 1;
								$parse_state->{in_xref} = 0;
							} elsif (defined $items{$language}{"seealso"}{$item})
							{
								$parse_state->{in_description} = 0;
								$parse_state->{in_example} = 0;
								$parse_state->{in_xref} = 1;
							} elsif (defined $items{$language}{"existed_until"}{$item})
							{
								$release = ltrim(substr($_, $pos2 + 1));
								if (defined($vers{$release}))
								{
									$input_file->{existed_until} = $vers{$release};
									printf STDERR "%s: existed_until=%s\n", $input_file->{filename}, $input_file->{existed_until} if $opt{debug};
								} else
								{
									printf STDERR "%s: unknown release '%s' in line %d\n", $input_file->{filename}, $release, $parse_state->{lineno};
									$status = 2;
								}
								$parse_state->{in_description} = 0;
								$parse_state->{in_example} = 0;
								$parse_state->{in_xref} = 0;
							} elsif (defined $items{$language}{"exists_since"}{$item})
							{
								$release = ltrim(substr($_, $pos2 + 1));
								if (defined($vers{$release}))
								{
									$input_file->{exists_since} = $vers{$release};
									printf STDERR "%s: exists_since=%s\n", $input_file->{filename}, $input_file->{exists_since} if $opt{debug};
								} else
								{
									printf STDERR "%s: unknown release '%s' in line %d\n", $input_file->{filename}, $release, $parse_state->{lineno};
									$status = 2;
								}
								$parse_state->{in_description} = 0;
								$parse_state->{in_example} = 0;
								$parse_state->{in_xref} = 0;
							} else
							{
								printf STDERR "%s: unknown item %s in line %d\n", $input_file->{filename}, $item, $parse_state->{lineno};
								$status = 2;
							}
						}
					} else
					{
						$res = add_input_line($parse_state, $input_file, $input_line);
						$status = $res if $res > $status;
					}
				} elsif ($parse_state->{in_example} >= 2)
				{
					$res = add_input_line($parse_state, $input_file, $input_line);
					$status = $res if $res > $status;
				} else
				{
					printf STDERR "%s: item outside xlist in line %d\n", $input_file->{filename}, $parse_state->{lineno};
					$status = 2;
				}
			} elsif ($#line >= 0 && $parse_state->{line}[0] eq "!end_node" && $parse_state->{in_example} < 2)
			{
				if ($parse_state->{in_node} == 1)
				{
					$parse_state->{in_node} = 2;
				}
			} else
			{
				if ($parse_state->{in_node} == 1 && $xlist_level == 0)
				{
					if ($#line >= 0)
					{
						if (defined($items{$language}{"example_end"}{$line[0]}))
						{
							$res = add_input_line($parse_state, $input_file, $input_line);
							$status = $res if $res > $status;
							if ($if_level == 0)
							{
								$parse_state->{in_example} = 0;
							}
						} elsif ($#line >= 0 && $parse_state->{line}[0] eq "!ifdest" && $parse_state->{in_example} >= 2)
						{
							$res = add_input_line($parse_state, $input_file, $input_line);
							$status = $res if $res > $status;
							++$if_level;
						} elsif ($#line >= 0 && $parse_state->{line}[0] eq "!ifndest" && $parse_state->{in_example} >= 2)
						{
							$res = add_input_line($parse_state, $input_file, $input_line);
							$status = $res if $res > $status;
							++$if_level;
						} elsif ($#line >= 0 && $parse_state->{line}[0] eq "!iflang" && $parse_state->{in_example} >= 2)
						{
							$res = add_input_line($parse_state, $input_file, $input_line);
							$status = $res if $res > $status;
							++$if_level;
						} elsif ($#line >= 0 && $parse_state->{line}[0] eq "!ifnlang" && $parse_state->{in_example} >= 2)
						{
							$res = add_input_line($parse_state, $input_file, $input_line);
							$status = $res if $res > $status;
							++$if_level;
						} elsif ($#line >= 0 && $parse_state->{line}[0] eq "!ifos" && $parse_state->{in_example} >= 2)
						{
							$res = add_input_line($parse_state, $input_file, $input_line);
							$status = $res if $res > $status;
							++$if_level;
						} elsif ($#line >= 0 && $parse_state->{line}[0] eq "!ifnos" && $parse_state->{in_example} >= 2)
						{
							$res = add_input_line($parse_state, $input_file, $input_line);
							$status = $res if $res > $status;
							++$if_level;
						} elsif ($#line >= 0 && $parse_state->{line}[0] eq "!ifset" && $parse_state->{in_example} >= 2)
						{
							$res = add_input_line($parse_state, $input_file, $input_line);
							$status = $res if $res > $status;
							++$if_level;
						} elsif ($#line >= 0 && $parse_state->{line}[0] eq "!ifnset" && $parse_state->{in_example} >= 2)
						{
							$res = add_input_line($parse_state, $input_file, $input_line);
							$status = $res if $res > $status;
							++$if_level;
						} elsif ($#line >= 0 && $parse_state->{line}[0] eq "!if" && $parse_state->{in_example} >= 2)
						{
							$res = add_input_line($parse_state, $input_file, $input_line);
							$status = $res if $res > $status;
							++$if_level;
						} elsif ($parse_state->{line}[0] eq "!endif" && $parse_state->{in_example} >= 2)
						{
							if ($if_level == 0)
							{
								printf STDERR "%s: unexpected endif in line %d\n", $input_file->{filename}, $parse_state->{lineno};
								$status = 2;
							} else
							{
								--$if_level;
							}
							$res = add_input_line($parse_state, $input_file, $input_line);
							$status = $res if $res > $status;
							if ($if_level == 0 && $parse_state->{in_example} == 3)
							{
								$parse_state->{in_example} = 0;
							}
						} elsif ($parse_state->{in_example} >= 2)
						{
							if (defined($items{$language}{"example"}{$line[0]}) && $if_level > 0)
							{
								$parse_state->{in_example} = 3;
							}
							$res = add_input_line($parse_state, $input_file, $input_line);
							$status = $res if $res > $status;
						} elsif (defined($items{$language}{"example"}{$line[0]}))
						{
							if ($if_level > 0)
							{
								$parse_state->{in_example} = 3;
							} else
							{
								$parse_state->{in_example} = 2;
							}
							if ($input_file->{num_example} > 0)
							{
								add_input_line($parse_state, $input_file, "");
							}
							$res = add_input_line($parse_state, $input_file, $input_line);
							$status = $res if $res > $status;
						} elsif ($line[0] eq "!label")
						{
							$input_file->{num_label}++;
							$input_file->{label}[$input_file->{num_label}] = ltrim(substr($_, 7));
							printf STDERR "%s: label[%s]=%s\n", $input_file->{filename}, $input_file->{num_label}, $input_file->{label}[$input_file->{num_label}] if $opt{debug};
						} elsif ($#line >= 1 && $line[0] eq "!html_name")
						{
							$input_file->{html_name} = $parse_state->{line}[1];
						} elsif ($line[0] eq "!alias")
						{
							$input_file->{num_header}++;
							$input_file->{header}[$input_file->{num_header}] = ltrim($_);
							printf STDERR "%s: header[%s]=%s\n", $input_file->{filename}, $input_file->{num_header}, $input_file->{header}[$input_file->{num_header}] if $opt{debug};
						} else
						{
							if ($input_file->{short_description} ne "")
							{
								printf STDERR "%s: more than one line of short_description in line %d\n", $input_file->{filename}, $parse_state->{lineno};
								$status = 2;
							} else
							{
								$input_file->{short_description} = $_;
								printf STDERR "%s: short_description=%s\n", $input_file->{filename}, $input_file->{short_description} if $opt{debug};
							}
						}
					} elsif ($parse_state->{in_example} >= 2)
					{
						$res = add_input_line($parse_state, $input_file, $input_line);
						$status = $res if $res > $status;
					}
				} else
				{
					$res = add_input_line($parse_state, $input_file, $input_line);
					$status = $res if $res > $status;
				}
			}
		}
		close(INFILE);
		
		
		while ($input_file->{num_description} > 0 && $input_file->{description}[$input_file->{num_description}] eq "")
		{
			pop @{$input_file->{description}};
			--$input_file->{num_description};
		}
		while ($input_file->{num_example} > 0 && $input_file->{example}[$input_file->{num_example}] eq "")
		{
			pop @{$input_file->{example}};
			--$input_file->{num_example};
		}
	
		if ($status < 2 && $parse_state->{in_node} != 2)
		{
			printf STDERR "%s: no command found\n", $input_file->{filename};
			$status = 2;
		}
		if ($status < 2 && ($input_file->{type} eq "" || $input_file->{position} eq ""))
		{
			printf STDERR "%s: no type/position found\n", $input_file->{filename};
			$status = 2;
		}
		if ($status < 2 && $input_file->{syntax} eq "")
		{
			printf STDERR "%s: no syntax description found\n", $input_file->{filename};
			$status = 2;
		}
		if ($status < 2 && $input_file->{num_description} == 0)
		{
			printf STDERR "%s: no description found\n", $input_file->{filename};
			$status = 2;
		}
		if ($input_file->{short_description} eq "")
		{
			printf STDERR "%s: warning: no short description found\n", $input_file->{filename};
			$status = 1 if ($status < 1);
		}
		
		if ($input_file->{html_name} eq "")
		{
			$base_name = basename($input_file->{filename}, ".ui");
			if ($input_file->{command_type} eq "S")
			{
				$input_file->{html_name} = "cmd_" . $base_name . ".html";
			} elsif ($input_file->{command_type} eq "D")
			{
				$input_file->{html_name} = "cmd_" . $input_file->{command} . "().html";
			} elsif ($input_file->{command_type} eq "B")
			{
				$input_file->{html_name} = "cmd_" . $input_file->{command} . "().html";
			} elsif ($input_file->{command_type} eq "1")
			{
				$input_file->{html_name} = "cmd_" . $base_name . ".html";
			} elsif ($input_file->{command_type} eq "Q")
			{
				$input_file->{html_name} = "cmd_" . $base_name . ".html";
			} else # ($input_file->{command_type} eq "N")
			{
				if (substr($input_file->{command}, 0, 1) eq "=")
				{
					$input_file->{html_name} = "cmd_" . substr($input_file->{command}, 1) . "-eq.html";
				} else
				{
					$input_file->{html_name} = "cmd_" . $input_file->{command} . ".html";
				}
			}
		}
	}
	return $status;
}


sub add_input_line($$)
{
	my ($parse_state, $input_file, $input_line) = @_;
	my @xref;
	my $ref;
	my $xref_type;
	my $pos1;
	my $pos2;
	my $txt;
	my $status;
	my $target;
	
	$status = 0;
	if ($parse_state->{in_description})
	{
		++$input_file->{num_description};
		$input_file->{description}[$input_file->{num_description}] = $input_line;
		printf STDERR "%s: description[%s]=%s\n", $parse_state->{filename}, $input_file->{num_description}, $input_file->{description}[$input_file->{num_description}] if $opt{debug};
	} elsif ($parse_state->{in_example})
	{
		++$input_file->{num_example};
		$input_file->{example}[$input_file->{num_example}] = $input_line;
		printf STDERR "%s: example%d[%d]=%s\n", $parse_state->{filename}, $parse_state->{in_example}, $input_file->{num_example}, $input_file->{example}[$input_file->{num_example}] if $opt{debug};
	} elsif ($parse_state->{in_xref})
	{
		if ($input_line ne "")
		{
			@xref = split(', ');
			foreach $ref (@xref)
			{
				$xref_type = "";
				$txt = "";
				$target = "";
				
				if (substr($ref, 0, 6) eq "(!link")
				{
					$pos1 = index($ref, '[');
					if ($pos1 > 0)
					{
						$pos2 = index($ref, ']', $pos1 + 1);
						if ($pos2 > $pos1)
						{
							$txt = substr($ref, $pos1 + 1, $pos2 - $pos1 - 1);
							$xref_type = "L";
							$pos1 = index($ref, '[', $pos2 + 1);
							if ($pos1 > 0)
							{
								$pos2 = index($ref, ']', $pos1 + 1);
								my $txt2 = substr($ref, $pos1 + 1, $pos2 - $pos1 - 1);
								if ($txt ne $txt2)
								{
									$xref_type = "A";
									$target = $txt;
									$txt = $txt2;
								}
							}
						}
					}
				} elsif (substr($ref, 0, 5) eq "(!KKW")
				{
					$pos1 = index($ref, '[');
					if ($pos1 > 0)
					{
						$pos2 = index($ref, ']');
						if ($pos2 > $pos1)
						{
							$txt = substr($ref, $pos1 + 1, $pos2 - $pos1 - 1);
							$xref_type = "B";
						}
					}
				} elsif (substr($ref, 0, 6) eq "(!KKKW")
				{
					$pos1 = index($ref, '[');
					if ($pos1 > 0)
					{
						$pos2 = index($ref, ']');
						if ($pos2 > $pos1)
						{
							$txt = substr($ref, $pos1 + 1, $pos2 - $pos1 - 1);
							$xref_type = "D";
						}
					}
				} elsif (substr($ref, 0, 4) eq "(!KW")
				{
					$pos1 = index($ref, '[');
					if ($pos1 > 0)
					{
						$pos2 = index($ref, ']');
						if ($pos2 > $pos1)
						{
							$txt = substr($ref, $pos1 + 1, $pos2 - $pos1 - 1);
							$xref_type = 'N';
							if (substr($ref, $pos2 + 1) eq " [[~!!]])")
							{
								$txt .= "[ ]";
							}
						}
					}
				} elsif (substr($ref, 0, 4) eq "(!K1")
				{
					$pos1 = index($ref, '[');
					if ($pos1 > 0)
					{
						$pos2 = index($ref, ']');
						if ($pos2 > $pos1)
						{
							$txt = substr($ref, $pos1 + 1, $pos2 - $pos1 - 1);
							if (substr($txt, 0, 1) eq "/")
							{
								$txt = substr($txt, 1);
							}
							$xref_type = "1";
						}
					}
				}
				if ($xref_type eq "")
				{
					printf STDERR "%s: unknown cross reference in line %d\n", $parse_state->{filename}, $parse_state->{lineno};
					$status = 2;
				} else
				{
					++$input_file->{num_xref};
					$input_file->{xref}[$input_file->{num_xref}]{xref_type} = $xref_type;
					$input_file->{xref}[$input_file->{num_xref}]{xref} = $txt;
					$input_file->{xref}[$input_file->{num_xref}]{target} = $target;
					undef $input_file->{xref}[$input_file->{num_xref}]{xref_to};
				}
			}
			printf STDERR "%s: xref[%d]=%s, %s\n",
				$parse_state->{filename},
				$input_file->{num_xref},
				$input_file->{xref}[$input_file->{num_xref}]{xref_type},
				$input_file->{xref}[$input_file->{num_xref}]{xref} if $opt{debug};
		}
	} else
	{
		if ($input_line ne "")
		{
			printf STDERR "%s: warning: unhandled line %d\n", $parse_state->{filename}, $parse_state->{lineno};
			$status = 1;
		}
	}
	return $status;
}


sub ltrim($)
{
	my ($str) = @_;
	
	($str) = ($str =~ /^\s*(.*)/);
	return $str;
}


sub fetchrow($)
{
	my ($stmt) = @_;
	my $sth;
	my @row;
	
	$sth = $dbh->prepare($stmt) || die $dbh->errstr;
	$sth->execute || die $dbh->errstr;
	@row = $sth->fetchrow_array();
	$sth->finish;
	printf STDERR "%s: %s\n", $stmt, join(', ', @row) if ($opt{debug});
	return @row;
}


sub usage()
{
    die $USAGE;
}




sub read_my_cnf()
{
	my $OS;
	
	$OS = get_os();
	open(TMP, $ENV{'HOME'} . "/.my.cnf") || return 1;
	while (<TMP>)
	{
		if (/^\[(client|perl)\]/i)
		{
			while ((defined($_=<TMP>)) && !/^\[\w+\]/)
			{
				if (/^host\s*=\s*(\S+)/i)
				{
					$opt{host} = $1;
				}
				elsif (/^user\s*=\s*(\S+)/i)
				{
					$opt{user} = $1;
				}
				elsif (/^password\s*=\s*(\S+)/i)
				{
					$opt{password} = $1;
				}
				elsif (/^port\s*=\s*(\S+)/i)
				{
					$opt{port} = $1;
				}
				elsif (/^socket\s*=\s*(\S+)/i)
				{
					$opt{socket} = $1;
				}
			}
		}
	}
	close(TMP);
	return 0;
}


sub drop_tables()
{
	eval {
		drop_table("LANG");
		drop_table("VERS");
		drop_table("POS");
		drop_table("TYPE");
		drop_table("XREF_TYPE");
		drop_table("LABEL");
		drop_table("HEADER");
		drop_table("SYNTAX");
		drop_table("DESCRIPTION");
		drop_table("XREF");
		drop_table("EXAMPLE");
		drop_table("COMMAND_TYPE");
		drop_table("COMMAND");
	};
	return 0;
}


sub drop_table($)
{
	my ($table_name) = @_;
	
	eval {
		do_command(sprintf($dbd{$opt{dbd}}{drop_table}, $table_name));
	};
}



sub do_command($)
{
	my ($command) = @_;
	
	if ($opt{printout})
	{
		printf "%s\n", $command;
	}
	if ($opt{execute})
	{
		$dbh->do($command) || die "$command\n" . $dbh->errstr;
	}
}


sub row_exists($)
{
	my ($stmt) = @_;
	my $sth;
	my @row;
	
	$sth = $dbh->prepare($stmt) || die $dbh->errstr;
	$sth->execute || die $dbh->errstr;
	@row = $sth->fetchrow_array();
	$sth->finish;

	return $#row >= 0;
}


# FIGURE OUT THE OS WE'RE RUNNING UNDER
# Some systems support the $^O variable.  If not
# available then require() the Config library
sub get_os()
{
	my $OS;
	
    unless ($OS = $^O) {
		require Config;
		$OS = $Config::Config{'osname'};
		$OS = $Config::Config{'osname'}; # suppress warning about being used only once
	}
	if ($OS =~ /^MSWin/i)
	{
		$OS = 'WINDOWS';
	} elsif ($OS =~ /^VMS/i)
	{
		$OS = 'VMS';
	} elsif ($OS =~ /^dos/i)
	{
		$OS = 'DOS';
	} elsif ($OS =~ /^MacOS/i)
	{
		$OS = 'MACINTOSH';
	} elsif ($OS =~ /^os2/i)
	{
	    $OS = 'OS2';
	} elsif ($OS =~ /^epoc/i)
	{
		$OS = 'EPOC';
	} else
	{
		$OS = 'UNIX';
	}
	return $OS;
}


sub dbh_connect()
{
	my $dbh;
	my $hostname = "";

	if ($opt{host} eq '')
	{
		$hostname = "localhost";
	} else
	{
		$hostname = $opt{host};
	}
	my $dsn = ";host=$hostname";
	$dsn .= ";port=$opt{port}" if $opt{port};
	$dsn .= ";mysql_socket=$opt{socket}" if $opt{socket};

	$dbh = DBI->connect("DBI:$opt{dbd}:database=$opt{database};$dsn", $opt{user}, $opt{password}, {PrintError => 0, mysql_enable_utf8 => 1}) || die $DBI::errstr;
	return $dbh;
}


sub commit()
{
	do_command("COMMIT;");
}


1;

__END__
