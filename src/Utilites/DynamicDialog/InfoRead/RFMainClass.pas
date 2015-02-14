{
  drComRead

  ReadInfo Library

  ������ � ������� �����������
  ������ �������� ������
  � ������

  Copyright (c) 2008-2009 Romanus
}
unit RFMainClass;

interface

uses
  Classes, SysUtils;

type
  //������ � ��������� �����������
  PRFInfoRecord = ^TRFInfoRecord;
  TRFInfoRecord = record
    FileName:WideString;
    Text:TStrings;
  end;

  TRFReadInfo = class
  private
    FTexts:TList;
    //��������� ����
    function AddData(FileName:WideString):Boolean;
  public
    //�����������
    constructor Create;
    //����������
    destructor Destroy;override;
    //������� ��� ������
    procedure Reset;
    //��������� ����
    function AddFile(FileName:WideString):Boolean;
    //�������� ��������� ��
    //������ ����� ����������� �����
    function GetPointer(Index:Integer):Pointer;
    //�������� ������ � ������ �����
    function GetStrToStr(Index1,Index2:Integer):String;
    //���������� ���������
    function Count:Integer;
    //�������� ��� �����
    function GetFileName(Index:Integer):WideString;
  end;

implementation

uses
  Windows, MainProgramHeader;

//��������� ����
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

//�����������
constructor TRFReadInfo.Create;
begin
  FTexts:=TList.Create;
end;

//����������
destructor TRFReadInfo.Destroy;
begin
  Self.Reset;
  FTexts.Free;
end;

//������� ��� ������
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

//��������� ����
function TRFReadInfo.AddFile(FileName:WideString):Boolean;
begin
  Result:=AddData(FileName);
end;

//�������� ��������� ��
//������ ����� ����������� �����
function TRFReadInfo.GetPointer(Index:Integer):Pointer;
begin
  Result:=nil;
  if Index >= FTexts.Count then
    Exit;
  Result:=PRFInfoRecord(FTexts.Items[Index]).Text;
end;

//�������� ������ � ������ �����
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

//���������� ���������
function TRFReadInfo.Count:Integer;
begin
  Result:=FTexts.Count;
end;

//�������� ��� �����
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
