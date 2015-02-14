{
  drComRead

  Internet automatic updater

  Модуль общих функций
  для автообновления

  Copyright (c) 2009-2011 Romanus
}
unit UpdaterUtils;

interface

uses
  SysUtils, Classes, Windows, WinInet,
  Generics.Collections;

var
  DownloadNewVersion:String;

//конвертим строку с версией
//в список чисел
function ConvertStringToVersion(Str:String):TList<Integer>;
function DownloadFile(const url: string;const destinationFileName: string): boolean;
function DownloadHtml(const url: string): TStringList;
//обновляем последней версией
function UpdateNewVersion(NewVersion:String):Boolean;
//обнуляем дополнительные
//недостающие части версии
procedure VersionsEmpty(Version:TList<Integer>;Count:Integer);
//проверяем старше ли
//последняя версия текущей
function CompareVersions(Current,Latest:TList<Integer>):Boolean;
//проверяем новую версию
function CheckNewVersion(GetVersion:String):Boolean;

implementation

//конвертим строку с версией
//в список чисел
function ConvertStringToVersion(Str:String):TList<Integer>;
var
  Separator:String;
  GetPos:Integer;
  LastPos:Integer;
begin
  Separator:='.';
  LastPos:=0;
  Result:=TList<Integer>.Create();
  for GetPos:=0 to Length(Str) do
  begin
    if Str[GetPos] = Separator then
    begin
      try
        Result.Add(StrToInt(Copy(Str,LastPos+1,(GetPos-LastPos)-1)));
      except
      end;
      LastPos:=GetPos;
    end;
  end;
  if LastPos <> Length(Str) then
  begin
    try
      Result.Add(StrToInt(Copy(Str,LastPos+1,Length(Str))));
    except
    end;
  end;
end;

function DownloadFile(
    const url: string;
    const destinationFileName: string): boolean;
var
  hInet: HINTERNET;
  hFile: HINTERNET;
  localFile: File;
  buffer: array[1..1024] of byte;
  bytesRead: DWORD;
begin
  result := False;
  hInet := InternetOpen(PChar('drComRead_IUpdater'),
    INTERNET_OPEN_TYPE_PRECONFIG,nil,nil,0);
  hFile := InternetOpenURL(hInet,PChar(url),nil,0,0,0);
  if Assigned(hFile) then
  begin
    AssignFile(localFile,destinationFileName);
    Rewrite(localFile,1);
    repeat
      InternetReadFile(hFile,@buffer,SizeOf(buffer),bytesRead);
      BlockWrite(localFile,buffer,bytesRead);
    until bytesRead = 0;
    CloseFile(localFile);
    result := true;
    InternetCloseHandle(hFile);
  end;
  InternetCloseHandle(hInet);
end;

function DownloadHtml(const url: string): TStringList;
var
  hInet: HINTERNET;
  hFile: HINTERNET;
  buffer: array[1..1024] of byte;
  bufferStr:WideString;
  GetPos:Integer;
  bytesRead: DWORD;
begin
  result := TStringList.Create;
  hInet := InternetOpen(PChar('drComRead_IUpdater'),
    INTERNET_OPEN_TYPE_PRECONFIG,nil,nil,0);
  {if hInet = nil then
    Exit(false);}
  hFile := InternetOpenURL(hInet,PChar(url),nil,0,0,0);
  if Assigned(hFile) then
  begin
    repeat
      InternetReadFile(hFile,@buffer,SizeOf(buffer),bytesRead);
      for GetPos:=1 to bytesRead do
      begin
        if buffer[GetPos] = 13 then
        begin
          result.Add(bufferStr);
          bufferStr:='';
        end else
        begin
          if (buffer[GetPos] <> 10) and (buffer[GetPos] <> 9) then
            bufferStr:=bufferStr+chr(buffer[GetPos]);
        end;
      end;
    until bytesRead = 0;
    InternetCloseHandle(hFile);
  end;
  InternetCloseHandle(hInet);
end;

//обновляем последней версией
function UpdateNewVersion(NewVersion:String):Boolean;
var
  BasicUrl:String;
begin
  //если есть точки в версии
  //то вырезаем их
  if Pos('.',NewVersion) <> 0 then
    NewVersion:=StringReplace(NewVersion,'.','',[rfReplaceAll]);
  //формируем урл
  BasicUrl:='http://drcomread.atticfloor.ru/uploads/updates/';
  BasicUrl:=BasicUrl+'update'+NewVersion+'.rar';
  if DownloadFile(
            BasicUrl,
            ExtractFilePath(ParamStr(0))+
            'update.rar') then
  begin
    Result:=true;
  end else
    Result:=false;
end;

//обнуляем дополнительные
//недостающие части версии
procedure VersionsEmpty(Version:TList<Integer>;Count:Integer);
var
  CountEmptys:Integer;
  GetPos:Integer;
begin
  CountEmptys:=Count-Version.Count;
  for GetPos:=0 to CountEmptys-1 do
    Version.Add(0);
end;

//проверяем старше ли
//последняя версия текущей
function CompareVersions(Current,Latest:TList<Integer>):Boolean;
var
  GetPos:Integer;
begin
  if Current.Count < Latest.Count then
    VersionsEmpty(Current,Latest.Count);
  if Latest.Count < Current.Count  then
    VersionsEmpty(Latest,Current.Count);
  for GetPos:=0 to Latest.Count-1 do
    if Current[GetPos] < Latest[GetPos] then
      Exit(true);
  Result:=false;
end;

//проверяем новую версию
function CheckNewVersion(GetVersion:String):Boolean;
var
  Stream:TStrings;
  GetString:String;
  PosStart:Integer;
  GetPos:Integer;
  CurrentVersions:TList<Integer>;
  NewVersion:TList<Integer>;
begin
  Result:=False;
  Stream:=DownloadHtml('http://drcomread.atticfloor.ru/');
  if Stream.Count = 0 then
    Exit;
  //сбрасываем позицию
  for GetPos:=0 to Stream.Count-1 do
  begin
    GetString:=Stream.Strings[GetPos];
    PosStart:=Pos('<!--version:',GetString);
    if PosStart = 0 then
      Continue;
    GetString:=Copy(GetString,PosStart+12,Length(GetString));
    GetString:=Copy(GetString,0,Pos(':',GetString)-1);
    Break;
  end;
  Stream.Free;
  if GetString = '' then
    Result:=False;
  CurrentVersions:=ConvertStringToVersion(GetVersion);
  NewVersion:=ConvertStringToVersion(GetString);
  if CompareVersions(CurrentVersions,NewVersion) then
  begin
    Result:=True;
    DownloadNewVersion:=StringReplace(GetString,'.','',[rfReplaceAll]);
  end;
  CurrentVersions.Free;
  NewVersion.Free;
end;

end.
