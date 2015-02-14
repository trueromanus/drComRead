{
  drComRead

  ������ ��� ������
  � ����������

  Copyright (c) 2012 Romanus
}
unit CRInet;

interface

uses
  Classes, SysUtils,
  IdComponent, IdHTTP, IdFTP;

type

  //��� ���������
  TCRInetProgressType = (iptConnecting,iptDownload);
  //���������� ���������
  TCRInetProgress = procedure (Percent:Integer;TypeProgress:TCRInetProgressType) of object;

  {$REGION 'TCRInet'}

  //����� ������� �����
  //��� ������ � ����������
  TCRInet = class
  private
    FAddress:String;
    FInetProgress:TCRInetProgress;
  public
    //���������� ���������
    property OnInetProgress:TCRInetProgress read FInetProgress write FInetProgress;
    //�����
    property Address:string read FAddress;
    //�����������
    constructor Create(url:String);virtual;
    //����������
    //destructor Destroy;override;
    //��������� ������
    function GetData:String;virtual;abstract;
    //��������� �����
    function GetFile:TStream;virtual;abstract;
  end;

  {$ENDREGION}

  {$REGION 'TCRHttpInet'}

  TCRHttpInet = class(TCRInet)
  private
    //������ ��� ����������
    //�������� �� HTTP
    FHttpObject:TIdHTTP;
    //�������� ����� ��������
    procedure ProgressEvent(ASender: TObject; const AStatus: TIdStatus;const AStatusText: string);
    //��������������
    procedure RedirectEvent(Sender: TObject; var dest: string; var NumRedirect: Integer; var Handled: boolean; var VMethod: TIdHTTPMethod);
    //��������
    procedure HttpWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
  public
    //�����������
    constructor Create(url:String);override;
    //����������
    destructor Destroy;override;
    //��������� ������
    function GetData:String;override;
    //��������� �����
    function GetFile:TStream;override;
  end;

  {$ENDREGION}

  {$REGION 'TCRFtpInet'}

  TCRFtpInet = class(TCRInet)
  private
    //������ ��� ����������
    //�������� �� FTP
    FFtpObject:TIdFTP;
    //�������� ���������� ��������
    procedure ProgressEvent(ASender: TObject; const AStatus: TIdStatus;const AStatusText: string);
  public
    //�����������
    constructor Create(url:String);override;
    //����������
    destructor Destroy;override;
    //��������� ������
    function GetData:String;override;
    //��������� �����
    function GetFile:TStream;override;
  end;

  {$ENDREGION}

implementation

uses
  Windows, CRGlobal;

{$REGION 'TCRInet'}

//�����������
constructor TCRInet.Create(url:String);
begin
  PrintToLog('TCRInet.Create at url(' + url + ')');
  FAddress:=url;
end;

{$ENDREGION}

{$REGION 'TCRHttpInet'}

//�������� ���������� ��������
procedure TCRHttpInet.ProgressEvent(ASender: TObject; const AStatus: TIdStatus;const AStatusText: string);
begin
  case AStatus of
    //�������
    hsResolving:;//ShowMessage('�������');
    //�����������
    hsConnecting:;//ShowMessage('�����������..');
    //�����������
    hsConnected:;//ShowMessage('���������!');
    //����������
    hsDisconnecting:;
    //��������
    hsDisconnected:;//ShowMessage('��������!');
    //
    hsStatusText:;//ShowMessage(AStatusText);
  end;
end;

//��������������
procedure TCRHttpInet.RedirectEvent(Sender: TObject; var dest: string; var NumRedirect: Integer; var Handled: boolean; var VMethod: TIdHTTPMethod);
var
  s:string;
begin
  if dest <> '' then
    s:=dest;
end;

procedure TCRHttpInet.HttpWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
var
  Http: TIdHTTP;
  ContentLength: Int64;
  Percent: Integer;
begin
  Http := TIdHTTP(ASender);
  ContentLength := Http.Response.ContentLength;

  if (Pos('chunked', Http.Response.ContentEncoding) = 0) and
     (ContentLength > 0) then
  begin
    Percent := 100*AWorkCount div ContentLength;
    if (Assigned(OnInetProgress)) then
      OnInetProgress(Percent,iptDownload);
  end;
end;


//�����������
constructor TCRHttpInet.Create(url:String);
begin
  inherited Create(url);
  FHttpObject:=TIdHTTP.Create;
  FHttpObject.OnStatus:=ProgressEvent;
  FHttpObject.OnRedirect:=RedirectEvent;
  FHttpObject.OnWork:=HttpWork;
end;

//����������
destructor TCRHttpInet.Destroy;
begin
  FHttpObject.Free;
end;

//��������� ������
function TCRHttpInet.GetData:String;
var
  GetResult:String;
  Int:Integer;
  Val:string;
begin
  //ToDo:��������� �� ���������?
  FHttpObject.HandleRedirects:=true;
  //������ ��� ���������
  FHttpObject.RedirectMaximum:=2;
  GetResult:=FHttpObject.Get(FAddress);
  if FHttpObject.ResponseCode <> 200 then
    raise Exception.Create('Server response not code 200');
  Result:=GetResult;
end;

//��������� �����
function TCRHttpInet.GetFile:TStream;
var
  Stream:TMemoryStream;
begin
  Stream:=TMemoryStream.Create;
  //������� ����������
  FHttpObject.HandleRedirects:=false;
  FHttpObject.Get(FAddress,Stream);
  if FHttpObject.ResponseCode <> 200 then
    raise Exception.Create('Server response not code 200');
  Result:=Stream;
end;

{$ENDREGION}

{$REGION 'TCRFtpInet'}

//�������� ���������� ��������
procedure TCRFtpInet.ProgressEvent(ASender: TObject; const AStatus: TIdStatus;const AStatusText: string);
begin
  case AStatus of
    //������� ��� ��?
    hsResolving:;
    //�����������
    hsConnecting:;
    //�����������
    hsConnected:;
    //����������
    hsDisconnecting:;
    //��������
    hsDisconnected:;
    hsStatusText:;
    //��������
    ftpTransfer:;
    //�����
    ftpReady:;
    //������
    ftpAborted:;
  end;

end;

//�����������
constructor TCRFtpInet.Create(url:String);
begin

end;

//����������
destructor TCRFtpInet.Destroy;
begin

end;
//��������� ������
function TCRFtpInet.GetData:String;
begin

end;
//��������� �����
function TCRFtpInet.GetFile:TStream;
begin

end;

{$ENDREGION}

end.
