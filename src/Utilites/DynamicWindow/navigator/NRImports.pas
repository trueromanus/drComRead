{
  drComRead

  Navigator Window

  Модуль для функций
  импорта

  Copyright (c) 2009-2010 Romanus
}
unit NRImports;

interface

var
  //включение/выключение
  //режима прокрутки
  Scrolling_SetActiveScroll:function(Mode:Boolean):Boolean;stdcall;
  //получения текущего состояния
  //режима активной
  //прокрутки
  Scrolling_GetActiveScroll:function():Boolean;stdcall;
  //следующее изображение
  Navigation_NextImage:function():Boolean;stdcall;
  //предыдущее изображение
  Navigation_PrevImage:function():Boolean;stdcall;
  //начальное изображение
  Navigation_StartImage:function():Boolean;stdcall;
  //конечное изображение
  Navigation_EndImage:function():Boolean;stdcall;
  //получить текущую позицию
  Navigation_Position:function():Integer;stdcall;
  //загрузить картинку
  //с индексом Index
  Navigation_NewPosition:function(Index:Integer):Boolean;stdcall;
  //получить количество изображений
  ListImage_Count:function():Integer;stdcall;
  //получаем имя файла изображения
  ListImage_GetFileName:function(Index:Integer):PWideChar;stdcall;
  //сохраняем текущий открытый файл
  ListImage_SaveGetToFile:function(FileName:PWideChar):Boolean;stdcall;
  //сохраняем в буфер обмена
  ListImage_SaveGetToClipboard:function():Boolean;stdcall;
  //поворт избражения на 90 градусов
  ListImage_RotateGetTo80CW:function():Boolean;stdcall;
  //поворот изображения на 90 градусов
  //назад
  ListImage_RotateGetTo80CCW:function():Boolean;stdcall;
  //зеркальные повороты
  //текущего изображения
  ListImage_FlipImage:function(Vert:Boolean):Boolean;stdcall;
  //получаем путь к программе
  Paths_GetApplicationPath:function():PWideChar;stdcall;
  //полноэкранный ли режим
  //изображения
  Window_FullScreenMode:function():Boolean;stdcall;
  //следующий архив
  Navigation_NextArc:function:Boolean;stdcall;
  //предыдущий архив
  Navigation_PrevArc:function:Boolean;stdcall;
  //первый архив
  Navigation_StartArc:function:Boolean;stdcall;
  //последний архив
  Navigation_EndArc:function:Boolean;stdcall;
  //Работаем с архивами
  //количество архивов
  GetArchivesCount:function:Integer;stdcall;
  //возвращаем имя архива
  GetArchiv:function(Index:Integer):PWideChar;stdcall;
  //возвращаем позицию
  //в списке архивов
  GetArchivPosition:function:Integer;stdcall;
  //открываем архив с указанным индексом
  GetArchivOpenIndex:function(Index:Integer):Boolean;stdcall;
  //работаем с мультиязыковым
  //интерфейсом
  MultiLanguage_GetGroupValue:function(Group,Key:PWideChar):PWideChar;stdcall;
  //получить значение из одиночного
  //списка
  MultiLanguage_GetConfigValue:function(Key:PWideChar):PWideChar;stdcall;
  //установить значение в одиночном списке
  MultiLanguage_SetConfigValue:function(Key,NewValue:PWideChar):Boolean;stdcall;


//грузим ссылки
function LoadLinks:Boolean;

implementation

uses
  Windows;

//грузим ссылки
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
