{
  drComRead

  Панель для всех многофункциональных
  диалогов системы

  Copyright (c) 2012 Romanus
}
unit CRDialogPanel;

interface

uses
  ExtCtrls, Classes, Controls, Graphics, Generics.Collections,
  hyieutils, ImageEnIO;

type
  //обработчик события
  TCRDialogHandlerCheckEvent = procedure (var CheckResult:Boolean) of object;
  //внешняя привязка к диалогу
  TCRDialogHandlerExternal = function (Control:TWinControl):Boolean;

  //хэндлер
  TCRDialogHandler = class
  private
    //имя диалога
    FNameDialog:String;
    //иконка
    FIcon:TIEBitmap;
    //обработчик проверки
    //для вывода
    FCheckEvent:TCRDialogHandlerCheckEvent;
  protected
    //интегрируем контрол
    //из внешнего диалога
    procedure IntegrateWinControl(Control:TWinControl);
  public
    //обработчик проверки
    property OnCheck:TCRDialogHandlerCheckEvent read FCheckEvent write FCheckEvent;
    //иконка
    property Icon:TIEBitmap read FIcon;
    //имя диалога
    property NameDialog:String read FNameDialog;
    //конструктор
    constructor Create(NameDialog:String;IconPath:String);
    //деструктор
    destructor Destroy;override;
    //проверка на доступность
    //данного диалога
    function Check:Boolean;
  end;

  TCRDialogsPanel = class
  private
    //панель с диалогом
    //непосредственно
    FPanel:TPanel;
    //панель с управляющими
    //элементами, определяющими
    //то какие доступны диалоги
    //и собственно какой из диалогов активен
    FControlPanel:TPanel;
    //список контроллеров
    FHandlers:TObjectList<TCRDialogHandler>;
    //набор изображений
    //в панели
    FImages:TList<TImage>;
    //сортировка пунктов диалога
    FSorting:TDictionary<Integer,Integer>;
    //инициализация хэндлеров
    procedure InitHandlers;
    //открыт архив и есть картинки
    procedure IsArhiveAndImagesExists(var CheckResult:Boolean);
    //есть в списке картинки (неважно что открыто)
    procedure ImagesExists(var CheckResult:Boolean);
    //есть ли архивы в списке
    procedure ArchivesExists(var CheckResult:Boolean);
    //есть ли текстовые файлы
    procedure TxtFilesExists(var CheckResult:Boolean);
    //есть файл comread присутствует ли в архиве
    procedure ComReadFilesExists(var CheckResult:Boolean);
  protected
    //формируем список
    //доступных контроллеров
    procedure FormingHandlers;
    //обработчик картинки
    procedure ImageClickEvent(Sender:TObject);
  public
    //конструктор
    constructor Create(Parent:TWinControl;ParentHide:TWinControl);
    //деструктор
    destructor Destroy;override;
    //показать только контролы
    //доступные в данный момент
    procedure ShowOnlyControls;
    //показать диалог
    procedure ShowDialog(id:Integer);
  end;

//создаем диалог в контроле
procedure CreateDialogAtWinControl(Control:TWinControl;Name:String);

var
  DialogsLinksDynamic:TDictionary<String,TCRDialogHandlerExternal>;

implementation

uses
  SysUtils, CRGlobal, DLLHeaders;

{$REGION 'TCRDialogHandler'}

//интегрируем контрол
//из внешнего диалога
procedure TCRDialogHandler.IntegrateWinControl(Control:TWinControl);
begin
  CreateDialogAtWinControl(Control,FNameDialog);
end;

//конструктор
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

//деструктор
destructor TCRDialogHandler.Destroy;
begin
  FIcon.Free;
end;

//проверка на доступность
//данного диалога
function TCRDialogHandler.Check:Boolean;
begin
  if Assigned(FCheckEvent) then
    FCheckEvent(Result)
  else
    //пустой результат не может
    //быть положительным
    Result:=false;
end;

{$ENDREGION}

{$REGION 'TCRDialogsPanel'}

//инициализация хэндлеров
procedure TCRDialogsPanel.InitHandlers;
var
  SortDialog:TCRDialogHandler;
  SortArcDialog:TCRDialogHandler;
  InformationDialog:TCRDialogHandler;
  TxtDialog:TCRDialogHandler;
begin
  //диалог сортировки файлов
  SortDialog:=TCRDialogHandler.Create('sortdialog',PathToProgramDir+'Data\dpanel\imagesort.png');
  SortDialog.OnCheck:=ImagesExists;
  //диалог сортировки архивов
  SortArcDialog:=TCRDialogHandler.Create('sortarcdialog',PathToProgramDir+'Data\dpanel\archivesort.png');
  SortArcDialog.OnCheck:=ArchivesExists;
  //диалог текстовых файлов
  TxtDialog:=TCRDialogHandler.Create('txtdialog',PathToProgramDir+'Data\dpanel\textfiles.png');
  TxtDialog.OnCheck:=TxtFilesExists;
  //диалог информации о архиве
  InformationDialog:=TCRDialogHandler.Create('infodialog',PathToProgramDir+'Data\dpanel\infoarchive.png');
  InformationDialog.OnCheck:=ComReadFilesExists;

  //регистрируем в списке хендлеров
  FHandlers.Add(InformationDialog);
  FHandlers.Add(SortDialog);
  FHandlers.Add(SortArcDialog);
  FHandlers.Add(TxtDialog);
end;

//открыт архив и есть картинки
procedure TCRDialogsPanel.IsArhiveAndImagesExists(var CheckResult:Boolean);
begin
  {$IFDEF _CONSOLE_TESTRUNNER}
  CheckResult:=true;
  {$ELSE}
  CheckResult:=(DirObj.ArchiveOpened and DirObj.NotEmpty);
  {$ENDIF}
end;

//есть в списке картинки (неважно что открыто)
procedure TCRDialogsPanel.ImagesExists(var CheckResult:Boolean);
begin
  {$IFDEF _CONSOLE_TESTRUNNER}
  CheckResult:=true;
  {$ELSE}
  CheckResult:=DirObj.NotEmpty;
  {$ENDIF}
end;

//есть ли архивы в списке
procedure TCRDialogsPanel.ArchivesExists(var CheckResult:Boolean);
begin
  {$IFDEF _CONSOLE_TESTRUNNER}
  CheckResult:=true;
  {$ELSE}
  CheckResult:=(DirObj.Archives.Count > 0);
  {$ENDIF}
end;

//есть ли текстовые файлы
procedure TCRDialogsPanel.TxtFilesExists(var CheckResult:Boolean);
begin
  {$IFDEF _CONSOLE_TESTRUNNER}
  CheckResult:=true;
  {$ELSE}
  CheckResult:=(DirObj.TxtFiles.Count > 0);
  {$ENDIF}
end;

//есть файл comread присутствует ли в архиве
procedure TCRDialogsPanel.ComReadFilesExists(var CheckResult:Boolean);
begin
  {$IFDEF _CONSOLE_TESTRUNNER}
  CheckResult:=true;
  {$ELSE}
  CheckResult:=DirObj.ComReadInfoFile;
  {$ENDIF}
end;

//формируем список
//доступных контроллеров
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

//обработчик картинки
procedure TCRDialogsPanel.ImageClickEvent(Sender:TObject);
begin
  //выводим соответствующий диалог
  ShowDialog(TImage(Sender).Tag);
end;

//конструктор
constructor TCRDialogsPanel.Create(Parent:TWinControl;ParentHide:TWinControl);
begin
  //панель для диалога
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
  //панель для контрольных кнопокt
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

  //создаем хэндлеры
  InitHandlers;
end;

//деструктор
destructor TCRDialogsPanel.Destroy;
begin
  FImages.Free;
  FHandlers.Free;
end;

//показать только контролы
//доступные в данный момент
procedure TCRDialogsPanel.ShowOnlyControls;
begin
  //определяем количество
  //выводимых диалогов
  FormingHandlers;

  //показываем контрольную панель
  FControlPanel.Visible:=true;
end;

//показать диалог
procedure TCRDialogsPanel.ShowDialog(id:Integer);
begin
  //формируем диалоги
  //FormingHandlers;
  //не может идентификатора диалога
  //вне допустимого диапазона
  if id >= FHandlers.Count then
    raise Exception.Create('Incorrected index at dialog show');
  //показываем диалог
  FPanel.Visible:=true;
  FControlPanel.Visible:=true;
  CreateDialogAtWinControl(FPanel,FHandlers[id].NameDialog);
end;

{$ENDREGION}

//создаем диалог в контроле
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

