{
  drComRead

  Модуль вспомогательных функций
  для работы с базой SQLite

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
  //процедура для обработки
  //результата sql запроса select
  TProcSqlSelect = reference to procedure(Table:TSQLiteTable);

//форматирование строки под sql запрос
function SQLFormat(Str:String):String;
//форматирование строки для вставки текущей даты и времени
function SQLFormatNow:string;
//выполняем запрос в базе данных
function SQLRequest(Str:String):Boolean;overload;
//выполняем запрос в базе данных
function SQLRequest(Str:Utf8String):Boolean;overload;
//выполняем запрос и
//возвращаем результат
function SQLSelect(Str:String):TSQLiteTable;
//специализированная функция
//которая упрощает процесс
//получения данных
function SQLSelectFor(Str:String;Func:TProcSqlSelect):Boolean;
//обрабатываем результат
//запроса
procedure SQLResult(Table:TSQLiteTable;Func:TProcSqlSelect);
//формируем запрос SELECT
function Select(Table,Fields,Condition:String;const Order:String = ''):TSQLiteTable;
//формируем запрос SELECT
function SelectCount(Table,Fields,Condition:String;const Order:String = ''):Integer;
//формируем запрос INSERT
function Insert(Table,Fields,Values:String):Boolean;
//формируем запрос UPDATE
function Update(Table,Values,Conditions:String):Boolean;


var
  //глобальная ссылка
  //на базу данных
  CurrentDataBase:TSQLiteDatabase;

implementation

uses
  SysUtils;

//форматирование строки под sql запрос
function SQLFormat(Str:String):String;
begin
  Result:=#39 + StringReplace(Str,#39,'',[rfReplaceAll]) + #39;
end;

//форматирование строки для вставки текущей даты и времени
function SQLFormatNow:string;
begin
  Exit('DATETIME(' + SQLFormat('NOW') + ')');
end;

//выполняем запрос в базе данных
function SQLRequest(Str:String):Boolean;
begin
  try
    CurrentDataBase.ExecSQL(UTF8Encode(Str));
    Exit(true);
  except
    Exit(false);
  end;
end;

//выполняем запрос в базе данных
function SQLRequest(Str:Utf8String):Boolean;
begin
  try
    CurrentDataBase.ExecSQL(Str);
    Exit(true);
  except
    Exit(false);
  end;
end;


//выполняем запрос и
//возвращаем результат
function SQLSelect(Str:String):TSQLiteTable;
begin
  try
    Exit(CurrentDataBase.GetTable(UTF8Encode(Str)));
  except
    Exit(nil);
  end;
end;

//возвращаем количество
//объектов которые вернули
function SQLSelectCount(Str:String):Integer;
begin
  Result:=SQLSelect(Str).Count;
end;

//специализированная функция
//которая упрощает процесс
//получения данных
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

//обрабатываем результат
//запроса
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

//формируем запрос SELECT
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

//формируем запрос SELECT
function SelectCount(Table,Fields,Condition:String;const Order:String = ''):Integer;
begin
  Result:=Select(Table,Fields,Condition,Order).Count;
end;

//формируем запрос INSERT
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
