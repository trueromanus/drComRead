{
  drComRead

  OpenDir Dll

  Динамическая библиотека
  для разгрузки диалога
  открытия каталогов

  Ревизия - $Revision: 1.2 $

  Copyright (c) 2008-2011 Romanus
}
library opendir;

uses
  SysUtils,
  Classes,
  OpenDirDialog in 'OpenDirDialog.pas',
  Globals in 'Globals.pas',
  MainProgramHeader in '..\..\Headers\MainProgramHeader.pas',
  CombineDirDialog in 'CombineDirDialog.pas' {CombineDirForm};

{$R *.res}

//экспортируем функцию
//отображения диалога
exports ShowDirDialog;

begin
end.
