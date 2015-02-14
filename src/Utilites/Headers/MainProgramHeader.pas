{
  drComRead

  Основной заголовочный файл
  для адаптации dll библиотеки
  к api основной программы

  Copyright (c) 2010-2011 Romanus
}
unit MainProgramHeader;

interface

uses
  Windows;

type
  //позиция окна
  TFEWindowPosition = record
    //позиция
    X,Y:Integer;
    //ширина
    Width:Integer;
    //длина
    Height:Integer;
  end;

var

{$REGION 'Спиcок архивов'}

  //количество архивов
  GetArchivesCount:function:Integer;stdcall;
  //возвращаем имя архива
  GetArchiv:function(Index:Integer):PWideChar;stdcall;
  //установить новое имя для архива
  SetNameArchiv:function(Index:Integer;NewName:PWideChar):Boolean;stdcall;
  //возвращаем позицию
  //в списке архивов
  GetArchivPosition:function:Integer;stdcall;
  //открываем архив
  //с указанной позицией индекса
  GetArchivOpenIndex:function(Index:Integer):Boolean;stdcall;

{$ENDREGION}

{$REGION 'Навигация'}

  //следующее изображение
  Navigation_NextImage:function:Boolean;stdcall;
  //предыдущее изображение
  Navigation_PrevImage:function:Boolean;stdcall;
  //начальное изображение
  Navigation_StartImage:function:Boolean;stdcall;
  //конечное изображение
  Navigation_EndImage:function:Boolean;stdcall;
  //получить текущую позицию
  Navigation_Position:function:Integer;stdcall;
  //следующий архив
  Navigation_NextArc:function:Boolean;stdcall;
  //предыдущий архив
  Navigation_PrevArc:function:Boolean;stdcall;
  //первый архив
  Navigation_StartArc:function:Boolean;stdcall;
  //последний архив
  Navigation_EndArc:function:Boolean;stdcall;
  //позиция в списке архивов
  Navigation_ArcPosition:function:Boolean;stdcall;
  //установить новую позицию
  //в списке
  Navigation_NewPosition:function(Index:Integer):Boolean;stdcall;

{$ENDREGION}

{$REGION 'Список изображений'}

  //количество изображений
  ListImage_Count:function:Integer;stdcall;
  //получить изображение
  //из списка
  ListImage_GetFileName:function(Index:Integer):PWideChar;stdcall;
  //устанавливаем изображение
  //для списка
  ListImage_SetFileName:function(Index:Integer;FileName:PWideChar):Boolean;stdcall;
  ListImage_SaveGetToFile:function(FileName:PWideChar):Boolean;stdcall;
  ListImage_SaveGetToClipboard:function:Boolean;stdcall;
  ListImage_RotateGetTo80CW:function:Boolean;stdcall;
  ListImage_RotateGetTo80CWAll:function:Boolean;stdcall;
  ListImage_RotateGetTo80CCW:function:Boolean;stdcall;
  ListImage_RotateGetTo80CCWAll:function:Boolean;stdcall;
  //зеркальные повороты
  //текущего изображения
  ListImage_FlipImage:function(Vert:Boolean):Boolean;stdcall;
  //зеркальные повороты
  //всех изображений
  ListImage_FlipImageAll:function(Vert:Boolean):Boolean;stdcall;
  //получаем признак того
  //что изображения зачитаны из архива
  ListImage_OpenArchive:function:Boolean;stdcall;

{$ENDREGION}

{$REGION 'Список текстовых файлов'}

  //количество файлов
  TxtFiles_Count:function:Integer;stdcall;
  //получаем имя файла
  TxtFiles_GetFileName:function(Index:Integer):PWideChar;stdcall;
  //извлекаем файл
  //во временную папку
  TxtFiles_ExtractByName:function(Name:PWideChar):Boolean;stdcall;

{$ENDREGION}

{$REGION 'Пути'}

  Paths_GetApplicationPath:function():PWideChar;stdcall;
  Paths_GetTempPath:function:PWideChar;stdcall;

{$ENDREGION}

{$REGION 'Программа'}

  //версия программы
  Program_VersionProg:function:PWideChar;stdcall;
  //фильтр изображений
  Program_ImageFilter:function:PWideChar;stdcall;
  //фильтр для архивов
  Program_ArchiveFilter:function:PWideChar;stdcall;
  //режим масштабирования
  Program_ImageMode:function:Byte;stdcall;
  //запускаем команду меню
  Program_RunMenuCommand:function(Index:Integer):Boolean;stdcall;
  //стрелочный курсор
  Program_GetArrowCursor:function:HCURSOR;stdcall;
  //загрузочный курсор
  Program_GetLoadCursor:function:HCURSOR;stdcall;

{$ENDREGION}

{$REGION 'Режимы программы'}

  //включение/выключение
  //режима прокрутки
  Scrolling_SetActiveScroll:function(Mode:Boolean):Boolean;stdcall;
  //отображаем состояние
  //активной прокрутки
  Scrolling_GetActiveScroll:function:Boolean;stdcall;

{$ENDREGION}

{$REGION 'Окно программы'}

  //полноэкранный ли режим
  //изображения
  Window_FullScreenMode:function:Boolean;stdcall;
  //возвращаем позицию
  //и ширину длину окна
  Window_GetWindowPosition:function:TFEWindowPosition;stdcall;
  //активно ли окно
  Window_ActivatedWindow:function:Boolean;stdcall;
  //возвращаем основную форму
  Window_GetFormHandle:function:Pointer;stdcall;


{$ENDREGION}

{$REGION 'Мультиязыковой интерфейс и конфигурация'}

  GetConfigHandle:function:Integer;stdcall;
  //получить первое значение
  //в группе
  MultiLanguage_GetGroupValue:function(Group,Key:PWideChar):PWideChar;stdcall;
  //получить значение из одиночного
  //списка
  MultiLanguage_GetConfigValue:function(Key:PWideChar):PWideChar;stdcall;
  //установить значение в одиночном списке
  MultiLanguage_SetConfigValue:function(Key,NewValue:PWideChar):Boolean;stdcall;

{$ENDREGION}

{$REGION 'Работаем с архивами'}

  ExtractImageWithIndex:function(ArcName:PWideChar;Index,SortMode:Integer;CaseSensitive:Boolean):PWideChar;stdcall;
  //извлечь изображение с именем ImageName
  ExtractImageWithName:function(ArcName,ImageName:PWideChar):Boolean;stdcall;

{$ENDREGION}

{$REGION 'Документация'}

  //открываем документацию
  //на определенной странице
  ShowDocumentation:function(Page:PWideChar):Boolean;
  //получить путь к файлу иконки
  GetGifFileDocumentation:function:PWideChar;

{$ENDREGION}

{$REGION 'Логирование'}

  //печать сообщения в лог
  PrintToProgramLog:function(Msg:PWideChar;Group:PWideChar):Boolean;
  //печать ошибки в лог
  PrintErrorToProgramLog:function(Msg:PWideChar;Group:PWideChar):Boolean;

{$ENDREGION}

  //флаг загрузки курсора
  CursorsIsLoading:Boolean = false;

procedure InitLinks;

//загружаем курсоры
procedure CursorsLoading;

implementation

uses
  Forms,Controls;

procedure InitLinks;
begin

{$REGION 'Спиcок архивов'}

  //количество архивов
  GetArchivesCount:=GetProcAddress(MainInstance,'GetArchivesCount');
  //возвращаем имя архива
  GetArchiv:=GetProcAddress(MainInstance,'GetArchiv');
  //установить новое имя для архива
  SetNameArchiv:=GetProcAddress(MainInstance,'SetNameArchiv');
  //возвращаем позицию
  //в списке архивов
  GetArchivPosition:=GetProcAddress(MainInstance,'GetArchivPosition');
  //открываем архив
  //с указанной позицией индекса
  GetArchivOpenIndex:=GetProcAddress(MainInstance,'GetArchivOpenIndex');

{$ENDREGION}

{$REGION 'Навигация'}

  //следующее изображение
  Navigation_NextImage:=GetProcAddress(MainInstance,'Navigation_NextImage');
  //предыдущее изображение
  Navigation_PrevImage:=GetProcAddress(MainInstance,'Navigation_PrevImage');
  //начальное изображение
  Navigation_StartImage:=GetProcAddress(MainInstance,'Navigation_StartImage');
  //конечное изображение
  Navigation_EndImage:=GetProcAddress(MainInstance,'Navigation_EndImage');
  //получить текущую позицию
  Navigation_Position:=GetProcAddress(MainInstance,'Navigation_Position');
  //следующий архив
  Navigation_NextArc:=GetProcAddress(MainInstance,'Navigation_NextArc');
  //предыдущий архив
  Navigation_PrevArc:=GetProcAddress(MainInstance,'Navigation_PrevArc');
  //первый архив
  Navigation_StartArc:=GetProcAddress(MainInstance,'Navigation_StartArc');
  //последний архив
  Navigation_EndArc:=GetProcAddress(MainInstance,'Navigation_EndArc');
  //позиция в списке архивов
  Navigation_ArcPosition:=GetProcAddress(MainInstance,'Navigation_ArcPosition');
  //установить новую позицию
  //в списке
  Navigation_NewPosition:=GetProcAddress(MainInstance,'Navigation_NewPosition');

{$ENDREGION}

{$REGION 'Список изображений'}

  //количество изображений
  ListImage_Count:=GetProcAddress(MainInstance,'ListImage_Count');
  //получить изображение
  //из списка
  ListImage_GetFileName:=GetProcAddress(MainInstance,'ListImage_GetFileName');
  //устанавливаем изображение
  //для списка
  ListImage_SetFileName:=GetProcAddress(MainInstance,'ListImage_SetFileName');
  ListImage_SaveGetToFile:=GetProcAddress(MainInstance,'ListImage_SaveGetToFile');
  ListImage_SaveGetToClipboard:=GetProcAddress(MainInstance,'ListImage_SaveGetToClipboard');
  ListImage_RotateGetTo80CW:=GetProcAddress(MainInstance,'ListImage_RotateGetTo80CW');
  ListImage_RotateGetTo80CWAll:=GetProcAddress(MainInstance,'ListImage_RotateGetTo80CWAll');
  ListImage_RotateGetTo80CCW:=GetProcAddress(MainInstance,'ListImage_RotateGetTo80CCW');
  ListImage_RotateGetTo80CCWAll:=GetProcAddress(MainInstance,'ListImage_RotateGetTo80CCWAll');
  //зеркальные повороты
  //текущего изображения
  ListImage_FlipImage:=GetProcAddress(MainInstance,'ListImage_FlipImage');
  //зеркальные повороты
  //всех изображений
  ListImage_FlipImageAll:=GetProcAddress(MainInstance,'ListImage_FlipImageAll');
  //получаем признак того
  //что изображения зачитаны из архива
  ListImage_OpenArchive:=GetProcAddress(MainInstance,'ListImage_OpenArchive');

{$ENDREGION}

{$REGION 'Список текстовых файлов'}

  //количество файлов
  TxtFiles_Count:=GetProcAddress(MainInstance,'TxtFiles_Count');
  //получаем имя файла
  TxtFiles_GetFileName:=GetProcAddress(MainInstance,'TxtFiles_GetFileName');
  //извлекаем файл
  //во временную папку
  TxtFiles_ExtractByName:=GetProcAddress(MainInstance,'TxtFiles_ExtractByName');

{$ENDREGION}

{$REGION 'Пути'}

  Paths_GetApplicationPath:=GetProcAddress(MainInstance,'Paths_GetApplicationPath');
  Paths_GetTempPath:=GetProcAddress(MainInstance,'Paths_GetTempPath');

{$ENDREGION}

{$REGION 'Программа'}

  //версия программы
  Program_VersionProg:=GetProcAddress(MainInstance,'Program_VersionProg');
  //фильтр изображений
  Program_ImageFilter:=GetProcAddress(MainInstance,'Program_ImageFilter');
  //фильтр для архивов
  Program_ArchiveFilter:=GetProcAddress(MainInstance,'Program_ArchiveFilter');
  //режим масштабирования
  Program_ImageMode:=GetProcAddress(MainInstance,'Program_ImageMode');
  //запускаем команду меню
  Program_RunMenuCommand:=GetProcAddress(MainInstance,'Program_RunMenuCommand');
  //стрелочный курсор
  Program_GetArrowCursor:=GetProcAddress(MainInstance,'Program_GetArrowCursor');
  //загрузочный курсор
  Program_GetLoadCursor:=GetProcAddress(MainInstance,'Program_GetLoadCursor');

{$ENDREGION}

{$REGION 'Режимы программы'}

  //включение/выключение
  //режима прокрутки
  Scrolling_SetActiveScroll:=GetProcAddress(MainInstance,'Scrolling_SetActiveScroll');
  //отображаем состояние
  //активной прокрутки
  Scrolling_GetActiveScroll:=GetProcAddress(MainInstance,'Scrolling_GetActiveScroll');

{$ENDREGION}

{$REGION 'Окно программы'}

  //полноэкранный ли режим
  //изображения
  Window_FullScreenMode:=GetProcAddress(MainInstance,'Window_FullScreenMode');
  //возвращаем позицию
  //и ширину длину окна
  Window_GetWindowPosition:=GetProcAddress(MainInstance,'Window_GetWindowPosition');
  //активно ли окно
  Window_ActivatedWindow:=GetProcAddress(MainInstance,'Window_ActivatedWindow');
  //возвращаем основную форму
  Window_GetFormHandle:=GetProcAddress(MainInstance,'Window_GetFormHandle');

{$ENDREGION}

{$REGION 'Мультиязыковой интерфейс и конфигурация'}

  GetConfigHandle:=GetProcAddress(MainInstance,'GetConfigHandle');
  //получить первое значение
  //в группе
  MultiLanguage_GetGroupValue:=GetProcAddress(MainInstance,'MultiLanguage_GetGroupValue');
  //получить значение из одиночного
  //списка
  MultiLanguage_GetConfigValue:=GetProcAddress(MainInstance,'MultiLanguage_GetConfigValue');
  //установить значение в одиночном списке
  MultiLanguage_SetConfigValue:=GetProcAddress(MainInstance,'MultiLanguage_SetConfigValue');

{$ENDREGION}

{$REGION 'Работаем с архивами'}

  ExtractImageWithIndex:=GetProcAddress(MainInstance,'ExtractImageWithIndex');
  ExtractImageWithName:=GetProcAddress(MainInstance,'ExtractImageWithName');

{$ENDREGION}

{$REGION 'Документация'}

  //открываем документацию
  //на определенной странице
  ShowDocumentation:=GetProcAddress(MainInstance,'ShowDocumentation');
  GetGifFileDocumentation:=GetProcAddress(MainInstance,'GetGifFileDocumentation');

{$ENDREGION}

{$REGION 'Логирование'}

  //открываем документацию
  //на определенной странице
  PrintToProgramLog:=GetProcAddress(MainInstance,'PrintToProgramLog');
  PrintErrorToProgramLog:=GetProcAddress(MainInstance,'PrintErrorToProgramLog');

{$ENDREGION}


end;

//загружаем курсоры
procedure CursorsLoading;
begin
  if not CursorsIsLoading then
  begin
    Screen.Cursors[crArrow]:=Program_GetArrowCursor;
    Screen.Cursors[crHourGlass]:=Program_GetLoadCursor;
    CursorsIsLoading:=true;
  end;
end;

end.
