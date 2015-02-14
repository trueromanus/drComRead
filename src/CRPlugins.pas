{
  drComRead

  ������ ��� ����������
  ������������ �������

  Copyright (c) 2011 Romanus
}
unit CRPlugins;

interface

uses
  Generics.Collections, Classes;

const
  NAME_CONST_SECTION        =           'ADDONS';

type
  //����� ��� ��������
  //������������� ������
  TCRPlugin = class
  private
    //�������������
    FInit:function(Language:PWideChar):Boolean;stdcall;
    //�������� ����
    FTitle:function:PWideChar;stdcall;
    //������ �������
    FVersionS:function:PWideChar;stdcall;
    //������ ������
    FVersionI:function:Integer;stdcall;
    //��������� ���� � ������
    FIcon:function:PWideChar;stdcall;
    //��������� �������� �������
    FExecute:function:Boolean;stdcall;
    //���������������
    FDeInit:function:Boolean;stdcall;
    //����� ����������
    FLibHandle:Cardinal;
    //���� � ����������
    FPathToLib:string;
  public
    //�����������
    constructor Create(DllName:String);
    //����������
    destructor Destroy;override;
    //�������� �������� �������
    function GetTitle:String;
    //�������������
    function Init:Boolean;
    //��������� ������
    procedure Execute;
  end;

  TCRPlugins = class
  private
    //������ ��������
    FList:TObjectList<TCRPlugin>;
    //�������� ���������� ������
    function ReadSection:TStrings;
    //���������� �������
    //��� ������� ����
    procedure ClickEvent(Sender:TObject);
  public
    //���������� ������
    //� ���������
    property Sections:TStrings read ReadSection;
    //�����������
    constructor Create;
    //����������
    destructor Destroy;override;
    //�������� ������
    function AddPlugin(DllName:String):Boolean;
    //��������� ������ ��
    //��������
    function LoadSettings:Boolean;
  end;

implementation

uses
  Windows, SysUtils, CRGlobal, Menus, MainForm;

{$REGION 'TCRPlugin - ����� �������� �������'}

//�����������
constructor TCRPlugin.Create(DllName:String);
begin
  //���������� ����������
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
  //��� ������� ������ ������������
  if (@FInit = nil) or
     (@FExecute = nil) or
     (@FTitle = nil) or
     (@FVersionS = nil) or
     (@FVersionI = nil) or
     (@FIcon = nil) or
     (@FDeInit = nil) then
     raise Exception.Create('Not load functions at plugin ' + DllName);
end;

//����������
destructor TCRPlugin.Destroy;
begin
  FDeInit();
  if FLibHandle <> 0 then
    FreeLibrary(FLibHandle);
end;

//�������� �������� �������
function TCRPlugin.GetTitle:String;
begin
  Result:=FTitle();
end;

//�������������
function TCRPlugin.Init:Boolean;
begin
  try
    Result:=FInit(PWideChar(FPathToLib));
  except
    Result:=false;
  end;
end;

//��������� ������
procedure TCRPlugin.Execute;
begin
  try
    FExecute();
  except
    //�� ������ ������ :)
  end;
end;

{$ENDREGION}

{$REGION 'TCRPlugins - ����� �������� ������ ��������'}

//�������� ���������� ������
function TCRPlugins.ReadSection:TStrings;
begin
  Result:=TStringList.Create;
  GlobalConfigData.ReadSectionValues(NAME_CONST_SECTION,Result);
end;

//���������� �������
//��� ������� ����
procedure TCRPlugins.ClickEvent(Sender:TObject);
var
  MenuItem:TMenuItem;
begin
  if Sender.ClassType <> TMenuItem then
    Exit;
  MenuItem:=TMenuItem(Sender);
  if MenuItem.Tag < 0 then
    Exit;
  //��������� ������
  //�������� ������
  FList[MenuItem.Tag].Execute;
end;

//�����������
constructor TCRPlugins.Create;
begin
  FList:=TObjectList<TCRPlugin>.Create;
end;

//����������
destructor TCRPlugins.Destroy;
begin
  FList.Clear;
  FList.Free;
end;

//�������� ������
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

//��������� ������ ��
//��������
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
      //��������� ������ � ����
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
