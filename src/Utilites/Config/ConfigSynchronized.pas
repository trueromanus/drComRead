{
  drComRead

  Модуль для синхронизации
  всех данных библиотеки

  Copyright (c) 2009-2011 Romanus
}
unit ConfigSynchronized;

interface

uses
  Controls, Generics.Collections, Forms;

type
  //визуальный элемент
  //конфигурации
  TConfigList = class
  private
    //название ключа для мультиязыкового
    //перевода элемента
    FList:TDictionary<Integer,String>;
    //загружаем все фреймы
    procedure LoadFrame;
  public
    //конструктор
    constructor Create;
    //деструктор
    destructor Destroy;override;
    //добавляем фрейм
    procedure Add(Tag:Integer;Frame:String);
    //получить фрейм
    function GetFrame(Tag:Integer):TFrame;overload;
    //получить фрейм
    function GetFrame(Tag:String):TFrame;overload;
    //получить индекс фрейма
    function GetFrameIndex(Tag:String):Integer;
  end;

var
  ConfigList:TConfigList;

//инициализация списка фреймов
procedure InitConfigList;
//деинициализация списка фреймов
procedure DeInitConfigList;

implementation

uses
  ConfigNextGen;

//конструктор
constructor TConfigList.Create;
begin
  FList:=TDictionary<Integer,String>.Create;
  LoadFrame;
end;

//деструктор
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

//загружаем все фреймы
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

//получить фрейм
function TConfigList.GetFrame(Tag:Integer):TFrame;
begin
  Result:=TFrame(FormConfig.FindComponent(FList[Tag]));
end;

//получить фрейм
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

//получить индекс фрейма
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

//инициализация списка фреймов
procedure InitConfigList;
begin
  ConfigList:=TConfigList.Create;
end;

//деинициализация списка фреймов
procedure DeInitConfigList;
begin
  ConfigList.Free;
end;

end.
