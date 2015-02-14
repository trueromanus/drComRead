{
  drComRead

  History and bookmarks
  access and saving
  library

  Copyright (c) 2011 Romanus
}
library history;

uses
  Windows,
  SQLiteTable3 in 'SQLiteTable3.pas',
  CRExports in 'CRExports.pas',
  CRGlobal in 'CRGlobal.pas',
  historyform in 'historyform.pas',
  SQLite3 in 'SQLite3.pas',
  MainProgramHeader in '..\..\Headers\MainProgramHeader.pas';

{$R *.res}

//функция для точки входа
procedure DLLEntryPoint(Reason: DWORD);
begin
  case Reason of
    DLL_PROCESS_DETACH:
      begin
        //перестраховываемся
        //если надо зачистить за собой
        if Assigned(HistoryDataBase) then
          HistoryDataBase.Free;
      end;
  end;
end;


exports
  ShowDialogHistory,

  InitDataBase,
  DeInitDataBase,

  FindBookmarkArchive,
  FindAllBookmarkArchive,
  AddBookmarkArchive,
  DeleteBookmarkArchive,
  DeleteBookmarkArchivePage,

  FindHistoryDirLast,
  FindHistoryDirIndex,
  AddHistoryDir,

  FindHistoryArcLast,
  FindHistoryArcIndex,
  AddHistoryArc;

begin
  //определяем обработчик
  //для событий присоединений
  //отсоединений потоков
  if @DllProc = nil then
    DllProc := @DLLEntryPoint;
  DllProc(DLL_PROCESS_ATTACH);
end.
