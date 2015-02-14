{
  drComRead

  ������ ��� ���� �������������������
  �������� �������

  Copyright (c) 2012 Romanus
}
unit CRDialogPanel;

interface

uses
  ExtCtrls, Classes, Controls, Graphics, Generics.Collections,
  hyieutils, ImageEnIO;

type
  //���������� �������
  TCRDialogHandlerCheckEvent = procedure (var CheckResult:Boolean) of object;
  //������� �������� � �������
  TCRDialogHandlerExternal = function (Control:TWinControl):Boolean;

  //�������
  TCRDialogHandler = class
  private
    //��� �������
    FNameDialog:String;
    //������
    FIcon:TIEBitmap;
    //���������� ��������
    //��� ������
    FCheckEvent:TCRDialogHandlerCheckEvent;
  protected
    //����������� �������
    //�� �������� �������
    procedure IntegrateWinControl(Control:TWinControl);
  public
    //���������� ��������
    property OnCheck:TCRDialogHandlerCheckEvent read FCheckEvent write FCheckEvent;
    //������
    property Icon:TIEBitmap read FIcon;
    //��� �������
    property NameDialog:String read FNameDialog;
    //�����������
    constructor Create(NameDialog:String;IconPath:String);
    //����������
    destructor Destroy;override;
    //�������� �� �����������
    //������� �������
    function Check:Boolean;
  end;

  TCRDialogsPanel = class
  private
    //������ � ��������
    //���������������
    FPanel:TPanel;
    //������ � ������������
    //����������, �������������
    //�� ����� �������� �������
    //� ���������� ����� �� �������� �������
    FControlPanel:TPanel;
    //������ ������������
    FHandlers:TObjectList<TCRDialogHandler>;
    //����� �����������
    //� ������
    FImages:TList<TImage>;
    //���������� ������� �������
    FSorting:TDictionary<Integer,Integer>;
    //������������� ���������
    procedure InitHandlers;
    //������ ����� � ���� ��������
    procedure IsArhiveAndImagesExists(var CheckResult:Boolean);
    //���� � ������ �������� (������� ��� �������)
    procedure ImagesExists(var CheckResult:Boolean);
    //���� �� ������ � ������
    procedure ArchivesExists(var CheckResult:Boolean);
    //���� �� ��������� �����
    procedure TxtFilesExists(var CheckResult:Boolean);
    //���� ���� comread ������������ �� � ������
    procedure ComReadFilesExists(var CheckResult:Boolean);
  protected
    //��������� ������
    //��������� ������������
    procedure FormingHandlers;
    //���������� ��������
    procedure ImageClickEvent(Sender:TObject);
  public
    //�����������
    constructor Create(Parent:TWinControl;ParentHide:TWinControl);
    //����������
    destructor Destroy;override;
    //�������� ������ ��������
    //��������� � ������ ������
    procedure ShowOnlyControls;
    //�������� ������
    procedure ShowDialog(id:Integer);
  end;

//������� ������ � ��������
procedure CreateDialogAtWinControl(Control:TWinControl;Name:String);

var
  DialogsLinksDynamic:TDictionary<String,TCRDialogHandlerExternal>;

implementation

uses
  SysUtils, CRGlobal, DLLHeaders;

{$REGION 'TCRDialogHandler'}

//����������� �������
//�� �������� �������
procedure TCRDialogHandler.IntegrateWinControl(Control:TWinControl);
begin
  CreateDialogAtWinControl(Control,FNameDialog);
end;

//�����������
constructor TCRDialogHandler.Create(NameDialog:String;IconPath:String);
var
  ImageIO:TImageEnIO;
begin
  FNameDialog:=NameDialog;
  FIcon:=TIEBitmap.Create;
  ImageIO:=TImageEnIO.Create(nil);
  ImageIO.AttachedIEBitmap:=FIcon;
  ImageIO.LoadFromFile(IconPath);
  ImageIO.Free;
end;

//����������
destructor TCRDialogHandler.Destroy;
begin
  FIcon.Free;
end;

//�������� �� �����������
//������� �������
function TCRDialogHandler.Check:Boolean;
begin
  if Assigned(FCheckEvent) then
    FCheckEvent(Result)
  else
    //������ ��������� �� �����
    //���� �������������
    Result:=false;
end;

{$ENDREGION}

{$REGION 'TCRDialogsPanel'}

//������������� ���������
procedure TCRDialogsPanel.InitHandlers;
var
  SortDialog:TCRDialogHandler;
  SortArcDialog:TCRDialogHandler;
  InformationDialog:TCRDialogHandler;
  TxtDialog:TCRDialogHandler;
begin
  //������ ���������� ������
  SortDialog:=TCRDialogHandler.Create('sortdialog',PathToProgramDir+'Data\dpanel\imagesort.png');
  SortDialog.OnCheck:=ImagesExists;
  //������ ���������� �������
  SortArcDialog:=TCRDialogHandler.Create('sortarcdialog',PathToProgramDir+'Data\dpanel\archivesort.png');
  SortArcDialog.OnCheck:=ArchivesExists;
  //������ ��������� ������
  TxtDialog:=TCRDialogHandler.Create('txtdialog',PathToProgramDir+'Data\dpanel\textfiles.png');
  TxtDialog.OnCheck:=TxtFilesExists;
  //������ ���������� � ������
  InformationDialog:=TCRDialogHandler.Create('infodialog',PathToProgramDir+'Data\dpanel\infoarchive.png');
  InformationDialog.OnCheck:=ComReadFilesExists;

  //������������ � ������ ���������
  FHandlers.Add(InformationDialog);
  FHandlers.Add(SortDialog);
  FHandlers.Add(SortArcDialog);
  FHandlers.Add(TxtDialog);
end;

//������ ����� � ���� ��������
procedure TCRDialogsPanel.IsArhiveAndImagesExists(var CheckResult:Boolean);
begin
  {$IFDEF _CONSOLE_TESTRUNNER}
  CheckResult:=true;
  {$ELSE}
  CheckResult:=(DirObj.ArchiveOpened and DirObj.NotEmpty);
  {$ENDIF}
end;

//���� � ������ �������� (������� ��� �������)
procedure TCRDialogsPanel.ImagesExists(var CheckResult:Boolean);
begin
  {$IFDEF _CONSOLE_TESTRUNNER}
  CheckResult:=true;
  {$ELSE}
  CheckResult:=DirObj.NotEmpty;
  {$ENDIF}
end;

//���� �� ������ � ������
procedure TCRDialogsPanel.ArchivesExists(var CheckResult:Boolean);
begin
  {$IFDEF _CONSOLE_TESTRUNNER}
  CheckResult:=true;
  {$ELSE}
  CheckResult:=(DirObj.Archives.Count > 0);
  {$ENDIF}
end;

//���� �� ��������� �����
procedure TCRDialogsPanel.TxtFilesExists(var CheckResult:Boolean);
begin
  {$IFDEF _CONSOLE_TESTRUNNER}
  CheckResult:=true;
  {$ELSE}
  CheckResult:=(DirObj.TxtFiles.Count > 0);
  {$ENDIF}
end;

//���� ���� comread ������������ �� � ������
procedure TCRDialogsPanel.ComReadFilesExists(var CheckResult:Boolean);
begin
  {$IFDEF _CONSOLE_TESTRUNNER}
  CheckResult:=true;
  {$ELSE}
  CheckResult:=DirObj.ComReadInfoFile;
  {$ENDIF}
end;

//��������� ������
//��������� ������������
procedure TCRDialogsPanel.FormingHandlers;
var
  Handler:TCRDialogHandler;
  HandlerIndex:Integer;
  Image:TImage;
  Iteration:Integer;
begin
  FImages.Clear;
  Iteration:=0;
  for HandlerIndex:=0 to FHandlers.Count-1 do
  begin
    Handler:=FHandlers[HandlerIndex];
    if Handler.Check then
    begin
      Image:=TImage.Create(FControlPanel);
      Image.Parent:=FControlPanel;
      Handler.Icon.CopyToTBitmap(Image.Picture.Bitmap);
      Image.Width:=16;
      Image.Height:=16;
      Image.Left:=0;
      Image.Top:=(16+5)*Iteration;
      Image.OnClick:=ImageClickEvent;
      Image.Tag:=Iteration;
      Image.Transparent:=True;
      FImages.Add(Image);
    end;
    Inc(Iteration);
  end;
end;

//���������� ��������
procedure TCRDialogsPanel.ImageClickEvent(Sender:TObject);
begin
  //������� ��������������� ������
  ShowDialog(TImage(Sender).Tag);
end;

//�����������
constructor TCRDialogsPanel.Create(Parent:TWinControl;ParentHide:TWinControl);
begin
  //������ ��� �������
  FPanel:=TPanel.Create(Parent);
  FPanel.AutoSize:=false;
  FPanel.Visible:=false;
  FPanel.Caption:='';
  FPanel.Parent:=Parent;
  FPanel.Left:=0;
  FPanel.Top:=0;
  FPanel.Width:=Parent.ClientWidth-16;
  FPanel.Height:=Parent.ClientHeight;
  FPanel.Anchors:=[akLeft,akTop,akRight,akBottom];
  //������ ��� ����������� ������t
  FControlPanel:=TPanel.Create(Parent);
  FControlPanel.AutoSize:=false;
  FControlPanel.Visible:=false;
  FControlPanel.Caption:='';
  FControlPanel.BevelKind:=bkNone;
  FControlPanel.BevelOuter:=bvNone;
  FControlPanel.Left:=Parent.ClientWidth-16;
  FControlPanel.Top:=0;
  FControlPanel.Width:=16;
  FControlPanel.Height:=Parent.ClientHeight;
  FControlPanel.Anchors:=[akLeft,akTop,akRight,akBottom];
  FControlPanel.Parent:=Parent;

  FHandlers:=TObjectList<TCRDialogHandler>.Create;
  FImages:=TList<TImage>.Create;
  FImages.Clear;

  //������� ��������
  InitHandlers;
end;

//����������
destructor TCRDialogsPanel.Destroy;
begin
  FImages.Free;
  FHandlers.Free;
end;

//�������� ������ ��������
//��������� � ������ ������
procedure TCRDialogsPanel.ShowOnlyControls;
begin
  //���������� ����������
  //��������� ��������
  FormingHandlers;

  //���������� ����������� ������
  FControlPanel.Visible:=true;
end;

//�������� ������
procedure TCRDialogsPanel.ShowDialog(id:Integer);
begin
  //��������� �������
  //FormingHandlers;
  //�� ����� �������������� �������
  //��� ����������� ���������
  if id >= FHandlers.Count then
    raise Exception.Create('Incorrected index at dialog show');
  //���������� ������
  FPanel.Visible:=true;
  FControlPanel.Visible:=true;
  CreateDialogAtWinControl(FPanel,FHandlers[id].NameDialog);
end;

{$ENDREGION}

//������� ������ � ��������
procedure CreateDialogAtWinControl(Control:TWinControl;Name:String);
var
  ExternalFunc:TCRDialogHandlerExternal;
begin
  if not Assigned(DialogsLinksDynamic) then
  begin
    DialogsLinksDynamic:=TDictionary<String,TCRDialogHandlerExternal>.Create;
    DialogsLinksDynamic.Add('sortdialog',SortFilesContext);
    //DialogsLinksDynamic.Add('sortarcdialog',0);
    //DialogsLinksDynamic.Add('txtdialog',0);
    //DialogsLinksDynamic.Add('infodialog',0);
  end;
  ExternalFunc:=DialogsLinksDynamic[Name];
  try
    ExternalFunc(Control);
  except
    raise Exception.Create('Error to init external dialog ' + Name);
  end;
end;

end.

