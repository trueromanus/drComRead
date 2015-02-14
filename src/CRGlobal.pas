{
  drComRead

  Модуль глобальных
  констант, переменных
  и функций

  Copyright (c) 2008-2012 Romanus
}
unit CRGlobal;

interface

uses
  Dialogs, ExtCtrls, IniFiles, Classes,
  CRDir, CRImageVisual, RGBCurvesdiagrammer, CRFastActions, CRLog,
  CRPlugins, SQLiteTable3;

const
  //фильтр изображений
                 //Jpeg and family images and JPEG2000
  IMAGE_FILTER = '*.jpg;*.jpeg;*.jpe;*.jif;*.jp2;' +
                 //PaintBrush PCX and DICOM Images
                 '*.pcx;*.dcm;*.dic;*.dicom;*.v2;' +
                 //Windows standart, web images
                 '*.bmp;*.wmf;*.emf;*.gif;*.png;' +
                 //Tiff, Photoshop PSD
                 '*.tiff;*.tif;*.fax;*.g3n;*.g3f;*.xif;*.psd;' +
                 //Targa images
                 '*.tga;*.targa;*.vda;*.icb;*.vst;*.pix' +
                 //Multipage PCX and Microsoft HD Photo
                 '*.dcx;*.wdp;*.hdp;' +
                 //Wireless Bitmap
                 '*.wbmp';
  ARC_FILTER   = '*.rar;*.zip;*.cbr;*.cbz;*.7z;*.gz;*.arj;*.tar';
  //версия программы
  PROGRAM_VERSION         =         '0.14.2a';
  //название секции
  //в конфигурационном файле
  CONFIG_MAINSECTION      =         'MAIN';

  {$REGION 'Режимы просмотра изображения'}
  
  //Режимы изображения
  //оригинал
  IMAGE_MODE_ORIGINAL     =         0;
  //масштабирование
  IMAGE_MODE_SCALE        =         1;
  //выравнивание по ширине
  IMAGE_MODE_STRETCH      =         2;
  //выравнивание по высоте
  IMAGE_MODE_HEIGHT       =         3;
  //настройка пользователя
  IMAGE_MODE_USER         =         4;
  //автоматическое выравнивание
  IMAGE_MODE_AUTOSIZE     =         5;

  {$ENDREGION}

var
  {$REGION 'Объекты'}

  //диалог открытия
  OpenDialog:TOpenDialog;
  //объект класса для
  //работы с папками
  DirObj:TCRDir;
  //объект для работы
  //с активным скроллингом
  ActiveScroll:TCRActiveScroll;
  //таймер для
  //скролируемой задержки
  ASSleepTimer:TTimer;
  //конфигурационный файл
  GlobalConfigData:TMemIniFile;
  //мультиязыковой файл
  GlobalLangData:TMemIniFile;
  //кривые для обработки
  //изображения
  MainCurves:TRGBCurves;
  //инструмент
  //быстрые действия
  FastActions:TCRFastActionsNew;
  //список подключенных
  //плагинов
  Addons:TCRPlugins;
  //класс для изменения размеров изображения
  ImageResizer:TCRImageResizer;
  //лог программы
  LogProgram:TCRLog;
  //основная база данных
  //для записи и чтения
  //истории и закладок
  ComReadDataBase:TSQLiteDatabase;


  {$ENDREGION}  

  {$REGION 'Пути'}

  //путь к базовому каталогу
  //для разархивирования
  PathToBaseDir:WideString;
  //путь к каталогу программы
  PathToProgramDir:String;

  {$ENDREGION}

  {$REGION 'Функциональные параметры'}

  //режим изображения
  //для портрета
  ImageMode:Byte = 0;
  //режим изображения
  //для альбомного
  //расположения листа
  ImageModeLandscape:Byte = 0;
  //режим масштабирования
  //для двухстраничного просмотра
  ImageModeTwoPage:Byte = 0;
  //режим сортировки
  SortFileMode:Byte = 0;
  //фильтры для диалога открытия
  OPENDIALOG_FILTER:WideString;
  //флаг открытия файл
  //анимированной загрузки
  FlagLAOpened:boolean;
  
  {$ENDREGION}

  {$REGION 'Опциональные параметры'}

  //минимизировать ли
  //окно при старте
  StartMinimize:Boolean;
  //включать ли при старте
  //ативное перемещение
  StartActiveScroll:Boolean;
  //чувствительность пермещения мыши
  SensivityMouseMove:Integer = 40;
  //полноэкранный режим
  FullScreenOpened:Boolean = false;
  //номер в списке с конфигурационными данными
  MainConfigFile:Integer;
  //имя файла с языковыми данными
  NameLanguageFile:WideString = 'default.lng';
  //сообщение по умолчанию
  DefaultMessage:String;
  //включена ли история
  EnableHistory:Boolean = false;
  //включен ли режим мягкого
  //скролирования изображений
  EnableSoftScrollMode:Boolean = true;
  //включен ли режим трейса
  EnableTrace:Boolean = true;

  {$ENDREGION}

  //стартовые параметры
  StartParameters:boolean = true;
  //номер списка с языковых данных
  MainLangHandle:Integer;

//прямой доступ к диалогу
//открытия файлов
function GetOpenDialog:TOpenDialog;
//читаем булев тип из параметров
//основных найтроек
function ReadBoolConfig(NameParam:String):Boolean;
//читаем число с плавающей точкой из параметров
//основных найтроек
function ReadFloatConfig(NameParam:String):Double;
//читаем число из параметров
//основных найтроек
function ReadIntConfig(NameParam:String):Integer;
//читаем строку из параметров
//основных найтроек
function ReadStringConfig(NameParam:String):String;
//читаем значение из
//файла с языковыми данными
function ReadLang(Group,Name:String):String;
//общая функция для
//сортировки файлов
function MainSortFiles(Mode:Byte):Boolean;
//печать в лог
procedure PrintToLog(Msg:String;const Group:String = '');
//печать в лог ошибку
procedure PrintErrorToLog(Msg:String;const Group:String = '');
//печать в лог критическую ошибку
procedure PrintCriticalErrorToLog(Msg:String;const Group:String = '');
//печать в лог системную ошибку
procedure PrintSystemToLog(Msg:String);

implementation

uses
  Forms, SysUtils, DLLHeaders, Windows;

//прямой доступ к диалогу
//открытия файлов
function GetOpenDialog:TOpenDialog;
begin
  if OpenDialog = nil then
  begin
    OpenDialog:=TOpenDialog.Create(nil);
    //множественный выбор
    OpenDialog.Options:=[ofAllowMultiSelect];
    OpenDialog.Filter:=OPENDIALOG_FILTER;
  end;
  Result:=OpenDialog;
end;

//читаем булев тип из параметров
//основных найтроек
function ReadBoolConfig(NameParam:String):Boolean;
begin
  Result:=GlobalConfigData.ReadBool(CONFIG_MAINSECTION,NameParam,false);
end;

//читаем число с плавающей точкой из параметров
//основных найтроек
function ReadFloatConfig(NameParam:String):Double;
begin
  Result:=GlobalConfigData.ReadFloat(CONFIG_MAINSECTION,NameParam,0);
end;

//читаем число из параметров
//основных найтроек
function ReadIntConfig(NameParam:String):Integer;
begin
  Result:=GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,NameParam,0);
end;

//читаем строку из параметров
//основных найтроек
function ReadStringConfig(NameParam:String):String;
begin
  Result:=GlobalConfigData.ReadString(CONFIG_MAINSECTION,NameParam,'');
end;

//читаем значение из
//файла с языковыми данными
function ReadLang(Group,Name:String):String;
begin
  Result:=GlobalLangData.ReadString(Group,Name,'');
end;

//общая функция для
//сортировки файлов
function MainSortFiles(Mode:Byte):Boolean;
begin
  Result:=SortFilesMainFunc(0);
end;

//печать в лог
procedure PrintToLog(Msg:String;const Group:String = '');
begin
  if EnableTrace then
    LogProgram.Print(Msg,Group);
end;

//печать в лог ошибку
procedure PrintErrorToLog(Msg:String;const Group:String = '');
begin
  if EnableTrace then
    LogProgram.PrintError(Msg,Group);
end;

//печать в лог критическую ошибку
procedure PrintCriticalErrorToLog(Msg:String;const Group:String = '');
begin
  if EnableTrace then
    LogProgram.PrintCritical(Msg,Group);
end;

//печать в лог системного сообщения
procedure PrintSystemToLog(Msg:String);
begin
  if EnableTrace then
    LogProgram.PrintSystem(Msg);
end;

end.
