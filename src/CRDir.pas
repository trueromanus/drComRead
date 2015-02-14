{
  drComRead

  Модуль работы со
  списками файлов

  Ревизия - $Revision: 1.14 $

  Copyright (c) 2008-2011 Romanus
}
unit CRDir;

interface

uses
  Windows, Classes, Generics.Collections,
  hyieutils,imageenio,imageenproc;

type
  //запись для хранения
  //изображения
  PCRFileRecord   =   ^TCRFileRecord;
  TCRFileRecord   =    record
    //имя файла
    FileName:String;
    //режим трансформации
    //0 - без трансфорамции
    //1 - поворот 80CW
    //2 - поворот 80CCW
    //3 - зеркальное горизонтальное
    //4 - зеркальное вертикальное
    TransformMode:Byte;
    //состояние поворота
    TransformRotState:Byte;
  end;

  //запись закладки
  TCRBookmark     =     record
    //имя страницы
    PageName:String;
    //номер страницы
    NumberPage:Integer;
  end;

  //тип файла
  TCRDirFileType  =   (
                        ftNone,
                        ftImage,
                        ftArchive,
                        ftTxt
                      );
  //тип архива
  TCRArchiveType  =   (
                        atUnknown,
                        atRar,
                        atZip,
                        at7zip
                      );
  //класс для работы
  //с каталогом 
  TCRDir = class
  private
    //текущая директория
    //для чтения файлов
    FGetDirectory:String;
    FDirDirectory:String;
    //текущий открытый архив
    FGetOpenedArchive:String;
    //признак удачной загрузки
    FComplete:Boolean;

    //признак того что
    //текущее изображение
    //открыто как два
    FGetImagesDouble:Boolean;
    //в архиве (или папке)
    //присутствует
    FComReadInfoFile:Boolean;

    //Архивные методы
    //список архивов
    FArchives:TStrings;
    //позиция в архивах
    FArchivesPos:integer;
    //признак того что открыт
    //архив а не директория
    FArchiveOpened:Boolean;
    //путь к папке с файлами
    //FDirPath:WideString;

    //Коллекции данных
    //текстовые файлы
    FTxtFiles:TStrings;
    //список изображений
    FImages:TList;
    //общая позиция
    FPosition:integer;

    //флаг перемещения на предыдущую
    //страницу
    FPrevPage:Boolean;

    //закладки для текущего
    //архива
    FBookmarks:TList<TCRBookmark>;
  public
    property ArchivesPos:integer read FArchivesPos write FArchivesPos default -1;
    //позиция в файловом массиве
    property Position:integer read FPosition default -1;
    //список архивов
    property Archives:TStrings read FArchives;
    //список текстовых файлов
    property TxtFiles:TStrings read FTxtFiles;
    //список изображений
    property BitmapList:TList read FImages;
    //список закладок
    property Bookmarks:TList<TCRBookmark> read FBookmarks;
    //открыт ли архив или каталог/файл
    property ArchiveOpened:Boolean read FArchiveOpened;
    //текущий открытый каталог
    property MainDirectory:String read FGetDirectory;
    //путь для извлечения файлов
    property MainDirDirectory:String read FDirDirectory;
    //текущий открытый архив
    property GetOpenedArchive:String read FGetOpenedArchive;
    //текущая страница
    //выведена как две
    property GetImagesDouble:Boolean read FGetImagesDouble;
    //есть информация из файла comread
    property ComReadInfoFile:Boolean read FComReadInfoFile;
    //конструктор
    constructor Create;overload;
    //конструктор
    //для каталогов
    constructor Create(path:string);overload;
    //создаем основные данные
    function CreateDataToDir(path:WideString):Boolean;
    //загружаем из списка файлов
    function LoadFromStrings(files:TStrings):Boolean;
    //загрузка архива
    function LoadArchive(fname:string;BaseDir:string):Boolean;
    //загружаем файл
    procedure LoadFileToType(fname:String);
    //добавляем файл
    function AddFile(fname:String):Integer;
    //загружаем уже созданное
    function LoadImage(Index:Integer):Boolean;overload;
    //загружаем две картинки сразу
    function LoadImageTwoPage(Index:Integer;JapanStyle:Boolean):Boolean;
    //деструктор
    destructor Destroy;override;
    //перемещение в массиве
    //файлов вперед
    //(если false значит это
    //конечный элемент)
    function Next:Boolean;
    //перемещение в массиве
    //файлов назад
    //(если false значит это
    //конечный элемент)
    function Prev:Boolean;
    //перемещение в начало
    function StartPos:Boolean;
    //перемещение в конец
    function EndPos:Boolean;
    //поставить изображение
    //по номеру
    function SetNumImage(Number:integer):Boolean;
    //последнее ли изображение
    //в списке
    function isEndIsList:Boolean;
    //первое ли изображение
    //в списке
    function isStartIsList:Boolean;
    //перемещение в списке архивов
    //следующий архив
    function NextArchive:Boolean;
    //предыдущий архив
    function PrevArchive:Boolean;
    //это последний архив списке
    function isEndArchive:Boolean;
    //это первый архив в списке
    function isStartArchive:Boolean;
    //получаем текущее
    //изображение
    function GetBitmap:TIEBitmap;
    //проверка на заполненность
    function NotEmpty:boolean;
    //очищаем данные
    procedure ClearData(const AllClear:Boolean = true);
    //чистим все для директории
    procedure ClearToDirOpened;
    //получить элемент
    //с индексом Index
    function GetElement(Index:Integer):PCRFileRecord;overload;
    //получить элемент
    //с именем Name
    function GetElement(Name:String):Integer;overload;
  end;

//определяем тип файла
function GetFileType(fname:string):TCRDirFileType;
//определяем тиа архива
function GetArchiveType(fname:string):TCRArchiveType;

implementation

uses
  SysUtils, Graphics, MainForm,
  CRGlobal, CRImageVisual,
  DLLHeaders, ArcFunc;


{$REGION 'Работа с данными'}

//конструктор
constructor TCRDir.Create;
begin
  //список архивов
  FArchives:=TStringList.Create;
  //список текстовичков
  FTxtFiles:=TStringList.Create;
  //список изображений
  FImages:=TList.Create;
  //список закладок
  FBookmarks:=TList<TCRBookmark>.Create;
  //флаг откртого файла комридера
  //в false
  FComReadInfoFile:=false;
  //позиция за границы диапозона
  FPosition:=-1;
  FComplete:=false;
end;

//конструктор
constructor TCRDir.Create(path:string);
begin
  //проверка корректности
  //пути
  if path[Length(path)] <> '\' then
    path:=path+'\';
  //общий конструктор
  Self.Create;
  //создаем данные
  Self.CreateDataToDir(path);
end;

//создаем основные данные
function TCRDir.CreateDataToDir(path:WideString):Boolean;
  procedure FindFilesWithDir(NewPath:String);
  var
    //запись о файле
    findRes:TSearchRec;
  begin
    if NewPath[Length(NewPath)] <> '\' then
      NewPath:=NewPath+'\';
    //обрабатываем сначала файлы
    if FindFirst(NewPath+'*.*',faAnyFile,findRes) = 0 then
    begin
      //читаем в цикле
      //все файлы
      repeat
        NextFrameAnim;
        LoadFileToType(NewPath+findRes.Name);
      until FindNext(findRes) <> 0;
      //чистим за собой
      FindClose(findRes);
    end;
    //потом папки
    if FindFirst(NewPath+'*.*',faDirectory,findRes) = 0 then
    begin
      repeat
        if (findRes.Attr = faDirectory)and
          (findRes.Name <> '.') and (findRes.Name <> '..') then
          FindFilesWithDir(NewPath+findRes.Name);
      until FindNext(findRes) <> 0;
    end;
  end;
begin
  SetMainPath(PWideChar(PathToBaseDir));
  FGetOpenedArchive:='';
  FArchiveOpened:=false;
  //центируем изображение
  //для анимации
  CenteredAnimsImage;

  //получаем данные из всех
  //вложенных папок
  FindFilesWithDir(path);

  //децентрируем изображение 
  UncenteredAnimsImage;
  FDirDirectory:=path;
  //сортируем архивы
  SortArchivesList(GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,'sort_arcopened',0));
  if (not NotEmpty) and (FArchives.Count > 0) then
    Exit(LoadArchive(FArchives.Strings[0],PathToBaseDir))
  else
    //сортируем файлы
    Exit(MainSortFiles(SortFileMode));
end;

//загружаем из списка файлов
function TCRDir.LoadFromStrings(Files:TStrings):Boolean;
var
  pos:integer;
  GetStr:String;
begin
  Result:=false;
  FGetOpenedArchive:='';
  FArchiveOpened:=false;
  if not ArcFunc.SetMainPath(PWideChar(PathToBaseDir)) then
    Exit;
  //при этом конфигурационные
  //файлы должны быть в архивах
  CenteredAnimsImage;
  for pos := 0 to files.Count-1 do
  begin
    NextFrameAnim;
    //обрабатываем файл
    LoadFileToType(files.Strings[pos]);
  end;
  UncenteredAnimsImage;
  //сортируем архивы
  SortArchivesList(GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,'sort_arcopened',0));
  //пишем в историю
  //все открытые архивы
  if EnableHistory then
    for GetStr in Archives do
      AddHistoryArc(PWideChar(GetStr));

  //если нет выбранных изображений
  //а есть архивы, то грузим
  //первый архив
  if (not NotEmpty) and (FArchives.Count > 0) then
    Exit(LoadArchive(FArchives.Strings[0],PathToBaseDir));
  Result:=true;
end;

//создаем данные из архива
//открываем архив
function TCRDir.LoadArchive(fname:string;BaseDir:string):Boolean;
var
  //признак удачного
  //завершения
  Complete:Boolean;
  //текущая позиция
  GetPos:Integer;
  //строка для преобразования
  WStr:WideString;
  //массив дял получения
  //закладок
  ArrBookmarks:TWideCharHistoryArray;
  //запись закладки
  Bookmark:TCRBookmark;
begin
  ChangeCursor(1);
  Result:=false;
  FGetOpenedArchive:='';
  WStr:=fname;
  Complete:=false;
  case GetArchiveType(fname) of
    atRar:Complete:=ArcFunc.OpenArchive(PWideChar(WStr),0);
    atZip:Complete:=ArcFunc.OpenArchive(PWideChar(WStr),1);
    at7zip:Complete:=ArcFunc.OpenArchive(PWideChar(WStr),2);
    atUnknown:Complete:=false;//неизвестный архив
  end;
  if not Complete then
  begin
    ChangeCursor(0);
    Exit;
  end;
  FGetOpenedArchive:=fname;
  //устанавливаем процедуру
  //дла обработки обратного вызова
  WStr:=BaseDir;
  //устанавливаем путь для распаковки
  ArcFunc.SetMainPath(PWideChar(WStr));
  //пишем список файлов
  for GetPos:=0 to ArcFunc.CountFiles-1 do
  begin
    LoadFileToType(ArcFunc.GetFileName(GetPos));
    NextFrameAnimToCallBack;
  end;
  //сортируем файлы
  MainSortFiles(SortFileMode);
  //пишем в историю
  //текущий открываемый архив
  if EnableHistory then
  begin
    //добавляем в историю архивов
    AddHistoryArc(PWideChar(fname));
    //обновляем меню архивов
    LoadMenuToArcHistory;
    //ищем закладки для текущего
    //архива
    ArrBookmarks:=FindAllBookmarkArchive(PWideChar(fname),true);
    FBookmarks.Clear;
    if High(ArrBookmarks) > -1 then
    begin
      for GetPos:=0 to High(ArrBookmarks) do
      begin
        Bookmark.PageName:=ArrBookmarks[GetPos];
        Bookmark.NumberPage:=GetElement(Bookmark.PageName);
        FBookmarks.Add(Bookmark);
      end;
    end;
  end;
  FArchiveOpened:=true;
  Result:=True;
  ChangeCursor(0);
end;

//загружаем файл
procedure TCRDir.LoadFileToType(fname:String);
begin
  //обрабатываем файл
  case GetFileType(fname) of
    //файл с текстовой информацией
    ftTxt:
      FTxtFiles.Add(fname);
    //архивы
    ftArchive:
      //добавляем в архивы
      FArchives.Add(fname);
    //изображения
    ftImage:
      //добавляем к изображениям
      AddFile(fname);
  end;
end;

//добавляем файл
function TCRDir.AddFile(fname:String):Integer;
var
  Rec:PCRFileRecord;
begin
  Result:=-1;
  New(Rec);
  if Rec = nil then
    Exit;  
  Rec.FileName:=fname;
  Rec.TransformMode:=0;
  Rec.TransformRotState:=0;
  FImages.Add(Rec);
  Result:=FImages.Count-1;
end;

//загружаем уже созданное
function TCRDir.LoadImage(Index:Integer):Boolean;
var
  Rec:PCRFileRecord;
  WDir:WideString;
  FileName:String;
begin
  Result:=false;
  if Index >= FImages.Count then
    Exit;
  FGetImagesDouble:=false;
  //получаем элемент
  Rec:=FImages.Items[Index];
  try
    //если открыт архив
    if FArchiveOpened then
    begin
      //извлекаем из архива
      //во временную папку
      WDir:=Rec.FileName;
      if not ArcFunc.ExtractSingleC(PWideChar(WDir)) then
        Exit;
      //на случай если путь
      //будет состоять из обратных
      //слэшов
      WDir:=StringReplace(WDir,'/','\',[rfReplaceAll]);
      //получаем имя файла
      FileName:=PathToBaseDir + ExtractFileName(WDir);
    end else
      //получаем имя файла
      FileName:=Rec.FileName;
    //загружаем файл напрямую
    //в виевер
    //FormMain.MainImage.IO.LoadFromFile(FileName);
    CreateImageResizer(FileName);
    //чистим каталог после прочтения
    if FArchiveOpened then
      DeleteFile(FileName);
    Result:=true;
  except
    //что-то пошло не так
    Result:=false;
  end;
end;

//получение картинки
//для просмотра
function TCRDir.LoadImageTwoPage(Index:Integer;JapanStyle:Boolean):Boolean;

//получаем файл и корректируем путь
//если это актуально
function FormingFilePath(FileName:String):String;
var
  WDir:WideString;
begin
  //если открыт архив
  if FArchiveOpened then
  begin
    //извлекаем из архива
    //во временную папку
    WDir:=FileName;
    if not ArcFunc.ExtractSingleC(PWideChar(WDir)) then
      Exit;
    //на случай если путь
    //будет состоять из обратных
    //слэшов
    WDir:=StringReplace(WDir,'/','\',[rfReplaceAll]);
    //получаем имя файла
    Result:=PathToBaseDir + ExtractFileName(WDir);
  end else
    //получаем имя файла
    Result:=FileName;
end;

var
  Rec:PCRFileRecord;
  Rec2:PCRFileRecord;
  FlagTwo:Boolean;
  FileName:String;
  FileNameTwo:String;
  FileIO:TImageEnIO;
  FileProc:TImageEnProc;
  OneBitmap:TIEBitmap;
  TwoBitmap:TIEBitmap;
  ResultBitmap:TIEBitmap;
begin
  Result:=false;
  Rec2:=nil;
  FileProc:=nil;
  FileIO:=nil;
  if Index >= FImages.Count then
    Exit;
  //если идем назад
  //
  if FPrevPage then
  begin
    //получаем элемент
    Rec:=FImages.Items[Index+1];
    if Index+1 < FImages.Count then
      Rec2:=FImages.Items[Index];
  end else
  begin
    //получаем элемент
    Rec:=FImages.Items[Index];
    if Index+1 < FImages.Count then
      Rec2:=FImages.Items[Index+1];
  end;
  try
    FileName:=FormingFilePath(Rec.FileName);
    FileIO:=TImageEnIO.Create(nil);
    //загружаем первый
    //файл
    OneBitmap:=TIEBitmap.Create(nil);
    FileIO.IEBitmap:=OneBitmap;
    FileIO.LoadFromFile(FileName);
    //только если портрет
    //мы будем схлапывать
    FlagTwo:=false;
    FileNameTwo:=FormingFilePath(Rec2.FileName);
    if (OneBitmap.Width < OneBitmap.Height) and (Index <> 0) and (Assigned(Rec2)) and (FileNameTwo <> '') then
    begin
      TwoBitmap:=TIEBitmap.Create(nil);
      FileIO.IEBitmap:=TwoBitmap;
      FileIO.LoadFromFile(FileNameTwo);
      FileProc:=TImageEnProc.Create(nil);
      //если второй не портрет то
      //не будем схлапывать
      if TwoBitmap.Width < OneBitmap.Height then
      begin
        //корректируем размеры
        ResultBitmap:=TIEBitmap.Create(nil);
        //если первое по высоте больше
        if OneBitmap.Height > TwoBitmap.Height then
        begin
          //подгоняем второе
          FileProc.AttachedIEBitmap:=TwoBitmap;
          FileProc.Resample(-1,OneBitmap.Height);
        end else
        //если второе по выстоте больше
        begin
          //подгоняем первое
          FileProc.AttachedIEBitmap:=OneBitmap;
          FileProc.Resample(-1,TwoBitmap.Height);
        end;
        //сливаем обе картинки в одну
        //или в японском стиле
        if JapanStyle then
        begin
          ResultBitmap.AssignImage(TwoBitmap);
          ResultBitmap.Resize(OneBitmap.Width+TwoBitmap.Width,TwoBitmap.Height);
          OneBitmap.DrawToCanvas(ResultBitmap.Canvas,TwoBitmap.Width,0);
        end else
        //или в обычном страничном
        begin
          ResultBitmap.AssignImage(OneBitmap);
          ResultBitmap.Resize(OneBitmap.Width+TwoBitmap.Width,TwoBitmap.Height);
          TwoBitmap.DrawToCanvas(ResultBitmap.Canvas,OneBitmap.Width,0);
        end;
        //FormMain.MainImage.IEBitmap.AssignImage(ResultBitmap);
        CreateImageResizer(ResultBitmap);
        //чистим за собой
        OneBitmap.Free;
        TwoBitmap.Free;
        ResultBitmap.Free;
        FileProc.Free;
        FileIO.Free;
        FlagTwo:=true;
        FGetImagesDouble:=true;
      end else
        TwoBitmap.Free;
    end;
    //если не получилось
    //сделать два изображения
    //то выводим только одно
    if not FlagTwo then
    begin
      //FormMain.MainImage.IEBitmap.AssignImage(OneBitmap);
      CreateImageResizer(OneBitmap);
      //чистим за собой
      OneBitmap.Free;
      try
        if Assigned(FileIO) then
          FileIO.Free;
        if Assigned(FileProc) then
          FileProc.Free;
      except
      end;
      FGetImagesDouble:=false;
    end;
    //чистим каталог после прочтения
    if FArchiveOpened then
    begin
      DeleteFile(FileName);
      DeleteFile(FileNameTwo);
    end;
    Result:=true;
  except
    //что-то пошло не так
    Result:=false;
    if Assigned(FileIO) then
      FileIO.Free;
  end;
end;

//деструктор
destructor TCRDir.Destroy;
begin
  ClearData;
  FTxtFiles.Free;
  FArchives.Free;
  FImages.Free;
  FBookmarks.Free;
end;

{$ENDREGION}

{$REGION 'Работа со списком'}

//перемещение в массиве
//файлов вперед
//(если false значит это
//конечный элемент)
function TCRDir.Next:boolean;
begin
  FPrevPage:=false;
  if FGetImagesDouble and not ReadBoolConfig('two_pages_long') then
  begin
    if FPosition < FImages.Count-1 then
    begin
      FPosition:=FPosition+2;
      if FPosition = FImages.Count then
        FPosition:=FImages.Count-1;
      Result:=true;
    end else
      Result:=false;
  end else
  begin
    if FPosition < FImages.Count-1 then
    begin
      FPosition:=FPosition+1;
      Result:=true;
    end else
      Result:=false;
  end;
end;

//перемещение в массиве
//файлов назад
//(если false значит это
//конечный элемент)
function TCRDir.Prev:boolean;
begin
  FPrevPage:=false;
  if FGetImagesDouble and not ReadBoolConfig('two_pages_long') then
  begin
    if FPosition > 0 then
    begin
      FPosition:=FPosition-2;
      if FPosition < 0 then
        FPosition:=0;
      if FPosition > 1 then
        FPrevPage:=true;
      Result:=true;
    end else
      Result:=false;
  end else
  begin
    if FPosition > 0 then
    begin
      FPosition:=FPosition-1;
      Result:=true;
    end else
      Result:=false;
  end;
end;

//перемещение в начало
function TCRDir.StartPos:boolean;
begin
  Result:=false;
  FPrevPage:=false;
  if Self.NotEmpty then
  begin
    FPosition:=0;
    Result:=true;
  end;
end;

//перемещение в конец
function TCRDir.EndPos:boolean;
begin
  Result:=false;
  FPrevPage:=false;
  if Self.NotEmpty then
  begin
    FPosition:=FImages.Count-1;
    Result:=true;
  end;
end;

//поставить изображение
//по номеру
function TCRDir.SetNumImage(Number:integer):boolean;
begin
  Result:=false;
  FPrevPage:=false;
  if Number < FImages.Count then
  begin
    FPosition:=Number;
    Result:=true;
  end;
end;

//последнее ли изображение
//в списке
function TCRDir.isEndIsList:Boolean;
begin
  Result:=false;
  if Position = FImages.Count-1 then
    Result:=true;
end;

//первое ли изображение
//в списке
function TCRDir.isStartIsList:Boolean;
begin
  Result:=false;
  if (Position = 0) and (FImages.Count > 0) then
    Result:=true;
end;

//перемещение в списке архивов
//следующий архив
function TCRDir.NextArchive:boolean;
begin
  Result:=false;
  if FArchivesPos < FArchives.Count then
  begin
    FArchivesPos:=FArchivesPos+1;
    Result:=true;
  end;
end;

//предыдущий архив
function TCRDir.PrevArchive:boolean;
begin
  Result:=false;
  if FArchivesPos > 0 then
  begin
    FArchivesPos:=FArchivesPos-1;
    Result:=true;
  end;
end;

//это последний архив списке
function TCRDir.isEndArchive:Boolean;
begin
  Result:=false;
  if FArchivesPos = FArchives.Count-1 then
    Result:=true;
end;

//это первый архив в списке
function TCRDir.isStartArchive:Boolean;
begin
  Result:=false;
  if (FArchivesPos = 0) and (FArchives.Count > 0) then
    Result:=true;
end;

//получаем текущее
//изображение
function TCRDir.GetBitmap:TIEBitmap;
begin
  Result:=nil;
  if (FPosition < 0) then
    Exit;
  if ReadBoolConfig('two_pages') and Self.LoadImageTwoPage(FPosition,ReadBoolConfig('two_pages_japan')) then
    Exit(FormMain.MainImage.IEBitmap);
  if Self.LoadImage(FPosition) then
    Result:=FormMain.MainImage.IEBitmap;
end;

//проверка на заполненность
function TCRDir.NotEmpty:boolean;
begin
  Result:=true;
  if FImages.Count = 0 then
    Result:=false;
end;

//получить элемент
//с индексом Index
function TCRDir.GetElement(Index:Integer):PCRFileRecord;
begin
  Result:=nil;
  if Index >= FImages.Count then
    Exit;
  Result:=FImages.Items[Index];
end;

//получить элемент
//с именем Name
function TCRDir.GetElement(Name:String):Integer;
var
  GetPos:Integer;
begin
  if FImages.Count = 0 then
    Exit(-1);
  for GetPos:=0 to FImages.Count-1 do
    if PCRFileRecord(FImages.Items[GetPos]).FileName = Name then
      Exit(GetPos);
  Result:=-1;
end;

{$ENDREGION}

{$REGION 'Чистим за собой'}

//очищаем данные
procedure TCRDir.ClearData(const AllClear:Boolean = true);
var
  pos:integer;
  FileRec:PCRFileRecord;
  OldArc:Boolean;
begin
  //удаляем текстовые файлы
  if FTxtFiles.Count > 0 then
    for pos := 0 to FTxtFiles.Count-1 do
      DeleteFile(FTxtFiles.Strings[pos]);
  FTxtFiles.Clear;
  if AllClear then
    FArchives.Clear;
  for pos := 0 to FImages.Count - 1 do
  begin
    FileRec:=FImages.Items[pos];
    //FileRec.Image.Free;
    Dispose(FileRec);
  end;
  FImages.Clear;
  FBookmarks.Clear;
  OldArc:=FArchiveOpened;
  FArchiveOpened:=false;
  FPosition:=-1;
  try
    //закрываем архив
    if OldArc then
      CloseArchive;
  except
    //на всякий случай
  end;
end;

//чистим все для директории
procedure TCRDir.ClearToDirOpened;
var
  pos:Integer;
begin
  if FTxtFiles.Count > 0 then
    for pos := 0 to FTxtFiles.Count-1 do
      DeleteFile(FTxtFiles.Strings[pos]);
  FTxtFiles.Clear;
  FImages.Clear;
  FBookmarks.Clear;
  FPosition:=-1;
  FArchiveOpened:=false;
  try
    ArcFunc.CloseArchive;
  except
    //для перестраховки
  end;
end;

{$ENDREGION}

{$REGION 'Служебные функции'}

//определяем тип файла
function GetFileType(fname:string):TCRDirFileType;
var
  FileExt:String;
begin
  //получаем расширение
  FileExt:=LowerCase(ExtractFileExt(fname));
  //если расширение
  //не распознано то пропускаем
  Result:=ftNone;
  //изображения
  if (FileExt = '.jpg')   or
     (FileExt = '.jpeg')  or
     (FileExt = '.jpe')  or
     (FileExt = '.jif')  or
     (FileExt = '.jp2')  or

     (FileExt = '.bmp')   or
     (FileExt = '.wmf')   or
     (FileExt = '.emf')   or
     (FileExt = '.gif')   or
     (FileExt = '.png')   or

     (FileExt = '.tif')   or
     (FileExt = '.tiff')  or
     (FileExt = '.fax')   or
     (FileExt = '.g3n')   or
     (FileExt = '.g3f')   or
     (FileExt = '.xif')   or
     (FileExt = '.psd')   or

     (FileExt = '.tga')   or
     (FileExt = '.targa') or
     (FileExt = '.vda')   or
     (FileExt = '.icb')   or
     (FileExt = '.vst')   or
     (FileExt = '.pix')   or

     (FileExt = '.dcx')   or
     (FileExt = '.wdp')   or
     (FileExt = '.hdp')   or
     (FileExt = '.wbmp') then
    Result:=ftImage;
  //архивы
  if (FileExt = '.zip') or
     (FileExt = '.rar') or
     (FileExt = '.cbr') or
     (FileExt = '.cbz') or
     (FileExt = '.7z') or
     (FileExt = '.cb7') or
     (FileExt = '.tar') or
     (FileExt = '.cbt') or
     (FileExt = '.arj') or
     (FileExt = '.cba') or
     (FileExt = '.gz') or
     (FileExt = '.cbg') then
    Result:=ftArchive;
  //файл с информацией
  if FileExt = '.txt' then
    Result:=ftTxt;
end;

//определяем тиа архива
function GetArchiveType(fname:string):TCRArchiveType;
var
  FileExt:String;
begin
    //получаем расширение
  FileExt:=LowerCase(ExtractFileExt(fname));
  //если расширение
  //не распознано то пропускаем
  Result:=atUnknown;
  if (FileExt = '.zip') or (FileExt = '.cbz') then
    Result:=atZip;
  if (FileExt = '.rar') or (FileExt = '.cbr') then
    Result:=atRar;
  //7zip,arj,tar,gz
  if (FileExt = '.7z') or (FileExt = '.cb7') or
     (FileExt = '.tar') or (FileExt = '.cbt') or
     (FileExt = '.arj') or (FileExt = '.cba') or
     (FileExt = '.gz') or (FileExt = '.cbg') then
    Result:=at7zip;
end;

{$ENDREGION}

end.
