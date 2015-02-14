{
  drComRead

  Navigator Window

  ������ ��� �������
  �������

  Copyright (c) 2009-2010 Romanus
}
unit NRImports;

interface

var
  //���������/����������
  //������ ���������
  Scrolling_SetActiveScroll:function(Mode:Boolean):Boolean;stdcall;
  //��������� �������� ���������
  //������ ��������
  //���������
  Scrolling_GetActiveScroll:function():Boolean;stdcall;
  //��������� �����������
  Navigation_NextImage:function():Boolean;stdcall;
  //���������� �����������
  Navigation_PrevImage:function():Boolean;stdcall;
  //��������� �����������
  Navigation_StartImage:function():Boolean;stdcall;
  //�������� �����������
  Navigation_EndImage:function():Boolean;stdcall;
  //�������� ������� �������
  Navigation_Position:function():Integer;stdcall;
  //��������� ��������
  //� �������� Index
  Navigation_NewPosition:function(Index:Integer):Boolean;stdcall;
  //�������� ���������� �����������
  ListImage_Count:function():Integer;stdcall;
  //�������� ��� ����� �����������
  ListImage_GetFileName:function(Index:Integer):PWideChar;stdcall;
  //��������� ������� �������� ����
  ListImage_SaveGetToFile:function(FileName:PWideChar):Boolean;stdcall;
  //��������� � ����� ������
  ListImage_SaveGetToClipboard:function():Boolean;stdcall;
  //������ ���������� �� 90 ��������
  ListImage_RotateGetTo80CW:function():Boolean;stdcall;
  //������� ����������� �� 90 ��������
  //�����
  ListImage_RotateGetTo80CCW:function():Boolean;stdcall;
  //���������� ��������
  //�������� �����������
  ListImage_FlipImage:function(Vert:Boolean):Boolean;stdcall;
  //�������� ���� � ���������
  Paths_GetApplicationPath:function():PWideChar;stdcall;
  //������������� �� �����
  //�����������
  Window_FullScreenMode:function():Boolean;stdcall;
  //��������� �����
  Navigation_NextArc:function:Boolean;stdcall;
  //���������� �����
  Navigation_PrevArc:function:Boolean;stdcall;
  //������ �����
  Navigation_StartArc:function:Boolean;stdcall;
  //��������� �����
  Navigation_EndArc:function:Boolean;stdcall;
  //�������� � ��������
  //���������� �������
  GetArchivesCount:function:Integer;stdcall;
  //���������� ��� ������
  GetArchiv:function(Index:Integer):PWideChar;stdcall;
  //���������� �������
  //� ������ �������
  GetArchivPosition:function:Integer;stdcall;
  //��������� ����� � ��������� ��������
  GetArchivOpenIndex:function(Index:Integer):Boolean;stdcall;
  //�������� � ��������������
  //�����������
  MultiLanguage_GetGroupValue:function(Group,Key:PWideChar):PWideChar;stdcall;
  //�������� �������� �� ����������
  //������
  MultiLanguage_GetConfigValue:function(Key:PWideChar):PWideChar;stdcall;
  //���������� �������� � ��������� ������
  MultiLanguage_SetConfigValue:function(Key,NewValue:PWideChar):Boolean;stdcall;


//������ ������
function LoadLinks:Boolean;

implementation

uses
  Windows;

//������ ������
function LoadLinks:Boolean;
begin
  try
    @Scrolling_SetActiveScroll:=GetProcAddress(MainInstance,'Scrolling_SetActiveScroll');
    @Scrolling_GetActiveScroll:=GetProcAddress(MainInstance,'Scrolling_GetActiveScroll');
    @Navigation_NextImage:=GetProcAddress(MainInstance,'Navigation_NextImage');
    @Navigation_PrevImage:=GetProcAddress(MainInstance,'Navigation_PrevImage');
    @Navigation_StartImage:=GetProcAddress(MainInstance,'Navigation_StartImage');
    @Navigation_EndImage:=GetProcAddress(MainInstance,'Navigation_EndImage');
    @Navigation_Position:=GetProcAddress(MainInstance,'Navigation_Position');
    @ListImage_Count:=GetProcAddress(MainInstance,'ListImage_Count');
    @ListImage_GetFileName:=GetProcAddress(MainInstance,'ListImage_GetFileName');
    @ListImage_SaveGetToFile:=GetProcAddress(MainInstance,'ListImage_SaveGetToFile');
    @ListImage_SaveGetToClipboard:=GetProcAddress(MainInstance,'ListImage_SaveGetToClipboard');
    @ListImage_RotateGetTo80CW:=GetProcAddress(MainInstance,'ListImage_RotateGetTo80CW');
    @ListImage_RotateGetTo80CCW:=GetProcAddress(MainInstance,'ListImage_RotateGetTo80CCW');
    @ListImage_FlipImage:=GetProcAddress(MainInstance,'ListImage_FlipImage');
    @Paths_GetApplicationPath:=GetProcAddress(MainInstance,'Paths_GetApplicationPath');
    @Window_FullScreenMode:=GetProcAddress(MainInstance,'Window_FullScreenMode');
    @Navigation_NextArc:=GetProcAddress(MainInstance,'Navigation_NextArc');
    @Navigation_PrevArc:=GetProcAddress(MainInstance,'Navigation_PrevArc');
    @Navigation_StartArc:=GetProcAddress(MainInstance,'Navigation_StartArc');
    @Navigation_EndArc:=GetProcAddress(MainInstance,'Navigation_EndArc');
    @GetArchivesCount:=GetProcAddress(MainInstance,'GetArchivesCount');
    @GetArchiv:=GetProcAddress(MainInstance,'GetArchiv');
    @GetArchivPosition:=GetProcAddress(MainInstance,'GetArchivPosition');
    @GetArchivOpenIndex:=GetProcAddress(MainInstance,'GetArchivOpenIndex');
    @Navigation_NewPosition:=GetProcAddress(MainInstance,'Navigation_NewPosition');
    @MultiLanguage_GetGroupValue:=GetProcAddress(MainInstance,'MultiLanguage_GetGroupValue');
    @MultiLanguage_GetConfigValue:=GetProcAddress(MainInstance,'MultiLanguage_GetConfigValue');
    @MultiLanguage_SetConfigValue:=GetProcAddress(MainInstance,'MultiLanguage_SetConfigValue');
    Result:=true;
  except
    Result:=false;
  end;
end;

end.
