{
  drComRead

  Sorting Library

  ������ � ���������
  ������������� �������

  Copyright (c) 2008-2009 Romanus
}
unit SFSorting;

interface

uses
  Classes;


{$REGION '������ �� �������'}

//�������� �������
function AddElement(Str:PWideChar):Boolean;stdcall;
//���������� ���������
function CountElements:Integer;stdcall;
//�������� ������
function ClearElements:Boolean;stdcall;
//�������� �������� ��������
//�� �������
function GetElement(Index:Integer):PWideChar;stdcall;
//��������� ���������
function AscSortList:Boolean;stdcall;
//��������� ���������
function DescSortList:Boolean;stdcall;
//��������� ���������
//������ �� ������ ������
function AscSortListOF:Boolean;stdcall;
//��������� ���������
//������ �� ������ ������
function DescSortListOF:Boolean;stdcall;
//������� ������� ����������
function SortFilesMainFunc(Mode:Byte):Boolean;stdcall;
//��������� ������� ����������
function SortingFilesAtList(Mode:Byte;Strings:TStringList):Boolean;stdcall;

{$ENDREGION}

{$REGION '����������'}

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

{$REGION '������ �� �������'}

//�������� �������
function AddElement(Str:PChar):Boolean;
begin
  Result:=false;
  if FilesCollection = nil then
    Exit;
  FilesCollection.Add(Str);
  Result:=true;
end;

//���������� ���������
function CountElements:Integer;
begin
  Result:=-1;
  if FilesCollection = nil then
    Exit;
  Result:=FilesCollection.Count;
end;

//�������� ������
function ClearElements:Boolean;
begin
  Result:=false;
  if FilesCollection = nil then
    Exit;
  FilesCollection.Clear;
  Result:=true;
end;

//�������� �������� ��������
//�� �������
function GetElement(Index:Integer):PChar;
begin
  Result:=nil;
  if FilesCollection = nil then
    Exit;
  if Index >= FilesCollection.Count then
    Exit;
  Result:=PChar(FilesCollection.Strings[Index]);
end;

//��������� ���������
function AscSortList:Boolean;stdcall;
begin
  MultiLanguage_GetConfigValue:=GetProcAddress(MainInstance,'MultiLanguage_GetConfigValue');
  TStringList(FilesCollection).CustomSort(AscSort);
  Result:=true;
end;

//��������� ���������
function DescSortList:Boolean;stdcall;
begin
  MultiLanguage_GetConfigValue:=GetProcAddress(MainInstance,'MultiLanguage_GetConfigValue');
  TStringList(FilesCollection).CustomSort(DescSort);
  Result:=true;
end;

//��������� ���������
//������ �� ������ ������
function AscSortListOF:Boolean;stdcall;
begin
  MultiLanguage_GetConfigValue:=GetProcAddress(MainInstance,'MultiLanguage_GetConfigValue');
  TStringList(FilesCollection).CustomSort(AscSortOnlyFileNames);
  Result:=true;
end;

//��������� ���������
//������ �� ������ ������
function DescSortListOF:Boolean;stdcall;
begin
  MultiLanguage_GetConfigValue:=GetProcAddress(MainInstance,'MultiLanguage_GetConfigValue');
  TStringList(FilesCollection).CustomSort(DescSortOnlyFileNames);
  Result:=true;
end;

//������� ������� ����������
function SortFilesMainFunc(Mode:Byte):Boolean;stdcall;
var
  Strings:TStringList;
  GetPos:Integer;
begin
  InitLinks;
  Result:=false;
  //���� ��� ������ �  ������
  //�� ������ � ������
  if ListImage_Count = 0 then
    Exit;
  Strings:=TStringList.Create;
  for GetPos:=0 to ListImage_Count - 1 do
    Strings.Add(ListImage_GetFileName(GetPos));
  if Mode = 0 then
    Mode:=StrToInt(MultiLanguage_GetConfigValue(PWideChar('sort_opened')));
  case Mode of
    //��������� � ������� ������
    1:Strings.CustomSort(AscSort);
    //��������� � ������� ������
    2:Strings.CustomSort(DescSort);
    //���������
    3:Strings.CustomSort(AscSortOnlyFileNames);
    //���������
    4:Strings.CustomSort(DescSortOnlyFileNames);
  end;
  for GetPos:=0 to ListImage_Count - 1 do
    ListImage_SetFileName(GetPos,PWideChar(Strings[GetPos]));
  Strings.Free;
  Result:=true;
end;

//��������� ������� ����������
function SortingFilesAtList(Mode:Byte;Strings:TStringList):Boolean;stdcall;
begin
  InitLinks;
  if Mode = 0 then
    Mode:=StrToInt(MultiLanguage_GetConfigValue(PWideChar('sort_opened')));
  case Mode of
    //��������� � ������� ������
    1:Strings.CustomSort(AscSort);
    //��������� � ������� ������
    2:Strings.CustomSort(DescSort);
    //���������
    3:Strings.CustomSort(AscSortOnlyFileNames);
    //���������
    4:Strings.CustomSort(DescSortOnlyFileNames);
  end;
  Result:=true;
end;

{$ENDREGION}

{$REGION '����������'}

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
