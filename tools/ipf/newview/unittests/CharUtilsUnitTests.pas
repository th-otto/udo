Unit CharUtilsUnitTests;

// NewView - a new OS/2 Help Viewer
// Copyright 2006-2009 Ronald Brill (rbri at rbri dot de)
// This software is released under the GNU Public License - see readme.txt

// UnitTests for CharUtilsUnit

Interface

uses
  Classes,
  SysUtils,
  TestAssert,
  CharUtilsUnit;

  FUNCTION getCharUtilsUnitTests : TList;


Implementation

  PROCEDURE testCharIsDigit_True;
  VAR
    tmpResult : boolean;
  BEGIN
    tmpResult := CharIsDigit('0');
    assertTrue('testCharIsDigit_True - 0', tmpResult);

    tmpResult := CharIsDigit('1');
    assertTrue('testCharIsDigit_True - 1', tmpResult);

    tmpResult := CharIsDigit('2');
    assertTrue('testCharIsDigit_True - 2', tmpResult);

    tmpResult := CharIsDigit('3');
    assertTrue('testCharIsDigit_True - 3', tmpResult);

    tmpResult := CharIsDigit('4');
    assertTrue('testCharIsDigit_True - 4', tmpResult);

    tmpResult := CharIsDigit('5');
    assertTrue('testCharIsDigit_True - 5', tmpResult);

    tmpResult := CharIsDigit('6');
    assertTrue('testCharIsDigit_True - 6', tmpResult);

    tmpResult := CharIsDigit('7');
    assertTrue('testCharIsDigit_True - 7', tmpResult);

    tmpResult := CharIsDigit('8');
    assertTrue('testCharIsDigit_True - 8', tmpResult);

    tmpResult := CharIsDigit('9');
    assertTrue('testCharIsDigit_True - 9', tmpResult);
  END;


  PROCEDURE testCharIsDigit_False;
  VAR
    tmpResult : boolean;
  BEGIN
    tmpResult := CharIsDigit('/');
    assertFalse('testCharIsDigit_False - /', tmpResult);

    tmpResult := CharIsDigit(':');
    assertFalse('testCharIsDigit_False - :', tmpResult);

    tmpResult := CharIsDigit(CharTAB);
    assertFalse('testCharIsDigit_False - CharTAB', tmpResult);

    tmpResult := CharIsDigit('a');
    assertFalse('testCharIsDigit_False - a', tmpResult);

    tmpResult := CharIsDigit('z');
    assertFalse('testCharIsDigit_False - z', tmpResult);

    tmpResult := CharIsDigit('A');
    assertFalse('testCharIsDigit_False - A', tmpResult);

    tmpResult := CharIsDigit('Z');
    assertFalse('testCharIsDigit_False - Z', tmpResult);

    tmpResult := CharIsDigit(#127);
    assertFalse('testCharIsDigit_False - #127', tmpResult);

    tmpResult := CharIsDigit(#255);
    assertFalse('testCharIsDigit_False - #255', tmpResult);

  END;


  // ----------------------------------------------------------


  PROCEDURE testCharIsAlpha_True;
  VAR
    tmpResult : boolean;
  BEGIN
    tmpResult := CharIsAlpha('A');
    assertTrue('testCharIsAlpha_True - A', tmpResult);

    tmpResult := CharIsAlpha('B');
    assertTrue('testCharIsAlpha_True - B', tmpResult);

    tmpResult := CharIsAlpha('X');
    assertTrue('testCharIsAlpha_True - X', tmpResult);

    tmpResult := CharIsAlpha('Z');
    assertTrue('testCharIsAlpha_True - Z', tmpResult);

    tmpResult := CharIsAlpha('a');
    assertTrue('testCharIsAlpha_True - a', tmpResult);

    tmpResult := CharIsAlpha('b');
    assertTrue('testCharIsAlpha_True - b', tmpResult);

    tmpResult := CharIsAlpha('x');
    assertTrue('testCharIsAlpha_True - x', tmpResult);

    tmpResult := CharIsAlpha('z');
    assertTrue('testCharIsAlpha_True - z', tmpResult);

  END;


  PROCEDURE testCharIsAlpha_False;
  VAR
    tmpResult : boolean;
  BEGIN
    tmpResult := CharIsAlpha('@');
    assertFalse('testCharIsAlpha_False - @', tmpResult);

    tmpResult := CharIsAlpha('[');
    assertFalse('testCharIsAlpha_False - [', tmpResult);

    tmpResult := CharIsAlpha(#140);
    assertFalse('testCharIsAlpha_False - #140', tmpResult);

    tmpResult := CharIsAlpha('{');
    assertFalse('testCharIsAlpha_False - {', tmpResult);

  END;


  // ---------------
  // ---- PChar ----
  // ---------------


  PROCEDURE testStrPasWithLength_Empty;
  VAR
    tmpPChar : PChar;
    tmpResult : String;
  BEGIN
    tmpPChar := '';
    tmpResult := StrPasWithLength(tmpPChar, 0);

    assertEqualsAnsiString('testStrPasWithLength_Empty', '', tmpResult);
  END;


  PROCEDURE testStrPasWithLength_EmptyLengt11;
  VAR
    tmpPChar : PChar;
    tmpResult : String;
  BEGIN
    tmpPChar := '';
    tmpResult := StrPasWithLength(tmpPChar, 11);

    assertEqualsAnsiString('testStrPasWithLength_EmptyLengt11', '', tmpResult);
  END;


  PROCEDURE testStrPasWithLength_Lengt0;
  VAR
    tmpPChar : PChar;
    tmpResult : String;
  BEGIN
    tmpPChar := 'abc';
    tmpResult := StrPasWithLength(tmpPChar, 0);

    assertEqualsAnsiString('testStrPasWithLength_Lengt0', '', tmpResult);
  END;


  PROCEDURE testStrPasWithLength_FirstChar;
  VAR
    tmpPChar : PChar;
    tmpResult : String;
  BEGIN
    tmpPChar := 'abc';
    tmpResult := StrPasWithLength(tmpPChar, 1);

    assertEqualsAnsiString('testStrPasWithLength_FirstChar', 'a', tmpResult);
  END;


  PROCEDURE testStrPasWithLength_ExactLength;
  VAR
    tmpPChar : PChar;
    tmpResult : String;
  BEGIN
    tmpPChar := 'abc';
    tmpResult := StrPasWithLength(tmpPChar, 3);

    assertEqualsAnsiString('testStrPasWithLength_ExactLength', 'abc', tmpResult);
  END;


  PROCEDURE testStrPasWithLength_LengthOneToBig;
  VAR
    tmpPChar : PChar;
    tmpResult : String;
  BEGIN
    tmpPChar := 'abc';
    tmpResult := StrPasWithLength(tmpPChar, 4);

    assertEqualsAnsiString('testStrPasWithLength_LengthOneToBig', 'abc', tmpResult);
  END;


  PROCEDURE testStrPasWithLength_LengthNegative;
  VAR
    tmpPChar : PChar;
    tmpResult : String;
  BEGIN
    tmpPChar := 'abc';
    tmpResult := StrPasWithLength(tmpPChar, -4);

    assertEqualsAnsiString('testStrPasWithLength_LengthNegative', '', tmpResult);
  END;


  // ----------------------------------------------------------

  PROCEDURE testPCharPointerDiff_Same;
  VAR
    tmpMinuend : PChar;
    tmpSubtrahend : PChar;
    tmpResult : Longword;
  BEGIN
    tmpMinuend := 'abc';
    tmpSubtrahend := tmpMinuend;
    tmpResult := PCharPointerDiff(tmpMinuend, tmpSubtrahend);

    assertEqualsLongWord('testPCharPointerDiff_Same', 0, tmpResult);
  END;


  PROCEDURE testPCharPointerDiff;
  VAR
    tmpMinuend : PChar;
    tmpSubtrahend : PChar;
    tmpResult : Longword;
  BEGIN
    tmpSubtrahend := 'abcdef';
    tmpMinuend := tmpSubtrahend + 2;
    assertEqualsString('testPCharPointerDiff', 'cdef', StrPas(tmpMinuend));

    tmpResult := PCharPointerDiff(tmpMinuend, tmpSubtrahend);

    assertEqualsLongWord('testPCharPointerDiff_Same', 2, tmpResult);
  END;


  // ----------------------------------------------------------


  FUNCTION getCharUtilsUnitTests : TList;
  BEGIN
    result := TList.Create;

    result.add(@testCharIsDigit_True);
    result.add(@testCharIsDigit_False);

    result.add(@testCharIsAlpha_True);
    result.add(@testCharIsAlpha_False);


    result.add(@testStrPasWithLength_Empty);
    result.add(@testStrPasWithLength_EmptyLengt11);
    result.add(@testStrPasWithLength_Lengt0);
    result.add(@testStrPasWithLength_FirstChar);
    result.add(@testStrPasWithLength_ExactLength);
    result.add(@testStrPasWithLength_LengthOneToBig);
    result.add(@testStrPasWithLength_LengthNegative);

    result.add(@testPCharPointerDiff_Same);
    result.add(@testPCharPointerDiff);

  END;

END.
