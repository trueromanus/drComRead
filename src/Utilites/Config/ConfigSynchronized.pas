{
  drComRead

  ������ ��� �������������
  ���� ������ ����������

  Copyright (c) 2009-2011 Romanus
}
unit ConfigSynchronized;

interface

uses
  Controls, Generics.Collections, Forms;

type
  //���������� �������
  //������������
  TConfigList = class
  private
    //�������� ����� ��� ���������������
    //�������� ��������
    FList:TDictionary<Integer,String>;
    //��������� ��� ������
    procedure LoadFrame;
  public
    //�����������
    constructor Create;
    //����������
    destructor Destroy;override;
    //��������� �����
    procedure Add(Tag:Integer;Frame:String);
    //�������� �����
    function GetFrame(Tag:Integer):TFrame;overload;
    //�������� �����
    function GetFrame(Tag:String):TFrame;overload;
    //�������� ������ ������
    function GetFrameIndex(Tag:String):Integer;
  end;

var
  ConfigList:TConfigList;

//������������� ������ �������
procedure InitConfigList;
//��������������� ������ �������
procedure DeInitConfigList;

implementation

uses
  ConfigNextGen;

//�����������
constructor TConfigList.Create;
begin
  FList:=TDictionary<Integer,String>.Create;
  LoadFrame;
end;

//����������
destructor TConfigList.Destroy;
var
  Pair:TPair<Integer,TFrame>;
begin
  FList.Free;
end;

procedure TConfigList.Add(Tag:Integer;Frame:String);
begin
  //Frame.LoadLanguage;
  FList.Add(Tag,Frame);
end;

//��������� ��� ������
procedure TConfigList.LoadFrame;
begin
  Add(1,'MainScaleMode');
  Add(2,'MainBackground');
  Add(3,'MainActiveScroll');
  Add(4,'WindowAndLanguage');
  Add(5,'MainTwoPage');
  Add(6,'MainNavigate');
  Add(7,'HistoryBookmark');
  Add(10,'ArchiveMain');
  Add(11,'ArchiveSort');
  Add(12,'ColorCorrectMain');
  Add(13,'FrameHistory');
end;

//�������� �����
function TConfigList.GetFrame(Tag:Integer):TFrame;
begin
  Result:=TFrame(FormConfig.FindComponent(FList[Tag]));
end;

//�������� �����
function TConfigList.GetFrame(Tag:String):TFrame;
var
  Pair:TPair<Integer,String>;
  Index:Integer;
begin
  Index:=-1;
  for Pair in FList do
    if Pair.Value = Tag then
      Index:=Pair.Key;
  if Index <> -1 then
    Result:=TFrame(FormConfig.FindComponent(FList[Index]));
  Result:=nil;
end;

//�������� ������ ������
function TConfigList.GetFrameIndex(Tag:String):Integer;
var
  Pair:TPair<Integer,String>;
  Index:Integer;
begin
  Index:=-1;
  for Pair in FList do
    if Pair.Value = Tag then
      Index:=Pair.Key;
  Result:=Index;
end;

//������������� ������ �������
procedure InitConfigList;
begin
  ConfigList:=TConfigList.Create;
end;

//��������������� ������ �������
procedure DeInitConfigList;
begin
  ConfigList.Free;
end;

end.
