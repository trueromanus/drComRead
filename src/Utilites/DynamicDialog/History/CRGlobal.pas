{
  drComRead

  History library

  ������ ��� ���������� ��������
  �������� � �������

  Copyright (c) 2010-2011 Romanus
}
unit CRGlobal;

interface

uses
  SQLiteTable3;

type
  //��������� ��� ���������
  //���������� sql ������� select
  TProcSqlSelect = procedure(Table:TSQLiteTable);

var
  //�������� ���� ������
  //��� ������ � ������
  //������� � ��������
  HistoryDataBase:TSQLiteDatabase;

//�������������� ������ ��� sql ������
function SQLStringFormat(Str:String):String;
//��������� ������ � ���� ������
function SQLRequest(Str:String):Boolean;
//��������� ������ �
//���������� ���������
function SQLSelect(Str:String):TSQLiteTable;
//������������������ �������
//������� �������� �������
//��������� ������
function SQLSelectFor(Str:String;Func:TProcSqlSelect):Boolean;

implementation

uses
  SysUtils;

//�������������� ������ ��� sql ������
function SQLStringFormat(Str:String):String;
begin
  Str:=StringReplace(Str,#39,'"',[rfReplaceAll]);
  Result:=#39 + Str + #39;
end;

//��������� ������ � ���� ������
function SQLRequest(Str:String):Boolean;
begin
  try
    HistoryDataBase.ExecSQL(UTF8Encode(Str));
    Exit(true);
  except
    Exit(false);
  end;
end;

//��������� ������ �
//���������� ���������
function SQLSelect(Str:String):TSQLiteTable;
begin
  try
    Exit(HistoryDataBase.GetTable(UTF8Encode(Str)));
  except
    Exit(nil);
  end;
end;

//������������������ �������
//������� �������� �������
//��������� ������
function SQLSelectFor(Str:String;Func:TProcSqlSelect):Boolean;
var
  Table:TSQLiteTable;
begin
  Table:=SQLSelect(Str);
  if Table = nil then
    Exit(false);
  if Table.Count = 0 then
    Exit(false);
  Func(Table);
  while Table.Next and not Table.EOF do
    Func(Table);
  Result:=true;
end;

end.
