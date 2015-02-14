{
  drComicsReader

  Модуль работы с
  изображениями

  Copyright (c) 2009-2012 Romanus
}

unit CRImageVisual;

interface

uses
  Windows, Classes, hyieutils, imageenproc;

{$REGION 'Активное перемещение'}

type
  TCRASDirect     = (asdNone,asdLeft,asdRight,asdTop,asdBottom);
  TCRActiveScroll = class
  private
    //направление
    FDirect:TCRASDirect;
    //признак активности
    FActive:boolean;
  public
    //признак активности
    property Active:boolean read FActive;
    //конструктор
    constructor Create;
    //деструктор
    destructor Destroy;override;
    //включаем активный
    //скролинг
    procedure Activate;
    //выключаем активный
    //скролинг
    procedure DeActivate;
    //обрабатываем
    //клавиатуру
    procedure GetKeyStep(Key: Word; Shift: TShiftState);
    //обрабатываем движение
    procedure GetKeyMove(Key: Word; Shift: TShiftState);
    //обрабатываем
    //мышку
    procedure GetMouseStep(X,Y:integer);
    //обрабатываем перемещение
    //мыши
    procedure GetMouseMove(X,Y:integer);
    //обрабатываем движение
    procedure MoveStep(const bIgnored:boolean = false);
  end;

{$ENDREGION}

{$REGION 'Общие функции'}

//следующий кадр
procedure NextFrameAnim;
//следующий кадр для обратных вызовов
procedure NextFrameAnimToCallBack;
//центрируем изображение
procedure CenteredAnimsImage;
//децентрируем изображение
procedure UnCenteredAnimsImage;
//обработка горизонтального
//скролирования мыши
procedure MouseWheelHorizontal(GLimit:Boolean;WheelDelta:Integer);
//обработка вертикального
//скролирования мыши
procedure MouseWheelVertical(GLimit:Boolean;WheelDelta:Integer);
//проверяем дошел ли
//до пика нижнего угла
function CheckRightBottomRange:Boolean;
//проверяем дошел ли
//до пика верхнего угла
function CheckLeftTopRange:Boolean;
//загружаем курсор
//из файла
function LoadAniCursor(FileName:String;Cur:Integer):Boolean;
//меняем режим
//курсора
function ChangeCursor(Mode:Byte):Boolean;
//отображаем информационную
//панель на главном окне
procedure ShowToInfoPanel(Mess:String);
//меняем расположение
//и изображение картинки
//с анимацией для быстрых
//переходов между страницами
procedure PageChangeImageMode(Mode:Byte);
//сколируем в левый верхний угол
procedure ScrollToLeftTop;
//скролируем в правый нижний угол
procedure ScrollToRightBottom;

//загружаем в меню
//историю папок
procedure LoadMenuToDirHistory;
//загружаем в меню
//историю архивов
procedure LoadMenuToArcHistory;

{$ENDREGION}

{$REGION 'Класс для изменения размеров изображения'}

type
  //класс внутри которого
  //будет вариться функционал
  //для изменения размеров
  //изображения
  TCRImageResizer = class
  private
    //базовое изображение
    FBasicImage:TIEBitmap;
    //класс для работы
    //с изображением
    FProcImage:TImageEnProc;
    //трансформируемое уже изображение
    FTransfomedImage:TIEBitmap;
    //получить ширину
    function GetWidth:Integer;
    //получить длину
    function GetHeight:Integer;
    //маленькое ли изображение
    //т.е. которое вполне целиком
    //помещается внутри окна
    function IsSmallImage:Boolean;
    //определяем портрет ли это или альбом
    function IsPortrait:Boolean;
    //получить базовое имя текущей настройки масштабирования
    function GetBasicOptionName:String;
  public
    //конструктор
    constructor Create(FileName:String);overload;
    //конструктор
    constructor Create(Bitmap:TIEBitmap);overload;
    //деструктор
    destructor Destroy;override;
    //подгоняем по ширине
    procedure ResizeToFitWidth;
    //подгоняем по высоте
    procedure ResizeToFitHeight;
    //подгоняем по размеру
    procedure ResizeToFit;
    //оригинал
    procedure ResizeToOriginal;
    //автоматически определяем
    //как изменять размеры
    procedure ResizeToAuto;
    //подогнать под значение
    //пользователя
    procedure ResizeToUser;
    //коррекция цвета
    procedure ColorCorrect;
    //трансформация изображения
    //согласно настройкам
    procedure TransformImage;
    //выполняем все необходимые обработки
    //изображения для вывода его
    procedure ChangeImageMode(const Mode:byte = 255);
  end;

{$ENDREGION}

//создаем класс который
//выполняет изменение размеров
//изображения
function CreateImageResizer(FileName:String):Boolean;overload;
//создаем класс который
//выполняет изменение размеров
//изображения
function CreateImageResizer(Bitmap:TIEBitmap):Boolean;overload;

implementation

uses
  imageenio, hyiedefs, Graphics,
  MainForm, Controls, Forms, Menus,
  CRGlobal, CRDir, DLLHeaders, CRFastActions,
  Dialogs,SysUtils;

{$REGION 'Активное перемещение'}

constructor TCRActiveScroll.Create;
begin
  FActive:=false;
end;

destructor TCRActiveScroll.Destroy;
begin
  inherited Destroy;
end;

//включаем активный
//скролинг
procedure TCRActiveScroll.Activate;
begin
  MainForm.FormMain.ASTimer.Enabled:=true;
  FActive:=true;
end;

//выключаем активный
//скролинг
procedure TCRActiveScroll.DeActivate;
begin
  MainForm.FormMain.ASTimer.Enabled:=false;
  FActive:=false;
end;

//обрабатываем
//клавиатуру
procedure TCRActiveScroll.GetKeyStep(Key: Word; Shift: TShiftState);
begin
  FDirect:=asdNone;
  with FormMain do
  begin
    case Key of
      //влево
      37:FDirect:=asdLeft;
      //вверх
      38:FDirect:=asdTop;
      //вправо
      39:FDirect:=asdRight;
      //вниз
      40:FDirect:=asdBottom;
    end;
  end;
end;

//обрабатываем движение
procedure TCRActiveScroll.GetKeyMove(Key: Word; Shift: TShiftState);
begin
  with FormMain do
  begin
    case Key of
      //влево
      100,37:MouseWheelHorizontal(false,100);
      //вверх
      104,34:MouseWheelVertical(false,100);
      //вправо
      102,39:MouseWheelHorizontal(true,-100);
      //вниз
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

//обрабатываем
//мышку
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

//проверка лимита
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

//обрабатываем перемещение
//мыши
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

//обрабатываем движение
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

{$REGION 'Общие функции'}

//следующий кадр
procedure NextFrameAnim;
begin
  Application.ProcessMessages;
end;

//следующий кадр для обратных вызовов
procedure NextFrameAnimToCallBack;
begin
  CenteredAnimsImage;
  NextFrameAnim;
  UnCenteredAnimsImage;
end;

//центрируем изображение
procedure CenteredAnimsImage;
begin
  //если информационная панель
  //активна стираем ее
  if FormMain.InfoMainForm.Visible then
    FormMain.InfoMainForm.Visible:=false;
  FormMain.LoadingImageView.Visible:=true;
  FormMain.LoadingImageView.Playing:=true;
  FormMain.LoadingImageView.PlayLoop:=true;
end;

//децентрируем изображение
procedure UnCenteredAnimsImage;
begin
  //децинтровка
  FormMain.MainImage.Center:=false;
  //убираем компонент
  //для отрисовки анимации
  FormMain.LoadingImageView.Visible:=false;
  FormMain.LoadingImageView.Playing:=false;
  FormMain.LoadingImageView.PlayLoop:=false;
end;

//обработка горизонтального
//скролирования мыши
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
      //если правый предел
      //крутим вниз
      if ViewX = MaxHorizontal then
        ViewY:=ViewY-Wheel
      else
        ViewX:=ViewX-Wheel;
    end else
    begin
      //если левый предел
      //крутим вниз
      if ViewX = 0 then
        ViewY:=ViewY-Wheel
      else
        ViewX:=ViewX-Wheel;
    end;
  end;
end;

//обработка вертикального
//скролирования мыши
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
      //если нижний предел
      //вправо
      if ViewY = MaxVertical then
        ViewX:=ViewX-Wheel
      else
        ViewY:=ViewY-Wheel;
    end else
    begin
      //если верхний предел
      //крутим влево
      if ViewY = 0 then
        ViewX:=ViewX-Wheel
      else
        ViewY:=ViewY-Wheel;
    end;
  end;
end;

//проверяем дошел ли
//до пика нижнего угла
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

//проверяем дошел ли
//до пика верхнего угла
function CheckLeftTopRange:Boolean;
begin
  Result:=false;
  with FormMain.MainImage do
    if (ViewX = 0) and (ViewY = 0) then
      Result:=true;
end;

//загружаем курсор
//из файла
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

//меняем режим
//курсора
function ChangeCursor(Mode:Byte):Boolean;
begin
  case Mode of
    //обычный
    0:
      begin
        FormMain.MainImage.Cursor:=crArrow;
        SetCursorPos(Mouse.CursorPos.X,Mouse.CursorPos.Y);
      end;
    //для загрузки
    1:
      begin
        FormMain.MainImage.Cursor:=crHourGlass;
        SetCursorPos(Mouse.CursorPos.X,Mouse.CursorPos.Y);
      end;
  end;
  Result:=true;
end;

//отображаем информационную
//панель на главном окне
procedure ShowToInfoPanel(Mess:String);
begin
  FormMain.InfoMainForm.Caption:=Mess;
  FormMain.InfoMainForm.Visible:=true;
end;

//меняем расположение
//и изображение картинки
//с анимацией для быстрых
//переходов между страницами
procedure PageChangeImageMode(Mode:Byte);
begin
  if not DirObj.NotEmpty then
    Exit;
  case Mode of
    //левый верхний
    0:
      begin
        //если первая позиция
        //то не показываем
        if DirObj.Position = 0 then
          Exit;
        //номер в виде числа
        FormMain.LeftTopLabel.Caption:=IntToStr(DirObj.Position);
        with FormMain.LeftTopImage do
        begin
          //чистим все
          Clear;
          //грузим нужный gif
          MIO.LoadFromFileGIF(PathToProgramDir + 'Data\animtop.gif');
          Playing:=true;
          PlayLoop:=true;
        end;
        with FormMain.PagingAnimPanel do
        begin
          //координируем размеры
          Left:=0;
          Top:=0;
          //показываем юзеру
          Visible:=true;
        end;
      end;
    //правая нижняя
    1:
      begin
        //если последняя позиция
        //то не показываем
        if DirObj.Position = DirObj.BitmapList.Count-1 then
          Exit;
        FormMain.LeftTopLabel.Caption:=IntToStr(DirObj.Position+2);
        with FormMain.LeftTopImage do
        begin
          //чистим все
          Clear;
          //грузим нужный gif
          MIO.LoadFromFileGIF(PathToProgramDir + 'Data\animbottom.gif');
          //показываем юзеру
          Playing:=true;
          PlayLoop:=true;
        end;
        with FormMain.PagingAnimPanel do
        begin
          //координируем размеры
          //координируем размеры
          if FormMain.BorderStyle = bsNone then
          begin
            Left:=FormMain.Width-100;
            Top:=FormMain.Height-130;
          end else
          begin
            Left:=FormMain.Width-108;
            Top:=FormMain.Height-165;
          end;
          //показываем юзеру
          Visible:=true;
        end;
      end;
    //скрываем элементы
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

//загружаем в меню
//историю папок
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
      //создаем подпункт
      MenuItem:=TMenuItem.Create(FormMain);
      //обработчик
      MenuItem.OnClick:=FormMain.ClickToHistoryMenu;
      //берем наименование файла
      MenuItem.Caption:=ExtractFileName(GetName);
      //полный путь к файлу
      //записан в подсказке
      MenuItem.Hint:=GetName;
      //добавляем в меню
      Menu_DirHistory.Add(MenuItem);
    end;
  end;
end;

//загружаем в меню
//историю архивов
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
      //создаем подпункт
      MenuItem:=TMenuItem.Create(FormMain);
      //обработчик
      MenuItem.OnClick:=FormMain.ClickToHistoryMenu;
      //берем наименование файла
      MenuItem.Caption:=ExtractFileName(GetPath);
      //полный путь к файлу
      //записан в подсказке
      MenuItem.Hint:=GetPath;
      //добавляем в меню
      Menu_ArcHistory.Add(MenuItem);
    end;
  end;
end;

{$ENDREGION}

{$REGION 'Класс для изменения размеров изображения'}

//получить ширину
function TCRImageResizer.GetWidth:Integer;
begin
  Result:=FormMain.MainImage.Width;
end;

//получить длину
function TCRImageResizer.GetHeight:Integer;
begin
  Result:=FormMain.MainImage.Height;
end;

//маленькое ли изображение
//т.е. которое вполне целиком
//помещается внутри окна
function TCRImageResizer.IsSmallImage:Boolean;
begin
  if (FBasicImage.Width < GetWidth) and
     (FBasicImage.Height < GetHeight)  then
    Exit(true);
  Result:=false;
end;

//определяем портрет ли это или альбом
function TCRImageResizer.IsPortrait:Boolean;
var
  Diff:integer;
begin
  Result:=false;
  Diff:=FTransfomedImage.Width-FTransfomedImage.Height;
  //выравниваем по ширине
  if Diff > 100 then
    Result:=false;
  //выравниваем по высоте
  if Diff < -100 then
    Result:=true;
end;

//получить базовое имя текущей настройки масштабирования
function TCRImageResizer.GetBasicOptionName:String;
begin
  if IsPortrait then
    Exit('getviewmode')
  else
    Exit('getviewmodevert');
  if DirObj.GetImagesDouble then
    Exit('getviewmodetwopage');
end;

//конструктор
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

//конструктор
constructor TCRImageResizer.Create(Bitmap:TIEBitmap);
begin
  FBasicImage:=TIEBitmap.Create;
  FBasicImage.Assign(Bitmap);
  FProcImage:=TImageEnProc.Create(nil);
end;

//деструктор
destructor TCRImageResizer.Destroy;
begin
  FTransfomedImage.Free;
  FProcImage.Free;
  FBasicImage.Free;
end;

//подгоняем по ширине
procedure TCRImageResizer.ResizeToFitWidth;
begin
  if not IsSmallImage then
    FProcImage.Resample(GetWidth,-1,rfLanczos3);
end;

//подгоняем по высоте
procedure TCRImageResizer.ResizeToFitHeight;
begin
  if not IsSmallImage then
    FProcImage.Resample(-1,GetHeight,rfLanczos3);
end;

//подгоняем по размеру
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

//оригинал
procedure TCRImageResizer.ResizeToOriginal;
begin
  //хехе
  //оставляем все как есть :)
end;

//автоматически определяем
//как изменять размеры
procedure TCRImageResizer.ResizeToAuto;
var
  Diff:integer;
begin
  Diff:=FTransfomedImage.Width-FTransfomedImage.Height;
  //выравниваем по ширине
  if Diff > 100 then
  begin
    ResizeToFitHeight;
    Exit;
  end;
  //выравниваем по высоте
  if Diff < -100 then
  begin
    ResizeToFitWidth;
    Exit;
  end;
  ResizeToFit;
end;

//подогнать под значение
//пользователя
procedure TCRImageResizer.ResizeToUser;
var
  BasicName:String;
begin
  with FormMain.MainImage do
  begin
    //определяем режим
    //который будет базовым
    if IsPortrait then
      BasicName:='getviewmode'
    else
      BasicName:='getviewmodevert';
    if DirObj.GetImagesDouble then
      BasicName:='getviewmodetwopage';
    //определяем режим
    case GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,BasicName+'usermode',0) of
      //проценты
      0:;
      //статичная ширина
      1:FProcImage.Resample
          (
            GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,BasicName+'user',100),
            -1,
            rfLanczos3
          );
      //статичная длина
      2:FProcImage.Resample
          (
            -1,
            GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,BasicName+'user',0),
            rfLanczos3
          );
    end;
  end;
end;

//трансформация изображения
//согласно настройкам
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
    //нет трансформации
    0:;
    //поворот по и
    //против часовой
    1,2:
        begin
          case Rotate of
            1:FProcImage.Rotate(270);//90);
            2:FProcImage.Rotate(180);//180);
            3:FProcImage.Rotate(90);//270);
          end;
        end;
    //зеркальное отображение
    //горизонталь
    3:FProcImage.Flip(fdHorizontal);
    //зеркальное отображение
    //вертикаль
    4:FProcImage.Flip(fdVertical);
  end;
end;

//цветокоррекция изображения
procedure TCRImageResizer.ColorCorrect;
begin
  //накладываем кривые
  if ReadBoolConfig('enabledcurves') then
    MainCurves.ApplyCurvestoIEBitmap(FTransfomedImage);
  //коррекция гаммы
  try
    if ReadBoolConfig('enabledgammacorrection') then
      FProcImage.GammaCorrect(ReadFloatConfig('gammacorrection'),[iecRed,iecGreen,iecBlue]);
  finally
    //мало ли что ;)
  end;
  //контраст
  if ReadIntConfig('imagecontrast') <> 0 then
    FProcImage.Contrast(ReadIntConfig('imagecontrast'));
  //наводим резкость на изображение
  if ReadBoolConfig('sharpenimages') then
    FProcImage.Sharpen();
  //насыщенность
  if ReadBoolConfig('enablesaturation') then
    FProcImage.AdjustSaturation(ReadIntConfig('saturation'));
end;

//выполняем все необходимые обработки
//изображения для вывода его
procedure TCRImageResizer.ChangeImageMode(const Mode:byte = 255);
var
  GetMode:Integer;
  BasicName:String;
begin
  if not DirObj.NotEmpty then
    Exit;
  //поворачиваем или отражаем
  //сначала изображение
  TransformImage;
  //устанавливаем режим
  if Mode <> 255 then
  begin
    //запоминаем изменения
    //для текущего режима отображения
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
  //берем текущий режим
  begin
    if IsPortrait then
      GetMode:=ImageMode
    else
      GetMode:=ImageModeLandscape;
    if DirObj.GetImagesDouble then
      GetMode:=ImageModeTwoPage;
  end;

  ColorCorrect;

  //масштабируем
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
  //запиливаем в текущее изображение
  FormMain.MainImage.LayersClear;
  FormMain.MainImage.IEBitmap.Assign(FTransfomedImage);
  FreeAndNil(FTransfomedImage);
  FormMain.MainImage.Center:=true;
  //перерисовываем изображение
  FormMain.MainImage.Repaint;
end;

{$ENDREGION}

//создаем класс который
//выполняет изменение размеров
//изображения
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

//создаем класс который
//выполняет изменение размеров
//изображения
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
