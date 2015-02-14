{
  drComRead

  ћодуль настроек программы

  Ќастройки окна и €зыка
  используемого в программе

  Copyright (c) 2012 Romanus
}
unit Main.WindowAndLanguage;

interface

uses
  SysUtils, Classes, Controls, Forms, StdCtrls, ExtCtrls;

const
  FullScreenOption                =         'full_screen';
  MinimizeOption                  =         'window_minimize';
  LanguageOption                  =         'defaultlng';


type
  TMainWindowAndLanguage = class(TFrame)
    Button_Apply: TButton;
    Panel_Separator: TPanel;
    Label_ActivateFullScreen: TLabel;
    CheckBox_ActivateFullScreen: TCheckBox;
    Panel_Separator2: TPanel;
    Label_MinimizeStart: TLabel;
    CheckBox_MinimizeStart: TCheckBox;
    Panel_Separator3: TPanel;
    Label_Language: TLabel;
    ComboBoxLanguage: TComboBox;
    Panel_Separator4: TPanel;
    procedure Button_ApplyClick(Sender: TObject);
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
procedure TMainWindowAndLanguage.LoadLanguage;
begin
  Label_ActivateFullScreen.Caption:=LangArrayValue('full_screen');
  Label_MinimizeStart.Caption:=LangArrayValue('window_minimize');
  Label_Language.Caption:=LangArrayValue('language');
  Button_Apply.Caption:=LangArrayValue('save_button');
end;

//ищем все €зыковые файлы
//в определенной папке
//и пишем их напр€мую в список
procedure FindAllLanguagesFiles(Strings:TStrings;Path:String);
var
  searchResult : TSearchRec;
begin
  Strings.Clear;
  if FindFirst(Path + '*.lng', faAnyFile, searchResult) = 0 then
  begin
    repeat
      Strings.Add(searchResult.Name);
    until FindNext(searchResult) <> 0;
    FindClose(searchResult);
  end;
end;

//загружаем данные
procedure TMainWindowAndLanguage.LoadData;
begin
  try
    CheckBox_ActivateFullScreen.Checked:=StrToBool(ConfArrayValue(FullScreenOption));
  except
    CheckBox_ActivateFullScreen.Checked:=false;
  end;
  try
    CheckBox_MinimizeStart.Checked:=StrToBool(ConfArrayValue(MinimizeOption));
  except
    CheckBox_MinimizeStart.Checked:=false;
  end;
  ComboBoxLanguage.Items.Clear;
  FindAllLanguagesFiles(ComboBoxLanguage.Items,String(Paths_GetApplicationPath));
  ComboBoxLanguage.ItemIndex:=ComboBoxLanguage.Items.IndexOf(ConfArrayValue('defaultlng'));
end;

//сохран€ем данные
procedure TMainWindowAndLanguage.SaveDataToMainProgram;
begin
  SetConfArrayValue(FullScreenOption,BoolToStr(CheckBox_ActivateFullScreen.Checked));
  SetConfArrayValue(MinimizeOption,BoolToStr(CheckBox_MinimizeStart.Checked));
  SetConfArrayValue(LanguageOption,ComboBoxLanguage.Items[ComboBoxLanguage.ItemIndex]);
end;

//конструктор
procedure TMainWindowAndLanguage.Button_ApplyClick(Sender: TObject);
begin
  SaveDataToMainProgram;
end;

constructor TMainWindowAndLanguage.Create(Owner:TComponent);
begin
  inherited Create(Owner);
  LoadLanguage;
  LoadData;
end;

end.
