{
  drComRead

  SortFiles Library

  Copyright (c) 2008-2009 Romanus
}
library sortfiles;

{$R *.res}

uses
  SFDialog in 'SFDialog.pas',
  SFSorting in 'SFSorting.pas',
  SFGlobal in 'SFGlobal.pas',
  MainProgramHeader in '..\..\Headers\MainProgramHeader.pas',
  SFNextGenDialog in 'SFNextGenDialog.pas' {Form1};

exports
  ShowSortFilesDialog,
  SortFilesMainFunc,
  SortingFilesAtList,
  SortFilesContext;

begin
end.
