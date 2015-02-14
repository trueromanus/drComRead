{
  drComRead

  LoadAnim Library

  Модуль работы с
  загрузкой анимированных
  изображений

  Copyright (c) 2008 Romanus
}
unit LALoadAnim;

interface

uses
  GiFImage, Graphics, Classes;

type
  //класс для обработки
  //загрузки анимации
  TLoadAnim = class
  private
    //изображение
    FImage:TGiFImage;
    //позиция
    FPosition:integer;
  public
    property Position:integer read FPosition;
    //конструктор
    constructor Create;
    //деструктор
    destructor Destroy;override;
    //следующая позиция
    function Next:boolean;
    //предыдующая позиция
    function Prev:boolean;
    //получаем изображение
    function GetImage:TGraphic;
    //получаем изображение
    function GetBitmap:TBitmap;
    //получаем стрим
    function GetStreamImage:TStream;
    //циклуем анимацию
    procedure CiclingNext;
    //загружаем файл
    function LoadFromFile(fname:PChar):boolean;
  end;

//загружаем анимированный gif
function LoadAnimGif(fname:PChar):boolean;
//получить следующий кадр
function GetNextFrameGif:TGraphic;

var
  MainObj:TLoadAnim;

implementation

//конструктор
constructor TLoadAnim.Create;
begin
  FImage:=TGiFImage.Create;
  FPosition:=-1;
end;

//деструктор
destructor TLoadAnim.Destroy;
begin
  FImage.Free;
end;

//следующая позиция
function TLoadAnim.Next:boolean;
begin
  Result:=false;
  if FPosition < FImage.Images.Count-1 then
  begin
    FPosition:=FPosition+1;
    Result:=true;
  end;
end;

//предыдующая позиция
function TLoadAnim.Prev:boolean;
begin
  Result:=false;
  if FPosition > 0 then
  begin
    FPosition:=FPosition-1;
    Result:=true;
  end;
end;

//получаем изображение
function TLoadAnim.GetImage:TGraphic;
begin
  Result:=FImage.Images[FPosition].Image;
end;

//получаем изображение
function TLoadAnim.GetBitmap:TBitmap;
begin
  Result:=FImage.Images[FPosition].Bitmap;
end;

//получаем стрим
function TLoadAnim.GetStreamImage:TStream;
var
  Stream:TStream;
begin
  Stream:=TMemoryStream.Create;
  FImage.Images[FPosition].SaveToStream(Stream);
  Result:=Stream;
end;

//циклуем анимацию
procedure TLoadAnim.CiclingNext;
begin
  if not Self.Next then
    FPosition:=0;
end;

//загружаем файл
function TLoadAnim.LoadFromFile(fname:PChar):boolean;
begin
  try
    FImage.LoadFromFile(fname);
    Result:=true;
  except
    Result:=false;
  end;
end;

//загружаем анимированный gif
function LoadAnimGif(fname:PChar):boolean;
begin
  Result:=false;
  MainObj:=TLoadAnim.Create;
  if (MainObj.LoadFromFile(fname)) and
     (MainObj.FImage.Images.Count > 1) then
    Result:=true;
end;

//получить следующий кадр
function GetNextFrameGif:TGraphic;
begin
  MainObj.CiclingNext;
  Result:=MainObj.GetImage;
end;

end.
