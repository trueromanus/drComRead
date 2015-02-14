{
  drComicsReader

  ������ ������ �
  �������������

  Copyright (c) 2009-2012 Romanus
}

unit CRImageVisual;

interface

uses
  Windows, Classes, hyieutils, imageenproc;

{$REGION '�������� �����������'}

type
  TCRASDirect     = (asdNone,asdLeft,asdRight,asdTop,asdBottom);
  TCRActiveScroll = class
  private
    //�����������
    FDirect:TCRASDirect;
    //������� ����������
    FActive:boolean;
  public
    //������� ����������
    property Active:boolean read FActive;
    //�����������
    constructor Create;
    //����������
    destructor Destroy;override;
    //�������� ��������
    //��������
    procedure Activate;
    //��������� ��������
    //��������
    procedure DeActivate;
    //������������
    //����������
    procedure GetKeyStep(Key: Word; Shift: TShiftState);
    //������������ ��������
    procedure GetKeyMove(Key: Word; Shift: TShiftState);
    //������������
    //�����
    procedure GetMouseStep(X,Y:integer);
    //������������ �����������
    //����
    procedure GetMouseMove(X,Y:integer);
    //������������ ��������
    procedure MoveStep(const bIgnored:boolean = false);
  end;

{$ENDREGION}

{$REGION '����� �������'}

//��������� ����
procedure NextFrameAnim;
//��������� ���� ��� �������� �������
procedure NextFrameAnimToCallBack;
//���������� �����������
procedure CenteredAnimsImage;
//������������ �����������
procedure UnCenteredAnimsImage;
//��������� ���������������
//������������� ����
procedure MouseWheelHorizontal(GLimit:Boolean;WheelDelta:Integer);
//��������� �������������
//������������� ����
procedure MouseWheelVertical(GLimit:Boolean;WheelDelta:Integer);
//��������� ����� ��
//�� ���� ������� ����
function CheckRightBottomRange:Boolean;
//��������� ����� ��
//�� ���� �������� ����
function CheckLeftTopRange:Boolean;
//��������� ������
//�� �����
function LoadAniCursor(FileName:String;Cur:Integer):Boolean;
//������ �����
//�������
function ChangeCursor(Mode:Byte):Boolean;
//���������� ��������������
//������ �� ������� ����
procedure ShowToInfoPanel(Mess:String);
//������ ������������
//� ����������� ��������
//� ��������� ��� �������
//��������� ����� ����������
procedure PageChangeImageMode(Mode:Byte);
//��������� � ����� ������� ����
procedure ScrollToLeftTop;
//���������� � ������ ������ ����
procedure ScrollToRightBottom;

//��������� � ����
//������� �����
procedure LoadMenuToDirHistory;
//��������� � ����
//������� �������
procedure LoadMenuToArcHistory;

{$ENDREGION}

{$REGION '����� ��� ��������� �������� �����������'}

type
  //����� ������ ��������
  //����� �������� ����������
  //��� ��������� ��������
  //�����������
  TCRImageResizer = class
  private
    //������� �����������
    FBasicImage:TIEBitmap;
    //����� ��� ������
    //� ������������
    FProcImage:TImageEnProc;
    //���������������� ��� �����������
    FTransfomedImage:TIEBitmap;
    //�������� ������
    function GetWidth:Integer;
    //�������� �����
    function GetHeight:Integer;
    //��������� �� �����������
    //�.�. ������� ������ �������
    //���������� ������ ����
    function IsSmallImage:Boolean;
    //���������� ������� �� ��� ��� ������
    function IsPortrait:Boolean;
    //�������� ������� ��� ������� ��������� ���������������
    function GetBasicOptionName:String;
  public
    //�����������
    constructor Create(FileName:String);overload;
    //�����������
    constructor Create(Bitmap:TIEBitmap);overload;
    //����������
    destructor Destroy;override;
    //��������� �� ������
    procedure ResizeToFitWidth;
    //��������� �� ������
    procedure ResizeToFitHeight;
    //��������� �� �������
    procedure ResizeToFit;
    //��������
    procedure ResizeToOriginal;
    //������������� ����������
    //��� �������� �������
    procedure ResizeToAuto;
    //��������� ��� ��������
    //������������
    procedure ResizeToUser;
    //��������� �����
    procedure ColorCorrect;
    //������������� �����������
    //�������� ����������
    procedure TransformImage;
    //��������� ��� ����������� ���������
    //����������� ��� ������ ���
    procedure ChangeImageMode(const Mode:byte = 255);
  end;

{$ENDREGION}

//������� ����� �������
//��������� ��������� ��������
//�����������
function CreateImageResizer(FileName:String):Boolean;overload;
//������� ����� �������
//��������� ��������� ��������
//�����������
function CreateImageResizer(Bitmap:TIEBitmap):Boolean;overload;

implementation

uses
  imageenio, hyiedefs, Graphics,
  MainForm, Controls, Forms, Menus,
  CRGlobal, CRDir, DLLHeaders, CRFastActions,
  Dialogs,SysUtils;

{$REGION '�������� �����������'}

constructor TCRActiveScroll.Create;
begin
  FActive:=false;
end;

destructor TCRActiveScroll.Destroy;
begin
  inherited Destroy;
end;

//�������� ��������
//��������
procedure TCRActiveScroll.Activate;
begin
  MainForm.FormMain.ASTimer.Enabled:=true;
  FActive:=true;
end;

//��������� ��������
//��������
procedure TCRActiveScroll.DeActivate;
begin
  MainForm.FormMain.ASTimer.Enabled:=false;
  FActive:=false;
end;

//������������
//����������
procedure TCRActiveScroll.GetKeyStep(Key: Word; Shift: TShiftState);
begin
  FDirect:=asdNone;
  with FormMain do
  begin
    case Key of
      //�����
      37:FDirect:=asdLeft;
      //�����
      38:FDirect:=asdTop;
      //������
      39:FDirect:=asdRight;
      //����
      40:FDirect:=asdBottom;
    end;
  end;
end;

//������������ ��������
procedure TCRActiveScroll.GetKeyMove(Key: Word; Shift: TShiftState);
begin
  with FormMain do
  begin
    case Key of
      //�����
      100,37:MouseWheelHorizontal(false,100);
      //�����
      104,34:MouseWheelVertical(false,100);
      //������
      102,39:MouseWheelHorizontal(true,-100);
      //����
      98,40:MouseWheelVertical(true,-100);
    end;
  end;
end;

function MinMax(Value,Min,Max:integer):boolean;
begin
  Result:=false;
  if (Value>=Min) and (Value<=Max) then
    Result:=true;  
end;

//������������
//�����
procedure TCRActiveScroll.GetMouseStep(X,Y:integer);
var
  CWidthMin:integer;
  CHeightMin:integer;
  Exp:integer;
begin
  Exp:=SensivityMouseMove;
  CWidthMin:=FormMain.ClientWidth-Exp;
  CHeightMin:=FormMain.ClientHeight-Exp;
  if MinMax(X,CWidthMin,FormMain.ClientWidth) then
  begin
    FDirect:=asdRight;
    Exit;
  end;
  if MinMax(X,0,Exp) then
  begin
    FDirect:=asdLeft;
    Exit;
  end;
  if MinMax(Y,0,Exp) then
  begin
    FDirect:=asdTop;
    Exit;
  end;
  if MinMax(Y,CHeightMin,FormMain.ClientHeight) then
  begin
    FDirect:=asdBottom;
    Exit;
  end;
  FDirect:=asdNone;
end;

//�������� ������
function CheckLimit(Source,Target:integer):boolean;
var
  Exp:integer;
begin
  Exp:=Source-Target;
  if (Exp < 20) and (Exp > -20) then
    Result:=true
  else
    Result:=false;
end;

//������������ �����������
//����
procedure TCRActiveScroll.GetMouseMove(X,Y:integer);
begin
  {with FormMain.MainImage do
  begin
    HorScroll.Position:=HorScroll.Position + ((XSource*Scale)-(X*Scale));
    VerScroll.Position:=VerScroll.Position + ((YSource*Scale)-(Y*Scale));
    UpdateImage;
  end;
  XSource:=X;
  YSource:=Y;}
end;

//������������ ��������
procedure TCRActiveScroll.MoveStep(const bIgnored:boolean = false);
begin
  if (not FActive) and (not bIgnored) then
    Exit;
  with FormMain.MainImage do
  begin
    case FDirect of
      asdLeft:MouseWheelHorizontal(false,100);
      asdRight:MouseWheelHorizontal(true,-100);
      asdTop:MouseWheelVertical(false,100);
      asdBottom:MouseWheelVertical(true,-100);
    end;
  end;
end;

{$ENDREGION}

{$REGION '����� �������'}

//��������� ����
procedure NextFrameAnim;
begin
  Application.ProcessMessages;
end;

//��������� ���� ��� �������� �������
procedure NextFrameAnimToCallBack;
begin
  CenteredAnimsImage;
  NextFrameAnim;
  UnCenteredAnimsImage;
end;

//���������� �����������
procedure CenteredAnimsImage;
begin
  //���� �������������� ������
  //������� ������� ��
  if FormMain.InfoMainForm.Visible then
    FormMain.InfoMainForm.Visible:=false;
  FormMain.LoadingImageView.Visible:=true;
  FormMain.LoadingImageView.Playing:=true;
  FormMain.LoadingImageView.PlayLoop:=true;
end;

//������������ �����������
procedure UnCenteredAnimsImage;
begin
  //�����������
  FormMain.MainImage.Center:=false;
  //������� ���������
  //��� ��������� ��������
  FormMain.LoadingImageView.Visible:=false;
  FormMain.LoadingImageView.Playing:=false;
  FormMain.LoadingImageView.PlayLoop:=false;
end;

//��������� ���������������
//������������� ����
procedure MouseWheelHorizontal(GLimit:Boolean;WheelDelta:Integer);
var
  MaxHorizontal,MaxVertical:Integer;
  Wheel:Integer;
begin
  Wheel:=(WheelDelta div 2);
  with FormMain.MainImage do
  begin
    GetMaxViewXY(MaxHorizontal,MaxVertical);
    if GLimit then
    begin
      //(WheelDelta div 2)
      //���� ������ ������
      //������ ����
      if ViewX = MaxHorizontal then
        ViewY:=ViewY-Wheel
      else
        ViewX:=ViewX-Wheel;
    end else
    begin
      //���� ����� ������
      //������ ����
      if ViewX = 0 then
        ViewY:=ViewY-Wheel
      else
        ViewX:=ViewX-Wheel;
    end;
  end;
end;

//��������� �������������
//������������� ����
procedure MouseWheelVertical(GLimit:Boolean;WheelDelta:Integer);
var
  MaxHorizontal,MaxVertical:Integer;
  Wheel:Integer;
begin
  Wheel:=(WheelDelta div 3);
  with FormMain.MainImage do
  begin
    GetMaxViewXY(MaxHorizontal,MaxVertical);
    if GLimit then
    begin
      //���� ������ ������
      //������
      if ViewY = MaxVertical then
        ViewX:=ViewX-Wheel
      else
        ViewY:=ViewY-Wheel;
    end else
    begin
      //���� ������� ������
      //������ �����
      if ViewY = 0 then
        ViewX:=ViewX-Wheel
      else
        ViewY:=ViewY-Wheel;
    end;
  end;
end;

//��������� ����� ��
//�� ���� ������� ����
function CheckRightBottomRange:Boolean;
var
  Bottom,
  Right:Integer;
begin
  Result:=false;
  with FormMain.MainImage do
  begin
    GetMaxViewXY(Bottom,Right);
    if (ViewX = Bottom) and (ViewY = Right) then
      Result:=true;
  end;
end;

//��������� ����� ��
//�� ���� �������� ����
function CheckLeftTopRange:Boolean;
begin
  Result:=false;
  with FormMain.MainImage do
    if (ViewX = 0) and (ViewY = 0) then
      Result:=true;
end;

//��������� ������
//�� �����
function LoadAniCursor(FileName:String;Cur:Integer):Boolean;
var
  Cursor:HCURSOR;
begin
  if not FileExists(FileName) then
    Exit(false);
  Cursor:=LoadCursorFromFile(PWideChar(FileName));
  if Cursor = 0 then
    Exit(false);
  Screen.Cursors[Cur]:=Cursor;
  Result:=true;
end;

//������ �����
//�������
function ChangeCursor(Mode:Byte):Boolean;
begin
  case Mode of
    //�������
    0:
      begin
        FormMain.MainImage.Cursor:=crArrow;
        SetCursorPos(Mouse.CursorPos.X,Mouse.CursorPos.Y);
      end;
    //��� ��������
    1:
      begin
        FormMain.MainImage.Cursor:=crHourGlass;
        SetCursorPos(Mouse.CursorPos.X,Mouse.CursorPos.Y);
      end;
  end;
  Result:=true;
end;

//���������� ��������������
//������ �� ������� ����
procedure ShowToInfoPanel(Mess:String);
begin
  FormMain.InfoMainForm.Caption:=Mess;
  FormMain.InfoMainForm.Visible:=true;
end;

//������ ������������
//� ����������� ��������
//� ��������� ��� �������
//��������� ����� ����������
procedure PageChangeImageMode(Mode:Byte);
begin
  if not DirObj.NotEmpty then
    Exit;
  case Mode of
    //����� �������
    0:
      begin
        //���� ������ �������
        //�� �� ����������
        if DirObj.Position = 0 then
          Exit;
        //����� � ���� �����
        FormMain.LeftTopLabel.Caption:=IntToStr(DirObj.Position);
        with FormMain.LeftTopImage do
        begin
          //������ ���
          Clear;
          //������ ������ gif
          MIO.LoadFromFileGIF(PathToProgramDir + 'Data\animtop.gif');
          Playing:=true;
          PlayLoop:=true;
        end;
        with FormMain.PagingAnimPanel do
        begin
          //������������ �������
          Left:=0;
          Top:=0;
          //���������� �����
          Visible:=true;
        end;
      end;
    //������ ������
    1:
      begin
        //���� ��������� �������
        //�� �� ����������
        if DirObj.Position = DirObj.BitmapList.Count-1 then
          Exit;
        FormMain.LeftTopLabel.Caption:=IntToStr(DirObj.Position+2);
        with FormMain.LeftTopImage do
        begin
          //������ ���
          Clear;
          //������ ������ gif
          MIO.LoadFromFileGIF(PathToProgramDir + 'Data\animbottom.gif');
          //���������� �����
          Playing:=true;
          PlayLoop:=true;
        end;
        with FormMain.PagingAnimPanel do
        begin
          //������������ �������
          //������������ �������
          if FormMain.BorderStyle = bsNone then
          begin
            Left:=FormMain.Width-100;
            Top:=FormMain.Height-130;
          end else
          begin
            Left:=FormMain.Width-108;
            Top:=FormMain.Height-165;
          end;
          //���������� �����
          Visible:=true;
        end;
      end;
    //�������� ��������
    2:
      begin
        FormMain.PagingAnimPanel.Visible:=false;
        FormMain.LeftTopImage.Playing:=false;
        FormMain.LeftTopImage.PlayLoop:=false;
      end;
  end;
end;

procedure ScrollToLeftTop;
begin
  with FormMain.MainImage do
  begin
    ViewX:=0;
    ViewY:=0;
  end;
end;

procedure ScrollToRightBottom;
var
  MaxX:Integer;
  MaxY:Integer;
begin
  with FormMain.MainImage do
  begin
    GetMaxViewXY(MaxX,MaxY);
    ViewX:=MaxX;
    ViewY:=MaxY;
  end;
end;

//��������� � ����
//������� �����
procedure LoadMenuToDirHistory;
var
  DirHistory:TIndexHistoryArray;
  GetPos:Integer;
  GetName:String;
  MenuItem:TMenuItem;
begin
  with FormMain do
  begin
    Menu_DirHistory.Clear;
    DirHistory:=FindHistoryDirLast(10);
    if DirHistory = nil then
      Exit;
    for GetPos:=0 to High(DirHistory)-1 do
    begin
      GetName:=FindHistoryDirIndex(DirHistory[GetPos]);
      if GetName = '' then
        Exit;
      //������� ��������
      MenuItem:=TMenuItem.Create(FormMain);
      //����������
      MenuItem.OnClick:=FormMain.ClickToHistoryMenu;
      //����� ������������ �����
      MenuItem.Caption:=ExtractFileName(GetName);
      //������ ���� � �����
      //������� � ���������
      MenuItem.Hint:=GetName;
      //��������� � ����
      Menu_DirHistory.Add(MenuItem);
    end;
  end;
end;

//��������� � ����
//������� �������
procedure LoadMenuToArcHistory;
var
  DirHistory:TIndexHistoryArray;
  GetPos:Integer;
  GetPath:PWideChar;
  MenuItem:TMenuItem;
begin
  with FormMain do
  begin
    Menu_ArcHistory.Clear;

    DirHistory:=FindHistoryArcLast(10);
    if DirHistory = nil then
      Exit;
    for GetPos:=0 to High(DirHistory)-1 do
    begin
      GetPath:=FindHistoryArcIndex(DirHistory[GetPos]);
      if GetPath = '' then
        continue;
      //������� ��������
      MenuItem:=TMenuItem.Create(FormMain);
      //����������
      MenuItem.OnClick:=FormMain.ClickToHistoryMenu;
      //����� ������������ �����
      MenuItem.Caption:=ExtractFileName(GetPath);
      //������ ���� � �����
      //������� � ���������
      MenuItem.Hint:=GetPath;
      //��������� � ����
      Menu_ArcHistory.Add(MenuItem);
    end;
  end;
end;

{$ENDREGION}

{$REGION '����� ��� ��������� �������� �����������'}

//�������� ������
function TCRImageResizer.GetWidth:Integer;
begin
  Result:=FormMain.MainImage.Width;
end;

//�������� �����
function TCRImageResizer.GetHeight:Integer;
begin
  Result:=FormMain.MainImage.Height;
end;

//��������� �� �����������
//�.�. ������� ������ �������
//���������� ������ ����
function TCRImageResizer.IsSmallImage:Boolean;
begin
  if (FBasicImage.Width < GetWidth) and
     (FBasicImage.Height < GetHeight)  then
    Exit(true);
  Result:=false;
end;

//���������� ������� �� ��� ��� ������
function TCRImageResizer.IsPortrait:Boolean;
var
  Diff:integer;
begin
  Result:=false;
  Diff:=FTransfomedImage.Width-FTransfomedImage.Height;
  //����������� �� ������
  if Diff > 100 then
    Result:=false;
  //����������� �� ������
  if Diff < -100 then
    Result:=true;
end;

//�������� ������� ��� ������� ��������� ���������������
function TCRImageResizer.GetBasicOptionName:String;
begin
  if IsPortrait then
    Exit('getviewmode')
  else
    Exit('getviewmodevert');
  if DirObj.GetImagesDouble then
    Exit('getviewmodetwopage');
end;

//�����������
constructor TCRImageResizer.Create(FileName:String);
var
  IO:TImageEnIO;
begin
  IO:=TImageEnIO.Create(nil);
  FBasicImage:=TIEBitmap.Create;
  FProcImage:=TImageEnProc.Create(nil);
  IO.IEBitmap:=FBasicImage;
  IO.LoadFromFile(FileName);
  IO.Free;
end;

//�����������
constructor TCRImageResizer.Create(Bitmap:TIEBitmap);
begin
  FBasicImage:=TIEBitmap.Create;
  FBasicImage.Assign(Bitmap);
  FProcImage:=TImageEnProc.Create(nil);
end;

//����������
destructor TCRImageResizer.Destroy;
begin
  FTransfomedImage.Free;
  FProcImage.Free;
  FBasicImage.Free;
end;

//��������� �� ������
procedure TCRImageResizer.ResizeToFitWidth;
begin
  if not IsSmallImage then
    FProcImage.Resample(GetWidth,-1,rfLanczos3);
end;

//��������� �� ������
procedure TCRImageResizer.ResizeToFitHeight;
begin
  if not IsSmallImage then
    FProcImage.Resample(-1,GetHeight,rfLanczos3);
end;

//��������� �� �������
procedure TCRImageResizer.ResizeToFit;
var
  Width,Height:Integer;
begin
  if IsSmallImage then
  begin
    ResizeToOriginal;
    Exit;
  end;
  Width:=GetWidth;
  Height:=GetHeight;
  if (Width > Height) or (Width = Height) then
  begin
    ResizeToFitWidth;
    Exit;
  end;
  if Width < Height then
  begin
    ResizeToFitHeight;
    Exit;
  end;
end;

//��������
procedure TCRImageResizer.ResizeToOriginal;
begin
  //����
  //��������� ��� ��� ���� :)
end;

//������������� ����������
//��� �������� �������
procedure TCRImageResizer.ResizeToAuto;
var
  Diff:integer;
begin
  Diff:=FTransfomedImage.Width-FTransfomedImage.Height;
  //����������� �� ������
  if Diff > 100 then
  begin
    ResizeToFitHeight;
    Exit;
  end;
  //����������� �� ������
  if Diff < -100 then
  begin
    ResizeToFitWidth;
    Exit;
  end;
  ResizeToFit;
end;

//��������� ��� ��������
//������������
procedure TCRImageResizer.ResizeToUser;
var
  BasicName:String;
begin
  with FormMain.MainImage do
  begin
    //���������� �����
    //������� ����� �������
    if IsPortrait then
      BasicName:='getviewmode'
    else
      BasicName:='getviewmodevert';
    if DirObj.GetImagesDouble then
      BasicName:='getviewmodetwopage';
    //���������� �����
    case GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,BasicName+'usermode',0) of
      //��������
      0:;
      //��������� ������
      1:FProcImage.Resample
          (
            GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,BasicName+'user',100),
            -1,
            rfLanczos3
          );
      //��������� �����
      2:FProcImage.Resample
          (
            -1,
            GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,BasicName+'user',0),
            rfLanczos3
          );
    end;
  end;
end;

//������������� �����������
//�������� ����������
procedure TCRImageResizer.TransformImage;
var
  Rotate:Byte;
  Element:PCRFileRecord;
begin
  FTransfomedImage:=TIEBitmap.Create;
  FTransfomedImage.Assign(FBasicImage);
  FProcImage.AttachedIEBitmap:=FTransfomedImage;
  Element:=DirObj.GetElement(DirObj.Position);
  Rotate:=Element.TransformRotState;
  case Element.TransformMode of
    //��� �������������
    0:;
    //������� �� �
    //������ �������
    1,2:
        begin
          case Rotate of
            1:FProcImage.Rotate(270);//90);
            2:FProcImage.Rotate(180);//180);
            3:FProcImage.Rotate(90);//270);
          end;
        end;
    //���������� �����������
    //�����������
    3:FProcImage.Flip(fdHorizontal);
    //���������� �����������
    //���������
    4:FProcImage.Flip(fdVertical);
  end;
end;

//�������������� �����������
procedure TCRImageResizer.ColorCorrect;
begin
  //����������� ������
  if ReadBoolConfig('enabledcurves') then
    MainCurves.ApplyCurvestoIEBitmap(FTransfomedImage);
  //��������� �����
  try
    if ReadBoolConfig('enabledgammacorrection') then
      FProcImage.GammaCorrect(ReadFloatConfig('gammacorrection'),[iecRed,iecGreen,iecBlue]);
  finally
    //���� �� ��� ;)
  end;
  //��������
  if ReadIntConfig('imagecontrast') <> 0 then
    FProcImage.Contrast(ReadIntConfig('imagecontrast'));
  //������� �������� �� �����������
  if ReadBoolConfig('sharpenimages') then
    FProcImage.Sharpen();
  //������������
  if ReadBoolConfig('enablesaturation') then
    FProcImage.AdjustSaturation(ReadIntConfig('saturation'));
end;

//��������� ��� ����������� ���������
//����������� ��� ������ ���
procedure TCRImageResizer.ChangeImageMode(const Mode:byte = 255);
var
  GetMode:Integer;
  BasicName:String;
begin
  if not DirObj.NotEmpty then
    Exit;
  //������������ ��� ��������
  //������� �����������
  TransformImage;
  //������������� �����
  if Mode <> 255 then
  begin
    //���������� ���������
    //��� �������� ������ �����������
    if DirObj.GetImagesDouble then
      ImageModeTwoPage:=Mode
    else begin
      if IsPortrait then
        ImageMode:=Mode
      else
        ImageModeLandscape:=Mode;
    end;
    GetMode:=Mode;
  end else
  //����� ������� �����
  begin
    if IsPortrait then
      GetMode:=ImageMode
    else
      GetMode:=ImageModeLandscape;
    if DirObj.GetImagesDouble then
      GetMode:=ImageModeTwoPage;
  end;

  ColorCorrect;

  //������������
  case GetMode of
    IMAGE_MODE_ORIGINAL:ResizeToOriginal;
    IMAGE_MODE_SCALE:ResizeToFit;
    IMAGE_MODE_STRETCH:ResizeToFitWidth;
    IMAGE_MODE_HEIGHT:ResizeToFitHeight;
    IMAGE_MODE_USER:
      begin
        ResizeToUser;
        BasicName:=GetBasicOptionName;
        if GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,BasicName+'usermode',0) = 0 then
          FormMain.MainImage.Zoom:=GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,BasicName+'user',100);
        FormMain.MainImage.ViewX:=0;
        FormMain.MainImage.ViewY:=0;
      end;
    IMAGE_MODE_AUTOSIZE:ResizeToAuto;
  end;
  //���������� � ������� �����������
  FormMain.MainImage.LayersClear;
  FormMain.MainImage.IEBitmap.Assign(FTransfomedImage);
  FreeAndNil(FTransfomedImage);
  FormMain.MainImage.Center:=true;
  //�������������� �����������
  FormMain.MainImage.Repaint;
end;

{$ENDREGION}

//������� ����� �������
//��������� ��������� ��������
//�����������
function CreateImageResizer(FileName:String):Boolean;overload;
begin
  try
    if Assigned(ImageResizer) then
      FreeAndNil(ImageResizer);
    ImageResizer:=TCRImageResizer.Create(FileName);
    Result:=true;
  except
    Result:=false;
  end;
end;

//������� ����� �������
//��������� ��������� ��������
//�����������
function CreateImageResizer(Bitmap:TIEBitmap):Boolean;overload;
begin
  try
    if Assigned(ImageResizer) then
      FreeAndNil(ImageResizer);
    ImageResizer:=TCRImageResizer.Create(Bitmap);
    Result:=true;
  except
    Result:=false;
  end;
end;

end.
