{
  drComRead

  ћодуль настроек программы

  Ќастройки двухстраничного
  просмотра

  Copyright (c) 2012 Romanus
}
unit Main.TwoPage;

interface

uses
  SysUtils, Classes, Controls, Forms,
  StdCtrls, ExtCtrls;

const
  TwoPageOption                   =         'two_pages';
  TwoPageJapanOption              =         'two_pages_japan';
  TwoPageOnePageOption            =         'two_pages_long';

type
  TMainTwopage = class(TFrame)
    Panel_Separator: TPanel;
    CheckBox_Activate: TCheckBox;
    Label_Activate: TLabel;
    Panel_Separator2: TPanel;
    Button_Apply: TButton;
    Label_TwoPageJapan: TLabel;
    CheckBox_Japan: TCheckBox;
    Panel_Separator3: TPanel;
    Label_OnePagePaging: TLabel;
    CheckBox_OnePagePaging: TCheckBox;
    Panel_Separator4: TPanel;
    procedure Button_ApplyClick(Sender: TObject);
    procedure CheckBox_ActivateClick(Sender: TObject);
    procedure CheckBox_JapanClick(Sender: TObject);
    procedure CheckBox_OnePagePagingClick(Sender: TObject);
  private
    FActivateTwoPage:Boolean;
    FActivateJapan:Boolean;
    FActivateOnePaging:Boolean;
    //загружаем €зык
    procedure LoadLanguage;
    //загружаем данные
    procedure LoadData;
    //сохран€ем данные
    procedure SaveDataToMainProgram;
    //активируем дополнительные
    //элементы
    procedure EnabledChecks(Enabled:Boolean);
  public
    //конструктор
    constructor Create(Owner:TComponent);override;
  end;

implementation

{$R *.dfm}

uses
  ConfigSynchronized, MainProgramHeader, ConfigGlobal;

//загружаем €зык
procedure TMainTwopage.LoadLanguage;
begin
  Label_Activate.Caption:=LangArrayValue('twopage_view');
  Label_OnePagePaging.Caption:=LangArrayValue('twopage_long');
  Label_TwoPageJapan.Caption:=LangArrayValue('twopage_japan');
  Button_Apply.Caption:=LangArrayValue('save_button');
end;

//загружаем данные
procedure TMainTwopage.LoadData;
begin
  try
    FActivateTwoPage:=StrToBool(ConfArrayValue(TwoPageOption));
  except
    FActivateTwoPage:=false;
  end;
  try
    FActivateJapan:=StrToBool(ConfArrayValue(TwoPageJapanOption));
  except
    FActivateJapan:=false;
  end;
  try
    FActivateOnePaging:=StrToBool(ConfArrayValue(TwoPageOnePageOption));
  except
    FActivateOnePaging:=false;
  end;
  CheckBox_Activate.Checked:=FActivateTwoPage;
  CheckBox_Japan.Checked:=FActivateJapan;
  CheckBox_OnePagePaging.Checked:=FActivateOnePaging;
  EnabledChecks(CheckBox_Activate.Checked);
end;

//сохран€ем данные
procedure TMainTwopage.SaveDataToMainProgram;
begin
  SetConfArrayValue(TwoPageOption,BoolToStr(FActivateTwoPage));
  SetConfArrayValue(TwoPageJapanOption,BoolToStr(FActivateJapan));
  SetConfArrayValue(TwoPageOnePageOption,BoolToStr(FActivateOnePaging));
end;

//конструктор
procedure TMainTwopage.Button_ApplyClick(Sender: TObject);
begin
  SaveDataToMainProgram;
end;

//активируем дополнительные
//элементы
procedure TMainTwopage.EnabledChecks(Enabled:Boolean);
begin
  CheckBox_Japan.Enabled:=Enabled;
  Label_TwoPageJapan.Enabled:=Enabled;
  CheckBox_OnePagePaging.Enabled:=Enabled;
  Label_OnePagePaging.Enabled:=Enabled;
end;

procedure TMainTwopage.CheckBox_ActivateClick(Sender: TObject);
begin
  EnabledChecks(CheckBox_Activate.Checked);
  FActivateTwoPage:=CheckBox_Activate.Checked;
end;

procedure TMainTwopage.CheckBox_JapanClick(Sender: TObject);
begin
  FActivateJapan:=CheckBox_Japan.Checked;
end;

procedure TMainTwopage.CheckBox_OnePagePagingClick(Sender: TObject);
begin
  FActivateOnePaging:=CheckBox_OnePagePaging.Checked;
end;

constructor TMainTwopage.Create(Owner:TComponent);
begin
  inherited Create(Owner);
  LoadLanguage;
  LoadData;
end;

end.
