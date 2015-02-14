{
  drComRead

  ������ ����������� �������

  Copyright (c) 2009-2011 Romanus
}
unit ArcReCreate;

interface

uses
  ArcCreate, ArcFunc;

type
  //����� �����������
  TArcReCreateMode = (rcmSelf,rcmRar,rcmZip,rcm7Zip);
  //����������� ��������
  TArcReCreateProcess = (rcpExtract,rcpPack,rcpCreate);
  //������� ��������� ������
  TArcReCreateCallBack = procedure (GetProcess:TArcReCreateProcess) of object;

  //����� ����������
  //������ �����������
  TArcReCreate = class
  private
    //������ ��� ���������
    //������
    FArcObj:TArcCreate;
    //������ ��� ����������
    //������
    FSourceObj:TALArchive;
    //��� ��������������� �����
    FRepackFileName:String;
    //������� ��� ���������
    //������
    FCallBack:TArcReCreateCallBack;
  public
    property OnCallBack:TArcReCreateCallBack read FCallBack write FCallBack;
    //��� ��������������� �����
    property RepackFileName:String read FRepackFileName;
    //�����������
    constructor Create(FileName:String;Mode:TArcReCreateMode);
    //����������
    destructor Destroy;override;
    //������������
    function Repack(Target:String):Boolean;
  end;

implementation

uses
  Windows,
  RLibString,
  MainForm, ShellApi, SysUtils, CRGlobal;

//�����������
constructor TArcReCreate.Create(FileName:String;Mode:TArcReCreateMode);
var
  Extension:String;
begin
  Extension:=LowerCase(ExtractFileExt(FileName));
  //������� ��������� ������
  //��� ��������� ������
  case Mode of
    rcmSelf:
      begin
        if (Extension = '.rar') or (Extension = '.cbr') then
        begin
          FArcObj:=TArcCreateRar.Create;
          FSourceObj:=TALRar.Create(FileName);
        end;
        if (Extension = '.zip') or (Extension = '.cbz') then
        begin
          FArcObj:=TArcCreateZip.Create;
          FSourceObj:=TALZip.Create(FileName);
        end;
        if (Extension = '.7z') or (Extension = '.cb7') then
        begin
          FArcObj:=TArcCreate7Zip.Create;
          FSourceObj:=T7Zip.Create(FileName);
        end;
      end;
    rcmRar:
      begin
        FArcObj:=TArcCreateRar.Create;
        FSourceObj:=TALRar.Create(FileName);
      end;
    rcmZip:
      begin
        FArcObj:=TArcCreateZip.Create;
        FSourceObj:=TALZip.Create(FileName);
      end;
    rcm7Zip:
      begin
        FArcObj:=TArcCreate7Zip.Create;
        FSourceObj:=T7Zip.Create(FileName);
      end;
  end;
end;

//����������
destructor TArcReCreate.Destroy;
begin
  //������ �� �����
  FArcObj.Free;
  FSourceObj.Free;
end;

procedure DeleteDir(Str:String);
var
 DirInfo: TSearchRec;
 r: integer;
begin
  r := FindFirst(Str + '\*.*', FaAnyfile, DirInfo);
  while r = 0 do begin
    if (DirInfo.Attr and FaDirectory <> FaDirectory) then
      DeleteFileW(PWideChar(Str + '\' + DirInfo.Name));
    r := FindNext(DirInfo);
  end;
  SysUtils.FindClose(DirInfo);
  RemoveDirectoryW(PWideChar(Str));
end;

//������������
function TArcReCreate.Repack(Target:String):Boolean;
var
  FileName:TRLibString;
  GetPos:Integer;
  FileNameStr:String;
  FullPath:String;
  Extended:String;
  GetStr:string;
begin
  FileName:=RLibStr(ExtractFileName(FSourceObj.FileName));
  FileNameStr:=FileName.SubString(1,FileName.LastIndexOf('.')-1);
  Extended:=ExtractFileExt(FSourceObj.FileName);
  FullPath:=Target+FileNameStr+'\';
  if Assigned(FCallBack) then
    FCallBack(rcpExtract);
  CreateDir(FullPath);
  //��������� �����
  if not FSourceObj.TestArchive then
    Exit(false);
  //���� ������ ������ ��
  //�������� ������ ��� �������������
  if FSourceObj.Files.Count = 0 then
    FSourceObj.ReadListOfFiles;
  //��������� ��� �� ������
  if not FSourceObj.ExtractAllArchive(FullPath) then
    Exit(false);
  if Assigned(FCallBack) then
    FCallBack(rcpPack);
  //��������� ������
  if FArcObj is TArcCreateRar then
    FArcObj.AddFile(FullPath)
  else begin
    for GetPos := 0 to FSourceObj.Files.Count-1 do
    begin
      GetStr:=FSourceObj.Files.Strings[GetPos];
      GetStr:=StringReplace(GetStr,'/','\',[rfReplaceAll]);
      GetStr:=ExtractFileName(GetStr);
      if GetStr = '' then
        Continue;
      FArcObj.AddFile(FullPath+GetStr);
    end;
  end;
  FRepackFileName:=Target+FileNameStr+Extended;
  FArcObj.CreateArchive(FRepackFileName);
  //������� �����
  try
    DeleteDir(Target+FileNameStr);
  finally

  end;
  Result:=True;
end;

end.
