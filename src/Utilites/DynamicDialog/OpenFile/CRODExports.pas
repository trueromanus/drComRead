{
  drComRead

  CROpenDialog

  ������ ��������

  Copyright (c) 2010 Romanus
}
unit CRODExports;

interface

uses
  Classes;

var
  FilesOpenDialog:TStrings;
  FlagCursorLoading:Boolean = false;

//��������� ������
function OpenArchiveDialog():Boolean;stdcall;
//���������� ����������� ������
function OpenDialogFilesCount():Integer;stdcall;
//�������� ���� � ������������ �����
function OpenDialogFilesName(Index:Integer):PWideChar;stdcall;

implementation

uses
  RVOpenDialog, MainProgramHeader, Forms, Controls,
  Dialogs, SysUtils;

//��������� ������
function OpenArchiveDialog():Boolean;stdcall;
var
  //OpenDialog:TOpenForm;
  GetPos:Integer;
begin
  InitLinks;
  CursorsLoading;
  //������� �����
  OpenForm:=TOpenForm.Create(nil);
  //�������� ���������
  //������������� �����
  OpenForm.FirstDir:=MultiLanguage_GetConfigValue('lastpathopenfile');
  //��������� ������
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

//���������� ����������� ������
function OpenDialogFilesCount():Integer;stdcall;
begin
  if not Assigned(FilesOpenDialog) then
    Exit(0);
  Result:=FilesOpenDialog.Count;
end;

//�������� ���� � ������������ �����
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
