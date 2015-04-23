.**********************************************************
.*
.* NewView Rendering Tests
.*
.* RBRi 2006-2008
.*
.**********************************************************
.*
:userdoc.
:docprof toc=123 ctrlarea=none.
:title.NewView Rendering Tests
.*
.*
.**********************************************************
:h1.Overview
:p.This is a test document for NewView. Every page contains
some samples/tests for a specific problem
.*
.*
.**********************************************************
:h1.Tests
:p.Tests
.*
.*
.**********************************************************
:h2 id=1234.TestTopic
:p.Page: TestTopic
.*
.*
.**********************************************************
:h2 id=1235 global.Global TestTopic
:p.Page: Global TestTopic
.*
.*
.**********************************************************
:h2.Italic text
:p.
This page contains various samples to sort out problems with
highlighted (italic) text.
:lm margin=4.
:p.
The space between the highlighted word and the next one is to short.
.br
:lm margin=10.Normal text :hp1.highlighted:ehp1. and again normal.
.br
:hp6.Max speed :ehp6.turns (there is a space between speed and turns)
.*
:lm margin=4.
:p.
Some samples for display problems when a short normal character follows
a highlighted one
.br
:lm margin=10.Normal text :hp1.Hint:ehp1.&colon. and again normal (colon is normal).
.br
Normal text :hp1.MLE:ehp1.. and again normal (dot is normal)
.*
.*
.**********************************************************
:h2.Spacing with an non proportional font
Spacing with an non proportional font
:font facename=Courier size=13x8.
.*
:lm margin=4.
:p.
The space between the highlighted word and the next one is to short.
.br
:lm margin=10.Normal text :hp1.highlighted:ehp1. and again normal.
.br
:hp6.Max speed :ehp6.turns (there is a space between speed and turns)
.*
:lm margin=4.
:p.
Some samples for display problems when a short normal character follows
a highlighted one
.br
:lm margin=10.Normal text :hp1.Hint:ehp1.&colon. and again normal (colon is normal).
.br
Normal text :hp1.MLE:ehp1.. and again normal (dot is normal)
.*
:font facename=default size=0x0.
:lm margin=1.
:p.
Character graphic
:lm margin=4.
:cgraphic.
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³:hp1.File:ehp1.   Edit  ³ View ³ Options   Help ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÙ
              ³ All                ³
              ³ Some . . .         ³
              ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
              ³ By . . .           ³
              ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
:ecgraphic.
.*
.*
.**********************************************************
:h2.Blank at the beginning
:artwork name='fm3.bmp' align=center.
There is a blank at the begining of the first line after an artwork.
.br
Normal beginning....
.*
.*
.**********************************************************
:h2.Blank at the beginning (II)

There is a blank at the begining if in the source is an empty line after the heading.
.br
Normal beginning....
.*
.*
.**********************************************************
:h2.Problem with underscores in search string

Please search with the sting 'test_' and select this topic form the list of founded pages.
.br
Then have a look at the selections...
:p.
normal test_ blahblah
:p.
something different _ with an underscore
:p.
something with error in this line
.*
.*
.**********************************************************
:h2.Text Color
:p.The color handling is separated from the text formating.
The color shoud not stop after a formating like 'highlighted'
ends.
:p.
Normal text :hp1.highlighted:ehp1. and again normal.
.br
:color fc=red.
Normal red text :hp1.highlighted:ehp1. and again normal.
.br
Color only stops if :color fc=green. another colors starts or
:h3.heading follows
with new text
.*
.*
.**********************************************************
:h2.Text Color II
:p.Now text with a :color fc=default bc=palegray.F1:color fc=default bc=default.
 and the rest of the sentence.
.*
.*
.**********************************************************
:h2.Text For"mating
:p.
Test
.*
.*
.**********************************************************
:h2.Link Tests
:p.
Link Tests
.*
.*
.**********************************************************
:h3.Link type 'hd'
:p.This type links to some heading.
:ol.
:li.
:link reftype=hd.
&colon.link reftype=hd.
:elink.
.br
(emty link definition test)
.br
this is not clickable
:li.
:link reftype=hd refid='1234'.
&colon.link reftype=hd refid='1234'.
.br
(internal link to our TestTopic)
:elink.
:li.
:link reftype=hd database=rendering.
&colon.link reftype=hd database=rendering.
:elink.
.br
(external link without refid test)
.br
this is not clickable
:li.:link reftype=hd refid='1234' database=rendering.
&colon.link reftype=hd refid='1234' database=rendering.
:elink.
.br
:link reftype=hd refid='1234' database='rendering.hlp'.
&colon.link reftype=hd refid='1234' database='rendering.hlp'.
:elink.
.br
(external link to our TestTopic)
.br
This is not working because the topic is not global

:li.
:link reftype=hd refid='1235' database=rendering.
&colon.link reftype=hd refid='1235' database=rendering.
:elink.
.br
:link reftype=hd refid='1235' database='rendering.hlp'.
&colon.link reftype=hd refid='1235' database='rendering.hlp'.
:elink.
.br
(external link to our Global TestTopic)
:li.
:link reftype=hd refid='1234' database=test_topics.
&colon.link reftype=hd refid='1234' database=test_topics.
:elink.
.br
:link reftype=hd refid='1234' database='test_topics.hlp'.
&colon.link reftype=hd refid='1234' database='test_topics.hlp'.
:elink.
.br
(external link to the TestTopic in file test_topics.hlp).
.br
This is not working because the topic is not global
:li.
:link reftype=hd refid='1235' database=test_topics.
&colon.link reftype=hd refid='1235' database=test_topics.
:elink.
.br
:link reftype=hd refid='1235' database='test_topics.hlp'.
&colon.link reftype=hd refid='1235' database='test_topics.hlp'.
:elink.
.br
(external link to the TestTopic in file test_topics.hlp).
:eol.
.*
.*
.**********************************************************
:h3.Link type 'fn'
:p.This type links to some footnote.
.*
:fn id=testfn.
This is a test footnote.
:efn.
.*
:ol.
:li.:link reftype=fn refid='testfn'.
&colon.link reftype=fn refid='testfn'.
.br
Internal link to our TestFootnote
:elink.
:li.:link reftype=fn refid='testfn' database=test_topics.
&colon.link reftype=fn refid='testfn' database=test_topics.
.br
Internal link to our TestFootnote in file test_topics.hlp.
The database is ignored by view and newview.
:elink.
:eol.
.*
.*
.**********************************************************
:h3.Link type 'launch'
:p.This kind of links are used to start an external program.
There are serveral test to launch view.exe.
:ol.
:li.:link reftype=launch object='view.exe'.
&colon.link reftype=launch object='view.exe'.
.br
Start view.exe without params.
:elink.
:li.:link reftype=launch object='view.exe' data=''.
&colon.link reftype=launch object='view.exe' data=''. (possible but generates a compiler warning)
.br
Start view.exe without params.
:elink.
:li.:link reftype=launch object='view.exe' data='test_topics.hlp TestTopic'.
&colon.link reftype=launch object='view.exe' data='test_topics.hlp TestTopic'.
.br
Start view.exe with command line 'test_topics.hlp TestTopic'.
:elink.
:li.:link reftype=launch object='p:\newview_dev\test\rendering\dir with blank\e.exe' data='config.sys'.
&colon.link reftype=launch object='p&colon.\newview_dev\test\rendering\dir with blank\e.exe' data='config.sys'.
.br
NewView (and also the original view) is not able to handle the call of
executables with blanks in file/path name correct.
:elink.
:eol.
.*
.*
.**********************************************************
:h3.Link type 'url'
:p.This kind of links are used to start the default browser.
:ol.
:li.http&colon.&slash.&slash.www&per.rbri&per.org
.br
Plain url
:li.:link reftype=launch object='firefox.exe' data='http://www.rbri.org'.
&colon.link reftype=launch object='firefox.exe' data='http&colon.&slash.&slash.www&per.rbri&per.org'.
.br
Start firefox with url.
:elink.
:li.:link reftype=launch object='fireFOX.exe' data='http://www.rbri.org'.
&colon.link reftype=launch object='fireFOX.exe' data='http&colon.&slash.&slash.www&per.rbri&per.org'.
.br
Start firefox with url (detect must be case insensitive).
:elink.
:li.:link reftype=launch object='mozilla.exe' data='http://www.rbri.org'.
&colon.link reftype=launch object='mozilla.exe' data='http&colon.&slash.&slash.www&per.rbri&per.org'.
.br
Start mozilla with url.
:elink.
:li.:link reftype=launch object='netscape.exe' data='http://www.rbri.org'.
&colon.link reftype=launch object='netscape.exe' data='http&colon.&slash.&slash.www&per.rbri&per.org'.
.br
Start netscape with url.
:elink.
:li.:link reftype=launch object='explore.exe' data='http://www.rbri.org'.
&colon.link reftype=launch object='explore.exe' data='http&colon.&slash.&slash.www&per.rbri&per.org'.
.br
Start explore with url.
:elink.
:eol.
.*
:p.Different URL types.
:ol.
:li.http&colon.&slash.&slash.www&per.rbri&per.org; https&colon.&slash.&slash.www&per.rbri&per.org
.br
Start firefox with url.
:li.mailto&colon.rbri&atsign.rbri&per.de
.br
Start mail programm.
:li.news&colon.news.ecomstation.com
.br
Start mail programm.
:li.ftp&colon.&slash.&slash.ftp.netlabs.org/pub/
.br
Start ftp programm.
:eol.
.*
.*
.**********************************************************
:h2.Link type 'inform'
:p.Not supported by NewView at the moment.
.*
.*
.**********************************************************

.*
.*
.**********************************************************
:euserdoc.
.*
.**********************************************************
