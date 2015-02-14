{
  drComRead

  Open File Dialog

  Copyright (c) 2011 Romanus
}
library openfiledialog;

uses
  Windows,Forms,Controls,
  CRArchive in 'CRArchive.pas',
  CRODExports in 'CRODExports.pas',
  sevenzip in '..\..\..\Libs\sevenzip.pas',
  MainProgramHeader in '..\..\Headers\MainProgramHeader.pas',
  RVOpenDialog in 'RVOpenDialog.pas' {OpenForm};

{$R *.res}

//������� ��� ����� �����
procedure DLLEntryPoint(Reason: DWORD);
begin
  case Reason of
    DLL_PROCESS_ATTACH:
      begin
        //
      end;
    DLL_PROCESS_DETACH:
      begin
        //������ ���������
        if Assigned(FilesOpenDialog) then
          FilesOpenDialog.Free;
      end;
  end;
end;

exports
  OpenArchiveDialog,
  OpenDialogFilesCount,
  OpenDialogFilesName;


begin
  //���������� ����������
  //��� ������� �������������
  //������������ �������
  if @DllProc = nil then
    DllProc := @DLLEntryPoint;
  DllProc(DLL_PROCESS_ATTACH);
end.
