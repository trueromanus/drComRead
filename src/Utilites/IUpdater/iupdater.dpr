{
  drComRead

  Internet automatic updater

  Автоматическое обновление
  через интернет

  Copyright (c) 2009-2011 Romanus
}
program iupdater;

{$APPTYPE CONSOLE}

uses
  WinInet,
  Windows,
  Classes,
  SysUtils,
  Generics.Collections,
  IUArchive in 'IUArchive.pas',
  RAR in '..\..\Libs\RAR.pas',
  RAR_DLL in '..\..\Libs\RAR_DLL.pas',
  ArcFunc in 'ArcFunc.pas',
  UpdaterUtils in 'UpdaterUtils.pas';

begin
  if ParamCount = 0 then
  begin
    Writeln('drComRead automatic internet updater version 1.0');
    Writeln('Copyright (c) 2011 Romanus');
    Writeln('This program correctly working at exist command line keys:');
    Writeln('check <getversion> - output well "true" or "false"');
    Writeln('update <newversion> - output well "true" or "false"');
    Writeln('checkandupdate <getversion> - output well "true" or "false"');
    Exit;
  end;
  if ParamCount = 1 then
  begin
    Writeln('Minimum two key command line');
    Exit;
  end;
  //проверка на наличие новой версии
  if (ParamStr(1) = 'check') and (ParamCount = 2) then
  begin
    if CheckNewVersion(ParamStr(2)) then
      Writeln('true')
    else
      Writeln('false');
  end;
  //обновление новой версии
  if ParamStr(1) = 'update' then
  begin
    if UpdateNewVersion(ParamStr(2)) then
      Writeln('true')
    else
      Writeln('false');
  end;
  //проверка и обновление в случае
  //если таковое есть
  if ParamStr(1) = 'checkandupdate' then
  begin
    if CheckNewVersion(ParamStr(2)) and UpdateNewVersion(DownloadNewVersion) then
      Writeln('true')
    else
      Writeln('false');
  end;
  //выполняем клиенсткие
  //операции обновления
  Update;
end.
