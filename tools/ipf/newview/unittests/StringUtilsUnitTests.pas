Unit StringUtilsUnitTests;

// NewView - a new OS/2 Help Viewer
// Copyright 2006-2009 Ronald Brill (rbri at rbri dot de)
// This software is released under the GNU Public License - see readme.txt

// UnitTests for StringUtilsUnit

Interface

uses
  Classes,
  SysUtils,
  TestAssert,
  StringUtilsUnit;

  FUNCTION getStringUtilsUnitTests : TList;


Implementation

  PROCEDURE testTSerializableStringList_Construction;
  VAR
    tmpResult : TSerializableStringList;
  BEGIN
    tmpResult := TSerializableStringList.Create;

    assertEqualsInt('testTSerializableStringList_Construction', 0, tmpResult.getCount);

    tmpResult.Destroy;
  END;


  PROCEDURE testTSerializableStringList_Add;
  VAR
    tmpResult : TSerializableStringList;
  BEGIN
    tmpResult := TSerializableStringList.Create;

    tmpResult.add('Test');
    assertEqualsInt('testTSerializableStringList_Add', 1, tmpResult.getCount);

    tmpResult.Destroy;
  END;


  PROCEDURE testTSerializableStringList_Get_Empty;
  VAR
    tmpResult : TSerializableStringList;
  BEGIN
    tmpResult := TSerializableStringList.Create;

    assertEqualsInt('testTSerializableStringList_Get_Empty', 0, tmpResult.getCount);

    try
      tmpResult.get(0);
    except
      on e:EListError do
      begin
        assertEqualsString('testTSerializableStringList_Get', 'TList error exception (EListError) occured', e.message);
      end;
    end;

    tmpResult.Destroy;
  END;


  PROCEDURE testTSerializableStringList_Get;
  VAR
    tmpResult : TSerializableStringList;
  BEGIN
    tmpResult := TSerializableStringList.Create;

    tmpResult.add('First');
    tmpResult.add('Second');
    assertEqualsInt('testTSerializableStringList_Get', 2, tmpResult.getCount);
    assertEqualsString('testTSerializableStringList_Get', 'First', tmpResult.get(0));

    tmpResult.Destroy;
  END;


  PROCEDURE testTSerializableStringList_getSerializedString_Empty;
  VAR
    tmpResult : TSerializableStringList;
  BEGIN
    tmpResult := TSerializableStringList.Create;

    assertEqualsString('testTSerializableStringList_getSerializedString_Empty', '', tmpResult.getSerializedString);

    tmpResult.Destroy;
  END;


  PROCEDURE testTSerializableStringList_getSerializedString;
  VAR
    tmpResult : TSerializableStringList;
  BEGIN
    tmpResult := TSerializableStringList.Create;

    tmpResult.add('First');
    tmpResult.add('Second');
    assertEqualsString('testTSerializableStringList_getSerializedString', 'First&Second', tmpResult.getSerializedString);

    tmpResult.Destroy;
  END;


  PROCEDURE testTSerializableStringList_getSerializedString_WithBlanks;
  VAR
    tmpResult : TSerializableStringList;
  BEGIN
    tmpResult := TSerializableStringList.Create;

    tmpResult.add('Fi rst');
    tmpResult.add('Second');
    assertEqualsString('testTSerializableStringList_getSerializedString_WithBlanks', 'Fi rst&Second', tmpResult.getSerializedString);

    tmpResult.Destroy;
  END;


  PROCEDURE testTSerializableStringList_getSerializedString_Escaping;
  VAR
    tmpResult : TSerializableStringList;
  BEGIN
    tmpResult := TSerializableStringList.Create;

    tmpResult.add('F&i"r''st');
    tmpResult.add('Sec&ond');
    assertEqualsString('testTSerializableStringList_getSerializedString_WithBlanks', 'F\&i"r''st&Sec\&ond', tmpResult.getSerializedString);

    tmpResult.Destroy;
  END;


  PROCEDURE testTSerializableStringList_readValuesFromSerializedString;
  VAR
    tmpResult : TSerializableStringList;
    tmpSerialized : String;
  BEGIN
    tmpResult := TSerializableStringList.Create;

    tmpSerialized := 'First&Second';

    tmpResult.readValuesFromSerializedString(tmpSerialized);

    assertEqualsInt('testTSerializableStringList_readValuesFromSerializedString', 2, tmpResult.getCount);
    assertEqualsString('testTSerializableStringList_readValuesFromSerializedString', 'First', tmpResult.get(0));
    assertEqualsString('testTSerializableStringList_readValuesFromSerializedString', 'Second', tmpResult.get(1));

    tmpResult.Destroy;
  END;


  PROCEDURE testTSerializableStringList_readValuesFromSerializedString_quoted;
  VAR
    tmpResult : TSerializableStringList;
    tmpSerialized : String;
  BEGIN
    tmpResult := TSerializableStringList.Create;

    tmpSerialized := 'Fi\\nrst&Se\&cond';

    tmpResult.readValuesFromSerializedString(tmpSerialized);

    assertEqualsInt('testTSerializableStringList_readValuesFromSerializedString_quoted', 2, tmpResult.getCount);
    assertEqualsString('testTSerializableStringList_readValuesFromSerializedString_quoted', 'Fi\nrst', tmpResult.get(0));
    assertEqualsString('testTSerializableStringList_readValuesFromSerializedString_quoted', 'Se&cond', tmpResult.get(1));

    tmpResult.Destroy;
  END;


  PROCEDURE testTSerializableStringList_readValuesFromSerializedString_empty;
  VAR
    tmpResult : TSerializableStringList;
    tmpSerialized : String;
  BEGIN
    tmpResult := TSerializableStringList.Create;

    tmpSerialized := '';

    tmpResult.readValuesFromSerializedString(tmpSerialized);

    assertEqualsInt('testTSerializableStringList_readValuesFromSerializedString_empty', 0, tmpResult.getCount);

    tmpResult.Destroy;
  END;


  PROCEDURE testTSerializableStringList_readValuesFromSerializedString_firstempty;
  VAR
    tmpResult : TSerializableStringList;
    tmpSerialized : String;
  BEGIN
    tmpResult := TSerializableStringList.Create;

    tmpResult.add('');
    tmpResult.add('test');

    tmpSerialized := tmpResult.getSerializedString;

    tmpResult.readValuesFromSerializedString(tmpSerialized);

    assertEqualsInt('testTSerializableStringList_readValuesFromSerializedString_firstempty', 2, tmpResult.getCount);
    assertEqualsString('testTSerializableStringList_readValuesFromSerializedString_firstempty', '', tmpResult.get(0));
    assertEqualsString('testTSerializableStringList_readValuesFromSerializedString_firstempty', 'test', tmpResult.get(1));

    tmpResult.Destroy;
  END;


  PROCEDURE testTSerializableStringList_readValuesFromSerializedString_2;
  VAR
    tmpResult : TSerializableStringList;
    tmpSerialized : String;
  BEGIN
    tmpResult := TSerializableStringList.Create;

    tmpResult.add('&test&');
    tmpResult.add('"test"');
    tmpResult.add('');
    tmpResult.add('abc\&');
    tmpResult.add('\config.sys');

    tmpResult.add('');

    tmpSerialized := tmpResult.getSerializedString;

    tmpResult.readValuesFromSerializedString(tmpSerialized);

    assertEqualsInt('testTSerializableStringList_readValuesFromSerializedString_2', 6, tmpResult.getCount);
    assertEqualsString('testTSerializableStringList_readValuesFromSerializedString_2', '&test&', tmpResult.get(0));
    assertEqualsString('testTSerializableStringList_readValuesFromSerializedString_2', '"test"', tmpResult.get(1));
    assertEqualsString('testTSerializableStringList_readValuesFromSerializedString_2', '', tmpResult.get(2));
    assertEqualsString('testTSerializableStringList_readValuesFromSerializedString_2', 'abc\&', tmpResult.get(3));
    assertEqualsString('testTSerializableStringList_readValuesFromSerializedString_2', '\config.sys', tmpResult.get(4));
    assertEqualsString('testTSerializableStringList_readValuesFromSerializedString_2', '', tmpResult.get(5));

    tmpResult.Destroy;
  END;


  // ------------------------------------------------------


  PROCEDURE testEscapeAllCharsBy_Empty;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrEscapeAllCharsBy('', ['b'], '\');

    assertEqualsString('testEscapeAllCharsBy_Empty', '', tmpResult);
  END;


  PROCEDURE testEscapeAllCharsBy_EmptyChars;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrEscapeAllCharsBy('abcd', [], '\');

    assertEqualsString('testEscapeAllCharsBy_EmptyChars', 'abcd', tmpResult);
  END;


  PROCEDURE testEscapeAllCharsBy;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrEscapeAllCharsBy('abc', ['b'], '\');

    assertEqualsString('testEscapeAllCharsBy', 'a\bc', tmpResult);
  END;


  PROCEDURE testEscapeAllCharsBy_EscapeEscape;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrEscapeAllCharsBy('a\bc', ['b'], '\');

    assertEqualsString('testEscapeAllCharsBy_EscapeEscape', 'a\\\bc', tmpResult);
  END;


  PROCEDURE testEscapeAllCharsBy_NoCharactersToEscape;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrEscapeAllCharsBy('a\bc\\de', [], '\');

    assertEqualsString('testEscapeAllCharsBy_NoCharactersToEscape', 'a\\bc\\\\de', tmpResult);
  END;


  PROCEDURE testEscapeAllCharsBy_DoubleDoubleQuotes;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrEscapeAllCharsBy('"ab cd"e', [], '"');

    assertEqualsString('testEscapeAllCharsBy_DoubleDoubleQuotes', '""ab cd""e', tmpResult);
  END;


  // ------------------------------------------------------


  PROCEDURE testStrExtractStrings_EmptyReceiver;
  VAR
    tmpResult : TStringList;
  BEGIN
    tmpResult := TStringList.Create;
    StrExtractStrings(tmpResult, '', ['x'], '\');

    assertEqualsInt('testStrExtractStrings_EmptyReceiver', 0, tmpResult.count);
    tmpResult.Destroy;
  END;


  PROCEDURE testStrExtractStrings_OnlyOnePart;
  VAR
    tmpResult : TStringList;
  BEGIN
    tmpResult := TStringList.Create;
    StrExtractStrings(tmpResult, 'abcd', ['x'], '\');

    assertEqualsInt('testStrExtractStrings_OnlyOnePart', 1, tmpResult.count);
    assertEqualsString('testStrExtractStrings_OnlyOnePart', 'abcd', tmpResult[0]);

    tmpResult.Destroy;
  END;


  PROCEDURE testStrExtractStrings_ManyParts;
  VAR
    tmpResult : TStringList;
  BEGIN
    tmpResult := TStringList.Create;
    StrExtractStrings(tmpResult, 'abxcd', ['x'], '\');

    assertEqualsInt('testStrExtractStrings_ManyParts', 2, tmpResult.count);
    assertEqualsString('testStrExtractStrings_ManyParts', 'ab', tmpResult[0]);
    assertEqualsString('testStrExtractStrings_ManyParts', 'cd', tmpResult[1]);

    tmpResult.Destroy;
  END;


  PROCEDURE testStrExtractStrings_StartWithDelimiter;
  VAR
    tmpResult : TStringList;
  BEGIN
    tmpResult := TStringList.Create;
    StrExtractStrings(tmpResult, 'xab', ['x'], '\');

    assertEqualsInt('testStrExtractStrings_StartWithDelimiter', 2, tmpResult.count);
    assertEqualsString('testStrExtractStrings_StartWithDelimiter', '', tmpResult[0]);
    assertEqualsString('testStrExtractStrings_StartWithDelimiter', 'ab', tmpResult[1]);

    tmpResult.Destroy;
  END;


  PROCEDURE testStrExtractStrings_EndWithDelimiter;
  VAR
    tmpResult : TStringList;
  BEGIN
    tmpResult := TStringList.Create;
    StrExtractStrings(tmpResult, 'abx', ['x'], '\');

    assertEqualsInt('testStrExtractStrings_EndWithDelimiter', 2, tmpResult.count);
    assertEqualsString('testStrExtractStrings_EndWithDelimiter', 'ab', tmpResult[0]);
    assertEqualsString('testStrExtractStrings_EndWithDelimiter', '', tmpResult[1]);

    tmpResult.Destroy;
  END;


  PROCEDURE testStrExtractStrings_EmptyPartInside;
  VAR
    tmpResult : TStringList;
  BEGIN
    tmpResult := TStringList.Create;
    StrExtractStrings(tmpResult, 'axxb', ['x'], '\');

    assertEqualsInt('testStrExtractStrings_EmptyPartInside', 3, tmpResult.count);
    assertEqualsString('testStrExtractStrings_EmptyPartInside', 'a', tmpResult[0]);
    assertEqualsString('testStrExtractStrings_EmptyPartInside', '', tmpResult[1]);
    assertEqualsString('testStrExtractStrings_EmptyPartInside', 'b', tmpResult[2]);

    tmpResult.Destroy;
  END;


  PROCEDURE testStrExtractStrings_NoDelimiter;
  VAR
    tmpResult : TStringList;
  BEGIN
    tmpResult := TStringList.Create;
    StrExtractStrings(tmpResult, 'axxb', [], '\');

    assertEqualsInt('testStrExtractStrings_NoDelimiter', 1, tmpResult.count);
    assertEqualsString('testStrExtractStrings_NoDelimiter', 'axxb', tmpResult[0]);

    tmpResult.Destroy;
  END;


  PROCEDURE testStrExtractStrings_EscapedDelimiter;
  VAR
    tmpResult : TStringList;
  BEGIN
    tmpResult := TStringList.Create;
    StrExtractStrings(tmpResult, 'a\xb', ['x'], '\');

    assertEqualsInt('testStrExtractStrings_EscapedDelimiter', 1, tmpResult.count);
    assertEqualsString('testStrExtractStrings_EscapedDelimiter', 'axb', tmpResult[0]);

    tmpResult.Destroy;
  END;

  PROCEDURE testStrExtractStrings_EscapedEscapeChar;
  VAR
    tmpResult : TStringList;
  BEGIN
    tmpResult := TStringList.Create;
    StrExtractStrings(tmpResult, 'a\\xb', ['x'], '\');

    assertEqualsInt('testStrExtractStrings_EscapedEscapeChar', 2, tmpResult.count);
    assertEqualsString('testStrExtractStrings_EscapedEscapeChar', 'a\', tmpResult[0]);
    assertEqualsString('testStrExtractStrings_EscapedEscapeChar', 'b', tmpResult[1]);

    tmpResult.Destroy;
  END;

  PROCEDURE testStrExtractStrings_DelimiterSameAsEscapeChar;
  VAR
    tmpResult : TStringList;
  BEGIN
    tmpResult := TStringList.Create;
    StrExtractStrings(tmpResult, 'a;b;;cd;;;', [';'], ';');

    assertEqualsInt('testStrExtractStrings_EscapedEscapeChar', 3, tmpResult.count);
    assertEqualsString('testStrExtractStrings_EscapedEscapeChar', 'a', tmpResult[0]);
    assertEqualsString('testStrExtractStrings_EscapedEscapeChar', 'b;cd;', tmpResult[1]);
    assertEqualsString('testStrExtractStrings_EscapedEscapeChar', '', tmpResult[2]);

    tmpResult.Destroy;
  END;

  // ------------------------------------------------------


  PROCEDURE testStrExtractStringsIgnoreEmpty_EmptyReceiver;
  VAR
    tmpResult : TStringList;
  BEGIN
    tmpResult := TStringList.Create;
    StrExtractStringsIgnoreEmpty(tmpResult, '', ['x'], '\');

    assertEqualsInt('testStrExtractStringsIgnoreEmpty_EmptyReceiver', 0, tmpResult.count);
    tmpResult.Destroy;
  END;


  PROCEDURE testStrExtractStringsIgnoreEmpty_OnlyOnePart;
  VAR
    tmpResult : TStringList;
  BEGIN
    tmpResult := TStringList.Create;
    StrExtractStringsIgnoreEmpty(tmpResult, 'abcd', ['x'], '\');

    assertEqualsInt('testStrExtractStringsIgnoreEmpty_OnlyOnePart', 1, tmpResult.count);
    assertEqualsString('testStrExtractStringsIgnoreEmpty_OnlyOnePart', 'abcd', tmpResult[0]);

    tmpResult.Destroy;
  END;


  PROCEDURE testStrExtractStringsIgnoreEmpty_ManyParts;
  VAR
    tmpResult : TStringList;
  BEGIN
    tmpResult := TStringList.Create;
    StrExtractStringsIgnoreEmpty(tmpResult, 'abxcd', ['x'], '\');

    assertEqualsInt('testStrExtractStringsIgnoreEmpty_ManyParts', 2, tmpResult.count);
    assertEqualsString('testStrExtractStringsIgnoreEmpty_ManyParts', 'ab', tmpResult[0]);
    assertEqualsString('testStrExtractStringsIgnoreEmpty_ManyParts', 'cd', tmpResult[1]);

    tmpResult.Destroy;
  END;


  PROCEDURE testStrExtractStringsIgnoreEmpty_StartWithDelimiter;
  VAR
    tmpResult : TStringList;
  BEGIN
    tmpResult := TStringList.Create;
    StrExtractStringsIgnoreEmpty(tmpResult, 'xab', ['x'], '\');

    assertEqualsInt('testStrExtractStringsIgnoreEmpty_StartWithDelimiter', 1, tmpResult.count);
    assertEqualsString('testStrExtractStringsIgnoreEmpty_StartWithDelimiter', 'ab', tmpResult[0]);

    tmpResult.Destroy;
  END;


  PROCEDURE testStrExtractStringsIgnoreEmpty_EndWithDelimiter;
  VAR
    tmpResult : TStringList;
  BEGIN
    tmpResult := TStringList.Create;
    StrExtractStringsIgnoreEmpty(tmpResult, 'abx', ['x'], '\');

    assertEqualsInt('testStrExtractStringsIgnoreEmpty_EndWithDelimiter', 1, tmpResult.count);
    assertEqualsString('testStrExtractStringsIgnoreEmpty_EndWithDelimiter', 'ab', tmpResult[0]);

    tmpResult.Destroy;
  END;


  PROCEDURE testStrExtractStringsIgnoreEmpty_EmptyPartInside;
  VAR
    tmpResult : TStringList;
  BEGIN
    tmpResult := TStringList.Create;
    StrExtractStringsIgnoreEmpty(tmpResult, 'axxb', ['x'], '\');

    assertEqualsInt('testStrExtractStringsIgnoreEmpty_EmptyPartInside', 2, tmpResult.count);
    assertEqualsString('testStrExtractStringsIgnoreEmpty_EmptyPartInside', 'a', tmpResult[0]);
    assertEqualsString('testStrExtractStringsIgnoreEmpty_EmptyPartInside', 'b', tmpResult[1]);

    tmpResult.Destroy;
  END;


  PROCEDURE testStrExtractStringsIgnoreEmpty_NoDelimiter;
  VAR
    tmpResult : TStringList;
  BEGIN
    tmpResult := TStringList.Create;
    StrExtractStringsIgnoreEmpty(tmpResult, 'axxb', [], '\');

    assertEqualsInt('testStrExtractStringsIgnoreEmpty_NoDelimiter', 1, tmpResult.count);
    assertEqualsString('testStrExtractStringsIgnoreEmpty_NoDelimiter', 'axxb', tmpResult[0]);

    tmpResult.Destroy;
  END;


  PROCEDURE testStrExtractStringsIgnoreEmpty_EscapedDelimiter;
  VAR
    tmpResult : TStringList;
  BEGIN
    tmpResult := TStringList.Create;
    StrExtractStringsIgnoreEmpty(tmpResult, 'a\xb', ['x'], '\');

    assertEqualsInt('testStrExtractStringsIgnoreEmpty_EscapedDelimiter', 1, tmpResult.count);
    assertEqualsString('testStrExtractStringsIgnoreEmpty_EscapedDelimiter', 'axb', tmpResult[0]);

    tmpResult.Destroy;
  END;

  PROCEDURE testStrExtractStringsIgnoreEmpty_EscapedEscapeChar;
  VAR
    tmpResult : TStringList;
  BEGIN
    tmpResult := TStringList.Create;
    StrExtractStringsIgnoreEmpty(tmpResult, 'a\\xb', ['x'], '\');

    assertEqualsInt('testStrExtractStringsIgnoreEmpty_EscapedEscapeChar', 2, tmpResult.count);
    assertEqualsString('testStrExtractStringsIgnoreEmpty_EscapedEscapeChar', 'a\', tmpResult[0]);
    assertEqualsString('testStrExtractStringsIgnoreEmpty_EscapedEscapeChar', 'b', tmpResult[1]);

    tmpResult.Destroy;
  END;


  // -------------------------------------------------------------------


  PROCEDURE testTrimLeftChars_Empty;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrTrimLeftChars('', ['b', 'x']);

    assertEqualsString('testTrimLeftChars_Empty', '', tmpResult);
  END;


  PROCEDURE testTrimLeftChars_RemoveAll;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrTrimLeftChars('bxxxbx', ['b', 'x']);

    assertEqualsString('testTrimLeftChars_RemoveAll', '', tmpResult);
  END;


  PROCEDURE testTrimLeftChars_OneLeft;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrTrimLeftChars('bxy', ['b', 'x']);

    assertEqualsString('testTrimLeftChars_OneLeft', 'y', tmpResult);
  END;


  PROCEDURE testTrimLeftChars_LeftOnly;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrTrimLeftChars('bxbxxay', ['b', 'x']);

    assertEqualsString('testTrimLeftChars_LeftOnly', 'ay', tmpResult);
  END;


  PROCEDURE testTrimLeftChars_CharsInside;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrTrimLeftChars('bxabxvvx', ['b', 'x']);

    assertEqualsString('testTrimLeftChars_CharsInside', 'abxvvx', tmpResult);
  END;


  PROCEDURE testTrimLeftChars_Nothing;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrTrimLeftChars('acdef', ['b', 'x']);

    assertEqualsString('testTrimLeftChars_Nothing', 'acdef', tmpResult);
  END;


  // -------------------------------------------------------------------


  PROCEDURE testTrimRightChars_Empty;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrTrimRightChars('', ['b', 'x']);

    assertEqualsString('testTrimRightChars_Empty', '', tmpResult);
  END;


  PROCEDURE testTrimRightChars_RemoveAll;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrTrimRightChars('bxxxbx', ['b', 'x']);

    assertEqualsString('testTrimRightChars_RemoveAll', '', tmpResult);
  END;


  PROCEDURE testTrimRightChars_OneLeft;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrTrimRightChars('ybx', ['b', 'x']);

    assertEqualsString('testTrimRightChars_OneLeft', 'y', tmpResult);
  END;


  PROCEDURE testTrimRightChars_RightOnly;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrTrimRightChars('aybxbxx', ['b', 'x']);

    assertEqualsString('testTrimRightChars_RightOnly', 'ay', tmpResult);
  END;


  PROCEDURE testTrimRightChars_CharsInside;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrTrimRightChars('abxvvxb', ['b', 'x']);

    assertEqualsString('testTrimRightChars_CharsInside', 'abxvv', tmpResult);
  END;


  PROCEDURE testTrimRightChars_Nothing;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrTrimRightChars('acdef', ['b', 'x']);

    assertEqualsString('testTrimRightChars_Nothing', 'acdef', tmpResult);
  END;


  // -------------------------------------------------------------------

  PROCEDURE testTrimChars_Empty;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrTrimChars('', ['b', 'x']);

    assertEqualsString('testTrimChars_Empty', '', tmpResult);
  END;


  PROCEDURE testTrimChars_RemoveAll;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrTrimChars('bxxxbx', ['b', 'x']);

    assertEqualsString('testTrimChars_RemoveAll', '', tmpResult);
  END;


  PROCEDURE testTrimChars_OneLeftFromLeft;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrTrimChars('bxa', ['b', 'x']);

    assertEqualsString('testTrimChars_OneLeftFromLeft', 'a', tmpResult);
  END;


  PROCEDURE testTrimChars_OneLeftFromRight;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrTrimChars('abx', ['b', 'x']);

    assertEqualsString('testTrimChars_OneLeftFromRight', 'a', tmpResult);
  END;


  PROCEDURE testTrimChars_LeftOnly;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrTrimChars('bxbxxay', ['b', 'x']);

    assertEqualsString('testTrimChars_LeftOnly', 'ay', tmpResult);
  END;


  PROCEDURE testTrimChars_RightOnly;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrTrimChars('aybxbxx', ['b', 'x']);

    assertEqualsString('testTrimChars_LeftOnly', 'ay', tmpResult);
  END;


  PROCEDURE testTrimChars_CharsInside;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrTrimChars('bxabxvvx', ['b', 'x']);

    assertEqualsString('testTrimChars_CharsInside', 'abxvv', tmpResult);
  END;


  PROCEDURE testTrimChars_Nothing;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrTrimChars('acdef', ['b', 'x']);

    assertEqualsString('testTrimChars_Nothing', 'acdef', tmpResult);
  END;


  // -------------------------------------------------------------------


  PROCEDURE testTrim;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrTrim('  a bc ');

    assertEqualsString('testTrim', 'a bc', tmpResult);
  END;


  // -------------------------------------------------------------------


  PROCEDURE testStrLeft_Empty;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrLeft('', 1);

    assertEqualsString('testStrLeft_Empty', '', tmpResult);
  END;


  PROCEDURE testStrLeft_Nothing;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrLeft('abc', 0);

    assertEqualsString('testStrLeft_Nothing', '', tmpResult);
  END;


  PROCEDURE testStrLeft_WholeString;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrLeft('abc', 3);

    assertEqualsString('testStrLeft_WholeString', 'abc', tmpResult);
  END;

  PROCEDURE testStrLeft_ToManyRequested;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrLeft('abc', 5);

    assertEqualsString('testStrLeft_ToManyRequested', 'abc', tmpResult);
  END;

  PROCEDURE testStrLeft_Part;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrLeft('abcdef', 2);

    assertEqualsString('testStrLeft_Part', 'ab', tmpResult);
  END;


  // -------------------------------------------------------------------


  PROCEDURE testStrLeftWithout_Empty;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrLeftWithout('', 4);

    assertEqualsString('testStrLeftWithout_Empty', '', tmpResult);
  END;


  PROCEDURE testStrLeftWithout_ToBig;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrLeftWithout('ab', 4);

    assertEqualsString('testStrLeftWithout_ToBig', '', tmpResult);
  END;


  PROCEDURE testStrLeftWithout_Negative;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrLeftWithout('ab', -1);

    assertEqualsString('testStrLeftWithout_Negative', 'ab', tmpResult);
  END;


  PROCEDURE testStrLeftWithout_All;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrLeftWithout('abdefg', 6);

    assertEqualsString('testStrLeftWithout_All', '', tmpResult);
  END;


  PROCEDURE testStrLeftWithout;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrLeftWithout('abdefg', 3);

    assertEqualsString('testStrLeftWithout', 'abd', tmpResult);
  END;


  // -------------------------------------------------------------------


  PROCEDURE testStrLeftUntil_Empty;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrLeftUntil('', ['b', 'x']);

    assertEqualsString('testStrLeftUntil_Empty', '', tmpResult);
  END;


  PROCEDURE testStrLeftUntil_Empty_EmptyDelimiterSet;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrLeftUntil('', []);

    assertEqualsString('testStrLeftUntil_Empty_EmptyDelimiterSet', '', tmpResult);
  END;


  PROCEDURE testStrLeftUntil_EmptyDelimiterSet;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrLeftUntil('abc', []);

    assertEqualsString('testStrLeftUntil_EmptyDelimiterSet', 'abc', tmpResult);
  END;


  PROCEDURE testStrLeftUntil_FirstIsDelimiter;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrLeftUntil('abc', ['a']);

    assertEqualsString('testStrLeftUntil_FirstIsDelimiter', '', tmpResult);
  END;


  PROCEDURE testStrLeftUntil_LastIsDelimiter;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrLeftUntil('abc', ['c']);

    assertEqualsString('testStrLeftUntil_LastIsDelimiter', 'ab', tmpResult);
  END;


  PROCEDURE testStrLeftUntil_UnusedDelimiter;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrLeftUntil('abc', ['x']);

    assertEqualsString('testStrLeftUntil_UnusedDelimiter', 'abc', tmpResult);
  END;


  PROCEDURE testStrLeftUntil;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrLeftUntil('abcx yz do', ['d', ' ']);

    assertEqualsString('testStrLeftUntil', 'abcx', tmpResult);
  END;


  // -------------------------------------------------------------------


  PROCEDURE testStrSubstringFrom_Empty;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrSubstringFrom('', 1);

    assertEqualsString('testStrSubstringFrom_Empty', '', tmpResult);
  END;


  PROCEDURE testStrSubstringFrom_EmptyZeroPos;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrSubstringFrom('', 0);

    assertEqualsString('testStrSubstringFrom_EmptyZeroPos', '', tmpResult);
  END;


  PROCEDURE testStrSubstringFrom_EmptyNegativePos;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrSubstringFrom('', -4);

    assertEqualsString('testStrSubstringFrom_EmptyNegativePos', '', tmpResult);
  END;


  PROCEDURE testStrSubstringFrom_FullCopy;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrSubstringFrom('abcd', 1);

    assertEqualsString('testStrSubstringFrom_FullCopy', 'abcd', tmpResult);
  END;


  PROCEDURE testStrSubstringFrom_ZeroPos;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrSubstringFrom('abcd', 0);

    assertEqualsString('testStrSubstringFrom_ZeroPos', 'abcd', tmpResult);
  END;


  PROCEDURE testStrSubstringFrom_NegativePos;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrSubstringFrom('abcd', -4);

    assertEqualsString('testStrSubstringFrom_NegativePos', 'abcd', tmpResult);
  END;


  PROCEDURE testStrSubstringFrom_ToBigPos;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrSubstringFrom('abcd', 11);

    assertEqualsString('testStrSubstringFrom_ToBigPos', '', tmpResult);
  END;


  PROCEDURE testStrSubstringFrom;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrSubstringFrom('abcd', 2);

    assertEqualsString('testStrSubstringFrom', 'bcd', tmpResult);
  END;


  // -------------------------------------------------------------------


  PROCEDURE testStrStartsWith_BothEmpty;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrStartsWith('', '');

    assertTrue('testStrStartsWith_BothEmpty', tmpResult);
  END;


  PROCEDURE testStrStartsWith_StringEmpty;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrStartsWith('', 'end');

    assertFalse('testStrStartsWith_StringEmpty', tmpResult);
  END;


  PROCEDURE testStrStartsWith_MatchEmpty;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrStartsWith('test', '');

    assertTrue('testStrStartsWith_MatchEmpty', tmpResult);
  END;


  PROCEDURE testStrStartsWith_StringToShort;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrStartsWith('test', 'test1');

    assertFalse('testStrStartsWith_StringToShort', tmpResult);
  END;


  PROCEDURE testStrStartsWith_StringEqualLength;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrStartsWith('test', 'best');

    assertFalse('testStrStartsWith_StringEqualLength', tmpResult);
  END;


  PROCEDURE testStrStartsWith_StringEqualLengthMatch;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrStartsWith('test', 'test');

    assertTrue('testStrStartsWith_StringEqualLengthMatch', tmpResult);
  END;


  PROCEDURE testStrStartsWith_StringMatch;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrStartsWith('this is a simple test', 'this');

    assertTrue('testStrStartsWith_StringMatch', tmpResult);
  END;


  PROCEDURE testStrStartsWith_StringMatchCaseSensitive;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrStartsWith('This is a simple test', 'tHis');

    assertFalse('testStrStartsWith_StringMatchCaseSensitive', tmpResult);
  END;


  // -------------------------------------------------------------------


  PROCEDURE testStrStartsWithIgnoringCase_BothEmpty;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrStartsWithIgnoringCase('', '');

    assertTrue('testStrStartsWithIgnoringCase_BothEmpty', tmpResult);
  END;


  PROCEDURE testStrStartsWithIgnoringCase_StringEmpty;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrStartsWithIgnoringCase('', 'end');

    assertFalse('testStrStartsWithIgnoringCase_StringEmpty', tmpResult);
  END;


  PROCEDURE testStrStartsWithIgnoringCase_MatchEmpty;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrStartsWithIgnoringCase('test', '');

    assertTrue('testStrStartsWithIgnoringCase_MatchEmpty', tmpResult);
  END;


  PROCEDURE testStrStartsWithIgnoringCase_StringToShort;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrStartsWithIgnoringCase('test', 'test1');

    assertFalse('testStrStartsWithIgnoringCase_StringToShort', tmpResult);
  END;


  PROCEDURE testStrStartsWithIgnoringCase_StringEqualLength;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrStartsWithIgnoringCase('test', 'best');

    assertFalse('testStrStartsWithIgnoringCase_StringEqualLength', tmpResult);
  END;


  PROCEDURE testStrStartsWithIgnoringCase_StringEqualLengthMatch;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrStartsWithIgnoringCase('test', 'test');

    assertTrue('testStrStartsWithIgnoringCase_StringEqualLengthMatch', tmpResult);
  END;


  PROCEDURE testStrStartsWithIgnoringCase_StringMatch;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrStartsWithIgnoringCase('This is a simple test', 'This');

    assertTrue('testStrStartsWithIgnoringCase_StringMatch', tmpResult);
  END;


  PROCEDURE testStrStartsWithIgnoringCase_StringMatchCaseInSensitive;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrStartsWithIgnoringCase('ThiS is a simple test', 'THis');

    assertTrue('testStrStartsWithIgnoringCase_StringMatchCaseSensitive', tmpResult);
  END;


  // -------------------------------------------------------------------


  PROCEDURE testStrEndsWith_BothEmpty;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrEndsWith('', '');

    assertTrue('testStrEndsWith_BothEmpty', tmpResult);
  END;


  PROCEDURE testStrEndsWith_StringEmpty;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrEndsWith('', 'end');

    assertFalse('testStrEndsWith_StringEmpty', tmpResult);
  END;


  PROCEDURE testStrEndsWith_MatchEmpty;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrEndsWith('test', '');

    assertTrue('testStrEndsWith_MatchEmpty', tmpResult);
  END;


  PROCEDURE testStrEndsWith_StringToShort;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrEndsWith('test', 'test1');

    assertFalse('testStrEndsWith_StringToShort', tmpResult);
  END;


  PROCEDURE testStrEndsWith_StringEqualLength;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrEndsWith('test', 'best');

    assertFalse('testStrEndsWith_StringEqualLength', tmpResult);
  END;


  PROCEDURE testStrEndsWith_StringEqualLengthMatch;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrEndsWith('test', 'test');

    assertTrue('testStrEndsWith_StringEqualLengthMatch', tmpResult);
  END;


  PROCEDURE testStrEndsWith_StringMatch;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrEndsWith('a simple test', 'test');

    assertTrue('testStrEndsWith_StringMatch', tmpResult);
  END;


  PROCEDURE testStrEndsWith_StringMatchCaseSensitive;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrEndsWith('a simple tEst', 'test');

    assertFalse('testStrEndsWith_StringMatchCaseSensitive', tmpResult);
  END;


  PROCEDURE testStrEndsWithIgnoringCase_BothEmpty;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrEndsWithIgnoringCase('', '');

    assertTrue('testStrEndsWithIgnoringCase_BothEmpty', tmpResult);
  END;


  PROCEDURE testStrEndsWithIgnoringCase_StringEmpty;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrEndsWithIgnoringCase('', 'end');

    assertFalse('testStrEndsWithIgnoringCase_StringEmpty', tmpResult);
  END;


  PROCEDURE testStrEndsWithIgnoringCase_MatchEmpty;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrEndsWithIgnoringCase('test', '');

    assertTrue('testStrEndsWithIgnoringCase_MatchEmpty', tmpResult);
  END;


  PROCEDURE testStrEndsWithIgnoringCase_StringToShort;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrEndsWithIgnoringCase('test', 'test1');

    assertFalse('testStrEndsWithIgnoringCase_StringToShort', tmpResult);
  END;


  PROCEDURE testStrEndsWithIgnoringCase_StringEqualLength;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrEndsWithIgnoringCase('test', 'best');

    assertFalse('testStrEndsWithIgnoringCase_StringEqualLength', tmpResult);
  END;


  PROCEDURE testStrEndsWithIgnoringCase_StringEqualLengthMatch;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrEndsWithIgnoringCase('test', 'test');

    assertTrue('testStrEndsWithIgnoringCase_StringEqualLengthMatch', tmpResult);
  END;


  PROCEDURE testStrEndsWithIgnoringCase_StringMatch;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrEndsWithIgnoringCase('a simple test', 'test');

    assertTrue('testStrEndsWithIgnoringCase_StringMatch', tmpResult);
  END;


  PROCEDURE testStrEndsWithIgnoringCase_StringMatchCaseInSensitive;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrEndsWithIgnoringCase('a simple tEst', 'test');

    assertTrue('testStrEndsWithIgnoringCase_StringMatchCaseSensitive', tmpResult);
  END;


  // ----------------------------------------------------------


  PROCEDURE testStrIsEmptyOrSpaces_Empty;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrIsEmptyOrSpaces('');

    assertTrue('testStrIsEmptyOrSpaces_Empty', tmpResult);
  END;


  PROCEDURE testStrIsEmptyOrSpaces_OneSpace;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrIsEmptyOrSpaces(' ');

    assertTrue('testStrIsEmptyOrSpaces_OneSpace', tmpResult);
  END;


  PROCEDURE testStrIsEmptyOrSpaces_ManySpaces;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrIsEmptyOrSpaces('        ');

    assertTrue('testStrIsEmptyOrSpaces_ManySpaces', tmpResult);
  END;


  PROCEDURE testStrIsEmptyOrSpaces_OneChar;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrIsEmptyOrSpaces('a');

    assertFalse('testStrIsEmptyOrSpaces_OneChar', tmpResult);
  END;


  PROCEDURE testStrIsEmptyOrSpaces_ManyChars;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrIsEmptyOrSpaces('abcde');

    assertFalse('testStrIsEmptyOrSpaces_ManyChars', tmpResult);
  END;


  PROCEDURE testStrIsEmptyOrSpaces_SpacesWithOneChar;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrIsEmptyOrSpaces('       z     ');

    assertFalse('testStrIsEmptyOrSpaces_SpacesWithOneChar', tmpResult);
  END;


  PROCEDURE testStrIsEmptyOrSpaces_CharZero;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrIsEmptyOrSpaces(#0);

    assertFalse('testStrIsEmptyOrSpaces_CharZero', tmpResult);
  END;


  // ----------------------------------------------------------


  PROCEDURE testStrEqualIgnoringCase_BothEmpty;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrEqualIgnoringCase('', '');

    assertTrue('testStrEqualIgnoringCase_BothEmpty', tmpResult);
  END;


  PROCEDURE testStrEqualIgnoringCase_FirstEmpty;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrEqualIgnoringCase('', 'xy');

    assertFalse('testStrEqualIgnoringCase_FirstEmpty', tmpResult);
  END;

  PROCEDURE testStrEqualIgnoringCase_SecondEmpty;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrEqualIgnoringCase('xy', '');

    assertFalse('testStrEqualIgnoringCase_SecondEmpty', tmpResult);
  END;

  PROCEDURE testStrEqualIgnoringCase_DifferentLength;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrEqualIgnoringCase('xy', 'xyz');

    assertFalse('testStrEqualIgnoringCase_DifferentLength', tmpResult);
  END;

  PROCEDURE testStrEqualIgnoringCase_DifferentCase;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrEqualIgnoringCase('xYz', 'xyz');

    assertTrue('testStrEqualIgnoringCase_DifferentCase', tmpResult);
  END;

  PROCEDURE testStrEqualIgnoringCase;
  VAR
    tmpResult : Boolean;
  BEGIN
    tmpResult := StrEqualIgnoringCase('XYz', 'XYz');

    assertTrue('testStrEqualIgnoringCase', tmpResult);
  END;

  // ----------------------------------------------------------


  PROCEDURE testLongWordToStr_Zero;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := LongWordToStr(0);

    assertEqualsString('testLongWordToStr_Zero', '0', tmpResult);
  END;


  PROCEDURE testLongWordToStr_Four;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := LongWordToStr(4);

    assertEqualsString('testLongWordToStr_Four', '4', tmpResult);
  END;

  PROCEDURE testLongWordToStr_Max;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := LongWordToStr(4294967295);

    assertEqualsString('testLongWordToStr_Max', '4294967295', tmpResult);
  END;


  // ----------------------------------------------------------


  PROCEDURE testBoolToStr_true;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := BoolToStr(true);

    assertEqualsString('testBoolToStr_true', 'True', tmpResult);
  END;


  PROCEDURE testBoolToStr_false;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := BoolToStr(false);

    assertEqualsString('testBoolToStr_false', 'False', tmpResult);
  END;


  // ----------------------------------------------------------


  PROCEDURE testHexStrToLongInt_Empty;
  VAR
    tmpResult : LongInt;
  BEGIN
    tmpResult := -1;
    try
      tmpResult := HexStrToLongInt('');
    except
      on e:EConvertError do
      begin
        assertEqualsString('testHexStrToLongInt_Empty', 'No chars in hex string', e.message);
      end;
    end;


    assertEqualsInt('testHexStrToLongInt_Empty', -1, tmpResult);
  END;


  PROCEDURE testHexStrToLongInt_IllegalChar;
  VAR
    tmpResult : LongInt;
  BEGIN
    tmpResult := -1;
    try
      tmpResult := HexStrToLongInt('abG');
    except
      on e:EConvertError do
      begin
        assertEqualsString('testHexStrToLongInt_IllegalChar', 'Invalid hex char: ''G'' in hex string ''abG''.', e.message);
      end;
    end;


    assertEqualsInt('testHexStrToLongInt_IllegalChar', -1, tmpResult);
  END;


  PROCEDURE testHexStrToLongInt_IllegalCharMinus;
  VAR
    tmpResult : LongInt;
  BEGIN
    tmpResult := -1;
    try
      tmpResult := HexStrToLongInt('-F3');
    except
      on e:EConvertError do
      begin
        assertEqualsString('testHexStrToLongInt_IllegalCharMinus', 'Invalid hex char: ''-'' in hex string ''-F3''.', e.message);
      end;
    end;


    assertEqualsInt('testHexStrToLongInt_IllegalCharMinus', -1, tmpResult);
  END;


  PROCEDURE testHexStrToLongInt_Zero;
  VAR
    tmpResult : LongInt;
  BEGIN
    tmpResult := HexStrToLongInt('000');

    assertEqualsInt('testHexStrToLongInt_Zero', 0, tmpResult);
  END;


  PROCEDURE testHexStrToLongInt_Ten;
  VAR
    tmpResult : LongInt;
  BEGIN
    tmpResult := HexStrToLongInt('A');

    assertEqualsInt('testHexStrToLongInt_Ten', 10, tmpResult);
  END;


  PROCEDURE testHexStrToLongInt_Big;
  VAR
    tmpResult : LongInt;
  BEGIN
    tmpResult := HexStrToLongInt('7fffFFFF');

    assertEqualsLongWord('testHexStrToLongInt_Big', 2147483647, tmpResult);
  END;


  // ----------------------------------------------------------


  PROCEDURE testStrInSingleQuotes_Empty;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrInSingleQuotes('');

    assertEqualsString('testStrInSingleQuotes_Empty', '''''', tmpResult);
  END;


  PROCEDURE testStrInSingleQuotes;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrInSingleQuotes('abc');

    assertEqualsString('testStrInSingleQuotes', '''abc''', tmpResult);
  END;


  // ----------------------------------------------------------


  PROCEDURE testStrInDoubleQuotes_Empty;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrInDoubleQuotes('');

    assertEqualsString('testStrInDoubleQuotes_Empty', '""', tmpResult);
  END;


  PROCEDURE testStrInDoubleQuotes;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := StrInDoubleQuotes('abc');

    assertEqualsString('testStrInDoubleQuotes', '"abc"', tmpResult);
  END;


  // ----------------------------------------------------------


  PROCEDURE testStrExtractStringsQuoted_Empty;
  VAR
    tmpResult : TStringList;
    tmpString : String;
  BEGIN
    tmpResult := TStringList.Create;
    tmpString := '';

    StrExtractStringsQuoted(tmpResult, tmpString);
    assertEqualsInt('testStrExtractStringsQuoted_Empty', 0, tmpResult.count);

    tmpResult.Destroy;
  END;


  PROCEDURE testStrExtractStringsQuoted_OnlyWhitespace;
  VAR
    tmpResult : TStringList;
    tmpString : String;
  BEGIN
    tmpResult := TStringList.Create;
    tmpString := ' ' + StrTAB + '    ';

    StrExtractStringsQuoted(tmpResult, tmpString);
    assertEqualsInt('testStrExtractStringsQuoted_OnlyWhitespace', 0, tmpResult.count);

    tmpResult.Destroy;
  END;


  PROCEDURE testStrExtractStringsQuoted_OnlyText;
  VAR
    tmpResult : TStringList;
    tmpString : String;
  BEGIN
    tmpResult := TStringList.Create;
    tmpString := 'TeXt';

    StrExtractStringsQuoted(tmpResult, tmpString);
    assertEqualsInt('testStrExtractStringsQuoted_OnlyText', 1, tmpResult.count);
    assertEqualsString('testStrExtractStringsQuoted_OnlyText', 'TeXt', tmpResult[0]);

    tmpResult.Destroy;
  END;


  PROCEDURE testStrExtractStringsQuoted_OnlyText2Parts;
  VAR
    tmpResult : TStringList;
    tmpString : String;
  BEGIN
    tmpResult := TStringList.Create;
    tmpString := 'TeXt sample';

    StrExtractStringsQuoted(tmpResult, tmpString);
    assertEqualsInt('testStrExtractStringsQuoted_OnlyText2Parts', 2, tmpResult.count);
    assertEqualsString('testStrExtractStringsQuoted_OnlyText2Parts', 'TeXt', tmpResult[0]);
    assertEqualsString('testStrExtractStringsQuoted_OnlyText2Parts', 'sample', tmpResult[1]);

    tmpResult.Destroy;
  END;


  PROCEDURE testStrExtractStringsQuoted_TextAndWhitespace2Parts;
  VAR
    tmpResult : TStringList;
    tmpString : String;
  BEGIN
    tmpResult := TStringList.Create;
    tmpString := '  TeXt   ' + StrTAB + StrTAB + '  sample ' + StrTAB;

    StrExtractStringsQuoted(tmpResult, tmpString);
    assertEqualsInt('testStrExtractStringsQuoted_TextAndWhitespace2Parts', 2, tmpResult.count);
    assertEqualsString('testStrExtractStringsQuoted_TextAndWhitespace2Parts', 'TeXt', tmpResult[0]);
    assertEqualsString('testStrExtractStringsQuoted_TextAndWhitespace2Parts', 'sample', tmpResult[1]);

    tmpResult.Destroy;
  END;


  PROCEDURE testStrExtractStringsQuoted_QuotedText1Part;
  VAR
    tmpResult : TStringList;
    tmpString : String;
  BEGIN
    tmpResult := TStringList.Create;
    tmpString := '"TeXt"';

    StrExtractStringsQuoted(tmpResult, tmpString);
    assertEqualsInt('testStrExtractStringsQuoted_QuotedText1Part', 1, tmpResult.count);
    assertEqualsString('testStrExtractStringsQuoted_QuotedText1Part', 'TeXt', tmpResult[0]);

    tmpResult.Destroy;
  END;


  PROCEDURE testStrExtractStringsQuoted_QuotedText1PartNoClosingQuotes;
  VAR
    tmpResult : TStringList;
    tmpString : String;
  BEGIN
    tmpResult := TStringList.Create;
    tmpString := '"TeXt';

    StrExtractStringsQuoted(tmpResult, tmpString);
    assertEqualsInt('testStrExtractStringsQuoted_QuotedText1PartNoClosingQuotes', 1, tmpResult.count);
    assertEqualsString('testStrExtractStringsQuoted_QuotedText1PartNoClosingQuotes', 'TeXt', tmpResult[0]);

    tmpResult.Destroy;
  END;


  PROCEDURE testStrExtractStringsQuoted_QuotedText1PartNoClosingQuotesWhitewspace;
  VAR
    tmpResult : TStringList;
    tmpString : String;
  BEGIN
    tmpResult := TStringList.Create;
    tmpString := '"TeX t ';

    StrExtractStringsQuoted(tmpResult, tmpString);
    assertEqualsInt('testStrExtractStringsQuoted_QuotedText1PartNoClosingQuotesWhitewspace', 1, tmpResult.count);
    assertEqualsString('testStrExtractStringsQuoted_QuotedText1PartNoClosingQuotesWhitewspace', 'TeX t ', tmpResult[0]);

    tmpResult.Destroy;
  END;




  PROCEDURE testStrExtractStringsQuoted_QuotedText1PartQuoteInside;
  VAR
    tmpResult : TStringList;
    tmpString : String;
  BEGIN
    tmpResult := TStringList.Create;
    tmpString := '"TeX"t';

    StrExtractStringsQuoted(tmpResult, tmpString);
    assertEqualsInt('testStrExtractStringsQuoted_QuotedText1PartQuoteInside', 2, tmpResult.count);
    assertEqualsString('testStrExtractStringsQuoted_QuotedText1PartQuoteInside', 'TeX', tmpResult[0]);
    assertEqualsString('testStrExtractStringsQuoted_QuotedText1PartQuoteInside', 't', tmpResult[1]);

    tmpResult.Destroy;
  END;


  PROCEDURE testStrExtractStringsQuoted_QuotedText1Part2QuotesInside;
  VAR
    tmpResult : TStringList;
    tmpString : String;
  BEGIN
    tmpResult := TStringList.Create;
    tmpString := '"TeX""t"';

    StrExtractStringsQuoted(tmpResult, tmpString);
    assertEqualsInt('testStrExtractStringsQuoted_QuotedText1Part2QuotesInside', 1, tmpResult.count);
    assertEqualsString('testStrExtractStringsQuoted_QuotedText1Part2QuotesInside', 'TeX"t', tmpResult[0]);

    tmpResult.Destroy;
  END;


  PROCEDURE testStrExtractStringsQuoted_QuotedText1Part2Quotes;
  VAR
    tmpResult : TStringList;
    tmpString : String;
  BEGIN
    tmpResult := TStringList.Create;
    tmpString := '"""Te X""t"""';

    StrExtractStringsQuoted(tmpResult, tmpString);
    assertEqualsInt('testStrExtractStringsQuoted_QuotedText1Part2Quotes', 1, tmpResult.count);
    assertEqualsString('testStrExtractStringsQuoted_QuotedText1Part2Quotes', '"Te X"t"', tmpResult[0]);

    tmpResult.Destroy;
  END;


  PROCEDURE testStrExtractStringsQuoted_Only1Quote;
  VAR
    tmpResult : TStringList;
    tmpString : String;
  BEGIN
    tmpResult := TStringList.Create;
    tmpString := '"';

    StrExtractStringsQuoted(tmpResult, tmpString);
    assertEqualsInt('testStrExtractStringsQuoted_Only1Quote', 0, tmpResult.count);

    tmpResult.Destroy;
  END;


  PROCEDURE testStrExtractStringsQuoted_Only1QuoteAndWhitespace;
  VAR
    tmpResult : TStringList;
    tmpString : String;
  BEGIN
    tmpResult := TStringList.Create;
    tmpString := ' " ';

    StrExtractStringsQuoted(tmpResult, tmpString);
    assertEqualsInt('testStrExtractStringsQuoted_Only1QuoteAndWhitespace', 1, tmpResult.count);
    assertEqualsString('testStrExtractStringsQuoted_Only1QuoteAndWhitespace', ' ', tmpResult[0]);

    tmpResult.Destroy;
  END;


  PROCEDURE testStrExtractStringsQuoted_QuoteStartsNewPart;
  VAR
    tmpResult : TStringList;
    tmpString : String;
  BEGIN
    tmpResult := TStringList.Create;
    tmpString := 'ab"c"';

    StrExtractStringsQuoted(tmpResult, tmpString);
    assertEqualsInt('testStrExtractStringsQuoted_QuoteStartsNewPart', 2, tmpResult.count);
    assertEqualsString('testStrExtractStringsQuoted_QuoteStartsNewPart', 'ab', tmpResult[0]);
    assertEqualsString('testStrExtractStringsQuoted_QuoteStartsNewPart', 'c', tmpResult[1]);

    // note this is not compatible with the old behavior but more consistent
    // tmpIndex  := 1;
    // GetNextQuotedValue(tmpString, tmpIndex, s, '"');
    // assertEqualsString('testGetNextQuotedValue', 'ab"c"', s);

    tmpResult.Destroy;
  END;


  PROCEDURE testStrExtractStringsQuoted_ManyParts;
  VAR
    tmpResult : TStringList;
    tmpString : String;
  BEGIN
    tmpResult := TStringList.Create;
    tmpString := 'ab "c" """d" xy z  ""';

    StrExtractStringsQuoted(tmpResult, tmpString);
    assertEqualsInt('testStrExtractStringsQuoted_ManyParts', 6, tmpResult.count);
    assertEqualsString('testStrExtractStringsQuoted_ManyParts', 'ab', tmpResult[0]);
    assertEqualsString('testStrExtractStringsQuoted_ManyParts', 'c', tmpResult[1]);
    assertEqualsString('testStrExtractStringsQuoted_ManyParts', '"d', tmpResult[2]);
    assertEqualsString('testStrExtractStringsQuoted_ManyParts', 'xy', tmpResult[3]);
    assertEqualsString('testStrExtractStringsQuoted_ManyParts', 'z', tmpResult[4]);
    assertEqualsString('testStrExtractStringsQuoted_ManyParts', '', tmpResult[5]);

    tmpResult.Destroy;
  END;


  // ----------------------------------------------------------


  PROCEDURE testCaseInsensitivePos_Empty;
  VAR
    tmpResult : longint;
  BEGIN
    tmpResult := CaseInsensitivePos('', '');

    assertEqualsInt('testCaseInsensitivePos_Empty', Pos('', ''), tmpResult);
  END;


  PROCEDURE testCaseInsensitivePos_EmptyPart;
  VAR
    tmpResult : longint;
  BEGIN
    tmpResult := CaseInsensitivePos('', 'abc');

    assertEqualsInt('testCaseInsensitivePos_EmptyPart', Pos('', 'abc'), tmpResult);
  END;


  PROCEDURE testCaseInsensitivePos_EmptyString;
  VAR
    tmpResult : longint;
  BEGIN
    tmpResult := CaseInsensitivePos('abc', '');

    assertEqualsInt('testCaseInsensitivePos_EmptyString', Pos('abc', ''), tmpResult);
  END;


  PROCEDURE testCaseInsensitivePos_PartLarger;
  VAR
    tmpResult : longint;
  BEGIN
    tmpResult := CaseInsensitivePos('abc', 'ab');

    assertEqualsInt('testCaseInsensitivePos_PartLarger', Pos('abc', 'ab'), tmpResult);
  END;


  PROCEDURE testCaseInsensitivePos_AtLeft;
  VAR
    tmpResult : integer;
  BEGIN
    tmpResult := CaseInsensitivePos('abCd', 'aBcDef');

    assertEqualsInt('testCaseInsensitivePos_AtLeft', Pos('abcd', 'abcdef'), tmpResult);
  END;


  PROCEDURE testCaseInsensitivePos_Middle;
  VAR
    tmpResult : integer;
  BEGIN
    tmpResult := CaseInsensitivePos('abCd', '12aBcDef');

    assertEqualsInt('testCaseInsensitivePos_Middle', Pos('abcd', '12abcdef'), tmpResult);
  END;


  PROCEDURE testCaseInsensitivePos_AtRight;
  VAR
    tmpResult : integer;
  BEGIN
    tmpResult := CaseInsensitivePos('abCd', 'efaBcD');

    assertEqualsInt('testCaseInsensitivePos_AtRight', Pos('abcd', 'efabcd'), tmpResult);
  END;


  PROCEDURE testCaseInsensitivePos;
  VAR
    tmpPart : String;
    tmpString : String;
    tmpResult,i : integer;
  BEGIN
    tmpPart := '';
    tmpString := '';

    for i:=1 to 255 do
    begin
      tmpPart := tmpPart + char(i);
      tmpString := tmpString + char(i);
    end;

    tmpResult := CaseInsensitivePos(tmpPart, UpperCase(tmpString));
    assertEqualsInt('testCaseInsensitivePos', 1, tmpResult);

    tmpResult := CaseInsensitivePos(UpperCase(tmpPart), tmpString);
    assertEqualsInt('testCaseInsensitivePos', 1, tmpResult);

    tmpResult := CaseInsensitivePos(tmpPart, LowerCase(tmpString));
    assertEqualsInt('testCaseInsensitivePos', 1, tmpResult);

    tmpResult := CaseInsensitivePos(LowerCase(tmpPart), tmpString);
    assertEqualsInt('testCaseInsensitivePos', 1, tmpResult);
  END;


  // -------------------------------------------------------------------


  PROCEDURE testLastPosOfChar_Empty;
  VAR
    tmpResult : longint;
  BEGIN
    tmpResult := LastPosOfChar('x', '');

    assertEqualsInt('testLastPosOfChar_Empty', 0, tmpResult);
  END;


  PROCEDURE testLastPosOfChar_NotFound;
  VAR
    tmpResult : longint;
  BEGIN
    tmpResult := LastPosOfChar('x', 'abcd');

    assertEqualsInt('testLastPosOfChar_NotFound', 0, tmpResult);
  END;


  PROCEDURE testLastPosOfChar_OneCharNotFound;
  VAR
    tmpResult : longint;
  BEGIN
    tmpResult := LastPosOfChar('x', 'a');

    assertEqualsInt('testLastPosOfChar_OneCharNotFound', 0, tmpResult);
  END;


  PROCEDURE testLastPosOfChar_OneCharFound;
  VAR
    tmpResult : longint;
  BEGIN
    tmpResult := LastPosOfChar('x', 'x');

    assertEqualsInt('testLastPosOfChar_OneCharFound', 1, tmpResult);
  END;


  PROCEDURE testLastPosOfChar_OneCharWrongCase;
  VAR
    tmpResult : longint;
  BEGIN
    tmpResult := LastPosOfChar('x', 'X');

    assertEqualsInt('testLastPosOfChar_OneCharWrongCase', 0, tmpResult);
  END;


  PROCEDURE testLastPosOfChar_FirstChar;
  VAR
    tmpResult : longint;
  BEGIN
    tmpResult := LastPosOfChar('x', 'xabcd');

    assertEqualsInt('testLastPosOfChar_FirstChar', 1, tmpResult);
  END;


  PROCEDURE testLastPosOfChar_LastChar;
  VAR
    tmpResult : longint;
  BEGIN
    tmpResult := LastPosOfChar('x', 'abcdx');

    assertEqualsInt('testLastPosOfChar_LastChar', 5, tmpResult);
  END;


  PROCEDURE testLastPosOfChar_MiddleChar;
  VAR
    tmpResult : longint;
  BEGIN
    tmpResult := LastPosOfChar('x', 'abcdxwertzu');

    assertEqualsInt('testLastPosOfChar_MiddleChar', 5, tmpResult);
  END;


  PROCEDURE testLastPosOfChar_ManyHits;
  VAR
    tmpResult : longint;
  BEGIN
    tmpResult := LastPosOfChar('x', 'axbcxdxu');

    assertEqualsInt('testLastPosOfChar_ManyHits', 7, tmpResult);
  END;


  // -------------------------------------------------------------------


  PROCEDURE testSubstituteAllOccurencesOfChar_Empty;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := '';
    SubstituteAllOccurencesOfChar(tmpResult, 'x', 'y');

    assertEqualsString('testSubstituteAllOccurencesOfChar_Empty', '', tmpResult);
  END;


  PROCEDURE testSubstituteAllOccurencesOfChar_NotFound;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := 'abc';
    SubstituteAllOccurencesOfChar(tmpResult, 'x', 'y');

    assertEqualsString('testSubstituteAllOccurencesOfChar_NotFound', 'abc', tmpResult);
  END;


  PROCEDURE testSubstituteAllOccurencesOfChar_OneCharReplace;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := 'x';
    SubstituteAllOccurencesOfChar(tmpResult, 'x', 'y');

    assertEqualsString('testSubstituteAllOccurencesOfChar_OneCharReplace', 'y', tmpResult);
  END;


  PROCEDURE testSubstituteAllOccurencesOfChar_ReplaceAll;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := 'xxxx';
    SubstituteAllOccurencesOfChar(tmpResult, 'x', 'y');

    assertEqualsString('testSubstituteAllOccurencesOfChar_ReplaceAll', 'yyyy', tmpResult);
  END;


  PROCEDURE testSubstituteAllOccurencesOfChar_Some;
  VAR
    tmpResult : String;
  BEGIN
    tmpResult := 'xabxcxddx';
    SubstituteAllOccurencesOfChar(tmpResult, 'x', 'y');

    assertEqualsString('testSubstituteAllOccurencesOfChar_Some', 'yabycyddy', tmpResult);
  END;


  // --------------------
  // ---- AnsiString ----
  // --------------------


  PROCEDURE testAnsiTrimLeftChars_Empty;
  VAR
    tmpResult : AnsiString;
    tmpValue : AnsiString;
  BEGIN
    tmpValue := '';
    tmpResult := AnsiStrTrimLeftChars(tmpValue, ['b', 'x']);

    assertEqualsAnsiString('testAnsiTrimLeftChars_Empty', '', tmpResult);
  END;


  PROCEDURE testAnsiTrimLeftChars_RemoveAll;
  VAR
    tmpResult : AnsiString;
    tmpValue : AnsiString;
  BEGIN
    tmpValue := 'bxxxbx';
    tmpResult := AnsiStrTrimLeftChars(tmpValue, ['b', 'x']);

    assertEqualsAnsiString('testAnsiTrimLeftChars_RemoveAll', '', tmpResult);
  END;


  PROCEDURE testAnsiTrimLeftChars_OneLeft;
  VAR
    tmpResult : AnsiString;
    tmpValue : AnsiString;
  BEGIN
    tmpValue := 'bxy';
    tmpResult := AnsiStrTrimLeftChars(tmpValue, ['b', 'x']);

    assertEqualsAnsiString('testAnsiTrimLeftChars_OneLeft', 'y', tmpResult);
  END;


  PROCEDURE testAnsiTrimLeftChars_LeftOnly;
  VAR
    tmpResult : AnsiString;
    tmpValue : AnsiString;
  BEGIN
    tmpValue := 'bxbxxay';
    tmpResult := AnsiStrTrimLeftChars(tmpValue, ['b', 'x']);

    assertEqualsAnsiString('testAnsiTrimLeftChars_LeftOnly', 'ay', tmpResult);
  END;


  PROCEDURE testAnsiTrimLeftChars_CharsInside;
  VAR
    tmpResult : AnsiString;
    tmpValue : AnsiString;
  BEGIN
    tmpValue := 'bxabxvvx';
    tmpResult := AnsiStrTrimLeftChars(tmpValue, ['b', 'x']);

    assertEqualsAnsiString('testAnsiTrimLeftChars_CharsInside', 'abxvvx', tmpResult);
  END;


  PROCEDURE testAnsiTrimLeftChars_Nothing;
  VAR
    tmpResult : AnsiString;
    tmpValue : AnsiString;
  BEGIN
    tmpValue := 'acdef';
    tmpResult := AnsiStrTrimLeftChars('acdef', ['b', 'x']);

    assertEqualsAnsiString('testAnsiTrimLeftChars_Nothing', 'acdef', tmpResult);
  END;


  PROCEDURE testAnsiTrimLeftChars_ReallyLong;
  VAR
    tmpResult : AnsiString;
    tmpValue : AnsiString;
  BEGIN
    tmpValue := '0123456789';
    tmpValue := tmpValue + tmpValue;
    tmpValue := tmpValue + tmpValue;
    tmpValue := tmpValue + tmpValue;
    tmpValue := tmpValue + tmpValue;
    tmpValue := tmpValue + tmpValue;
    assertEqualsInt('testAnsiTrimLeftChars_ReallyLong', 320, Length(tmpValue));

    tmpResult := AnsiStrTrimLeftChars(tmpValue, ['0', '1']);

    assertEqualsInt('testAnsiTrimLeftChars_ReallyLong', 318, Length(tmpResult));
  END;


  // -------------------------------------------------------------------


  PROCEDURE testAnsiTrimRightChars_Empty;
  VAR
    tmpResult : AnsiString;
    tmpValue : AnsiString;
  BEGIN
    tmpValue := '';
    tmpResult := AnsiStrTrimRightChars(tmpValue, ['b', 'x']);

    assertEqualsAnsiString('testAnsiTrimRightChars_Empty', '', tmpResult);
  END;


  PROCEDURE testAnsiTrimRightChars_RemoveAll;
  VAR
    tmpResult : AnsiString;
    tmpValue : AnsiString;
  BEGIN
    tmpValue := 'bxxxbx';
    tmpResult := AnsiStrTrimRightChars(tmpValue, ['b', 'x']);

    assertEqualsAnsiString('testAnsiTrimRightChars_RemoveAll', '', tmpResult);
  END;


  PROCEDURE testAnsiTrimRightChars_OneLeft;
  VAR
    tmpResult : AnsiString;
    tmpValue : AnsiString;
  BEGIN
    tmpValue := 'ybx';
    tmpResult := AnsiStrTrimRightChars(tmpValue, ['b', 'x']);

    assertEqualsAnsiString('testAnsiTrimRightChars_OneLeft', 'y', tmpResult);
  END;


  PROCEDURE testAnsiTrimRightChars_RightOnly;
  VAR
    tmpResult : AnsiString;
    tmpValue : AnsiString;
  BEGIN
    tmpValue := 'aybxbxx';
    tmpResult := AnsiStrTrimRightChars(tmpValue, ['b', 'x']);

    assertEqualsAnsiString('testAnsiTrimRightChars_RightOnly', 'ay', tmpResult);
  END;


  PROCEDURE testAnsiTrimRightChars_CharsInside;
  VAR
    tmpResult : AnsiString;
    tmpValue : AnsiString;
  BEGIN
    tmpValue := 'abxvvxb';
    tmpResult := AnsiStrTrimRightChars(tmpValue, ['b', 'x']);

    assertEqualsAnsiString('testAnsiTrimRightChars_CharsInside', 'abxvv', tmpResult);
  END;


  PROCEDURE testAnsiTrimRightChars_Nothing;
  VAR
    tmpResult : AnsiString;
    tmpValue : AnsiString;
  BEGIN
    tmpValue := 'acdef';
    tmpResult := AnsiStrTrimRightChars(tmpValue, ['b', 'x']);

    assertEqualsAnsiString('testAnsiTrimRightChars_Nothing', 'acdef', tmpResult);
  END;


  PROCEDURE testAnsiTrimRightChars_ReallyLong;
  VAR
    tmpResult : AnsiString;
    tmpValue : AnsiString;
  BEGIN
    tmpValue := '0123456789';
    tmpValue := tmpValue + tmpValue;
    tmpValue := tmpValue + tmpValue;
    tmpValue := tmpValue + tmpValue;
    tmpValue := tmpValue + tmpValue;
    tmpValue := tmpValue + tmpValue;
    assertEqualsInt('testAnsiTrimRightChars_ReallyLong', 320, Length(tmpValue));

    tmpResult := AnsiStrTrimRightChars(tmpValue, ['8', '9']);

    assertEqualsInt('testAnsiTrimRightChars_ReallyLong', 318, Length(tmpResult));
  END;


  // -------------------------------------------------------------------

  PROCEDURE testAnsiTrimChars_Empty;
  VAR
    tmpResult : AnsiString;
    tmpValue : AnsiString;
  BEGIN
    tmpValue := '';
    tmpResult := AnsiStrTrimChars(tmpValue, ['b', 'x']);

    assertEqualsAnsiString('testAnsiTrimChars_Empty', '', tmpResult);
  END;


  PROCEDURE testAnsiTrimChars_RemoveAll;
  VAR
    tmpResult : AnsiString;
    tmpValue : AnsiString;
  BEGIN
    tmpValue := 'bxxxbx';
    tmpResult := AnsiStrTrimChars(tmpValue, ['b', 'x']);

    assertEqualsAnsiString('testAnsiTrimChars_RemoveAll', '', tmpResult);
  END;


  PROCEDURE testAnsiTrimChars_OneLeftFromLeft;
  VAR
    tmpResult : AnsiString;
    tmpValue : AnsiString;
  BEGIN
    tmpValue := 'bxa';
    tmpResult := AnsiStrTrimChars(tmpValue, ['b', 'x']);

    assertEqualsAnsiString('testAnsiTrimChars_OneLeftFromLeft', 'a', tmpResult);
  END;


  PROCEDURE testAnsiTrimChars_OneLeftFromRight;
  VAR
    tmpResult : AnsiString;
    tmpValue : AnsiString;
  BEGIN
    tmpValue := 'abx';
    tmpResult := AnsiStrTrimChars(tmpValue, ['b', 'x']);

    assertEqualsAnsiString('testAnsiTrimChars_OneLeftFromRight', 'a', tmpResult);
  END;


  PROCEDURE testAnsiTrimChars_LeftOnly;
  VAR
    tmpResult : AnsiString;
    tmpValue : AnsiString;
  BEGIN
    tmpValue := 'bxbxxay';
    tmpResult := AnsiStrTrimChars(tmpValue, ['b', 'x']);

    assertEqualsAnsiString('testAnsiTrimChars_LeftOnly', 'ay', tmpResult);
  END;


  PROCEDURE testAnsiTrimChars_RightOnly;
  VAR
    tmpResult : AnsiString;
    tmpValue : AnsiString;
  BEGIN
    tmpValue := 'aybxbxx';
    tmpResult := AnsiStrTrimChars(tmpValue, ['b', 'x']);

    assertEqualsAnsiString('testAnsiTrimChars_LeftOnly', 'ay', tmpResult);
  END;


  PROCEDURE testAnsiTrimChars_CharsInside;
  VAR
    tmpResult : AnsiString;
    tmpValue : AnsiString;
  BEGIN
    tmpValue := 'bxabxvvx';
    tmpResult := AnsiStrTrimChars(tmpValue, ['b', 'x']);

    assertEqualsAnsiString('testAnsiTrimChars_CharsInside', 'abxvv', tmpResult);
  END;


  PROCEDURE testAnsiTrimChars_Nothing;
  VAR
    tmpResult : AnsiString;
    tmpValue : AnsiString;
  BEGIN
    tmpValue := 'acdef';
    tmpResult := AnsiStrTrimChars(tmpValue, ['b', 'x']);

    assertEqualsAnsiString('testAnsiTrimChars_Nothing', 'acdef', tmpResult);
  END;


  PROCEDURE testAnsiTrimChars_ReallyLong;
  VAR
    tmpResult : AnsiString;
    tmpValue : AnsiString;
  BEGIN
    tmpValue := '0123456789';
    tmpValue := tmpValue + tmpValue;
    tmpValue := tmpValue + tmpValue;
    tmpValue := tmpValue + tmpValue;
    tmpValue := tmpValue + tmpValue;
    tmpValue := tmpValue + tmpValue;
    assertEqualsInt('testAnsiTrimChars_ReallyLong', 320, Length(tmpValue));

    tmpResult := AnsiStrTrimChars(tmpValue, ['8', '9', '0', '1']);

    assertEqualsInt('testAnsiTrimChars_ReallyLong', 316, Length(tmpResult));
  END;


  // -------------------------------------------------------------------


  PROCEDURE testAnsiTrim;
  VAR
    tmpResult : String;
    tmpValue : AnsiString;
  BEGIN
    tmpValue := '  a bc ';
    tmpResult := AnsiStrTrim(tmpValue);

    assertEqualsAnsiString('testAnsiTrim', 'a bc', tmpResult);
  END;


  PROCEDURE testAnsiTrim_ReallyLong;
  VAR
    tmpResult : AnsiString;
    tmpValue : AnsiString;
  BEGIN
    tmpValue := '0123456789';
    tmpValue := tmpValue + tmpValue;
    tmpValue := tmpValue + tmpValue;
    tmpValue := tmpValue + tmpValue;
    tmpValue := tmpValue + tmpValue;
    tmpValue := tmpValue + tmpValue;
    tmpValue := '  ' + tmpValue + '    ';
    assertEqualsInt('testAnsiTrim_ReallyLong', 326, Length(tmpValue));

    tmpResult := AnsiStrTrim(tmpValue);

    assertEqualsInt('testAnsiTrim_ReallyLong', 320, Length(tmpResult));
  END;


  // -------------------------------------------------------------------


  FUNCTION getStringUtilsUnitTests : TList;
  BEGIN
    result := TList.Create;

    result.add(@testTSerializableStringList_Construction);
    result.add(@testTSerializableStringList_Add);
    result.add(@testTSerializableStringList_Get_Empty);
    result.add(@testTSerializableStringList_Get);
    result.add(@testTSerializableStringList_getSerializedString_Empty);
    result.add(@testTSerializableStringList_getSerializedString);
    result.add(@testTSerializableStringList_getSerializedString);
    result.add(@testTSerializableStringList_getSerializedString_WithBlanks);
    result.add(@testTSerializableStringList_getSerializedString_Escaping);
    result.add(@testTSerializableStringList_readValuesFromSerializedString);
    result.add(@testTSerializableStringList_readValuesFromSerializedString_quoted);
    result.add(@testTSerializableStringList_readValuesFromSerializedString_empty);
    result.add(@testTSerializableStringList_readValuesFromSerializedString_firstempty);
    result.add(@testTSerializableStringList_readValuesFromSerializedString_2);

    result.add(@testEscapeAllCharsBy);
    result.add(@testEscapeAllCharsBy_Empty);
    result.add(@testEscapeAllCharsBy_EmptyChars);
    result.add(@testEscapeAllCharsBy_EscapeEscape);
    result.add(@testEscapeAllCharsBy_NoCharactersToEscape);
    result.add(@testEscapeAllCharsBy_DoubleDoubleQuotes);

    result.add(@testStrExtractStrings_EmptyReceiver);
    result.add(@testStrExtractStrings_OnlyOnePart);
    result.add(@testStrExtractStrings_ManyParts);
    result.add(@testStrExtractStrings_StartWithDelimiter);
    result.add(@testStrExtractStrings_EndWithDelimiter);
    result.add(@testStrExtractStrings_EmptyPartInside);
    result.add(@testStrExtractStrings_NoDelimiter);
    result.add(@testStrExtractStrings_EscapedDelimiter);
    result.add(@testStrExtractStrings_EscapedEscapeChar);
    result.add(@testStrExtractStrings_DelimiterSameAsEscapeChar);

    result.add(@testStrExtractStringsIgnoreEmpty_EmptyReceiver);
    result.add(@testStrExtractStringsIgnoreEmpty_OnlyOnePart);
    result.add(@testStrExtractStringsIgnoreEmpty_ManyParts);
    result.add(@testStrExtractStringsIgnoreEmpty_StartWithDelimiter);
    result.add(@testStrExtractStringsIgnoreEmpty_EndWithDelimiter);
    result.add(@testStrExtractStringsIgnoreEmpty_EmptyPartInside);
    result.add(@testStrExtractStringsIgnoreEmpty_NoDelimiter);
    result.add(@testStrExtractStringsIgnoreEmpty_EscapedDelimiter);
    result.add(@testStrExtractStringsIgnoreEmpty_EscapedEscapeChar);

    result.add(@testTrimLeftChars_Empty);
    result.add(@testTrimLeftChars_RemoveAll);
    result.add(@testTrimLeftChars_OneLeft);
    result.add(@testTrimLeftChars_LeftOnly);
    result.add(@testTrimLeftChars_CharsInside);
    result.add(@testTrimLeftChars_Nothing);

    result.add(@testTrimRightChars_Empty);
    result.add(@testTrimRightChars_RemoveAll);
    result.add(@testTrimRightChars_OneLeft);
    result.add(@testTrimRightChars_RightOnly);
    result.add(@testTrimRightChars_CharsInside);
    result.add(@testTrimRightChars_Nothing);

    result.add(@testTrimChars_Empty);
    result.add(@testTrimChars_RemoveAll);
    result.add(@testTrimChars_OneLeftFromLeft);
    result.add(@testTrimChars_OneLeftFromRight);
    result.add(@testTrimChars_LeftOnly);
    result.add(@testTrimChars_RightOnly);
    result.add(@testTrimChars_CharsInside);
    result.add(@testTrimChars_Nothing);

    result.add(@testTrim);

    result.add(@testStrLeft_Empty);
    result.add(@testStrLeft_Nothing);
    result.add(@testStrLeft_WholeString);
    result.add(@testStrLeft_ToManyRequested);
    result.add(@testStrLeft_Part);

    result.add(@testStrLeftWithout_Empty);
    result.add(@testStrLeftWithout_ToBig);
    result.add(@testStrLeftWithout_Negative);
    result.add(@testStrLeftWithout_All);
    result.add(@testStrLeftWithout);

    result.add(@testStrLeftUntil_Empty);
    result.add(@testStrLeftUntil_Empty_EmptyDelimiterSet);
    result.add(@testStrLeftUntil_EmptyDelimiterSet);
    result.add(@testStrLeftUntil_FirstIsDelimiter);
    result.add(@testStrLeftUntil_LastIsDelimiter);
    result.add(@testStrLeftUntil_UnusedDelimiter);
    result.add(@testStrLeftUntil);

    result.add(@testStrSubstringFrom_Empty);
    result.add(@testStrSubstringFrom_EmptyZeroPos);
    result.add(@testStrSubstringFrom_EmptyNegativePos);
    result.add(@testStrSubstringFrom_FullCopy);
    result.add(@testStrSubstringFrom_ZeroPos);
    result.add(@testStrSubstringFrom_NegativePos);
    result.add(@testStrSubstringFrom_ToBigPos);
    result.add(@testStrSubstringFrom);

    result.add(@testStrStartsWith_BothEmpty);
    result.add(@testStrStartsWith_StringEmpty);
    result.add(@testStrStartsWith_MatchEmpty);
    result.add(@testStrStartsWith_StringToShort);
    result.add(@testStrStartsWith_StringEqualLength);
    result.add(@testStrStartsWith_StringEqualLengthMatch);
    result.add(@testStrStartsWith_StringMatch);
    result.add(@testStrStartsWith_StringMatchCaseSensitive);

    result.add(@testStrStartsWithIgnoringCase_BothEmpty);
    result.add(@testStrStartsWithIgnoringCase_StringEmpty);
    result.add(@testStrStartsWithIgnoringCase_MatchEmpty);
    result.add(@testStrStartsWithIgnoringCase_StringToShort);
    result.add(@testStrStartsWithIgnoringCase_StringEqualLength);
    result.add(@testStrStartsWithIgnoringCase_StringEqualLengthMatch);
    result.add(@testStrStartsWithIgnoringCase_StringMatch);
    result.add(@testStrStartsWithIgnoringCase_StringMatchCaseInSensitive);

    result.add(@testStrEndsWith_BothEmpty);
    result.add(@testStrEndsWith_StringEmpty);
    result.add(@testStrEndsWith_MatchEmpty);
    result.add(@testStrEndsWith_StringToShort);
    result.add(@testStrEndsWith_StringEqualLength);
    result.add(@testStrEndsWith_StringEqualLengthMatch);
    result.add(@testStrEndsWith_StringMatch);
    result.add(@testStrEndsWith_StringMatchCaseSensitive);

    result.add(@testStrEndsWithIgnoringCase_BothEmpty);
    result.add(@testStrEndsWithIgnoringCase_StringEmpty);
    result.add(@testStrEndsWithIgnoringCase_MatchEmpty);
    result.add(@testStrEndsWithIgnoringCase_StringToShort);
    result.add(@testStrEndsWithIgnoringCase_StringEqualLength);
    result.add(@testStrEndsWithIgnoringCase_StringEqualLengthMatch);
    result.add(@testStrEndsWithIgnoringCase_StringMatch);
    result.add(@testStrEndsWithIgnoringCase_StringMatchCaseInSensitive);

    result.add(@testStrIsEmptyOrSpaces_Empty);
    result.add(@testStrIsEmptyOrSpaces_OneSpace);
    result.add(@testStrIsEmptyOrSpaces_ManySpaces);
    result.add(@testStrIsEmptyOrSpaces_OneChar);
    result.add(@testStrIsEmptyOrSpaces_ManyChars);
    result.add(@testStrIsEmptyOrSpaces_SpacesWithOneChar);
    result.add(@testStrIsEmptyOrSpaces_CharZero);

    result.add(@testStrEqualIgnoringCase_BothEmpty);
    result.add(@testStrEqualIgnoringCase_FirstEmpty);
    result.add(@testStrEqualIgnoringCase_SecondEmpty);
    result.add(@testStrEqualIgnoringCase_DifferentLength);
    result.add(@testStrEqualIgnoringCase_DifferentCase);
    result.add(@testStrEqualIgnoringCase);

    result.add(@testLongWordToStr_Zero);
    result.add(@testLongWordToStr_Four);
    result.add(@testLongWordToStr_Max);

    result.add(@testBoolToStr_true);
    result.add(@testBoolToStr_false);

    result.add(@testStrInSingleQuotes_Empty);
    result.add(@testStrInSingleQuotes);

    result.add(@testHexStrToLongInt_Empty);
    result.add(@testHexStrToLongInt_IllegalChar);
    result.add(@testHexStrToLongInt_IllegalCharMinus);
    result.add(@testHexStrToLongInt_Zero);
    result.add(@testHexStrToLongInt_Ten);
    result.add(@testHexStrToLongInt_Big);

    result.add(@testStrInDoubleQuotes_Empty);
    result.add(@testStrInDoubleQuotes);

    result.add(@testStrExtractStringsQuoted_Empty);
    result.add(@testStrExtractStringsQuoted_OnlyWhitespace);
    result.add(@testStrExtractStringsQuoted_OnlyText);
    result.add(@testStrExtractStringsQuoted_OnlyText2Parts);
    result.add(@testStrExtractStringsQuoted_TextAndWhitespace2Parts);
    result.add(@testStrExtractStringsQuoted_QuotedText1Part);
    result.add(@testStrExtractStringsQuoted_QuotedText1PartNoClosingQuotes);
    result.add(@testStrExtractStringsQuoted_QuotedText1PartNoClosingQuotesWhitewspace);
    result.add(@testStrExtractStringsQuoted_QuotedText1PartQuoteInside);
    result.add(@testStrExtractStringsQuoted_QuotedText1Part2QuotesInside);
    result.add(@testStrExtractStringsQuoted_QuotedText1Part2Quotes);
    result.add(@testStrExtractStringsQuoted_Only1Quote);
    result.add(@testStrExtractStringsQuoted_Only1QuoteAndWhitespace);
    result.add(@testStrExtractStringsQuoted_QuoteStartsNewPart);
    result.add(@testStrExtractStringsQuoted_ManyParts);

    result.add(@testCaseInsensitivePos_Empty);
    result.add(@testCaseInsensitivePos_EmptyPart);
    result.add(@testCaseInsensitivePos_EmptyString);
    result.add(@testCaseInsensitivePos_PartLarger);
    result.add(@testCaseInsensitivePos_AtLeft);
    result.add(@testCaseInsensitivePos_Middle);
    result.add(@testCaseInsensitivePos_AtRight);
    result.add(@testCaseInsensitivePos);

    result.add(@testLastPosOfChar_Empty);
    result.add(@testLastPosOfChar_NotFound);
    result.add(@testLastPosOfChar_OneCharNotFound);
    result.add(@testLastPosOfChar_OneCharFound);
    result.add(@testLastPosOfChar_OneCharWrongCase);
    result.add(@testLastPosOfChar_FirstChar);
    result.add(@testLastPosOfChar_LastChar);
    result.add(@testLastPosOfChar_MiddleChar);
    result.add(@testLastPosOfChar_ManyHits);

    result.add(@testSubstituteAllOccurencesOfChar_Empty);
    result.add(@testSubstituteAllOccurencesOfChar_NotFound);
    result.add(@testSubstituteAllOccurencesOfChar_OneCharReplace);
    result.add(@testSubstituteAllOccurencesOfChar_ReplaceAll);
    result.add(@testSubstituteAllOccurencesOfChar_Some);

  // --------------------
  // ---- AnsiString ----
  // --------------------


    result.add(@testAnsiTrimLeftChars_Empty);
    result.add(@testAnsiTrimLeftChars_RemoveAll);
    result.add(@testAnsiTrimLeftChars_OneLeft);
    result.add(@testAnsiTrimLeftChars_LeftOnly);
    result.add(@testAnsiTrimLeftChars_CharsInside);
    result.add(@testAnsiTrimLeftChars_Nothing);
    result.add(@testAnsiTrimLeftChars_ReallyLong);

    result.add(@testAnsiTrimRightChars_Empty);
    result.add(@testAnsiTrimRightChars_RemoveAll);
    result.add(@testAnsiTrimRightChars_OneLeft);
    result.add(@testAnsiTrimRightChars_RightOnly);
    result.add(@testAnsiTrimRightChars_CharsInside);
    result.add(@testAnsiTrimRightChars_Nothing);
    result.add(@testAnsiTrimRightChars_ReallyLong);

    result.add(@testAnsiTrimChars_Empty);
    result.add(@testAnsiTrimChars_RemoveAll);
    result.add(@testAnsiTrimChars_OneLeftFromLeft);
    result.add(@testAnsiTrimChars_OneLeftFromRight);
    result.add(@testAnsiTrimChars_LeftOnly);
    result.add(@testAnsiTrimChars_RightOnly);
    result.add(@testAnsiTrimChars_CharsInside);
    result.add(@testAnsiTrimChars_Nothing);
    result.add(@testAnsiTrimChars_ReallyLong);

    result.add(@testAnsiTrim);
    result.add(@testAnsiTrim_ReallyLong);


  END;

END.
