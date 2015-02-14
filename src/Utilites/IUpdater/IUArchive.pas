{
  drComRead

  Internet automatic updater

  ������ ���������� �����������
  �� ��������� ����������

  Copyright (c) 2009-2011 Romanus
}
unit IUArchive;

interface

//������������� �����
function UnpackArchive:Boolean;
//��������� ����������
//� ��������������� ���������
function LoadLib:Boolean;
//����� ������� ����������
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

//������������� �����
function UnpackArchive:Boolean;
var
  Arc:TALRar;
  FullPath:String;
begin
  FullPath:=ExtractFilePath(ParamStr(0)) + 'update.rar';
  if not FileExists(FullPath) then
    Exit(false);
  //������� ��������
  KillTask('drComRead.exe');
  Arc:=TALRar.Create(FullPath);
  //��������� �����
  if not Arc.TestArchive then
    Exit(false);
  Arc.ExtractAllArchive(ExtractFilePath(ParamStr(0)));
  Arc.Free;
  Result:=true;
end;

//��������� ����������
//� ��������������� ���������
function LoadLib:Boolean;
begin
  Result:=true;
end;

//��������� ����������
//� ��������������� ���������
function DeleteTempFiles:Boolean;
var
  UpdateFile:String;
begin
  UpdateFile:=ExtractFilePath(ParamStr(0)) + 'update.rar';
  if FileExists(UpdateFile) then
    Exit(DeleteFile(UpdateFile));
  Result:=true;
end;

//����� ������� ����������
function Update:Boolean;
begin
  //������������� �����
  if not UnpackArchive then
    Exit(false);
  //��������� �������������� ����������
  if not LoadLib then
    Exit(false);
  //������� ������ �����
  if not DeleteTempFiles then
    Exit(false);
  //��������� ��������
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
