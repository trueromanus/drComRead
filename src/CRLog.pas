{
  drComRead

  ������ ������
  ����������� ����� ����������

  Copyright (c) 2012 Romanus
}
unit CRLog;

interface

uses
  Classes, CRDataBase;

type

  //����� ��������������
  TCRLogModePost = (lmNone,lmEmail,lmHttp);

  //����� ����
  TCRLog = class
  private
    //��������������
    FPost:TCRLogModePost;
    //������ � ���� ������
    FDataBase:TCRLogDataBase;
  protected
    //��������������
    //���������
    procedure PostEvent;
  public
    //�����������
    constructor Create(Post:TCRLogModePost);
    //�����������
    destructor Destroy;override;
    //������ � ��� ���������
    procedure Print(Msg:String;Group:String);
    //������ � ��� ��������� �� ������
    procedure PrintError(Msg:String;Group:String);
    //������ � ��� ���������� ���������
    procedure PrintSystem(Msg:String);
    //������ � ��� ����������� ������
    procedure PrintCritical(Msg:String;Group:String);
  end;

implementation

uses
  SysUtils, CRGlobal;

//��������������
//���������
procedure TCRLog.PostEvent;
begin
  case FPost of
    //������ � ����
    lmNone:;
    //�����
    lmEmail:;
    //�������� �� ����
    lmHttp:;
  end;

end;

//�����������
constructor TCRLog.Create(Post:TCRLogModePost);
begin
  FPost:=Post;
  FDataBase:=TCRLogDataBase.Create(PathToProgramDir);
end;

//�����������
destructor TCRLog.Destroy;
begin
  FDataBase.Free;
  inherited Destroy;
end;

//������ � ��� ���������
procedure TCRLog.Print(Msg:String;Group:String);
begin
  if Group <> '' then
    FDataBase.CreateRoutineMessage(Msg,Group)
  else
    FDataBase.CreateRoutineMessage(Msg);
end;

//������ � ��� ��������� �� ������
procedure TCRLog.PrintError(Msg:String;Group:String);
begin
  if Group <> '' then
    FDataBase.CreateErrorMessage(Msg,Group)
  else
    FDataBase.CreateErrorMessage(Msg);
end;

//������ � ��� ���������� ���������
procedure TCRLog.PrintSystem(Msg:String);
begin
  FDataBase.CreateSystemMessage(Msg);
end;

//������ � ��� ����������� ������
procedure TCRLog.PrintCritical(Msg:String;Group:String);
begin
  if Group <> '' then
    FDataBase.CreateCriticalMessage(Msg,Group)
  else
    FDataBase.CreateCriticalMessage(Msg);
end;

end.
