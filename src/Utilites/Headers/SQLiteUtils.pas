{
  drComRead

  ������ ��������������� �������
  ��� ������ � ����� SQLite

  Copyright (c) 2009-2011 Romanus
}
unit SQLiteUtils;

interface

uses
  SQLiteTable3;

const
  SQLSelectRequest      =       'SELECT ';
  SQLFromRequest        =       ' FROM ';
  SQLWhereRequest       =       ' WHERE ';
  SQLInsertRequest      =       'INSERT INTO ';
  SQLDeleteRequest      =       'DELETE ';
  SQLUpdateRequest      =       'UPDATE ';
  SQLOrderRequest       =       ' ORDER BY ';

type
  //��������� ��� ���������
  //���������� sql ������� select
  TProcSqlSelect = reference to procedure(Table:TSQLiteTable);

//�������������� ������ ��� sql ������
function SQLFormat(Str:String):String;
//�������������� ������ ��� ������� ������� ���� � �������
function SQLFormatNow:string;
//��������� ������ � ���� ������
function SQLRequest(Str:String):Boolean;overload;
//��������� ������ � ���� ������
function SQLRequest(Str:Utf8String):Boolean;overload;
//��������� ������ �
//���������� ���������
function SQLSelect(Str:String):TSQLiteTable;
//������������������ �������
//������� �������� �������
//��������� ������
function SQLSelectFor(Str:String;Func:TProcSqlSelect):Boolean;
//������������ ���������
//�������
procedure SQLResult(Table:TSQLiteTable;Func:TProcSqlSelect);
//��������� ������ SELECT
function Select(Table,Fields,Condition:String;const Order:String = ''):TSQLiteTable;
//��������� ������ SELECT
function SelectCount(Table,Fields,Condition:String;const Order:String = ''):Integer;
//��������� ������ INSERT
function Insert(Table,Fields,Values:String):Boolean;
//��������� ������ UPDATE
function Update(Table,Values,Conditions:String):Boolean;


var
  //���������� ������
  //�� ���� ������
  CurrentDataBase:TSQLiteDatabase;

implementation

uses
  SysUtils;

//�������������� ������ ��� sql ������
function SQLFormat(Str:String):String;
begin
  Result:=#39 + StringReplace(Str,#39,'',[rfReplaceAll]) + #39;
end;

//�������������� ������ ��� ������� ������� ���� � �������
function SQLFormatNow:string;
begin
  Exit('DATETIME(' + SQLFormat('NOW') + ')');
end;

//��������� ������ � ���� ������
function SQLRequest(Str:String):Boolean;
begin
  try
    CurrentDataBase.ExecSQL(UTF8Encode(Str));
    Exit(true);
  except
    Exit(false);
  end;
end;

//��������� ������ � ���� ������
function SQLRequest(Str:Utf8String):Boolean;
begin
  try
    CurrentDataBase.ExecSQL(Str);
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
    Exit(CurrentDataBase.GetTable(UTF8Encode(Str)));
  except
    Exit(nil);
  end;
end;

//���������� ����������
//�������� ������� �������
function SQLSelectCount(Str:String):Integer;
begin
  Result:=SQLSelect(Str).Count;
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
  Table.Free;
  Result:=true;
end;

//������������ ���������
//�������
procedure SQLResult(Table:TSQLiteTable;Func:TProcSqlSelect);
begin
  if Table.Count = 0 then
  begin
    FreeAndNil(Table);
    Exit;
  end;
  Func(Table);
  while Table.Next and not Table.EOF do
    Func(Table);
  FreeAndNil(Table);
end;

//��������� ������ SELECT
function Select(Table,Fields,Condition:String;const Order:String = ''):TSQLiteTable;
var
  Request:String;
begin
  Request:=SQLSelectRequest + Fields + SQLFromRequest + Table;
  if Condition <> '' then
    Request:=Request+SQLWhereRequest+Condition;
  if Order <> '' then
    Request:=Request+SQLOrderRequest+Order;
  Result:=SQLSelect(Request);
end;

//��������� ������ SELECT
function SelectCount(Table,Fields,Condition:String;const Order:String = ''):Integer;
begin
  Result:=Select(Table,Fields,Condition,Order).Count;
end;

//��������� ������ INSERT
function Insert(Table,Fields,Values:String):Boolean;
var
  Request:String;
begin
  Request:=SQLInsertRequest + Table + '(' + Fields + ')';
  Request:=Request + ' VALUES (' + Values + ')';
  Result:=SQLRequest(Request);
end;

function Update(Table,Values,Conditions:String):Boolean;
var
  Request:String;
begin
  Request:=SQLUpdateRequest + Table + ' SET ' + Values;
  if Conditions <> '' then
    Request:=Request + ' WHERE ' + Values + Conditions;
  Result:=SQLRequest(Request);
end;

end.
