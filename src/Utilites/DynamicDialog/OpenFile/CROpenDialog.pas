{
  drComRead

  Модифицированный диалог
  открытия файлов
  поддерживающий предпросмотр
  картинок а также предпросмотр
  обложки архивов а также
  поддерживающий все доступные
  для чтения форматы графики

  Copyright (c) 2010 Romanus
}
unit CROpenDialog;

interface

uses
  Messages, Windows, SysUtils, Classes, Controls, StdCtrls,
  Graphics, ExtCtrls, Buttons, Dialogs, Consts,
  imageenview, imageen, imageenio, ExtDlgs;

type
  TCROpenDialog = class(TOpenDialog)
  private
    FPicturePanel: TPanel;
    FPictureLabel: TLabel;
    FPreviewButton: TSpeedButton;
    FPaintPanel: TPanel;
    FImageCtrl: TImage;
    FSavedFilename: string;
    function  IsFilterStored: Boolean;
    procedure PreviewKeyPress(Sender: TObject; var Key: Char);
  protected
    procedure PreviewClick(Sender: TObject); virtual;
    procedure DoClose; override;
    procedure DoSelectionChange; override;
    procedure DoShow; override;
    property ImageCtrl: TImage read FImageCtrl;
    property PictureLabel: TLabel read FPictureLabel;
  published
    property Filter stored IsFilterStored;
  public
    constructor Create(AOwner: TComponent); override;
    function Execute(ParentWnd: HWND): Boolean; override;
  end;

implementation

uses
  Math, Forms, CommDlg, Dlgs, Types,
  CRArchive, hyiedefs;

type
  TSilentPaintPanel = class(TPanel)
  public
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
  end;

procedure TSilentPaintPanel.WMPaint(var Msg: TWMPaint);
begin
  try
    inherited;
  except
    Caption := SInvalidImage;
  end;
end;

//определяем путь к
//системной временной папке
function GetWindowsTempPath:String;
var
  pTempPath:PChar;
begin
  pTempPath := StrAlloc(MAX_PATH + 1);
  GetTempPath(MAX_PATH+1, pTempPath);
  Result := string(pTempPath);
  StrDispose(pTempPath);
end;

constructor TCROpenDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Filter := GraphicFilter(TGraphic);
  FPicturePanel := TPanel.Create(Self);
  with FPicturePanel do
  begin
    Name := 'PicturePanel';
    Caption := '';
    SetBounds(204, 5, 169, 200);
    BevelOuter := bvNone;
    BorderWidth := 6;
    TabOrder := 1;
    FPictureLabel := TLabel.Create(Self);
    with FPictureLabel do
    begin
      Name := 'PictureLabel';
      Caption := '';
      SetBounds(6, 6, 157, 23);
      Align := alTop;
      AutoSize := False;
      Parent := FPicturePanel;
    end;
    FPreviewButton := TSpeedButton.Create(Self);
    with FPreviewButton do
    begin
      Name := 'PreviewButton';
      SetBounds(77, 1, 23, 22);
      Enabled := False;
      Glyph.LoadFromResourceName(HInstance, 'PREVIEWGLYPH');
      Hint := SPreviewLabel;
      ParentShowHint := False;
      ShowHint := True;
      OnClick := PreviewClick;
      Parent := FPicturePanel;
    end;
    FPaintPanel := TSilentPaintPanel.Create(Self);
    with FPaintPanel do
    begin
      Name := 'PaintPanel';
      Caption := '';
      SetBounds(6, 29, 157, 145);
      Align := alClient;
      BevelInner := bvRaised;
      BevelOuter := bvLowered;
      TabOrder := 0;
      FImageCtrl := TImage.Create(Self);
      Parent := FPicturePanel;
      with FImageCtrl do
      begin
        Name := 'PaintBox';
        Align := alClient;
        OnDblClick := PreviewClick;
        Parent := FPaintPanel;
        Proportional := True;
        Stretch := True;
        Center := True;
        IncrementalDisplay := True;
      end;
    end;
  end;
end;

procedure TCROpenDialog.DoSelectionChange;
var
  FullName: string;
  ValidPicture: Boolean;

  function ValidFile(const FileName: string): Boolean;
  begin
    Result := true;
  end;

  function ExtractFileFromArchive(FileName:String):String;
  var
    ArcObj:TAlArchive;
    TempPath:String;
    GetStr:String;
  begin
    ArcObj:=T7Zip.Create(FileName);
    //если архив не удалось открыть
    if not ArcObj.TestArchive then
      Exit('');
    //если не удалось прочесть
    //список файлов
    if not ArcObj.ReadListOfFiles then
      Exit('');
    //извлекаем файл
    TempPath:=GetWindowsTempPath;
    GetStr:=ArcObj.ExtractFirstImage(TempPath);
    if GetStr = '' then
      Exit('');
    //возвращаем путь к нему
    Result:=TempPath + ExtractFileName(GetStr);
    ArcObj.Free;
  end;

  function GetBitmap(FileName:String):TBitmap;
  var
    Proc:TImageEnIO;
    GetExt:String;
    ArcMode:Boolean;
  begin
    ArcMode:=false;
    GetExt:=ExtractFileExt(FileName);
    GetExt:=LowerCase(GetExt);
    if (GetExt = '.cbr') or (GetExt = '.rar') or
       (GetExt = '.cbz') or (GetExt = '.zip') or
       (GetExt = '.cb7') or (GetExt = '.7z')
       then
    begin
      FileName:=ExtractFileFromArchive(FileName);
      if FileName = '' then
        Exit(nil);
      ArcMode:=true;
    end;

    Result:=TBitmap.Create;
    Proc:=TImageEnIO.Create(nil);
    Proc.Bitmap:=Result;
    try
      Proc.LoadFromFile(FileName);
    except
      Result:=nil;
    end;
    //удаляем файл
    //если открыли архивы
    if ArcMode then
      DeleteFile(FileName);
  end;

begin
  FullName := FileName;
  FImageCtrl.Picture:=nil;
  if FullName <> FSavedFilename then
  begin
    FSavedFilename := FullName;
    ValidPicture := FileExists(FullName) and ValidFile(FullName);
    if ValidPicture then
    try
      FImageCtrl.Picture.Bitmap:=GetBitmap(FullName);
      FPictureLabel.Caption := Format(SPictureDesc,
        [FImageCtrl.Picture.Width, FImageCtrl.Picture.Height]);
      FPreviewButton.Enabled := True;
      FPaintPanel.Caption := '';
    except
      ValidPicture := False;
    end;
    if not ValidPicture then
    begin
      FPictureLabel.Caption := SPictureLabel;
      FPreviewButton.Enabled := False;
      FImageCtrl.Picture:=nil;
      FPaintPanel.Caption := srNone;
    end;
  end;
  inherited DoSelectionChange;
end;

procedure TCROpenDialog.DoClose;
begin
  inherited DoClose;
  Application.HideHint;
end;

procedure TCROpenDialog.DoShow;
var
  PreviewRect, StaticRect: TRect;
begin
  { Set preview area to entire dialog }
  GetClientRect(Handle, PreviewRect);
  StaticRect := GetStaticRect;
  { Move preview area to right of static area }
  PreviewRect.Left := StaticRect.Left + (StaticRect.Right - StaticRect.Left);
  Inc(PreviewRect.Top, 4);
  FPicturePanel.BoundsRect := PreviewRect;
  FPreviewButton.Left := FPaintPanel.BoundsRect.Right - FPreviewButton.Width - 2;
  FImageCtrl.Picture:=nil;
  FSavedFilename := '';
  FPaintPanel.Caption := srNone;
  FPicturePanel.ParentWindow := Handle;
  inherited DoShow;
end;

function TCROpenDialog.Execute(ParentWnd: HWND): Boolean;
begin
  if NewStyleControls and not (ofOldStyleDialog in Options) and not
     ((Win32MajorVersion >= 6) and UseLatestCommonDialogs) then
    Template := 'DLGTEMPLATE'
  else
    Template := nil;
  Result := inherited Execute(ParentWnd);
end;

procedure TCROpenDialog.PreviewClick(Sender: TObject);
var
  PreviewForm: TForm;
  Panel: TPanel;
begin
  PreviewForm := TForm.Create(Self);
  with PreviewForm do
  try
    Name := 'PreviewForm';
    Visible := False;
    Caption := SPreviewLabel;
    BorderStyle := bsSizeToolWin;
    KeyPreview := True;
    Position := poScreenCenter;
    OnKeyPress := PreviewKeyPress;
    Panel := TPanel.Create(PreviewForm);
    with Panel do
    begin
      Name := 'Panel';
      Caption := '';
      Align := alClient;
      BevelOuter := bvNone;
      BorderStyle := bsSingle;
      BorderWidth := 5;
      Color := clWindow;
      Parent := PreviewForm;
      DoubleBuffered := True;
      with TImageEnView.Create(PreviewForm) do
      begin
        Name := 'Image';
        ZoomFilter:=rfLanczos3;
        MouseInteract:=[miScroll];
        Align := alClient;
        IEBitmap.Assign(FImageCtrl.Picture.Bitmap);
        Parent := Panel;
      end;
    end;
    if FImageCtrl.Picture.Width > 0 then
    begin
      ClientWidth := Min(Monitor.Width * 3 div 4,
        FImageCtrl.Picture.Width + (ClientWidth - Panel.ClientWidth)+ 10);
      ClientHeight := Min(Monitor.Height * 3 div 4,
        FImageCtrl.Picture.Height + (ClientHeight - Panel.ClientHeight) + 10);
    end;
    ShowModal;
  finally
    Free;
  end;
end;

procedure TCROpenDialog.PreviewKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then TForm(Sender).Close;
end;

function TCROpenDialog.IsFilterStored: Boolean;
begin
  Result := not (Filter = GraphicFilter(TGraphic));
end;

end.

