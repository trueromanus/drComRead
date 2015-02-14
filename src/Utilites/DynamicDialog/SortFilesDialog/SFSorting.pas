{
  drComRead

  Sorting Library

  Модуль с описанием
  сортировочных функций

  Copyright (c) 2008-2009 Romanus
}
unit SFSorting;

interface

uses
  Classes;


{$REGION 'Работа со списком'}

//добавить элемент
function AddElement(Str:PWideChar):Boolean;stdcall;
//количество элементов
function CountElements:Integer;stdcall;
//очистить список
function ClearElements:Boolean;stdcall;
//получить значение элемента
//по индексу
function GetElement(Index:Integer):PWideChar;stdcall;
//сортируем нисходяще
function AscSortList:Boolean;stdcall;
//сортируем восходяще
function DescSortList:Boolean;stdcall;
//сортируем нисходяще
//только по именам файлов
function AscSortListOF:Boolean;stdcall;
//сортируем восходяще
//только по именам файлов
function DescSortListOF:Boolean;stdcall;
//основна функция сортировки
function SortFilesMainFunc(Mode:Byte):Boolean;stdcall;
//целиковая функция сортировки
function SortingFilesAtList(Mode:Byte;Strings:TStringList):Boolean;stdcall;

{$ENDREGION}

{$REGION 'Сортировка'}

function CompareStringsAsc(const S1, S2: string): Integer;
function CompareStringsDesc(const S1, S2: string): Integer;
function AscSort(List: TStringList; Index1, Index2: Integer): Integer;
function DescSort(List: TStringList; Index1, Index2: Integer): Integer;
function AscSortOnlyFileNames(List: TStringList; Index1, Index2: Integer): Integer;
function DescSortOnlyFileNames(List: TStringList; Index1, Index2: Integer): Integer;

{$ENDREGION}


implementation

uses
  SFGlobal, MainProgramHeader,
  SysUtils, Dialogs, Windows;

{$REGION 'Работа со списком'}

//добавить элемент
function AddElement(Str:PChar):Boolean;
begin
  Result:=false;
  if FilesCollection = nil then
    Exit;
  FilesCollection.Add(Str);
  Result:=true;
end;

//количество элементов
function CountElements:Integer;
begin
  Result:=-1;
  if FilesCollection = nil then
    Exit;
  Result:=FilesCollection.Count;
end;

//очистить список
function ClearElements:Boolean;
begin
  Result:=false;
  if FilesCollection = nil then
    Exit;
  FilesCollection.Clear;
  Result:=true;
end;

//получить значение элемента
//по индексу
function GetElement(Index:Integer):PChar;
begin
  Result:=nil;
  if FilesCollection = nil then
    Exit;
  if Index >= FilesCollection.Count then
    Exit;
  Result:=PChar(FilesCollection.Strings[Index]);
end;

//сортируем нисходяще
function AscSortList:Boolean;stdcall;
begin
  MultiLanguage_GetConfigValue:=GetProcAddress(MainInstance,'MultiLanguage_GetConfigValue');
  TStringList(FilesCollection).CustomSort(AscSort);
  Result:=true;
end;

//сортируем восходяще
function DescSortList:Boolean;stdcall;
begin
  MultiLanguage_GetConfigValue:=GetProcAddress(MainInstance,'MultiLanguage_GetConfigValue');
  TStringList(FilesCollection).CustomSort(DescSort);
  Result:=true;
end;

//сортируем нисходяще
//только по именам файлов
function AscSortListOF:Boolean;stdcall;
begin
  MultiLanguage_GetConfigValue:=GetProcAddress(MainInstance,'MultiLanguage_GetConfigValue');
  TStringList(FilesCollection).CustomSort(AscSortOnlyFileNames);
  Result:=true;
end;

//сортируем восходяще
//только по именам файлов
function DescSortListOF:Boolean;stdcall;
begin
  MultiLanguage_GetConfigValue:=GetProcAddress(MainInstance,'MultiLanguage_GetConfigValue');
  TStringList(FilesCollection).CustomSort(DescSortOnlyFileNames);
  Result:=true;
end;

//основна функция сортировки
function SortFilesMainFunc(Mode:Byte):Boolean;stdcall;
var
  Strings:TStringList;
  GetPos:Integer;
begin
  InitLinks;
  Result:=false;
  //если нет ничего в  списке
  //то нечего и делать
  if ListImage_Count = 0 then
    Exit;
  Strings:=TStringList.Create;
  for GetPos:=0 to ListImage_Count - 1 do
    Strings.Add(ListImage_GetFileName(GetPos));
  if Mode = 0 then
    Mode:=StrToInt(MultiLanguage_GetConfigValue(PWideChar('sort_opened')));
  case Mode of
    //восходяще с полными путями
    1:Strings.CustomSort(AscSort);
    //нисходяще с полными путями
    2:Strings.CustomSort(DescSort);
    //восходяще
    3:Strings.CustomSort(AscSortOnlyFileNames);
    //нисходяще
    4:Strings.CustomSort(DescSortOnlyFileNames);
  end;
  for GetPos:=0 to ListImage_Count - 1 do
    ListImage_SetFileName(GetPos,PWideChar(Strings[GetPos]));
  Strings.Free;
  Result:=true;
end;

//целиковая функция сортировки
function SortingFilesAtList(Mode:Byte;Strings:TStringList):Boolean;stdcall;
begin
  InitLinks;
  if Mode = 0 then
    Mode:=StrToInt(MultiLanguage_GetConfigValue(PWideChar('sort_opened')));
  case Mode of
    //восходяще с полными путями
    1:Strings.CustomSort(AscSort);
    //нисходяще с полными путями
    2:Strings.CustomSort(DescSort);
    //восходяще
    3:Strings.CustomSort(AscSortOnlyFileNames);
    //нисходяще
    4:Strings.CustomSort(DescSortOnlyFileNames);
  end;
  Result:=true;
end;

{$ENDREGION}

{$REGION 'Сортировка'}

function CompareStringsDesc(const S1, S2: string): Integer;
begin
  if S1 > S2 then result := -1
  else if S1 = S2 then result := 0
  else result := 1;
end;

function CompareStringsAsc(const S1, S2: string): Integer;
begin
  if S1 < S2 then result := -1
  else if S1 = S2 then result := 0
  else result := 1;
end;

function AscSort(List: TStringList; Index1, Index2: Integer): Integer;
begin
  if MultiLanguage_GetConfigValue(PWideChar('sort_imagesensitive')) = '-1' then
    Result:=CompareStringsAsc(LowerCase(List.Strings[Index1]),LowerCase(List.Strings[Index2]))
  else
    Result:=CompareStringsAsc(List.Strings[Index1],List.Strings[Index2]);
end;

function DescSort(List: TStringList; Index1, Index2: Integer): Integer;
begin
  if MultiLanguage_GetConfigValue(PWideChar('sort_imagesensitive')) = '-1' then
    Result:=CompareStringsDesc(LowerCase(List.Strings[Index1]),LowerCase(List.Strings[Index2]))
  else
    Result:=CompareStringsDesc(List.Strings[Index1],List.Strings[Index2]);
end;

function AscSortOnlyFileNames(List: TStringList; Index1, Index2: Integer): Integer;
begin
  if MultiLanguage_GetConfigValue(PWideChar('sort_imagesensitive')) = '-1' then
  begin
    Result:=CompareStringsAsc (
                LowerCase(ExtractFileName(List.Strings[Index1])),
                LowerCase(ExtractFileName(List.Strings[Index2]))
                              );
  end else
  begin
    Result:=CompareStringsAsc (
                ExtractFileName(List.Strings[Index1]),
                ExtractFileName(List.Strings[Index2])
                              );
  end;
end;

function DescSortOnlyFileNames(List: TStringList; Index1, Index2: Integer): Integer;
begin
  if MultiLanguage_GetConfigValue(PWideChar('sort_imagesensitive')) = '-1' then
  begin
    Result:=CompareStringsDesc  (
                LowerCase(ExtractFileName(List.Strings[Index1])),
                LowerCase(ExtractFileName(List.Strings[Index2]))
                                );
  end else
  begin
    Result:=CompareStringsDesc  (
                ExtractFileName(List.Strings[Index1]),
                ExtractFileName(List.Strings[Index2])
                                );
  end;
end;


{$ENDREGION}

end.
