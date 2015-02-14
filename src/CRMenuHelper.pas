{
  drComRead

  Модуль помошник
  для основного меню

  Copyright (c) 2009-2011 Romanus
}
unit CRMenuHelper;

interface

uses
  Menus,
  Generics.Collections;

type
  TCRMenuHelperEvent = function:Boolean;

  //запись одного действия
  //помошника меню
  TCRMenuHelperRecord = record
    Menu:TMenuItem;
    Event:TCRMenuHelperEvent;
  end;

var
  MenuHelper:TList<TCRMenuHelperRecord>;

//инициализируем помошники меню
procedure InitMenuHelpers;
//деинициализируем помошников
procedure DeInitMenuHelpers;
//выполняем процесс обновления
//меню
procedure UpdateMenu;

implementation

uses
  CRGlobal,
  MainForm;

function MenuHelperRecord(MenuItem:TMenuItem;EventFunc:TCRMenuHelperEvent):TCRMenuHelperRecord;
begin
  Result.Menu:=MenuItem;
  Result.Event:=EventFunc;
end;

//открыт ли архив
function IsArchiveOpened:Boolean;
begin
  Result:=DirObj.ArchiveOpened;
end;

//открыт ли архив
function IsImagesNotEmpty:Boolean;
begin
  Result:=DirObj.NotEmpty;
end;

//открыт ли архив
function IsManyArchives:Boolean;
begin
  Result:=(DirObj.Archives.Count > 1);
end;

//для следующего архива
function IsArchiveNext:Boolean;
begin
  Result:=IsManyArchives and (DirObj.ArchivesPos < (DirObj.Archives.Count-1));
end;

//для предыдущего архива
function IsArchivePrev:Boolean;
begin
  Result:=IsManyArchives and (DirObj.ArchivesPos > 0);
end;

//для первого архива
function IsArchiveFirst:Boolean;
begin
  Result:=IsManyArchives and (DirObj.ArchivesPos <> 0);
end;

//для последнего архива
function IsArchiveLast:Boolean;
begin
  Result:=IsManyArchives and (DirObj.ArchivesPos <> (DirObj.Archives.Count-1));
end;

//открыт ли архив
function IsTxtFilesExist:Boolean;
begin
  Result:=(DirObj.TxtFiles.Count > 0);
end;

//можно ли создать архив
function IsCreateArchive:Boolean;
begin
  Result:=(DirObj.NotEmpty and not DirObj.ArchiveOpened);
end;

//инициализируем помошники меню
procedure InitMenuHelpers;
begin
  MenuHelper:=TList<TCRMenuHelperRecord>.Create;
  //навигация по списку изображений
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_NextImage,IsImagesNotEmpty));
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_PrevImage,IsImagesNotEmpty));
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_StartImage,IsImagesNotEmpty));
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_EndImage,IsImagesNotEmpty));

  //работа с изображениями
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_ImageControl,IsImagesNotEmpty));

  //закладки
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_Bookmarks,IsArchiveOpened));

  //диалоги управления списками
  //архивов
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_ArchiveList,IsManyArchives));
  //изображений
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_SortFiles,IsImagesNotEmpty));
  //текстовых файлов
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_FileInfo,IsTxtFilesExist));

  //создание архивов
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_CreateArchive,IsCreateArchive));
  //перепаковка архивов
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_RecreateArchive,IsArchiveOpened));

  //навигация по списку архивов
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_NextArchive,IsArchiveNext));
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_PrevArchive,IsArchivePrev));
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_StartArchive,IsArchiveFirst));
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_EndArchive,IsArchiveLast));

  //единичный просмотрщик
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_SinglePreview,IsImagesNotEmpty));
end;

//деинициализируем помошников
procedure DeInitMenuHelpers;
begin
  MenuHelper.Free;
end;

//выполняем процесс обновления
//меню
procedure UpdateMenu;
var
  HelperRecord:TCRMenuHelperRecord;
begin
  for HelperRecord in MenuHelper do
    HelperRecord.Menu.Enabled:=HelperRecord.Event;
end;

end.
