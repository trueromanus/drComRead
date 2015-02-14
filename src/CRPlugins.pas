{
  drComRead

  Модуль для реализации
  подключаемых модулей

  Copyright (c) 2011 Romanus
}
unit CRPlugins;

interface

uses
  Generics.Collections, Classes;

const
  NAME_CONST_SECTION        =           'ADDONS';

type
  //класс для описания
  //подключаемого модуля
  TCRPlugin = class
  private
    //инициализации
    FInit:function(Language:PWideChar):Boolean;stdcall;
    //название меню
    FTitle:function:PWideChar;stdcall;
    //версия строкой
    FVersionS:function:PWideChar;stdcall;
    //версия числом
    FVersionI:function:Integer;stdcall;
    //локальный путь к иконке
    FIcon:function:PWideChar;stdcall;
    //выполняем основной процесс
    FExecute:function:Boolean;stdcall;
    //деинициализация
    FDeInit:function:Boolean;stdcall;
    //хэндл библиотеки
    FLibHandle:Cardinal;
    //путь к библиотеке
    FPathToLib:string;
  public
    //конструктор
    constructor Create(DllName:String);
    //деструктор
    destructor Destroy;override;
    //получаем название плагина
    function GetTitle:String;
    //инициализация
    function Init:Boolean;
    //запускаем плагин
    procedure Execute;
  end;

  TCRPlugins = class
  private
    //список плагинов
    FList:TObjectList<TCRPlugin>;
    //получаем содержимое секции
    function ReadSection:TStrings;
    //обработчик нажатия
    //для пунктов меню
    procedure ClickEvent(Sender:TObject);
  public
    //содержимое секции
    //с плагинами
    property Sections:TStrings read ReadSection;
    //конструктор
    constructor Create;
    //деструктор
    destructor Destroy;override;
    //добавить плагин
    function AddPlugin(DllName:String):Boolean;
    //формируем список из
    //настроек
    function LoadSettings:Boolean;
  end;

implementation

uses
  Windows, SysUtils, CRGlobal, Menus, MainForm;

{$REGION 'TCRPlugin - класс описания плагина'}

//конструктор
constructor TCRPlugin.Create(DllName:String);
begin
  //подключаем библиотеку
  FLibHandle:=LoadLibrary(PWideChar(DllName));
  if FLibHandle = 0 then
    raise Exception.Create('Can''t load plugin ' + DllName);
  FPathToLib:=DllName;
  FInit:=GetProcAddress(FLibHandle,PWideChar('initfunc'));
  FExecute:=GetProcAddress(FLibHandle,PWideChar('executefunc'));
  FDeInit:=GetProcAddress(FLibHandle,PWideChar('deinitfunc'));
  FTitle:=GetProcAddress(FLibHandle,PWideChar('titlefunc'));
  FVersionS:=GetProcAddress(FLibHandle,PWideChar('stringversion'));
  FVersionI:=GetProcAddress(FLibHandle,PWideChar('intversion'));
  FIcon:=GetProcAddress(FLibHandle,PWideChar('iconfunc'));
  //все функции должны существовать
  if (@FInit = nil) or
     (@FExecute = nil) or
     (@FTitle = nil) or
     (@FVersionS = nil) or
     (@FVersionI = nil) or
     (@FIcon = nil) or
     (@FDeInit = nil) then
     raise Exception.Create('Not load functions at plugin ' + DllName);
end;

//деструктор
destructor TCRPlugin.Destroy;
begin
  FDeInit();
  if FLibHandle <> 0 then
    FreeLibrary(FLibHandle);
end;

//получаем название плагина
function TCRPlugin.GetTitle:String;
begin
  Result:=FTitle();
end;

//инициализация
function TCRPlugin.Init:Boolean;
begin
  try
    Result:=FInit(PWideChar(FPathToLib));
  except
    Result:=false;
  end;
end;

//запускаем плагин
procedure TCRPlugin.Execute;
begin
  try
    FExecute();
  except
    //на всякий случай :)
  end;
end;

{$ENDREGION}

{$REGION 'TCRPlugins - класс описания списка плагинов'}

//получаем содержимое секции
function TCRPlugins.ReadSection:TStrings;
begin
  Result:=TStringList.Create;
  GlobalConfigData.ReadSectionValues(NAME_CONST_SECTION,Result);
end;

//обработчик нажатия
//для пунктов меню
procedure TCRPlugins.ClickEvent(Sender:TObject);
var
  MenuItem:TMenuItem;
begin
  if Sender.ClassType <> TMenuItem then
    Exit;
  MenuItem:=TMenuItem(Sender);
  if MenuItem.Tag < 0 then
    Exit;
  //выполняем запуск
  //внешнего модуля
  FList[MenuItem.Tag].Execute;
end;

//конструктор
constructor TCRPlugins.Create;
begin
  FList:=TObjectList<TCRPlugin>.Create;
end;

//деструктор
destructor TCRPlugins.Destroy;
begin
  FList.Clear;
  FList.Free;
end;

//добавить плагин
function TCRPlugins.AddPlugin(DllName:String):Boolean;
var
  Plugin:TCRPlugin;
begin
  try
    Plugin:=TCRPlugin.Create(DllName);
    if Plugin.Init then
      FList.Add(Plugin)
    else
      Plugin.Free;
    Result:=true;
  except
    Result:=false;
  end;
end;

//формируем список из
//настроек
function TCRPlugins.LoadSettings:Boolean;
var
  GetPos:Integer;
  PathPlugin:String;
  StringPlugin:String;
  Strings:TStrings;
  MenuItem:TMenuItem;
  MaxLimit:Integer;
begin
  Strings:=Self.ReadSection;
  for GetPos:=0 to Strings.Count-1 do
  begin
    StringPlugin:=Strings[GetPos];
    PathPlugin:=Copy(StringPlugin,Pos('=',StringPlugin)+1,Length(StringPlugin));
    if AddPlugin(PathToProgramDir+PathPlugin) then
    begin
      if not FormMain.Menu_Addons.Visible then
      begin
        FormMain.Menu_Addons.Visible:=true;
        FormMain.MenuSeparator50.Visible:=true;
      end;
      MaxLimit:=FList.Count-1;
      //добавляем плагин в меню
      MenuItem:=TMenuItem.Create(nil);
      MenuItem.Caption:=FList[MaxLimit].GetTitle;
      MenuItem.Tag:=MaxLimit;
      MenuItem.OnClick:=ClickEvent;
      FormMain.Menu_Addons.Add(MenuItem);
    end;
  end;
  Strings.Free;
  Result:=true;
end;

{$ENDREGION}

end.
