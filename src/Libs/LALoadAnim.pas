{
  drComRead

  LoadAnim Library

  ������ ������ �
  ��������� �������������
  �����������

  Copyright (c) 2008 Romanus
}
unit LALoadAnim;

interface

uses
  GiFImage, Graphics, Classes;

type
  //����� ��� ���������
  //�������� ��������
  TLoadAnim = class
  private
    //�����������
    FImage:TGiFImage;
    //�������
    FPosition:integer;
  public
    property Position:integer read FPosition;
    //�����������
    constructor Create;
    //����������
    destructor Destroy;override;
    //��������� �������
    function Next:boolean;
    //����������� �������
    function Prev:boolean;
    //�������� �����������
    function GetImage:TGraphic;
    //�������� �����������
    function GetBitmap:TBitmap;
    //�������� �����
    function GetStreamImage:TStream;
    //������� ��������
    procedure CiclingNext;
    //��������� ����
    function LoadFromFile(fname:PChar):boolean;
  end;

//��������� ������������� gif
function LoadAnimGif(fname:PChar):boolean;
//�������� ��������� ����
function GetNextFrameGif:TGraphic;

var
  MainObj:TLoadAnim;

implementation

//�����������
constructor TLoadAnim.Create;
begin
  FImage:=TGiFImage.Create;
  FPosition:=-1;
end;

//����������
destructor TLoadAnim.Destroy;
begin
  FImage.Free;
end;

//��������� �������
function TLoadAnim.Next:boolean;
begin
  Result:=false;
  if FPosition < FImage.Images.Count-1 then
  begin
    FPosition:=FPosition+1;
    Result:=true;
  end;
end;

//����������� �������
function TLoadAnim.Prev:boolean;
begin
  Result:=false;
  if FPosition > 0 then
  begin
    FPosition:=FPosition-1;
    Result:=true;
  end;
end;

//�������� �����������
function TLoadAnim.GetImage:TGraphic;
begin
  Result:=FImage.Images[FPosition].Image;
end;

//�������� �����������
function TLoadAnim.GetBitmap:TBitmap;
begin
  Result:=FImage.Images[FPosition].Bitmap;
end;

//�������� �����
function TLoadAnim.GetStreamImage:TStream;
var
  Stream:TStream;
begin
  Stream:=TMemoryStream.Create;
  FImage.Images[FPosition].SaveToStream(Stream);
  Result:=Stream;
end;

//������� ��������
procedure TLoadAnim.CiclingNext;
begin
  if not Self.Next then
    FPosition:=0;
end;

//��������� ����
function TLoadAnim.LoadFromFile(fname:PChar):boolean;
begin
  try
    FImage.LoadFromFile(fname);
    Result:=true;
  except
    Result:=false;
  end;
end;

//��������� ������������� gif
function LoadAnimGif(fname:PChar):boolean;
begin
  Result:=false;
  MainObj:=TLoadAnim.Create;
  if (MainObj.LoadFromFile(fname)) and
     (MainObj.FImage.Images.Count > 1) then
    Result:=true;
end;

//�������� ��������� ����
function GetNextFrameGif:TGraphic;
begin
  MainObj.CiclingNext;
  Result:=MainObj.GetImage;
end;

end.
