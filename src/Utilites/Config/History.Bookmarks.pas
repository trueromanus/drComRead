{
  drComRead

  ћодуль настроек программы

  Ќастройки закладок

  Copyright (c) 2012 Romanus
}
unit History.Bookmarks;

interface

uses
  Controls, Forms, StdCtrls, ExtCtrls, Classes;

const
  BookmarkGotoLastOption        =           'goto_bookmark_last';
  BookmarkIsOneOption           =           'bookmark_is_one';
  BookmarkCloseProgramOption    =           'addbookmark_closeprogram';
  BookmarkCloseArchiveOption    =           'addbookmark_close';

type
  THistoryBookmark = class(TFrame)
    Button_Apply: TButton;
    Panel_Separator: TPanel;
    Panel_Separator2: TPanel;
    Label_ChangeToLastBookmark: TLabel;
    CheckBox_ChangeToLastBookmark: TCheckBox;
    Label_BookmarkIsOne: TLabel;
    CheckBox_BookmarkIsOne: TCheckBox;
    Panel_Separator3: TPanel;
    Label_AddCloseProgram: TLabel;
    CheckBox_AddCloseProgram: TCheckBox;
    Panel1: TPanel;
    Label_AddCloseArchive: TLabel;
    CheckBox_AddCloseArchive: TCheckBox;
    Panel2: TPanel;
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
  SysUtils,
  MainProgramHeader, ConfigGlobal;


//загружаем €зык
procedure THistoryBookmark.LoadLanguage;
begin
  Label_ChangeToLastBookmark.Caption:=LangArrayValue('bookmarks_change_last');
  Label_BookmarkIsOne.Caption:=LangArrayValue('bookmarks_is_one');
  Label_AddCloseProgram.Caption:=LangArrayValue('bookmarks_close_program');
  Label_AddCloseArchive.Caption:=LangArrayValue('bookmarks_close_archive');
  Button_Apply.Caption:=LangArrayValue('save_button');
end;

//загружаем данные
procedure THistoryBookmark.LoadData;
begin
  try
    CheckBox_ChangeToLastBookmark.Checked:=StrToBool(ConfArrayValue(BookmarkGotoLastOption))
  except
    CheckBox_ChangeToLastBookmark.Checked:=true;
  end;
  try
    CheckBox_BookmarkIsOne.Checked:=StrToBool(ConfArrayValue(BookmarkIsOneOption))
  except
    CheckBox_BookmarkIsOne.Checked:=true;
  end;
  try
    CheckBox_AddCloseProgram.Checked:=StrToBool(ConfArrayValue(BookmarkCloseProgramOption))
  except
    CheckBox_AddCloseProgram.Checked:=true;
  end;
  try
    CheckBox_AddCloseArchive.Checked:=StrToBool(ConfArrayValue(BookmarkCloseArchiveOption))
  except
    CheckBox_AddCloseArchive.Checked:=true;
  end;
end;

//сохран€ем данные
procedure THistoryBookmark.SaveDataToMainProgram;
begin
  SetConfArrayValue(BookmarkGotoLastOption,BoolToStr(CheckBox_ChangeToLastBookmark.Checked));
  SetConfArrayValue(BookmarkIsOneOption,BoolToStr(CheckBox_BookmarkIsOne.Checked));
  SetConfArrayValue(BookmarkCloseProgramOption,BoolToStr(CheckBox_AddCloseProgram.Checked));
  SetConfArrayValue(BookmarkCloseArchiveOption,BoolToStr(CheckBox_AddCloseArchive.Checked));
end;

procedure THistoryBookmark.Button_ApplyClick(Sender: TObject);
begin
  SaveDataToMainProgram;
end;

constructor THistoryBookmark.Create(Owner:TComponent);
begin
  inherited Create(Owner);
  LoadLanguage;
  LoadData;
end;

end.
