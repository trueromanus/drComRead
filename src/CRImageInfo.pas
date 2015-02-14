{
  drComicsReader

  Модуль объявления
  структур информации
  об изображениях

  Ревизия - $Revision: 1.4 $

  Copyright (c) 2008 Romanus
}
unit CRImageInfo;

interface

uses
  Graphics;

const
{
   'Blending' - медленно (около секунды) отображается по альфе
   'Kick' - потресение области (т.е. удар etc)
   'RedChannel' - из красного канала изображение
   'GreenChannel' - из зеленого канала изображение
   'BlueChannel' - из голубого канала изображение
   'Normal' - без эффектов (просто быстрый показ)
   'Emission' - зеркалирование
   'Merginged' - подергивание (страх или глубокие эмоции etc)
}
  //определение эффектов
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
              
  //указатель на тип
  PCRImageArea = ^TCRImageArea;
  //активная область
  //изображения
  TCRImageArea = class
  private
    //координаты
    //участка экрана
    FX1,FY1,
    FX2,FY2:integer;
    //порядок сортировки
    FOrder:byte;
    //проигрывание звука
    //FSound:string[80];
    //сколько времени
    //будет отображатся
    //изображение (если 0 то
    //берется по времени звука)
    FTimeShow:integer;
    //фоновый цвет
    FBColor:TColor;
    //эффект для отображения
    FEffect:TCREffect;
    //парсим в номер
    function ToInt(Str:String;Range:integer):integer;
  public
    //цвет
    property Color:TColor read FBColor;
    //эффект
    property Effect:TCREffect read FEffect;
    //конструктор
    constructor Create(Order:byte;TimeShow:integer);
    //деструктор
    destructor Destroy;override;
    //установить цвет
    procedure SetColor(Value:string);
    //установить эффект
    procedure SetEffect(Value:string);
    //установить координаты
    procedure SetCoord(X1,X2,Y1,Y2:integer);
  end;

  //список областей
  //изображения (максимум 11)
  //TCRImageAreaList = array[0..10] of TCRImageArea;

  //полное изображение
  {TCRImage = class
  private
    //имя файла
    FName:string[100];
    //фоновая музыка
    //для изображения
    //FMusic:TCRSound;
    //области
    FAreas:TCRImageAreaList;

  public
  end;}

implementation

uses
  SysUtils;

//парсим в номер
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

//конструктор
constructor TCRImageArea.Create(Order:byte;TimeShow:integer);
begin
  //ордер
  FOrder:=Order;
  //время отображения
  FTimeShow:=TimeShow;
end;

//деструктор
destructor TCRImageArea.Destroy;
begin
  inherited Destroy;
end;

//установить цвет
procedure TCRImageArea.SetColor(Value:string);
begin
  //FBColor:=TColor(toInt(FBColor));
end;

//установить эффект
procedure TCRImageArea.SetEffect(Value:string);
var
  Int:integer;
begin
  Int:=ToInt(Value,8);
  if Int > -1 then
    FEffect:=TCREffect(Int);
end;

//установить координаты
procedure TCRImageArea.SetCoord(X1,X2,Y1,Y2:integer);
begin
  FX1:=X1;
  FX2:=X2;
  FY1:=Y1;
  FY2:=Y2;
end;

end.
