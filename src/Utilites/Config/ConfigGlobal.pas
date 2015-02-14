{
  drComRead
  Config Library

  ������ ����������
  ����������

  Copyright (c) 2008-2009 Romanus
}

unit ConfigGlobal;

interface

var
  //������ �� �������� ����
  LangHandle:Integer;
  //������ �� ���������������� ����
  ConfHandle:Integer;
  //����� �����������
  //�������� ����������
  ModeMainBox:Byte = 0;

//�������� �������� �� �����������������
//�����
function LangArrayValue(Key:String):String;
//�������� �������� �� �����������������
//�����
function ConfArrayValue(Key:String):String;
//����� �������� � ��������������� ����
procedure SetConfArrayValue(Key,Value:String);
//����� � ���������� ���������
function SetArrayValue(Key,Value:String):Boolean;

implementation

uses
  ConfigDialog, MainProgramHeader;

//�������� �������� �� �����������������
//�����
function LangArrayValue(Key:String):String;
begin
  Result:=MultiLanguage_GetGroupValue('configdialog',PWideChar(Key));
end;

//�������� ��������
//�� �����������������
//�����
function ConfArrayValue(Key:String):String;
begin
  Result:=MultiLanguage_GetConfigValue(PWideChar(Key));
end;

//����� � ���������� ���������
procedure SetConfArrayValue(Key,Value:String);
begin
  MultiLanguage_SetConfigValue(PWideChar(Key),PWideChar(Value));
end;

function SetArrayValue(Key,Value:String):Boolean;
begin
  Result:=MultiLanguage_SetConfigValue(PWideChar(Key),PWideChar(Value));
end;

end.
