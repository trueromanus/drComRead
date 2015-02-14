{
  drComRead

  Модуль настроек программы

  Общие настройки
  цветокоррекции

  Copyright (c) 2012 Romanus
}
unit ColorCorrectMain;

interface

uses
  SysUtils, Classes, Controls, Forms, StdCtrls, ExtCtrls, ComCtrls;

const
  //использовать кривые
  EnabledCurvesOption             =             'enabledcurves';
  //использовать резкость
  EnabledSharpenOption            =             'sharpenimages';
  //контраст
  ContrastOption                  =             'imagecontrast';
  //используется ли коррекция гаммы
  GammaCorrectionOption           =             'enabledgammacorrection';
  //коррекция гаммы значение
  GammaCorrectionValueOption      =             'gammacorrection';
  //использовать насыщенность
  EnabledSaturationOption         =             'enablesaturation';
  //насыщенность
  SaturationOption                =             'saturation';

type
  TFrameColorCorrectMain = class(TFrame)
    Button_Apply: TButton;
    Panel_Separator: TPanel;
    Label_EnabledCurves: TLabel;
    CheckBox_EnabledCurves: TCheckBox;
    Panel1: TPanel;
    Label_Sharpen: TLabel;
    CheckBox_Sharpen: TCheckBox;
    Panel2: TPanel;
    Label_Saturation: TLabel;
    CheckBox_Saturation: TCheckBox;
    Panel3: TPanel;
    Edit_Saturation: TEdit;
    UpDown_Saturation: TUpDown;
    Panel4: TPanel;
    Label_GammaCorrection: TLabel;
    CheckBox_GammaCorrect: TCheckBox;
    Edit_GammaFirst: TEdit;
    Edit_GammaSecond: TEdit;
    UpDown_GammaFirst: TUpDown;
    UpDown_GammaSecond: TUpDown;
    Panel5: TPanel;
    Label_EnabledContrast: TLabel;
    CheckBox_Contrast: TCheckBox;
    Edit_Contrast: TEdit;
    UpDown_Contrast: TUpDown;
    procedure CheckBox_SaturationClick(Sender: TObject);
    procedure CheckBox_GammaCorrectClick(Sender: TObject);
    procedure CheckBox_ContrastClick(Sender: TObject);
    procedure Button_ApplyClick(Sender: TObject);
  private
    //загружаем язык
    procedure LoadLanguage;
    //загружаем данные
    procedure LoadData;
    //сохраняем данные
    procedure SaveDataToMainProgram;
  public
    //конструктор
    constructor Create(Owner:TComponent);override;
  end;

implementation

{$R *.dfm}

uses
  ConfigSynchronized, MainProgramHeader, ConfigGlobal;

procedure TFrameColorCorrectMain.Button_ApplyClick(Sender: TObject);
begin
  SaveDataToMainProgram;
end;

procedure TFrameColorCorrectMain.CheckBox_ContrastClick(Sender: TObject);
begin
  Edit_Contrast.Enabled:=CheckBox_Contrast.Checked;
  UpDown_Contrast.Enabled:=CheckBox_Contrast.Checked;
  if not CheckBox_Contrast.Checked then
    UpDown_Contrast.Position:=0;
end;

procedure TFrameColorCorrectMain.CheckBox_GammaCorrectClick(Sender: TObject);
begin
  Edit_GammaFirst.Enabled:=CheckBox_GammaCorrect.Checked;
  Edit_GammaSecond.Enabled:=CheckBox_GammaCorrect.Checked;
  UpDown_GammaFirst.Enabled:=CheckBox_GammaCorrect.Checked;
  UpDown_GammaSecond.Enabled:=CheckBox_GammaCorrect.Checked;
end;

procedure TFrameColorCorrectMain.CheckBox_SaturationClick(Sender: TObject);
begin
  Edit_Saturation.Enabled:=CheckBox_Saturation.Checked;
  UpDown_Saturation.Enabled:=CheckBox_Saturation.Checked;
end;

//загружаем язык
procedure TFrameColorCorrectMain.LoadLanguage;
begin
  Label_EnabledCurves.Caption:=LangArrayValue('cc_curves');
  Label_Sharpen.Caption:=LangArrayValue('cc_sharpen');
  Label_GammaCorrection.Caption:=LangArrayValue('cc_enabledgammacorrection');
  Label_Saturation.Caption:=LangArrayValue('saturation');
  Label_EnabledContrast.Caption:=LangArrayValue('cc_contrast');
  Button_Apply.Caption:=LangArrayValue('save_button');
end;

//загружаем данные
procedure TFrameColorCorrectMain.LoadData;
var
  GammaValue:String;
begin
  CheckBox_EnabledCurves.Checked:=StrToBool(ConfArrayValue(EnabledCurvesOption));
  CheckBox_Sharpen.Checked:=StrToBool(ConfArrayValue(EnabledSharpenOption));
  CheckBox_Saturation.Checked:=StrToBool(ConfArrayValue(EnabledSaturationOption));
  CheckBox_GammaCorrect.Checked:=StrToBool(ConfArrayValue(GammaCorrectionOption));
  UpDown_Contrast.Position:=StrToInt(ConfArrayValue(ContrastOption));
  if UpDown_Contrast.Position = 0 then
    CheckBox_Contrast.Checked:=false
  else
    CheckBox_Contrast.Checked:=true;
  UpDown_Saturation.Position:=StrToInt(ConfArrayValue(SaturationOption));
  GammaValue:=ConfArrayValue(GammaCorrectionValueOption);
  UpDown_GammaFirst.Position:=StrToInt(Copy(GammaValue,0,Pos(',',GammaValue)-1));
  UpDown_GammaSecond.Position:=StrToInt(Copy(GammaValue,Pos(',',GammaValue)+1,Length(GammaValue)));
  CheckBox_SaturationClick(nil);
  CheckBox_ContrastClick(nil);
  CheckBox_GammaCorrectClick(nil);
end;

//сохраняем данные
procedure TFrameColorCorrectMain.SaveDataToMainProgram;
begin
  SetConfArrayValue(EnabledCurvesOption,BoolToStr(CheckBox_EnabledCurves.Checked));
  SetConfArrayValue(EnabledSharpenOption,BoolToStr(CheckBox_Sharpen.Checked));
  SetConfArrayValue(EnabledSaturationOption,BoolToStr(CheckBox_Saturation.Checked));
  SetConfArrayValue(GammaCorrectionOption,BoolToStr(CheckBox_GammaCorrect.Checked));
  SetConfArrayValue(ContrastOption,IntToStr(UpDown_Contrast.Position));
  SetConfArrayValue(SaturationOption,Edit_Saturation.Text);
  SetConfArrayValue(GammaCorrectionValueOption,Edit_GammaFirst.Text+','+Edit_GammaSecond.Text);
end;

//конструктор
constructor TFrameColorCorrectMain.Create(Owner:TComponent);
begin
  inherited Create(Owner);
  LoadLanguage;
  LoadData;
end;

end.
