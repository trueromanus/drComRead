{
  drComRead

  ������ ����������
  ��������, ����������
  � �������

  Copyright (c) 2008-2012 Romanus
}
unit CRGlobal;

interface

uses
  Dialogs, ExtCtrls, IniFiles, Classes,
  CRDir, CRImageVisual, RGBCurvesdiagrammer, CRFastActions, CRLog,
  CRPlugins, SQLiteTable3;

const
  //������ �����������
                 //Jpeg and family images and JPEG2000
  IMAGE_FILTER = '*.jpg;*.jpeg;*.jpe;*.jif;*.jp2;' +
                 //PaintBrush PCX and DICOM Images
                 '*.pcx;*.dcm;*.dic;*.dicom;*.v2;' +
                 //Windows standart, web images
                 '*.bmp;*.wmf;*.emf;*.gif;*.png;' +
                 //Tiff, Photoshop PSD
                 '*.tiff;*.tif;*.fax;*.g3n;*.g3f;*.xif;*.psd;' +
                 //Targa images
                 '*.tga;*.targa;*.vda;*.icb;*.vst;*.pix' +
                 //Multipage PCX and Microsoft HD Photo
                 '*.dcx;*.wdp;*.hdp;' +
                 //Wireless Bitmap
                 '*.wbmp';
  ARC_FILTER   = '*.rar;*.zip;*.cbr;*.cbz;*.7z;*.gz;*.arj;*.tar';
  //������ ���������
  PROGRAM_VERSION         =         '0.14.2a';
  //�������� ������
  //� ���������������� �����
  CONFIG_MAINSECTION      =         'MAIN';

  {$REGION '������ ��������� �����������'}
  
  //������ �����������
  //��������
  IMAGE_MODE_ORIGINAL     =         0;
  //���������������
  IMAGE_MODE_SCALE        =         1;
  //������������ �� ������
  IMAGE_MODE_STRETCH      =         2;
  //������������ �� ������
  IMAGE_MODE_HEIGHT       =         3;
  //��������� ������������
  IMAGE_MODE_USER         =         4;
  //�������������� ������������
  IMAGE_MODE_AUTOSIZE     =         5;

  {$ENDREGION}

var
  {$REGION '�������'}

  //������ ��������
  OpenDialog:TOpenDialog;
  //������ ������ ���
  //������ � �������
  DirObj:TCRDir;
  //������ ��� ������
  //� �������� �����������
  ActiveScroll:TCRActiveScroll;
  //������ ���
  //������������ ��������
  ASSleepTimer:TTimer;
  //���������������� ����
  GlobalConfigData:TMemIniFile;
  //�������������� ����
  GlobalLangData:TMemIniFile;
  //������ ��� ���������
  //�����������
  MainCurves:TRGBCurves;
  //����������
  //������� ��������
  FastActions:TCRFastActionsNew;
  //������ ������������
  //��������
  Addons:TCRPlugins;
  //����� ��� ��������� �������� �����������
  ImageResizer:TCRImageResizer;
  //��� ���������
  LogProgram:TCRLog;
  //�������� ���� ������
  //��� ������ � ������
  //������� � ��������
  ComReadDataBase:TSQLiteDatabase;


  {$ENDREGION}  

  {$REGION '����'}

  //���� � �������� ��������
  //��� ����������������
  PathToBaseDir:WideString;
  //���� � �������� ���������
  PathToProgramDir:String;

  {$ENDREGION}

  {$REGION '�������������� ���������'}

  //����� �����������
  //��� ��������
  ImageMode:Byte = 0;
  //����� �����������
  //��� ����������
  //������������ �����
  ImageModeLandscape:Byte = 0;
  //����� ���������������
  //��� ��������������� ���������
  ImageModeTwoPage:Byte = 0;
  //����� ����������
  SortFileMode:Byte = 0;
  //������� ��� ������� ��������
  OPENDIALOG_FILTER:WideString;
  //���� �������� ����
  //������������� ��������
  FlagLAOpened:boolean;
  
  {$ENDREGION}

  {$REGION '������������ ���������'}

  //�������������� ��
  //���� ��� ������
  StartMinimize:Boolean;
  //�������� �� ��� ������
  //������� �����������
  StartActiveScroll:Boolean;
  //���������������� ���������� ����
  SensivityMouseMove:Integer = 40;
  //������������� �����
  FullScreenOpened:Boolean = false;
  //����� � ������ � ����������������� �������
  MainConfigFile:Integer;
  //��� ����� � ��������� �������
  NameLanguageFile:WideString = 'default.lng';
  //��������� �� ���������
  DefaultMessage:String;
  //�������� �� �������
  EnableHistory:Boolean = false;
  //������� �� ����� �������
  //������������� �����������
  EnableSoftScrollMode:Boolean = true;
  //������� �� ����� ������
  EnableTrace:Boolean = true;

  {$ENDREGION}

  //��������� ���������
  StartParameters:boolean = true;
  //����� ������ � �������� ������
  MainLangHandle:Integer;

//������ ������ � �������
//�������� ������
function GetOpenDialog:TOpenDialog;
//������ ����� ��� �� ����������
//�������� ��������
function ReadBoolConfig(NameParam:String):Boolean;
//������ ����� � ��������� ������ �� ����������
//�������� ��������
function ReadFloatConfig(NameParam:String):Double;
//������ ����� �� ����������
//�������� ��������
function ReadIntConfig(NameParam:String):Integer;
//������ ������ �� ����������
//�������� ��������
function ReadStringConfig(NameParam:String):String;
//������ �������� ��
//����� � ��������� �������
function ReadLang(Group,Name:String):String;
//����� ������� ���
//���������� ������
function MainSortFiles(Mode:Byte):Boolean;
//������ � ���
procedure PrintToLog(Msg:String;const Group:String = '');
//������ � ��� ������
procedure PrintErrorToLog(Msg:String;const Group:String = '');
//������ � ��� ����������� ������
procedure PrintCriticalErrorToLog(Msg:String;const Group:String = '');
//������ � ��� ��������� ������
procedure PrintSystemToLog(Msg:String);

implementation

uses
  Forms, SysUtils, DLLHeaders, Windows;

//������ ������ � �������
//�������� ������
function GetOpenDialog:TOpenDialog;
begin
  if OpenDialog = nil then
  begin
    OpenDialog:=TOpenDialog.Create(nil);
    //������������� �����
    OpenDialog.Options:=[ofAllowMultiSelect];
    OpenDialog.Filter:=OPENDIALOG_FILTER;
  end;
  Result:=OpenDialog;
end;

//������ ����� ��� �� ����������
//�������� ��������
function ReadBoolConfig(NameParam:String):Boolean;
begin
  Result:=GlobalConfigData.ReadBool(CONFIG_MAINSECTION,NameParam,false);
end;

//������ ����� � ��������� ������ �� ����������
//�������� ��������
function ReadFloatConfig(NameParam:String):Double;
begin
  Result:=GlobalConfigData.ReadFloat(CONFIG_MAINSECTION,NameParam,0);
end;

//������ ����� �� ����������
//�������� ��������
function ReadIntConfig(NameParam:String):Integer;
begin
  Result:=GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,NameParam,0);
end;

//������ ������ �� ����������
//�������� ��������
function ReadStringConfig(NameParam:String):String;
begin
  Result:=GlobalConfigData.ReadString(CONFIG_MAINSECTION,NameParam,'');
end;

//������ �������� ��
//����� � ��������� �������
function ReadLang(Group,Name:String):String;
begin
  Result:=GlobalLangData.ReadString(Group,Name,'');
end;

//����� ������� ���
//���������� ������
function MainSortFiles(Mode:Byte):Boolean;
begin
  Result:=SortFilesMainFunc(0);
end;

//������ � ���
procedure PrintToLog(Msg:String;const Group:String = '');
begin
  if EnableTrace then
    LogProgram.Print(Msg,Group);
end;

//������ � ��� ������
procedure PrintErrorToLog(Msg:String;const Group:String = '');
begin
  if EnableTrace then
    LogProgram.PrintError(Msg,Group);
end;

//������ � ��� ����������� ������
procedure PrintCriticalErrorToLog(Msg:String;const Group:String = '');
begin
  if EnableTrace then
    LogProgram.PrintCritical(Msg,Group);
end;

//������ � ��� ���������� ���������
procedure PrintSystemToLog(Msg:String);
begin
  if EnableTrace then
    LogProgram.PrintSystem(Msg);
end;

end.
