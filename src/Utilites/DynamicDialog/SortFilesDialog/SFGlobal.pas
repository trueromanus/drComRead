{
  drComRead

  Sorting Library

  Модуль с описанием
  глобальных констант
  и переменных

  Copyright (c) 2008-2009 Romanus
}
unit SFGlobal;

interface

uses
  Classes;

var
  //массив для хранения
  //ссылок на строки
  FilesCollection:TStringList;

implementation

initialization

  FilesCollection:=TStringList.Create;

finalization

  FilesCollection.Free;

end.
