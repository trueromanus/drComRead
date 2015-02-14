{
  drComRead

  Модуль настроек программы

  Настройки активного
  перемещения

  Copyright (c) 2012 Romanus
}
unit Main.ActiveScroll;

interface

uses
  Classes, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

const
  SensitivyMouseOption          =         'sensivity_level';
  ActiveScrollOption            =         'active_scroll';

type
  TMainActiveScroll = class(TFrame)
    Button_Apply: TButton;
    Panel_Separator: TPanel;
    Label_StartProgramState: TLabel;
    CheckBox_StartProgramState: TCheckBox;
    Label_CurrentState: TLabel;
    CheckBox_RunProgramState: TCheckBox;
    Panel_Separator2: TPanel;
    Panel_Separator3: TPanel;
    Label_ActiveScrollSensitive: TLabel;
    Edit_ScrollSensitive: TEdit;
    UpDownScroll: TUpDown;
    Panel_Separator4: TPanel;
    procedure Button_ApplyClick(Sender: TObject);
  private
    FActiveScrollStart:Boolean;
    FActiveScrollRun:Boolean;
    FScrollSensitive:Integer;
    //загружаем язык
    procedure LoadLanguage;
    //загружаем данные
    procedure LoadData;
    //сохраняем данные
    procedure SaveDataToMainProgram;
    //загружаем данные в форму
    procedure LoadDataToForm;
  public
    //конструктор
    constructor Create(Owner:TComponent);override;
  end;

implementation

{$R *.dfm}

uses
  SysUtils,
  ConfigSynchronized, MainProgramHeader, ConfigGlobal;

//загружаем язык
procedure TMainActiveScroll.LoadLanguage;
begin
  Label_ActiveScrollSensitive.Caption:=LangArrayValue('sensivity_level');
  Label_CurrentState.Caption:=LangArrayValue('active_scroll');
  Label_StartProgramState.Caption:=LangArrayValue('active_scroll_start');
  Button_Apply.Caption:=LangArrayValue('save_button');
end;

//загружаем данные
procedure TMainActiveScroll.LoadData;
begin
  try
    FActiveScrollStart:=StrToBool(ConfArrayValue(ActiveScrollOption));
  except
    FActiveScrollStart:=false;
  end;
  FActiveScrollRun:=Scrolling_GetActiveScroll;
  try
    FScrollSensitive:=StrToInt(ConfArrayValue(SensitivyMouseOption));
  except
    FScrollSensitive:=10;
  end;
  LoadDataToForm;
end;

//сохраняем данные
procedure TMainActiveScroll.SaveDataToMainProgram;
begin
  SetConfArrayValue(SensitivyMouseOption,IntToStr(FScrollSensitive));
  SetConfArrayValue(ActiveScrollOption,BoolToStr(FActiveScrollStart));
  Scrolling_SetActiveScroll(FActiveScrollRun);
end;

//загружаем данные в форму
procedure TMainActiveScroll.LoadDataToForm;
begin
  CheckBox_StartProgramState.Checked:=FActiveScrollStart;
  CheckBox_RunProgramState.Checked:=FActiveScrollRun;
  Edit_ScrollSensitive.Text:=IntToStr(FScrollSensitive);
end;

procedure TMainActiveScroll.Button_ApplyClick(Sender: TObject);
begin
  SaveDataToMainProgram;
end;

constructor TMainActiveScroll.Create(Owner:TComponent);
begin
  inherited Create(Owner);
  LoadLanguage;
  LoadData;
end;


end.
