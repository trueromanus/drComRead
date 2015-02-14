{
  drComRead

  ������ ������ ��
  �������� ������

  ������� - $Revision: 1.14 $

  Copyright (c) 2008-2011 Romanus
}
unit CRDir;

interface

uses
  Windows, Classes, Generics.Collections,
  hyieutils,imageenio,imageenproc;

type
  //������ ��� ��������
  //�����������
  PCRFileRecord   =   ^TCRFileRecord;
  TCRFileRecord   =    record
    //��� �����
    FileName:String;
    //����� �������������
    //0 - ��� �������������
    //1 - ������� 80CW
    //2 - ������� 80CCW
    //3 - ���������� ��������������
    //4 - ���������� ������������
    TransformMode:Byte;
    //��������� ��������
    TransformRotState:Byte;
  end;

  //������ ��������
  TCRBookmark     =     record
    //��� ��������
    PageName:String;
    //����� ��������
    NumberPage:Integer;
  end;

  //��� �����
  TCRDirFileType  =   (
                        ftNone,
                        ftImage,
                        ftArchive,
                        ftTxt
                      );
  //��� ������
  TCRArchiveType  =   (
                        atUnknown,
                        atRar,
                        atZip,
                        at7zip
                      );
  //����� ��� ������
  //� ��������� 
  TCRDir = class
  private
    //������� ����������
    //��� ������ ������
    FGetDirectory:String;
    FDirDirectory:String;
    //������� �������� �����
    FGetOpenedArchive:String;
    //������� ������� ��������
    FComplete:Boolean;

    //������� ���� ���
    //������� �����������
    //������� ��� ���
    FGetImagesDouble:Boolean;
    //� ������ (��� �����)
    //������������
    FComReadInfoFile:Boolean;

    //�������� ������
    //������ �������
    FArchives:TStrings;
    //������� � �������
    FArchivesPos:integer;
    //������� ���� ��� ������
    //����� � �� ����������
    FArchiveOpened:Boolean;
    //���� � ����� � �������
    //FDirPath:WideString;

    //��������� ������
    //��������� �����
    FTxtFiles:TStrings;
    //������ �����������
    FImages:TList;
    //����� �������
    FPosition:integer;

    //���� ����������� �� ����������
    //��������
    FPrevPage:Boolean;

    //�������� ��� ��������
    //������
    FBookmarks:TList<TCRBookmark>;
  public
    property ArchivesPos:integer read FArchivesPos write FArchivesPos default -1;
    //������� � �������� �������
    property Position:integer read FPosition default -1;
    //������ �������
    property Archives:TStrings read FArchives;
    //������ ��������� ������
    property TxtFiles:TStrings read FTxtFiles;
    //������ �����������
    property BitmapList:TList read FImages;
    //������ ��������
    property Bookmarks:TList<TCRBookmark> read FBookmarks;
    //������ �� ����� ��� �������/����
    property ArchiveOpened:Boolean read FArchiveOpened;
    //������� �������� �������
    property MainDirectory:String read FGetDirectory;
    //���� ��� ���������� ������
    property MainDirDirectory:String read FDirDirectory;
    //������� �������� �����
    property GetOpenedArchive:String read FGetOpenedArchive;
    //������� ��������
    //�������� ��� ���
    property GetImagesDouble:Boolean read FGetImagesDouble;
    //���� ���������� �� ����� comread
    property ComReadInfoFile:Boolean read FComReadInfoFile;
    //�����������
    constructor Create;overload;
    //�����������
    //��� ���������
    constructor Create(path:string);overload;
    //������� �������� ������
    function CreateDataToDir(path:WideString):Boolean;
    //��������� �� ������ ������
    function LoadFromStrings(files:TStrings):Boolean;
    //�������� ������
    function LoadArchive(fname:string;BaseDir:string):Boolean;
    //��������� ����
    procedure LoadFileToType(fname:String);
    //��������� ����
    function AddFile(fname:String):Integer;
    //��������� ��� ���������
    function LoadImage(Index:Integer):Boolean;overload;
    //��������� ��� �������� �����
    function LoadImageTwoPage(Index:Integer;JapanStyle:Boolean):Boolean;
    //����������
    destructor Destroy;override;
    //����������� � �������
    //������ ������
    //(���� false ������ ���
    //�������� �������)
    function Next:Boolean;
    //����������� � �������
    //������ �����
    //(���� false ������ ���
    //�������� �������)
    function Prev:Boolean;
    //����������� � ������
    function StartPos:Boolean;
    //����������� � �����
    function EndPos:Boolean;
    //��������� �����������
    //�� ������
    function SetNumImage(Number:integer):Boolean;
    //��������� �� �����������
    //� ������
    function isEndIsList:Boolean;
    //������ �� �����������
    //� ������
    function isStartIsList:Boolean;
    //����������� � ������ �������
    //��������� �����
    function NextArchive:Boolean;
    //���������� �����
    function PrevArchive:Boolean;
    //��� ��������� ����� ������
    function isEndArchive:Boolean;
    //��� ������ ����� � ������
    function isStartArchive:Boolean;
    //�������� �������
    //�����������
    function GetBitmap:TIEBitmap;
    //�������� �� �������������
    function NotEmpty:boolean;
    //������� ������
    procedure ClearData(const AllClear:Boolean = true);
    //������ ��� ��� ����������
    procedure ClearToDirOpened;
    //�������� �������
    //� �������� Index
    function GetElement(Index:Integer):PCRFileRecord;overload;
    //�������� �������
    //� ������ Name
    function GetElement(Name:String):Integer;overload;
  end;

//���������� ��� �����
function GetFileType(fname:string):TCRDirFileType;
//���������� ��� ������
function GetArchiveType(fname:string):TCRArchiveType;

implementation

uses
  SysUtils, Graphics, MainForm,
  CRGlobal, CRImageVisual,
  DLLHeaders, ArcFunc;


{$REGION '������ � �������'}

//�����������
constructor TCRDir.Create;
begin
  //������ �������
  FArchives:=TStringList.Create;
  //������ ������������
  FTxtFiles:=TStringList.Create;
  //������ �����������
  FImages:=TList.Create;
  //������ ��������
  FBookmarks:=TList<TCRBookmark>.Create;
  //���� �������� ����� ���������
  //� false
  FComReadInfoFile:=false;
  //������� �� ������� ���������
  FPosition:=-1;
  FComplete:=false;
end;

//�����������
constructor TCRDir.Create(path:string);
begin
  //�������� ������������
  //����
  if path[Length(path)] <> '\' then
    path:=path+'\';
  //����� �����������
  Self.Create;
  //������� ������
  Self.CreateDataToDir(path);
end;

//������� �������� ������
function TCRDir.CreateDataToDir(path:WideString):Boolean;
  procedure FindFilesWithDir(NewPath:String);
  var
    //������ � �����
    findRes:TSearchRec;
  begin
    if NewPath[Length(NewPath)] <> '\' then
      NewPath:=NewPath+'\';
    //������������ ������� �����
    if FindFirst(NewPath+'*.*',faAnyFile,findRes) = 0 then
    begin
      //������ � �����
      //��� �����
      repeat
        NextFrameAnim;
        LoadFileToType(NewPath+findRes.Name);
      until FindNext(findRes) <> 0;
      //������ �� �����
      FindClose(findRes);
    end;
    //����� �����
    if FindFirst(NewPath+'*.*',faDirectory,findRes) = 0 then
    begin
      repeat
        if (findRes.Attr = faDirectory)and
          (findRes.Name <> '.') and (findRes.Name <> '..') then
          FindFilesWithDir(NewPath+findRes.Name);
      until FindNext(findRes) <> 0;
    end;
  end;
begin
  SetMainPath(PWideChar(PathToBaseDir));
  FGetOpenedArchive:='';
  FArchiveOpened:=false;
  //��������� �����������
  //��� ��������
  CenteredAnimsImage;

  //�������� ������ �� ����
  //��������� �����
  FindFilesWithDir(path);

  //������������ ����������� 
  UncenteredAnimsImage;
  FDirDirectory:=path;
  //��������� ������
  SortArchivesList(GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,'sort_arcopened',0));
  if (not NotEmpty) and (FArchives.Count > 0) then
    Exit(LoadArchive(FArchives.Strings[0],PathToBaseDir))
  else
    //��������� �����
    Exit(MainSortFiles(SortFileMode));
end;

//��������� �� ������ ������
function TCRDir.LoadFromStrings(Files:TStrings):Boolean;
var
  pos:integer;
  GetStr:String;
begin
  Result:=false;
  FGetOpenedArchive:='';
  FArchiveOpened:=false;
  if not ArcFunc.SetMainPath(PWideChar(PathToBaseDir)) then
    Exit;
  //��� ���� ����������������
  //����� ������ ���� � �������
  CenteredAnimsImage;
  for pos := 0 to files.Count-1 do
  begin
    NextFrameAnim;
    //������������ ����
    LoadFileToType(files.Strings[pos]);
  end;
  UncenteredAnimsImage;
  //��������� ������
  SortArchivesList(GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,'sort_arcopened',0));
  //����� � �������
  //��� �������� ������
  if EnableHistory then
    for GetStr in Archives do
      AddHistoryArc(PWideChar(GetStr));

  //���� ��� ��������� �����������
  //� ���� ������, �� ������
  //������ �����
  if (not NotEmpty) and (FArchives.Count > 0) then
    Exit(LoadArchive(FArchives.Strings[0],PathToBaseDir));
  Result:=true;
end;

//������� ������ �� ������
//��������� �����
function TCRDir.LoadArchive(fname:string;BaseDir:string):Boolean;
var
  //������� ��������
  //����������
  Complete:Boolean;
  //������� �������
  GetPos:Integer;
  //������ ��� ��������������
  WStr:WideString;
  //������ ��� ���������
  //��������
  ArrBookmarks:TWideCharHistoryArray;
  //������ ��������
  Bookmark:TCRBookmark;
begin
  ChangeCursor(1);
  Result:=false;
  FGetOpenedArchive:='';
  WStr:=fname;
  Complete:=false;
  case GetArchiveType(fname) of
    atRar:Complete:=ArcFunc.OpenArchive(PWideChar(WStr),0);
    atZip:Complete:=ArcFunc.OpenArchive(PWideChar(WStr),1);
    at7zip:Complete:=ArcFunc.OpenArchive(PWideChar(WStr),2);
    atUnknown:Complete:=false;//����������� �����
  end;
  if not Complete then
  begin
    ChangeCursor(0);
    Exit;
  end;
  FGetOpenedArchive:=fname;
  //������������� ���������
  //��� ��������� ��������� ������
  WStr:=BaseDir;
  //������������� ���� ��� ����������
  ArcFunc.SetMainPath(PWideChar(WStr));
  //����� ������ ������
  for GetPos:=0 to ArcFunc.CountFiles-1 do
  begin
    LoadFileToType(ArcFunc.GetFileName(GetPos));
    NextFrameAnimToCallBack;
  end;
  //��������� �����
  MainSortFiles(SortFileMode);
  //����� � �������
  //������� ����������� �����
  if EnableHistory then
  begin
    //��������� � ������� �������
    AddHistoryArc(PWideChar(fname));
    //��������� ���� �������
    LoadMenuToArcHistory;
    //���� �������� ��� ��������
    //������
    ArrBookmarks:=FindAllBookmarkArchive(PWideChar(fname),true);
    FBookmarks.Clear;
    if High(ArrBookmarks) > -1 then
    begin
      for GetPos:=0 to High(ArrBookmarks) do
      begin
        Bookmark.PageName:=ArrBookmarks[GetPos];
        Bookmark.NumberPage:=GetElement(Bookmark.PageName);
        FBookmarks.Add(Bookmark);
      end;
    end;
  end;
  FArchiveOpened:=true;
  Result:=True;
  ChangeCursor(0);
end;

//��������� ����
procedure TCRDir.LoadFileToType(fname:String);
begin
  //������������ ����
  case GetFileType(fname) of
    //���� � ��������� �����������
    ftTxt:
      FTxtFiles.Add(fname);
    //������
    ftArchive:
      //��������� � ������
      FArchives.Add(fname);
    //�����������
    ftImage:
      //��������� � ������������
      AddFile(fname);
  end;
end;

//��������� ����
function TCRDir.AddFile(fname:String):Integer;
var
  Rec:PCRFileRecord;
begin
  Result:=-1;
  New(Rec);
  if Rec = nil then
    Exit;  
  Rec.FileName:=fname;
  Rec.TransformMode:=0;
  Rec.TransformRotState:=0;
  FImages.Add(Rec);
  Result:=FImages.Count-1;
end;

//��������� ��� ���������
function TCRDir.LoadImage(Index:Integer):Boolean;
var
  Rec:PCRFileRecord;
  WDir:WideString;
  FileName:String;
begin
  Result:=false;
  if Index >= FImages.Count then
    Exit;
  FGetImagesDouble:=false;
  //�������� �������
  Rec:=FImages.Items[Index];
  try
    //���� ������ �����
    if FArchiveOpened then
    begin
      //��������� �� ������
      //�� ��������� �����
      WDir:=Rec.FileName;
      if not ArcFunc.ExtractSingleC(PWideChar(WDir)) then
        Exit;
      //�� ������ ���� ����
      //����� �������� �� ��������
      //������
      WDir:=StringReplace(WDir,'/','\',[rfReplaceAll]);
      //�������� ��� �����
      FileName:=PathToBaseDir + ExtractFileName(WDir);
    end else
      //�������� ��� �����
      FileName:=Rec.FileName;
    //��������� ���� ��������
    //� ������
    //FormMain.MainImage.IO.LoadFromFile(FileName);
    CreateImageResizer(FileName);
    //������ ������� ����� ���������
    if FArchiveOpened then
      DeleteFile(FileName);
    Result:=true;
  except
    //���-�� ����� �� ���
    Result:=false;
  end;
end;

//��������� ��������
//��� ���������
function TCRDir.LoadImageTwoPage(Index:Integer;JapanStyle:Boolean):Boolean;

//�������� ���� � ������������ ����
//���� ��� ���������
function FormingFilePath(FileName:String):String;
var
  WDir:WideString;
begin
  //���� ������ �����
  if FArchiveOpened then
  begin
    //��������� �� ������
    //�� ��������� �����
    WDir:=FileName;
    if not ArcFunc.ExtractSingleC(PWideChar(WDir)) then
      Exit;
    //�� ������ ���� ����
    //����� �������� �� ��������
    //������
    WDir:=StringReplace(WDir,'/','\',[rfReplaceAll]);
    //�������� ��� �����
    Result:=PathToBaseDir + ExtractFileName(WDir);
  end else
    //�������� ��� �����
    Result:=FileName;
end;

var
  Rec:PCRFileRecord;
  Rec2:PCRFileRecord;
  FlagTwo:Boolean;
  FileName:String;
  FileNameTwo:String;
  FileIO:TImageEnIO;
  FileProc:TImageEnProc;
  OneBitmap:TIEBitmap;
  TwoBitmap:TIEBitmap;
  ResultBitmap:TIEBitmap;
begin
  Result:=false;
  Rec2:=nil;
  FileProc:=nil;
  FileIO:=nil;
  if Index >= FImages.Count then
    Exit;
  //���� ���� �����
  //
  if FPrevPage then
  begin
    //�������� �������
    Rec:=FImages.Items[Index+1];
    if Index+1 < FImages.Count then
      Rec2:=FImages.Items[Index];
  end else
  begin
    //�������� �������
    Rec:=FImages.Items[Index];
    if Index+1 < FImages.Count then
      Rec2:=FImages.Items[Index+1];
  end;
  try
    FileName:=FormingFilePath(Rec.FileName);
    FileIO:=TImageEnIO.Create(nil);
    //��������� ������
    //����
    OneBitmap:=TIEBitmap.Create(nil);
    FileIO.IEBitmap:=OneBitmap;
    FileIO.LoadFromFile(FileName);
    //������ ���� �������
    //�� ����� ����������
    FlagTwo:=false;
    FileNameTwo:=FormingFilePath(Rec2.FileName);
    if (OneBitmap.Width < OneBitmap.Height) and (Index <> 0) and (Assigned(Rec2)) and (FileNameTwo <> '') then
    begin
      TwoBitmap:=TIEBitmap.Create(nil);
      FileIO.IEBitmap:=TwoBitmap;
      FileIO.LoadFromFile(FileNameTwo);
      FileProc:=TImageEnProc.Create(nil);
      //���� ������ �� ������� ��
      //�� ����� ����������
      if TwoBitmap.Width < OneBitmap.Height then
      begin
        //������������ �������
        ResultBitmap:=TIEBitmap.Create(nil);
        //���� ������ �� ������ ������
        if OneBitmap.Height > TwoBitmap.Height then
        begin
          //��������� ������
          FileProc.AttachedIEBitmap:=TwoBitmap;
          FileProc.Resample(-1,OneBitmap.Height);
        end else
        //���� ������ �� ������� ������
        begin
          //��������� ������
          FileProc.AttachedIEBitmap:=OneBitmap;
          FileProc.Resample(-1,TwoBitmap.Height);
        end;
        //������� ��� �������� � ����
        //��� � �������� �����
        if JapanStyle then
        begin
          ResultBitmap.AssignImage(TwoBitmap);
          ResultBitmap.Resize(OneBitmap.Width+TwoBitmap.Width,TwoBitmap.Height);
          OneBitmap.DrawToCanvas(ResultBitmap.Canvas,TwoBitmap.Width,0);
        end else
        //��� � ������� ����������
        begin
          ResultBitmap.AssignImage(OneBitmap);
          ResultBitmap.Resize(OneBitmap.Width+TwoBitmap.Width,TwoBitmap.Height);
          TwoBitmap.DrawToCanvas(ResultBitmap.Canvas,OneBitmap.Width,0);
        end;
        //FormMain.MainImage.IEBitmap.AssignImage(ResultBitmap);
        CreateImageResizer(ResultBitmap);
        //������ �� �����
        OneBitmap.Free;
        TwoBitmap.Free;
        ResultBitmap.Free;
        FileProc.Free;
        FileIO.Free;
        FlagTwo:=true;
        FGetImagesDouble:=true;
      end else
        TwoBitmap.Free;
    end;
    //���� �� ����������
    //������� ��� �����������
    //�� ������� ������ ����
    if not FlagTwo then
    begin
      //FormMain.MainImage.IEBitmap.AssignImage(OneBitmap);
      CreateImageResizer(OneBitmap);
      //������ �� �����
      OneBitmap.Free;
      try
        if Assigned(FileIO) then
          FileIO.Free;
        if Assigned(FileProc) then
          FileProc.Free;
      except
      end;
      FGetImagesDouble:=false;
    end;
    //������ ������� ����� ���������
    if FArchiveOpened then
    begin
      DeleteFile(FileName);
      DeleteFile(FileNameTwo);
    end;
    Result:=true;
  except
    //���-�� ����� �� ���
    Result:=false;
    if Assigned(FileIO) then
      FileIO.Free;
  end;
end;

//����������
destructor TCRDir.Destroy;
begin
  ClearData;
  FTxtFiles.Free;
  FArchives.Free;
  FImages.Free;
  FBookmarks.Free;
end;

{$ENDREGION}

{$REGION '������ �� �������'}

//����������� � �������
//������ ������
//(���� false ������ ���
//�������� �������)
function TCRDir.Next:boolean;
begin
  FPrevPage:=false;
  if FGetImagesDouble and not ReadBoolConfig('two_pages_long') then
  begin
    if FPosition < FImages.Count-1 then
    begin
      FPosition:=FPosition+2;
      if FPosition = FImages.Count then
        FPosition:=FImages.Count-1;
      Result:=true;
    end else
      Result:=false;
  end else
  begin
    if FPosition < FImages.Count-1 then
    begin
      FPosition:=FPosition+1;
      Result:=true;
    end else
      Result:=false;
  end;
end;

//����������� � �������
//������ �����
//(���� false ������ ���
//�������� �������)
function TCRDir.Prev:boolean;
begin
  FPrevPage:=false;
  if FGetImagesDouble and not ReadBoolConfig('two_pages_long') then
  begin
    if FPosition > 0 then
    begin
      FPosition:=FPosition-2;
      if FPosition < 0 then
        FPosition:=0;
      if FPosition > 1 then
        FPrevPage:=true;
      Result:=true;
    end else
      Result:=false;
  end else
  begin
    if FPosition > 0 then
    begin
      FPosition:=FPosition-1;
      Result:=true;
    end else
      Result:=false;
  end;
end;

//����������� � ������
function TCRDir.StartPos:boolean;
begin
  Result:=false;
  FPrevPage:=false;
  if Self.NotEmpty then
  begin
    FPosition:=0;
    Result:=true;
  end;
end;

//����������� � �����
function TCRDir.EndPos:boolean;
begin
  Result:=false;
  FPrevPage:=false;
  if Self.NotEmpty then
  begin
    FPosition:=FImages.Count-1;
    Result:=true;
  end;
end;

//��������� �����������
//�� ������
function TCRDir.SetNumImage(Number:integer):boolean;
begin
  Result:=false;
  FPrevPage:=false;
  if Number < FImages.Count then
  begin
    FPosition:=Number;
    Result:=true;
  end;
end;

//��������� �� �����������
//� ������
function TCRDir.isEndIsList:Boolean;
begin
  Result:=false;
  if Position = FImages.Count-1 then
    Result:=true;
end;

//������ �� �����������
//� ������
function TCRDir.isStartIsList:Boolean;
begin
  Result:=false;
  if (Position = 0) and (FImages.Count > 0) then
    Result:=true;
end;

//����������� � ������ �������
//��������� �����
function TCRDir.NextArchive:boolean;
begin
  Result:=false;
  if FArchivesPos < FArchives.Count then
  begin
    FArchivesPos:=FArchivesPos+1;
    Result:=true;
  end;
end;

//���������� �����
function TCRDir.PrevArchive:boolean;
begin
  Result:=false;
  if FArchivesPos > 0 then
  begin
    FArchivesPos:=FArchivesPos-1;
    Result:=true;
  end;
end;

//��� ��������� ����� ������
function TCRDir.isEndArchive:Boolean;
begin
  Result:=false;
  if FArchivesPos = FArchives.Count-1 then
    Result:=true;
end;

//��� ������ ����� � ������
function TCRDir.isStartArchive:Boolean;
begin
  Result:=false;
  if (FArchivesPos = 0) and (FArchives.Count > 0) then
    Result:=true;
end;

//�������� �������
//�����������
function TCRDir.GetBitmap:TIEBitmap;
begin
  Result:=nil;
  if (FPosition < 0) then
    Exit;
  if ReadBoolConfig('two_pages') and Self.LoadImageTwoPage(FPosition,ReadBoolConfig('two_pages_japan')) then
    Exit(FormMain.MainImage.IEBitmap);
  if Self.LoadImage(FPosition) then
    Result:=FormMain.MainImage.IEBitmap;
end;

//�������� �� �������������
function TCRDir.NotEmpty:boolean;
begin
  Result:=true;
  if FImages.Count = 0 then
    Result:=false;
end;

//�������� �������
//� �������� Index
function TCRDir.GetElement(Index:Integer):PCRFileRecord;
begin
  Result:=nil;
  if Index >= FImages.Count then
    Exit;
  Result:=FImages.Items[Index];
end;

//�������� �������
//� ������ Name
function TCRDir.GetElement(Name:String):Integer;
var
  GetPos:Integer;
begin
  if FImages.Count = 0 then
    Exit(-1);
  for GetPos:=0 to FImages.Count-1 do
    if PCRFileRecord(FImages.Items[GetPos]).FileName = Name then
      Exit(GetPos);
  Result:=-1;
end;

{$ENDREGION}

{$REGION '������ �� �����'}

//������� ������
procedure TCRDir.ClearData(const AllClear:Boolean = true);
var
  pos:integer;
  FileRec:PCRFileRecord;
  OldArc:Boolean;
begin
  //������� ��������� �����
  if FTxtFiles.Count > 0 then
    for pos := 0 to FTxtFiles.Count-1 do
      DeleteFile(FTxtFiles.Strings[pos]);
  FTxtFiles.Clear;
  if AllClear then
    FArchives.Clear;
  for pos := 0 to FImages.Count - 1 do
  begin
    FileRec:=FImages.Items[pos];
    //FileRec.Image.Free;
    Dispose(FileRec);
  end;
  FImages.Clear;
  FBookmarks.Clear;
  OldArc:=FArchiveOpened;
  FArchiveOpened:=false;
  FPosition:=-1;
  try
    //��������� �����
    if OldArc then
      CloseArchive;
  except
    //�� ������ ������
  end;
end;

//������ ��� ��� ����������
procedure TCRDir.ClearToDirOpened;
var
  pos:Integer;
begin
  if FTxtFiles.Count > 0 then
    for pos := 0 to FTxtFiles.Count-1 do
      DeleteFile(FTxtFiles.Strings[pos]);
  FTxtFiles.Clear;
  FImages.Clear;
  FBookmarks.Clear;
  FPosition:=-1;
  FArchiveOpened:=false;
  try
    ArcFunc.CloseArchive;
  except
    //��� �������������
  end;
end;

{$ENDREGION}

{$REGION '��������� �������'}

//���������� ��� �����
function GetFileType(fname:string):TCRDirFileType;
var
  FileExt:String;
begin
  //�������� ����������
  FileExt:=LowerCase(ExtractFileExt(fname));
  //���� ����������
  //�� ���������� �� ����������
  Result:=ftNone;
  //�����������
  if (FileExt = '.jpg')   or
     (FileExt = '.jpeg')  or
     (FileExt = '.jpe')  or
     (FileExt = '.jif')  or
     (FileExt = '.jp2')  or

     (FileExt = '.bmp')   or
     (FileExt = '.wmf')   or
     (FileExt = '.emf')   or
     (FileExt = '.gif')   or
     (FileExt = '.png')   or

     (FileExt = '.tif')   or
     (FileExt = '.tiff')  or
     (FileExt = '.fax')   or
     (FileExt = '.g3n')   or
     (FileExt = '.g3f')   or
     (FileExt = '.xif')   or
     (FileExt = '.psd')   or

     (FileExt = '.tga')   or
     (FileExt = '.targa') or
     (FileExt = '.vda')   or
     (FileExt = '.icb')   or
     (FileExt = '.vst')   or
     (FileExt = '.pix')   or

     (FileExt = '.dcx')   or
     (FileExt = '.wdp')   or
     (FileExt = '.hdp')   or
     (FileExt = '.wbmp') then
    Result:=ftImage;
  //������
  if (FileExt = '.zip') or
     (FileExt = '.rar') or
     (FileExt = '.cbr') or
     (FileExt = '.cbz') or
     (FileExt = '.7z') or
     (FileExt = '.cb7') or
     (FileExt = '.tar') or
     (FileExt = '.cbt') or
     (FileExt = '.arj') or
     (FileExt = '.cba') or
     (FileExt = '.gz') or
     (FileExt = '.cbg') then
    Result:=ftArchive;
  //���� � �����������
  if FileExt = '.txt' then
    Result:=ftTxt;
end;

//���������� ��� ������
function GetArchiveType(fname:string):TCRArchiveType;
var
  FileExt:String;
begin
    //�������� ����������
  FileExt:=LowerCase(ExtractFileExt(fname));
  //���� ����������
  //�� ���������� �� ����������
  Result:=atUnknown;
  if (FileExt = '.zip') or (FileExt = '.cbz') then
    Result:=atZip;
  if (FileExt = '.rar') or (FileExt = '.cbr') then
    Result:=atRar;
  //7zip,arj,tar,gz
  if (FileExt = '.7z') or (FileExt = '.cb7') or
     (FileExt = '.tar') or (FileExt = '.cbt') or
     (FileExt = '.arj') or (FileExt = '.cba') or
     (FileExt = '.gz') or (FileExt = '.cbg') then
    Result:=at7zip;
end;

{$ENDREGION}

end.
