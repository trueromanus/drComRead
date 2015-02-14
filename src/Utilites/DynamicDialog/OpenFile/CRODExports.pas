{
  drComRead

  CROpenDialog

  Модуль экспорта

  Copyright (c) 2010 Romanus
}
unit CRODExports;

interface

uses
  Classes;

var
  FilesOpenDialog:TStrings;
  FlagCursorLoading:Boolean = false;

//открываем диалог
function OpenArchiveDialog():Boolean;stdcall;
//количество открываемых файлов
function OpenDialogFilesCount():Integer;stdcall;
//получить путь к открываемому файлу
function OpenDialogFilesName(Index:Integer):PWideChar;stdcall;

implementation

uses
  RVOpenDialog, MainProgramHeader, Forms, Controls,
  Dialogs, SysUtils;

//открываем диалог
function OpenArchiveDialog():Boolean;stdcall;
var
  //OpenDialog:TOpenForm;
  GetPos:Integer;
begin
  InitLinks;
  CursorsLoading;
  //создаем форму
  OpenForm:=TOpenForm.Create(nil);
  //получаем последнюю
  //просмотренную папку
  OpenForm.FirstDir:=MultiLanguage_GetConfigValue('lastpathopenfile');
  //запускаем диалог
  OpenForm.Execute;
  if OpenForm.CountResult = 0 then
  begin
    OpenForm.Free;
    Exit(false);
  end;
  if not Assigned(FilesOpenDialog) then
    FilesOpenDialog:=TStringList.Create;
  FilesOpenDialog.Clear;
  for GetPos:=0 to OpenForm.CountResult - 1 do
    FilesOpenDialog.Add(OpenForm.ResultString(GetPos));
  MultiLanguage_SetConfigValue
    (
      PWideChar('lastpathopenfile'),
      PWideChar(ExtractFileDir(OpenForm.ResultString(0)))
    );
  OpenForm.Free;
  //Screen.Free;
  Result:=true;
end;

//количество открываемых файлов
function OpenDialogFilesCount():Integer;stdcall;
begin
  if not Assigned(FilesOpenDialog) then
    Exit(0);
  Result:=FilesOpenDialog.Count;
end;

//получить путь к открываемому файлу
function OpenDialogFilesName(Index:Integer):PWideChar;stdcall;
begin
  Result:=PWideChar('');
  if not Assigned(FilesOpenDialog) then
    Exit();
  if Index >= FilesOpenDialog.Count then
    Exit();
  Result:=PWideChar(FilesOpenDialog.Strings[Index]);
end;

end.
