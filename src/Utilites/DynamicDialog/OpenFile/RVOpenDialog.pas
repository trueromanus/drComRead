{
  drComRead

  ������ ��� �������� ������
  � ������������ �������������
  ����������� � ������� �������

  Copyright (c) 2011 Romanus
}
unit RVOpenDialog;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms,
  ComCtrls, ShellCtrls, StdCtrls, ieview, imageenview, Buttons;

const
  ArchiveFilters:array[0..13] of string =
    (
      '.cbr','.cbz',
      '.rar','.zip',
      '.cb7','.7z',
      '.cba','.arj',
      '.cbt','.tar',
      '.gz','.lzh',
      '.iso','.chm'
    );

type
// ����� ��������� ������ �����
  TShellListView = class(ShellCtrls.TShellListView)
  protected
    procedure DblClick; override;
  end;
  TOpenForm = class(TForm)
    ComboBox: TShellComboBox;
    ShellView: TShellListView;
    FolderLabel: TLabel;
    Open: TButton;
    Cancel: TButton;
    ImageView: TImageEnView;
    FileNameEdit: TEdit;
    FileNameLabel: TLabel;
    ButtonUpToFolder: TSpeedButton;
    PreviewButton: TSpeedButton;
    ShellTree: TShellTreeView;
    SpeedButton_help: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ShellViewAddFolder(Sender: TObject; AFolder: TShellFolder;
      var CanAdd: Boolean);
    procedure ShellViewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure ButtonUpToFolderClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OpenClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure PreviewButtonClick(Sender: TObject);
    procedure PreviewKeyPress(Sender: TObject; var Key: Char);
    procedure ShellViewDblClick(Sender: TObject);
    procedure ShellViewClick(Sender: TObject);
    procedure FormWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure ImageViewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageViewMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton_helpClick(Sender: TObject);
  private
    //��������� �����
    FFileNames:TStrings;
    //������ ���
    //���������� ��������
    FFirstDir:String;
    //���������
    FState:Boolean;
    //��������� ���� ����� �����
    //���� � ����� �����
    procedure ValidateFileEdit;
  public
    property FirstDir:String read FFirstDir write FFirstDir;
    //������� ������
    //� ���������� ������
    //���� �� ���-�� ������
    procedure Execute;
    //���������� �����������
    function CountResult:Integer;
    //�������� ���������� ���������
    function ResultString(Index:Integer):String;
  end;

var
  OpenForm: TOpenForm;
  RightButtonPressed:Boolean = false;
  //ClearBitmap:Boolean = false;

implementation

uses
  Dialogs, ExtCtrls, Math,
  hyiedefs,hyieutils,
  CRArchive, MainProgramHeader;

{$R *.dfm}

procedure TShellListView.DblClick;
begin
  if Selected = nil then
    Exit;
  AutoNavigate := False;
  with Folders[Selected.Index] do
  begin
    if IsFolder then
      AutoNavigate := True;
  end;
  inherited DblClick;
end;

procedure TOpenForm.FormCreate(Sender: TObject);
begin
  FFileNames:=TStringList.Create;
  SpeedButton_help.Glyph.LoadFromFile(GetGifFileDocumentation);
end;

procedure TOpenForm.FormDestroy(Sender: TObject);
begin
  FFileNames.Free;
end;

procedure TOpenForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
  begin
    //���� ������� ��������
    //��������� ������ �� ������
    if ShellView.Focused or ComboBox.Focused then
    begin
      if ShellView.SelectedFolder <> nil then
      begin
        if not ShellView.SelectedFolder.IsFolder then
          Open.Click;
      end;
      Exit;
    end;
    //���� ������� ��� �����
    //����� ����� �� ������������ ���
    if FileNameEdit.Focused then
      ValidateFileEdit
    else
      Open.Click;
  end;
  if Key = 112 then
    SpeedButton_helpClick(nil);
end;

procedure TOpenForm.OpenClick(Sender: TObject);
var
  GetPos:Integer;
begin
  FState:=true;
  FFileNames.Clear;
  //���� �������� �����
  if FileNameEdit.Text <> '' then
  begin
    ValidateFileEdit;
    Exit;
  end;
  //���� ������ �� �������
  if ShellView.SelCount = 0 then
    Exit;
  //���� ������ ����
  //�� ��������� ������
  //������ � ������
  if ShellView.SelCount = 1 then
  begin
    FFileNames.Add(ShellView.SelectedFolder.PathName);
    Close;
  end;
  if ShellView.SelCount > 1 then
  begin
    for GetPos:=0 to ShellView.Items.Count-1 do
      if ShellView.Items[GetPos].Selected then
        if not ShellView.Folders[GetPos].IsFolder then
          FFileNames.Add(ShellView.Folders[GetPos].PathName);
    if FFileNames.Count > 0 then
      Close;
  end;
end;

procedure TOpenForm.ShellViewAddFolder(Sender: TObject; AFolder: TShellFolder;
  var CanAdd: Boolean);
var
  Ext:String;
begin
  CanAdd:=false;
  //���� ����� �� �������
  if AFolder.IsFolder then
    CanAdd:=true;
  //������ ������
  Ext:=ExtractFileExt(AFolder.PathName);
  if (Ext = '.cbr') or
    (Ext = '.rar') or
    (Ext = '.cbr') or
    (Ext = '.cbz') or
    (Ext = '.cb7') or
    (Ext = '.7z') or
    (Ext = '.gz') or
    (Ext = '.arj') or
    (Ext = '.tar') or

    (Ext = '.jpg') or
    (Ext = '.jpeg') or
    (Ext = '.jpe') or
    (Ext = '.jif') or
    (Ext = '.jp2') or

    (Ext = '.pcx') or
    (Ext = '.dcm') or
    (Ext = '.dic') or
    (Ext = '.dicom') or
    (Ext = '.v2') or


    (Ext = '.bmp') or
    (Ext = '.wmf') or
    (Ext = '.emf') or
    (Ext = '.gif') or
    (Ext = '.png') or

    (Ext = '.tif') or
    (Ext = '.tiff') or
    (Ext = '.tga') or
    (Ext = '.psd') or
    (Ext = '.dcx') or
    (Ext = '.wdp') or
    (Ext = '.hdp') or
    (Ext = '.wbmp')
    then
      CanAdd:=true;
end;

//���������� ���� �
//��������� ��������� �����
function GetWindowsTempPath:String;
var
  pTempPath:PChar;
begin
  pTempPath := StrAlloc(MAX_PATH + 1);
  GetTempPath(MAX_PATH+1, pTempPath);
  Result := string(pTempPath);
  StrDispose(pTempPath);
end;

function ExtractFileFromArchive(FileName:String):String;
var
  ArcObj:TAlArchive;
  TempPath:String;
  GetStr:String;
begin
  ArcObj:=T7Zip.Create(FileName);
  //���� ����� �� ������� �������
  if ArcObj.TestArchive and ArcObj.ReadListOfFiles then
  begin
    //��������� ����
    TempPath:=GetWindowsTempPath;
    GetStr:=ArcObj.ExtractFirstImage(TempPath);
    if GetStr = '' then
      Exit('');
    //���������� ���� � ����
    Result:=TempPath + ExtractFileName(GetStr);
  end;
  ArcObj.Free;
end;

procedure TOpenForm.ShellViewChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
  GetExt:String;
  bfArchive:Boolean;
  GetPos:Integer;
  ArcFile:String;
begin
  //���� ������� �����
  //�� ������ �� ����������
  if ShellView.SelCount > 1 then
    Exit;
  ImageView.LayersClear;
  if (ShellView.SelectedFolder <> nil) and
    not ShellView.SelectedFolder.IsFolder then
  begin
    GetExt:=ExtractFileExt(ShellView.SelectedFolder.PathName);
    bfArchive:=false;
    for GetPos:=0 to High(ArchiveFilters) do
      if ArchiveFilters[GetPos] = GetExt then
        bfArchive:=true;
    if bfArchive then
    begin
      //��������� ������� �� ������
      ArcFile:=ExtractFileFromArchive(ShellView.SelectedFolder.PathName);
      if ArcFile <> '' then
      begin
        ImageView.IO.LoadFromFile(ArcFile);
        //������������
        ImageView.Fit;
      end;
    end else
    begin
      //��������� �� �����
      ImageView.IO.LoadFromFile(ShellView.SelectedFolder.PathName);
      //������������
      ImageView.Fit;
    end;
  end;
end;

procedure TOpenForm.ShellViewClick(Sender: TObject);
begin
  //
end;

procedure TOpenForm.ShellViewDblClick(Sender: TObject);
begin
  Self.Open.Click;
end;

procedure TOpenForm.SpeedButton_helpClick(Sender: TObject);
begin
  ShowDocumentation(PWideChar('openfiledialog'));
end;

procedure TOpenForm.FormWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  GScroll,
  GLimit:boolean;
  View:TImageEnView;
begin
  //�������� ������
  //���������
  if Sender is TForm then
    View:=TImageEnView(TForm(Sender).FindComponent('Image'))
  else
    View:=TImageEnView(Sender);
  //���������� �����������
  //��������� � ������������
  if WheelDelta < 0 then
  begin
    if RightButtonPressed then
      View.ViewY:=View.ViewY+20
    else
      View.ViewX:=View.ViewX+20;
  end
  else begin
    if RightButtonPressed then
      View.ViewY:=View.ViewY-20
    else
      View.ViewX:=View.ViewX-20;
  end;
end;

procedure TOpenForm.ImageViewMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    RightButtonPressed:=true;
end;

procedure TOpenForm.ImageViewMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    RightButtonPressed:=false;
end;

procedure TOpenForm.PreviewButtonClick(Sender: TObject);
var
  PreviewForm: TForm;
  Panel: TPanel;
begin
  if ImageView.IsEmpty then
    Exit;
  PreviewForm := TForm.Create(Self);
  with PreviewForm do
  try
    Name := 'PreviewForm';
    Visible := False;
    Caption := 'Preview';
    BorderStyle := bsSizeToolWin;
    KeyPreview := True;
    Position := poScreenCenter;
    OnKeyPress := PreviewKeyPress;
    OnMouseWheel := FormWheel;
    Panel := TPanel.Create(PreviewForm);
    Cursor := crArrow;
    with Panel do
    begin
      Name := 'Panel';
      Caption := '';
      Align := alClient;
      BevelOuter := bvNone;
      BorderStyle := bsSingle;
      BorderWidth := 5;
      Parent := PreviewForm;
      DoubleBuffered := True;
      Cursor := crArrow;
      with TImageEnView.Create(PreviewForm) do
      begin
        Name:='Image';
        ZoomFilter:=rfLanczos3;
        MouseWheelParams.Action:=iemwNone;
        MouseInteract:=[miScroll];
        Align:=alClient;
        IEBitmap.Assign(ImageView.IEBitmap);
        Cursor:=crDefault;
        Parent:=Panel;
        OnMouseWheel:=FormWheel;
        OnMouseDown:=ImageViewMouseDown;
        OnMouseUp:=ImageViewMouseUp;
        Cursor := crArrow;
      end;
    end;
    if ImageView.IEBitmap.Width > 0 then
    begin
      ClientWidth := Min(Monitor.Width * 3 div 4,
        ImageView.IEBitmap.Width + (ClientWidth - Panel.ClientWidth)+ 10);
      ClientHeight := Min(Monitor.Height * 3 div 4,
        ImageView.IEBitmap.Height + (ClientHeight - Panel.ClientHeight) + 10);
    end;
    ShowModal;
  finally
    Free;
  end;
end;

procedure TOpenForm.ButtonUpToFolderClick(Sender: TObject);
begin
  ShellView.Back;
end;

procedure TOpenForm.PreviewKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then TForm(Sender).Close;
end;

//��������� ���� ����� �����
//���� � ����� �����
procedure TOpenForm.ValidateFileEdit;
begin
  //���� ����� ����� ����������
  //�� ��������� � ���
  if DirectoryExists(FileNameEdit.Text) then
  begin
    ComboBox.Path:=FileNameEdit.Text;
    ShellTree.Path:=FileNameEdit.Text;
    Exit;
  end;
  if FileExists(FileNameEdit.Text) then
  begin
    FState:=true;
    FFileNames.Clear;
    FFileNames.Add(FileNameEdit.Text);
    Self.Close;
  end;
end;

function GetLangKey(Key:String):String;
begin
  Result:=MultiLanguage_GetGroupValue(PWideChar('OPENDIALOG'),PWideChar(Key));
end;

procedure TOpenForm.Execute;
var
  NameGroup:String;
begin
  //������ ������
  FFileNames.Clear;
  //������ ���������
  ShellView.ClearSelection;
  FileNameLabel.Caption:=GetLangKey('file_name') + ':';
  FolderLabel.Caption:=GetLangKey('folder_name') + ':';
  Open.Caption:=GetLangKey('open_button');
  Cancel.Caption:=GetLangKey('cancel_button');
  Caption:=GetLangKey('title');
  //���� ������� �����
  //� ��� ���������� ��
  //��������� �� ���
  if (FFirstDir <> '') and DirectoryExists(FFirstDir) then
  begin
    ComboBox.Path:=FFirstDir;
    ShellTree.Path:=FFirstDir;
  end;
  //������� ������ ��������
  Self.ShowModal;
  if not FState then
    Self.FFileNames.Clear;
end;

//���������� �����������
procedure TOpenForm.CancelClick(Sender: TObject);
begin
  FState:=false;
end;

function TOpenForm.CountResult:Integer;
begin
  Exit(FFileNames.Count);
end;

//�������� ���������� ���������
function TOpenForm.ResultString(Index:Integer):String;
begin
  if Index >= FFileNames.Count then
    Exit('');
  Result:=FFileNames.Strings[Index];
end;

end.
