{
  drComRead

  ������ ��� ��������
  ������� ���������� �������  

  Copyright (c) 2008-2010 Romanus
}
unit ArcFunc;

interface

uses
  Classes,
  //7zip
  sevenzip,
  //rar
  Rar,
  //zip
  AbZipTyp, AbArcTyp, AbUnZper, AbUnzPrc;

type

  //������ ��������
  TALIntArray = array of integer;
  //������ �����
  TALStrArray = array of string;

{$REGION 'Archive'}

  TALArchive = class
  private
    //��� �����
    FFileName:String;
    //������ ������
    FFiles:TStrings;
  public
    //������ ������ ������ ������
    property Files:TStrings read FFiles;
    //��� ����� ������
    property FileName:string read FFileName;
    //�����������
    constructor Create(fname:String);virtual;
    //����������
    destructor Destroy;override;    
    //�������� ��� ����� �� �������
    function GetString(Index:Integer):String;
    //��������� �����
    //�� ������������
    function TestArchive:boolean;virtual;abstract;
    //������ ������ ������
    //� ������
    function ReadListOfFiles:boolean;virtual;abstract;
    //���������� ���� ������
    //� ���������� ��������
    function ExtractAllArchive(Path:String):boolean;virtual;abstract;
    //���������� ������ �����
    //�� �������
    function ExtractByIndex(Path:String;Index:Integer):boolean;virtual;abstract;
    //���������� ������ �����
    //�� �����
    function ExtractByName(Path:String;Name:String):boolean;virtual;abstract;
    //��������� ����� ��������
    //������� ��������
    function ExtractByIndexs(Path:String;Indexs:TALIntArray):boolean;virtual;abstract;
    //���������� ������� ������
    //�� �����
    function ExtractByNames(Path:String;Names:TALStrArray):boolean;virtual;abstract;
    //������������� ������� ��������� ������
    function SetCallBackFunc(Func:Pointer):boolean;virtual;abstract;
  end;

{$ENDREGION}

{$REGION '7-zip,tar,arj,cab,gzip'}

  T7Zip = class(TALArchive)
  private
    //�������� ������ ���
    //������
    F7ZipObj:I7zInArchive;
    //����� ���
    //���������� ������
    FStream:TMemoryStream;
  public
    //�����������
    constructor Create(fname:String);override;
    //����������
    destructor Destroy;override;
    //��������� �����
    //�� ������������
    function TestArchive:boolean;override;
    //������ ������ ������
    //� ������
    function ReadListOfFiles:boolean;override;
    //���������� ���� ������
    //� ���������� ��������
    function ExtractAllArchive(Path:String):boolean;override;
    //���������� ������ �����
    //�� �������
    function ExtractByIndex(Path:String;Index:Integer):boolean;override;
    //���������� ������ �����
    //�� �����
    function ExtractByName(Path:String;Name:String):boolean;override;
    //��������� ����� ��������
    //������� ��������
    function ExtractByIndexs(Path:String;Indexs:TALIntArray):boolean;override;
    //���������� ������� ������
    //�� �����
    function ExtractByNames(Path:String;Names:TALStrArray):boolean;override;
    //������������� ������� ��������� ������
    function SetCallBackFunc(Func:Pointer):Boolean;override;
  end;

{$ENDREGION}

{$REGION 'Rar'}

  TALRar = class(TALArchive)
  private
    //����� ��� ������
    //� rar ��������
    FRARObj:TRAR;
    //������� ��� ���������
    //���������
    FFunc:Pointer;
  protected
    //������ ���� �� ������
    procedure ReadListFile(Sender: TObject; const FileInformation:TRARFileItem);
    //������������ ��������
    procedure ReadProgress(Sender: TObject; const FileName:WideString; const ArchiveBytesTotal, ArchiveBytesDone, FileBytesTotal, FileBytesDone:cardinal);
  public
    //�����������
    constructor Create(fname:String);override;
    //����������
    destructor Destroy;override;
    //��������� �����
    //�� ������������
    function TestArchive:boolean;override;
    //������ ������ ������
    //� ������
    function ReadListOfFiles:boolean;override;
    //���������� ���� ������
    //� ���������� ��������
    function ExtractAllArchive(Path:String):boolean;override;
    //���������� ������ �����
    //�� �������
    function ExtractByIndex(Path:String;Index:Integer):boolean;override;
    //���������� ������ �����
    //�� �����
    function ExtractByName(Path:String;Name:String):boolean;override;
    //��������� ����� ��������
    //������� ��������
    function ExtractByIndexs(Path:String;Indexs:TALIntArray):boolean;override;
    //���������� ������� ������
    //�� �����
    function ExtractByNames(Path:String;Names:TALStrArray):boolean;override;
    //������������� ������� ��������� ������
    function SetCallBackFunc(Func:Pointer):Boolean;override;
  end;

{$ENDREGION}

{$REGION 'Zip'}

  TALZip = class(TALArchive)
  private
    //����� ��� ������
    //� zip ��������
    FZipObj:TAbZipArchive;
    //������� ��� ���������
    //���������
    FFunc:Pointer;
  protected
    //���������� ���������
    procedure ProgressEvent(Sender : TObject; Item : TAbArchiveItem; Progress : Byte;
      var Abort : Boolean);
    //���������� ����� ����������
    procedure ProcItem(Sender : TObject; Item : TAbArchiveItem;
      const NewName : string);
  public
    //�����������
    constructor Create(fname:String);override;
    //����������
    destructor Destroy;override;
    //��������� �����
    //�� ������������
    function TestArchive:boolean;override;
    //������ ������ ������
    //� ������
    function ReadListOfFiles:boolean;override;
    //���������� ���� ������
    //� ���������� ��������
    function ExtractAllArchive(Path:String):boolean;override;
    //���������� ������ �����
    //�� �������
    function ExtractByIndex(Path:String;Index:Integer):boolean;override;
    //���������� ������ �����
    //�� �����
    function ExtractByName(Path:String;Name:String):boolean;override;
    //��������� ����� ��������
    //������� ��������
    function ExtractByIndexs(Path:String;Indexs:TALIntArray):boolean;override;
    //���������� ������� ������
    //�� �����
    function ExtractByNames(Path:String;Names:TALStrArray):boolean;override;
    //������������� ������� ��������� ������
    function SetCallBackFunc(Func:Pointer):Boolean;override;
  end;

{$ENDREGION}

var
  //����� � ������� �� ��������
  Archive:TALArchive;
  //������� �������� ������ 
  ArchiveIsCreated:Boolean;
  //���� ��� ����������
  MainPath:String;
  //���������� �������
  //��� ������ ���������
  CallFunc:procedure;

{$REGION '�������'}

//�������� �������� ������

//��������� �����
function OpenArchive(FName:PWideChar;Mode:Byte):Boolean;stdcall;
//��������� �����
function CloseArchive:Boolean;stdcall;
//��������� ��������� ���������
//������
function SetCallBackFunc(Func:Pointer):Boolean;stdcall;

//���� ������ �� ������

//���������� ������
function CountFiles:Integer;stdcall;
//�������� ��� �����
function GetFileName(Index:Integer):PWideChar;stdcall;
//���������� ���� ��� ����������
function SetMainPath(Path:PWideChar):Boolean;stdcall;
//�������� ���� ������������� ��������
//����
function GetMainPath:PWideChar;stdcall;

//��������� ������

//����� ���� ������������� ����� SetMainPath
//��������� ���� �����
function ExtractAllA:Boolean;stdcall;
//������� ���� ����
function ExtractSingleA(Index:Integer):Boolean;stdcall;
//������� ������ ������
function ExtractIndexesA(Indexes:TALIntArray):Boolean;stdcall;

//��� ������� ����������
//���������� ��������� ����
//��������� ���� �����
function ExtractAllB(Path:PWideChar):Boolean;stdcall;
//������� ���� ����
function ExtractSingleB(Path:PWideChar;Index:Integer):Boolean;stdcall;
//������� ���� ����
function ExtractSingleC(FName:PWideChar):Boolean;stdcall;
//������� ������ ������
function ExtractIndexesB(Path:PWideChar;Indexes:TALIntArray):Boolean;stdcall;

{$ENDREGION}

implementation

uses
  SysUtils, Dialogs;

{$REGION 'Archive'}

//�����������
constructor TALArchive.Create(fname:String);
begin
  FFileName:=fname;
  FFiles:=TStringList.Create;
end;

//����������
destructor TALArchive.Destroy;
begin
  FFiles.Free;  
end;

//�������� ��� ����� �� �������
function TALArchive.GetString(Index:Integer):String;
begin
  Result:='';
  if Index >= FFiles.Count then
    Exit;
  Result:=FFiles.Strings[Index];
end;

{$ENDREGION}

{$REGION '7-zip,tar,arj,cab,gzip'}

function CallBackFunc(sender: Pointer; index: Cardinal;var outStream: ISequentialOutStream): HRESULT; stdcall;
var
  aStream:TStream;
begin
  aStream:=TMemoryStream.Create;
  outStream := T7zStream.Create(aStream, soReference);
  //���� ������� ���
  //������ ���������
  //���� �� ��������� ��
  if @CallFunc <> nil then
    CallFunc();
  Result:=0;
end;

//�����������
constructor T7Zip.Create(fname:String);
var
  Ext:String;
begin
  inherited Create(fname);
  Ext:=ExtractFileExt(fname);
  if (Ext = '.rar') or (Ext = '.cbr') then
    F7ZipObj:=CreateInArchive(CLSID_CFormatRar);
  if (Ext = '.zip') or (Ext = '.cbz') then
    F7ZipObj:=CreateInArchive(CLSID_CFormatZip);
  if (Ext = '.7z') or (Ext = '.cb7') then
    F7ZipObj:=CreateInArchive(CLSID_CFormat7z);
  if (Ext = '.arj') or (Ext = '.cba') then
    F7ZipObj:=CreateInArchive(CLSID_CFormatArj);
  if (Ext = '.tar') or (Ext = '.cbt') then
    F7ZipObj:=CreateInArchive(CLSID_CFormatTar);
  if (Ext = '.gz') or (Ext = '.cbg') then
    F7ZipObj:=CreateInArchive(CLSID_CFormatGZip);
  if (Ext = '.chm') then
    F7ZipObj:=CreateInArchive(CLSID_CFormatChm);
  if (Ext = '.bz2') then
    F7ZipObj:=CreateInArchive(CLSID_CFormatBZ2);
  if (Ext = '.lzh') then
    F7ZipObj:=CreateInArchive(CLSID_CFormatLzh);
  if (Ext = '.iso') then
    F7ZipObj:=CreateInArchive(CLSID_CFormatIso);
  //�� ��������� ������ zip
  if F7ZipObj = nil then
    F7ZipObj:=CreateInArchive(CLSID_CFormatZip);
  FFileName:=fname;
end;

//����������
destructor T7Zip.Destroy;
begin
  I7zInArchive(F7ZipObj).Close;
  inherited Destroy;
end;

//��������� �����
//�� ������������
function T7Zip.TestArchive:boolean;
begin
  try
    F7ZipObj.OpenFile(FFileName);
    Result:=true;    
  except
    Result:=false;
  end;
end;

//������ ������ ������
//� ������
function T7Zip.ReadListOfFiles:boolean;
var
  GetPos:Integer;
begin
  for GetPos:=0 to F7ZipObj.NumberOfItems-1 do
    if not F7ZipObj.ItemIsFolder[GetPos] and
      (F7ZipObj.ItemPath[GetPos] <> '') then
      FFiles.Add(F7ZipObj.ItemPath[GetPos]);
  Result:=true;        
end;

//���������� ���� ������
//� ���������� ��������
function T7Zip.ExtractAllArchive(Path:String):boolean;
var
  GetPos:Integer;
begin
  try
    //���������
    for GetPos:=0 to FFiles.Count-1 do
      Self.ExtractByIndex(Path,GetPos);
    Result:=true;
  except
    Result:=false;
  end;
end;

//���������� ������ �����
//�� �������
function T7Zip.ExtractByIndex(Path:String;Index:Integer):boolean;
var
  NewFileName:WideString;
begin
  Result:=false;
  if Index >= FFiles.Count then
    Exit;
  if Assigned(FStream) then
    FStream.Free;
  FStream:=TMemoryStream.Create;
  try
    F7ZipObj.ExtractItem(Index,FStream,false);
    if FStream.Size = 0 then
      F7ZipObj.ExtractItem(Index+1,FStream,false);
    //�������� ����
    if Path[Length(Path)] <> '\' then
      Path:=Path+'\';
    //��������� � ����
    NewFileName:=ExtractFileName(FFiles.Strings[Index]);
    FStream.SaveToFile(Path+NewFileName);
    FreeAndNil(FStream);
    Result:=true;
  except
    Exit;
  end;
end;

//���������� ������ �����
//�� �����
function T7Zip.ExtractByName(Path:String;Name:String):boolean;
var
  Index:Integer;
begin
  Result:=false;
  Index:=FFiles.IndexOf(Name);
  if Index = -1 then
    Exit;
  Result:=Self.ExtractByIndex(Path,Index);
end;

//��������� ����� ��������
//������� ��������
function T7Zip.ExtractByIndexs(Path:String;Indexs:TALIntArray):boolean;
var
  GetPos:Integer;
begin
  Result:=false;
  for GetPos:=0 to High(Indexs) do
    if not Self.ExtractByIndex(Path,Indexs[GetPos]) then
      Exit;
  Result:=true;
end;

//���������� ������� ������
//�� �����
function T7Zip.ExtractByNames(Path:String;Names:TALStrArray):boolean;
var
  GetPos:Integer;
begin
  Result:=false;
  for GetPos:=0 to High(Names) do
    if not Self.ExtractByName(Path,Names[GetPos]) then
      Exit;
  Result:=true;
end;

function T7Zip.SetCallBackFunc(Func:Pointer):Boolean;
begin
  @CallFunc:=Func;
  Result:=true;
end;


{$ENDREGION}

{$REGION 'Rar'}

//������ ���� �� ������
procedure TALRar.ReadListFile(Sender: TObject; const FileInformation:TRARFileItem);
begin
  FFiles.Add(FileInformation.FileNameW);
end;

//������������ ��������
procedure TALRar.ReadProgress(Sender: TObject; const FileName:WideString; const ArchiveBytesTotal, ArchiveBytesDone, FileBytesTotal, FileBytesDone:cardinal);
var
  Func:procedure;
begin
  if FFunc <> nil then
  begin
    @Func:=FFunc;
    Func();
  end;
end;

//�����������
constructor TALRar.Create(fname:String);
begin
  inherited Create(fname);
  FRARObj:=TRar.Create(nil);
  //���������� ���������
  FRARObj.OnProgress:=Self.ReadProgress;
  //���������� ������ �����
  FRARObj.OnListFile:=ReadListFile;
end;

//����������
destructor TALRar.Destroy;
begin
  FRARObj.Free;
  inherited Destroy;
end;

//��������� �����
//�� ������������
function TALRar.TestArchive:boolean;
begin
  try
    //�������� �������
    //���� � �������������� ���
    if not FRARObj.OpenFile(FFileName) then
      Exit(false);
    Result:=FRARObj.Test;
  except
    Result:=false;
  end;
end;

//������ ������ ������
//� ������
function TALRar.ReadListOfFiles:boolean;
begin
  Result:=true;
end;

//���������� ���� ������
//� ���������� ��������
function TALRar.ExtractAllArchive(Path:String):boolean;
{begin
  Result:=FRARObj.Extract(AnsiString(Path),true,FFiles);}
var
  GetPos:Integer;
begin
  for GetPos:=0 to FFiles.Count-1 do
    if not Self.ExtractByIndex(Path,GetPos) then
      Exit(false);
  Result:=true;
end;

//���������� ������ �����
//�� �������
function TALRar.ExtractByIndex(Path:String;Index:Integer):boolean;
var
  Strings:TStringList;
begin
  Result:=false;
  if Index >= FFiles.Count then
    Exit;
  //��������� ������
  Strings:=TStringList.Create;
  Strings.Add(FFiles.Strings[Index]);
  //�������� �������
  Result:=FRARObj.Extract(AnsiString(Path),false,Strings);
  //������ ������
  Strings.Free;
end;

//���������� ������ �����
//�� �����
function TALRar.ExtractByName(Path:String;Name:String):boolean;
var
  Index:Integer;
begin
  Result:=false;
  Index:=FFiles.IndexOf(Name);
  if Index = -1 then
    Exit;
  Result:=Self.ExtractByIndex(Path,Index);
end;

//��������� ����� ��������
//������� ��������
function TALRar.ExtractByIndexs(Path:String;Indexs:TALIntArray):boolean;
var
  GetPos:Integer;
begin
  Result:=false;
  for GetPos:=0 to High(Indexs) do
    if not Self.ExtractByIndex(Path,Indexs[GetPos]) then
      Exit;
  Result:=true;
end;

//���������� ������� ������
//�� �����
function TALRar.ExtractByNames(Path:String;Names:TALStrArray):boolean;
var
  GetPos:Integer;
begin
  Result:=false;
  for GetPos:=0 to High(Names) do
    if not Self.ExtractByName(Path,Names[GetPos]) then
      Exit;
  Result:=true;
end;

//������������� ������� ��������� ������
function TALRar.SetCallBackFunc(Func:Pointer):Boolean;
begin
  FFunc:=Func;
  Result:=true;
end;

{$ENDREGION}

{$REGION 'Zip'}

//���������� ���������
procedure TALZip.ProgressEvent(Sender : TObject; Item : TAbArchiveItem; Progress : Byte;
  var Abort : Boolean);
var
  Func:procedure;
begin
  if FFunc <> nil then
  begin
    @Func:=FFunc;
    Func();
  end;
end;

//���������� ����� ����������
procedure TALZip.ProcItem(Sender : TObject; Item : TAbArchiveItem;
  const NewName : string);
begin
  AbUnZip(Sender,TAbZipItem(Item),NewName + ExtractFileName(Item.DiskFileName));
end;

//�����������
constructor TALZip.Create(fname:String);
begin
  inherited Create(fname);
  FZipObj:=TAbZipArchive.Create(fname,fmOpenRead);
  FZipObj.OnArchiveItemProgress:=ProgressEvent;
  FZipObj.ExtractHelper:=ProcItem;
end;

//����������
destructor TALZip.Destroy;
begin
  FZipObj.Free;
  inherited Destroy;
end;

//��������� �����
//�� ������������
function TALZip.TestArchive:boolean;
begin
  try
    FZipObj.Load;
    Exit(true);
  except
    Exit(false);
  end;
end;

//������ ������ ������
//� ������
function TALZip.ReadListOfFiles:boolean;
var
  GetPos:Integer;
begin
  Result:=true;
  for GetPos:=0 to FZipObj.ItemList.Count-1 do
    FFiles.Add(TAbArchiveItem(FZipObj.ItemList.Items[GetPos]).FileName);
end;

//���������� ���� ������
//� ���������� ��������
function TALZip.ExtractAllArchive(Path:String):boolean;
var
  GetPos:Integer;
begin
  for GetPos:=0 to FFiles.Count-1 do
    if not Self.ExtractByIndex(Path,GetPos) then
      Exit(false);
  Result:=true;
end;

//���������� ������ �����
//�� �������
function TALZip.ExtractByIndex(Path:String;Index:Integer):boolean;
begin
  try
    FZipObj.BaseDirectory:=Path;
    FZipObj.ExtractAt(Index,Path);
    Result:=true;
  except
    Result:=false;
  end;
end;

//���������� ������ �����
//�� �����
function TALZip.ExtractByName(Path:String;Name:String):boolean;
var
  Index:Integer;
begin
  Index:=FFiles.IndexOf(Name);
  if Index = -1 then
    Exit(false);
  Result:=Self.ExtractByIndex(Path,Index);
end;

//��������� ����� ��������
//������� ��������
function TALZip.ExtractByIndexs(Path:String;Indexs:TALIntArray):boolean;
var
  GetPos:Integer;
begin
  for GetPos:=0 to High(Indexs) do
    Self.ExtractByIndex(Path,Indexs[GetPos]);
  Result:=true;
end;

//���������� ������� ������
//�� �����
function TALZip.ExtractByNames(Path:String;Names:TALStrArray):boolean;
var
  GetPos:Integer;
begin
  for GetPos:=0 to High(Names) do
    Self.ExtractByName(Path,Names[GetPos]);
  Result:=true;
end;

//������������� ������� ��������� ������
function TALZip.SetCallBackFunc(Func:Pointer):Boolean;
begin
  FFunc:=Func;
  Result:=true;
end;

{$ENDREGION}

{$REGION '�������'}

//��������� �����
function OpenArchive(FName:PWideChar;Mode:Byte):Boolean;
var
  Str:String;
begin
  Result:=false;
  Str:=WideCharToString(FName);
  try
    case Mode of
      //rar �����
      0:Archive:=TALRar.Create(Str);
      //zip
      1:Archive:=TALZip.Create(Str);
      //7zip,tar,cab,gzip
      2:Archive:=T7Zip.Create(Str);
	    //���� pdf
	    //3:Archive:=TALPdf.Create(FName);
    end;
  except
    Exit;
  end;
  Result:=Archive.TestArchive;
end;

//��������� �����
function CloseArchive:Boolean;
begin
  try
    if Assigned(Archive) then
      FreeAndNil(Archive);
    Result:=true;
  except
    Result:=false;
  end;
end;

//��������� ��������� ���������
//������
function SetCallBackFunc(Func:Pointer):Boolean;
begin
  Result:=Archive.SetCallBackFunc(Func);
end;

//���������� ������
function CountFiles:Integer;
begin
  Result:=-1;
  if Archive = nil then
    Exit;
  //������ ������ ������
  if not Archive.ReadListOfFiles then
    Exit;
  //���������� ���������� ������
  Result:=Archive.FFiles.Count;
end;

//�������� ��� �����
function GetFileName(Index:Integer):PWideChar;
var
  WStr:WideString;
begin
  Result:='';
  if Archive = nil then
    Exit;
  if Index >= Archive.FFiles.Count then
    Exit;
  WStr:=Archive.FFiles.Strings[Index];
  Result:=PWideChar(WStr);
end;

//���������� ���� ��� ����������
function SetMainPath(Path:PWideChar):Boolean;
begin
  Result:=true;
  MainPath:=WideCharToString(Path);
end;

//�������� ���� ������������� ��������
//����
function GetMainPath:PWideChar;
var
  ResString:WideString;
begin
  ResString:=MainPath;
  Result:=PWideChar(ResString);
end;

//��������� ���� �����
function ExtractAllA:Boolean;
begin
  Result:=Archive.ExtractAllArchive(MainPath);
end;

//������� ���� ����
function ExtractSingleA(Index:Integer):Boolean;
begin
  Result:=Archive.ExtractByIndex(MainPath,Index);
end;

//������� ������ ������
function ExtractIndexesA(Indexes:TALIntArray):Boolean;
begin
  Result:=Archive.ExtractByIndexs(MainPath,Indexes);
end;

//��������� ���� �����
function ExtractAllB(Path:PWideChar):Boolean;
begin
  Result:=Archive.ExtractAllArchive(WideCharToString(Path));
end;

//������� ���� ����
function ExtractSingleB(Path:PWideChar;Index:Integer):Boolean;
begin
  Result:=Archive.ExtractByIndex(WideCharToString(Path),Index);
end;

//������� ���� ����
function ExtractSingleC(FName:PWideChar):Boolean;
begin
  Result:=Archive.ExtractByName(MainPath,FName);
end;

//������� ������ ������
function ExtractIndexesB(Path:PWideChar;Indexes:TALIntArray):Boolean;
begin
  Result:=Archive.ExtractByIndexs(WideCharToString(Path),Indexes);
end;

{$ENDREGION}


end.
