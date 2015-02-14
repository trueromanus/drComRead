{
  drComRead

  Модуль для описания
  работы элемента управления
  Быстрые действия

  Copyright (c) 2010-2011 Romanus
}
unit CRFastActions;

interface

uses
  Classes, ExtCtrls, Buttons, Controls,
  Generics.Collections, Menus;

type

  {$REGION 'Новый класс'}

  //действие
  TCRFastAction = class
  private
    //родитель
    FParent:TCRFastAction;
    //подсказка
    FTitle:String;
    //событие
    FClick:TNotifyEvent;
    //имя изображения
    FImageName:String;
  public
    property Parent:TCRFastAction read FParent;
    property Title:String read FTitle;
    property Click:TNotifyEvent read FClick;
    property ImageName:String read FImageName;
    constructor Create(Parent:TCRFastAction;Click:TNotifyEvent;ImageName,Title:String);
  end;

  TCRFastActionsNew = class
  private
    //панель для отображения
    //кнопок быстрых действий
    FPanel:TPanel;
    //дополнительная панель
    //для дополнительных действий
    FAddPanel:TPanel;
    //последняя нажатая кнопка
    //которая вывела меню
    FLastButtonCliked:TSpeedButton;
    //доступные команды
    FCommands:TList<TCRFastAction>;
    //кнопки
    FButtons:TObjectList<TSpeedButton>;
    //кнопки для дополнительной
    //панели
    FAddButtons:TObjectList<TSpeedButton>;
    //генерируемое меню
    //для изменения
    //состояния
    FMenu:TPopupMenu;
    //индекс нажатой кнопки
    //при вызове меню изменения
    FClickedButton:Integer;
  protected
    function GetVisible:Boolean;
    //загружаем команды
    procedure LoadCommands;
    //загружаем из настроек
    procedure LoadSettings;
    //ассоциируем действие и кнопку
    procedure LoadActionToButton(IndexButton,IndexAction:Integer);
    //создаем всплывающее меню
    procedure CreatePopupMenu;
    //обработчик для смены кнопки
    procedure ChangeButtonEvent(Sender:TObject);
  public
    //панель для действий
    property Panel:TPanel read FPanel;
    //панель дополнительных действий
    property AddPanel:TPanel read FAddPanel;
    //признак отображения
    property Visible:Boolean read GetVisible;
    //конструктор
    constructor Create;
    //деструктор
    destructor Destroy;override;
    //добавляем действие
    function AddAction(Title,Icon:String;Parent:TCRFastAction;Event:TNotifyEvent):TCRFastAction;
    //отображаем быстрые действия
    procedure Show;
    //скрываем быстрые действия
    procedure Hide;
    //обработчик для скрытия
    //тулбара
    procedure MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    //выполняем операцию тулбара
    //по индексу
    procedure ExecuteActionByIndex(Index:Integer);
    //обработчик для групповых
    //выводов
    procedure GroupVisibleEvent(Sender:TObject);
    //обработчик для скрытия
    //дополнительного тулбара
    //при любом нажатии кнопок
    procedure MouseUpAddPanel(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  end;

  {$ENDREGION}

//инициализируем быстрые действия
procedure InitFastActions;
//деинициализируем быстрые действия
procedure DeInitFastActions;

implementation

uses
  SysUtils, Windows, Forms, DLLHeaders,
  MainForm, CRGlobal, imageenio;

{$REGION 'TCRFastActionsNew'}

constructor TCRFastAction.Create(Parent:TCRFastAction;Click:TNotifyEvent;ImageName,Title:String);
begin
  FParent:=Parent;
  FClick:=Click;
  FImageName:=ImageName;
  FTitle:=Title;
end;

function TCRFastActionsNew.GetVisible:Boolean;
begin
  Result:=FPanel.Visible;
end;

//загружаем команды
procedure TCRFastActionsNew.LoadCommands;
var
  ImageAction:TCRFastAction;
  NavigateAction:TCRFastAction;
  WindowAction:TCRFastAction;
  FileAction:TCRFastAction;
  BookmarkAction:TCRFastAction;
begin
  FileAction:=AddAction(ReadLang(CONFIG_MAINSECTION,'filemenu'),'filegroup.gif',nil,GroupVisibleEvent);
  NavigateAction:=AddAction(ReadLang(CONFIG_MAINSECTION,'navigate'),'navigate.gif',nil,GroupVisibleEvent);
  WindowAction:=AddAction(ReadLang(CONFIG_MAINSECTION,'window'),'windowgroup.gif',nil,GroupVisibleEvent);
  ImageAction:=AddAction(ReadLang(CONFIG_MAINSECTION,'image'),'imagegroup.gif',nil,GroupVisibleEvent);

  AddAction(ReadLang(CONFIG_MAINSECTION,'opendir'),'openfolder.gif',FileAction,FormMain.Menu_OpenDirClick);
  AddAction(ReadLang(CONFIG_MAINSECTION,'openfile'),'openfile.gif',FileAction,FormMain.Menu_OpenFileClick);
  AddAction(ReadLang(CONFIG_MAINSECTION,'closefile'),'close.gif',FileAction,FormMain.Menu_CloseCurrentClick);
  AddAction(ReadLang(CONFIG_MAINSECTION,'navigate_next'),'imagenext.gif',NavigateAction,FormMain.Menu_NextImageClick);
  AddAction(ReadLang(CONFIG_MAINSECTION,'navigate_prev'),'imageprev.gif',NavigateAction,FormMain.Menu_PrevImageClick);
  AddAction(ReadLang(CONFIG_MAINSECTION,'navigate_nextarc'),'book_next.gif',NavigateAction,FormMain.Menu_NextArchiveClick);
  AddAction(ReadLang(CONFIG_MAINSECTION,'navigate_prevarc'),'book_previous.gif',NavigateAction,FormMain.Menu_PrevArchiveClick);
  AddAction(ReadLang('CONFIGDIALOG','main_title'),'settings.gif',FileAction,FormMain.Menu_SettingsClick);
  AddAction(ReadLang(CONFIG_MAINSECTION,'fileinfo'),'infofile.gif',WindowAction,FormMain.Menu_FileInfoClick);
  AddAction(ReadLang(CONFIG_MAINSECTION,'archivedialog'),'archivedialog.gif',WindowAction,FormMain.Menu_ArchiveListClick);
  AddAction(ReadLang(CONFIG_MAINSECTION,'sortfiles'),'sortfiles.gif',WindowAction,FormMain.Menu_SortFilesClick);
  AddAction(ReadLang(CONFIG_MAINSECTION,'historydialog'),'historydialog.gif',WindowAction,FormMain.Menu_HistoryDialogClick);
  //Группа окно
  //полный экран
  AddAction(ReadLang(CONFIG_MAINSECTION,'window_fscr'),'fullscreen.gif',WindowAction,FormMain.Menu_FullScreenClick);
  //минимизировать
  AddAction(ReadLang(CONFIG_MAINSECTION,'window_min'),'minimize.gif',WindowAction,FormMain.Menu_MinimizeClick);
  //навигатор
  AddAction(ReadLang(CONFIG_MAINSECTION,'window_magn'),'navigator.gif',WindowAction,FormMain.Menu_NavigatorClick);
  //единичный просмотрщик
  AddAction(ReadLang(CONFIG_MAINSECTION,'window_deff'),'singlepreview.gif',WindowAction,FormMain.Menu_SinglePreviewClick);
  //Дополнительные операции
  //закрыть все
  AddAction(ReadLang(CONFIG_MAINSECTION,'closeall'),'closeall.gif',FileAction,FormMain.Menu_CloseAllClick);
  //выход из программы
  AddAction(ReadLang(CONFIG_MAINSECTION,'image_exit'),'exitprogram.gif',FileAction,FormMain.Menu_ExitClick);
  //сохранить текущее изображение
  //в файл
  AddAction(ReadLang(CONFIG_MAINSECTION,'savetofile'),'saveimage.gif',FileAction,FormMain.Menu_SaveToFileClick);
  //сохранить текущее изображение
  //в буфер обмена
  AddAction(ReadLang(CONFIG_MAINSECTION,'savetoclipboard'),'saveclipboard.gif',FileAction,FormMain.Menu_SaveToBufferClick);
  //Группа изображение
  //Действие для группы
  AddAction(ReadLang('CURVES','main_title'),'colorcorrection.gif',ImageAction,FormMain.Menu_CurvesSettingClick);
  //масштабировать
  AddAction(ReadLang(CONFIG_MAINSECTION,'image_zoom'),'zoom.gif',ImageAction,FormMain.Menu_ZoomClick);
  //выровнять по ширине
  AddAction(ReadLang(CONFIG_MAINSECTION,'image_stretch'),'scalewidth.gif',ImageAction,FormMain.Menu_StretchClick);
  //выровнять по высоте
  AddAction(ReadLang(CONFIG_MAINSECTION,'image_height'),'scaleheight.gif',ImageAction,FormMain.Menu_FitHeightClick);
  //оригинал
  AddAction(ReadLang(CONFIG_MAINSECTION,'image_original'),'original.gif',ImageAction,FormMain.Menu_OriginalClick);
  //поворот по часовой
  AddAction(ReadLang(CONFIG_MAINSECTION,'rotate_cw'),'rotatecw.gif',ImageAction,FormMain.Menu_Rotate80CWClick);
  //поворот против часовой
  AddAction(ReadLang(CONFIG_MAINSECTION,'rotate_ccw'),'rotateccw.gif',ImageAction,FormMain.Menu_Rotate80CCWClick);
  //зеркально по горизонтали
  AddAction(ReadLang(CONFIG_MAINSECTION,'flip_horizontal'),'fliphorizontal.gif',ImageAction,FormMain.Menu_FlipHorizontalClick);
  //зеркально по вертикали
  AddAction(ReadLang(CONFIG_MAINSECTION,'flip_vertical'),'flipvertical.gif',ImageAction,FormMain.Menu_FlipVerticalClick);

  //переходим в начало списка
  AddAction(ReadLang(CONFIG_MAINSECTION,'navigate_start'),'startimage.gif',NavigateAction,FormMain.Menu_StartImageClick);
  //переходим в конец списка
  AddAction(ReadLang(CONFIG_MAINSECTION,'navigate_end'),'endimage.gif',NavigateAction,FormMain.Menu_EndImageClick);

  BookmarkAction:=AddAction(ReadLang(CONFIG_MAINSECTION,'bookmarks'),'bookmarkgroup.gif',nil,GroupVisibleEvent);
  //предыдущая закладка
  AddAction(ReadLang(CONFIG_MAINSECTION,'prevbookmark'),'prevbookmark.gif',BookmarkAction,FormMain.Menu_PrevBookmarkClick);
  //следующая закладка
  AddAction(ReadLang(CONFIG_MAINSECTION,'nextbookmark'),'nextbookmark.gif',BookmarkAction,FormMain.Menu_NextBookmarkClick);
  //поставить закладки
  AddAction(ReadLang(CONFIG_MAINSECTION,'addbookmark'),'addbookmark.gif',BookmarkAction,FormMain.Menu_AddbookmarkClick);
  //удалить все закладки в текущем архиве
  AddAction(ReadLang(CONFIG_MAINSECTION,'clearallbookmark'),'clearallbookmark.gif',BookmarkAction,FormMain.Menu_ClearBookmarksClick);
end;

procedure TCRFastActionsNew.LoadSettings;
var
  NameSection:String;
  GetPos:Integer;
begin
  NameSection:='FASTACTIONS';
  for GetPos:=0 to 8 do
    LoadActionToButton(GetPos,GlobalConfigData.ReadInteger(NameSection,'num'+IntToStr(GetPos),0));
end;

//ассоциируем действие и кнопку
procedure TCRFastActionsNew.LoadActionToButton(IndexButton,IndexAction:Integer);
var
  IEIO:TImageEnIO;
begin
  FButtons[IndexButton].OnClick:=FCommands[IndexAction].Click;
  FButtons[IndexButton].Hint:=FCommands[IndexAction].Title;
  FButtons[IndexButton].Font.Height:=IndexAction;
  IEIO:=TImageEnIO.Create(nil);
  IEIO.AttachedBitmap:=FButtons[IndexButton].Glyph;
  IEIO.LoadFromFile(PathToProgramDir+'data\toolbar\'+FCommands[IndexAction].ImageName);
  IEIO.Free;
end;

//создаем всплывающее меню
procedure TCRFastActionsNew.CreatePopupMenu;
var
  Action:TCRFastAction;
  Item:TMenuItem;
  ItemChild:TMenuItem;
  IndexAction:Integer;
  Iterator:Integer;
begin
  Iterator:=0;
  for Action in FCommands do
  begin
    Item:=TMenuItem.Create(FMenu);
    Item.Caption:=Action.Title;
    Item.Tag:=Iterator;
    Item.OnClick:=ChangeButtonEvent;
    //если привзан к родителю
    if Action.Parent <> nil then
    begin
      IndexAction:=FCommands.IndexOf(Action.Parent);
      for ItemChild in FMenu.Items do
        if ItemChild.Tag = IndexAction then
          ItemChild.Add(Item);
    end else
    begin
      //если нет то добавляем в корень
      Item.OnClick:=nil;
      FMenu.Items.Add(Item);
      ItemChild:=TMenuItem.Create(FMenu);
      ItemChild.Caption:=ReadLang(CONFIG_MAINSECTION,'selectallgroup');
      ItemChild.Tag:=Iterator;
      ItemChild.OnClick:=ChangeButtonEvent;
      FMenu.Items[FMenu.Items.Count-1].Add(ItemChild);
    end;
    Inc(Iterator);
  end;
end;

//обработчик для смены кнопки
procedure TCRFastActionsNew.ChangeButtonEvent(Sender:TObject);
begin
  LoadActionToButton(FClickedButton,TMenuItem(Sender).Tag);
  GlobalConfigData.WriteInteger('FASTACTIONS','num'+IntToStr(FClickedButton),TMenuItem(Sender).Tag);
end;

//конструктор
constructor TCRFastActionsNew.Create;
var
  GetPos:Integer;
  Exp:Integer;
  Button:TSpeedButton;
begin
  FPanel:=TPanel.Create(FormMain);
  FPanel.Cursor:=crArrow;
  FAddPanel:=TPanel.Create(FormMain);
  FAddPanel.Parent:=FormMain.MainImage;
  FAddPanel.Visible:=false;
  FAddPanel.Cursor:=crArrow;
  FButtons:=TObjectList<TSpeedButton>.Create();
  FCommands:=TList<TCRFastAction>.Create();
  FMenu:=TPopupMenu.Create(nil);
  FPanel.Parent:=FormMain.MainImage;
  FPanel.Width:=343;
  FPanel.Height:=38;
  Exp:=-38;
  for GetPos:=0 to 8 do
  begin
    Exp:=Exp+38;
    Button:=TSpeedButton.Create(FPanel);
    with Button do
    begin
      Parent:=FPanel;
      Left:=Exp;
      Width:=38;
      Height:=38;
      Tag:=GetPos;
      ShowHint:=true;
      OnMouseDown:=MouseDown;
      Cursor:=crArrow;
    end;
    FButtons.Add(Button);
  end;
  //загружаем команды
  LoadCommands;
  //ассоциируем кнопки
  //из настроек
  LoadSettings;
  //создаем всплывающее
  //меню
  CreatePopupMenu;
end;

//деструктор
destructor TCRFastActionsNew.Destroy;
var
  Action:TCRFastAction;
  Item:TMenuItem;
begin
  //чистим за собой
  FButtons.Free;
  for Action in FCommands do
    Action.Free;
  FreeAndNil(FCommands);
  if Assigned(FAddButtons) then
    FreeAndNil(FAddButtons);
  FPanel.Free;
  FAddPanel.Free;
  for Item in FMenu.Items do
    Item.Free;
  FMenu.Items.Clear;
  FMenu.Free;
end;

//добавляем действие
function TCRFastActionsNew.AddAction(Title,Icon:String;Parent:TCRFastAction;Event:TNotifyEvent):TCRFastAction;
var
  Action:TCRFastAction;
begin
  Action:=TCRFastAction.Create(Parent,Event,Icon,Title);
  FCommands.Add(Action);
  Result:=Action;
end;

//отображаем быстрые действия
procedure TCRFastActionsNew.Show;
begin
  FPanel.Visible:=true;
  FPanel.Left:=(FormMain.Width div 2)-(FPanel.Width div 2);
end;

//скрываем быстрые действия
procedure TCRFastActionsNew.Hide;
begin
  FPanel.Visible:=false;
  FAddPanel.Visible:=false;
end;

//обработчик для скрытия
//тулбара
procedure TCRFastActionsNew.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  CloseNavigatorWindow;
  if ssMiddle in Shift then
  begin
    Self.Hide;
    Exit;
  end;
  if ssRight in Shift then
  begin
    FClickedButton:=TSpeedButton(Sender).Tag;
    FMenu.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
  end;
  //если это не группа
  //то не скрываем
  if FCommands.Items[TSpeedButton(Sender).Font.Height].FParent <> nil then
    FAddPanel.Visible:=false;
end;

//выполняем операцию тулбара
//по индексу
procedure TCRFastActionsNew.ExecuteActionByIndex(Index:Integer);
begin
  if Index >= FButtons.Count then
    Exit;
  FButtons[Index].Click;
end;

//обработчик для групповых
//выводов
procedure TCRFastActionsNew.GroupVisibleEvent(Sender:TObject);
var
  Action:TCRFastAction;
  LinkParent:TCRFastAction;
  SpeedButton:TSpeedButton;
  IEIO:TImageEnIO;
begin
  //для адекватной обработки
  //скрытия дополнительной панели
  //на манер обычного меню
  if FAddPanel.Visible and (FLastButtonCliked = Sender) then
  begin
    FAddPanel.Visible:=false;
    Exit;
  end;
  Action:=FCommands.Items[TSpeedButton(Sender).Font.Height];
  FAddPanel.Left:=FPanel.Left+TSpeedButton(Sender).Left;
  FAddPanel.Top:=FPanel.Top+FPanel.Height;
  FAddPanel.Width:=39;
  FAddPanel.Height:=0;
  if Assigned(FAddButtons) then
    FreeAndNil(FAddButtons);
  FAddButtons:=TObjectList<TSpeedButton>.Create;
  for LinkParent in FCommands do
  begin
    if LinkParent.Parent = Action then
    begin
      //рисуем кнопку на дополнительной панели
      FAddPanel.Height:=FAddPanel.Height+39;
      SpeedButton:=TSpeedButton.Create(nil);
      SpeedButton.Parent:=FAddPanel;
      SpeedButton.Width:=38;
      SpeedButton.Height:=38;
      SpeedButton.Top:=FAddPanel.Height-SpeedButton.Height;
      SpeedButton.OnClick:=LinkParent.Click;
      SpeedButton.Hint:=LinkParent.Title;
      SpeedButton.ShowHint:=true;
      SpeedButton.OnMouseUp:=MouseUpAddPanel;
      IEIO:=TImageEnIO.Create(nil);
      IEIO.AttachedBitmap:=SpeedButton.Glyph;
      IEIO.LoadFromFile(PathToProgramDir+'data\toolbar\'+LinkParent.ImageName);
      IEIO.Free;
      FAddButtons.Add(SpeedButton);
    end;
  end;
  FAddPanel.Visible:=true;
  FLastButtonCliked:=TSpeedButton(Sender);
  //если основная панель не отображена
  //то показываем
  if not FPanel.Visible then
  begin
    Self.Show;
    SetCursorPos(
        (FormMain.Left+FAddPanel.Left)+20,
        (FormMain.Top+FAddPanel.Top)+40
      );
  end;
end;

//обработчик для скрытия
//дополнительного тулбара
//при любом нажатии кнопок
procedure TCRFastActionsNew.MouseUpAddPanel(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //чистим кнопки
  FreeAndNil(FAddButtons);
  //убираем панель
  FAddPanel.Visible:=false;
end;

{$ENDREGION}

{$REGION 'Служебные функции'}

//инициализируем быстрые действия
procedure InitFastActions;
begin
  FastActions:=TCRFastActionsNew.Create;
  //отображаем панель
  FastActions.Show;
end;

//деинициализируем быстрые действия
procedure DeInitFastActions;
begin
  FastActions.Free;
end;

{$ENDREGION}

end.
