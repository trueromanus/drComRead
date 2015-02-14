{
  drComRead

  ������ � ��������
  �������� ��������

  Copyright (c) 2008-2011 Romanus
}
unit OpenDirDialog;

interface

uses
  Classes, Controls, Forms,
  Dialogs, FileCtrl, StdCtrls, ComCtrls, ShellCtrls, Buttons;

type
  TDirDialog = class(TForm)
    Button_Open: TButton;
    Button_Cancel: TButton;
    DirList: TShellTreeView;
    FileList: TShellListView;
    CheckBoxFullPath: TCheckBox;
    SpeedButton_Help: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CheckBoxFullPathClick(Sender: TObject);
    procedure SpeedButton_HelpClick(Sender: TObject);
    procedure FileListChanging(Sender: TObject; Item: TListItem;
      Change: TItemChange; var AllowChange: Boolean);
  private
    FCustomLeft:integer;
    FCustomTop:integer;
  public
  end;

var
  DirDialog: TDirDialog;

//���������� ������ ��������
//�������� � ����������
//� ������� ������ ����������
//� ���� ������ ������
function ShowDirDialog(Left,Top:integer):PWideChar;stdcall;

implementation

{$R *.dfm}

uses
  SysUtils,
  Globals, Windows, MainProgramHeader;

//��������� ������� ������
procedure TDirDialog.CheckBoxFullPathClick(Sender: TObject);
begin
  //������ ����� �����������
  if CheckBoxFullPath.Checked then
  begin
    FileList.ObjectTypes:=FileList.ObjectTypes+[otFolders];
  end else
  begin
    FileList.ObjectTypes:=FileList.ObjectTypes-[otFolders];
  end;
  //��������� � ������������
  MultiLanguage_SetConfigValue('opendir_dirvisible',PWideChar(BoolToStr(CheckBoxFullPath.Checked)));
end;

procedure TDirDialog.FileListChanging(Sender: TObject; Item: TListItem;
  Change: TItemChange; var AllowChange: Boolean);
begin
  AllowChange:=false;
end;

procedure TDirDialog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //��������
  if (ssCtrl in Shift) and (Key = 13) then
    Button_Open.Click;
  //������
  if Key = 27 then
    Button_Cancel.Click;
  //������
  if Key = 112 then
    SpeedButton_HelpClick(nil);
end;

procedure TDirDialog.FormShow(Sender: TObject);
begin
  DirDialog.Left:=FCustomLeft;
  DirDialog.Top:=FCustomTop;
  SpeedButton_Help.Glyph.LoadFromFile(GetGifFileDocumentation);
end;

procedure TDirDialog.SpeedButton_HelpClick(Sender: TObject);
begin
  ShowDocumentation(PWideChar('opendirdialog'));
end;

//��������� �������� ������
function LoadLangData:Boolean;
var
  Flag:String;
begin
  try
    DirDialog.Caption:=MultiLanguage_GetGroupValue('dirdialog','window_title');
    DirDialog.Button_Cancel.Caption:=MultiLanguage_GetGroupValue('dirdialog','cancel_button');
    DirDialog.Button_Open.Caption:=MultiLanguage_GetGroupValue('dirdialog','ok_button');
    DirDialog.CheckBoxFullPath.Caption:=MultiLanguage_GetGroupValue('dirdialog','checkbox');
    //������ ��������� ������� �� ��������
    //��� ���
    Flag:=MultiLanguage_GetConfigValue('opendir_dirvisible');
    if Flag = '-1' then
    begin
      with DirDialog do
      begin
        CheckBoxFullPath.Checked:=true;
        FileList.ObjectTypes:=FileList.ObjectTypes+[otFolders];
      end;
    end else
    begin
      with DirDialog do
      begin
        CheckBoxFullPath.Checked:=false;
        FileList.ObjectTypes:=FileList.ObjectTypes-[otFolders];
      end;
    end;
    Result:=true;
  except
    Result:=false;
  end;
end;

//���������� ������ ��������
//�������� � ����������
//� ������� ������ ����������
//� ���� ������ ������
function ShowDirDialog(Left,Top:integer):PWideChar;
begin
  Result:='';
  //�������������� ������
  //�� api ���������
  InitLinks;
  Screen.Cursors[crArrow]:=Program_GetArrowCursor;
  //������� ������
  DirDialog:=TDirDialog.Create(nil);
  if not LoadLangData then
    Exit;
  DirDialog.FCustomLeft:=Left;
  DirDialog.FCustomTop:=Top;
  //���� ��� ����������� ����
  GetPathToDir:=MultiLanguage_GetConfigValue('lastpathopendir');
  if (GetPathToDir <> '') and DirectoryExists(GetPathToDir) then
    DirDialog.DirList.Path:=GetPathToDir;
  //���������� ������
  if DirDialog.ShowModal = mrOk then
  begin
    //���������� ������������ ����
    MultiLanguage_SetConfigValue('lastpathopendir',PWideChar(DirDialog.DirList.Path));
    //���������� ���
    Result:=PWideChar(DirDialog.DirList.Path);
  end;
end;

end.
