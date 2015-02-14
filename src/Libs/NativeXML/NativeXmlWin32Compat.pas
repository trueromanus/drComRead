{ linux-aware bare versions of win32 functions so
  NativeXml can compile in linux

  TODO! I dont know how linux does this

  copyright (c) 2011 Nils Haeck (www.simdesign.nl)
}
unit NativeXmlWin32Compat;

interface

{int MultiByteToWideChar(

    UINT CodePage,	// code page
    DWORD dwFlags,	// character-type options
    LPCSTR lpMultiByteStr,	// address of string to map
    int cchMultiByte,	// number of characters in string
    LPWSTR lpWideCharStr,	// address of wide-character buffer
    int cchWideChar 	// size of buffer
   );	}

function MultiByteToWideChar(CodePage: word; dwFlags: longword; lpMultiByteStr: pansichar;
  cchMultiByte: integer; lpWideCharStr: pwidechar; cchWideChar: integer): integer;

{int WideCharToMultiByte(

    UINT CodePage,	// code page
    DWORD dwFlags,	// performance and mapping flags
    LPCWSTR lpWideCharStr,	// address of wide-character string
    int cchWideChar,	// number of characters in string
    LPSTR lpMultiByteStr,	// address of buffer for new string
    int cchMultiByte,	// size of buffer
    LPCSTR lpDefaultChar,	// address of default for unmappable characters
    LPBOOL lpUsedDefaultChar 	// address of flag set when default char. used
   ); }

function WideCharToMultiByte(CodePage: word; dwFlags: longword; lpWideCharStr: pwidechar;
  cchWideChar: integer; lpMultiByteStr: pansichar; cchMultiByte: integer;
  lpDefaultChar: pansichar; lpUsedDefaultChar: pointer): integer;

implementation

uses
  NativeXml;

function MultiByteToWideChar(CodePage: word; dwFlags: longword; lpMultiByteStr: pansichar;
  cchMultiByte: integer; lpWideCharStr: pwidechar; cchWideChar: integer): integer;
begin
  //todo!
  Result := sdUtf8ToWideBuffer(lpMultiByteStr^, lpWideCharStr^, cchMultiByte);
end;

function WideCharToMultiByte(CodePage: word; dwFlags: longword; lpWideCharStr: pwidechar;
  cchWideChar: integer; lpMultiByteStr: pansichar; cchMultiByte: integer;
  lpDefaultChar: pansichar; lpUsedDefaultChar: pointer): integer;
begin
  // todo!
  Result := sdWideToUtf8Buffer(lpWideCharStr^, lpMultiByteStr^, cchWideChar);
end;

end.
