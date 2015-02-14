{
  drComRead

  Модуль для работы
  с интернетом

  Copyright (c) 2012 Romanus
}
unit CRInet;

interface

uses
  Classes, SysUtils,
  IdComponent, IdHTTP, IdFTP;

type

  //тип прогресса
  TCRInetProgressType = (iptConnecting,iptDownload);
  //обработчик прогресса
  TCRInetProgress = procedure (Percent:Integer;TypeProgress:TCRInetProgressType) of object;

  {$REGION 'TCRInet'}

  //общий базовый класс
  //для работы с интернетом
  TCRInet = class
  private
    FAddress:String;
    FInetProgress:TCRInetProgress;
  public
    //обработчик прогресса
    property OnInetProgress:TCRInetProgress read FInetProgress write FInetProgress;
    //адрес
    property Address:string read FAddress;
    //конструктор
    constructor Create(url:String);virtual;
    //деструктор
    //destructor Destroy;override;
    //получение данных
    function GetData:String;virtual;abstract;
    //получение файла
    function GetFile:TStream;virtual;abstract;
  end;

  {$ENDREGION}

  {$REGION 'TCRHttpInet'}

  TCRHttpInet = class(TCRInet)
  private
    //объект для выполнения
    //запросов по HTTP
    FHttpObject:TIdHTTP;
    //прогресс смены статусов
    procedure ProgressEvent(ASender: TObject; const AStatus: TIdStatus;const AStatusText: string);
    //перенапраление
    procedure RedirectEvent(Sender: TObject; var dest: string; var NumRedirect: Integer; var Handled: boolean; var VMethod: TIdHTTPMethod);
    //прогресс
    procedure HttpWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
  public
    //конструктор
    constructor Create(url:String);override;
    //деструктор
    destructor Destroy;override;
    //получение данных
    function GetData:String;override;
    //получение файла
    function GetFile:TStream;override;
  end;

  {$ENDREGION}

  {$REGION 'TCRFtpInet'}

  TCRFtpInet = class(TCRInet)
  private
    //объект для выполнения
    //запросов по FTP
    FFtpObject:TIdFTP;
    //прогресс выполнения загрузки
    procedure ProgressEvent(ASender: TObject; const AStatus: TIdStatus;const AStatusText: string);
  public
    //конструктор
    constructor Create(url:String);override;
    //деструктор
    destructor Destroy;override;
    //получение данных
    function GetData:String;override;
    //получение файла
    function GetFile:TStream;override;
  end;

  {$ENDREGION}

implementation

uses
  Windows, CRGlobal;

{$REGION 'TCRInet'}

//конструктор
constructor TCRInet.Create(url:String);
begin
  PrintToLog('TCRInet.Create at url(' + url + ')');
  FAddress:=url;
end;

{$ENDREGION}

{$REGION 'TCRHttpInet'}

//прогресс выполнения загрузки
procedure TCRHttpInet.ProgressEvent(ASender: TObject; const AStatus: TIdStatus;const AStatusText: string);
begin
  case AStatus of
    //Простой
    hsResolving:;//ShowMessage('Простой');
    //Подключение
    hsConnecting:;//ShowMessage('Подключение..');
    //Подключился
    hsConnected:;//ShowMessage('Подключен!');
    //Отключение
    hsDisconnecting:;
    //Отключен
    hsDisconnected:;//ShowMessage('Отключен!');
    //
    hsStatusText:;//ShowMessage(AStatusText);
  end;
end;

//перенапраление
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


//конструктор
constructor TCRHttpInet.Create(url:String);
begin
  inherited Create(url);
  FHttpObject:=TIdHTTP.Create;
  FHttpObject.OnStatus:=ProgressEvent;
  FHttpObject.OnRedirect:=RedirectEvent;
  FHttpObject.OnWork:=HttpWork;
end;

//деструктор
destructor TCRHttpInet.Destroy;
begin
  FHttpObject.Free;
end;

//получение данных
function TCRHttpInet.GetData:String;
var
  GetResult:String;
  Int:Integer;
  Val:string;
begin
  //ToDo:разрешать ли редиректы?
  FHttpObject.HandleRedirects:=true;
  //только два редиректа
  FHttpObject.RedirectMaximum:=2;
  GetResult:=FHttpObject.Get(FAddress);
  if FHttpObject.ResponseCode <> 200 then
    raise Exception.Create('Server response not code 200');
  Result:=GetResult;
end;

//получение файла
function TCRHttpInet.GetFile:TStream;
var
  Stream:TMemoryStream;
begin
  Stream:=TMemoryStream.Create;
  //никаких редиректов
  FHttpObject.HandleRedirects:=false;
  FHttpObject.Get(FAddress,Stream);
  if FHttpObject.ResponseCode <> 200 then
    raise Exception.Create('Server response not code 200');
  Result:=Stream;
end;

{$ENDREGION}

{$REGION 'TCRFtpInet'}

//прогресс выполнения загрузки
procedure TCRFtpInet.ProgressEvent(ASender: TObject; const AStatus: TIdStatus;const AStatusText: string);
begin
  case AStatus of
    //Решение что за?
    hsResolving:;
    //Подключение
    hsConnecting:;
    //Подключился
    hsConnected:;
    //Отключение
    hsDisconnecting:;
    //Отключен
    hsDisconnected:;
    hsStatusText:;
    //Передача
    ftpTransfer:;
    //готов
    ftpReady:;
    //отмена
    ftpAborted:;
  end;

end;

//конструктор
constructor TCRFtpInet.Create(url:String);
begin

end;

//деструктор
destructor TCRFtpInet.Destroy;
begin

end;
//получение данных
function TCRFtpInet.GetData:String;
begin

end;
//получение файла
function TCRFtpInet.GetFile:TStream;
begin

end;

{$ENDREGION}

end.
