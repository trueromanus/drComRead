{
  drComRead

  Navigator Window

  ������ ��� �������
  ��������

  Copyright (c) 2009-2010 Romanus
}
unit NRExports;

interface

//�������������� �������� ����
function CloseNavigatorWindow:Boolean;stdcall;
//���������� ������ ����������
function ShowNavigatorDialog:Boolean;stdcall;
//�������������� ������
function InitNavigatorDialog(Control:Pointer):Boolean;stdcall;

implementation

uses
  MainProgramHeader,
  NRMainForm,NRAnims,Controls,Classes,Dialogs,
  Forms,SysUtils, Windows, Messages;

//�������������� �������� ����
function CloseNavigatorWindow:Boolean;
begin
  Result:=false;
  //���� ���������
  //���������
  if CRNavigator.Visible then
    CRNavigator.Close;
  Result:=true;
end;


//���������� ������ ����������
function ShowNavigatorDialog:Boolean;
begin
  if CRNavigator = nil then
    Exit(false);
  //���������� �� �����
  CRNavigator.Moving;
  //��������� ������ ������ ������
  CRNavigator.UpdateRightDownPanel;
  //���������� ����
  CRNavigator.Show;
  //������� ���
  SetForegroundWindow(CRNavigator.Handle);
  SendMessage(CRNavigator.Handle,WA_CLICKACTIVE,0,0);

  Result:=true;
end;

//�������������� ������
function InitNavigatorDialog(Control:Pointer):Boolean;
var
  CRApplication:TApplication;
begin
  InitLinks;
  CursorsLoading;
  //���� ��������� ��� ��
  //������ �� �������
  if CRNavigator = nil then
  begin
    CRApplication:=TApplication(Window_GetFormHandle);
    CRApplication.CreateForm(TCRNavigator,CRNavigator);
    CRNavigator.Visible:=false;
    MultiLanguageLoad;
    //�������� ������
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
  //������ �������� ����
  //��� ���������
  if not FlagLoaded and not LoadImages then
    Exit(false);
  Result:=true;
end;

end.
