{
  drComRead

  ћодуль настроек программы

  ќбщие настройки
  сортировки файлов и архивов

  Copyright (c) 2012 Romanus
}
unit Archives.Sort;

interface

uses
  SysUtils, Classes, Controls, Forms, ExtCtrls, StdCtrls;

const
  SortingFileOption             =             'sort_opened';
  SortingArchiveOption          =             'sort_arcopened';
  SensitiveFilesOption          =             'sort_imagesensitive';
  SensitiveArchivesOption       =             'sort_archivesensitive';

type
  TFrameArchiveSort = class(TFrame)
    Panel_Separator: TPanel;
    Button_Apply: TButton;
    Label_Sensitivy: TLabel;
    CheckBox_Sensitive: TCheckBox;
    Panel1: TPanel;
    ComboBox_SortingFiles: TComboBox;
    Label_SortingFiles: TLabel;
    Label_SensitiveArchives: TLabel;
    CheckBox_SensitiveArchive: TCheckBox;
    Panel2: TPanel;
    ComboBox_SortingArchives: TComboBox;
    Label_SortingArchives: TLabel;
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
procedure TFrameArchiveSort.LoadLanguage;
begin
  Label_Sensitivy.Caption:=LangArrayValue('sort_sensitive');
  Label_SensitiveArchives.Caption:=LangArrayValue('sort_sensitive_archives');
  Label_SortingFiles.Caption:=LangArrayValue('sort_to_opened');
  Label_SortingArchives.Caption:=LangArrayValue('sort_archive');

  ComboBox_SortingFiles.Items.Clear;
  ComboBox_SortingFiles.Items.Add(LangArrayValue('sort_none'));
  ComboBox_SortingFiles.Items.Add(LangArrayValue('sort_ascfull'));
  ComboBox_SortingFiles.Items.Add(LangArrayValue('sort_descfull'));
  ComboBox_SortingFiles.Items.Add(LangArrayValue('sort_asc'));
  ComboBox_SortingFiles.Items.Add(LangArrayValue('sort_desc'));

  ComboBox_SortingArchives.Items.Clear;
  ComboBox_SortingArchives.Items.Add(LangArrayValue('sort_none'));
  ComboBox_SortingArchives.Items.Add(LangArrayValue('sort_ascfull'));
  ComboBox_SortingArchives.Items.Add(LangArrayValue('sort_descfull'));
  ComboBox_SortingArchives.Items.Add(LangArrayValue('sort_asc'));
  ComboBox_SortingArchives.Items.Add(LangArrayValue('sort_desc'));

  Button_Apply.Caption:=LangArrayValue('save_button');
end;

//загружаем данные
procedure TFrameArchiveSort.LoadData;
begin
  try
    CheckBox_Sensitive.Checked:=StrToBool(ConfArrayValue(SensitiveFilesOption));
  except
    CheckBox_Sensitive.Checked:=false;
  end;
  try
    CheckBox_SensitiveArchive.Checked:=StrToBool(ConfArrayValue(SensitiveArchivesOption));
  except
    CheckBox_SensitiveArchive.Checked:=false;
  end;
  ComboBox_SortingFiles.ItemIndex:=StrToInt(ConfArrayValue(SortingFileOption));
  ComboBox_SortingArchives.ItemIndex:=StrToInt(ConfArrayValue(SortingArchiveOption));
end;

//сохран€ем данные
procedure TFrameArchiveSort.SaveDataToMainProgram;
begin
  SetConfArrayValue(SensitiveFilesOption,BoolToStr(CheckBox_Sensitive.Checked));
  SetConfArrayValue(SensitiveArchivesOption,BoolToStr(CheckBox_SensitiveArchive.Checked));
  SetConfArrayValue(SortingFileOption,IntToStr(ComboBox_SortingFiles.ItemIndex));
  SetConfArrayValue(SortingArchiveOption,IntToStr(ComboBox_SortingArchives.ItemIndex));
end;

procedure TFrameArchiveSort.Button_ApplyClick(Sender: TObject);
begin
  SaveDataToMainProgram;
end;

constructor TFrameArchiveSort.Create(Owner:TComponent);
begin
  inherited Create(Owner);
  LoadLanguage;
  LoadData;
end;

end.
