{
  drComRead

  ReadInfo Library

  Модуль с классом описывающим
  логику хранения данных
  о файлах

  Copyright (c) 2008-2009 Romanus
}
unit RFMainClass;

interface

uses
  Classes, SysUtils;

type
  //запись с текстовой информацией
  PRFInfoRecord = ^TRFInfoRecord;
  TRFInfoRecord = record
    FileName:WideString;
    Text:TStrings;
  end;

  TRFReadInfo = class
  private
    FTexts:TList;
    //добавляем файл
    function AddData(FileName:WideString):Boolean;
  public
    //конструктор
    constructor Create;
    //деструктор
    destructor Destroy;override;
    //очищаем все данные
    procedure Reset;
    //добавляем файл
    function AddFile(FileName:WideString):Boolean;
    //получаем указатель на
    //массив строк прочтенного файла
    function GetPointer(Index:Integer):Pointer;
    //получаем строку в масиве строк
    function GetStrToStr(Index1,Index2:Integer):String;
    //количество элементов
    function Count:Integer;
    //получаем имя файла
    function GetFileName(Index:Integer):WideString;
  end;

implementation

uses
  Windows, MainProgramHeader;

//доабвляем файл
function TRFReadInfo.AddData(FileName:WideString):Boolean;
var
  Rec:PRFInfoRecord;
begin
  Result:=false;
  if not FileExists(FileName) then
    Exit;
  New(Rec);
  Rec.FileName:=FileName;
  Rec.Text:=TStringList.Create;
  Rec.Text.LoadFromFile(FileName);
  FTexts.Add(Rec);
  Result:=true;  
end;

//конструктор
constructor TRFReadInfo.Create;
begin
  FTexts:=TList.Create;
end;

//деструктор
destructor TRFReadInfo.Destroy;
begin
  Self.Reset;
  FTexts.Free;
end;

//очищаем все данные
procedure TRFReadInfo.Reset;
var
  GetPos:Integer;
  Rec:PRFInfoRecord;
begin
  for GetPos:=0 to FTexts.Count-1 do
  begin
    Rec:=FTexts.Items[GetPos];
    Rec.Text.Free;
    Dispose(Rec);
  end;
  FTexts.Clear;    
end;

//добавляем файл
function TRFReadInfo.AddFile(FileName:WideString):Boolean;
begin
  Result:=AddData(FileName);
end;

//получаем указатель на
//массив строк прочтенного файла
function TRFReadInfo.GetPointer(Index:Integer):Pointer;
begin
  Result:=nil;
  if Index >= FTexts.Count then
    Exit;
  Result:=PRFInfoRecord(FTexts.Items[Index]).Text;
end;

//получаем строку в масиве строк
function TRFReadInfo.GetStrToStr(Index1,Index2:Integer):String;
var
  Strings:TStrings;
begin
  Result:='';
  Strings:=TStringList(GetPointer(Index1));
  if @Strings = nil then
    Exit;
  if Index2 >= Strings.Count then
    Exit;
  Result:=Strings.Strings[Index2];
end;

//количество элементов
function TRFReadInfo.Count:Integer;
begin
  Result:=FTexts.Count;
end;

//получаем имя файла
function TRFReadInfo.GetFileName(Index:Integer):WideString;
var
  Rec:PRFInfoRecord;
begin
  Result:='';
  if Index >= FTexts.Count then
    Exit;
  Rec:=FTexts.Items[Index];
  Result:=Rec.FileName;
end;

end.
