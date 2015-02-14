{
  drComRead

  Navigator Window

  Модуль для функций
  экспорта

  Copyright (c) 2009-2010 Romanus
}
unit NRExports;

interface

//принудительное закрытие окна
function CloseNavigatorWindow:Boolean;stdcall;
//отображаем диалог навигатора
function ShowNavigatorDialog:Boolean;stdcall;
//инициализируем диалог
function InitNavigatorDialog(Control:Pointer):Boolean;stdcall;

implementation

uses
  MainProgramHeader,
  NRMainForm,NRAnims,Controls,Classes,Dialogs,
  Forms,SysUtils, Windows, Messages;

//принудительное закрытие окна
function CloseNavigatorWindow:Boolean;
begin
  Result:=false;
  //если отображен
  //закрываем
  if CRNavigator.Visible then
    CRNavigator.Close;
  Result:=true;
end;


//отображаем диалог навигатора
function ShowNavigatorDialog:Boolean;
begin
  if CRNavigator = nil then
    Exit(false);
  //пермещеаем за мышью
  CRNavigator.Moving;
  //обновляем правую нижнюю панель
  CRNavigator.UpdateRightDownPanel;
  //показываем окно
  CRNavigator.Show;
  //очищаем фон
  SetForegroundWindow(CRNavigator.Handle);
  SendMessage(CRNavigator.Handle,WA_CLICKACTIVE,0,0);

  Result:=true;
end;

//инициализируем диалог
function InitNavigatorDialog(Control:Pointer):Boolean;
var
  CRApplication:TApplication;
begin
  InitLinks;
  CursorsLoading;
  //если навигатор еще не
  //создан то создаем
  if CRNavigator = nil then
  begin
    CRApplication:=TApplication(Window_GetFormHandle);
    CRApplication.CreateForm(TCRNavigator,CRNavigator);
    CRNavigator.Visible:=false;
    MultiLanguageLoad;
    //скрываем панели
    if WideString(MultiLanguage_GetConfigValue('navigatorleftup')) = '0' then
      CRNavigator.ShowHideLeftUpPanel;
    if WideString(MultiLanguage_GetConfigValue('navigatorrightup')) = '0' then
      CRNavigator.ShowHideRightUpPanel;
    if WideString(MultiLanguage_GetConfigValue('navigatorleftdown')) = '0' then
      CRNavigator.ShowHideLeftDownPanel;
    if WideString(MultiLanguage_GetConfigValue('navigatorrightdown')) = '0' then
      CRNavigator.ShowHideRightDownPanel;
    Application.HintHidePause:=3000;
    Application.HintPause:=4000;
  end;
  //грузим картинки если
  //это актуально
  if not FlagLoaded and not LoadImages then
    Exit(false);
  Result:=true;
end;

end.
