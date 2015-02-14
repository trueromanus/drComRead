{
  drComRead

  ������ ��� ��������
  �������������� �������

  Copyright (c) 2008-2009 Romanus
}
unit FuncExports;

interface

uses
  Windows;

type
  //������� ����
  TFEWindowPosition = record
    //�������
    X,Y:Integer;
    //������
    Width:Integer;
    //�����
    Height:Integer;
  end;

{$REGION '���c�� �������'}

//���������� �������
function GetArchivesCount:Integer;stdcall;
//���������� ��� ������
function GetArchiv(Index:Integer):PWideChar;stdcall;
//���������� ����� ��� ��� ������
function SetNameArchiv(Index:Integer;NewName:PWideChar):Boolean;stdcall;
//���������� �������
//� ������ �������
function GetArchivPosition:Integer;stdcall;
//��������� �����
//� ��������� �������� �������
function GetArchivOpenIndex(Index:Integer):Boolean;stdcall;

{$ENDREGION}

{$REGION '���������'}

//��������� �����������
function Navigation_NextImage:Boolean;stdcall;
//���������� �����������
function Navigation_PrevImage:Boolean;stdcall;
//��������� �����������
function Navigation_StartImage:Boolean;stdcall;
//�������� �����������
function Navigation_EndImage:Boolean;stdcall;
//�������� ������� �������
function Navigation_Position:Integer;stdcall;
//��������� �����
function Navigation_NextArc:Boolean;stdcall;
//���������� �����
function Navigation_PrevArc:Boolean;stdcall;
//������ �����
function Navigation_StartArc:Boolean;stdcall;
//��������� �����
function Navigation_EndArc:Boolean;stdcall;
//������� � ������ �������
function Navigation_ArcPosition:Boolean;stdcall;
//���������� ����� �������
//� ������
function Navigation_NewPosition(Index:Integer):Boolean;stdcall;

{$ENDREGION}

{$REGION '������ �����������'}

//���������� �����������
function ListImage_Count:Integer;stdcall;
//�������� �����������
//�� ������
function ListImage_GetFileName(Index:Integer):PWideChar;stdcall;
//������������� �����������
//��� ������
function ListImage_SetFileName(Index:Integer;FileName:PWideChar):Boolean;stdcall;
function ListImage_SaveGetToFile(FileName:PWideChar):Boolean;stdcall;
function ListImage_SaveGetToClipboard:Boolean;stdcall;
function ListImage_RotateGetTo80CW:Boolean;stdcall;
function ListImage_RotateGetTo80CWAll:Boolean;stdcall;
function ListImage_RotateGetTo80CCW:Boolean;stdcall;
function ListImage_RotateGetTo80CCWAll:Boolean;stdcall;
//���������� ��������
//�������� �����������
function ListImage_FlipImage(Vert:Boolean):Boolean;stdcall;
//���������� ��������
//���� �����������
function ListImage_FlipImageAll(Vert:Boolean):Boolean;stdcall;
//������� ������� ����
//��� ����������� �������� �� ������
function ListImage_OpenArchive:Boolean;stdcall;

{$ENDREGION}

{$REGION '������ ��������� ������'}

//���������� ������
function TxtFiles_Count:Integer;stdcall;
//�������� ��� �����
function TxtFiles_GetFileName(Index:Integer):PWideChar;stdcall;
//��������� ����
//�� ��������� �����
function TxtFiles_ExtractByName(Name:PWideChar):Boolean;stdcall;

{$ENDREGION}

{$REGION '����'}

function Paths_GetApplicationPath():PWideChar;stdcall;
function Paths_GetTempPath():PWideChar;stdcall;

{$ENDREGION}

{$REGION '���������'}

//������ ���������
function Program_VersionProg:PWideChar;stdcall;
//������ �����������
function Program_ImageFilter:PWideChar;stdcall;
//������ ��� �������
function Program_ArchiveFilter:PWideChar;stdcall;
//����� ���������������
function Program_ImageMode:Byte;stdcall;
//��������� ������� ����
function Program_RunMenuCommand(Index:Integer):Boolean;stdcall;
//���������� ������
function Program_GetArrowCursor:HCURSOR;stdcall;
//����������� ������
function Program_GetLoadCursor:HCURSOR;stdcall;

{$ENDREGION}

{$REGION '������ ���������'}

//���������/����������
//������ ���������
function Scrolling_SetActiveScroll(Mode:Boolean):Boolean;stdcall;
//���������� ���������
//�������� ���������
function Scrolling_GetActiveScroll:Boolean;stdcall;

{$ENDREGION}

{$REGION '���� ���������'}

//������������� �� �����
//�����������
function Window_FullScreenMode:Boolean;stdcall;
//���������� �������
//� ������ ����� ����
function Window_GetWindowPosition:TFEWindowPosition;stdcall;
//������� �� ����
function Window_ActivatedWindow:Boolean;stdcall;
//���������� �������� �����
function Window_GetFormHandle:Pointer;stdcall;

{$ENDREGION}

{$REGION '�������������� ��������� � ������������'}

function GetConfigHandle:Integer;stdcall;
//�������� ������ ��������
//� ������
function MultiLanguage_GetGroupValue(Group,Key:PWideChar):PWideChar;stdcall;
//�������� �������� �� ����������
//������
function MultiLanguage_GetConfigValue(Key:PWideChar):PWideChar;stdcall;
//���������� �������� � ��������� ������
function MultiLanguage_SetConfigValue(Key,NewValue:PWideChar):Boolean;stdcall;

{$ENDREGION}

{$REGION '�������� � ��������'}

//������� �����������
//� �������� Index � ������
//���������� SortMode � �������
//��������� ��� ��� ������� ����� CaseSensitive
function ExtractImageWithIndex(ArcName:PWideChar;Index,SortMode:Integer;CaseSensitive:Boolean):PWideChar;stdcall;
//������� ����������� � ������ ImageName
function ExtractImageWithName(ArcName,ImageName:PWideChar):Boolean;stdcall;

{$ENDREGION}

{$REGION '������������'}

//��������� ������������
//�� ������������ ��������
function ShowDocumentation(Page:PWideChar):Boolean;
//�������� ���� � ����� ������
function GetGifFileDocumentation:PWideChar;

{$ENDREGION}

{$REGION '�����������'}

//������ ��������� � ���
function PrintToProgramLog(Msg:PWideChar;Group:PWideChar):Boolean;
//������ ������ � ���
function PrintErrorToProgramLog(Msg:PWideChar;Group:PWideChar):Boolean;

{$ENDREGION}

implementation

uses
  Forms, Clipbrd, Classes, SysUtils, Controls,
  Generics.Collections, Generics.Defaults,
  MainForm,
  CRGlobal, CRDir, CRImageVisual, CRLog,
  DllHeaders, ArcFunc;

function FEStringToWideString(Str:String):PWideChar;
var
  WStr:WideString;
begin
  WStr:=Str;
  Result:=PWideChar(WStr);
end;

{$REGION '���c�� �������'}

//�������� � ��������
//���������� �������
function GetArchivesCount:Integer;
begin
  Result:=DirObj.Archives.Count;
end;

//���������� ��� ������
function GetArchiv(Index:Integer):PWideChar;
begin
  Result:='';
  if (Index >= DirObj.Archives.Count) or (Index < 0) then
    Exit;
  Result:=FEStringToWideString(DirObj.Archives.Strings[Index]);
end;

//���������� ����� ��� ��� ������
function SetNameArchiv(Index:Integer;NewName:PWideChar):Boolean;stdcall;
begin
  Result:=false;
  if (Index >= DirObj.Archives.Count) or (Index < 0) then
    Exit;
  DirObj.Archives.Strings[Index]:=NewName;
  Result:=true;
end;

//���������� �������
//� ������ �������
function GetArchivPosition:Integer;
begin
  Result:=DirObj.ArchivesPos;
end;

//��������� �����
//� ��������� �������� �������
function GetArchivOpenIndex(Index:Integer):Boolean;
begin
  LoadToArchiveNumber(Index);
  Result:=true;
end;

{$ENDREGION}

{$REGION '���������'}

//��������� �����������
function Navigation_NextImage:Boolean;
begin
  Result:=FormMain.LoadNavigateBitmap(1);
end;

//���������� �����������
function Navigation_PrevImage:Boolean;
begin
  Result:=FormMain.LoadNavigateBitmap(2);
end;

//��������� �����������
function Navigation_StartImage:Boolean;
begin
  Result:=FormMain.LoadNavigateBitmap(0);
end;

//�������� �����������
function Navigation_EndImage:Boolean;
begin
  Result:=FormMain.LoadNavigateBitmap(3);
end;

//�������� ������� �������
function Navigation_Position:Integer;
begin
  Result:=DirObj.Position;
end;

//��������� �����
function Navigation_NextArc:Boolean;
begin
  FormMain.Menu_NextArchiveClick(nil);
  Result:=true;
end;

//���������� �����
function Navigation_PrevArc:Boolean;
begin
  FormMain.Menu_PrevArchiveClick(nil);
  Result:=true;
end;

//������ �����
function Navigation_StartArc:Boolean;stdcall;
begin
  FormMain.Menu_StartArchiveClick(nil);
  Result:=true;
end;

//��������� �����
function Navigation_EndArc:Boolean;stdcall;
begin
  FormMain.Menu_EndArchiveClick(nil);
  Result:=true;
end;

//������� � ������ �������
function Navigation_ArcPosition:Boolean;
begin
  FormMain.Menu_PrevArchiveClick(nil);
  Result:=true;
end;

//���������� ����� �������
//� ������
function Navigation_NewPosition(Index:Integer):Boolean;stdcall;
begin
  Result:=FormMain.LoadNavigateBitmap(4,Index);
end;

{$ENDREGION}

{$REGION '������ �����������'}

//���������� �����������
function ListImage_Count:Integer;
begin
  Result:=DirObj.BitmapList.Count;
end;

//�������� �����������
//�� ������
function ListImage_GetFileName(Index:Integer):PWideChar;
var
  FileRecord:PCRFileRecord;
  WStr:WideString;
begin
  Result:='';
  if (Index >= DirObj.BitmapList.Count) or (Index < 0) then
    Exit;
  FileRecord:=DirObj.BitmapList.Items[Index];
  WStr:=FileRecord.FileName;
  Result:=PWideChar(WStr);
end;

//������������� �����������
//��� ������
function ListImage_SetFileName(Index:Integer;FileName:PWideChar):Boolean;
var
  FileRecord:PCRFileRecord;
begin
  Result:=false;
  if Index >= DirObj.BitmapList.Count then
    Exit;
  FileRecord:=DirObj.BitmapList.Items[Index];
  FileRecord.FileName:=FileName;
  Result:=true;
end;

function ListImage_SaveGetToFile(FileName:PWideChar):Boolean;stdcall;
var
  Ext:string;
begin
  Result:=false;
  //���� ��� �����������
  //������ � ���������
  if DirObj.BitmapList.Count = 0 then
    Exit;
  DirObj.GetBitmap;
  if FormMain.MainImage.LayersCount = 0 then
    Exit;
  Ext:=ExtractFileExt(FileName);
  Ext:=LowerCase(Ext);
  try
    //��������� � bmp
    if Ext = '.bmp' then
      FormMain.MainImage.IO.SaveToFileBMP(FileName);
    //��������� � tiff
    if (Ext = '.tif') or (Ext = '.tiff') then
      FormMain.MainImage.IO.SaveToFileTIFF(FileName);
    //��������� � jpeg
    if (Ext = '.jpg') or (Ext = '.jpeg') then
      FormMain.MainImage.IO.SaveToFileJpeg(FileName);
    //��������� � psd
    if (Ext = '.psd') then
      FormMain.MainImage.IO.SaveToFilePSD(FileName);
    //��������� � pdf
    if (Ext = '.pdf') then
      FormMain.MainImage.IO.SaveToFilePDF(FileName);
    //��������� � gif
    if (Ext = '.gif') then
      FormMain.MainImage.IO.SaveToFileGIF(FileName);
    //��������� � png
    if (Ext = '.png') then
      FormMain.MainImage.IO.SaveToFilePNG(FileName);
    //��������� � tga
    if (Ext = '.tga') then
      FormMain.MainImage.IO.SaveToFileTGA(FileName);
    //��������� � hdp
    if (Ext = '.hdp') then
      FormMain.MainImage.IO.SaveToFileHDP(FileName);
    Result:=true;
  except
    //������ ����������
  end;
end;

function ListImage_SaveGetToClipboard:Boolean;stdcall;
begin
  Result:=false;
  //���� ��� �����������
  //������ � ���������
  if DirObj.BitmapList.Count = 0 then
    Exit;
  DirObj.GetBitmap;
  if FormMain.MainImage.LayersCount = 0 then
    Exit;
  try
    FormMain.MainImage.Proc.CopyToClipboard();
    Result:=true;
  except
    //������ ����������
  end;
end;

function ListImage_RotateGetTo80CW:Boolean;stdcall;
var
  FileRec:PCRFileRecord;
begin
  Result:=false;
  //���� ��� �����������
  //������ � ������������
  if DirObj.BitmapList.Count = 0 then
    Exit(false);
  FileRec:=DirObj.GetElement(DirObj.Position);
  if FileRec = nil then
    Exit;
  try
    FileRec:=DirObj.GetElement(DirObj.Position);
    FileRec.TransformMode:=1;
    if FileRec.TransformRotState = 3 then
    begin
      //���� ������������
      //���������
      FileRec.TransformRotState:=0;
      FileRec.TransformMode:=0;
    end else
      Inc(FileRec.TransformRotState);
    MainForm.FormMain.LoadNavigateBitmap(4,DirObj.Position);
    Result:=true;
  except
    Result:=false;
  end;
end;

function ListImage_RotateGetTo80CWAll:Boolean;stdcall;
var
  FileRec:PCRFileRecord;
  GetPos:Integer;
begin
  //���� ��� �����������
  //������ � ������������
  if DirObj.BitmapList.Count = 0 then
    Exit(false);
  for GetPos:=0 to DirObj.BitmapList.Count-1 do
  begin
    FileRec:=DirObj.GetElement(GetPos);
    if FileRec = nil then
      Exit(false);
    try
      FileRec.TransformMode:=1;
      if FileRec.TransformRotState = 3 then
      begin
        //���� ������������
        //���������
        FileRec.TransformRotState:=0;
        FileRec.TransformMode:=0;
      end else
        Inc(FileRec.TransformRotState);
    except
      //���� ���������
      //����� �� �������
      Exit(false);
    end;
  end;
  MainForm.FormMain.LoadNavigateBitmap(4,DirObj.Position);
  Result:=true;
end;

function ListImage_RotateGetTo80CCW:Boolean;stdcall;
var
  FileRec:PCRFileRecord;
begin
  //���� ��� �����������
  //������ � ������������
  if DirObj.BitmapList.Count = 0 then
    Exit(false);
  FileRec:=DirObj.GetElement(DirObj.Position);
  if FileRec = nil then
    Exit(false);
  try
    FileRec:=DirObj.GetElement(DirObj.Position);
    FileRec.TransformMode:=2;
    if FileRec.TransformRotState = 1 then
    begin
      FileRec.TransformRotState:=0;
      FileRec.TransformMode:=0;
    end;
    if FileRec.TransformRotState = 0 then
      FileRec.TransformRotState:=4;
    Dec(FileRec.TransformRotState);
    MainForm.FormMain.LoadNavigateBitmap(4,DirObj.Position);
    Result:=true;
  except
    Result:=false;
  end;
end;

function ListImage_RotateGetTo80CCWAll:Boolean;stdcall;
var
  FileRec:PCRFileRecord;
  GetPos:Integer;
begin
  //���� ��� �����������
  //������ � ������������
  if DirObj.BitmapList.Count = 0 then
    Exit(false);
  for GetPos:=0 to DirObj.BitmapList.Count-1 do
  begin
    FileRec:=DirObj.GetElement(GetPos);
    if FileRec = nil then
      Exit(false);
    try
      FileRec.TransformMode:=2;
      if FileRec.TransformRotState = 1 then
      begin
        FileRec.TransformRotState:=0;
        FileRec.TransformMode:=0;
      end;
      Dec(FileRec.TransformRotState);
    except
      Exit(false);
    end;
  end;
  MainForm.FormMain.LoadNavigateBitmap(4,DirObj.Position);
  Result:=true;
end;

//���������� ��������
//�������� �����������
function ListImage_FlipImage(Vert:Boolean):Boolean;stdcall;
var
  FileRec:PCRFileRecord;
begin
  //���� ��� �����������
  //������ � ������������
  if DirObj.BitmapList.Count = 0 then
    Exit(false);
  FileRec:=DirObj.GetElement(DirObj.Position);
  if FileRec = nil then
    Exit(false);
  try
    FileRec:=DirObj.GetElement(DirObj.Position);
    if Vert then
      FileRec.TransformMode:=4
    else
      FileRec.TransformMode:=3;
    MainForm.FormMain.LoadNavigateBitmap(4,DirObj.Position);
    Result:=true;
  except
    Result:=false;
  end;
end;

//���������� ��������
//���� �����������
function ListImage_FlipImageAll(Vert:Boolean):Boolean;stdcall;
var
  FileRec:PCRFileRecord;
  GetPos:Integer;
begin
  //���� ��� �����������
  //������ � ������������
  if DirObj.BitmapList.Count = 0 then
    Exit(false);
  for GetPos:=0 to DirObj.BitmapList.Count-1 do
  begin
    FileRec:=DirObj.GetElement(GetPos);
    if FileRec = nil then
      Exit(false);
    try
      if Vert then
        FileRec.TransformMode:=4
      else
        FileRec.TransformMode:=3;
    except
      Exit(false);
    end;
  end;
  MainForm.FormMain.LoadNavigateBitmap(4,DirObj.Position);
  Result:=true;
end;

//�������� ������� ����
//��� ����������� �������� �� ������
function ListImage_OpenArchive:Boolean;
begin
  Result:=DirObj.ArchiveOpened;
end;

{$ENDREGION}

{$REGION '������ ��������� ������'}

function TxtFiles_Count:Integer;
begin
  Result:=DirObj.TxtFiles.Count;
end;

function TxtFiles_GetFileName(Index:Integer):PWideChar;
var
  WStr:WideString;
begin
  Result:='';
  if Index >= DirOBj.TxtFiles.Count then
    Exit;
  WStr:=DirObj.TxtFiles.Strings[Index];
  Result:=PWideChar(WStr);
end;

//��������� ����
//�� ��������� �����
function TxtFiles_ExtractByName(Name:PWideChar):Boolean;stdcall;
begin
  try
    if not ArcFunc.ExtractSingleC(Name) then
      Exit(false);
    Result:=true;
  except
    Result:=false;
  end;
end;

{$ENDREGION}

{$REGION '����'}

function Paths_GetApplicationPath():PWideChar;
var
  WStr:WideString;
begin
  WStr:=PathToProgramDir;
  Result:=PWideChar(WStr);
end;

function Paths_GetTempPath():PWideChar;
begin
  Result:=PWideChar(PathToBaseDir);
end;

{$ENDREGION}

{$REGION '���������'}

//������ ���������
function Program_VersionProg:PWideChar;
begin
  Result:=FEStringToWideString(PROGRAM_VERSION);
end;

//������ �����������
function Program_ImageFilter:PWideChar;
begin
  Result:=FEStringToWideString(IMAGE_FILTER);
end;

//������ ��� �������
function Program_ArchiveFilter:PWideChar;
begin
  Result:=FEStringToWideString(ARC_FILTER);
end;

//����� ���������������
function Program_ImageMode:Byte;
begin
  Result:=ImageMode;
end;

//��������� ������� ����
function Program_RunMenuCommand(Index:Integer):Boolean;stdcall;
begin
  with MainForm.FormMain do
  begin
    case Index of
      //������� �����
      1:FormMain.Menu_OpenDirClick(nil);
      //������� ����
      2:FormMain.Menu_OpenFileClick(nil);
      //������� ����
      3:FormMain.Menu_CloseCurrentClick(nil);
      //���������� ������
      4:FormMain.Menu_SortFilesClick(nil);
      //���������� �������
      5:FormMain.Menu_ArchiveListClick(nil);
      //���������� � �����
      6:FormMain.Menu_FileInfoClick(nil);
      //��������� �����������
      7:FormMain.Menu_NextImageClick(nil);
      //���������� �����������
      8:FormMain.Menu_PrevImageClick(nil);
      //��������� �����������
      9:FormMain.Menu_StartImageClick(nil);
      //�������� �����������
      10:FormMain.Menu_EndImageClick(nil);
      //��������� �����
      11:FormMain.Menu_NextArchiveClick(nil);
      //���������� �����
      12:FormMain.Menu_PrevArchiveClick(nil);
      //��������� �����
      13:FormMain.Menu_StartArchiveClick(nil);
      //�������� �����
      14:FormMain.Menu_EndArchiveClick(nil);
      //������ �����
      15:FormMain.Menu_FullScreenClick(nil);
      //��������� �����������
      16:FormMain.Menu_SinglePreviewClick(nil);
      //��������������
      17:FormMain.Menu_MinimizeClick(nil);
      //���������
      18:FormMain.Menu_NavigatorClick(nil);
      //���������������
      19:FormMain.Menu_ZoomClick(nil);
      //��������� �� ������
      20:FormMain.Menu_StretchClick(nil);
      //��������� �� ������
      21:FormMain.Menu_FitHeightClick(nil);
      //��������
      22:FormMain.Menu_OriginalClick(nil);
      //�����
      23:FormMain.Menu_ExitClick(nil);
      //80CW
      24:ListImage_RotateGetTo80CW;
      //80CCW
      25:ListImage_RotateGetTo80CCW;
      //Flip -
      26:ListImage_FlipImage(true);
      //Flip |
      27:ListImage_FlipImage(false);
      //80CW ���
      28:;
      //80CCW ���
      29:;
      //Flip - ���
      30:;
      //Flip | ���
      31:;
      //mouser
      32:FormMain.Menu_MouserClick(nil);
    end;
  end;
  Result:=true;
end;

//���������� ������
function Program_GetArrowCursor:HCURSOR;
begin
  Result:=HCURSOR(Screen.Cursors[crArrow]);
end;

//����������� ������
function Program_GetLoadCursor:HCURSOR;
begin
  Result:=HCURSOR(Screen.Cursors[crHourGlass]);
end;

{$ENDREGION}

{$REGION '������ ���������'}

//���������/����������
//������ ���������
function Scrolling_SetActiveScroll(Mode:Boolean):Boolean;
begin
  try
    if Mode then
    begin
      ActiveScroll.Activate;
    end else
    begin
      ActiveScroll.DeActivate;
    end;
    Result:=true;      
  except
    Result:=false;
  end;
end;
//���������� ���������
//�������� ���������
function Scrolling_GetActiveScroll:Boolean;
begin
  Result:=ActiveScroll.Active;  
end;

{$ENDREGION}

{$REGION '���� ���������'}

//������������� �� �����
//�����������
function Window_FullScreenMode:Boolean;
begin
  Result:=false;
  if FormMain.FormStyle = fsStayOnTop then
    Result:=true;
end;

//���������� �������
//� ������ ����� ����
function Window_GetWindowPosition:TFEWindowPosition;
begin
  Result.X:=FormMain.Left;
  Result.Y:=FormMain.Top;
  Result.Width:=FormMain.Width;
  Result.Height:=FormMain.Height;
end;

//������� �� ����
function Window_ActivatedWindow:Boolean;
begin
  Result:=FormMain.Active;
end;

//���������� �������� �����
function Window_GetFormHandle:Pointer;
begin
  Result:=Application;
end;

{$ENDREGION}

{$REGION '�������������� ���������'}

function GetConfigHandle:Integer;
begin
  Result:=MainLangHandle;
end;

//�������� ������ ��������
//� ������
function MultiLanguage_GetGroupValue(Group,Key:PWideChar):PWideChar;
begin
  Result:=PWideChar(GlobalLangData.ReadString(Group,Key,''));
end;

//�������� �������� �� ����������
//������
function MultiLanguage_GetConfigValue(Key:PWideChar):PWideChar;
begin
  Result:=PWideChar(GlobalConfigData.ReadString(CONFIG_MAINSECTION,WideCharToString(Key),''));
end;

//���������� �������� � ��������� ������
function MultiLanguage_SetConfigValue(Key,NewValue:PWideChar):Boolean;
begin
  GlobalConfigData.WriteString(CONFIG_MAINSECTION,Key,NewValue);
  Result:=true;
end;

{$ENDREGION}

{$REGION '�������� � ��������'}

//������� �����������
//� �������� Index � ������
//���������� SortMode � �������
//��������� ��� ��� ������� ����� CaseSensitive
function ExtractImageWithIndex(ArcName:PWideChar;Index,SortMode:Integer;CaseSensitive:Boolean):PWideChar;
var
  Arc:T7Zip;
  GetPos:Integer;
  ImagesList:TList<String>;
begin
  Result:=PWideChar('');
  try
    Arc:=T7Zip.Create(ArcName);
    ImagesList:=TList<String>.Create();
    //��� ����� �� ������
    //��� ������ ����� �� ��������
    //������ ������ � ������
    if not Arc.TestArchive or not Arc.ReadListOfFiles then
      Exit;
    //�������� ������ �����������
    for GetPos:=0 to Arc.Files.Count-1 do
      if GetFileType(Arc.Files.Strings[GetPos]) = ftImage then
        ImagesList.Add(Arc.Files.Strings[GetPos]);
    //��������� ������ �� ���������
    if Index >= ImagesList.Count then
      Exit;
    //��������� ������
    case SortMode of
      0:;
      //��������� � ������� ������
      1:ImagesList.Sort(TComparer<String>.Construct(
        function (const L, R: String): integer
        var
          NL,NR:String;
        begin
          NL:=L;
          NR:=R;
          if CaseSensitive then
          begin
            NL:=LowerCase(NL);
            NR:=LowerCase(NR);
          end;
          if NL < NR then
            Exit(-1);
          if NL = NR then
            Exit(0)
          else
            Exit(1);
        end
       ));
      2:ImagesList.Sort(TComparer<String>.Construct(
        function (const L, R: String): integer
        var
          NL,NR:string;
        begin
          if CaseSensitive then
          begin
            NL:=LowerCase(L);
            NR:=LowerCase(R);
          end;
          if NL > NR then
            Exit(-1);
          if NL = NR then
            Exit(0)
          else
            Exit(1);
        end
       ));
      3:ImagesList.Sort(TComparer<String>.Construct(
        function (const L, R: String): integer
        var
          NL,NR:string;
        begin
          NL:=ExtractFileName(L);
          NR:=ExtractFileName(R);
          if CaseSensitive then
          begin
            NL:=LowerCase(NL);
            NR:=LowerCase(NR);
          end;
          if NL < NR then
            Exit(-1);
          if NL = NR then
            Exit(0)
          else
            Exit(1);
        end
       ));
      4:ImagesList.Sort(TComparer<String>.Construct(
        function (const L, R: String): integer
        var
          NL,NR:string;
        begin
          NL:=ExtractFileName(L);
          NR:=ExtractFileName(R);
          if CaseSensitive then
          begin
            NL:=LowerCase(NL);
            NR:=LowerCase(NR);
          end;
          if NL > NR then
            Exit(-1);
          if NL = NR then
            Exit(0)
          else
            Exit(1);
        end
       ));
    end;
    //��������� ����������� �� �������
    if Arc.ExtractByName(PathToBaseDir,ImagesList.Items[Index]) then
      Result:=PWideChar(PathToBaseDir+ExtractFileName(ImagesList.Items[Index]));
    ImagesList.Free;
    FreeAndNil(Arc);
  except
    if Assigned(Arc) then
      FreeAndNil(Arc);
    if Assigned(ImagesList) then
      FreeAndNil(ImagesList);
  end;
end;

//������� ����������� � ������ ImageName
function ExtractImageWithName(ArcName,ImageName:PWideChar):Boolean;
var
  Arc:T7Zip;
  NImageName:String;
begin
  try
    Arc:=T7Zip.Create(ArcName);
    //��������� �����
    //� ������ ������ ������
    if not Arc.TestArchive then
      Exit(false);
    if not Arc.ReadListOfFiles then
      Exit(false);
    NImageName:=ImageName;
    NImageName:=StringReplace(NImageName,'/','\',[rfReplaceAll]);
    Result:=Arc.ExtractByName(PathToBaseDir,NImageName);
    FreeAndNil(Arc);
  except
    Result:=false;
    if Assigned(Arc) then
      FreeAndNil(Arc);
  end;
end;

{$ENDREGION}

{$REGION '������������'}

//��������� ������������
//�� ������������ ��������
function ShowDocumentation(Page:PWideChar):Boolean;
var
  Lang:String;
begin
  Lang:=GlobalConfigData.ReadString(CONFIG_MAINSECTION,'defaultlng','');
  Lang:=Copy(Lang,0,Pos('.',Lang)-1);
  PrintToLog('Program.FuncExports.ShowDocumentation(' + Lang + ',' + PROGRAM_VERSION + ',' + Page + ')');
  Result:=ShowDocumentationDialog(PWideChar(Lang),PWideChar(PROGRAM_VERSION),Page);
end;
//�������� ���� � ����� ������
function GetGifFileDocumentation:PWideChar;
var
  FullPath:String;
begin
  FullPath:=PathToProgramDir+'data\help.bmp';
  PrintToLog('Program.FuncExports.GetGifFileDocumentation(' + FullPath + ')');
  Result:=PWideChar(FullPath);
end;

{$ENDREGION}

{$REGION '�����������'}

//������ ��������� � ���
function PrintToProgramLog(Msg:PWideChar;Group:PWideChar):Boolean;
var
  Srt,Grp:String;
begin
  Srt:=Msg;
  Grp:=Group;
  PrintToLog(Srt,Grp);
end;

//������ ������ � ���
function PrintErrorToProgramLog(Msg:PWideChar;Group:PWideChar):Boolean;
begin
  PrintErrorToLog(Msg,Group);
end;

{$ENDREGION}

end.

