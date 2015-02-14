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
  //rar
  Rar;

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

implementation

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
begin
  Result:=FRARObj.Extract(AnsiString(Path),true,FFiles);
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

end.
