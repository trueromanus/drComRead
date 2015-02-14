{
  drComRead

  PreviewPage Library

  Copyright (c) 2009-2011 Romanus
}
library previewpage;

{$R *.res}

uses
  Windows,
  SysUtils,
  PrevForm in 'PrevForm.pas',
  MainProgramHeader in '..\..\Headers\MainProgramHeader.pas';

//функция для точки входа
procedure DLLEntryPoint(Reason: DWORD);
begin
  case Reason of
    DLL_PROCESS_DETACH:
      begin
        //чистим за собой
        //если не зачистили
        if Assigned(FormPrev) then
        begin
          FormPrev.MViewImages.Clear;
          FreeAndNil(FormPrev);
        end;
      end;
  end;
end;


exports
  ShowPrevOneDialog,
  LoadImagesCollection,
  ClearBitmapList,
  BitmapListIsLoading;

begin
  //определяем обработчик
  //для событий присоединений
  //отсоединений потоков
  if @DllProc = nil then
    DllProc := @DLLEntryPoint;
  DllProc(DLL_PROCESS_ATTACH);
end.
