{
  drComRead
  Config Library

  Модуль глобальных
  переменных

  Copyright (c) 2008-2009 Romanus
}

unit ConfigGlobal;

interface

var
  //ссылка на языковой файл
  LangHandle:Integer;
  //ссылка на конфигурационный файл
  ConfHandle:Integer;
  //режим отображения
  //главного контейнера
  ModeMainBox:Byte = 0;

//получаем значение из конфигурационного
//файла
function LangArrayValue(Key:String):String;
//получаем значение из конфигурационного
//файла
function ConfArrayValue(Key:String):String;
//пишем значение в конфигурацонный файл
procedure SetConfArrayValue(Key,Value:String);
//пишем и возвращаем результат
function SetArrayValue(Key,Value:String):Boolean;

implementation

uses
  ConfigDialog, MainProgramHeader;

//получаем значение из конфигурационного
//файла
function LangArrayValue(Key:String):String;
begin
  Result:=MultiLanguage_GetGroupValue('configdialog',PWideChar(Key));
end;

//получаем значение
//из конфигурационного
//файла
function ConfArrayValue(Key:String):String;
begin
  Result:=MultiLanguage_GetConfigValue(PWideChar(Key));
end;

//пишем и возвращаем результат
procedure SetConfArrayValue(Key,Value:String);
begin
  MultiLanguage_SetConfigValue(PWideChar(Key),PWideChar(Value));
end;

function SetArrayValue(Key,Value:String):Boolean;
begin
  Result:=MultiLanguage_SetConfigValue(PWideChar(Key),PWideChar(Value));
end;

end.
