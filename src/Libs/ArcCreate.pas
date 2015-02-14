{
  drComRead

  ������� �������� �������

  Copyright (c) 2009-2011 Romanus
}
unit ArcCreate;

interface

uses
  Generics.Collections, sevenzip;

type
  TFuncCallBack = function:Boolean;

  {$REGION 'TArcCreate'}

  //������� �����
  //��� �������� �������
  TArcCreate = class
  private
    //������ ������
    FFiles:TList<string>;
    //������� ��������� ������
    FFunc:TFuncCallBack;
  public
    //������� ��������� ������
    property FuncCallBack:TFuncCallBack read FFunc;
    //�����������
    constructor Create;
    //����������
    destructor Destroy;override;
    //�������� ���� � ������
    procedure AddFile(FileName:string);
    //������������� �������
    //��� ������ ���������
    procedure SetFuncCallBack(Func:TFuncCallBack);
    //������� �����
    //�� ������ � ������
    function CreateArchive(FileName:String):Boolean;virtual;abstract;
  end;

  {$ENDREGION}

  {$REGION 'TArcCreateRar'}

  TArcCreateRar = class(TArcCreate)
  public
    //������� �����
    //�� ������ � ������
    function CreateArchive(FileName:String):Boolean;override;
  end;

  {$ENDREGION}

  {$REGION 'TArcCreateZip'}

  TArcCreateZip = class(TArcCreate)
  private
    FOutArchive:I7zOutArchive;
  public
    //������� �����
    //�� ������ � ������
    function CreateArchive(FileName:String):Boolean;override;
  end;

  {$ENDREGION}

  {$REGION 'TArcCreate7Zip'}

  TArcCreate7Zip = class(TArcCreate)
  private
    FOutArchive:I7zOutArchive;
  public
    //������� �����
    //�� ������ � ������
    function CreateArchive(FileName:String):Boolean;override;
  end;

  {$ENDREGION}

  {$REGION 'TArcCreatePdf'}

  TArcCreatePdf = class(TArcCreate)
  public
    //������� �����
    //�� ������ � ������
    function CreateArchive(FileName:String):Boolean;override;
  end;

  {$ENDREGION}

  {$REGION 'TArcCreateTiff'}

  TArcCreateTiff = class(TArcCreate)
  public
    //������� �����
    //�� ������ � ������
    function CreateArchive(FileName:String):Boolean;override;
  end;

  {$ENDREGION}

  {$REGION 'TArcCreateGif'}

  TArcCreateGif = class(TArcCreate)
  public
    //������� �����
    //�� ������ � ������
    function CreateArchive(FileName:String):Boolean;override;
  end;

  {$ENDREGION}

implementation

uses
  ShellAPI,
  SysUtils, Windows, Dialogs,
  ieview, iemview,
  CRGlobal, MainForm, ArcReCreate;

{$REGION 'TArcCreate'}

//�����������
constructor TArcCreate.Create;
begin
  FFiles:=TList<string>.Create();
end;

//����������
destructor TArcCreate.Destroy;
begin
  FFiles.Free;
end;

//�������� ���� � ������
procedure TArcCreate.AddFile(FileName:string);
begin
  FFiles.Add(FileName);
end;

//������������� �������
//��� ������ ���������
procedure TArcCreate.SetFuncCallBack(Func:TFuncCallBack);
begin
  FFunc:=Func;
end;

{$ENDREGION}

{$REGION 'TArcCreateRar'}

function ExecAndWait(const FileName, Params: String): boolean; export;
var
  StartInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  CmdLine: String;
begin
  { �������� ��� ����� ����� ���������, � ����������� ���� �������� � ������ Win9x }
  CmdLine := '"' + Filename + '" ' + Params;
  FillChar(StartInfo, SizeOf(StartInfo), #0);
  with StartInfo do
  begin
    cb := SizeOf(StartInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := SW_HIDE;
  end;
  Result := CreateProcessW(nil, PWideChar(CmdLine), nil, nil, false,
                          CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil,
                          PWideChar(ExtractFilePath(Filename)),StartInfo,ProcInfo);
  { ������� ���������� ���������� }
  if Result then
  begin
    WaitForSingleObject(ProcInfo.hProcess, INFINITE);
    { Free the Handles }
    CloseHandle(ProcInfo.hProcess);
    CloseHandle(ProcInfo.hThread);
  end;
end;

//������� �����
//�� ������ � ������
function TArcCreateRar.CreateArchive(FileName:String):Boolean;
var
  RarPath, GetString:String;
  Params:String;
begin
  RarPath:=ReadStringConfig('rar_console');
  if RarPath = '' then
  begin
    ShowMessage('Not exist rar console path option');
    Exit(false);
  end;
  //-r ���� ��� �������� ��������� �����
  Params:=' a "' + FileName + '" ';
  for GetString in FFiles do
    Params:=Params+'"'+GetString+'" ';
  ExecAndWait(RarPath,Params);
  Result:=true;
end;

{$ENDREGION}

{$REGION 'TArcCreateZip'}

function CallBackFunc(sender: Pointer; total: boolean; value: int64): HRESULT; stdcall;
begin
  Result:=0;
end;

//������� �����
//�� ������ � ������
function TArcCreateZip.CreateArchive(FileName:String):Boolean;
var
  GetString:String;
  BasicPath:String;
  NewPath:String;
  Index:Integer;
  LastIndex:Integer;
begin
  FOutArchive:=CreateOutArchive(CLSID_CFormatZip);
  FOutArchive.SetProgressCallback(@Self,CallBackFunc);
  BasicPath:=ExtractFilePath(FileName);
  BasicPath:=Copy(BasicPath,0,Length(BasicPath)-1);
  LastIndex:=0;
  for Index:=0 to Length(BasicPath)-1 do
    if BasicPath[Index] = '\' then
      LastIndex:=Index;
  NewPath:=Copy(BasicPath,LastIndex+1,Length(BasicPath)) + '\';
  //��������� �����
  for GetString in FFiles do
    FOutArchive.AddFile(GetString,NewPath + ExtractFileName(GetString));
  //�������� ��������� � �����
  try
    FOutArchive.SaveToFile(FileName);
    Result:=true;
  except
    Result:=false;
  end;
end;

{$ENDREGION}

{$REGION 'TArcCreate7Zip'}

//������� �����
//�� ������ � ������
function TArcCreate7Zip.CreateArchive(FileName:String):Boolean;
var
  GetString:String;
  BasicPath:String;
  NewPath:String;
  Index:Integer;
  LastIndex:Integer;
begin
  FOutArchive:=CreateOutArchive(CLSID_CFormat7z);
  FOutArchive.SetProgressCallback(@Self,CallBackFunc);
  BasicPath:=ExtractFilePath(FileName);
  BasicPath:=Copy(BasicPath,0,Length(BasicPath)-1);
  LastIndex:=0;
  for Index:=0 to Length(BasicPath)-1 do
    if BasicPath[Index] = '\' then
      LastIndex:=Index;
  NewPath:=Copy(BasicPath,LastIndex+1,Length(BasicPath)) + '\';
  //��������� �����
  for GetString in FFiles do
  begin
    FOutArchive.AddFile(GetString,NewPath + ExtractFileName(GetString));
  end;
  //�������� ��������� � �����
  try
    FOutArchive.SaveToFile(FileName);
    Result:=true;
  except
    Result:=false;
  end;
end;

{$ENDREGION}

{$REGION 'TArcCreatePdf'}

//������� �����
//�� ������ � ������
function TArcCreatePdf.CreateArchive(FileName:String):Boolean;
var
  IO:TImageEnMView;
  Name:String;
begin
  //��������� ������
  //�����������
  //��������� ��
  IO:=TImageEnMView.Create(nil);
  for Name in FFiles do
    IO.AppendImage(Name);
  try
    //� ���������
    IO.MIO.SaveToFilePDF(FileName);
    IO.Free;
    Result:=true;
  except
    Result:=false;
    IO.Free;
  end;
end;

{$ENDREGION}

{$REGION 'TArcCreateTiff'}

function TArcCreateTiff.CreateArchive(FileName:String):Boolean;
var
  IO:TImageEnMView;
  Name:String;
begin
  //��������� ������
  //�����������
  //��������� ��
  IO:=TImageEnMView.Create(nil);
  for Name in FFiles do
    IO.AppendImage(Name);
  try
    //� ���������
    IO.MIO.SaveToFileTIFF(FileName);
    IO.Free;
    Result:=true;
  except
    Result:=false;
    IO.Free;
  end;
end;

{$ENDREGION}

{$REGION 'TArcCreateGif'}

//������� �����
//�� ������ � ������
function TArcCreateGif.CreateArchive(FileName:String):Boolean;
var
  IO:TImageEnMView;
  Name:String;
begin
  //��������� ������
  //�����������
  //��������� ��
  IO:=TImageEnMView.Create(nil);
  for Name in FFiles do
    IO.AppendImage(Name);
  try
    //� ���������
    IO.MIO.SaveToFileGIF(FileName);
    IO.Free;
    Result:=true;
  except
    Result:=false;
    IO.Free;
  end;
end;

{$ENDREGION}

end.
