{
  drComRead

  History library

  Модуль для глобальных констант
  объектов и функций

  Copyright (c) 2010-2011 Romanus
}
unit CRGlobal;

interface

uses
  SQLiteTable3;

type
  //процедура для обработки
  //результата sql запроса select
  TProcSqlSelect = procedure(Table:TSQLiteTable);

var
  //основная база данных
  //для записи и чтения
  //истории и закладок
  HistoryDataBase:TSQLiteDatabase;

//форматирование строки под sql запрос
function SQLStringFormat(Str:String):String;
//выполняем запрос в базе данных
function SQLRequest(Str:String):Boolean;
//выполняем запрос и
//возвращаем результат
function SQLSelect(Str:String):TSQLiteTable;
//специализированная функция
//которая упрощает процесс
//получения данных
function SQLSelectFor(Str:String;Func:TProcSqlSelect):Boolean;

implementation

uses
  SysUtils;

//форматирование строки под sql запрос
function SQLStringFormat(Str:String):String;
begin
  Str:=StringReplace(Str,#39,'"',[rfReplaceAll]);
  Result:=#39 + Str + #39;
end;

//выполняем запрос в базе данных
function SQLRequest(Str:String):Boolean;
begin
  try
    HistoryDataBase.ExecSQL(UTF8Encode(Str));
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
    Exit(HistoryDataBase.GetTable(UTF8Encode(Str)));
  except
    Exit(nil);
  end;
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
  Result:=true;
end;

end.
