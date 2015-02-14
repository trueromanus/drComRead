unit CRArchive;

interface

uses
  Classes,
  //7zip
  sevenzip,
  SysUtils;

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
    //конструктор
    constructor Create(fname:String);virtual;
    //деструктор
    destructor Destroy;override;
    //получаем имя файла по индексу
    function GetString(Index:Integer):String;
    //извлекаем первое изображение
    function ExtractFirstImage(Path:String):String;
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

//извлекаем первое изображение
function TALArchive.ExtractFirstImage(Path:String):String;
var
  Images:TStringList;
  GetPos:Integer;
  GetExt:String;
begin
  Result:='';
  Images:=TStringList.Create;
  for GetPos:=0 to FFiles.Count-1 do
  begin
    GetExt:=LowerCase(ExtractFileExt(FFiles.Strings[GetPos]));
  if (GetExt = '.jpg')   or
     (GetExt = '.jpeg')  or
     (GetExt = '.bmp')   or
     (GetExt = '.gif')   or
     (GetExt = '.tif')   or
     (GetExt = '.tiff')  or
     (GetExt = '.tga')  or
     (GetExt = '.psd')  or
     (GetExt = '.pcx')  or
     (GetExt = '.wbmp')  or
     (GetExt = '.hdp')  or
     (GetExt = '.dcx')  or
     (GetExt = '.wdp') then
    Images.Add(FFiles.Strings[GetPos]);
  end;
  //сортируем
  Images.Sort;
  //извлекаем
  try
    if Self.ExtractByName(Path,Images.Strings[0]) then
      Result:=Images.Strings[0];
  except
    Exit('');
  end;
  //чистим за собой
  Images.Free;
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
    F7ZipObj:=CreateInArchive(CLSID_CFormatRar);
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
  Result:=true;
end;


{$ENDREGION}

end.
