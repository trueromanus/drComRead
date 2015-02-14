{
  drComRead

  �������� ������������ ����
  ��� ��������� dll ����������
  � api �������� ���������

  Copyright (c) 2010-2011 Romanus
}
unit MainProgramHeader;

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

var

{$REGION '���c�� �������'}

  //���������� �������
  GetArchivesCount:function:Integer;stdcall;
  //���������� ��� ������
  GetArchiv:function(Index:Integer):PWideChar;stdcall;
  //���������� ����� ��� ��� ������
  SetNameArchiv:function(Index:Integer;NewName:PWideChar):Boolean;stdcall;
  //���������� �������
  //� ������ �������
  GetArchivPosition:function:Integer;stdcall;
  //��������� �����
  //� ��������� �������� �������
  GetArchivOpenIndex:function(Index:Integer):Boolean;stdcall;

{$ENDREGION}

{$REGION '���������'}

  //��������� �����������
  Navigation_NextImage:function:Boolean;stdcall;
  //���������� �����������
  Navigation_PrevImage:function:Boolean;stdcall;
  //��������� �����������
  Navigation_StartImage:function:Boolean;stdcall;
  //�������� �����������
  Navigation_EndImage:function:Boolean;stdcall;
  //�������� ������� �������
  Navigation_Position:function:Integer;stdcall;
  //��������� �����
  Navigation_NextArc:function:Boolean;stdcall;
  //���������� �����
  Navigation_PrevArc:function:Boolean;stdcall;
  //������ �����
  Navigation_StartArc:function:Boolean;stdcall;
  //��������� �����
  Navigation_EndArc:function:Boolean;stdcall;
  //������� � ������ �������
  Navigation_ArcPosition:function:Boolean;stdcall;
  //���������� ����� �������
  //� ������
  Navigation_NewPosition:function(Index:Integer):Boolean;stdcall;

{$ENDREGION}

{$REGION '������ �����������'}

  //���������� �����������
  ListImage_Count:function:Integer;stdcall;
  //�������� �����������
  //�� ������
  ListImage_GetFileName:function(Index:Integer):PWideChar;stdcall;
  //������������� �����������
  //��� ������
  ListImage_SetFileName:function(Index:Integer;FileName:PWideChar):Boolean;stdcall;
  ListImage_SaveGetToFile:function(FileName:PWideChar):Boolean;stdcall;
  ListImage_SaveGetToClipboard:function:Boolean;stdcall;
  ListImage_RotateGetTo80CW:function:Boolean;stdcall;
  ListImage_RotateGetTo80CWAll:function:Boolean;stdcall;
  ListImage_RotateGetTo80CCW:function:Boolean;stdcall;
  ListImage_RotateGetTo80CCWAll:function:Boolean;stdcall;
  //���������� ��������
  //�������� �����������
  ListImage_FlipImage:function(Vert:Boolean):Boolean;stdcall;
  //���������� ��������
  //���� �����������
  ListImage_FlipImageAll:function(Vert:Boolean):Boolean;stdcall;
  //�������� ������� ����
  //��� ����������� �������� �� ������
  ListImage_OpenArchive:function:Boolean;stdcall;

{$ENDREGION}

{$REGION '������ ��������� ������'}

  //���������� ������
  TxtFiles_Count:function:Integer;stdcall;
  //�������� ��� �����
  TxtFiles_GetFileName:function(Index:Integer):PWideChar;stdcall;
  //��������� ����
  //�� ��������� �����
  TxtFiles_ExtractByName:function(Name:PWideChar):Boolean;stdcall;

{$ENDREGION}

{$REGION '����'}

  Paths_GetApplicationPath:function():PWideChar;stdcall;
  Paths_GetTempPath:function:PWideChar;stdcall;

{$ENDREGION}

{$REGION '���������'}

  //������ ���������
  Program_VersionProg:function:PWideChar;stdcall;
  //������ �����������
  Program_ImageFilter:function:PWideChar;stdcall;
  //������ ��� �������
  Program_ArchiveFilter:function:PWideChar;stdcall;
  //����� ���������������
  Program_ImageMode:function:Byte;stdcall;
  //��������� ������� ����
  Program_RunMenuCommand:function(Index:Integer):Boolean;stdcall;
  //���������� ������
  Program_GetArrowCursor:function:HCURSOR;stdcall;
  //����������� ������
  Program_GetLoadCursor:function:HCURSOR;stdcall;

{$ENDREGION}

{$REGION '������ ���������'}

  //���������/����������
  //������ ���������
  Scrolling_SetActiveScroll:function(Mode:Boolean):Boolean;stdcall;
  //���������� ���������
  //�������� ���������
  Scrolling_GetActiveScroll:function:Boolean;stdcall;

{$ENDREGION}

{$REGION '���� ���������'}

  //������������� �� �����
  //�����������
  Window_FullScreenMode:function:Boolean;stdcall;
  //���������� �������
  //� ������ ����� ����
  Window_GetWindowPosition:function:TFEWindowPosition;stdcall;
  //������� �� ����
  Window_ActivatedWindow:function:Boolean;stdcall;
  //���������� �������� �����
  Window_GetFormHandle:function:Pointer;stdcall;


{$ENDREGION}

{$REGION '�������������� ��������� � ������������'}

  GetConfigHandle:function:Integer;stdcall;
  //�������� ������ ��������
  //� ������
  MultiLanguage_GetGroupValue:function(Group,Key:PWideChar):PWideChar;stdcall;
  //�������� �������� �� ����������
  //������
  MultiLanguage_GetConfigValue:function(Key:PWideChar):PWideChar;stdcall;
  //���������� �������� � ��������� ������
  MultiLanguage_SetConfigValue:function(Key,NewValue:PWideChar):Boolean;stdcall;

{$ENDREGION}

{$REGION '�������� � ��������'}

  ExtractImageWithIndex:function(ArcName:PWideChar;Index,SortMode:Integer;CaseSensitive:Boolean):PWideChar;stdcall;
  //������� ����������� � ������ ImageName
  ExtractImageWithName:function(ArcName,ImageName:PWideChar):Boolean;stdcall;

{$ENDREGION}

{$REGION '������������'}

  //��������� ������������
  //�� ������������ ��������
  ShowDocumentation:function(Page:PWideChar):Boolean;
  //�������� ���� � ����� ������
  GetGifFileDocumentation:function:PWideChar;

{$ENDREGION}

{$REGION '�����������'}

  //������ ��������� � ���
  PrintToProgramLog:function(Msg:PWideChar;Group:PWideChar):Boolean;
  //������ ������ � ���
  PrintErrorToProgramLog:function(Msg:PWideChar;Group:PWideChar):Boolean;

{$ENDREGION}

  //���� �������� �������
  CursorsIsLoading:Boolean = false;

procedure InitLinks;

//��������� �������
procedure CursorsLoading;

implementation

uses
  Forms,Controls;

procedure InitLinks;
begin

{$REGION '���c�� �������'}

  //���������� �������
  GetArchivesCount:=GetProcAddress(MainInstance,'GetArchivesCount');
  //���������� ��� ������
  GetArchiv:=GetProcAddress(MainInstance,'GetArchiv');
  //���������� ����� ��� ��� ������
  SetNameArchiv:=GetProcAddress(MainInstance,'SetNameArchiv');
  //���������� �������
  //� ������ �������
  GetArchivPosition:=GetProcAddress(MainInstance,'GetArchivPosition');
  //��������� �����
  //� ��������� �������� �������
  GetArchivOpenIndex:=GetProcAddress(MainInstance,'GetArchivOpenIndex');

{$ENDREGION}

{$REGION '���������'}

  //��������� �����������
  Navigation_NextImage:=GetProcAddress(MainInstance,'Navigation_NextImage');
  //���������� �����������
  Navigation_PrevImage:=GetProcAddress(MainInstance,'Navigation_PrevImage');
  //��������� �����������
  Navigation_StartImage:=GetProcAddress(MainInstance,'Navigation_StartImage');
  //�������� �����������
  Navigation_EndImage:=GetProcAddress(MainInstance,'Navigation_EndImage');
  //�������� ������� �������
  Navigation_Position:=GetProcAddress(MainInstance,'Navigation_Position');
  //��������� �����
  Navigation_NextArc:=GetProcAddress(MainInstance,'Navigation_NextArc');
  //���������� �����
  Navigation_PrevArc:=GetProcAddress(MainInstance,'Navigation_PrevArc');
  //������ �����
  Navigation_StartArc:=GetProcAddress(MainInstance,'Navigation_StartArc');
  //��������� �����
  Navigation_EndArc:=GetProcAddress(MainInstance,'Navigation_EndArc');
  //������� � ������ �������
  Navigation_ArcPosition:=GetProcAddress(MainInstance,'Navigation_ArcPosition');
  //���������� ����� �������
  //� ������
  Navigation_NewPosition:=GetProcAddress(MainInstance,'Navigation_NewPosition');

{$ENDREGION}

{$REGION '������ �����������'}

  //���������� �����������
  ListImage_Count:=GetProcAddress(MainInstance,'ListImage_Count');
  //�������� �����������
  //�� ������
  ListImage_GetFileName:=GetProcAddress(MainInstance,'ListImage_GetFileName');
  //������������� �����������
  //��� ������
  ListImage_SetFileName:=GetProcAddress(MainInstance,'ListImage_SetFileName');
  ListImage_SaveGetToFile:=GetProcAddress(MainInstance,'ListImage_SaveGetToFile');
  ListImage_SaveGetToClipboard:=GetProcAddress(MainInstance,'ListImage_SaveGetToClipboard');
  ListImage_RotateGetTo80CW:=GetProcAddress(MainInstance,'ListImage_RotateGetTo80CW');
  ListImage_RotateGetTo80CWAll:=GetProcAddress(MainInstance,'ListImage_RotateGetTo80CWAll');
  ListImage_RotateGetTo80CCW:=GetProcAddress(MainInstance,'ListImage_RotateGetTo80CCW');
  ListImage_RotateGetTo80CCWAll:=GetProcAddress(MainInstance,'ListImage_RotateGetTo80CCWAll');
  //���������� ��������
  //�������� �����������
  ListImage_FlipImage:=GetProcAddress(MainInstance,'ListImage_FlipImage');
  //���������� ��������
  //���� �����������
  ListImage_FlipImageAll:=GetProcAddress(MainInstance,'ListImage_FlipImageAll');
  //�������� ������� ����
  //��� ����������� �������� �� ������
  ListImage_OpenArchive:=GetProcAddress(MainInstance,'ListImage_OpenArchive');

{$ENDREGION}

{$REGION '������ ��������� ������'}

  //���������� ������
  TxtFiles_Count:=GetProcAddress(MainInstance,'TxtFiles_Count');
  //�������� ��� �����
  TxtFiles_GetFileName:=GetProcAddress(MainInstance,'TxtFiles_GetFileName');
  //��������� ����
  //�� ��������� �����
  TxtFiles_ExtractByName:=GetProcAddress(MainInstance,'TxtFiles_ExtractByName');

{$ENDREGION}

{$REGION '����'}

  Paths_GetApplicationPath:=GetProcAddress(MainInstance,'Paths_GetApplicationPath');
  Paths_GetTempPath:=GetProcAddress(MainInstance,'Paths_GetTempPath');

{$ENDREGION}

{$REGION '���������'}

  //������ ���������
  Program_VersionProg:=GetProcAddress(MainInstance,'Program_VersionProg');
  //������ �����������
  Program_ImageFilter:=GetProcAddress(MainInstance,'Program_ImageFilter');
  //������ ��� �������
  Program_ArchiveFilter:=GetProcAddress(MainInstance,'Program_ArchiveFilter');
  //����� ���������������
  Program_ImageMode:=GetProcAddress(MainInstance,'Program_ImageMode');
  //��������� ������� ����
  Program_RunMenuCommand:=GetProcAddress(MainInstance,'Program_RunMenuCommand');
  //���������� ������
  Program_GetArrowCursor:=GetProcAddress(MainInstance,'Program_GetArrowCursor');
  //����������� ������
  Program_GetLoadCursor:=GetProcAddress(MainInstance,'Program_GetLoadCursor');

{$ENDREGION}

{$REGION '������ ���������'}

  //���������/����������
  //������ ���������
  Scrolling_SetActiveScroll:=GetProcAddress(MainInstance,'Scrolling_SetActiveScroll');
  //���������� ���������
  //�������� ���������
  Scrolling_GetActiveScroll:=GetProcAddress(MainInstance,'Scrolling_GetActiveScroll');

{$ENDREGION}

{$REGION '���� ���������'}

  //������������� �� �����
  //�����������
  Window_FullScreenMode:=GetProcAddress(MainInstance,'Window_FullScreenMode');
  //���������� �������
  //� ������ ����� ����
  Window_GetWindowPosition:=GetProcAddress(MainInstance,'Window_GetWindowPosition');
  //������� �� ����
  Window_ActivatedWindow:=GetProcAddress(MainInstance,'Window_ActivatedWindow');
  //���������� �������� �����
  Window_GetFormHandle:=GetProcAddress(MainInstance,'Window_GetFormHandle');

{$ENDREGION}

{$REGION '�������������� ��������� � ������������'}

  GetConfigHandle:=GetProcAddress(MainInstance,'GetConfigHandle');
  //�������� ������ ��������
  //� ������
  MultiLanguage_GetGroupValue:=GetProcAddress(MainInstance,'MultiLanguage_GetGroupValue');
  //�������� �������� �� ����������
  //������
  MultiLanguage_GetConfigValue:=GetProcAddress(MainInstance,'MultiLanguage_GetConfigValue');
  //���������� �������� � ��������� ������
  MultiLanguage_SetConfigValue:=GetProcAddress(MainInstance,'MultiLanguage_SetConfigValue');

{$ENDREGION}

{$REGION '�������� � ��������'}

  ExtractImageWithIndex:=GetProcAddress(MainInstance,'ExtractImageWithIndex');
  ExtractImageWithName:=GetProcAddress(MainInstance,'ExtractImageWithName');

{$ENDREGION}

{$REGION '������������'}

  //��������� ������������
  //�� ������������ ��������
  ShowDocumentation:=GetProcAddress(MainInstance,'ShowDocumentation');
  GetGifFileDocumentation:=GetProcAddress(MainInstance,'GetGifFileDocumentation');

{$ENDREGION}

{$REGION '�����������'}

  //��������� ������������
  //�� ������������ ��������
  PrintToProgramLog:=GetProcAddress(MainInstance,'PrintToProgramLog');
  PrintErrorToProgramLog:=GetProcAddress(MainInstance,'PrintErrorToProgramLog');

{$ENDREGION}


end;

//��������� �������
procedure CursorsLoading;
begin
  if not CursorsIsLoading then
  begin
    Screen.Cursors[crArrow]:=Program_GetArrowCursor;
    Screen.Cursors[crHourGlass]:=Program_GetLoadCursor;
    CursorsIsLoading:=true;
  end;
end;

end.
