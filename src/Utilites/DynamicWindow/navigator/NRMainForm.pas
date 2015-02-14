{
  drComRead

  Модуль c формой
  навигатора

  Copyright (c) 2008-2012 Romanus
}
unit NRMainForm;

interface

uses
  Windows, SysUtils, Classes, Forms, Dialogs,
  StdCtrls, Buttons, Controls, ExtCtrls, jpeg, Menus, ScreenTips,
  ComCtrls, InfoForm, Graphics;

const
  NameLanguageGroup:PWideChar  = 'navigator';

type
  TCRNavigator = class(TForm)
    FocusPanel: TPanel;
    DragPanel: TPanel;
    UpPanel: TPanel;
    UpImage: TImage;
    LeftPanel: TPanel;
    RightPanel: TPanel;
    DownPanel: TPanel;
    RightImage: TImage;
    DownImage: TImage;
    LeftImage: TImage;
    ActiveScrollPanel: TPanel;
    RotateSavePanel: TPanel;
    PosCountImagesPanel: TPanel;
    UpdateTimer: TTimer;
    CountPosImage: TImage;
    CountPosLabel: TLabel;
    ActiveScrollImage: TImage;
    ActiveScrollLabel: TLabel;
    RotateSaveImage: TImage;
    RotateSaveLabel: TLabel;
    FuncImage: TImage;
    FuncLabel: TLabel;
    FuncPanel: TPanel;
    PrevArchive: TImage;
    NextArchive: TImage;
    UpNavigationImage: TImage;
    NextArchiveToolTip: TScreenTipsPopup;
    ToolTipsManager: TScreenTipsManager;
    PrevArchiveToolTip: TScreenTipsPopup;
    DownNavigationImage: TImage;
    MenuActionsToolTip: TScreenTipsPopup;
    NavigateStartToolTip: TScreenTipsPopup;
    NavigateEndToolTip: TScreenTipsPopup;
    NavigatePrevToolTip: TScreenTipsPopup;
    NavigateNextToolTip: TScreenTipsPopup;
    ActiveScrollTip: TScreenTipsPopup;
    CenterPanelToolTip: TScreenTipsPopup;
    UpArchiveNavigation: TImage;
    DownArchiveNavigation: TImage;
    NavigateArcStart: TScreenTipsPopup;
    NavigateArcEnd: TScreenTipsPopup;
    ListElementsTrackBar: TTrackBar;
    TypeListComboBox: TComboBox;
    TrackBarHelpTooltip: TScreenTipsPopup;
    RightDownPanelHider: TPanel;
    LeftDownPanelHider: TPanel;
    LeftUpPanelHider: TPanel;
    RightUpPanelHider: TPanel;
    LeftUpPanelHide: TScreenTipsPopup;
    LeftDownPanelHide: TScreenTipsPopup;
    RightUpPanelHide: TScreenTipsPopup;
    RightDownPanelHide: TScreenTipsPopup;
    DownPanelPanel: TPanel;
    UpPanelPanel: TPanel;
    UpArcPanelPanel: TPanel;
    DownArcPanelPanel: TPanel;
    PanelNumberPages: TPanel;
    GetPosListElementsLabel: TLabel;
    ImageBackgroundCountPages: TImage;
    CountListElementsLabel: TLabel;
    ImageDragPanel: TImage;
    ImageRightDown: TImage;
    ImageLeftDownHide: TImage;
    ImageLeftUpHide: TImage;
    ImageRightUpHide: TImage;
    UpdateShowTimer: TTimer;
    procedure FormPaint(Sender: TObject);
    procedure DragPanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DragPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DragPanelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure LeftImageClick(Sender: TObject);
    procedure RightImageClick(Sender: TObject);
    procedure UpImageClick(Sender: TObject);
    procedure DownImageClick(Sender: TObject);
    procedure ActiveScrollPanelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure UpdateTimerTimer(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PrevArchiveClick(Sender: TObject);
    procedure NextArchiveClick(Sender: TObject);
     procedure UpNavigationImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DownNavigationImageMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DownNavigationImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DownArchiveNavigationClick(Sender: TObject);
    procedure UpArchiveNavigationClick(Sender: TObject);
    procedure PrevArchiveMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TypeListComboBoxChange(Sender: TObject);
    procedure ListElementsTrackBarChange(Sender: TObject);
    procedure RightDownPanelHiderClick(Sender: TObject);
    procedure LeftDownPanelHiderClick(Sender: TObject);
    procedure LeftUpPanelHiderClick(Sender: TObject);
    procedure RightUpPanelHiderClick(Sender: TObject);
    procedure UpdateShowTimerTimer(Sender: TObject);
  public
    procedure RebuildWindowRgn;
    procedure Moving;
    //обновляем данные для
    //правой нижней панели
    procedure UpdateRightDownPanel;
    //Для общего скрытия панелей
    //верхняя левая
    procedure ShowHideLeftUpPanel;
    //верхняя правая
    procedure ShowHideRightUpPanel;
    //нижняя левая
    procedure ShowHideLeftDownPanel;
    //нижняя правая
    procedure ShowHideRightDownPanel;
  end;

const
  IMAGE_FILTER    = 'BMP|*.bmp';
var
  CRNavigator:TCRNavigator;
  MovX,MovY:Integer;
  DragForm:Boolean;
  Iter:Integer = 0;
  SaveDialog:TSaveDialog;
  //строки для вывода
  //переключателя активного
  //скролинга
  OnActiveScrollString:String = 'On';
  OffActiveScrollString:String = 'Off';
  //новая позиция
  //для перемещения
  NewPosition:Integer = -1;
  //нажата левая кнопка
  //мыши
  GetClickedNavigation:Integer = 0;
  //количество попыток
  //для отображения навигатора
  //CounterShow:Integer = 0;

procedure MultiLanguageCreateHint(NameKey:WideString;Elem:TScreenTipsPopup);

//загружаем языковые данные
procedure MultiLanguageLoad;

implementation

uses
  MainProgramHeader;

{$R *.dfm}

{$REGION 'Служебные функции'}

//выравниваем информационную форму
procedure AlignInfoForm;
begin
  if not Assigned(InfoListForm) then
    Exit;
  with InfoListForm do
  begin
    //выставляем положение
    Left:=CRNavigator.Left+CRNavigator.ListElementsTrackBar.Left;
    Top:=CRNavigator.Top+CRNavigator.ListElementsTrackBar.Top+CRNavigator.ListElementsTrackBar.Height;
  end;
end;

//отображаем и
//выводим текст в форме
procedure ShowAndTextInfoForm(Msg:String);
begin
  //если форма не создана
  //то создаем и привязываем
  //к основному окну
  if not Assigned(InfoListForm) then
    InfoListForm:=TInfoListForm.Create(CRNavigator);
  //выравниваем форму
  AlignInfoForm;
  with InfoListForm do
  begin
    //выставляем положение
    {Left:=CRNavigator.Left+CRNavigator.ListElementsTrackBar.Left;
    Top:=CRNavigator.Top+CRNavigator.ListElementsTrackBar.Top+CRNavigator.ListElementsTrackBar.Height;}
    //чистим список
    PanelNameFile.Caption:=Msg;
    //признак видимости
    Visible:=true;
    //отображаем форму
    Show;
  end;
end;

//меняем на новую позицию
//для перемещения
procedure ChangeNewPosition(Exp:Integer);
var
  GetPos,
  Count:Integer;
begin
  GetClickedNavigation:=Exp;
  Count:=ListImage_Count;
  if NewPosition = -1 then
    GetPos:=Navigation_Position
  else
    GetPos:=NewPosition;
  GetPos:=GetPos+Exp;
  //режем по рамкам
  if GetPos < 0 then
    GetPos:=0;
  if GetPos >= Count then
    GetPos:=Count-1;
  NewPosition:=GetPos;
end;

//загружаем языковые данные
procedure MultiLanguageLoad;
begin
  CRNavigator.RotateSaveLabel.Caption:=MultiLanguage_GetGroupValue('navigator','action90rotate');
  //кнопка для управления
  //архивами
  CRNavigator.NextArchiveToolTip.ScreenTip.Header:=MultiLanguage_GetGroupValue('navigator','nextarchive');
  CRNavigator.PrevArchiveToolTip.ScreenTip.Header:=MultiLanguage_GetGroupValue('navigator','prevarchive');
  //кнопка для управлением
  //активным скролингом
  OnActiveScrollString:=MultiLanguage_GetGroupValue('navigator','onactivescroll');
  OffActiveScrollString:=MultiLanguage_GetGroupValue('navigator','offactivescroll');
  with CRNavigator do
  begin
    //первое изображение
    MultiLanguageCreateHint('navigatestart',NavigateStartToolTip);
    //последнее изображение
    MultiLanguageCreateHint('navigateend',NavigateEndToolTip);
    //предыдущее изображение
    MultiLanguageCreateHint('navigateprev',NavigatePrevToolTip);
    //следующее изображение
    MultiLanguageCreateHint('navigatenext',NavigateNextToolTip);
    //панель активной прокрутки
    MultiLanguageCreateHint('activescrollbutton',ActiveScrollTip);
    //центральная панель
    MultiLanguageCreateHint('centralpanel',CenterPanelToolTip);
    //панели для скрытия
    //других панелей :)
    MultiLanguageCreateHint('leftuphide',LeftUpPanelHide);
    MultiLanguageCreateHint('rightuphide',RightUpPanelHide);
    MultiLanguageCreateHint('leftdownhide',LeftDownPanelHide);
    MultiLanguageCreateHint('rightdownhide',RightDownPanelHide);
  end;
  with CRNavigator do
  begin
    TypeListComboBox.Items.Clear;
    TypeListComboBox.Items.Add(WideString(MultiLanguage_GetGroupValue(NameLanguageGroup,'imageslist')));
    TypeListComboBox.Items.Add(WideString(MultiLanguage_GetGroupValue(NameLanguageGroup,'arhiveslist')));
  end;
end;

procedure MultiLanguageCreateHint(NameKey:WideString;Elem:TScreenTipsPopup);
var
  ConfigStr:WideString;
begin
  ConfigStr:=MultiLanguage_GetGroupValue(NameLanguageGroup,PWideChar(NameKey));
  with Elem.ScreenTip do
  begin
    Header:=copy(ConfigStr,0,Pos(';',ConfigStr)-1);
    Description.Clear;
    Description.Add(copy(ConfigStr,Pos(';',ConfigStr)+1,Length(ConfigStr)));
  end;
end;

{$ENDREGION}

{$REGION 'Навигация по списку изображений'}

procedure NavigationCommand(Mode:Byte);
begin
  case Mode of
    0:Navigation_StartImage;
    1:Navigation_NextImage;
    2:Navigation_EndImage;
    3:Navigation_PrevImage;
    4:Navigation_StartArc;
    5:Navigation_EndArc;
    6:Navigation_NextArc;
    7:Navigation_PrevArc;
  end;
  CRNavigator.UpdateRightDownPanel;
end;

procedure TCRNavigator.RightImageClick(Sender: TObject);
begin
  NavigationCommand(2);
end;

procedure TCRNavigator.UpdateTimerTimer(Sender: TObject);
var
  GetPos,Count:Integer;
  AGetPos,ACount:Integer;
begin
  //Позиция в списке изображений
  GetPos:=Navigation_Position;
  if GetPos <> -1 then
    GetPos:=GetPos+1
  else
    GetPos:=0;
  Count:=ListImage_Count;
  if NewPosition <> -1 then
    CountPosLabel.Caption:=IntToStr(NewPosition+1) + '/' + IntToStr(GetPos)+'/'+IntToStr(Count)
  else
    CountPosLabel.Caption:=IntToStr(GetPos)+'/'+IntToStr(Count);
  //Активный скролинг
  if Scrolling_GetActiveScroll then
    ActiveScrollLabel.Caption:=OnActiveScrollString
  else
    ActiveScrollLabel.Caption:=OffActiveScrollString;
  //Списки архивов
  //скрываем управляюшие
  //элементы
  PrevArchive.Visible:=false;
  NextArchive.Visible:=false;
  //если архивы есть
  if GetArchivesCount <> 0 then
  begin
    AGetPos:=GetArchivPosition;
    ACount:=GetArchivesCount-1;
    if AGetPos < ACount then
    begin
      NextArchive.Visible:=true;
      NextArchiveToolTip.ScreenTip.Description.Clear;
      NextArchiveToolTip.ScreenTip.Description.Add(ExtractFileName(GetArchiv(AGetPos+1)));
    end;
    if AGetPos > 0 then
    begin
      PrevArchive.Visible:=true;
      PrevArchiveToolTip.ScreenTip.Description.Clear;
      PrevArchiveToolTip.ScreenTip.Description.Add(ExtractFileName(GetArchiv(AGetPos-1)));
    end;
  end;
  //если жмем на кнопку
  //перехода между изображениями
  //то выполняем переход
  //и без отпускания
  if GetClickedNavigation <> 0 then
    ChangeNewPosition(GetClickedNavigation);
end;

procedure TCRNavigator.UpdateShowTimerTimer(Sender: TObject);
begin
  if TypeListComboBox.DroppedDown then
    Exit;
  if Self.Visible and Window_FullScreenMode then
  begin
    Self.Show;
    if Assigned(InfoListForm) and InfoListForm.Visible then
      InfoListForm.Show;
  end;
end;

procedure TCRNavigator.UpImageClick(Sender: TObject);
begin
  NavigationCommand(3);
end;

procedure TCRNavigator.UpNavigationImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  GetClickedNavigation:=1;
  if Button = mbLeft then
    ChangeNewPosition(-1);
  //если среднюю
  //то закрываем навигатор
  if Button = mbMiddle then
    Self.Close;
end;

procedure TCRNavigator.DownNavigationImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  GetClickedNavigation:=1;
  if Button = mbLeft then
    ChangeNewPosition(1);
  //если среднюю
  //то закрываем навигатор
  if Button = mbMiddle then
    Self.Close;
end;

procedure TCRNavigator.DownNavigationImageMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  GetClickedNavigation:=0;
end;

procedure TCRNavigator.LeftImageClick(Sender: TObject);
begin
  NavigationCommand(0);
end;

procedure TCRNavigator.DownArchiveNavigationClick(Sender: TObject);
begin
  if GetArchivesCount = 0 then
    Exit;
  if GetArchivPosition < (GetArchivesCount-1) then
    NavigationCommand(5);
end;

procedure TCRNavigator.UpArchiveNavigationClick(Sender: TObject);
begin
  if GetArchivPosition > 0 then
    NavigationCommand(4);
end;

procedure TCRNavigator.DownImageClick(Sender: TObject);
begin
  NavigationCommand(1);
end;

procedure TCRNavigator.NextArchiveClick(Sender: TObject);
begin
  NavigationCommand(6);
end;

procedure TCRNavigator.PrevArchiveClick(Sender: TObject);
begin
  NavigationCommand(7);
end;

procedure TCRNavigator.PrevArchiveMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbMiddle then
    Self.Close;
end;

{$ENDREGION}

{$REGION 'Визуализация'}

procedure TCRNavigator.FormDestroy(Sender: TObject);
begin
  MovX:=0;
  MovY:=0;
  if Assigned(InfoListForm) then
    InfoListForm.Free;
end;

procedure TCRNavigator.FormHide(Sender: TObject);
begin
  Self.UpdateTimer.Enabled:=false;
  NewPosition:=-1;
  if Assigned(InfoListForm) then
    InfoListForm.Visible:=false;
end;

procedure TCRNavigator.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //если нажали
  //среднюю кнопку
  //то закрываем окно
  if Button=mbMiddle then
    Self.Close;
  if Button=mbRight then
  begin
    //ToDo:выводим поле для ручного ввода
    //номера страницы
  end;
  if (Button=mbLeft) and (NewPosition <> -1) then
  begin
    Navigation_NewPosition(NewPosition);
    Self.Close;
  end;
end;

procedure TCRNavigator.FormPaint(Sender: TObject);
begin
  RebuildWindowRgn;
end;

procedure TCRNavigator.FormShow(Sender: TObject);
begin
  Self.UpdateTimer.Enabled:=true;
  Self.FormStyle:=fsStayOnTop;
end;

procedure TCRNavigator.RebuildWindowRgn;
var
  FullRgn, Rgn: THandle;
  ClientX, ClientY, i: integer;
begin
  ClientX:=(Width-ClientWidth) div 2;
  ClientY:=Height-ClientHeight-ClientX;

  FullRgn:=CreateRectRgn(0,0,Width,Height);
  Rgn:=CreateRectRgn(ClientX,ClientY,ClientX+ClientWidth,
  ClientY+ClientHeight);

  CombineRgn(FullRgn,FullRgn,Rgn,RGN_DIFF);

  for i:=0 to ControlCount-1 do
    with Controls[i] do
    begin
      Rgn:=CreateRectRgn(ClientX+Left,ClientY+Top,
      ClientX+Left+Width,ClientY+Top+Height);
      CombineRgn(FullRgn,FullRgn,Rgn,RGN_OR);
    end;

  SetWindowRgn(Handle,FullRgn,true);
end;

procedure TCRNavigator.Moving;
var
  NewX:Integer;
  NewY:Integer;
begin
  MovX:=Mouse.CursorPos.X;
  MovY:=Mouse.CursorPos.Y;
  NewX:=Width-FocusPanel.Left;
  NewY:=Height-FocusPanel.Top;
  Left:=MovX-(NewX+5);
  Top:=MovY-(NewY-25);
end;

{$ENDREGION}

{$REGION 'Обработка ввода'}

procedure TCRNavigator.ActiveScrollPanelClick(Sender: TObject);
var
  Flag:Boolean;
begin
  if Scrolling_GetActiveScroll then
    Flag:=false
  else
    Flag:=true;
  Scrolling_SetActiveScroll(Flag);
end;

procedure TCRNavigator.DragPanelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ssLeft in Shift then
    DragForm:=true;
  if ssMiddle in Shift then
    Self.Close;
end;

procedure TCRNavigator.DragPanelMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if DragForm then
  begin
    Left:=Left+X-10;
    Top:=Top+Y-10;
  end;
  AlignInfoForm;
end;

procedure TCRNavigator.DragPanelMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  DragForm:=false;
end;

{$ENDREGION}

{$REGION 'Правая нижняя панель'}

procedure TCRNavigator.TypeListComboBoxChange(Sender: TObject);
var
  CountListElem:Integer;
  PositionList:Integer;
  GetFile:String;
begin
  CountListElem:=0;
  PositionList:=0;
  //обрабатываем соответствующий
  //список выбранный в выпадающем
  //селекте
  case TypeListComboBox.ItemIndex of
    //список изображений
    0:
      begin
        CountListElem:=ListImage_Count;
        PositionList:=Navigation_Position+1;
        GetFile:=ListImage_GetFileName(Navigation_Position);
      end;
    //список архивов
    1:
      begin
        CountListElem:=GetArchivesCount;
        PositionList:=GetArchivPosition+1;
        GetFile:=GetArchiv(GetArchivPosition);
      end;
  end;
  CountListElementsLabel.Caption:=IntToStr(CountListElem);
  ListElementsTrackBar.Min:=1;
  ListElementsTrackBar.Max:=CountListElem;
  ListElementsTrackBar.Position:=PositionList;
  //если количество элементов
  //больше нуля выводим текстовое поле
  if CountListElem <> 0 then
    ShowAndTextInfoForm(ExtractFileName(GetFile));
end;

procedure TCRNavigator.ListElementsTrackBarChange(Sender: TObject);
var
  GetName:WideString;
  CountElems:Integer;
begin
  GetPosListElementsLabel.Caption:=IntToStr(ListElementsTrackBar.Position);
  if TypeListComboBox.ItemIndex = 0 then
  begin
    GetName:=ListImage_GetFileName(ListElementsTrackBar.Position-1);
    CountElems:=ListImage_Count;
  end else
  begin
    GetName:=GetArchiv(ListElementsTrackBar.Position-1);
    CountElems:=GetArchivesCount;
  end;
  if CountElems = 0 then
    Exit;
  ShowAndTextInfoForm(ExtractFileName(GetName));
end;

//обновляем данные для
//правой нижней панели
procedure TCRNavigator.UpdateRightDownPanel;
var
  CountImages:Integer;
begin
  CountImages:=ListImage_Count;
  TypeListComboBox.ItemIndex:=0;
  if CountImages = 0 then
  begin
    ListElementsTrackBar.Min:=0;
    ListElementsTrackBar.Max:=0;
  end else
  begin
    ListElementsTrackBar.Max:=CountImages;
    ListElementsTrackBar.Min:=1;
    ListElementsTrackBar.Position:=Navigation_Position+1;
    GetPosListElementsLabel.Caption:=IntToStr(Navigation_Position+1);
    CountListElementsLabel.Caption:=IntToStr(CountImages);
    InfoListForm.Visible:=false;
  end;
end;

{$ENDREGION}

{$REGION 'Скрытие панелей'}

//верхняя левая
procedure TCRNavigator.ShowHideLeftUpPanel;
begin
  if ActiveScrollPanel.Left = 48 then
  begin
    ActiveScrollPanel.Left:=ActiveScrollPanel.Left + 500;
    MultiLanguage_SetConfigValue('navigatorleftup','0');
  end else
  begin
    ActiveScrollPanel.Left:=ActiveScrollPanel.Left - 500;
    MultiLanguage_SetConfigValue('navigatorleftup','-1');
  end;
  Self.Repaint;
end;

//верхняя правая
procedure TCRNavigator.ShowHideRightUpPanel;
begin
  if FuncPanel.Left = 183 then
  begin
    FuncPanel.Left:=FuncPanel.Left + 300;
    UpArchiveNavigation.Left:=UpArchiveNavigation.Left + 300;
    DownArchiveNavigation.Left:=DownArchiveNavigation.Left + 300;
    DownArcPanelPanel.Left:=DownArcPanelPanel.Left + 300;
    UpArcPanelPanel.Left:=UpArcPanelPanel.Left + 300;
    MultiLanguage_SetConfigValue('navigatorrightup','0');
  end else
  begin
    FuncPanel.Left:=FuncPanel.Left - 300;
    UpArchiveNavigation.Left:=UpArchiveNavigation.Left - 300;
    DownArchiveNavigation.Left:=DownArchiveNavigation.Left - 300;
    DownArcPanelPanel.Left:=DownArcPanelPanel.Left - 300;
    UpArcPanelPanel.Left:=UpArcPanelPanel.Left - 300;
    MultiLanguage_SetConfigValue('navigatorrightup','-1');
  end;
  Self.Repaint;
end;

//нижняя левая
procedure TCRNavigator.ShowHideLeftDownPanel;
begin
  if PosCountImagesPanel.Left = 48 then
  begin
    PosCountImagesPanel.Left:=PosCountImagesPanel.Left + 300;
    UpNavigationImage.Left:=UpNavigationImage.Left + 300;
    DownNavigationImage.Left:=DownNavigationImage.Left + 300;
    DownPanelPanel.Left:=DownPanelPanel.Left + 300;
    UpPanelPanel.Left:=UpPanelPanel.Left + 300;
    MultiLanguage_SetConfigValue('navigatorleftdown','0');
  end else
  begin
    PosCountImagesPanel.Left:=PosCountImagesPanel.Left - 300;
    UpNavigationImage.Left:=UpNavigationImage.Left - 300;
    DownNavigationImage.Left:=DownNavigationImage.Left - 300;
    DownPanelPanel.Left:=DownPanelPanel.Left - 300;
    UpPanelPanel.Left:=UpPanelPanel.Left - 300;
    MultiLanguage_SetConfigValue('navigatorleftdown','-1');
  end;
  Self.Repaint;
end;

//нижняя правая
procedure TCRNavigator.ShowHideRightDownPanel;
begin
  if RotateSavePanel.Left = 176 then
  begin
    PanelNumberPages.Left:=PanelNumberPages.Left + 300;
    RotateSavePanel.Left:=RotateSavePanel.Left + 300;
    GetPosListElementsLabel.Left:=GetPosListElementsLabel.Left + 300;
    CountListElementsLabel.Left:=CountListElementsLabel.Left + 300;
    ListElementsTrackBar.Left:=ListElementsTrackBar.Left + 300;
    MultiLanguage_SetConfigValue('navigatorrightdown','0');
  end else
  begin
    PanelNumberPages.Left:=PanelNumberPages.Left - 300;
    RotateSavePanel.Left:=RotateSavePanel.Left - 300;
    GetPosListElementsLabel.Left:=GetPosListElementsLabel.Left - 300;
    CountListElementsLabel.Left:=CountListElementsLabel.Left - 300;
    ListElementsTrackBar.Left:=ListElementsTrackBar.Left - 300;
    MultiLanguage_SetConfigValue('navigatorrightdown','-1');
  end;
  Self.Repaint;
end;

procedure TCRNavigator.LeftUpPanelHiderClick(Sender: TObject);
begin
  Self.ShowHideLeftUpPanel;
end;

procedure TCRNavigator.LeftDownPanelHiderClick(Sender: TObject);
begin
  Self.ShowHideLeftDownPanel;
end;

procedure TCRNavigator.RightUpPanelHiderClick(Sender: TObject);
begin
  Self.ShowHideRightUpPanel;
end;

procedure TCRNavigator.RightDownPanelHiderClick(Sender: TObject);
begin
  Self.ShowHideRightDownPanel;
end;

{$ENDREGION}

end.
