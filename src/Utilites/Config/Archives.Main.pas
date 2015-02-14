{
  drComRead

  ћодуль настроек программы

  ќбщие настройки
  группы архивов

  Copyright (c) 2012 Romanus
}
unit Archives.Main;

interface

uses
  SysUtils, Classes, Controls, Forms, ExtCtrls, StdCtrls;

const
  TempPathOption              =         'get_temp_path';
  RarPathOption               =         'rar_console';
  WindowsTempConst            =         '{windows|temp}';

type
  TFrameArchiveMain = class(TFrame)
    Button_Apply: TButton;
    Panel_Separator: TPanel;
    Label_PathToTemp: TLabel;
    Edit_TempPath: TEdit;
    Panel1: TPanel;
    Label_RARPath: TLabel;
    Panel2: TPanel;
    Edit_RarPath: TEdit;
    Panel3: TPanel;
    Label_WindowsTemp: TLabel;
    CheckBox_WindowsTemp: TCheckBox;
    procedure Button_ApplyClick(Sender: TObject);
    procedure CheckBox_WindowsTempClick(Sender: TObject);
  private
    //загружаем €зык
    procedure LoadLanguage;
    //загружаем данные
    procedure LoadData;
    //сохран€ем данные
    procedure SaveDataToMainProgram;
  public
    //конструктор
    constructor Create(Owner:TComponent);override;
  end;

implementation

{$R *.dfm}

uses
  ConfigSynchronized, MainProgramHeader, ConfigGlobal;

//загружаем €зык
procedure TFrameArchiveMain.LoadLanguage;
begin
  Label_PathToTemp.Caption:=LangArrayValue('path_to_temp_dir');
  Label_RARPath.Caption:=LangArrayValue('rar_locate');
  Label_WindowsTemp.Caption:=LangArrayValue('windows_sys_temp_dir');
  Button_Apply.Caption:=LangArrayValue('save_button');
end;

//загружаем данные
procedure TFrameArchiveMain.LoadData;
begin
  Edit_TempPath.Text:=ConfArrayValue(TempPathOption);
  Edit_RarPath.Text:=ConfArrayValue(RarPathOption);
  if Edit_TempPath.Text = WindowsTempConst then
  begin
    CheckBox_WindowsTemp.Checked:=true;
    Edit_TempPath.Enabled:=false;
  end else
  begin
    CheckBox_WindowsTemp.Checked:=false;
    Edit_TempPath.Enabled:=true;
  end;
end;

//сохран€ем данные
procedure TFrameArchiveMain.SaveDataToMainProgram;
begin
  SetConfArrayValue(TempPathOption,Edit_TempPath.Text);
  if CheckBox_WindowsTemp.Checked then
    SetConfArrayValue(RarPathOption,WindowsTempConst)
  else
    SetConfArrayValue(RarPathOption,Edit_RarPath.Text);
end;

//конструктор
procedure TFrameArchiveMain.Button_ApplyClick(Sender: TObject);
begin
  SaveDataToMainProgram;
end;

procedure TFrameArchiveMain.CheckBox_WindowsTempClick(Sender: TObject);
begin
  if CheckBox_WindowsTemp.Checked then
    Edit_TempPath.Enabled:=false
  else
    Edit_TempPath.Enabled:=true;
end;

constructor TFrameArchiveMain.Create(Owner:TComponent);
begin
  inherited Create(Owner);
  LoadLanguage;
  LoadData;
end;

end.
