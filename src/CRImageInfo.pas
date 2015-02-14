{
  drComicsReader

  ������ ����������
  �������� ����������
  �� ������������

  ������� - $Revision: 1.4 $

  Copyright (c) 2008 Romanus
}
unit CRImageInfo;

interface

uses
  Graphics;

const
{
   'Blending' - �������� (����� �������) ������������ �� �����
   'Kick' - ���������� ������� (�.�. ���� etc)
   'RedChannel' - �� �������� ������ �����������
   'GreenChannel' - �� �������� ������ �����������
   'BlueChannel' - �� �������� ������ �����������
   'Normal' - ��� �������� (������ ������� �����)
   'Emission' - ��������������
   'Merginged' - ������������ (����� ��� �������� ������ etc)
}
  //����������� ��������
  CR_EFFECTS_ARRAY  : array[0..7] of string =
                                          (
                              'Blending',
                              'Kick',
                              'RedChannel',
                              'GreenChannel',
                              'BlueChannel',
                              'Normal',
                              'Emission',
                              'Merginged'
                                          );

type
  TCREffect = (
                creNone,
                creBlending,
                creKick,
                creRedChannel,
                creGreenChannel,
                creBlueChannel,
                creNormal,
                creEmission,
                creMerginged
              );
              
  //��������� �� ���
  PCRImageArea = ^TCRImageArea;
  //�������� �������
  //�����������
  TCRImageArea = class
  private
    //����������
    //������� ������
    FX1,FY1,
    FX2,FY2:integer;
    //������� ����������
    FOrder:byte;
    //������������ �����
    //FSound:string[80];
    //������� �������
    //����� �����������
    //����������� (���� 0 ��
    //������� �� ������� �����)
    FTimeShow:integer;
    //������� ����
    FBColor:TColor;
    //������ ��� �����������
    FEffect:TCREffect;
    //������ � �����
    function ToInt(Str:String;Range:integer):integer;
  public
    //����
    property Color:TColor read FBColor;
    //������
    property Effect:TCREffect read FEffect;
    //�����������
    constructor Create(Order:byte;TimeShow:integer);
    //����������
    destructor Destroy;override;
    //���������� ����
    procedure SetColor(Value:string);
    //���������� ������
    procedure SetEffect(Value:string);
    //���������� ����������
    procedure SetCoord(X1,X2,Y1,Y2:integer);
  end;

  //������ ��������
  //����������� (�������� 11)
  //TCRImageAreaList = array[0..10] of TCRImageArea;

  //������ �����������
  {TCRImage = class
  private
    //��� �����
    FName:string[100];
    //������� ������
    //��� �����������
    //FMusic:TCRSound;
    //�������
    FAreas:TCRImageAreaList;

  public
  end;}

implementation

uses
  SysUtils;

//������ � �����
function TCRImageArea.ToInt(Str:String;Range:integer):integer;
var
  Int:integer;
begin
  try
    Int:=StrToInt(Str);
    if Int > Range then
      Int:=Range;
  except
    Result:=-1;
    Exit;
  end;
  Result:=Int;
end;

//�����������
constructor TCRImageArea.Create(Order:byte;TimeShow:integer);
begin
  //�����
  FOrder:=Order;
  //����� �����������
  FTimeShow:=TimeShow;
end;

//����������
destructor TCRImageArea.Destroy;
begin
  inherited Destroy;
end;

//���������� ����
procedure TCRImageArea.SetColor(Value:string);
begin
  //FBColor:=TColor(toInt(FBColor));
end;

//���������� ������
procedure TCRImageArea.SetEffect(Value:string);
var
  Int:integer;
begin
  Int:=ToInt(Value,8);
  if Int > -1 then
    FEffect:=TCREffect(Int);
end;

//���������� ����������
procedure TCRImageArea.SetCoord(X1,X2,Y1,Y2:integer);
begin
  FX1:=X1;
  FX2:=X2;
  FY1:=Y1;
  FY2:=Y2;
end;

end.
