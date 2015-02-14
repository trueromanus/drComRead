{
  drComRead

  Модуль для основных
  функций распаковки архивов  

  Copyright (c) 2008-2010 Romanus
}
unit ArcFunc;

interface

uses
  Classes,
  //7zip
  sevenzip,
  //rar
  Rar,
  //zip
  AbZipTyp, AbArcTyp, AbUnZper, AbUnzPrc;

type

  //массив индексов
  TALIntArray = array of integer;
  //массив строк
  TALStrArray = array of string;

{$REGION 'Archive'}

  TALArchive = class
  private
    //имя файла
    FFileName:String;
    //список файлов
    FFiles:TStrings;
  public
    //список файлов внутри архива
    property Files:TStrings read FFiles;
    //имя файла архива
    property FileName:string read FFileName;
    //конструктор
    constructor Create(fname:String);virtual;
    //деструктор
    destructor Destroy;override;    
    //получаем имя файла по индексу
    function GetString(Index:Integer):String;
    //тестируем архив
    //на корректность
    function TestArchive:boolean;virtual;abstract;
    //читаем список файлов
    //а архиве
    function ReadListOfFiles:boolean;virtual;abstract;
    //извлечение всех файлов
    //с допустимым форматом
    function ExtractAllArchive(Path:String):boolean;virtual;abstract;
    //извлечение одного файла
    //по индексу
    function ExtractByIndex(Path:String;Index:Integer):boolean;virtual;abstract;
    //извлечение одного файла
    //по имени
    function ExtractByName(Path:String;Name:String):boolean;virtual;abstract;
    //извлекаем файлы согласно
    //массиву индексов
    function ExtractByIndexs(Path:String;Indexs:TALIntArray):boolean;virtual;abstract;
    //извлечение массива файлов
    //по имени
    function ExtractByNames(Path:String;Names:TALStrArray):boolean;virtual;abstract;
    //устанавливаем функцию обратного вызова
    function SetCallBackFunc(Func:Pointer):boolean;virtual;abstract;
  end;

{$ENDREGION}

{$REGION '7-zip,tar,arj,cab,gzip'}

  T7Zip = class(TALArchive)
  private
    //основной объект для
    //работы
    F7ZipObj:I7zInArchive;
    //поток для
    //извлечения файлов
    FStream:TMemoryStream;
  public
    //конструктор
    constructor Create(fname:String);override;
    //деструктор
    destructor Destroy;override;
    //тестируем архив
    //на корректность
    function TestArchive:boolean;override;
    //читаем список файлов
    //а архиве
    function ReadListOfFiles:boolean;override;
    //извлечение всех файлов
    //с допустимым форматом
    function ExtractAllArchive(Path:String):boolean;override;
    //извлечение одного файла
    //по индексу
    function ExtractByIndex(Path:String;Index:Integer):boolean;override;
    //извлечение одного файла
    //по имени
    function ExtractByName(Path:String;Name:String):boolean;override;
    //извлекаем файлы согласно
    //массиву индексов
    function ExtractByIndexs(Path:String;Indexs:TALIntArray):boolean;override;
    //извлечение массива файлов
    //по имени
    function ExtractByNames(Path:String;Names:TALStrArray):boolean;override;
    //устанавливаем функцию обратного вызова
    function SetCallBackFunc(Func:Pointer):Boolean;override;
  end;

{$ENDREGION}

{$REGION 'Rar'}

  TALRar = class(TALArchive)
  private
    //класс для работы
    //с rar архивами
    FRARObj:TRAR;
    //функция для обратного
    //прогресса
    FFunc:Pointer;
  protected
    //читаем файл из списка
    procedure ReadListFile(Sender: TObject; const FileInformation:TRARFileItem);
    //обрабатываем прогресс
    procedure ReadProgress(Sender: TObject; const FileName:WideString; const ArchiveBytesTotal, ArchiveBytesDone, FileBytesTotal, FileBytesDone:cardinal);
  public
    //конструктор
    constructor Create(fname:String);override;
    //деструктор
    destructor Destroy;override;
    //тестируем архив
    //на корректность
    function TestArchive:boolean;override;
    //читаем список файлов
    //а архиве
    function ReadListOfFiles:boolean;override;
    //извлечение всех файлов
    //с допустимым форматом
    function ExtractAllArchive(Path:String):boolean;override;
    //извлечение одного файла
    //по индексу
    function ExtractByIndex(Path:String;Index:Integer):boolean;override;
    //извлечение одного файла
    //по имени
    function ExtractByName(Path:String;Name:String):boolean;override;
    //извлекаем файлы согласно
    //массиву индексов
    function ExtractByIndexs(Path:String;Indexs:TALIntArray):boolean;override;
    //извлечение массива файлов
    //по имени
    function ExtractByNames(Path:String;Names:TALStrArray):boolean;override;
    //устанавливаем функцию обратного вызова
    function SetCallBackFunc(Func:Pointer):Boolean;override;
  end;

{$ENDREGION}

{$REGION 'Zip'}

  TALZip = class(TALArchive)
  private
    //класс для работы
    //с zip архивами
    FZipObj:TAbZipArchive;
    //функция для обратного
    //прогресса
    FFunc:Pointer;
  protected
    //обработчик прогресса
    procedure ProgressEvent(Sender : TObject; Item : TAbArchiveItem; Progress : Byte;
      var Abort : Boolean);
    //обработчик файла извлечения
    procedure ProcItem(Sender : TObject; Item : TAbArchiveItem;
      const NewName : string);
  public
    //конструктор
    constructor Create(fname:String);override;
    //деструктор
    destructor Destroy;override;
    //тестируем архив
    //на корректность
    function TestArchive:boolean;override;
    //читаем список файлов
    //а архиве
    function ReadListOfFiles:boolean;override;
    //извлечение всех файлов
    //с допустимым форматом
    function ExtractAllArchive(Path:String):boolean;override;
    //извлечение одного файла
    //по индексу
    function ExtractByIndex(Path:String;Index:Integer):boolean;override;
    //извлечение одного файла
    //по имени
    function ExtractByName(Path:String;Name:String):boolean;override;
    //извлекаем файлы согласно
    //массиву индексов
    function ExtractByIndexs(Path:String;Indexs:TALIntArray):boolean;override;
    //извлечение массива файлов
    //по имени
    function ExtractByNames(Path:String;Names:TALStrArray):boolean;override;
    //устанавливаем функцию обратного вызова
    function SetCallBackFunc(Func:Pointer):Boolean;override;
  end;

{$ENDREGION}

var
  //архив с которым мы работаем
  Archive:TALArchive;
  //признак создания архива 
  ArchiveIsCreated:Boolean;
  //путь для извлечения
  MainPath:String;
  //вызываемая функция
  //для показа прогресса
  CallFunc:procedure;

{$REGION 'Функции'}

//Открытие закрытие архива

//открываем архив
function OpenArchive(FName:PWideChar;Mode:Byte):Boolean;stdcall;
//закрываем архив
function CloseArchive:Boolean;stdcall;
//установка процедуры обратного
//вызова
function SetCallBackFunc(Func:Pointer):Boolean;stdcall;

//Сбор данных об архиве

//количество файлов
function CountFiles:Integer;stdcall;
//получаем имя файла
function GetFileName(Index:Integer):PWideChar;stdcall;
//установить путь для извлечения
function SetMainPath(Path:PWideChar):Boolean;stdcall;
//получить путь установленный функцией
//выше
function GetMainPath:PWideChar;stdcall;

//Извлекаем данные

//Общий путь установленный через SetMainPath
//извлекаем весь архив
function ExtractAllA:Boolean;stdcall;
//извлечь один файл
function ExtractSingleA(Index:Integer):Boolean;stdcall;
//извлечь группу файлов
function ExtractIndexesA(Indexes:TALIntArray):Boolean;stdcall;

//Для каждого извлечения
//необходимо указывать путь
//извлекаем весь архив
function ExtractAllB(Path:PWideChar):Boolean;stdcall;
//извлечь один файл
function ExtractSingleB(Path:PWideChar;Index:Integer):Boolean;stdcall;
//извлечь один файл
function ExtractSingleC(FName:PWideChar):Boolean;stdcall;
//извлечь группу файлов
function ExtractIndexesB(Path:PWideChar;Indexes:TALIntArray):Boolean;stdcall;

{$ENDREGION}

implementation

uses
  SysUtils, Dialogs;

{$REGION 'Archive'}

//конструктор
constructor TALArchive.Create(fname:String);
begin
  FFileName:=fname;
  FFiles:=TStringList.Create;
end;

//деструктор
destructor TALArchive.Destroy;
begin
  FFiles.Free;  
end;

//получаем имя файла по индексу
function TALArchive.GetString(Index:Integer):String;
begin
  Result:='';
  if Index >= FFiles.Count then
    Exit;
  Result:=FFiles.Strings[Index];
end;

{$ENDREGION}

{$REGION '7-zip,tar,arj,cab,gzip'}

function CallBackFunc(sender: Pointer; index: Cardinal;var outStream: ISequentialOutStream): HRESULT; stdcall;
var
  aStream:TStream;
begin
  aStream:=TMemoryStream.Create;
  outStream := T7zStream.Create(aStream, soReference);
  //если функция для
  //показа прогресса
  //есть то запускаем ее
  if @CallFunc <> nil then
    CallFunc();
  Result:=0;
end;

//конструктор
constructor T7Zip.Create(fname:String);
var
  Ext:String;
begin
  inherited Create(fname);
  Ext:=ExtractFileExt(fname);
  if (Ext = '.rar') or (Ext = '.cbr') then
    F7ZipObj:=CreateInArchive(CLSID_CFormatRar);
  if (Ext = '.zip') or (Ext = '.cbz') then
    F7ZipObj:=CreateInArchive(CLSID_CFormatZip);
  if (Ext = '.7z') or (Ext = '.cb7') then
    F7ZipObj:=CreateInArchive(CLSID_CFormat7z);
  if (Ext = '.arj') or (Ext = '.cba') then
    F7ZipObj:=CreateInArchive(CLSID_CFormatArj);
  if (Ext = '.tar') or (Ext = '.cbt') then
    F7ZipObj:=CreateInArchive(CLSID_CFormatTar);
  if (Ext = '.gz') or (Ext = '.cbg') then
    F7ZipObj:=CreateInArchive(CLSID_CFormatGZip);
  if (Ext = '.chm') then
    F7ZipObj:=CreateInArchive(CLSID_CFormatChm);
  if (Ext = '.bz2') then
    F7ZipObj:=CreateInArchive(CLSID_CFormatBZ2);
  if (Ext = '.lzh') then
    F7ZipObj:=CreateInArchive(CLSID_CFormatLzh);
  if (Ext = '.iso') then
    F7ZipObj:=CreateInArchive(CLSID_CFormatIso);
  //по умолчанию просто zip
  if F7ZipObj = nil then
    F7ZipObj:=CreateInArchive(CLSID_CFormatZip);
  FFileName:=fname;
end;

//деструктор
destructor T7Zip.Destroy;
begin
  I7zInArchive(F7ZipObj).Close;
  inherited Destroy;
end;

//тестируем архив
//на корректность
function T7Zip.TestArchive:boolean;
begin
  try
    F7ZipObj.OpenFile(FFileName);
    Result:=true;    
  except
    Result:=false;
  end;
end;

//читаем список файлов
//а архиве
function T7Zip.ReadListOfFiles:boolean;
var
  GetPos:Integer;
begin
  for GetPos:=0 to F7ZipObj.NumberOfItems-1 do
    if not F7ZipObj.ItemIsFolder[GetPos] and
      (F7ZipObj.ItemPath[GetPos] <> '') then
      FFiles.Add(F7ZipObj.ItemPath[GetPos]);
  Result:=true;        
end;

//извлечение всех файлов
//с допустимым форматом
function T7Zip.ExtractAllArchive(Path:String):boolean;
var
  GetPos:Integer;
begin
  try
    //извлекаем
    for GetPos:=0 to FFiles.Count-1 do
      Self.ExtractByIndex(Path,GetPos);
    Result:=true;
  except
    Result:=false;
  end;
end;

//извлечение одного файла
//по индексу
function T7Zip.ExtractByIndex(Path:String;Index:Integer):boolean;
var
  NewFileName:WideString;
begin
  Result:=false;
  if Index >= FFiles.Count then
    Exit;
  if Assigned(FStream) then
    FStream.Free;
  FStream:=TMemoryStream.Create;
  try
    F7ZipObj.ExtractItem(Index,FStream,false);
    if FStream.Size = 0 then
      F7ZipObj.ExtractItem(Index+1,FStream,false);
    //конечный слэш
    if Path[Length(Path)] <> '\' then
      Path:=Path+'\';
    //сохраняем в файл
    NewFileName:=ExtractFileName(FFiles.Strings[Index]);
    FStream.SaveToFile(Path+NewFileName);
    FreeAndNil(FStream);
    Result:=true;
  except
    Exit;
  end;
end;

//извлечение одного файла
//по имени
function T7Zip.ExtractByName(Path:String;Name:String):boolean;
var
  Index:Integer;
begin
  Result:=false;
  Index:=FFiles.IndexOf(Name);
  if Index = -1 then
    Exit;
  Result:=Self.ExtractByIndex(Path,Index);
end;

//извлекаем файлы согласно
//массиву индексов
function T7Zip.ExtractByIndexs(Path:String;Indexs:TALIntArray):boolean;
var
  GetPos:Integer;
begin
  Result:=false;
  for GetPos:=0 to High(Indexs) do
    if not Self.ExtractByIndex(Path,Indexs[GetPos]) then
      Exit;
  Result:=true;
end;

//извлечение массива файлов
//по имени
function T7Zip.ExtractByNames(Path:String;Names:TALStrArray):boolean;
var
  GetPos:Integer;
begin
  Result:=false;
  for GetPos:=0 to High(Names) do
    if not Self.ExtractByName(Path,Names[GetPos]) then
      Exit;
  Result:=true;
end;

function T7Zip.SetCallBackFunc(Func:Pointer):Boolean;
begin
  @CallFunc:=Func;
  Result:=true;
end;


{$ENDREGION}

{$REGION 'Rar'}

//читаем файл из списка
procedure TALRar.ReadListFile(Sender: TObject; const FileInformation:TRARFileItem);
begin
  FFiles.Add(FileInformation.FileNameW);
end;

//обрабатываем прогресс
procedure TALRar.ReadProgress(Sender: TObject; const FileName:WideString; const ArchiveBytesTotal, ArchiveBytesDone, FileBytesTotal, FileBytesDone:cardinal);
var
  Func:procedure;
begin
  if FFunc <> nil then
  begin
    @Func:=FFunc;
    Func();
  end;
end;

//конструктор
constructor TALRar.Create(fname:String);
begin
  inherited Create(fname);
  FRARObj:=TRar.Create(nil);
  //обработчик прогресса
  FRARObj.OnProgress:=Self.ReadProgress;
  //обработчик чтения файла
  FRARObj.OnListFile:=ReadListFile;
end;

//деструктор
destructor TALRar.Destroy;
begin
  FRARObj.Free;
  inherited Destroy;
end;

//тестируем архив
//на корректность
function TALRar.TestArchive:boolean;
begin
  try
    //пытаемся открыть
    //файл и протестировать его
    if not FRARObj.OpenFile(FFileName) then
      Exit(false);
    Result:=FRARObj.Test;
  except
    Result:=false;
  end;
end;

//читаем список файлов
//а архиве
function TALRar.ReadListOfFiles:boolean;
begin
  Result:=true;
end;

//извлечение всех файлов
//с допустимым форматом
function TALRar.ExtractAllArchive(Path:String):boolean;
{begin
  Result:=FRARObj.Extract(AnsiString(Path),true,FFiles);}
var
  GetPos:Integer;
begin
  for GetPos:=0 to FFiles.Count-1 do
    if not Self.ExtractByIndex(Path,GetPos) then
      Exit(false);
  Result:=true;
end;

//извлечение одного файла
//по индексу
function TALRar.ExtractByIndex(Path:String;Index:Integer):boolean;
var
  Strings:TStringList;
begin
  Result:=false;
  if Index >= FFiles.Count then
    Exit;
  //формируем данные
  Strings:=TStringList.Create;
  Strings.Add(FFiles.Strings[Index]);
  //пытаемся извлечь
  Result:=FRARObj.Extract(AnsiString(Path),false,Strings);
  //чистим память
  Strings.Free;
end;

//извлечение одного файла
//по имени
function TALRar.ExtractByName(Path:String;Name:String):boolean;
var
  Index:Integer;
begin
  Result:=false;
  Index:=FFiles.IndexOf(Name);
  if Index = -1 then
    Exit;
  Result:=Self.ExtractByIndex(Path,Index);
end;

//извлекаем файлы согласно
//массиву индексов
function TALRar.ExtractByIndexs(Path:String;Indexs:TALIntArray):boolean;
var
  GetPos:Integer;
begin
  Result:=false;
  for GetPos:=0 to High(Indexs) do
    if not Self.ExtractByIndex(Path,Indexs[GetPos]) then
      Exit;
  Result:=true;
end;

//извлечение массива файлов
//по имени
function TALRar.ExtractByNames(Path:String;Names:TALStrArray):boolean;
var
  GetPos:Integer;
begin
  Result:=false;
  for GetPos:=0 to High(Names) do
    if not Self.ExtractByName(Path,Names[GetPos]) then
      Exit;
  Result:=true;
end;

//устанавливаем функцию обратного вызова
function TALRar.SetCallBackFunc(Func:Pointer):Boolean;
begin
  FFunc:=Func;
  Result:=true;
end;

{$ENDREGION}

{$REGION 'Zip'}

//обработчик прогресса
procedure TALZip.ProgressEvent(Sender : TObject; Item : TAbArchiveItem; Progress : Byte;
  var Abort : Boolean);
var
  Func:procedure;
begin
  if FFunc <> nil then
  begin
    @Func:=FFunc;
    Func();
  end;
end;

//обработчик файла извлечения
procedure TALZip.ProcItem(Sender : TObject; Item : TAbArchiveItem;
  const NewName : string);
begin
  AbUnZip(Sender,TAbZipItem(Item),NewName + ExtractFileName(Item.DiskFileName));
end;

//конструктор
constructor TALZip.Create(fname:String);
begin
  inherited Create(fname);
  FZipObj:=TAbZipArchive.Create(fname,fmOpenRead);
  FZipObj.OnArchiveItemProgress:=ProgressEvent;
  FZipObj.ExtractHelper:=ProcItem;
end;

//деструктор
destructor TALZip.Destroy;
begin
  FZipObj.Free;
  inherited Destroy;
end;

//тестируем архив
//на корректность
function TALZip.TestArchive:boolean;
begin
  try
    FZipObj.Load;
    Exit(true);
  except
    Exit(false);
  end;
end;

//читаем список файлов
//а архиве
function TALZip.ReadListOfFiles:boolean;
var
  GetPos:Integer;
begin
  Result:=true;
  for GetPos:=0 to FZipObj.ItemList.Count-1 do
    FFiles.Add(TAbArchiveItem(FZipObj.ItemList.Items[GetPos]).FileName);
end;

//извлечение всех файлов
//с допустимым форматом
function TALZip.ExtractAllArchive(Path:String):boolean;
var
  GetPos:Integer;
begin
  for GetPos:=0 to FFiles.Count-1 do
    if not Self.ExtractByIndex(Path,GetPos) then
      Exit(false);
  Result:=true;
end;

//извлечение одного файла
//по индексу
function TALZip.ExtractByIndex(Path:String;Index:Integer):boolean;
begin
  try
    FZipObj.BaseDirectory:=Path;
    FZipObj.ExtractAt(Index,Path);
    Result:=true;
  except
    Result:=false;
  end;
end;

//извлечение одного файла
//по имени
function TALZip.ExtractByName(Path:String;Name:String):boolean;
var
  Index:Integer;
begin
  Index:=FFiles.IndexOf(Name);
  if Index = -1 then
    Exit(false);
  Result:=Self.ExtractByIndex(Path,Index);
end;

//извлекаем файлы согласно
//массиву индексов
function TALZip.ExtractByIndexs(Path:String;Indexs:TALIntArray):boolean;
var
  GetPos:Integer;
begin
  for GetPos:=0 to High(Indexs) do
    Self.ExtractByIndex(Path,Indexs[GetPos]);
  Result:=true;
end;

//извлечение массива файлов
//по имени
function TALZip.ExtractByNames(Path:String;Names:TALStrArray):boolean;
var
  GetPos:Integer;
begin
  for GetPos:=0 to High(Names) do
    Self.ExtractByName(Path,Names[GetPos]);
  Result:=true;
end;

//устанавливаем функцию обратного вызова
function TALZip.SetCallBackFunc(Func:Pointer):Boolean;
begin
  FFunc:=Func;
  Result:=true;
end;

{$ENDREGION}

{$REGION 'Функции'}

//открываем архив
function OpenArchive(FName:PWideChar;Mode:Byte):Boolean;
var
  Str:String;
begin
  Result:=false;
  Str:=WideCharToString(FName);
  try
    case Mode of
      //rar архив
      0:Archive:=TALRar.Create(Str);
      //zip
      1:Archive:=TALZip.Create(Str);
      //7zip,tar,cab,gzip
      2:Archive:=T7Zip.Create(Str);
	    //файл pdf
	    //3:Archive:=TALPdf.Create(FName);
    end;
  except
    Exit;
  end;
  Result:=Archive.TestArchive;
end;

//закрываем архив
function CloseArchive:Boolean;
begin
  try
    if Assigned(Archive) then
      FreeAndNil(Archive);
    Result:=true;
  except
    Result:=false;
  end;
end;

//установка процедуры обратного
//вызова
function SetCallBackFunc(Func:Pointer):Boolean;
begin
  Result:=Archive.SetCallBackFunc(Func);
end;

//количество файлов
function CountFiles:Integer;
begin
  Result:=-1;
  if Archive = nil then
    Exit;
  //читаем список файлов
  if not Archive.ReadListOfFiles then
    Exit;
  //возвращаем количество файлов
  Result:=Archive.FFiles.Count;
end;

//получаем имя файла
function GetFileName(Index:Integer):PWideChar;
var
  WStr:WideString;
begin
  Result:='';
  if Archive = nil then
    Exit;
  if Index >= Archive.FFiles.Count then
    Exit;
  WStr:=Archive.FFiles.Strings[Index];
  Result:=PWideChar(WStr);
end;

//установить путь для извлечения
function SetMainPath(Path:PWideChar):Boolean;
begin
  Result:=true;
  MainPath:=WideCharToString(Path);
end;

//получить путь установленный функцией
//выше
function GetMainPath:PWideChar;
var
  ResString:WideString;
begin
  ResString:=MainPath;
  Result:=PWideChar(ResString);
end;

//извлекаем весь архив
function ExtractAllA:Boolean;
begin
  Result:=Archive.ExtractAllArchive(MainPath);
end;

//извлечь один файл
function ExtractSingleA(Index:Integer):Boolean;
begin
  Result:=Archive.ExtractByIndex(MainPath,Index);
end;

//извлечь группу файлов
function ExtractIndexesA(Indexes:TALIntArray):Boolean;
begin
  Result:=Archive.ExtractByIndexs(MainPath,Indexes);
end;

//извлекаем весь архив
function ExtractAllB(Path:PWideChar):Boolean;
begin
  Result:=Archive.ExtractAllArchive(WideCharToString(Path));
end;

//извлечь один файл
function ExtractSingleB(Path:PWideChar;Index:Integer):Boolean;
begin
  Result:=Archive.ExtractByIndex(WideCharToString(Path),Index);
end;

//извлечь один файл
function ExtractSingleC(FName:PWideChar):Boolean;
begin
  Result:=Archive.ExtractByName(MainPath,FName);
end;

//извлечь группу файлов
function ExtractIndexesB(Path:PWideChar;Indexes:TALIntArray):Boolean;
begin
  Result:=Archive.ExtractByIndexs(WideCharToString(Path),Indexes);
end;

{$ENDREGION}


end.
