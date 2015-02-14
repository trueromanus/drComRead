{
  drComRead

  Модуль для организации
  поиска

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
    //конструктор
    constructor Create(Strings:TStrings);
    //деструктор
    destructor Destroy;override;
    //ищем строку
    //согласно шаблону
    function Find(Str:String;StartIndex,EndIndex:Integer):Integer;
    //ищем от начальной до указанной
    //позиции
    function FindAtStartToPos(Str:String;Position:Integer):Integer;
    //ищем от указанной
    //позиции до конечной
    function FindAtPosToEnd(Str:String;Position:Integer):Integer;
  end;

implementation

uses
  StrUtils;

//конструктор
constructor TArchiveFind.Create(Strings:TStrings);
begin
  FList:=Strings;
end;

//деструктор
destructor TArchiveFind.Destroy;
begin
  //
end;

//ищем строку
//согласно шаблону
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

//ищем от начальной до указанной
//позиции
function TArchiveFind.FindAtStartToPos(Str:String;Position:Integer):Integer;
begin
  Result:=Self.Find(Str,0,Position);
end;

//ищем от указанной
//позиции до конечной
function TArchiveFind.FindAtPosToEnd(Str:String;Position:Integer):Integer;
begin
  Result:=Self.Find(Str,Position,FList.Count-1);
end;

end.
