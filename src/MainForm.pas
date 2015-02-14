{
  drComRead

  Модуль с главной
  формой

  Copyright (c) 2008-2012 Romanus
}
unit MainForm;

interface

uses
  //системные модули 
  Windows, Classes, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Menus, Messages,
  ShellApi,
  ArcReCreate,
  //поддержка графической библиотеки
  ieview, hyieutils, imageenview, iemview;//,
  //IMouse - сделать поддержку IntelliMouse;

const
  WM_XBUTTONDOWN    =   $020B; // сообщение о нажатии X button
  WM_XBUTTONUP      =   $020C;   // сообщение об отпускании X button
  MK_XBUTTON1       =   $20;      // идентификатор клавиши "назад" в LoWord(WParam)
  MK_XBUTTON2       =   $40;      // идентификатор клавиши "вперёд" в LoWord(WParam)
  XBUTTON1          =   $1;          // код клавиши "назад" в HiWord(WParam)
  XBUTTON2          =   $2;          // код клавиши "вперёд" в HiWord(WParam)

type
  TFormMain = class(TForm)
    PopupMenu: TPopupMenu;
    Menu_OpenDir: TMenuItem;
    Menu_OpenFile: TMenuItem;
    N2: TMenuItem;
    Menu_CloseCurrent: TMenuItem;
    Menu_SinglePreview: TMenuItem;
    Menu_Minimize: TMenuItem;
    Menu_NextImage: TMenuItem;
    Menu_PrevImage: TMenuItem;
    Menu_Navigate: TMenuItem;
    Menu_StartImage: TMenuItem;
    Menu_EndImage: TMenuItem;
    Menu_WinControl: TMenuItem;
    Menu_FullScreen: TMenuItem;
    Menu_ImageControl: TMenuItem;
    Menu_Zoom: TMenuItem;
    Menu_Stretch: TMenuItem;
    Menu_Original: TMenuItem;
    N3: TMenuItem;
    Menu_About: TMenuItem;
    Menu_Exit: TMenuItem;
    N1: TMenuItem;
    Menu_ListArchive: TMenuItem;
    ASTimer: TTimer;
    Menu_FitHeight: TMenuItem;
    Menu_Navigator: TMenuItem;
    Menu_NextArchive: TMenuItem;
    Menu_PrevArchive: TMenuItem;
    Menu_FileInfo: TMenuItem;
    Menu_ArchiveList: TMenuItem;
    Menu_SortFiles: TMenuItem;
    Menu_FileManaged: TMenuItem;
    Menu_Mouser: TMenuItem;
    Menu_StartArchive: TMenuItem;
    Menu_EndArchive: TMenuItem;
    N4: TMenuItem;
    Menu_Rotate80CW: TMenuItem;
    Menu_Rotate80CCW: TMenuItem;
    Menu_FlipHorizontal: TMenuItem;
    Menu_FlipVertical: TMenuItem;
    Menu_Rotate: TMenuItem;
    Menu_Rotate80CWAll: TMenuItem;
    Menu_Rotate80CCWAll: TMenuItem;
    Menu_Flip: TMenuItem;
    Menu_FlipHorizontalAll: TMenuItem;
    Menu_FlipVerticalAll: TMenuItem;
    N5: TMenuItem;
    Menu_SaveToFile: TMenuItem;
    Menu_SaveToBuffer: TMenuItem;
    LeftTopLabel: TLabel;
    MainImage: TImageEnView;
    InfoMainForm: TLabel;
    NumberNextImage: TLabel;
    LoadingImageView: TImageEnMView;
    LeftTopImage: TImageEnMView;
    PagingAnimPanel: TPanel;
    CurvesPopUp: TPopupMenu;
    Menu_SaveCurves: TMenuItem;
    Menu_OpenCurves: TMenuItem;
    Menu_ApplyCurves: TMenuItem;
    Menu_ResetCurves: TMenuItem;
    Menu_DirHistory: TMenuItem;
    Menu_ArcHistory: TMenuItem;
    N6: TMenuItem;
    Menu_Addbookmark: TMenuItem;
    Menu_Bookmarks: TMenuItem;
    Menu_HistoryDialog: TMenuItem;
    Menu_NextBookmark: TMenuItem;
    Menu_PrevBookmark: TMenuItem;
    N7: TMenuItem;
    Menu_CreateRAR: TMenuItem;
    Menu_CreateZip: TMenuItem;
    Menu_Create7Zip: TMenuItem;
    Menu_CreateArchive: TMenuItem;
    Menu_RecreateArchive: TMenuItem;
    Menu_Recreateandrewrite: TMenuItem;
    Menu_Recreateandsaveas: TMenuItem;
    Menu_CreatePDF: TMenuItem;
    Menu_CreateTIFF: TMenuItem;
    Menu_CreateGIF: TMenuItem;
    Menu_CloseAll: TMenuItem;
    Menu_OpenDefaultCurves: TMenuItem;
    Menu_ClearBookmarks: TMenuItem;
    Menu_CheckUpdates: TMenuItem;
    Menu_Addons: TMenuItem;
    MenuSeparator50: TMenuItem;
    Menu_AddonsManage: TMenuItem;
    Menu_Documentation: TMenuItem;
    procedure FormClick(Sender: TObject);
    procedure Menu_ArchiveListClick(Sender: TObject);
    procedure Menu_FitAutoClick(Sender: TObject);
    procedure Menu_PrevArchiveClick(Sender: TObject);
    procedure Menu_NextArchiveClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Menu_SinglePreviewClick(Sender: TObject);
    procedure Menu_FitHeightClick(Sender: TObject);
    procedure MainImageDblClick(Sender: TObject);
    procedure ASTimerTimer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Menu_FileInfoClick(Sender: TObject);
    procedure Menu_CloseCurrentClick(Sender: TObject);
    procedure Menu_ZoomClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Menu_StartImageClick(Sender: TObject);
    procedure Menu_EndImageClick(Sender: TObject);
    procedure Menu_OriginalClick(Sender: TObject);
    procedure Menu_MinimizeClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Menu_AboutClick(Sender: TObject);
    procedure Menu_FullScreenClick(Sender: TObject);
    procedure Menu_StretchClick(Sender: TObject);
    procedure Menu_PrevImageClick(Sender: TObject);
    procedure Menu_NextImageClick(Sender: TObject);
    procedure Menu_OpenDirClick(Sender: TObject);
    procedure Menu_ExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Menu_OpenFileClick(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure ListArchiveClick(Sender:TObject);
    procedure Menu_NavigatorClick(Sender: TObject);
    procedure Menu_SortFilesClick(Sender: TObject);
    procedure Timer_ScrollAction(Sender: TObject);
    procedure MainImageResize(Sender: TObject);
    procedure Menu_MouserClick(Sender: TObject);
    procedure Menu_StartArchiveClick(Sender: TObject);
    procedure Menu_EndArchiveClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure LeftTopImageClick(Sender: TObject);
    procedure Menu_Rotate80CWClick(Sender: TObject);
    procedure Menu_Rotate80CCWClick(Sender: TObject);
    procedure Menu_Rotate80CWAllClick(Sender: TObject);
    procedure Menu_Rotate80CCWAllClick(Sender: TObject);
    procedure Menu_FlipHorizontalClick(Sender: TObject);
    procedure Menu_FlipVerticalClick(Sender: TObject);
    procedure Menu_FlipHorizontalAllClick(Sender: TObject);
    procedure Menu_FlipVerticalAllClick(Sender: TObject);
    procedure Menu_SaveToFileClick(Sender: TObject);
    procedure Menu_SaveToBufferClick(Sender: TObject);
    procedure MainImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MainImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MainImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure Menu_SaveCurvesClick(Sender: TObject);
    procedure Menu_ApplyCurvesClick(Sender: TObject);
    procedure Menu_OpenCurvesClick(Sender: TObject);
    procedure Menu_ResetCurvesClick(Sender: TObject);
    procedure Menu_SettingsClick(Sender: TObject);
    procedure Menu_CurvesSettingClick(Sender: TObject);
    procedure Menu_AddbookmarkClick(Sender: TObject);
    procedure Menu_HistoryDialogClick(Sender: TObject);
    procedure Menu_CreateRARClick(Sender: TObject);
    procedure Menu_CreateZipClick(Sender: TObject);
    procedure Menu_Create7ZipClick(Sender: TObject);
    procedure Menu_CreatePDFClick(Sender: TObject);
    procedure Menu_CreateTIFFClick(Sender: TObject);
    procedure Menu_CreateGIFClick(Sender: TObject);
    procedure Menu_RecreateandsaveasClick(Sender: TObject);
    procedure Menu_RecreateandrewriteClick(Sender: TObject);
    procedure Menu_CloseAllClick(Sender: TObject);
    procedure Menu_OpenDefaultCurvesClick(Sender: TObject);
    procedure Menu_ClearBookmarksClick(Sender: TObject);
    procedure Menu_NextBookmarkClick(Sender: TObject);
    procedure Menu_PrevBookmarkClick(Sender: TObject);
    procedure Menu_CheckUpdatesClick(Sender: TObject);
    procedure Menu_DocumentationClick(Sender: TObject);
    procedure WMDropFiles(var Msg: TMessage); message wm_DropFiles;
    procedure PopupMenuPopup(Sender: TObject);
  private
    //признак загрузки изображения
    FLoadingImage:Integer;
    //обычный обработчик основного изображения
    OldMainImageWindProc: TWndMethod;
  public
    //обрабатываем специальные кнопки мыши
    procedure WMXButtonDown(var Message: TWMMouse); message WM_XBUTTONDOWN;
    //переопределяем виндовую обработку
    procedure NewMainImageWindProc(var Message: TMessage);
    //закрываем список или текущий файл
    procedure CloseCurrentList(const AllList:Boolean = true);
    //загружаем меню
    //архивов
    procedure LoadArchiveMenu;
    //навигация по изображениям
    function LoadNavigateBitmap(Mode:byte;const Page:integer = -1):Boolean;
    //меняем кривые на лету
    procedure ChangeCurvesBitmap(Sender:TObject);
    //кликаем по пунктам истории
    procedure ClickToHistoryMenu(Sender: TObject);
    //переходим на закладку
    function GoToBookmark:Boolean;
    //открываем каталог
    procedure OpenDirFunc(StrDir:String);
    //событие перепаковки
    procedure RepackCallBack(GetProcess:TArcReCreateProcess);
    //перепаковываем текущий архив
    function RepackGetArchive(SaveCustom:Boolean):Boolean;
    //загружаем закладки
    //из базы в память
    procedure LoadBookmarksAtBase;
  end;

var
  FormMain: TFormMain;
  XSource,YSource:Integer;
  //зажата ли левая
  //кнопка мыши
  LeftButtonPressed:Boolean;
  //зажата ли правая
  //кнопка мыши
  RightButtonPressed:Boolean;
  //не отображать основное меню
  PopupMenuDontView:Boolean = false;
  //информация для вывода
  //текущая страница
  GetPageString:string = 'Current: ';
  //переходимая страница
  NewPageString:string = ' Going to: ';
  //количество страниц
  CountPageString:string = ' Count: ';
  //счетчик для блокировки
  //скролирования
  CounterBlockScrolling:Integer = 0;
  //файлы пришедшие по Drag'n'Drop
  DragNDropFiles:TStrings;

procedure LoadToArchiveNumber(Index:integer;const NavigateMode:Integer = 0);
procedure LoadToArchiveString(FileName:String;const NavigateMode:Integer = 0);

implementation

{$R *.dfm}

uses
  //системные модули
  SysUtils, IniFiles,Graphics,
  RGBCurvesdiagrammer,
  //модули программы
  CRGlobal, CRDir, CRImageVisual, CRFastActions,
  CRFile, CRLog, CRPHardwareInfo,
  DLLHeaders,
  //общие библиотеки
  ArcCreate, ArcFunc,
  FuncExports,
  CRMenuHelper, CRPlugins;

{$REGION 'Общие функции'}

//загружаем необходимые
//для программы данные
procedure LoadProgramData;
var
  ExpStr:String;
begin
  SetCurrentDir(PathToProgramDir);
  //загружаем файл конфигурации
  LoadConfigData('config.cr');
  //загружаем анимированный gif
  FormMain.LoadingImageView.MIO.LoadFromFileGIF('data\loading.gif');
  if ReadBoolConfig('enablehistory') then
  begin
    EnableHistory:=InitDataBase;
    if EnableHistory then
    begin
      //заполняем меню последними
      //записями
      LoadMenuToDirHistory;
      LoadMenuToArcHistory;
    end;
  end;
  //текст приветсвия
  DefaultMessage:=GlobalLangData.ReadString('MESSAGES','programtext','');
  DefaultMessage:=DefaultMessage+' '+PROGRAM_VERSION + #13#10;
  ExpStr:=GlobalLangData.ReadString('MESSAGES','welcometext','');
  DefaultMessage:=DefaultMessage+copy(ExpStr,0,Pos(';',ExpStr)-1)+#13#10;
  DefaultMessage:=DefaultMessage+copy(ExpStr,Pos(';',ExpStr)+1,Length(ExpStr));
  FormMain.InfoMainForm.Caption:=DefaultMessage;
  FormMain.InfoMainForm.Visible:=true;
  //объект дял работы
  //с кривыми
  MainCurves:=TRGBCurves.Create(nil);
  MainCurves.Visible:=false;
  MainCurves.Left:=0;
  MainCurves.Top:=0;
  MainCurves.Width:=200;
  MainCurves.Height:=200;
  MainCurves.Parent:=FormMain;
  MainCurves.PopupMenu:=FormMain.CurvesPopUp;
  //если файл с информацией
  //о кривых есть то
  //загружаем данные из него
  if FileExists(PathToProgramDir + 'curves.fcc') then
  begin
    MainCurves.ImportCurvesFromFile(PathToProgramDir + 'curves.fcc');
  end;
  MainCurves.OnChangeCurve:=FormMain.ChangeCurvesBitmap;
  //выставляем полный экран
  if FullScreenOpened then
    FormMain.Menu_FullScreenClick(nil);
end;

{$ENDREGION}

{$REGION 'TFormMain'}

{$REGION 'Обще оконные методы :)'}

procedure TFormMain.ASTimerTimer(Sender: TObject);
begin
  if (FormStyle in [fsStayOnTop]) then
  begin
    //если нажата левая кнопка
    //мыши то ничего не делаем
    if LeftButtonPressed then
      Exit;
    //если активно не
    //основное окно
    //то не скролируем
    if not Active then
      Exit;
    //если открыто закладка для
    //перехода
    if PagingAnimPanel.Visible then
      Exit;
    //если панель быстрых действий
    //видимо то не скролируем
    if FastActions.Visible then
      Exit;
    //обрабатываем позицию
    ActiveScroll.GetMouseStep
                              (
                                Mouse.CursorPos.X,
                                Mouse.CursorPos.Y
                              );
    ActiveScroll.MoveStep(true);
  end;
end;

procedure TFormMain.Timer_ScrollAction(Sender: TObject);
begin
  //ToDo:добавить визуальный
  //стоппер для отображения
  PrintToLog('TFormMain.Timer_ScrollAction.OnTimer');
  NumberNextImage.Visible:=false;
  FormMain.NumberNextImage.Tag:=0;
  FreeAndNil(ASSleepTimer);
end;

procedure TFormMain.FormClick(Sender: TObject);
begin
  PrintToLog('TFormMain.FormClick call to CloseNavigatorWindow');
  DLLHeaders.CloseNavigatorWindow;
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  PrintToLog('start close program event');
  DragAcceptFiles(Handle, false);
  FreeAndNil(DragNDropFiles);
  if BitmapListIsLoading then
  begin
    Action:=caNone;
    Exit;
  end;
  ASTimer.Enabled:=false;
  //если установлена настройка
  //то ставим закладку
  //в текущий архив на текущую
  //страницу
  if ReadBoolConfig('addbookmark_closeprogram') then
  begin
    PrintToLog('save bookmark at current archive');
    Menu_AddbookmarkClick(nil);
  end;
  //вычищаем все данные
  //если таковые имеются
  PrintToLog('unload dirobj data');
  DirObj.ClearData(true);
  //чистим навигатор
  PrintToLog('unload navigator dialog');
  DLLHeaders.CloseNavigatorWindow;
  //чистим предварительный просмотр
  PrintToLog('unload preview window list');
  DLLHeaders.ClearBitmapList;
  //подключенные плагины
  PrintToLog('unload plugins');
  Addons.Free;
  //чистим быстрые действия
  PrintToLog('unload fast actions');
  DeInitFastActions;
  //очищаем изображение
  PrintToLog('unload main image');
  MainImage.Bitmap.FreeImage;
  //очищаем сам объект
  MainImage.Free;
  //чистим мультиязыковой объект
  PrintToLog('unload language data');
  GlobalLangData.Free;
  //чистим настройки
  PrintToLog('unload config data');
  GlobalConfigData.UpdateFile;
  GlobalConfigData.Free;
  //помошники меню
  PrintToLog('unload menu helpers');
  DeInitMenuHelpers;
end;

procedure TFormMain.FormContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
  if PopupMenuDontView then
  begin
    PopupMenuDontView:=false;
    Handled:=true;
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  DefFileLang:String;
begin
  //файл с основными
  //данными о конфигурации
  GlobalConfigData:=TMemIniFile.Create(PathToProgramDir+'config.cr');
  //получаем имя файла
  //с языковыми данными

  DefFileLang:=GlobalConfigData.ReadString(CONFIG_MAINSECTION,'defaultlng','');
  try
    //загружаем его
    GlobalLangData:=TMemIniFile.Create(PathToProgramDir+DefFileLang);
  except
    //если не удалось загрузить
    //файл то падаем из прогаммы
    ShowMessage('Not load language file : ' + DefFileLang);
    Close;
  end;
  DefFileLang:='';
  //включаем ли режим трэйса
  //EnableTrace:=GlobalConfigData.ReadBool(CONFIG_MAINSECTION,'globaltrace',false);
  //если включен создаем объект лога
  //стартовое сообщение лога
  //стандартный курсор
  LoadAniCursor(PathToProgramDir+'data\standcur.cur',crArrow);
  //загрузочный курсор
  LoadAniCursor(PathToProgramDir+'data\loadcur.cur',crHourGlass);
  //пытаемся поменять
  //на загруженный
  ChangeCursor(0);
  //грузим языковые данные
  //в меню
  PrintToLog('load to language data');
  LoadToPopUpMenu;
  //загружаем данные
  //программы
  PrintToLog('load to program data');
  LoadProgramData;
  //помошники меню
  PrintToLog('load to menu helpers');
  InitMenuHelpers;
  //объект для работы
  //со списками файлов
  PrintToLog('load to main dir class');
  DirObj:=TCRDir.Create;
  //объект для работы
  //с активным скролированием
  PrintToLog('load to active scroll class');
  ActiveScroll:=TCRActiveScroll.Create;

  //если нужно рисовать фон
  PrintToLog('background changed at config file');
  if GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,'modebackground',0) = 2 then
  begin
    MainImage.WallPaper.LoadFromFile(
      GlobalConfigData.ReadString(CONFIG_MAINSECTION,'backgroundtile',ExtractFilePath(ParamStr(0))+'\data\imagetile.jpg')
    );
  end;
  //убираем скролирование
  //из прокрутки колесика мыши
  MainImage.MouseWheelParams.Action:=iemwNone;
  //инициализируем быстрые действия
  PrintToLog('load to fast actions panel');
  InitFastActions;
  //если включена
  //проверка новых версий
  if ReadBoolConfig('newversionchecked') then
  begin
    PrintToLog('running checked new version program');
    CheckNewVersion;
  end;

  //обновляем меню
  PrintToLog('update menu helpers');
  CRMenuHelper.UpdateMenu;

  PrintToLog('plugins initialize load...');

  //подключаем плагины
  Addons:=TCRPlugins.Create;
  Addons.LoadSettings;

  PrintToLog('plugins initialize completed');

  FLoadingImage:=0;

  //поддержка технологии Drag'n'Drop
  DragAcceptFiles(Handle, True);

  //поддержка дополнительных клавиш
  //мыши (которые вперед и назад)
  OldMainImageWindProc:=MainImage.WindowProc;
  MainImage.WindowProc:=NewMainImageWindProc;

  PrintToLog('main form initialization finished');
end;

//открытие окна О Программе
procedure TFormMain.Menu_AboutClick(Sender: TObject);
begin
  PrintToLog('TFormMain.Menu_AboutClick call to ShowAboutDialog');
  ShowAboutDialog(Self.Left,Self.Top,PCHar(PROGRAM_VERSION));
end;

//завершение приложения
procedure TFormMain.Menu_ExitClick(Sender: TObject);
begin
  PrintToLog('TFormMain.Menu_ExitClick call to self.Close');
  //убираем за собой
  //и завершаем приложение
  FormMain.Close;
end;

{$ENDREGION}

{$REGION 'Обработка ввода'}

//обрабатываем специальные кнопки мыши
procedure TFormMain.WMXButtonDown(var Message: TWMMouse);
begin
  if Message.Keys and (MK_XBUTTON1 or MK_XBUTTON2) <> 0 then
  begin
    case HiWord(Message.Keys) of
      XBUTTON1 : Menu_PrevImageClick(nil);
      XBUTTON2 : Menu_NextImageClick(nil);
    end;
    Message.Result := 1;
  end;
end;

//переопределяем виндовую обработку
procedure TFormMain.NewMainImageWindProc(var Message: TMessage);
begin
  // все мессаги, не касающиеся Х кнопок, переправляем в дефолтный обработчик
  // здесь, конечно, надо перечислять все X button сообщения, на которые хочется реагировать
  if Message.Msg <> WM_XBUTTONDOWN then
  begin
    OldMainImageWindProc(Message);
    Exit;
  end;

  if Message.WParam and (MK_XBUTTON1 or MK_XBUTTON2) <> 0 then
  begin
    case HiWord(Message.WParam) of
      XBUTTON1 : Menu_PrevImageClick(nil);
      XBUTTON2 : Menu_NextImageClick(nil);
    end;
    Message.Result := 1;
  end;

end;

procedure TFormMain.Menu_SettingsClick(Sender: TObject);
var
  Key:Word;
begin
  Key:=119;
  Self.FormKeyDown(nil,Key,[]);
end;

procedure TFormMain.Menu_CurvesSettingClick(Sender: TObject);
var
  Key:Word;
begin
  Key:=191;
  Self.FormKeyDown(nil,Key,[]);
end;

procedure TFormMain.Menu_DocumentationClick(Sender: TObject);
begin
  FuncExports.ShowDocumentation(PWideChar('overview'));
end;

//получение списка файлов
//через стандартное перетаскивание
procedure TFormMain.WMDropFiles(var Msg: TMessage);
var
  Filename:PChar;
  //FileStr:String;
  Amount,Iterator:Integer;
  Size:Integer;
begin
  DragNDropFiles:=TStringList.Create;
  Amount := DragQueryFile(Msg.WParam, $FFFFFFFF, Filename, 255);
  for Iterator := 0 to (Amount - 1) do
  begin
    Size:=DragQueryFile(Msg.WParam,Iterator,nil,0) + 1;
    Filename:=StrAlloc(Size);
    DragQueryFile(Msg.WParam,Iterator,Filename,size);
    DragNDropFiles.Add(StrPas(Filename));
    StrDispose(Filename);
  end;
  //передать в открытие
  Menu_OpenFileClick(nil);
  //чистим за собой
  if DragNDropFiles <> nil then
    FreeAndNil(DragNDropFiles);
  //подсветка окна
  //FlashWindow(FormMain.Handle,true);
end;

//активные клавиши формы
procedure TFormMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    //F8 - открываем диалог настроек
    119:
      begin
        if ShowConfigFormDialog(PWideChar('')) then
        begin
          LoadConfigDataFromMemory;
          //если открыто изображение
          //то обновляем его
          if DirObj.NotEmpty then
            LoadNavigateBitmap(4,DirObj.Position)
        end;
      end;
    // / - в num клавиатуре
    111,191:
      begin
        if DirObj.NotEmpty then
        begin
          if MainCurves.Visible then
            MainCurves.Visible:=false
          else begin
            if ReadBoolConfig('enabledcurves') then
              MainCurves.Visible:=true;
          end;
        end;
      end;
    //F2 - основное меню
    113:Self.PopupMenu.Popup(Self.Left,Self.Top);
    //F3 - быстрые действия
    114:
      begin
        FastActions.Panel.Visible:=true;
        SetCursorPos(
            (Self.Left+FastActions.Panel.Left)+20,
            (Self.Top+FastActions.Panel.Top)+40
          )
      end;
    //F6 - навигатор
    117:Menu_NavigatorClick(nil);
    //*, 0 или ) - включение отключение
    //активной прокрутки
    106,48:
      begin
        if ActiveScroll.Active then
        begin
          ActiveScroll.DeActivate;
        end else
        begin
          ActiveScroll.Activate;
        end;
      end;
    //PageUp
    33:Menu_PrevImageClick(nil);
    //PageDown
    34:Menu_NextImageClick(nil);
    //Home
    36:Menu_StartImageClick(nil);
    //End
    35:Menu_EndImageClick(nil);
    //Списки действий
    //для вызовов быстрых действий
    //1
    49:FastActions.ExecuteActionByIndex(0);
    //2
    50:FastActions.ExecuteActionByIndex(1);
    //3
    51:FastActions.ExecuteActionByIndex(2);
    //4
    52:FastActions.ExecuteActionByIndex(3);
    //5
    53:FastActions.ExecuteActionByIndex(4);
    //6
    54:FastActions.ExecuteActionByIndex(5);
    //7
    55:FastActions.ExecuteActionByIndex(6);
    //8
    56:FastActions.ExecuteActionByIndex(7);
    //9
    57:FastActions.ExecuteActionByIndex(8);
    //Esc
    27:
      begin
        //скрытие быстрых действий
        if FastActions.Panel.Visible and DirObj.NotEmpty then
          FastActions.Hide;
      end;
  end;
  //активное перемещение
  if ActiveScroll.Active then
    ActiveScroll.GetKeyStep(Key,Shift);
  //имитируем клавишами
  //активное перемещение
  ActiveScroll.GetKeyMove(Key,Shift);
end;

function MainFuncWheel(GLimit:Boolean):Boolean;
var
  RightBottom,
  TopLeft:Boolean;
  NewPosition:Integer;
  AddStr:String;
  ArcStr:String;
  VisibleArchive:Boolean;
begin
  Result:=false;
  NewPosition:=0;
  VisibleArchive:=false;
  try
    RightBottom:=CheckRightBottomRange;
    TopLeft:=CheckLeftTopRange;
    //если достигли угла
    //то включаем отображение
    //информации о следующем
    //изображении
    if RightBottom or TopLeft then
    begin
      if (DirObj.Position = 0) and TopLeft and not RightBottom then
      begin
        if (DirObj.Archives.Count > 1) and (DirObj.ArchivesPos > 0) then
          VisibleArchive:=true
        else
          Exit;
      end;
      if (DirObj.Position = DirObj.BitmapList.Count-1) and RightBottom then
      begin
        if (DirObj.Archives.Count > 1) and (DirObj.ArchivesPos < DirObj.Archives.Count-1) then
          VisibleArchive:=true
        else
          Exit;
      end;
      if FormMain.NumberNextImage.Visible then
      begin
        if FormMain.NumberNextImage.Tag < 3 then
        begin
          FormMain.NumberNextImage.Tag:=FormMain.NumberNextImage.Tag+1;
          Exit;
        end;
        //правый нижний уровень
        if RightBottom and GLimit then
        begin
          FormMain.Menu_NextImageClick(nil);
          FormMain.NumberNextImage.Visible:=false;
        end;
        //левый верхний уровень
        if TopLeft and not GLimit then
        begin
          FormMain.Menu_PrevImageClick(nil);
          FormMain.NumberNextImage.Visible:=false;
        end;
        Result:=true;
        Exit;
      end;
      //если поле не отображено
      //мы проверяем позицию
      //чистим таймер и создаем его заново
      if not FormMain.NumberNextImage.Visible then
      begin
        with FormMain.NumberNextImage do
        begin
          Visible:=true;
          Tag:=0;
          if TopLeft and not GLimit then
          begin
            Align:=alTop;
            if DirObj.GetImagesDouble and (DirObj.Position > 1) then
              NewPosition:=DirObj.Position-2
            else
              NewPosition:=DirObj.Position-1;
            if VisibleArchive then
              ArcStr:=ExtractFileName(DirObj.Archives.Strings[DirObj.ArchivesPos-1]);
          end;
          if RightBottom and GLimit then
          begin
            Align:=alBottom;
            if DirObj.GetImagesDouble then
              NewPosition:=DirObj.Position+2
            else
              NewPosition:=DirObj.Position+1;
            if VisibleArchive then
              ArcStr:=ExtractFileName(DirObj.Archives.Strings[DirObj.ArchivesPos+1]);
          end;
          if DirObj.GetImagesDouble then
            AddStr:=','+IntToStr(DirObj.Position+2)+' ';
          if VisibleArchive then
            Caption:=ReadLang('MAIN','nextarchiveinfo')+ArcStr
          else
            Caption:=GetPageString+IntToStr(DirObj.Position+1)+AddStr+' '+
                     NewPageString+IntToStr(NewPosition+1)+' '+
                     CountPageString+IntToStr(DirObj.BitmapList.Count)+' ';
        end;
        if Assigned(ASSleepTimer) then
        begin
          try
            ASSleepTimer.Enabled:=false;
            FreeAndNil(ASSleepTimer);
          except
            //для перестраховки
          end;
        end;
        ASSleepTimer:=TTimer.Create(nil);
        ASSleepTimer.Interval:=2500;
        ASSleepTimer.OnTimer:=FormMain.Timer_ScrollAction;
        Exit;
      end;
    end;
  except
    //ShowMEssage('Yaha');
  end;
end;

//обработка колесика мыши
procedure TFormMain.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var
  GScroll,
  GLimit:boolean;
begin
  //только если что-то есть в списке
  if not DirObj.NotEmpty then
    Exit;
  //и не отображено иконка
  //прогресса загрузки архива
  if FormMain.LoadingImageView.Visible then
  begin
    //если таковое есть
    //то включаем блокировку
    //скролирования
    CounterBlockScrolling:=5;
    Exit;
  end;
  PopupMenuDontView:=true;
  //определяем направление
  //прокрутки
  if WheelDelta < 0 then
    GLimit:=true
  else
    GLimit:=false;
  //определяем режим
  //прокрутки
  if RightButtonPressed then
    GScroll:=true
  else
    GScroll:=false;
  if CounterBlockScrolling > 0 then
  begin
    Dec(CounterBlockScrolling);
    Exit;
  end;
  if FLoadingImage > 0 then
  begin
    Dec(FLoadingImage);
    Exit;
  end;
  if not NumberNextImage.Visible then
    if GScroll then
      MouseWheelHorizontal(GLimit,WheelDelta)
    else
      MouseWheelVertical(GLimit,WheelDelta);
  MainFuncWheel(GLimit);
end;

//обработка двойного нажатия
procedure TFormMain.MainImageDblClick(Sender: TObject);
var
  iCenter:integer;
begin
  iCenter:=Self.ClientHeight;
  if odd(iCenter) then
    iCenter:=iCenter+1;
  iCenter:=iCenter div 2;
  if YSource < iCenter then
    Self.Menu_PrevImageClick(nil)
  else
    Self.Menu_NextImageClick(nil);
end;

//обработка перемещения мыши
procedure TFormMain.MainImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ssLeft in Shift then
    LeftButtonPressed:=true;
  if ssRight in Shift then
    RightButtonPressed:=true;
  YSource:=Y;
  //отображаем навигатор
  //если нажали на среднюю кнопку
  if ssMiddle in Shift then
    DLLHeaders.ShowNavigatorDialog;
end;

procedure TFormMain.MainImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  ExpX:Integer;
  ExpC:Integer;
begin
  if not (ssLeft in Shift) then
    LeftButtonPressed:=false;
  //если окно не активно
  //то не выводим ничего
  if not Self.Active then
    Exit;
  //выводим закладки на
  //следующую и предыдущую
  //страницу в списке
  if not LeftButtonPressed then
  begin
    if (X < 70) and (Y < 70) then
    begin
      PageChangeImageMode(0);
      Exit;
    end;
    if (X > Self.Width-78) and (Y > Self.Height-103) then
    begin
      PageChangeImageMode(1);
      Exit;
    end;
    PageChangeImageMode(2);
  end;
  //выводим или скрываем тулбар
  if not LeftButtonPressed and DirObj.NotEmpty then
  begin
    ExpX:=FastActions.Panel.Width div 2;
    ExpC:=Self.Width div 2;
    if (Y > 38) and not FastActions.AddPanel.Visible then
      FastActions.Hide;
    if Y < 38 then
      if (X > ExpC-ExpX) and (X < ExpC+ExpX) then
        FastActions.Show;
  end;
end;

procedure TFormMain.MainImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ssLeft in Shift then
    LeftButtonPressed:=false
  else begin
    if RightButtonPressed then
    begin
      RightButtonPressed:=false;
    end;
  end;
  PopupMenuDontView:=false;
end;

procedure TFormMain.MainImageResize(Sender: TObject);
begin
  //
end;

{$ENDREGION}

{$REGION 'Управление окном'}

//полноэкранный просмотр
procedure TFormMain.Menu_FullScreenClick(Sender: TObject);
begin
  if FormMain.BorderStyle = bsNone then
  begin
    FormMain.WindowState:=wsNormal;
    FormMain.BorderStyle:=bsSizeable;
    FormMain.FormStyle:=fsNormal;
  end else
  begin
    FormMain.BorderStyle:=bsNone;
    FormMain.FormStyle:=fsStayOnTop;
    FormMain.WindowState:=wsMaximized;
  end;
end;

//минимизация приложения
procedure TFormMain.Menu_MinimizeClick(Sender: TObject);
begin
  Application.Minimize;
end;

//диалог для быстрого запуска
//команд меню
procedure TFormMain.Menu_MouserClick(Sender: TObject);
begin
  //
end;

//единичный прокрутчик
procedure TFormMain.Menu_SinglePreviewClick(Sender: TObject);
var
  numpage:integer;
begin
  //выводим диалог и возможно переходим
  //куда-то
  if not DirObj.NotEmpty then
    Exit;
  numpage:=DllHeaders.ShowPrevOneDialog(DirObj.Position);
  if numpage > -1 then
    Self.LoadNavigateBitmap(4,numpage);
end;

procedure TFormMain.FormPaint(Sender: TObject);
var
  CLParams:TStrings;
begin
  if not StartParameters then
    Exit;
  //читаем параметры командной строки
  CLParams:=FormatCommandLine;
  if CLParams.Count > 0 then
  begin
    DirObj.LoadFromStrings(CLParams);
    if EnableHistory and GoToBookmark then
    else
      Self.LoadNavigateBitmap(0);
    //обновляем меню
    UpdateMenu;
  end;
  CLParams.Free;
  if StartMinimize then
    Application.Minimize;
  if StartActiveScroll then
    ActiveScroll.Activate;
  StartParameters:=false;
end;

procedure TFormMain.FormResize(Sender: TObject);
begin
  //убираем пэйджинг
  PagingAnimPanel.Visible:=false;
  //меняем размеры информационной
  //и различных элементов формы
  InfoMainForm.Width:=FormMain.ClientWidth;
  InfoMainForm.Left:=0;
  InfoMainForm.Top:=(FormMain.Height div 2)-(InfoMainForm.Height*2);
  LoadingImageView.Left:=(FormMain.Width div 2)-(LoadingImageView.Width div 2);
  LoadingImageView.Top:=(FormMain.Height div 2)-(LoadingImageView.Height);

  //если тулбар отображается
  //то меняем его расположение
  if Assigned(FastActions) then
  begin
    if FastActions.Visible then
    begin
      FastActions.Show;
      FastActions.AddPanel.Visible:=false;
    end;
    //корректируем режим изображения
    //ChangeModeImage(255);
    if Assigned(ImageResizer) then
      ImageResizer.ChangeImageMode;
  end;
end;

procedure TFormMain.Menu_NavigatorClick(Sender: TObject);
begin
  //отображаем навигатор
  DLLHeaders.ShowNavigatorDialog;
end;

procedure TFormMain.FormActivate(Sender: TObject);
begin
  //закрываем диалог
  //навигатора при
  //активации окна
  DllHeaders.CloseNavigatorWindow;
end;

procedure TFormMain.Menu_CheckUpdatesClick(Sender: TObject);
begin
  CheckNewVersion(true);
end;


{$ENDREGION}

{$REGION 'Работа с файлами'}

procedure TFormMain.CloseCurrentList(const AllList:Boolean = true);
begin
  if BitmapListIsLoading then
    Exit;
  //если настройка включена
  //то пытаемся сохранить закладку
  //для текущего архива
  if ReadBoolConfig('addbookmark_close') then
    Menu_AddbookmarkClick(nil);
  //цвет по умолчанию
  MainImage.Background:=clBtnFace;
  //очищаем изображений
  MainImage.LayersClear;
  MainImage.Repaint;
  //очищаем данные
  DirObj.ClearData(AllList);
  //чистим список в
  //диалоге предпросмотра
  DLLHeaders.ClearBitmapList;
  //скрываем кривые
  MainCurves.Visible:=false;
  //очищаем меню
  LoadArchiveMenu;
end;

//закрываем текущий список просмотра
//и лист архивов
procedure TFormMain.Menu_CloseAllClick(Sender: TObject);
begin
  CloseCurrentList;
end;

procedure TFormMain.Menu_CloseCurrentClick(Sender: TObject);
begin
  CloseCurrentList(false);
end;

function TFormMain.GoToBookmark:Boolean;
var
  PageBookmark:Integer;
begin
  //если настройка перехода
  //на последнюю закладку
  //включена то переходим
  Result:=false;
  if ReadBoolConfig('goto_bookmark_last') then
  begin
    if DirObj.ArchiveOpened and (DirObj.Bookmarks.Count > 0) then
    begin
      PageBookmark:=DirObj.Bookmarks[0].NumberPage;
      if PageBookmark <> -1 then
      begin
        LoadNavigateBitmap(4,PageBookmark);
        Result:=true;
      end;
    end;
  end;
end;

procedure TFormMain.OpenDirFunc(StrDir:String);
begin
  if BitmapListIsLoading then
    Exit;
  //чистим список в
  //диалоге предпросмотра
  DLLHeaders.ClearBitmapList;
  //меняем курсор
  //на загрузочный
  ChangeCursor(1);
  if StrDir <> '' then
  begin
    //ставим закладку если
    //был открыт архив
    if DirObj.ArchiveOpened and EnableHistory then
      if ReadBoolConfig('addbookmark_close') then
        Menu_AddbookmarkClick(nil);
    //очищаем текущее изображение
    MainImage.LayersClear;
    //перерисовка формы
    FormMain.Repaint;
    //сбрасываем данные
    DirObj.ClearData;
    //заполняем данные о нем
    DirObj.CreateDataToDir(StrDir);
    //пишем в историю
    if EnableHistory then
      DLLHeaders.AddHistoryDir(PWideChar(StrDir));
    //если список изображений
    //не пустой то грузим его
    if EnableHistory and GoToBookmark then
    else
      LoadNavigateBitmap(0);
    //загружаем меню
    LoadArchiveMenu;
  end;
  //меняем курсор на
  //стандартный
  ChangeCursor(0);
  //обновляем историю
  //для каталогов
  if EnableHistory then
    LoadMenuToDirHistory;
end;

procedure TFormMain.PopupMenuPopup(Sender: TObject);
begin
  CloseNavigatorWindow;
end;

procedure TFormMain.Menu_OpenDirClick(Sender: TObject);
var
  StrDir:String;
begin
  if BitmapListIsLoading then
    Exit;
  //выбираем каталог
  StrDir:=ShowDirDialog(FormMain.Left,FormMain.Top);
  OpenDirFunc(StrDir);
end;

function OpenFileDialogExecute:TStrings;
var
  GetPos:Integer;
begin
  Result:=nil;
  if DLLHeaders.OpenDialogFilesCount = 0 then
    Exit;
  Result:=TStringList.Create;
  for GetPos:=0 to DLLHeaders.OpenDialogFilesCount - 1 do
    Result.Add(WideString(DLLHeaders.OpenDialogFilesName(GetPos)));
end;

procedure TFormMain.Menu_OpenFileClick(Sender: TObject);
var
  FlagOpened:Boolean;
  FilesStrings:TStrings;
begin
  //чистим список в
  //диалоге предпросмотра
  DLLHeaders.ClearBitmapList;
  FlagOpened:=false;
  FilesStrings:=nil;
  if Assigned(DragNDropFiles) then
  begin
    FilesStrings:=TStringList.Create;
    FilesStrings.AddStrings(DragNDropFiles);
    FlagOpened:=true;
  end else begin
    if OpenArchiveDialog then
    begin
      FilesStrings:=OpenFileDialogExecute;
      FlagOpened:=(FilesStrings <> nil);
    end;
  end;
  //если что-то открыли
  //то обрабатываем список
  if FlagOpened then
  begin
    //ставим закладку если
    //был открыт архив
    if DirObj.ArchiveOpened and EnableHistory then
      if ReadBoolConfig('addbookmark_close') then
        Menu_AddbookmarkClick(nil);
    //очищаем текущее изображение
    MainImage.LayersClear;
    //перерисовка формы
    FormMain.Repaint;
    //сбрасываем данные
    DirObj.ClearData;
    //открываем все файлы
    if not DirObj.LoadFromStrings(FilesStrings) then
    begin
      ShowMessage(GlobalLangData.ReadString('MESSAGES','errorloadarchive',''));
      Exit;
    end;
    //чистим список
    FilesStrings.Free;
    //переходим на закладку
    if EnableHistory and GoToBookmark then
    else
      //загружаем первое изображение
      LoadNavigateBitmap(0);
    //загружаем меню
    LoadArchiveMenu;
  end;
end;

//информация о файле
procedure TFormMain.Menu_FileInfoClick(Sender: TObject);
var
  GetPath:WideString;
  Mode:Byte;
begin
  GetPath:=DirObj.MainDirDirectory;
  Mode:=0;
  if DirObj.ArchiveOpened then
    Mode:=1;  
  DLLHeaders.ShowReadForm(PWideChar(GetPath),Mode);
end;

{$ENDREGION}

{$REGION 'Режимы масштабирования'}

//оригинал
procedure TFormMain.Menu_OriginalClick(Sender: TObject);
begin
  //ChangeModeImage(IMAGE_MODE_ORIGINAL);
  ImageResizer.ChangeImageMode(IMAGE_MODE_ORIGINAL);
end;

//выравниванием по ширине
procedure TFormMain.Menu_StretchClick(Sender: TObject);
begin
  //ChangeModeImage(IMAGE_MODE_STRETCH);
  ImageResizer.ChangeImageMode(IMAGE_MODE_ORIGINAL);
end;

//масштабируем изображение
procedure TFormMain.Menu_ZoomClick(Sender: TObject);
begin
  //ChangeModeImage(IMAGE_MODE_SCALE);
  ImageResizer.ChangeImageMode(IMAGE_MODE_SCALE);
end;

//выравниванием по высоте
procedure TFormMain.Menu_FitHeightClick(Sender: TObject);
begin
  //ChangeModeImage(IMAGE_MODE_HEIGHT);
  ImageResizer.ChangeImageMode(IMAGE_MODE_HEIGHT);
end;

//автоматическое выравнивание
procedure TFormMain.Menu_FitAutoClick(Sender: TObject);
begin
  //ChangeModeImage(IMAGE_MODE_AUTO);
end;

{$ENDREGION}

{$REGION 'Навигация по списку просмотра'}

procedure TFormMain.Menu_EndImageClick(Sender: TObject);
begin
  LoadNavigateBitmap(3);
end;

procedure TFormMain.Menu_NextImageClick(Sender: TObject);
begin
  Self.LoadNavigateBitmap(1);
end;

procedure TFormMain.Menu_PrevImageClick(Sender: TObject);
begin
  Self.LoadNavigateBitmap(2);
end;

procedure TFormMain.Menu_StartImageClick(Sender: TObject);
begin
  Self.LoadNavigateBitmap(0);
end;

//навигация по изображениям
function TFormMain.LoadNavigateBitmap(Mode:byte;const Page:integer = -1):Boolean;
begin
  Result:=false;
  //проверка на наличие
  //изображений для
  //просмотра
  if not DirObj.NotEmpty then
    Exit;
  //скрываем кривые
  MainCurves.Visible:=false;
  //скрываем информационную
  //строку
  InfoMainForm.Visible:=false;

  if GlobalConfigData.ReadBool(CONFIG_MAINSECTION,'arcendpaging',false) then
  begin
    //если переходим вперед
    //и у нас есть следующий
    //архив в списке и настройка соответствующая
    //включена то открываем следующий архив
    if (Mode = 1) and DirObj.isEndIsList
        and not DirObj.isEndArchive then
    begin
      if DirObj.NextArchive then
        LoadToArchiveNumber(DirObj.ArchivesPos);
      Exit;
    end;
    //если переходим назад
    //и у нас есть предыдущий архив
    //и настройка тоже включена :)
    //то переходим на предыдущий архив
    if (Mode = 2) and DirObj.isStartIsList
        and not DirObj.isStartArchive then
    begin
      if DirObj.PrevArchive then
        LoadToArchiveNumber(DirObj.ArchivesPos,3);
      Exit;
    end;
  end;

  //перемещаемся по списку
  //в нужную сторону
  case Mode of
    //стартовая позиция
    0:Result:=DirObj.StartPos;
    //следующая позиция
    1:Result:=DirObj.Next;
    //предыдущая позиция
    2:Result:=DirObj.Prev;
    //конечная позиция
    3:Result:=DirObj.EndPos;
    //принудительный перевод
    //на любую страницу
    4:Result:=DirObj.SetNumImage(Page);
  end;
  //если актуально
  //то отображаем изображение
  if Result then
  begin
    //получаем изображение
    DirObj.GetBitmap;

    //автоматически
    //выставляем фон по левой верхней точке
    if GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,'modebackground',0) = 3 then
      MainImage.Background:=MainImage.Bitmap.Canvas.Pixels[0,0];

    //если нужно выставить просто фон
    if GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,'modebackground',0) = 1 then
      MainImage.Background:=GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,'backgroundcolor',clBlack);

    //корректируем размеры
    //изображения
    ImageResizer.ChangeImageMode;
    //меняем положения скролеров
    if Mode = 2 then
      ScrollToRightBottom
    else
      ScrollToLeftTop;
    if (Mode = 1) or (Mode = 2) then
      CounterBlockScrolling:=5;
  end;
  FLoadingImage:=5;
end;

//меняем кривые на лету
procedure TFormMain.ChangeCurvesBitmap(Sender:TObject);
begin
  if DirObj.NotEmpty then
    MainCurves.DoPreviewstoImageenView(Self.MainImage);
end;

{$ENDREGION}

{$REGION 'Управление списком архивов'}

procedure LoadToArchiveNumber(Index:integer;const NavigateMode:Integer = 0);
var
  //полный путь
  FullPath:WideString;
begin
  //выход за пределы диапозона
  if Index >= DirObj.Archives.Count then
    Exit;
  //если в данный момент
  //грузиться список
  //ничего не делаем
  if BitmapListIsLoading then
    Exit;
  //если настройка включена
  //то пытаемся сохранить закладку
  //для текущего архива
  if ReadBoolConfig('addbookmark_close') then
    FormMain.Menu_AddbookmarkClick(nil);
  with FormMain do
  begin
    //перерисовка формы
    FormMain.Repaint;
    //запоминаем позицию
    DirObj.ArchivesPos:=Index;
    //чистим все перед отображением
    DirObj.ClearData(false);
    //формируем полный путь
    FullPath:=DirObj.Archives[Index];
    //грузим архив
    DirObj.LoadArchive(FullPath,PathToBaseDir);
    DLLHeaders.ClearBitmapList;
    if EnableHistory and GoToBookmark then
    else
      LoadNavigateBitmap(NavigateMode);
    //обновляем меню
    CRMenuHelper.UpdateMenu;
  end;
end;

procedure LoadToArchiveString(FileName:String;const NavigateMode:Integer = 0);
begin
  //если в данный момент
  //грузиться список
  //ничего не делаем
  if BitmapListIsLoading then
    Exit;
  //если настройка включена
  //то пытаемся сохранить закладку
  //для текущего архива
  if ReadBoolConfig('addbookmark_close') then
    FormMain.Menu_AddbookmarkClick(nil);
  with FormMain do
  begin
    //перерисовка формы
    FormMain.Repaint;
    //чистим все перед отображением
    DirObj.ClearToDirOpened;
    //грузим архив
    DirObj.LoadArchive(FileName,PathToBaseDir);
    DLLHeaders.ClearBitmapList;
    if EnableHistory and GoToBookmark then
    else
      LoadNavigateBitmap(NavigateMode);
    //обновляем меню
    CRMenuHelper.UpdateMenu;
  end;
end;

procedure TFormMain.Menu_ArchiveListClick(Sender: TObject);
var
  NewArchive:WideString;
  Index:Integer;
begin
  NewArchive:=ShowArchiveDialog(Self.Left,Self.Top);
  if NewArchive = '' then
    Exit;
  //грузим список в меню
  LoadArchiveMenu;
  //находим выделенный
  //в списке
  Index:=DirObj.Archives.IndexOf(NewArchive);
  //если уже открыт
  //текущий архив
  //то пропускаем
  if Index = DirObj.ArchivesPos then
    Exit;
  //если не указан
  //или не найден
  if Index = -1 then
    Exit;
  //грузим архив
  LoadToArchiveNumber(Index);
end;

procedure TFormMain.LeftTopImageClick(Sender: TObject);
begin
  if PagingAnimPanel.Left = 0 then
    Menu_PrevImageClick(nil)
  else
    Menu_NextImageClick(nil);
  PagingAnimPanel.Visible:=false;
end;

//обрабатываем нажатие на список архива
procedure TFormMain.ListArchiveClick(Sender:TObject);
begin
  if TMenuItem(Sender).Checked then
    Exit;
  //загрузить архив
  LoadToArchiveNumber(TMenuItem(Sender).Tag);
end;

//загружаем меню
//архивов
procedure TFormMain.LoadArchiveMenu;
var
  MenuItem:TMenuItem;
  pos:integer;
begin
  with FormMain do
  begin
    //очищаем список
    //чилдов
    Menu_ListArchive.Clear;
    for pos := 0 to DirObj.Archives.Count-1 do
    begin
      //создаем подпункт
      MenuItem:=TMenuItem.Create(Self);
      //обработчик
      MenuItem.OnClick:=Self.ListArchiveClick;
      //берем наименование файла
      MenuItem.Caption:=ExtractFileName(DirObj.Archives.Strings[pos]);
      //тэг
      MenuItem.Tag:=pos;
      //добавляем в меню
      Menu_ListArchive.Add(MenuItem);
    end;
    //обновляем меню
    CRMenuHelper.UpdateMenu;
  end;
end;

//следующий архив
procedure TFormMain.Menu_NextArchiveClick(Sender: TObject);
begin
  if DirObj.NextArchive then
    LoadToArchiveNumber(DirObj.ArchivesPos);
end;

//предыдущий архив
procedure TFormMain.Menu_PrevArchiveClick(Sender: TObject);
begin
  if DirObj.PrevArchive then
    LoadToArchiveNumber(DirObj.ArchivesPos);
end;

//начальный архив
procedure TFormMain.Menu_StartArchiveClick(Sender: TObject);
begin
  if DirObj.Archives.Count > 0 then
    LoadToArchiveNumber(0);
end;

//конечный архив
procedure TFormMain.Menu_EndArchiveClick(Sender: TObject);
begin
  if (DirObj.Archives.Count > 0) and
     (DirObj.ArchivesPos <> DirObj.Archives.Count-1) then
    LoadToArchiveNumber(DirObj.Archives.Count-1);
end;

procedure TFormMain.Menu_SortFilesClick(Sender: TObject);
begin
  //отображаем диалог сортировки
  if not ShowSortFilesDialog(Self.Left,Self.Top) then
    Exit;
  //если пользователь
  //что-то отсортировал
  {Count:=DLLHeaders.CountElements;
  //сортируем данные и в
  //списке файлов
  for GetPos:=0 to Count-1 do
    DirObj.GetElement(GetPos).FileName:=DLLHeaders.GetElement(GetPos);}
  //перечитываем закладки
  //из базы
  LoadBookmarksAtBase;
  //перечитываем текущее
  //изображение
  LoadNavigateBitmap(4,DirObj.Position);
end;

{$ENDREGION}

{$REGION 'Трансформации изображения'}

procedure TFormMain.Menu_FlipHorizontalClick(Sender: TObject);
begin
  ListImage_FlipImage(false);
end;

procedure TFormMain.Menu_FlipVerticalAllClick(Sender: TObject);
begin
  ListImage_FlipImage(true);
end;

procedure TFormMain.Menu_FlipVerticalClick(Sender: TObject);
begin
  ListImage_FlipImageAll(true);
end;

procedure TFormMain.Menu_FlipHorizontalAllClick(Sender: TObject);
begin
  ListImage_FlipImageAll(false);
end;

procedure TFormMain.Menu_Rotate80CCWAllClick(Sender: TObject);
begin
  ListImage_RotateGetTo80CCWAll;
end;

procedure TFormMain.Menu_Rotate80CCWClick(Sender: TObject);
begin
  ListImage_RotateGetTo80CCW;
end;

procedure TFormMain.Menu_Rotate80CWAllClick(Sender: TObject);
begin
  ListImage_RotateGetTo80CWAll;
end;

procedure TFormMain.Menu_Rotate80CWClick(Sender: TObject);
begin
  ListImage_RotateGetTo80CW;
end;

procedure TFormMain.Menu_SaveToBufferClick(Sender: TObject);
begin
  ListImage_SaveGetToClipboard;
end;

procedure TFormMain.Menu_SaveToFileClick(Sender: TObject);
var
  SaveDialog:TSaveDialog;
  FileName:String;
begin
  if DirObj.BitmapList.Count = 0 then
    Exit;
  SaveDialog:=TSaveDialog.Create(nil);
  SaveDialog.Filter:=
    'BMP|*.bmp|'+
    'TIF|*.tif|'+
    'JPEG|*.jpg|'+
    'PSD|*.psd|'+
    'PDF|*.pdf|'+
    'GIF|*.gif|'+
    'PNG|*.png|'+
    'TGA|*.tga|'+
    'HDP|*.hdp'
    ;
  if SaveDialog.Execute then
  begin
    FileName:=SaveDialog.FileName;
    if ExtractFileExt(FileName) = '' then
    begin
      case SaveDialog.FilterIndex of
        1:FileName:=FileName+'.bmp';
        2:FileName:=FileName+'.tif';
        3:FileName:=FileName+'.jpg';
        4:FileName:=FileName+'.psd';
        5:FileName:=FileName+'.pdf';
        6:FileName:=FileName+'.gif';
        7:FileName:=FileName+'.png';
        8:FileName:=FileName+'.tga';
        9:FileName:=FileName+'.hdp';
      end;
    end;
    ListImage_SaveGetToFile(PWideChar(FileName));
  end;
end;

{$ENDREGION}

{$REGION 'Кривые'}

procedure TFormMain.Menu_ApplyCurvesClick(Sender: TObject);
begin
  MainCurves.ExportCurvesToFile(PathToProgramDir+'curves.fcc');
end;

procedure TFormMain.Menu_ResetCurvesClick(Sender: TObject);
begin
  MainCurves.ResetPoints;
end;

procedure TFormMain.Menu_SaveCurvesClick(Sender: TObject);
begin
  MainCurves.ExportCurves;
end;

procedure TFormMain.Menu_OpenCurvesClick(Sender: TObject);
begin
  with GetOpenDialog do
  begin
    Filter:='Curves file|*.fcc';
    if Execute then
      MainCurves.ImportCurvesFromFile(FileName);
  end;
end;

procedure TFormMain.Menu_OpenDefaultCurvesClick(Sender: TObject);
begin
  MainCurves.ImportCurvesFromFile(PathToProgramDir+'curves.fcc');
end;

{$ENDREGION}

{$REGION 'История'}

//выводим диалог истории
procedure TFormMain.Menu_HistoryDialogClick(Sender: TObject);
var
  HistoryRecord:DLLHeaders.TResultDialog;
  Strings:TStrings;
begin
  HistoryRecord:=DLLHeaders.ShowDialogHistory();
  if not HistoryRecord.Complete then
    Exit;
  //очищаем текущее изображение
  MainImage.LayersClear;
  //перерисовка формы
  FormMain.Repaint;
  //сбрасываем данные
  DirObj.ClearData;
  //если пришел результат
  //то открываем соответствующий
  //файл
  case HistoryRecord.TypeDate of
    //архив
    0:
      begin
        Strings:=TStringList.Create;
        Strings.Add(HistoryRecord.NameFile);
        DirObj.LoadFromStrings(Strings);
        LoadNavigateBitmap(0);
        CRMenuHelper.UpdateMenu;
        Strings.Free;
      end;
    //каталог
    1:
      begin
        OpenDirFunc(HistoryRecord.NameFile);
      end;
    //закладка
    2:
      begin
        Strings:=TStringList.Create;
        Strings.Add(HistoryRecord.NameFile);
        DirObj.LoadFromStrings(Strings);
        //переходим на закладку
        if EnableHistory and GoToBookmark then
        else
          //загружаем первое изображение
          LoadNavigateBitmap(0);
        CRMenuHelper.UpdateMenu;
        Strings.Free;
      end;
  end;
end;

procedure TFormMain.ClickToHistoryMenu(Sender: TObject);
begin
  if EnableHistory then
  begin
    with TMenuItem(Sender) do
    begin
      //если расширение пустое
      //то открываем папку
      if ExtractFileExt(Hint) = '' then
      begin
        if DirectoryExists(Hint) then
          OpenDirFunc(Hint);
      end else
      begin
        //если нет то значит
        //это архив
        if FileExists(Hint) then
          LoadToArchiveString(Hint,0);
      end;
    end;
  end;
end;

procedure TFormMain.Menu_AddbookmarkClick(Sender: TObject);
begin
  if not EnableHistory then
    Exit;
  if DirObj.ArchiveOpened and DirObj.NotEmpty  then
  begin
    //если настройка включена
    //чистим все текущие закладки
    //доступные для этого архива
    if ReadBoolConfig('bookmark_is_one') then
      DLLHeaders.DeleteBookmarkArchive(PWideChar(DirObj.GetOpenedArchive),true);
    //ставим закладку
    DLLHeaders.AddBookmarkArchive(
        PWideChar(DirObj.GetOpenedArchive),
        PWideChar (
          PCRFileRecord(DirObj.BitmapList.Items[DirObj.Position]).FileName
                  )
      );
    //обновляем данные о закладках
    LoadBookmarksAtBase;
  end;
end;

//чистим весь список закладок
//для текущего архива
procedure TFormMain.Menu_ClearBookmarksClick(Sender: TObject);
begin
  DLLHeaders.DeleteBookmarkArchive(PWideChar(DirObj.GetOpenedArchive),true);
  //обновляем данные о закладках
  LoadBookmarksAtBase;
end;

procedure TFormMain.Menu_NextBookmarkClick(Sender: TObject);
var
  BookmarkRec:TCRBookmark;
  NumChanged:Integer;
begin
  if DirObj.Bookmarks.Count = 0 then
    Exit;
  NumChanged:=-1;
  //ищем закладку которая
  //стоит позднее чем
  //открытая страница
  for BookmarkRec in DirObj.Bookmarks do
  begin
    if DirObj.Position < BookmarkRec.NumberPage  then
    begin
      NumChanged:=BookmarkRec.NumberPage;
      Break;
    end;
  end;
  //если закладка найдена
  //переходим на нее
  if NumChanged > -1 then
    LoadNavigateBitmap(4,NumChanged);
end;

procedure TFormMain.Menu_PrevBookmarkClick(Sender: TObject);
var
  BookmarkRec:TCRBookmark;
  NumChanged:Integer;
begin
  if DirObj.Bookmarks.Count = 0 then
    Exit;
  NumChanged:=-1;
  //ищем закладку которая
  //стоит позднее чем
  //открытая страница
  for BookmarkRec in DirObj.Bookmarks do
  begin
    if BookmarkRec.NumberPage < DirObj.Position then
    begin
      NumChanged:=BookmarkRec.NumberPage;
      Break;
    end;
  end;
  //если закладка найдена
  //переходим на нее
  if NumChanged > -1 then
    LoadNavigateBitmap(4,NumChanged);
end;

//загружаем закладки
//из базы в память
procedure TFormMain.LoadBookmarksAtBase;
var
  //массив дял получения
  //закладок
  ArrBookmarks:TWideCharHistoryArray;
  //запись закладки
  BookmarkRec:TCRBookmark;
  GetPos:Integer;
begin
  if not EnableHistory then
    Exit;
  if not DirObj.ArchiveOpened then
    Exit;
    //ищем закладки для текущего
    //архива
    ArrBookmarks:=FindAllBookmarkArchive(PWideChar(DirObj.GetOpenedArchive),true);
    //чистим список закладок
    DirObj.Bookmarks.Clear;
    //загружаем закладки
    if High(ArrBookmarks) > -1 then
    begin
      for GetPos:=0 to High(ArrBookmarks) do
      begin
        BookmarkRec.PageName:=ArrBookmarks[GetPos];
        BookmarkRec.NumberPage:=DirObj.GetElement(BookmarkRec.PageName);
        DirObj.Bookmarks.Add(BookmarkRec);
      end;
    end;
end;

{$ENDREGION}

{$REGION 'Создание и пересохранение архивов'}

procedure TFormMain.Menu_CreateRARClick(Sender: TObject);
var
  RarArc:TArcCreateRar;
  SaveDialog:TSaveDialog;
  GetPos:Integer;
begin
  if DirObj.ArchiveOpened then
    Exit;
  //выводим диалог для сохранения
  SaveDialog:=TSaveDialog.Create(nil);
  SaveDialog.Filter:='CBR|*.cbr|RAR|*.rar';
  if not SaveDialog.Execute then
    Exit;
  RepackCallBack(rcpCreate);
  //если нет расширения
  //то добавляем
  if ExtractFileExt(SaveDialog.FileName) = '' then
  begin
    case SaveDialog.FilterIndex of
      1:SaveDialog.FileName:=SaveDialog.FileName+'.cbr';
      2:SaveDialog.FileName:=SaveDialog.FileName+'.rar';
    end;
  end;
  //создаем объект для работы
  //с архивом
  RarArc:=TArcCreateRar.Create;
  //формируем список файлов
  for GetPos:=0 to DirObj.BitmapList.Count-1 do
    RarArc.AddFile(DirObj.GetElement(GetPos).FileName);
  for GetPos:=0 to DirObj.TxtFiles.Count-1 do
    RarArc.AddFile(DirObj.TxtFiles.Strings[GetPos]);
  //сохраняем в архив
  RarArc.CreateArchive(SaveDialog.FileName);
  RarArc.Free;
  NumberNextImage.Caption:='';
  NumberNextImage.Visible:=false;
end;

procedure TFormMain.Menu_CreateZipClick(Sender: TObject);
var
  ZipArc:TArcCreateZip;
  SaveDialog:TSaveDialog;
  GetPos:Integer;
begin
  if DirObj.ArchiveOpened then
    Exit;
  //выводим диалог для сохранения
  SaveDialog:=TSaveDialog.Create(nil);
  SaveDialog.Filter:='CBZ|*.cbz|ZIP|*.rar';
  if not SaveDialog.Execute then
    Exit;
  RepackCallBack(rcpCreate);
  //если нет расширения
  //то добавляем
  if ExtractFileExt(SaveDialog.FileName) = '' then
  begin
    case SaveDialog.FilterIndex of
      1:SaveDialog.FileName:=SaveDialog.FileName+'.cbz';
      2:SaveDialog.FileName:=SaveDialog.FileName+'.zip';
    end;
  end;
  //создаем объект для работы
  //с архивом
  ZipArc:=TArcCreateZip.Create;
  //формируем список файлов
  for GetPos:=0 to DirObj.BitmapList.Count-1 do
    ZipArc.AddFile(DirObj.GetElement(GetPos).FileName);
  for GetPos:=0 to DirObj.TxtFiles.Count-1 do
    ZipArc.AddFile(DirObj.TxtFiles.Strings[GetPos]);
  //сохраняем в архив
  ZipArc.CreateArchive(SaveDialog.FileName);
  ZipArc.Free;
  NumberNextImage.Caption:='';
  NumberNextImage.Visible:=false;
end;

procedure TFormMain.Menu_Create7ZipClick(Sender: TObject);
var
  ZipArc:TArcCreate7Zip;
  SaveDialog:TSaveDialog;
  GetPos:Integer;
begin
  if DirObj.ArchiveOpened then
    Exit;
  //выводим диалог для сохранения
  SaveDialog:=TSaveDialog.Create(nil);
  SaveDialog.Filter:='CB7|*.cb7|7ZIP|*.7z';
  if not SaveDialog.Execute then
    Exit;
  RepackCallBack(rcpCreate);
  //если нет расширения
  //то добавляем
  if ExtractFileExt(SaveDialog.FileName) = '' then
  begin
    case SaveDialog.FilterIndex of
      1:SaveDialog.FileName:=SaveDialog.FileName+'.cb7';
      2:SaveDialog.FileName:=SaveDialog.FileName+'.7z';
    end;
  end;
  //создаем объект для работы
  //с архивом
  ZipArc:=TArcCreate7Zip.Create;
  //формируем список файлов
  for GetPos:=0 to DirObj.BitmapList.Count-1 do
    ZipArc.AddFile(DirObj.GetElement(GetPos).FileName);
  for GetPos:=0 to DirObj.TxtFiles.Count-1 do
    ZipArc.AddFile(DirObj.TxtFiles.Strings[GetPos]);
  //сохраняем в архив
  ZipArc.CreateArchive(SaveDialog.FileName);
  ZipArc.Free;
  NumberNextImage.Caption:='';
  NumberNextImage.Visible:=false;
end;

procedure TFormMain.Menu_CreatePDFClick(Sender: TObject);
var
  PdfArc:TArcCreatePdf;
  SaveDialog:TSaveDialog;
  GetPos:Integer;
begin
  if DirObj.ArchiveOpened then
    Exit;
  //выводим диалог для сохранения
  SaveDialog:=TSaveDialog.Create(nil);
  SaveDialog.DefaultExt:='*.pdf';
  SaveDialog.Filter:='PDF|*.pdf';
  if not SaveDialog.Execute then
    Exit;
  RepackCallBack(rcpCreate);
  //если нет расширения
  //то добавляем
  if ExtractFileExt(SaveDialog.FileName) = '' then
    SaveDialog.FileName:=SaveDialog.FileName+'.pdf';
  //создаем объект для работы
  //с архивом
  PdfArc:=TArcCreatePdf.Create;
  //формируем список файлов
  for GetPos:=0 to DirObj.BitmapList.Count-1 do
    PdfArc.AddFile(DirObj.GetElement(GetPos).FileName);
  //сохраняем в архив
  PdfArc.CreateArchive(SaveDialog.FileName);
  PdfArc.Free;
  NumberNextImage.Caption:='';
  NumberNextImage.Visible:=false;
end;

procedure TFormMain.Menu_CreateTIFFClick(Sender: TObject);
var
  TiffArc:TArcCreateTiff;
  SaveDialog:TSaveDialog;
  GetPos:Integer;
begin
  if DirObj.ArchiveOpened then
    Exit;
  //выводим диалог для сохранения
  SaveDialog:=TSaveDialog.Create(nil);
  SaveDialog.DefaultExt:='*.tif';
  SaveDialog.Filter:='TIFF|*.tif';
  if not SaveDialog.Execute then
    Exit;
  RepackCallBack(rcpCreate);
  //если нет расширения
  //то добавляем
  if ExtractFileExt(SaveDialog.FileName) = '' then
    SaveDialog.FileName:=SaveDialog.FileName+'.tif';
  //создаем объект для работы
  //с архивом
  TiffArc:=TArcCreateTiff.Create;
  //формируем список файлов
  for GetPos:=0 to DirObj.BitmapList.Count-1 do
    TiffArc.AddFile(DirObj.GetElement(GetPos).FileName);
  //сохраняем в архив
  TiffArc.CreateArchive(SaveDialog.FileName);
  TiffArc.Free;
  NumberNextImage.Caption:='';
  NumberNextImage.Visible:=false;
end;

procedure TFormMain.Menu_CreateGIFClick(Sender: TObject);
var
  GifArc:TArcCreateGif;
  SaveDialog:TSaveDialog;
  GetPos:Integer;
begin
  if DirObj.ArchiveOpened then
    Exit;
  //выводим диалог для сохранения
  SaveDialog:=TSaveDialog.Create(nil);
  SaveDialog.DefaultExt:='*.gif';
  SaveDialog.Filter:='GIF|*.gif';
  if not SaveDialog.Execute then
    Exit;
  RepackCallBack(rcpCreate);
  //если нет расширения
  //то добавляем
  if ExtractFileExt(SaveDialog.FileName) = '' then
    SaveDialog.FileName:=SaveDialog.FileName+'.gif';
  //создаем объект для работы
  //с архивом
  GifArc:=TArcCreateGif.Create;
  //формируем список файлов
  for GetPos:=0 to DirObj.BitmapList.Count-1 do
    GifArc.AddFile(DirObj.GetElement(GetPos).FileName);
  //сохраняем в архив
  GifArc.CreateArchive(SaveDialog.FileName);
  GifArc.Free;
  NumberNextImage.Caption:='';
  NumberNextImage.Visible:=false;
end;

procedure TFormMain.RepackCallBack(GetProcess:TArcReCreateProcess);
begin
  if not NumberNextImage.Visible then
    NumberNextImage.Visible:=true;
  case GetProcess of
    rcpExtract:NumberNextImage.Caption:=GlobalLangData.ReadString(CONFIG_MAINSECTION,'repackloadingunarc','');
    rcpPack:NumberNextImage.Caption:=GlobalLangData.ReadString(CONFIG_MAINSECTION,'repackloadingarc','');
    rcpCreate:NumberNextImage.Caption:=GlobalLangData.ReadString(CONFIG_MAINSECTION,'createloading','');
  end;
  Application.ProcessMessages;
end;

//перепаковываем текущий архив
function TFormMain.RepackGetArchive(SaveCustom:Boolean):Boolean;
var
  ArcReCreate:TArcReCreate;
  PathToRepackDir:String;
  FileArchive:String;
  SaveDialog:TSaveDialog;
  Ext:String;
begin
  //нет архивов
  //нечего и делать
  if DirObj.Archives.Count = 0 then
    Exit(false);
  NumberNextImage.Caption:='';
  NumberNextImage.Align:=alBottom;
  NumberNextImage.Visible:=true;
  FileArchive:=DirObj.Archives.Strings[DirObj.ArchivesPos];
  ArcReCreate:=TArcReCreate.Create(FileArchive,rcmSelf);
  try
    ArcReCreate.OnCallBack:=RepackCallBack;
    PathToRepackDir:=PathToProgramDir+'repackdir\';
    if not DirectoryExists(PathToRepackDir) then
      MkDir(PathToRepackDir);
    if not ArcReCreate.Repack(PathToRepackDir) then
      Exit(false);
    if SaveCustom then
    begin
      SaveDialog:=TSaveDialog.Create(nil);
      Ext:=ExtractFileExt(ArcReCreate.RepackFileName);
      SaveDialog.DefaultExt:=Ext;
      SaveDialog.Filter:=Ext+'|'+Ext;
      if SaveDialog.Execute then
      begin
        CopyFileW
          (
            PWideChar(ArcReCreate.RepackFileName),
            PWideChar(SaveDialog.FileName),
            false
          );
        DeleteFileW(PWideChar(ArcReCreate.RepackFileName));
      end;
      SaveDialog.Free;
    end else
    begin
      //чистим данные о текущем открытом
      //архиве
      CloseCurrentList(false);
      //удаляем его
      DeleteFileW(PWideChar(FileArchive));
      //копируем перепакованный
      CopyFileW
        (
            PWideChar(ArcReCreate.RepackFileName),
            PWideChar(FileArchive),
            false
        );
      //удаляем его из источника
      DeleteFileW(PWideChar(ArcReCreate.RepackFileName));
      //открываем архив заново
      LoadToArchiveNumber(DirObj.ArchivesPos);
    end;
  except
    ShowMessage(GlobalLangData.ReadString(CONFIG_MAINSECTION,'repackloadingerror',''));
    Exit(false);
  end;
  ArcReCreate.Free;
  NumberNextImage.Caption:='';
  NumberNextImage.Visible:=false;
  Result:=true;
end;

//перепаковываем и сохраняем
//с диалогом
procedure TFormMain.Menu_RecreateandrewriteClick(Sender: TObject);
begin
  RepackGetArchive(false);
end;

procedure TFormMain.Menu_RecreateandsaveasClick(Sender: TObject);
begin
  RepackGetArchive(true);
end;

{$ENDREGION}

{$ENDREGION}

end.
