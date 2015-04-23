Unit CmdLineParameterUnitTests;

// NewView - a new OS/2 Help Viewer
// Copyright 2006-2009 Ronald Brill (rbri at rbri dot de)
// This software is released under the GNU Public License - see readme.txt

// UnitTests for CmdLineParameterUnit

Interface

uses
  Classes,
  TestAssert,
  CmdLineParameterUnit;

  FUNCTION getCmdLineParameterUnitTests : TList;


Implementation

  PROCEDURE testParseCmdLine_Empty;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_Empty', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_Empty', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_Empty', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_Empty', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_Empty', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_Empty', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_Empty', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_Empty', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_Empty', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_Empty', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_Empty', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_Empty', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_QuestionMark;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-?';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertTrue('testParseCmdLine_QuestionMark', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_QuestionMark', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_QuestionMark', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_QuestionMark', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_QuestionMark', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_QuestionMark', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_QuestionMark', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_QuestionMark', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_QuestionMark', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_QuestionMark', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_QuestionMark', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_QuestionMark', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_QuotedQuestionMark;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '"-?"';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertTrue('testParseCmdLine_QuotedQuestionMark', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_QuotedQuestionMark', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_QuotedQuestionMark', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_QuotedQuestionMark', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_QuotedQuestionMark', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_QuotedQuestionMark', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_QuotedQuestionMark', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_QuotedQuestionMark', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_QuotedQuestionMark', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_QuotedQuestionMark', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_QuotedQuestionMark', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_QuotedQuestionMark', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_lowerH;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-h';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertTrue('testParseCmdLine_lowerH', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_lowerH', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_lowerH', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_lowerH', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_lowerH', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_lowerH', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_lowerH', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_lowerH', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_lowerH', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_lowerH', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_lowerH', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_lowerH', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_upperH;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-H';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertTrue('testParseCmdLine_upperH', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_upperH', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_upperH', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_upperH', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_upperH', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_upperH', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_upperH', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_upperH', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_upperH', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_upperH', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_upperH', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_upperH', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_lowerHelp;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-help';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertTrue('testParseCmdLine_lowerHelp', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_lowerHelp', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_lowerHelp', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_lowerHelp', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_lowerHelp', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_lowerHelp', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_lowerHelp', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_lowerHelp', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_lowerHelp', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_lowerHelp', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_lowerHelp', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_lowerHelp', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_upperHELP;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-HELP';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertTrue('testParseCmdLine_upperHELP', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_upperHELP', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_upperHELP', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_upperHELP', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_upperHELP', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_upperHELP', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_upperHELP', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_upperHELP', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_upperHELP', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_upperHELP', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_upperHELP', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_upperHELP', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_upperHE;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-He';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertTrue('testParseCmdLine_upperHE', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_upperHE', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_upperHELP', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_upperHE', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_upperHE', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_upperHE', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_upperHE', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_upperHE', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_upperHE', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_upperHE', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_upperHE', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_upperHE', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_h_between;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-s-h-title';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertTrue('testParseCmdLine_h_between', tmpCmdLineParameters.getShowUsageFlag);
    assertTrue('testParseCmdLine_h_between', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_h_between', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_h_between', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_h_between', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_h_between', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_h_between', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_h_between', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_h_between', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_h_between', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_h_between', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_h_between', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_h_between_withSpace;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-s -h -title';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertTrue('testParseCmdLine_h_between_withSpace', tmpCmdLineParameters.getShowUsageFlag);
    assertTrue('testParseCmdLine_h_between_withSpace', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_h_between_withSpace', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_h_between_withSpace', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_h_between_withSpace', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_h_between_withSpace', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_h_between_withSpace', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_h_between_withSpace', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_h_between_withSpace', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_h_between_withSpace', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_h_between_withSpace', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_h_between_withSpace', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_lowerS;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-s file search';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_lowerS', tmpCmdLineParameters.getShowUsageFlag);
    assertTrue('testParseCmdLine_lowerS', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_lowerS', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_lowerS', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_lowerS', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_lowerS', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_lowerS', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_lowerS', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_lowerS', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_lowerS', 'file', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_lowerS', 'file', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_lowerS', 'search', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_upperS;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-S file seArch';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_upperS', tmpCmdLineParameters.getShowUsageFlag);
    assertTrue('testParseCmdLine_upperS', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_upperS', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_upperS', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_upperS', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_upperS', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_upperS', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_upperS', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_upperS', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_upperS', 'file', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_upperS', 'file', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_upperS', 'seArch', tmpCmdLineParameters.getSearchText);
  END;



  PROCEDURE testParseCmdLine_upperS_withBlank;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-S FilE seArch';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_upperS_withBlank', tmpCmdLineParameters.getShowUsageFlag);
    assertTrue('testParseCmdLine_upperS_withBlank', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_upperS_withBlank', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_upperS_withBlank', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_upperS_withBlank', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_upperS_withBlank', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_upperS_withBlank', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_upperS_withBlank', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_upperS_withBlank', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_upperS_withBlank', 'FilE', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_upperS_withBlank', 'FilE', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_upperS_withBlank', 'seArch', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_QuotedS;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '"-S" FilE seArch';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_QuotedS', tmpCmdLineParameters.getShowUsageFlag);
    assertTrue('testParseCmdLine_QuotedS', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_QuotedS', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_QuotedS', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_QuotedS', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_QuotedS', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_QuotedS', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_QuotedS', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_QuotedS', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_QuotedS', 'FilE', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_QuotedS', 'FilE', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_QuotedS', 'seArch', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_emptyS;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-S';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_emptyS', tmpCmdLineParameters.getShowUsageFlag);
    assertTrue('testParseCmdLine_emptyS', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_emptyS', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_emptyS', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_emptyS', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_emptyS', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_emptyS', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_emptyS', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_emptyS', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_emptyS', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_emptyS', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_emptyS', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_s_between;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-h-s-h';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertTrue('testParseCmdLine_s_between', tmpCmdLineParameters.getShowUsageFlag);
    assertTrue('testParseCmdLine_s_between', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_s_between', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_emptyS', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_emptyS', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_s_between', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_s_between', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_s_between', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_s_between', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_s_between', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_s_between', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_s_between', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_s_between_withSpace;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-h -s -h';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertTrue('testParseCmdLine_s_between_withSpace', tmpCmdLineParameters.getShowUsageFlag);
    assertTrue('testParseCmdLine_s_between_withSpace', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_s_between_withSpace', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_s_between_withSpace', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_s_between_withSpace', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_s_between_withSpace', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_s_between_withSpace', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_s_between_withSpace', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_s_between_withSpace', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_s_between_withSpace', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_s_between_withSpace', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_s_between_withSpace', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_help_and_s;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-h -s file ';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertTrue('testParseCmdLine_help_and_s', tmpCmdLineParameters.getShowUsageFlag);
    assertTrue('testParseCmdLine_help_and_s', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_help_and_s', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_help_and_s', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_help_and_s', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_help_and_s', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_help_and_s', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_help_and_s', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_help_and_s', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_help_and_s', 'file', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_help_and_s', 'file', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_help_and_s', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_s_and_help;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-s -h file    ';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertTrue('testParseCmdLine_s_and_help', tmpCmdLineParameters.getShowUsageFlag);
    assertTrue('testParseCmdLine_s_and_help', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_s_and_help', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_s_and_help', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_s_and_help', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_s_and_help', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_s_and_help', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_s_and_help', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_s_and_help', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_s_and_help', 'file', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_s_and_help', 'file', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_s_and_help', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_help_and_s_without_blank;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-s-h file';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertTrue('testParseCmdLine_help_and_s_without_blank', tmpCmdLineParameters.getShowUsageFlag);
    assertTrue('testParseCmdLine_help_and_s_without_blank', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_help_and_s_without_blank', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_help_and_s_without_blank', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_help_and_s_without_blank', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_help_and_s_without_blank', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_help_and_s_without_blank', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_help_and_s_without_blank', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_help_and_s_without_blank', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_help_and_s_without_blank', 'file', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_help_and_s_without_blank', 'file', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_help_and_s_without_blank', '', tmpCmdLineParameters.getSearchText);
  END;



 PROCEDURE testParseCmdLine_lowerG;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-g file search';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_lowerG', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_lowerG', tmpCmdLineParameters.getSearchFlag);
    assertTrue('testParseCmdLine_lowerG', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_lowerG', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_lowerG', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_lowerG', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_lowerG', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_lowerG', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_lowerG', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_lowerG', 'file', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_lowerG', 'file', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_lowerG', 'search', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_upperG;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-G fiLe seArch';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_upperG', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_upperG', tmpCmdLineParameters.getSearchFlag);
    assertTrue('testParseCmdLine_upperG', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_upperG', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_upperG', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_upperG', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_upperG', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_upperG', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_upperG', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_upperG', 'fiLe', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_upperG', 'fiLe', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_upperG', 'seArch', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_QuotedG;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '"-G" seArch';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_QuotedG', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_QuotedG', tmpCmdLineParameters.getSearchFlag);
    assertTrue('testParseCmdLine_QuotedG', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_QuotedG', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_QuotedG', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_QuotedG', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_QuotedG', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_QuotedG', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_QuotedG', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_QuotedG', '', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_QuotedG', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_QuotedG', 'seArch', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_emptyG;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-G';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_emptyG', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_emptyG', tmpCmdLineParameters.getSearchFlag);
    assertTrue('testParseCmdLine_emptyG', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_emptyG', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_emptyG', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_emptyG', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_emptyG', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_emptyG', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_emptyG', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_emptyG', '', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_emptyG', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_emptyG', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_g_between;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-h-G-s';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertTrue('testParseCmdLine_g_between', tmpCmdLineParameters.getShowUsageFlag);
    assertTrue('testParseCmdLine_g_between', tmpCmdLineParameters.getSearchFlag);
    assertTrue('testParseCmdLine_g_between', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_g_between', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_g_between', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_g_between', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_g_between', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_g_between', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_g_between', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_g_between', '', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_g_between', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_g_between', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_g_between_withSpace;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-h -G -s';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertTrue('testParseCmdLine_g_between_withSpace', tmpCmdLineParameters.getShowUsageFlag);
    assertTrue('testParseCmdLine_g_between_withSpace', tmpCmdLineParameters.getSearchFlag);
    assertTrue('testParseCmdLine_g_between_withSpace', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_g_between_withSpace', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_g_between_withSpace', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_g_between_withSpace', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_g_between_withSpace', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_g_between_withSpace', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_g_between_withSpace', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_g_between_withSpace', '', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_g_between_withSpace', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_g_between_withSpace', '', tmpCmdLineParameters.getSearchText);
  END;


 PROCEDURE testParseCmdLine_lowerI;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-i file';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_lowerI', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_lowerI', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_lowerI', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_lowerI', '', tmpCmdLineParameters.getLanguage);
    assertTrue('testParseCmdLine_lowerI', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_lowerI', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_lowerI', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_lowerI', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_lowerI', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_lowerI', 'file', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_lowerI', 'file', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_lowerI', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_upperI;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-I fiLe seArch';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_upperI', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_upperI', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_upperI', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_upperI', '', tmpCmdLineParameters.getLanguage);
    assertTrue('testParseCmdLine_upperI', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_upperI', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_upperI', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_upperI', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_upperI', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_upperI', 'fiLe', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_upperI', 'fiLe', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_upperI', 'seArch', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_QuotedI;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '"-I" seArch';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_QuotedI', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_QuotedI', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_QuotedI', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_QuotedI', '', tmpCmdLineParameters.getLanguage);
    assertTrue('testParseCmdLine_QuotedI', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_QuotedI', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_QuotedI', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_QuotedI', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_QuotedI getWindowTitle', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_QuotedI getFileNames(true)', 'seArch', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_QuotedI getFileNames(false)', 'seArch', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_QuotedI getSearchText', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_emptyI;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-I';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_emptyI', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_emptyI', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_emptyI', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_emptyI', '', tmpCmdLineParameters.getLanguage);
    assertTrue('testParseCmdLine_emptyI', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_emptyI', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_emptyI', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_emptyI', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_emptyI getWindowTitle', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_emptyI getFileNames(true)', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_emptyI getFileNames(false)', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_emptyI getSearchText', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_i_between;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-h-i-s';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertTrue('testParseCmdLine_i_between', tmpCmdLineParameters.getShowUsageFlag);
    assertTrue('testParseCmdLine_i_between', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_i_between', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_i_between', '', tmpCmdLineParameters.getLanguage);
    assertTrue('testParseCmdLine_i_between', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_i_between', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_i_between', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_i_between', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_i_between', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_i_between', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_i_between', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_i_between', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_i_between_withSpace;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-h -I -s';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertTrue('testParseCmdLine_i_between_withSpace', tmpCmdLineParameters.getShowUsageFlag);
    assertTrue('testParseCmdLine_i_between_withSpace', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_i_between_withSpace', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_i_between_withSpace', '', tmpCmdLineParameters.getLanguage);
    assertTrue('testParseCmdLine_i_between_withSpace', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_i_between_withSpace', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_i_between_withSpace', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_i_between_withSpace', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_i_between_withSpace', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_i_between_withSpace', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_i_between_withSpace', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_i_between_withSpace', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_Language;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-lang:DE';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_Language', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_Language', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_Language', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_Language', 'DE', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_Language', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_Language', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_Language', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_Language', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_Language', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_Language', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_Language', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_Language', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_Language_Empty;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-lang';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_Language_Empty', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_Language_Empty', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_Language_Empty', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_Language_Empty', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_Language_Empty', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_Language_Empty', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_Language_Empty', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_Language_Empty', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_Language_Empty', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_Language_Empty', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_Language_Empty', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_Language_Empty', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_Language_Empty_WithColon;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-lang:';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_Language_Empty_WithColon', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_Language_Empty_WithColon', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_Language_Empty_WithColon', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_Language_Empty_WithColon', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_Language_Empty_WithColon', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_Language_Empty_WithColon', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_Language_Empty_WithColon', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_Language_Empty_WithColon', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_Language_Empty_WithColon', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_Language_Empty_WithColon', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_Language_Empty_WithColon', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_Language_Empty_WithColon', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_Language_WithFile;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-lang:DE filE';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_Language_WithFile', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_Language_WithFile', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_Language_WithFile', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_Language_WithFile', 'DE', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_Language_WithFile', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_Language_WithFile', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_Language_WithFile', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_Language_WithFile', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_Language_WithFile', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_Language_WithFile', 'filE', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_Language_WithFile', 'filE', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_Language_WithFile', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_QuotedLanguage;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '"-lang:DE" filE';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_QuotedLanguage', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_QuotedLanguage', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_QuotedLanguage', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_QuotedLanguage', 'DE', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_QuotedLanguage', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_QuotedLanguage', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_QuotedLanguage', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_QuotedLanguage', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_QuotedLanguage', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_QuotedLanguage', 'filE', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_QuotedLanguage', 'filE', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_QuotedLanguage', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_QuotedLanguage2;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-lang:"DE" filE';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_QuotedLanguage2', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_QuotedLanguage2', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_QuotedLanguage2', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_QuotedLanguage2', 'DE', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_QuotedLanguage2', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_QuotedLanguage2', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_QuotedLanguage2', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_QuotedLanguage2', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_QuotedLanguage2', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_QuotedLanguage2', 'filE', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_QuotedLanguage2', 'filE', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_QuotedLanguage2', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_Language_between;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-s-lang:DE-h filE';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertTrue('testParseCmdLine_Language_between', tmpCmdLineParameters.getShowUsageFlag);
    assertTrue('testParseCmdLine_Language_between', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_Language_between', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_Language_between', 'DE', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_Language_between', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_Language_between', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_Language_between', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_Language_between', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_Language_between', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_Language_between', 'filE', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_Language_between', 'filE', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_Language_between', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_Language_between_withSpace;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-s-lang:DE-h filE';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertTrue('testParseCmdLine_Language_between_withSpace', tmpCmdLineParameters.getShowUsageFlag);
    assertTrue('testParseCmdLine_Language_between_withSpace', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_Language_between_withSpace', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_Language_between_withSpace', 'DE', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_Language_between_withSpace', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_Language_between_withSpace', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_Language_between_withSpace', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_Language_between_withSpace', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_Language_between_withSpace', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_Language_between_withSpace', 'filE', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_Language_between_withSpace', 'filE', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_Language_between_withSpace', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_HelpManagerNumber;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-Hm:123';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_HelpManagerNumber', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_HelpManagerNumber', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_HelpManagerNumber', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_HelpManagerNumber', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_HelpManagerNumber', tmpCmdLineParameters.getShowIndexFlag);
    assertTrue('testParseCmdLine_HelpManagerNumber', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_HelpManagerNumber', 123, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_HelpManagerNumber', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_HelpManagerNumber', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_HelpManagerNumber', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_HelpManagerNumber', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_HelpManagerNumber', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_HelpManagerBigNumber;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-Hm:2147484546';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_HelpManagerBigNumber', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_HelpManagerBigNumber', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_HelpManagerBigNumber', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_HelpManagerBigNumber', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_HelpManagerBigNumber', tmpCmdLineParameters.getShowIndexFlag);
    assertTrue('testParseCmdLine_HelpManagerBigNumber', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_HelpManagerBigNumber', 2147484546, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_HelpManagerBigNumber', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_HelpManagerBigNumber', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_HelpManagerBigNumber', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_HelpManagerBigNumber', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_HelpManagerBigNumber', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_HelpManagerNumber_WithoutColon;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-Hm123';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_HelpManagerNumber_WithoutColon', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_HelpManagerNumber_WithoutColon', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_HelpManagerNumber_WithoutColon', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_HelpManagerNumber_WithoutColon', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_HelpManagerNumber_WithoutColon', tmpCmdLineParameters.getShowIndexFlag);
    assertTrue('testParseCmdLine_HelpManagerNumber_WithoutColon', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_HelpManagerNumber_WithoutColon', 123, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_HelpManagerNumber_WithoutColon', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_HelpManagerNumber_WithoutColon', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_HelpManagerNumber_WithoutColon', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_HelpManagerNumber_WithoutColon', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_HelpManagerNumber_WithoutColon', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_HelpManagerNumber_Invalid;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-Hm:12u3';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertTrue('testParseCmdLine_HelpManagerNumber_Invalid', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_HelpManagerNumber_Invalid', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_HelpManagerNumber_Invalid', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_HelpManagerNumber_Invalid', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_HelpManagerNumber_Invalid', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_HelpManagerNumber_Invalid', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_HelpManagerNumber_Invalid', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_HelpManagerNumber_Invalid', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_HelpManagerNumber_Invalid', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_HelpManagerNumber_Invalid', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_HelpManagerNumber_Invalid', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_HelpManagerNumber_Invalid', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_HelpManagerNumber_between;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-s-Hm:12-h';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertTrue('testParseCmdLine_HelpManagerNumber_between', tmpCmdLineParameters.getShowUsageFlag);
    assertTrue('testParseCmdLine_HelpManagerNumber_between', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_HelpManagerNumber_between', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_HelpManagerNumber_between', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_HelpManagerNumber_between', tmpCmdLineParameters.getShowIndexFlag);
    assertTrue('testParseCmdLine_HelpManagerNumber_between', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_HelpManagerNumber_between', 12, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_HelpManagerNumber_between', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_HelpManagerNumber_between', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_HelpManagerNumber_between', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_HelpManagerNumber_between', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_HelpManagerNumber_between', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_HelpManagerNumber_between_withSpace;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-s -Hm:12 -h';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertTrue('testParseCmdLine_HelpManagerNumber_between_withSpace', tmpCmdLineParameters.getShowUsageFlag);
    assertTrue('testParseCmdLine_HelpManagerNumber_between_withSpace', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_HelpManagerNumber_between_withSpace', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_HelpManagerNumber_between_withSpace', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_HelpManagerNumber_between_withSpace', tmpCmdLineParameters.getShowIndexFlag);
    assertTrue('testParseCmdLine_HelpManagerNumber_between_withSpace', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_HelpManagerNumber_between_withSpace', 12, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_HelpManagerNumber_between_withSpace', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_HelpManagerNumber_between_withSpace', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_HelpManagerNumber_between_withSpace', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_HelpManagerNumber_between_withSpace', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_HelpManagerNumber_between_withSpace', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_OwnerNumber;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-owNer:1234';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_OwnerNumber', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_OwnerNumber', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_OwnerNumber', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_OwnerNumber', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_OwnerNumber', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_OwnerNumber', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_OwnerNumber', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_OwnerNumber', 1234, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_OwnerNumber', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_OwnerNumber', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_OwnerNumber', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_OwnerNumber', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_OwnerNumber_WithoutColon;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-OWNER134';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_OwnerNumber_WithoutColon', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_OwnerNumber_WithoutColon', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_OwnerNumber_WithoutColon', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_OwnerNumber_WithoutColon', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_OwnerNumber_WithoutColon', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_OwnerNumber_WithoutColon', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_OwnerNumber_WithoutColon', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_OwnerNumber_WithoutColon', 134, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_OwnerNumber_WithoutColon', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_OwnerNumber_WithoutColon', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_OwnerNumber_WithoutColon', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_OwnerNumber_WithoutColon', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_OwnerNumber_Invalid;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-owner:12x34';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertTrue('testParseCmdLine_OwnerNumber_Invalid', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_OwnerNumber_Invalid', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_OwnerNumber_Invalid', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_OwnerNumber_Invalid', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_OwnerNumber_Invalid', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_OwnerNumber_Invalid', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_OwnerNumber_Invalid', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_OwnerNumber_Invalid', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_OwnerNumber_Invalid', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_OwnerNumber_Invalid', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_OwnerNumber_Invalid', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_OwnerNumber_Invalid', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_OwnerNumber_between;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-g-owner:14-s';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_OwnerNumber_between', tmpCmdLineParameters.getShowUsageFlag);
    assertTrue('testParseCmdLine_OwnerNumber_between', tmpCmdLineParameters.getSearchFlag);
    assertTrue('testParseCmdLine_OwnerNumber_between', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_OwnerNumber_between', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_OwnerNumber_between', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_OwnerNumber_between', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_OwnerNumber_between', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_OwnerNumber_between', 14, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_OwnerNumber_between', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_OwnerNumber_between', '', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_OwnerNumber_between', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_OwnerNumber_between', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_OwnerNumber_between_withSpace;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-g -owner:14 -s';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_OwnerNumber_between_withSpace', tmpCmdLineParameters.getShowUsageFlag);
    assertTrue('testParseCmdLine_OwnerNumber_between_withSpace', tmpCmdLineParameters.getSearchFlag);
    assertTrue('testParseCmdLine_OwnerNumber_between_withSpace', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_OwnerNumber_between_withSpace', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_OwnerNumber_between_withSpace', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_OwnerNumber_between_withSpace', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_OwnerNumber_between_withSpace', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_OwnerNumber_between_withSpace', 14, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_OwnerNumber_between_withSpace', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_OwnerNumber_between_withSpace', '', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_OwnerNumber_between_withSpace', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_OwnerNumber_between_withSpace', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_Title;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-Title:Test';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_Title', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_Title', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_Title', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_Title', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_Title', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_Title', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_Title', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_Title', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_Title', 'Test', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_Title', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_Title', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_Title', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_Title_WithoutColon;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-titletitlE';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_Title_WithoutColon', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_Title_WithoutColon', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_Title_WithoutColon', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_Title_WithoutColon', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_Title_WithoutColon', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_Title_WithoutColon', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_Title_WithoutColon', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_Title_WithoutColon', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_Title_WithoutColon', 'titlE', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_Title_WithoutColon', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_Title_WithoutColon', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_Title_WithoutColon', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_Title_Empty;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-TITLE:';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_Title_Empty', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_Title_Empty', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_Title_Empty', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_Title_Empty', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_Title_Empty', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_Title_Empty', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_Title_Empty', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_Title_Empty', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_Title_Empty', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_Title_Empty', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_Title_Empty', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_Title_Empty', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_QuotedTitle;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '"-Title:Test Title"';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_QuotedTitle', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_QuotedTitle', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_QuotedTitle', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_QuotedTitle', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_QuotedTitle', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_QuotedTitle', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_QuotedTitle', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_QuotedTitle', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_QuotedTitle', 'Test Title', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_QuotedTitle', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_QuotedTitle', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_QuotedTitle', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_QuotedTitle2;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-Title:"Test Title"';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_QuotedTitle2', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_QuotedTitle2', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_QuotedTitle2', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_QuotedTitle2', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_QuotedTitle2', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_QuotedTitle2', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_QuotedTitle2', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_QuotedTitle2', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_QuotedTitle2', 'Test Title', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_QuotedTitle2', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_QuotedTitle2', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_QuotedTitle2', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_QuotedTitle_AfterFile;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := 'cmdref "-Title:Test Title"';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_QuotedTitle_AfterFile', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_QuotedTitle_AfterFile', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_QuotedTitle_AfterFile', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_QuotedTitle_AfterFile', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_QuotedTitle_AfterFile', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_QuotedTitle_AfterFile', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_QuotedTitle_AfterFile', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_QuotedTitle_AfterFile', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_QuotedTitle_AfterFile', 'Test Title', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_QuotedTitle_AfterFile', 'cmdref', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_QuotedTitle_AfterFile', 'cmdref', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_QuotedTitle_AfterFile', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_Title_between;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-h-TITLE:tItlE-s';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertTrue('testParseCmdLine_Title_between', tmpCmdLineParameters.getShowUsageFlag);
    assertTrue('testParseCmdLine_Title_between', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_Title_between', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_Title_between', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_Title_between', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_Title_between', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_Title_between', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_Title_between', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_Title_between', 'tItlE', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_Title_between', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_Title_between', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_Title_between', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_Title_between_withSpace;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-h-TITLE:tItlE-s';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertTrue('testParseCmdLine_Title_between_withSpace', tmpCmdLineParameters.getShowUsageFlag);
    assertTrue('testParseCmdLine_Title_between_withSpace', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_Title_between_withSpace', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_Title_between_withSpace', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_Title_between_withSpace', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_Title_between_withSpace', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_Title_between_withSpace', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_Title_between_withSpace', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_Title_between_withSpace', 'tItlE', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_Title_between_withSpace', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_Title_between_withSpace', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_Title_between_withSpace', '', tmpCmdLineParameters.getSearchText);
  END;


  // can't test start profile

  PROCEDURE testParseCmdLine_WindowPos;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
    tmpWindowPosition : TWindowPosition;
  BEGIN
    tmpCmdLineString := '-pos:20,40,60,80';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_WindowPos', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_WindowPos', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_WindowPos', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_WindowPos', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_WindowPos', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_WindowPos', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_WindowPos', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_WindowPos', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_WindowPos', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_WindowPos', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_WindowPos', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_WindowPos', '', tmpCmdLineParameters.getSearchText);

    assertTrue('testParseCmdLine_WindowPos', tmpCmdLineParameters.getWindowPositionFlag);
    tmpWindowPosition := tmpCmdLineParameters.getWindowPosition;
    assertEqualsInt('testParseCmdLine_WindowPos', 20, tmpWindowPosition.left);
    assertEqualsInt('testParseCmdLine_WindowPos', 40, tmpWindowPosition.bottom);
    assertEqualsInt('testParseCmdLine_WindowPos', 60, tmpWindowPosition.width);
    assertEqualsInt('testParseCmdLine_WindowPos', 80, tmpWindowPosition.height);
  END;



  PROCEDURE testParseCmdLine_WindowPosPercentage;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
    tmpWindowPosition : TWindowPosition;
  BEGIN
    tmpCmdLineString := '-pos:100p,100p,50p,50p';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_WindowPosPercentage', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_WindowPosPercentage', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_WindowPosPercentage', tmpCmdLineParameters.getGlobalSearchFlag);
    assertFalse('testParseCmdLine_WindowPosPercentage', tmpCmdLineParameters.getShowIndexFlag);
    assertEqualsString('testParseCmdLine_WindowPos', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_WindowPosPercentage', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_WindowPosPercentage', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_WindowPosPercentage', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_WindowPosPercentage', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_WindowPosPercentage', 'C:\ecs\help\NewView.hlp', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_WindowPosPercentage', '', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_WindowPosPercentage', '', tmpCmdLineParameters.getSearchText);

    assertTrue('testParseCmdLine_WindowPosPercentage', tmpCmdLineParameters.getWindowPositionFlag);
    tmpWindowPosition := tmpCmdLineParameters.getWindowPosition;
    assertEqualsInt('testParseCmdLine_WindowPosPercentage', 1920, tmpWindowPosition.left);
    assertEqualsInt('testParseCmdLine_WindowPosPercentage', 1200, tmpWindowPosition.bottom);
    assertEqualsInt('testParseCmdLine_WindowPosPercentage', 960, tmpWindowPosition.width);
    assertEqualsInt('testParseCmdLine_WindowPosPercentage', 600, tmpWindowPosition.height);
  END;


  PROCEDURE testParseCmdLine_Topic;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := 'file topi1 topi2';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_Topic->ShowUsageFlag', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_Topic->SearchFlag', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_Topic->GlobalSearchFlag', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_Topic', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_Topic', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_Topic', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_Topic', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_Topic', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_Topic', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_Topic', 'file', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_Topic', 'file', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_Topic', 'topi1 topi2', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_QuotedTopic;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := 'file "topi1"';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_QuotedTopic->ShowUsageFlag', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_QuotedTopic->SearchFlag', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_QuotedTopic->GlobalSearchFlag', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_QuotedTopic', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_QuotedTopic', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_QuotedTopic', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_QuotedTopic', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_QuotedTopic', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_QuotedTopic', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_QuotedTopic', 'file', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_QuotedTopic', 'file', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_QuotedTopic', 'topi1', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_file;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := 'file';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_file->ShowUsageFlag', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_file->SearchFlag', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_file->GlobalSearchFlag', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_file', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_file', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_file', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_file', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_file', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_file', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_file', 'file', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_file', 'file', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_file', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_fileLeadingBlanks;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '  file';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_fileLeadingBlanks->ShowUsageFlag', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_fileLeadingBlanks->SearchFlag', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_fileLeadingBlanks->GlobalSearchFlag', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_fileLeadingBlanks', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_fileLeadingBlanks',  tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_fileLeadingBlanks', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_fileLeadingBlanks', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_fileLeadingBlanks', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_fileLeadingBlanks', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_fileLeadingBlanks', 'file', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_fileLeadingBlanks', 'file', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_fileLeadingBlanks', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_fileTrailingBlanks;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := 'file  ';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_fileTrailingBlanks->ShowUsageFlag', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_fileTrailingBlanks->SearchFlag', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_fileTrailingBlanks->GlobalSearchFlag', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_fileTrailingBlanks', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_fileTrailingBlanks', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_fileTrailingBlanks', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_fileTrailingBlanks', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_fileTrailingBlanks', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_fileTrailingBlanks', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_fileTrailingBlanks', 'file', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_fileTrailingBlanks', 'file', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_fileTrailingBlanks', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_fileQuoted;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '"fi -h le"';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_fileQuoted->ShowUsageFlag', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_fileQuoted->SearchFlag', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_fileQuoted->GlobalSearchFlag', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_fileQuoted', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_fileQuoted', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_fileQuoted', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_fileQuoted', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_fileQuoted', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_fileQuoted', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_fileQuoted', 'fi -h le', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_fileQuoted', 'fi -h le', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_fileQuoted', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_fileQuotedMissingClosedQuote;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '"fi -h le';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_fileQuotedMissingClosedQuote->ShowUsageFlag', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_fileQuotedMissingClosedQuote->SearchFlag', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_fileQuotedMissingClosedQuote->GlobalSearchFlag', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_fileQuotedMissingClosedQuote', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_fileQuotedMissingClosedQuote', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_fileQuotedMissingClosedQuote', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_fileQuotedMissingClosedQuote', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_fileQuotedMissingClosedQuote', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_fileQuotedMissingClosedQuote', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_fileQuotedMissingClosedQuote', 'fi -h le', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_fileQuotedMissingClosedQuote', 'fi -h le', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_fileQuotedMissingClosedQuote', '', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_fileQuotedAndText;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '"fi -h le" searchText';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_fileQuotedAndText->ShowUsageFlag', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_fileQuotedAndText->SearchFlag', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_fileQuotedAndText->GlobalSearchFlag', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_fileQuotedAndText', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_fileQuotedAndText', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_fileQuotedAndText', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_fileQuotedAndText', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_fileQuotedAndText', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_fileQuotedAndText', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_fileQuotedAndText', 'fi -h le', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_fileQuotedAndText', 'fi -h le', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_fileQuotedAndText', 'searchText', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_fileQuotedAndTextManyBlanks;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '"fi -h le"    searchText    ';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_fileQuotedAndTextManyBlanks->ShowUsageFlag', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_fileQuotedAndTextManyBlanks->SearchFlag', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_fileQuotedAndTextManyBlanks->GlobalSearchFlag', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_fileQuotedAndTextManyBlanks', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_fileQuotedAndTextManyBlanks', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_fileQuotedAndTextManyBlanks', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_fileQuotedAndTextManyBlanks', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_fileQuotedAndTextManyBlanks', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_fileQuotedAndTextManyBlanks', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_fileQuotedAndTextManyBlanks', 'fi -h le', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_fileQuotedAndTextManyBlanks', 'fi -h le', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_fileQuotedAndTextManyBlanks', 'searchText', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_fileQuotedInside;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := 'test"fi -h le"tes searchText';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_fileQuotedInside->ShowUsageFlag', tmpCmdLineParameters.getShowUsageFlag);
    assertFalse('testParseCmdLine_fileQuotedInside->SearchFlag', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_fileQuotedInside->GlobalSearchFlag', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_fileQuotedInside', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_fileQuotedInside', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_fileQuotedInside', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_fileQuotedInside', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_fileQuotedInside', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_fileQuotedInside', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_fileQuotedInside', 'testfi -h letes', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_fileQuotedInside', 'testfi -h letes', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_fileQuotedInside', 'searchText', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_SwitchAndFileQuoted;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-s "fi -h le" searchText';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_SwitchAndFileQuoted->ShowUsageFlag', tmpCmdLineParameters.getShowUsageFlag);
    assertTrue('testParseCmdLine_SwitchAndFileQuoted->SearchFlag', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_SwitchAndFileQuoted->GlobalSearchFlag', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_SwitchAndFileQuoted', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_SwitchAndFileQuoted', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_SwitchAndFileQuoted', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_SwitchAndFileQuoted', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_SwitchAndFileQuoted', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_SwitchAndFileQuoted', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_SwitchAndFileQuoted', 'fi -h le', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_SwitchAndFileQuoted', 'fi -h le', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_SwitchAndFileQuoted', 'searchText', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_SwitchAndFileAndTextQuoted;
  VAR
    tmpCmdLineString : String;
    tmpCmdLineParameters : TCmdLineParameters;
  BEGIN
    tmpCmdLineString := '-s file "search text"';
    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_SwitchAndFileAndTextQuoted->ShowUsageFlag', tmpCmdLineParameters.getShowUsageFlag);
    assertTrue('testParseCmdLine_SwitchAndFileAndTextQuoted->SearchFlag', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_SwitchAndFileAndTextQuoted->GlobalSearchFlag', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_SwitchAndFileAndTextQuoted', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_SwitchAndFileAndTextQuoted', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_SwitchAndFileAndTextQuoted', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_SwitchAndFileAndTextQuoted', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_SwitchAndFileAndTextQuoted', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_SwitchAndFileAndTextQuoted', '', tmpCmdLineParameters.getWindowTitle);
    assertEqualsString('testParseCmdLine_SwitchAndFileAndTextQuoted', 'file', tmpCmdLineParameters.getFileNames(true));
    assertEqualsString('testParseCmdLine_SwitchAndFileAndTextQuoted', 'file', tmpCmdLineParameters.getFileNames(false));
    assertEqualsString('testParseCmdLine_SwitchAndFileAndTextQuoted', '"search text"', tmpCmdLineParameters.getSearchText);
  END;


  PROCEDURE testParseCmdLine_ReallyLong;
  VAR
    tmpCmdLineString : AnsiString;
    tmpCmdLineParameters : TCmdLineParameters;
    i : integer;
  BEGIN
    tmpCmdLineString := '-s ';

    // long file name
    tmpCmdLineString := tmpCmdLineString + 'LongFileName';
    for i := 1 to 30 do
    begin
      tmpCmdLineString := tmpCmdLineString + '0123456789';
    end;

    // long search text
    tmpCmdLineString := tmpCmdLineString + ' LongSearchText';
    for i := 1 to 30 do
    begin
      tmpCmdLineString := tmpCmdLineString + '0123456789';
    end;

    tmpCmdLineParameters := TCmdLineParameters.Create;
    tmpCmdLineParameters.parseCmdLine(tmpCmdLineString);

    assertFalse('testParseCmdLine_ReallyLong->ShowUsageFlag', tmpCmdLineParameters.getShowUsageFlag);
    assertTrue('testParseCmdLine_ReallyLong->SearchFlag', tmpCmdLineParameters.getSearchFlag);
    assertFalse('testParseCmdLine_ReallyLong->GlobalSearchFlag', tmpCmdLineParameters.getGlobalSearchFlag);
    assertEqualsString('testParseCmdLine_ReallyLong', '', tmpCmdLineParameters.getLanguage);
    assertFalse('testParseCmdLine_ReallyLong', tmpCmdLineParameters.getShowIndexFlag);
    assertFalse('testParseCmdLine_ReallyLong', tmpCmdLineParameters.getHelpManagerFlag);
    assertEqualsInt('testParseCmdLine_ReallyLong', 0, tmpCmdLineParameters.getHelpManagerWindow);
    assertEqualsInt('testParseCmdLine_ReallyLong', 0, tmpCmdLineParameters.getOwnerWindow);
    assertEqualsString('testParseCmdLine_ReallyLong', '', tmpCmdLineParameters.getWindowTitle);

    assertEqualsInt('testParseCmdLine_ReallyLong', 312, Length(tmpCmdLineParameters.getFileNames(true)));
    assertEqualsInt('testParseCmdLine_ReallyLong', 312, Length(tmpCmdLineParameters.getFileNames(false)));
    assertEqualsInt('testParseCmdLine_ReallyLong', 314, Length(tmpCmdLineParameters.getSearchText));
  END;


  // ----------------------------------------------------------


  PROCEDURE testParseAndExpandFileNames_EmptyString;
  VAR
    tmpFileNamesString : String;
    tmpFileNamesList: TStringList;
  BEGIN
    tmpFileNamesString := '';

    tmpFileNamesList := TStringList.Create;
    ParseAndExpandFileNames(tmpFileNamesString, tmpFileNamesList);

    assertEqualsInt('testParseAndExpandFileNames_EmptyString', 0, tmpFileNamesList.Count);

    tmpFileNamesList.Destroy;
  END;


  PROCEDURE testParseAndExpandFileNames_OneFile;
  VAR
    tmpFileNamesString : String;
    tmpFileNamesList: TStringList;
  BEGIN
    tmpFileNamesString := 'cmdref';

    tmpFileNamesList := TStringList.Create;
    ParseAndExpandFileNames(tmpFileNamesString, tmpFileNamesList);

    assertEqualsInt('testParseAndExpandFileNames_OneFile', 1, tmpFileNamesList.Count);
    assertEqualsString('testParseAndExpandFileNames_OneFile', 'cmdref', tmpFileNamesList[0]);

    tmpFileNamesList.Destroy;
  END;


  PROCEDURE testParseAndExpandFileNames_TwoFiles;
  VAR
    tmpFileNamesString : String;
    tmpFileNamesList: TStringList;
  BEGIN
    tmpFileNamesString := 'cmdref+second';

    tmpFileNamesList := TStringList.Create;
    ParseAndExpandFileNames(tmpFileNamesString, tmpFileNamesList);

    assertEqualsInt('testParseAndExpandFileNames_TwoFiles', 2, tmpFileNamesList.Count);
    assertEqualsString('testParseAndExpandFileNames_TwoFiles', 'cmdref', tmpFileNamesList[0]);
    assertEqualsString('testParseAndExpandFileNames_TwoFiles', 'second', tmpFileNamesList[1]);

    tmpFileNamesList.Destroy;
  END;


  PROCEDURE testParseAndExpandFileNames_PlusAtEnd;
  VAR
    tmpFileNamesString : String;
    tmpFileNamesList: TStringList;
  BEGIN
    tmpFileNamesString := 'cmdref+second+';

    tmpFileNamesList := TStringList.Create;
    ParseAndExpandFileNames(tmpFileNamesString, tmpFileNamesList);

    assertEqualsInt('testParseAndExpandFileNames_PlusAtEnd', 2, tmpFileNamesList.Count);
    assertEqualsString('testParseAndExpandFileNames_PlusAtEnd', 'cmdref', tmpFileNamesList[0]);
    assertEqualsString('testParseAndExpandFileNames_PlusAtEnd', 'second', tmpFileNamesList[1]);

    tmpFileNamesList.Destroy;
  END;


  PROCEDURE testParseAndExpandFileNames_GLOSSARY;
  VAR
    tmpFileNamesString : String;
    tmpFileNamesList: TStringList;
  BEGIN
    tmpFileNamesString := 'GLOSSARY';

    tmpFileNamesList := TStringList.Create;
    ParseAndExpandFileNames(tmpFileNamesString, tmpFileNamesList);

    assertEqualsInt('testParseAndExpandFileNames_GLOSSARY', 1, tmpFileNamesList.Count);
    assertEqualsString('testParseAndExpandFileNames_GLOSSARY', 'C:\OS2\HELP\GLOSS\WPGLOSS.HLP', tmpFileNamesList[0]);

    tmpFileNamesList.Destroy;
  END;


  PROCEDURE testParseAndExpandFileNames_GlossaryMixedCase;
  VAR
    tmpFileNamesString : String;
    tmpFileNamesList: TStringList;
  BEGIN
    tmpFileNamesString := 'Glossary';

    tmpFileNamesList := TStringList.Create;
    ParseAndExpandFileNames(tmpFileNamesString, tmpFileNamesList);

    assertEqualsInt('testParseAndExpandFileNames_GlossaryMixedCase', 1, tmpFileNamesList.Count);
    assertEqualsString('testParseAndExpandFileNames_GlossaryMixedCase', 'Glossary', tmpFileNamesList[0]);

    tmpFileNamesList.Destroy;
  END;


  PROCEDURE testParseAndExpandFileNames_HELP;
  VAR
    tmpFileNamesString : String;
    tmpFileNamesList: TStringList;
  BEGIN
    tmpFileNamesString := 'HELP';

    tmpFileNamesList := TStringList.Create;
    ParseAndExpandFileNames(tmpFileNamesString, tmpFileNamesList);

    assertEqualsInt('testParseAndExpandFileNames_HELP', 116, tmpFileNamesList.Count);
    assertEqualsString('testParseAndExpandFileNames_HELP', 'D:\progs\develop\watcom_18\BINP\HELP\ide.hlp', tmpFileNamesList[0]);
    assertEqualsString('testParseAndExpandFileNames_HELP', 'D:\progs\develop\watcom_18\BINP\HELP\wbrw.hlp', tmpFileNamesList[1]);
    assertEqualsString('testParseAndExpandFileNames_HELP', 'D:\progs\develop\watcom_18\BINP\HELP\wccerrs.hlp', tmpFileNamesList[2]);
    assertEqualsString('testParseAndExpandFileNames_HELP', 'D:\progs\develop\watcom_18\BINP\HELP\wd.hlp', tmpFileNamesList[3]);
    assertEqualsString('testParseAndExpandFileNames_HELP', 'D:\progs\develop\watcom_18\BINP\HELP\wpperrs.hlp', tmpFileNamesList[4]);
    assertEqualsString('testParseAndExpandFileNames_HELP', 'D:\progs\develop\watcom_18\BINP\HELP\wprof.hlp', tmpFileNamesList[5]);
    assertEqualsString('testParseAndExpandFileNames_HELP', 'C:\MPTN\ddccmst.hlp', tmpFileNamesList[6]);
    assertEqualsString('testParseAndExpandFileNames_HELP', 'C:\MPTN\dhcamst.hlp', tmpFileNamesList[7]);
    assertEqualsString('testParseAndExpandFileNames_HELP', 'C:\MPTN\dhcmmst.hlp', tmpFileNamesList[8]);
    assertEqualsString('testParseAndExpandFileNames_HELP', 'C:\MPTN\dipamst.hlp', tmpFileNamesList[9]);
    assertEqualsString('testParseAndExpandFileNames_HELP', 'C:\ecs\help\ae.hlp', tmpFileNamesList[10]);

    assertEqualsString('testParseAndExpandFileNames_HELP', 'C:\MMOS2\HELP\wepmplus.hlp', tmpFileNamesList[115]);

    tmpFileNamesList.Destroy;
  END;


  // ----------------------------------------------------------


  FUNCTION getCmdLineParameterUnitTests : TList;
  BEGIN
    result := TList.Create;

    result.add(@testParseCmdLine_Empty);

    result.add(@testParseCmdLine_QuestionMark);
    result.add(@testParseCmdLine_QuotedQuestionMark);
    result.add(@testParseCmdLine_lowerH);
    result.add(@testParseCmdLine_upperH);
    result.add(@testParseCmdLine_lowerHelp);
    result.add(@testParseCmdLine_upperHELP);
    result.add(@testParseCmdLine_upperHE);
    result.add(@testParseCmdLine_h_between);
    result.add(@testParseCmdLine_h_between_withSpace);

    result.add(@testParseCmdLine_lowerS);
    result.add(@testParseCmdLine_upperS);
    result.add(@testParseCmdLine_upperS_withBlank);
    result.add(@testParseCmdLine_QuotedS);
    result.add(@testParseCmdLine_emptyS);

    result.add(@testParseCmdLine_s_between);
    result.add(@testParseCmdLine_s_between_withSpace);
    result.add(@testParseCmdLine_help_and_s);
    result.add(@testParseCmdLine_s_and_help);
    result.add(@testParseCmdLine_help_and_s_without_blank);

    result.add(@testParseCmdLine_lowerG);
    result.add(@testParseCmdLine_upperG);
    result.add(@testParseCmdLine_QuotedG);
    result.add(@testParseCmdLine_emptyG);
    result.add(@testParseCmdLine_g_between);
    result.add(@testParseCmdLine_g_between_withSpace);

    result.add(@testParseCmdLine_lowerI);
    result.add(@testParseCmdLine_upperI);
    result.add(@testParseCmdLine_QuotedI);
    result.add(@testParseCmdLine_emptyI);
    result.add(@testParseCmdLine_i_between);
    result.add(@testParseCmdLine_i_between_withSpace);

    result.add(@testParseCmdLine_Language);

    result.add(@testParseCmdLine_Language_Empty);
    result.add(@testParseCmdLine_Language_Empty_WithColon);
    result.add(@testParseCmdLine_Language_WithFile);
    result.add(@testParseCmdLine_QuotedLanguage);
    result.add(@testParseCmdLine_QuotedLanguage2);
    result.add(@testParseCmdLine_Language_between);
    result.add(@testParseCmdLine_Language_between_withSpace);

    result.add(@testParseCmdLine_HelpManagerNumber);
    result.add(@testParseCmdLine_HelpManagerBigNumber);
    result.add(@testParseCmdLine_HelpManagerNumber_WithoutColon);
    result.add(@testParseCmdLine_HelpManagerNumber_Invalid);
    result.add(@testParseCmdLine_HelpManagerNumber_between);
    result.add(@testParseCmdLine_HelpManagerNumber_between_withSpace);

    result.add(@testParseCmdLine_OwnerNumber);
    result.add(@testParseCmdLine_OwnerNumber_WithoutColon);
    result.add(@testParseCmdLine_OwnerNumber_Invalid);
    result.add(@testParseCmdLine_OwnerNumber_between);
    result.add(@testParseCmdLine_OwnerNumber_between_withSpace);


    result.add(@testParseCmdLine_Title);
    result.add(@testParseCmdLine_Title_WithoutColon);
    result.add(@testParseCmdLine_Title_Empty);
    result.add(@testParseCmdLine_QuotedTitle);
    result.add(@testParseCmdLine_QuotedTitle2);
    result.add(@testParseCmdLine_QuotedTitle_AfterFile);
    result.add(@testParseCmdLine_Title_between);
    result.add(@testParseCmdLine_Title_between_withSpace);

    result.add(@testParseCmdLine_WindowPos);
    result.add(@testParseCmdLine_WindowPosPercentage);

    result.add(@testParseCmdLine_Topic);
    result.add(@testParseCmdLine_QuotedTopic);

    result.add(@testParseCmdLine_file);
    result.add(@testParseCmdLine_fileLeadingBlanks);
    result.add(@testParseCmdLine_fileTrailingBlanks);
    result.add(@testParseCmdLine_fileQuoted);
    result.add(@testParseCmdLine_fileQuotedMissingClosedQuote);
    result.add(@testParseCmdLine_fileQuotedAndText);
    result.add(@testParseCmdLine_fileQuotedAndTextManyBlanks);
    result.add(@testParseCmdLine_fileQuotedInside);

    result.add(@testParseCmdLine_SwitchAndFileQuoted);
    result.add(@testParseCmdLine_SwitchAndFileAndTextQuoted);

    result.add(@testParseCmdLine_ReallyLong);

    result.add(@testParseAndExpandFileNames_EmptyString);
    result.add(@testParseAndExpandFileNames_OneFile);
    result.add(@testParseAndExpandFileNames_TwoFiles);
    result.add(@testParseAndExpandFileNames_PlusAtEnd);
    result.add(@testParseAndExpandFileNames_GLOSSARY);
    result.add(@testParseAndExpandFileNames_GlossaryMixedCase);
    result.add(@testParseAndExpandFileNames_HELP);

  END;

END.
