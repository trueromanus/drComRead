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
  //rar
  Rar;

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

implementation

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
begin
  Result:=FRARObj.Extract(AnsiString(Path),true,FFiles);
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

end.
