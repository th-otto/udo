--
-- This script creates the database that is used
-- by the udosql.pl perl script
--
--
DROP TABLE IF EXISTS LANG;
DROP TABLE IF EXISTS VERS;
DROP TABLE IF EXISTS POS;
DROP TABLE IF EXISTS TYPE;
DROP TABLE IF EXISTS XREF_TYPE;
DROP TABLE IF EXISTS LABEL;
DROP TABLE IF EXISTS HEADER;
DROP TABLE IF EXISTS SYNTAX;
DROP TABLE IF EXISTS DESCRIPTION;
DROP TABLE IF EXISTS XREF;
DROP TABLE IF EXISTS EXAMPLE;
DROP TABLE IF EXISTS COMMAND_TYPE;
DROP TABLE IF EXISTS COMMAND;


CREATE TABLE LANG (
         LANG_ID SMALLINT NOT NULL /* AUTO_INCREMENT */,
	 NAME VARCHAR(10) BINARY NOT NULL,
         DIR CHAR(3) NOT NULL,
	 DESCRIPTION VARCHAR(80) BINARY NOT NULL,

	 CONSTRAINT PK_LANG PRIMARY KEY(LANG_ID),
	 CONSTRAINT UK_LANG_NAME UNIQUE(NAME),
         CONSTRAINT UK_LANG_DIR UNIQUE(DIR)
)
DEFAULT CHARACTER SET = utf8;

INSERT INTO LANG(LANG_ID, NAME, DIR, DESCRIPTION) VALUES (1, 'german',  'de', 'German');

INSERT INTO LANG(LANG_ID, NAME, DIR, DESCRIPTION) VALUES (2, 'english', 'en', 'English');

INSERT INTO LANG(LANG_ID, NAME, DIR, DESCRIPTION) VALUES (3, 'dutch',   'nl', 'Dutch');

INSERT INTO LANG(LANG_ID, NAME, DIR, DESCRIPTION) VALUES (4, 'french',  'fr', 'French');

INSERT INTO LANG(LANG_ID, NAME, DIR, DESCRIPTION) VALUES (5, 'italian', 'it', 'Italian');

INSERT INTO LANG(LANG_ID, NAME, DIR, DESCRIPTION) VALUES (6, 'spanish', 'es', 'Spanish');

INSERT INTO LANG(LANG_ID, NAME, DIR, DESCRIPTION) VALUES (7, 'swedish', 'sv', 'Swedish');

INSERT INTO LANG(LANG_ID, NAME, DIR, DESCRIPTION) VALUES (8, 'portuguese', 'pt', 'Portuguese');

INSERT INTO LANG(LANG_ID, NAME, DIR, DESCRIPTION) VALUES (9, 'danish', 'dk', 'Danish');

INSERT INTO LANG(LANG_ID, NAME, DIR, DESCRIPTION) VALUES (10, 'norwegian', 'no', 'Norwegian');

INSERT INTO LANG(LANG_ID, NAME, DIR, DESCRIPTION) VALUES (11, 'finnish', 'fi', 'Finnish');

INSERT INTO LANG(LANG_ID, NAME, DIR, DESCRIPTION) VALUES (12, 'czech', 'cs', 'Czech');

INSERT INTO LANG(LANG_ID, NAME, DIR, DESCRIPTION) VALUES (13, 'latvian', 'lv', 'Latvian');

INSERT INTO LANG(LANG_ID, NAME, DIR, DESCRIPTION) VALUES (14, 'polish', 'po', 'Polish');

INSERT INTO LANG(LANG_ID, NAME, DIR, DESCRIPTION) VALUES (15, 'japanese', 'ja', 'Japanese');

INSERT INTO LANG(LANG_ID, NAME, DIR, DESCRIPTION) VALUES (16, 'russian', 'ru', 'Russian');



CREATE TABLE VERS (
         VERS_ID SMALLINT NOT NULL /* AUTO_INCREMENT */,
         VERS VARCHAR(80) BINARY NOT NULL,
         OFFICIAL_RELEASE CHAR(1) BINARY NOT NULL,
         RELEASE_DATE DATE,

         CONSTRAINT PK_VERSION PRIMARY KEY(VERS_ID),
         CONSTRAINT UK_VERSION_VERS UNIQUE(VERS)
)
DEFAULT CHARACTER SET = utf8;



source versions.sql;



CREATE TABLE COMMAND_TYPE (
	COMMAND_TYPE CHAR(1) BINARY NOT NULL,
	DESCRIPTION VARCHAR(80) BINARY,

	CONSTRAINT PK_COMMAND_TYPE PRIMARY KEY(COMMAND_TYPE)
)
DEFAULT CHARACTER SET = utf8;

INSERT INTO COMMAND_TYPE (COMMAND_TYPE, DESCRIPTION) VALUES('S', 'special');

INSERT INTO COMMAND_TYPE (COMMAND_TYPE, DESCRIPTION) VALUES('D', 'dotted');

INSERT INTO COMMAND_TYPE (COMMAND_TYPE, DESCRIPTION) VALUES('B', 'bracketed');

INSERT INTO COMMAND_TYPE (COMMAND_TYPE, DESCRIPTION) VALUES('1', 'single char');

INSERT INTO COMMAND_TYPE (COMMAND_TYPE, DESCRIPTION) VALUES('Q', 'no quote');

INSERT INTO COMMAND_TYPE (COMMAND_TYPE, DESCRIPTION) VALUES('N', 'normal');



CREATE TABLE TYPE (
	TYPE CHAR(1) BINARY NOT NULL,
	LANG_ID SMALLINT NOT NULL,
	DESCRIPTION VARCHAR(80) BINARY,

	CONSTRAINT PK_TYPE PRIMARY KEY(TYPE, LANG_ID),
	CONSTRAINT FK_TYPE_LANG_ID FOREIGN KEY (LANG_ID)
	   REFERENCES LANG(LANG_ID)
)
DEFAULT CHARACTER SET = utf8;

INSERT INTO TYPE (TYPE, LANG_ID, DESCRIPTION) VALUES('S', 1, 'Sonderzeichen');

INSERT INTO TYPE (TYPE, LANG_ID, DESCRIPTION) VALUES('C', 1, 'Kommando');

INSERT INTO TYPE (TYPE, LANG_ID, DESCRIPTION) VALUES('A', 1, 'Kommando-Abk�rzung');

INSERT INTO TYPE (TYPE, LANG_ID, DESCRIPTION) VALUES('P', 1, 'Platzhalter');

INSERT INTO TYPE (TYPE, LANG_ID, DESCRIPTION) VALUES('W', 1, 'Schalter');

INSERT INTO TYPE (TYPE, LANG_ID, DESCRIPTION) VALUES('S', 2, 'special characters');

INSERT INTO TYPE (TYPE, LANG_ID, DESCRIPTION) VALUES('C', 2, 'command');

INSERT INTO TYPE (TYPE, LANG_ID, DESCRIPTION) VALUES('A', 2, 'command abbreviation');

INSERT INTO TYPE (TYPE, LANG_ID, DESCRIPTION) VALUES('P', 2, 'placeholder');

INSERT INTO TYPE (TYPE, LANG_ID, DESCRIPTION) VALUES('W', 2, 'switch');



CREATE TABLE POS (
	POS CHAR(1) BINARY NOT NULL,
	LANG_ID SMALLINT NOT NULL,
	DESCRIPTION VARCHAR(80) BINARY,

	CONSTRAINT PK_POS PRIMARY KEY(POS, LANG_ID),
	CONSTRAINT FK_POS_LANG_ID FOREIGN KEY (LANG_ID)
	   REFERENCES LANG(LANG_ID)
)
DEFAULT CHARACTER SET = utf8;

INSERT INTO POS (POS, LANG_ID, DESCRIPTION) VALUES('P', 1, 'Vorspann');

INSERT INTO POS (POS, LANG_ID, DESCRIPTION) VALUES('M', 1, 'Hauptteil');

INSERT INTO POS (POS, LANG_ID, DESCRIPTION) VALUES('B', 1, 'Vorspann & Hauptteil');

INSERT INTO POS (POS, LANG_ID, DESCRIPTION) VALUES('P', 2, 'preamble');

INSERT INTO POS (POS, LANG_ID, DESCRIPTION) VALUES('M', 2, 'main part');

INSERT INTO POS (POS, LANG_ID, DESCRIPTION) VALUES('B', 2, 'preamble & main part');




CREATE TABLE COMMAND (
        COMMAND_ID SMALLINT NOT NULL /* AUTO_INCREMENT */,
        COMMAND VARCHAR(30) BINARY NOT NULL,
	COMMAND_TYPE CHAR(1) BINARY NOT NULL,
	TYPE CHAR(1) BINARY NOT NULL,
	POS CHAR(1) BINARY NOT NULL,
        FILENAME VARCHAR(40) NOT NULL,
        EXISTS_SINCE SMALLINT NOT NULL,
        EXISTED_UNTIL SMALLINT NOT NULL,
        SORT CHAR(1) BINARY NOT NULL,
        HTML_FILENAME VARCHAR(40),

	CONSTRAINT PK_COMMAND PRIMARY KEY(COMMAND_ID),
	CONSTRAINT UK_COMMAND_ID UNIQUE(COMMAND_ID, COMMAND_TYPE),
        CONSTRAINT UK_COMMAND_FILENAME UNIQUE(FILENAME),
        CONSTRAINT UK_COMMAND_HTML_FILENAME UNIQUE(HTML_FILENAME),
        CONSTRAINT FK_COMMAND_EXISTS_SINCE FOREIGN KEY (EXISTS_SINCE)
           REFERENCES VERS(VERS_ID),
        CONSTRAINT FK_COMMAND_EXISTED_UNTIL FOREIGN KEY (EXISTED_UNTIL)
           REFERENCES VERS(VERS_ID),
        CONSTRAINT FK_COMMAND_COMMAND_TYPE FOREIGN KEY (COMMAND_TYPE)
           REFERENCES COMMAND_TYPE(COMMAND_TYPE),
        CONSTRAINT FK_COMMAND_TYPE FOREIGN KEY(TYPE)
           REFERENCES TYPE(TYPE),
        CONSTRAINT FK_COMMAND_POS FOREIGN KEY(POS)
           REFERENCES POS(POS)
)
DEFAULT CHARACTER SET = utf8;


CREATE TABLE SYNTAX (
        SYNTAX_ID SMALLINT NOT NULL /* AUTO_INCREMENT */,
	COMMAND_ID SMALLINT NOT NULL,
        LANG_ID SMALLINT DEFAULT 2 NOT NULL,
	SYNTAX VARCHAR(80) BINARY NOT NULL,

	CONSTRAINT PK_SYNTAX PRIMARY KEY(SYNTAX_ID),
	CONSTRAINT FK_SYNTAX_LANG_ID FOREIGN KEY (LANG_ID)
	   REFERENCES LANG(LANG_ID),
        CONSTRAINT FK_SYNTAX_COMMAND_ID FOREIGN KEY (COMMAND_ID)
	    REFERENCES COMMAND(COMMAND_ID)
)
DEFAULT CHARACTER SET = utf8;



CREATE TABLE DESCRIPTION (
	 DESCRIPTION_ID SMALLINT NOT NULL /* AUTO_INCREMENT */,
	 COMMAND_ID SMALLINT NOT NULL,
	 LANG_ID SMALLINT DEFAULT 2 NOT NULL,
	 LINE SMALLINT NOT NULL,
	 DESCRIPTION VARCHAR(1024) BINARY,

	 CONSTRAINT PK_DESCRIPTION PRIMARY KEY(DESCRIPTION_ID),
         CONSTRAINT UK_DESCRIPTION_LINE UNIQUE(COMMAND_ID, LANG_ID, LINE),
	 CONSTRAINT FK_DESCRIPTION_LANG_ID FOREIGN KEY (LANG_ID)
	    REFERENCES LANG(LANG_ID),
	 CONSTRAINT FK_DESCRIPTION_COMMAND_ID FOREIGN KEY (COMMAND_ID)
	    REFERENCES COMMAND(COMMAND_ID)
)
DEFAULT CHARACTER SET = utf8;



CREATE TABLE EXAMPLE (
	 EXAMPLE_ID SMALLINT NOT NULL /* AUTO_INCREMENT */,
	 COMMAND_ID SMALLINT NOT NULL,
	 LANG_ID SMALLINT DEFAULT 2 NOT NULL,
	 LINE SMALLINT NOT NULL,
	 EXAMPLE VARCHAR(1024) BINARY,

	 CONSTRAINT PK_EXAMPLE PRIMARY KEY(EXAMPLE_ID),
         CONSTRAINT UK_EXAMPLE_LINE UNIQUE(COMMAND_ID, LANG_ID, LINE),
	 CONSTRAINT FK_EXAMPLE_LANG_ID FOREIGN KEY (LANG_ID)
	    REFERENCES LANG(LANG_ID),
	 CONSTRAINT FK_EXAMPLE_COMMAND_ID FOREIGN KEY (COMMAND_ID, LANG_ID)
	    REFERENCES COMMAND(COMMAND_ID, LANG_ID)
)
DEFAULT CHARACTER SET = utf8;



CREATE TABLE LABEL (
	 LABEL_ID SMALLINT NOT NULL /* AUTO_INCREMENT */,
	 COMMAND_ID SMALLINT NOT NULL,
	 LANG_ID SMALLINT DEFAULT 2 NOT NULL,
	 LINE SMALLINT NOT NULL,
	 LABEL VARCHAR(80) BINARY NOT NULL,

	 CONSTRAINT PK_LABEL PRIMARY KEY(LABEL_ID),
         CONSTRAINT UK_LABEL_LINE UNIQUE(COMMAND_ID, LANG_ID, LINE),
         CONSTRAINT UK_LABEL_LABEL UNIQUE(LANG_ID, LABEL),
	 CONSTRAINT FK_LABEL_LANG_ID FOREIGN KEY (LANG_ID)
	    REFERENCES LANG(LANG_ID),
	 CONSTRAINT FK_LABEL_COMMAND_ID FOREIGN KEY (COMMAND_ID)
	    REFERENCES COMMAND(COMMAND_ID)
)
DEFAULT CHARACTER SET = utf8;



CREATE TABLE HEADER (
	 HEADER_ID SMALLINT NOT NULL /* AUTO_INCREMENT */,
	 COMMAND_ID SMALLINT NOT NULL,
	 LANG_ID SMALLINT DEFAULT 2 NOT NULL,
	 LINE SMALLINT NOT NULL,
	 HEADER VARCHAR(1024) BINARY NOT NULL,

	 CONSTRAINT PK_HEADER PRIMARY KEY(HEADER_ID),
         CONSTRAINT UK_HEADER_LINE UNIQUE(COMMAND_ID, LANG_ID, LINE),
	 CONSTRAINT FK_HEADER_LANG_ID FOREIGN KEY (LANG_ID)
	    REFERENCES LANG(LANG_ID),
	 CONSTRAINT FK_HEADER_COMMAND_ID FOREIGN KEY (COMMAND_ID)
	    REFERENCES COMMAND(COMMAND_ID)
)
DEFAULT CHARACTER SET = utf8;



CREATE TABLE XREF_TYPE (
         XREF_TYPE CHAR(1) BINARY NOT NULL,
	 DESCRIPTION VARCHAR(80) BINARY,

	 CONSTRAINT PK_XREF_TYPE PRIMARY KEY(XREF_TYPE)
)
DEFAULT CHARACTER SET = utf8;

INSERT INTO XREF_TYPE (XREF_TYPE, DESCRIPTION) VALUES ('L', 'link command');

INSERT INTO XREF_TYPE (XREF_TYPE, DESCRIPTION) VALUES ('A', 'link to label');

INSERT INTO XREF_TYPE (XREF_TYPE, DESCRIPTION) VALUES ('B', 'bracketed');

INSERT INTO XREF_TYPE (XREF_TYPE, DESCRIPTION) VALUES ('D', 'dotted');

INSERT INTO XREF_TYPE (XREF_TYPE, DESCRIPTION) VALUES ('N', 'normal');

INSERT INTO XREF_TYPE (XREF_TYPE, DESCRIPTION) VALUES ('1', 'single char');


CREATE TABLE XREF (
	 XREF_ID SMALLINT NOT NULL /* AUTO_INCREMENT */,
	 COMMAND_ID SMALLINT NOT NULL,
	 LANG_ID SMALLINT DEFAULT 2 NOT NULL,
	 LINE SMALLINT NOT NULL,
	 XREF VARCHAR(80) BINARY,
	 XREF_TYPE CHAR(1) BINARY NOT NULL,
	 XREF_TO SMALLINT,
	 TARGET VARCHAR(80) BINARY,

	 CONSTRAINT PK_XREF PRIMARY KEY(XREF_ID),
         CONSTRAINT UK_XREF_LINE UNIQUE(COMMAND_ID, LANG_ID, LINE),
	 CONSTRAINT FK_XREF_LANG_ID FOREIGN KEY (LANG_ID)
	    REFERENCES LANG(LANG_ID),
	 CONSTRAINT FK_XREF_COMMAND_ID FOREIGN KEY (COMMAND_ID)
	    REFERENCES COMMAND(COMMAND_ID),
	 CONSTRAINT FK_XREF_XREF_TO FOREIGN KEY (COMMAND_ID)
	    REFERENCES COMMAND(COMMAND_ID),
	 CONSTRAINT FK_XREF_XREF_TYPE FOREIGN KEY (XREF_TYPE)
	    REFERENCES XREF_TYPE(XREF_TYPE)
)
DEFAULT CHARACTER SET = utf8;
