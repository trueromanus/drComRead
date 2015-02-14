{
  drComRead

  Internet automatic updater

  Модуль распаковки полученного
  из интернета обновления

  Copyright (c) 2009-2011 Romanus
}
unit IUArchive;

interface

//распаковываем файлы
function UnpackArchive:Boolean;
//запускаем библиотеку
//с дополнительными дейтвиями
function LoadLib:Boolean;
//общий процесс обновления
function Update:Boolean;

implementation

uses
  Windows, Tlhelp32, ShellAPI,
  SysUtils, ArcFunc;

function KillTask(ExeFileName: string): integer;
const
  PROCESS_TERMINATE=$0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  result := 0;

  FSnapshotHandle := CreateToolhelp32Snapshot
                     (TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle,
                                 FProcessEntry32);

  while integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
         UpperCase(ExeFileName))
     or (UpperCase(FProcessEntry32.szExeFile) =
         UpperCase(ExeFileName))) then
      Result := Integer(TerminateProcess(OpenProcess(
                        PROCESS_TERMINATE, BOOL(0),
                        FProcessEntry32.th32ProcessID), 0));
    ContinueLoop := Process32Next(FSnapshotHandle,
                                  FProcessEntry32);
  end;

  CloseHandle(FSnapshotHandle);
end;

//распаковываем файлы
function UnpackArchive:Boolean;
var
  Arc:TALRar;
  FullPath:String;
begin
  FullPath:=ExtractFilePath(ParamStr(0)) + 'update.rar';
  if not FileExists(FullPath) then
    Exit(false);
  //убиваем комридер
  KillTask('drComRead.exe');
  Arc:=TALRar.Create(FullPath);
  //тестируем архив
  if not Arc.TestArchive then
    Exit(false);
  Arc.ExtractAllArchive(ExtractFilePath(ParamStr(0)));
  Arc.Free;
  Result:=true;
end;

//запускаем библиотеку
//с дополнительными дейтвиями
function LoadLib:Boolean;
begin
  Result:=true;
end;

//запускаем библиотеку
//с дополнительными дейтвиями
function DeleteTempFiles:Boolean;
var
  UpdateFile:String;
begin
  UpdateFile:=ExtractFilePath(ParamStr(0)) + 'update.rar';
  if FileExists(UpdateFile) then
    Exit(DeleteFile(UpdateFile));
  Result:=true;
end;

//общий процесс обновления
function Update:Boolean;
begin
  //распаковываем файлы
  if not UnpackArchive then
    Exit(false);
  //загружаем дополнительные библиотеки
  if not LoadLib then
    Exit(false);
  //удаляем лишние файлы
  if not DeleteTempFiles then
    Exit(false);
  //запускаем комридер
  ShellExecuteW
    (
      0,
      PWideChar(''),
      PWideChar(ExtractFilePath(ParamStr(0)) + 'drComRead.exe'),
      PWideChar(''),
      PWideChar(ExtractFilePath(ParamStr(0))),
      SW_SHOW
    );
  Result:=true;
end;

end.
