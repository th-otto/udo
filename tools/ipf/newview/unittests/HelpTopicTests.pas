Unit HelpTopicTests;

Interface

uses
  Classes,
  TestAssert
  // HelpTopic
  ;

  FUNCTION getHelpTopicTests : TList;

Implementation

  PROCEDURE testTranslateIPFEscapeCode;
  VAR
    tmpResult : String;
    //tmpTopic : TTopic;
    // tmpFileHandle : HFILE;
  BEGIN
    // tmpTopic := TTopic.Create();
    // tmpResult := TTopic.Create.TranslateIPFEscapeCode();
    tmpResult := '';
    assertEqualsString('testGetBeginLink', '', tmpResult);
  END;


  FUNCTION getHelpTopicTests : TList;
  BEGIN
    result := TList.Create;

    result.add(@testTranslateIPFEscapeCode);
  END;

END.