{
  drComRead

  History library

  Модуль для описания
  визуальной формы для
  работы с историей
  и закладками

  Copyright (c) 2010-2011 Romanus
}
unit historyform;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ieview, imageenview, FileCtrl, ShellCtrls,
  Generics.Collections, Generics.Defaults, Tabs, Buttons;

type
  //запись закладки
  THistoryBookmark = record
    //полный путь к архиву
    FullArcPath:String;
    //только имя файла
    ArcName:String;
    //имя закладки
    BookmarkName:String;
    //дата записи
    DateRecord:String;
    //идентификатор записи
    IdRecord:Integer;
  end;

  //запись закладки
  THistoryArchive = record
    //полный путь к архиву
    FullArcPath:String;
    //только имя файла
    ArcName:String;
    //дата записи
    DateRecord:String;
    //идентификатор записи
    IdRecord:Integer;
  end;

  //запись закладки
  THistoryDirArchive = record
    //полный путь к папке
    FullArcPath:String;
    //урезанный путь к папке
    ShortPath:String;
    //дата записи
    DateRecord:String;
    //идентификатор записи
    IdRecord:Integer;
  end;

  THistoryDialog = class(TForm)
    MainTabs: TPageControl;
    ArcTab: TTabSheet;
    DirTab: TTabSheet;
    BookmarkTab: TTabSheet;
    ArchiveListBox: TListBox;
    DirListBox: TListBox;
    BookmarksListBox: TListBox;
    ImageView: TImageEnView;
    ButtonOpen: TButton;
    ButtonCancel: TButton;
    DateTimeLabel: TLabel;
    ErrorLabel: TLabel;
    TreeView: TShellTreeView;
    ComboOrderDate: TComboBox;
    LabelOrderDate: TLabel;
    ImageBookmarks: TImageEnView;
    LabelBookmarkSorting: TLabel;
    ComboBoxBookmarkSorting: TComboBox;
    TabSetArhives: TTabSet;
    SpeedButton_Help: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ArchiveListBoxClick(Sender: TObject);
    procedure ComboOrderDateChange(Sender: TObject);
    procedure DirListBoxClick(Sender: TObject);
    procedure BookmarksListBoxClick(Sender: TObject);
    procedure ComboBoxBookmarkSortingClick(Sender: TObject);
    procedure MainTabsChange(Sender: TObject);
    procedure TabSetArhivesChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SpeedButton_HelpClick(Sender: TObject);
  private
    //список архивов
    //с полными путями
    FArchivesList:TList<THistoryArchive>;
    //список папок
    //с полными путями
    FDirList:TList<THistoryDirArchive>;
    //список архивов
    //с закладками
    FBookmarksList:TList<THistoryBookmark>;
  public
    procedure LoadFullNamesToShortList;
    //обновляем определенные данные
    procedure UpdateData(Mode:Byte);
    //обновляем все данные
    procedure UpdateAll;
    //получить запись
    //архива по индексу
    function GetArchiveRecord(Index:Integer):THistoryArchive;
    //получить запись
    //закладки по индексу
    function GetBookmarkRecord(Index:Integer):THistoryBookmark;
  end;

var
  HistoryDialog: THistoryDialog;
  ErrorMessage:String = 'File don''t exists';
  ErrorDirMessage:String = 'Dir don''t exists';

procedure LoadLanguage;

implementation

uses
  CRGlobal, CRExports, SQLiteTable3,
  MainProgramHeader;

{$R *.dfm}


{$REGION 'Обновление данных'}

procedure AddToArcList(Table:TSQLiteTable);
var
  ArchiveRecord:THistoryArchive;
begin
  //создаем запись
  //для хранения данных
  //об архиве
  with Table do
  begin
    ArchiveRecord.FullArcPath:=UTF8ToWideString(FieldAsString(FieldIndex['FullPath']));
    ArchiveRecord.ArcName:=ExtractFileName(ArchiveRecord.FullArcPath);
    ArchiveRecord.DateRecord:=FieldAsString(FieldIndex['DateLastOpened']);
    ArchiveRecord.IdRecord:=FieldAsInteger(FieldIndex['ID']);
  end;
  //добавляем в коллекцию
  with HistoryDialog do
  begin
    FArchivesList.Add(ArchiveRecord);
    ArchiveListBox.Items.Add(ArchiveRecord.ArcName);
  end;
end;

procedure AddToDirList(Table:TSQLiteTable);
var
  GetStr:String;
  DirRecord:THistoryDirArchive;
begin
  with Table do
  begin
    GetStr:=UTF8ToWideString(FieldAsString(FieldIndex['FullPath']));
    DirRecord.FullArcPath:=GetStr;
    DirRecord.ShortPath:=GetStr;
    DirRecord.IdRecord:=FieldAsInteger(FieldIndex['ID']);
    DirRecord.DateRecord:=FieldAsString(FieldIndex['DateRecord']);
    HistoryDialog.FDirList.Add(DirRecord);
  end;
  HistoryDialog.DirListBox.Items.Add(GetStr);
end;

//обновляем закладки
procedure AddToBookmarks(Table:TSQLiteTable);
var
  GetStr:String;
  Bookmark:THistoryBookmark;
begin
  with Table do
  begin
    GetStr:=UTF8ToWideString(FieldAsString(FieldIndex['FullPath']));
    Bookmark.FullArcPath:=GetStr;
    Bookmark.ArcName:=ExtractFileName(GetStr);
    Bookmark.IdRecord:=FieldAsInteger(FieldIndex['ID']);
    Bookmark.DateRecord:=FieldAsString(FieldIndex['DateRecord']);
    Bookmark.BookmarkName:=FieldAsString(FieldIndex['NamePage']);
    HistoryDialog.FBookmarksList.Add(Bookmark);
  end;
  HistoryDialog.BookmarksListBox.Items.Add(Bookmark.ArcName);
end;

//обновляем определенные данные
procedure THistoryDialog.UpdateData(Mode:Byte);
begin
  case Mode of
    //обновляем архивы
    0:SQLSelectFor(
        'SELECT ID,DateLastOpened,FullPath FROM historyarchives ' +
        'ORDER BY DateLastOpened DESC',
        AddToArcList
      );
    //обновляем каталоги
    1:SQLSelectFor(
        'SELECT ID,FullPath,DateRecord FROM historydir ' +
        'ORDER BY DateRecord DESC',
        AddToDirList
      );
    //обновляем закладки
    2:SQLSelectFor(
        'SELECT ID,FullPath,DateRecord,NamePage ' +
        'FROM bookmarks ORDER BY DateRecord DESC',
        AddToBookmarks
      );
  end;
end;

//обновляем все данные
procedure THistoryDialog.UpdateAll;
begin
  HistoryDialog.FArchivesList.Clear;
  UpdateData(0);
  UpdateData(1);
  UpdateData(2);
end;

{$ENDREGION}

{$REGION 'История архивов'}

procedure THistoryDialog.ArchiveListBoxClick(Sender: TObject);
var
  CurrentRecord:THistoryArchive;
  CurrentPath:String;
  TempPath:String;
begin
  DateTimeLabel.Caption:='';
  ErrorLabel.Caption:='';
  ImageView.LayersClear;
  //только если что-то выделено
  if ArchiveListBox.ItemIndex = -1 then
    Exit;
  //текущая запись
  CurrentRecord:=FArchivesList.Items[ArchiveListBox.ItemIndex];
  //текущий путь
  CurrentPath:=CurrentRecord.FullArcPath;
  try
    DateTimeLabel.Caption:=CurrentRecord.DateRecord;
    //если файл не существует
    //то и делать нечего
    if not FileExists(CurrentPath) then
    begin
      ErrorLabel.Caption:=ErrorMessage;
      Exit;
    end;
    //извлекаем файл
    //для просмотра
    TempPath:=ExtractImageWithIndex
      (
        PWideChar(CurrentPath),
        0,
        StrToInt(MultiLanguage_GetConfigValue('sort_opened')),
        StrToBool(MultiLanguage_GetConfigValue('sort_imagesensitive'))
      );
    if TempPath <> '' then
    begin
      ImageView.IO.LoadFromFile(TempPath);
      DeleteFileW(PWideChar(TempPath));
    end;
  except
    Exit;
  end;
end;

procedure THistoryDialog.ComboOrderDateChange(Sender: TObject);
begin
  if FArchivesList.Count = 0 then
  begin
    ArchiveListBox.Clear;
    Exit;
  end;
  //сортируем нужным образом
  case ComboOrderDate.ItemIndex of
    //убывающая
    0:
      begin
        FArchivesList.Sort(
          TComparer<THistoryArchive>.Construct(
            function (const L, R: THistoryArchive): integer
            begin
              if L.DateRecord > R.DateRecord then
                Exit(-1);
              if L.DateRecord = R.DateRecord then
                Exit(0)
              else
                Exit(1);
            end
           )
        );
      end;
    //возрастающе
    1:
      begin
        FArchivesList.Sort(
          TComparer<THistoryArchive>.Construct(
            function (const L, R: THistoryArchive): integer
            begin
              if L.DateRecord < R.DateRecord then
                Exit(-1);
              if L.DateRecord = R.DateRecord then
                Exit(0)
              else
                Exit(1);
            end
           )
        );
      end;
    //убывающая по имени
    2:
      begin
        FArchivesList.Sort(
          TComparer<THistoryArchive>.Construct(
            function (const L, R: THistoryArchive): integer
            begin
              if L.IdRecord > R.IdRecord then
                Exit(-1);
              if L.IdRecord = R.IdRecord then
                Exit(0)
              else
                Exit(1);
            end
           )
        );
      end;
    //возрастающе по имени
    3:
      begin
        FArchivesList.Sort(
          TComparer<THistoryArchive>.Construct(
            function (const L, R: THistoryArchive): integer
            begin
              if L.IdRecord < R.IdRecord then
                Exit(-1);
              if L.IdRecord = R.IdRecord then
                Exit(0)
              else
                Exit(1);
            end
           )
        );
      end;
  end;
  //загружаем в список для отображения
  LoadFullNamesToShortList;
end;

//преливаем данные из одного
//списка в другой
procedure THistoryDialog.LoadFullNamesToShortList;
var
  GetPos:Integer;
begin
  ArchiveListBox.Clear;
  for GetPos:=0 to FArchivesList.Count - 1 do
    ArchiveListBox.Items.Add(ExtractFileName(FArchivesList.Items[GetPos].ArcName));
end;

procedure THistoryDialog.MainTabsChange(Sender: TObject);
begin
  DateTimeLabel.Caption:='';
  ErrorLabel.Caption:='';
end;

procedure THistoryDialog.SpeedButton_HelpClick(Sender: TObject);
begin
  ShowDocumentation(PWideChar('history'));
end;

procedure THistoryDialog.TabSetArhivesChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
var
  BasicSql:String;
begin
  //чистим списки
  FArchivesList.Clear;
  BasicSql:='SELECT ID,DateLastOpened,FullPath FROM historyarchives ';
  //выбираем то что нужно
  case NewTab of
    //все
    0:
      begin
        SQLSelectFor(
          BasicSql,
          AddToArcList
        );
      end;
    //сегодня
    1:
      begin
        SQLSelectFor(
          BasicSql +
          'WHERE DateLastOpened>=datetime(' +
          SQLStringFormat('now') + ',' +
          SQLStringFormat('-12 hours') +
          ')',
          AddToArcList
        );
      end;
    //неделя
    2:
      begin
        SQLSelectFor(
          BasicSql +
          'WHERE DateLastOpened>=date(' +
          SQLStringFormat('now') + ',' +
          SQLStringFormat('-7 days')
           + ') AND DateLastOpened<=date(' +
           SQLStringFormat('now') + ',' +
           SQLStringFormat('+1 days') +
           ')',
          AddToArcList
        );
      end;
    //месяц
    3:
      begin
        SQLSelectFor(
          BasicSql +
          'WHERE DateLastOpened>=date(' +
          SQLStringFormat('now') + ',' +
          SQLStringFormat('-30 days') +
          ') AND DateLastOpened<=date(' +
          SQLStringFormat('now') + ',' +
          SQLStringFormat('+1 days') +
          ')',
          AddToArcList
        );
      end;
  end;
  //сортируем
  ComboOrderDateChange(nil);
end;

{$ENDREGION}

{$REGION 'История каталогов'}

procedure THistoryDialog.DirListBoxClick(Sender: TObject);
var
  CurrentRecord:THistoryDirArchive;
begin
  DateTimeLabel.Caption:='';
  ErrorLabel.Caption:='';
  //должен быть выделен
  //какой-нибудь элемент
  if DirListBox.ItemIndex = -1 then
    Exit;
  CurrentRecord:=FDirList[DirListBox.ItemIndex];
  DateTimeLabel.Caption:=CurrentRecord.DateRecord;
  if not DirectoryExists(CurrentRecord.FullArcPath) then
  begin
    ErrorLabel.Caption:=ErrorDirMessage;
    Exit;
  end;
  TreeView.Root:=CurrentRecord.FullArcPath;
end;

{$ENDREGION}

{$REGION 'Закладки'}

procedure THistoryDialog.BookmarksListBoxClick(Sender: TObject);
var
  Bookmark:THistoryBookmark;
  FPath:string;
begin
  DateTimeLabel.Caption:='';
  ErrorLabel.Caption:='';
  //что-то должно быть выделено
  if BookmarksListBox.ItemIndex = -1 then
    Exit;
  Bookmark:=FBookmarksList.Items[BookmarksListBox.ItemIndex];
  if ExtractImageWithName(PWideChar(Bookmark.FullArcPath),PWideChar(Bookmark.BookmarkName)) then
  begin
    FPath:=Paths_GetTempPath+Bookmark.BookmarkName;
    try
      ImageBookmarks.IO.LoadFromFile(FPath);
      DeleteFileW(PWideChar(FPath));
    except
      //на случай если что-то пошло не так
    end;
  end;
end;

procedure THistoryDialog.ComboBoxBookmarkSortingClick(Sender: TObject);
var
  GetPos:Integer;
begin
  BookmarksListBox.Clear;
  ImageBookmarks.LayersClear;
  case ComboBoxBookmarkSorting.ItemIndex of
    //сортировка по дате убывающая
    0:FBookmarksList.Sort(
      TComparer<THistoryBookmark>.Construct(
        function (const L, R: THistoryBookmark): integer
        begin
          if L.DateRecord > R.DateRecord then
            Exit(-1);
          if L.DateRecord = R.DateRecord then
            Exit(0)
          else
            Exit(1);
        end
       ));
    //сортировка по дате возрастающая
    1:FBookmarksList.Sort(
      TComparer<THistoryBookmark>.Construct(
        function (const L, R: THistoryBookmark): integer
        begin
          if L.DateRecord < R.DateRecord then
            Exit(-1);
          if L.DateRecord = R.DateRecord then
            Exit(0)
          else
            Exit(1);
        end
       ));
    //сортировка по имени убывающая
    2:FBookmarksList.Sort(
      TComparer<THistoryBookmark>.Construct(
        function (const L, R: THistoryBookmark): integer
        begin
          if L.ArcName > R.ArcName then
            Exit(-1);
          if L.ArcName = R.ArcName then
            Exit(0)
          else
            Exit(1);
        end
       ));
    //сортировка по имени возрастающая
    3:FBookmarksList.Sort(
      TComparer<THistoryBookmark>.Construct(
        function (const L, R: THistoryBookmark): integer
        begin
          if L.ArcName < R.ArcName then
            Exit(-1);
          if L.ArcName = R.ArcName then
            Exit(0)
          else
            Exit(1);
        end
       ));
  end;
  for GetPos:=0 to FBookmarksList.Count - 1 do
    BookmarksListBox.Items.Add(FBookmarksList.Items[GetPos].ArcName);
end;

{$ENDREGION}

{$REGION 'Рутина'}

procedure THistoryDialog.FormCreate(Sender: TObject);
begin
  FArchivesList:=TList<THistoryArchive>.Create;
  FBookmarksList:=TList<THistoryBookmark>.Create;
  FDirList:=TList<THistoryDirArchive>.Create;
  SpeedButton_Help.Glyph.LoadFromFile(GetGifFileDocumentation);
end;

procedure THistoryDialog.FormDestroy(Sender: TObject);
begin
  FBookmarksList.Free;
  FArchivesList.Free;
  FDirList.Free;
end;

procedure THistoryDialog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    27:Self.Close;
  end;
end;

//получить запись
//архива по индексу
function THistoryDialog.GetArchiveRecord(Index:Integer):THistoryArchive;
begin
  Result:=FArchivesList.Items[Index];
end;

//получить запись
//закладки по индексу
function THistoryDialog.GetBookmarkRecord(Index:Integer):THistoryBookmark;
begin
  Result:=FBookmarksList.Items[Index];
end;

{$ENDREGION}

{$REGION 'Мультиязыковая поддержка'}

//получить значение
//из языковой группы
function GetLangValue(Key:String):String;
var
  Str:String;
begin
  Str:=MultiLanguage_GetGroupValue(PWideChar('HISTORYDIALOG'),PWideChar(Key));
  Result:=Str;
end;

procedure LoadLanguage;
begin
  with HistoryDialog do
  begin
    Caption:=GetLangValue('title');
    LabelBookmarkSorting.Caption:=GetLangValue('sort_title');
    LabelOrderDate.Caption:=GetLangValue('sort_title');
    ArcTab.Caption:=GetLangValue('arc_tab');
    DirTab.Caption:=GetLangValue('dir_tab');
    BookmarkTab.Caption:=GetLangValue('bookmark_tab');
    TabSetArhives.Tabs.Clear;
    TabSetArhives.Tabs.Add(GetLangValue('arc_all'));
    TabSetArhives.Tabs.Add(GetLangValue('arc_today'));
    TabSetArhives.Tabs.Add(GetLangValue('arc_weekly'));
    TabSetArhives.Tabs.Add(GetLangValue('arc_mounth'));
    ButtonOpen.Caption:=GetLangValue('open_button');
    ButtonCancel.Caption:=GetLangValue('cancel_button');
    ErrorMessage:=GetLangValue('error_message');
    ErrorDirMessage:=GetLangValue('errordir_message');

    ComboOrderDate.Items.Clear;
    ComboOrderDate.Items.Add(GetLangValue('sort_descdate'));
    ComboOrderDate.Items.Add(GetLangValue('sort_ascdate'));
    ComboOrderDate.Items.Add(GetLangValue('sort_descname'));
    ComboOrderDate.Items.Add(GetLangValue('sort_ascname'));
    ComboOrderDate.ItemIndex:=0;

    with ComboBoxBookmarkSorting.Items do
    begin
      Clear;
      Add(GetLangValue('sort_descdate'));
      Add(GetLangValue('sort_ascdate'));
      Add(GetLangValue('sort_descname'));
      Add(GetLangValue('sort_ascname'));
    end;
    ComboBoxBookmarkSorting.ItemIndex:=0;
  end;
end;

{$ENDREGION}

end.
