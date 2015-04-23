ACLConstants.pas
A few useful constants like EndLine

ACLFileIOUtility.pas
Functions for working more conveniently with OS/2 HFILE (opened with DosOpen).
I've had problems with using SIbyl's built in file handling.

ACLFileUtility.pas
Useful file and filename handling. My favourites: AddSlash and RemoveSLash. Use whenever you aren't sure if a filename has a slash on the end or not! Other highlights: DeleteTree function, functions for getting list of files in directory, deleting readonly files etc.

ACLFindFunctions.pas
Replacements for Sibyl find functions... which I have had problems with!!

ACLLibrary.pas
ACLLibraryTestForm.pas
ACLLibraryTestFormUnit.pas
Test project file and forms for Sibyl and Delphi

ACLPCharUtility.pas
Many useful functions for working with PChar, such as TrimWhitespace, create a duplicate from a standard pascal string, and an AddAndResize function that works as a length-safe StrCat.

ACLProfile.pas
Trivial profiling functions. Call StartProfile to open a file. ProfileEvent( message) to mark an event. StopProfile to stop. Each event is marked with time accurate to milliseconds.

ACLString.pas
Contains the class TAString: a string class. Maintains a length like a standard Sibyl string but length is 32 bit and memory allocation is dynamic. Compatible with PChar.
In theory, AnsiString is better, but in practice I have had problems, and there is no fast way to append to an AnsiString.
Has many convenient methods such as ParseKeyValuePair and ExtractNextValue, and also unlimited ReadLn and WriteLn functions.

ACLStringUtility.pas
Various useful string utilities, such as StrRight, StrLeft, LeftWithout, RightFrom, IsDigit, Left0Pad, Starts, Ends, ListToString and StringToList

ACLUtility.pas
General functions, such as a MemCopy and FillMem, which take pointers instead of Var parameters like the Sibyl equivalents, List functions, SearchPath and RunProgram

PCharList.pas
Maintains a searchable list of PChar strings. Better than TStringList only because the strings are not length-limited.

RunProgramUnit.pas
For Delphi + Windows - run a program
