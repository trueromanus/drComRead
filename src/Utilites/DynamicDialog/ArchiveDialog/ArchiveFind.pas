{
  drComRead

  ������ ��� �����������
  ������

  Copyright (c) 2009-2011 Romanus
}
unit ArchiveFind;

interface

uses
  Classes;

type
  TArchiveFind = class
  private
    FList:TStrings;
  public
    //�����������
    constructor Create(Strings:TStrings);
    //����������
    destructor Destroy;override;
    //���� ������
    //�������� �������
    function Find(Str:String;StartIndex,EndIndex:Integer):Integer;
    //���� �� ��������� �� ���������
    //�������
    function FindAtStartToPos(Str:String;Position:Integer):Integer;
    //���� �� ���������
    //������� �� ��������
    function FindAtPosToEnd(Str:String;Position:Integer):Integer;
  end;

implementation

uses
  StrUtils;

//�����������
constructor TArchiveFind.Create(Strings:TStrings);
begin
  FList:=Strings;
end;

//����������
destructor TArchiveFind.Destroy;
begin
  //
end;

//���� ������
//�������� �������
function TArchiveFind.Find(Str:String;StartIndex,EndIndex:Integer):Integer;
var
  GetPos:Integer;
begin
  if (StartIndex >= FList.Count) or (EndIndex >= FList.Count)  then
    Exit;
  if StartIndex > EndIndex then
    Exit;
  for GetPos:=StartIndex to EndIndex do
  begin
    if Pos(Str,FList[GetPos]) <> 0 then
    begin
      Exit(GetPos);
    end;
  end;
  Result:=-1;
end;

//���� �� ��������� �� ���������
//�������
function TArchiveFind.FindAtStartToPos(Str:String;Position:Integer):Integer;
begin
  Result:=Self.Find(Str,0,Position);
end;

//���� �� ���������
//������� �� ��������
function TArchiveFind.FindAtPosToEnd(Str:String;Position:Integer):Integer;
begin
  Result:=Self.Find(Str,Position,FList.Count-1);
end;

end.
