{
  drComRead

  Navigator Window

  Copyright (c) 2008-2010 Romanus
}
library navigator;

uses
  SysUtils,
  Classes,
  Windows,
  NRAnims in 'NRAnims.pas',
  NRExports in 'NRExports.pas',
  NRMainForm in 'NRMainForm.pas',
  InfoForm in 'InfoForm.pas',
  MainProgramHeader in '..\..\Headers\MainProgramHeader.pas';

{$R *.res}

//функция для точки входа
procedure DLLEntryPoint(Reason: DWORD);
begin
  case Reason of
    DLL_PROCESS_ATTACH:
      begin
        {if not Assigned(CRNavigator) then
        begin
          //грузим ссылки
          //InitLinks;
        end;}
      end;
    DLL_PROCESS_DETACH:
      begin
        //чистим навигатор
        {if Assigned(CRNavigator) then
          CRNavigator.Free;}
      end;
  end;
end;

exports
  CloseNavigatorWindow,
  InitNavigatorDialog,
  ShowNavigatorDialog;

begin
  //определяем обработчик
  //для событий присоединений
  //отсоединений потоков
  if @DllProc = nil then
    DllProc := @DLLEntryPoint;
  DllProc(DLL_PROCESS_ATTACH);
end.
