{
  drComRead

  Archive Dialog Library

  Copyright (c) 2008-2009 Romanus
}
library arcdialog;

uses
  SysUtils,
  Classes,
  ArchiveDialog in 'ArchiveDialog.pas',
  MainProgramHeader in '..\..\Headers\MainProgramHeader.pas',
  ArchiveFind in 'ArchiveFind.pas';

{$R *.res}

exports
  ShowArchiveDialog,
  SortArchivesList;

begin
end.
