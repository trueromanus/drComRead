{
  drComRead

  Sorting Library

  Модуль инициализации
  библиотеки

  Copyright (c) 2008-2009 Romanus
}
unit SFInit;

interface

type
  PSFFileList = ^TSFFileList;
  TSFFileList = array of string;

//функция инициализации
//списка файлов
function InitListFiles(FileList:PSFFileList;Count:Integer):Boolean;

implementation

uses
  Classes,
  SFGlobal;

//функция инициализации
//списка файлов
function InitListFiles(FileList:PSFFileList;Count:Integer):Boolean;
var
  GetPos:Integer;
begin
  Result:=false;
  if FileList = nil then
    Exit;
  //setlength(FilesCollection,Count);
  //for GetPos:=0 to Count do
    //FilesCollection[GetPos]:=TSFFileList(FileList)[GetPos];
end;

end.
