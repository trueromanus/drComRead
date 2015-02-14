{
  drComRead

  Модуль для объявления
  заголовочный функций

  Copyright (c) 2008-2009 Romanus
}
unit DLLHeaders;

interface

uses
  CRGlobal, Classes, Controls, ComReadSerialize;

type
  //массив индексов
  TALIntArray = array of integer;
  //тип для возвращение результата
  //индексов поиска
  TIndexHistoryArray = array of Integer;
  //массив строк
  TWideCharHistoryArray = array of PWideChar;

  //результат диалога
  TResultDialog = record
    //флаг успешного завершнения
    Complete:Boolean;
    //тип открываемого файла
    TypeDate:Byte;
    //имя файла
    NameFile:PWideChar;
    //Идентификатор записи
    IDRecord:Integer;
  end;

const
  NameSortFilesLibrary      =       'dialogs\sortfiles.dll';
  NameArcSortFilesLibrary   =       'dialogs\arcdialog.dll';
  NameHistoryLibrary        =       'dialogs\history.dll';
  NamePreviewLibrary        =       'dialogs\previewpage.dll';
  NameDocumentationLibrary  =       'crod\crod.dll';
  NameOnlineArcLibrary      =       'onlinearc.dll';

{$REGION 'Работаем с диалогами'}

//диалог списка архивов
function ShowArchiveDialog(Left,Top:Integer):PWideChar;stdcall;
external 'dialogs\arcdialog.dll';
function SortArchivesList(Mode:Byte):Boolean;stdcall;
external 'dialogs\arcdialog.dll';
//диалог О Программе
procedure ShowAboutDialog(Left,Top:integer;Version:PChar);stdcall;
external 'dialogs\information.dll';
//диалог конфигурации программы
function ShowConfigDialog(fname:PWideChar):boolean;stdcall;
external 'dialogs\config.dll';
function ShowConfigFormDialog(fname:PWideChar):boolean;stdcall;
external 'dialogs\config.dll';
//диалог с информацией о папках/архивах
function ShowReadForm(Path:PWideChar;Mode:Byte):Boolean;stdcall;
external 'dialogs\readinfo.dll';
//отображаем диалог октрытия
//каталогов
function ShowDirDialog(Left,Top:Integer):PWideChar;stdcall;
external 'dialogs\opendir.dll';
//отображаем диалог сортировки
function ShowSortFilesDialog(Left,Top:Integer):Boolean;stdcall;
external 'dialogs\sortfiles.dll';

//отображаем диалог открытия
//окна предпросмотра
function ShowPrevOneDialog(Position:Integer):Integer;stdcall;
external NamePreviewLibrary;
//инициализация изображений
function LoadImagesCollection:Boolean;stdcall;
external NamePreviewLibrary;
//деинициализация изображений
function ClearBitmapList:Boolean;stdcall;
external NamePreviewLibrary;
//загружается ли список или нет
function BitmapListIsLoading:Boolean;stdcall;
external NamePreviewLibrary;

//принудительное закрытие окна навигатора
function CloseNavigatorWindow:Boolean;stdcall;
external 'dialogs\navigator.dll';
//отображаем диалог навигатора
function ShowNavigatorDialog:Boolean;stdcall;
external 'dialogs\navigator.dll';
//инициализируем диалог
function InitNavigatorDialog(Control:Pointer):Boolean;stdcall;
external 'dialogs\navigator.dll';

//открываем диалог
function OpenArchiveDialog():Boolean;stdcall;
external 'dialogs\openfiledialog.dll';
//количество открываемых файлов
function OpenDialogFilesCount():Integer;stdcall;
external 'dialogs\openfiledialog.dll';
//получить путь к открываемому файлу
function OpenDialogFilesName(Index:Integer):PWideChar;stdcall;
external 'dialogs\openfiledialog.dll';

//получить или создать
//файл базы данных и
//насоздавать в нем таблиц
function InitDataBase:Boolean;stdcall;
external NameHistoryLibrary;
//ищем закладку
//для текущего архива
//если находим возвращаем
//полное имя файла извлеченное
//из архива
function FindBookmarkArchive(Name:PWideChar;FullPathMode:Boolean):PWideChar;stdcall;
external NameHistoryLibrary;
//ищем все закладки
//для текущего архива
//и возвращаем их
//в виде массива со строками
function FindAllBookmarkArchive(Name:PWideChar;FullPathMode:Boolean):TWideCharHistoryArray;stdcall;
external NameHistoryLibrary;
//добавляем закладку на
//архив в слеучае если
//она уже существует
//перезаписываем данные
function AddBookmarkArchive(Name,NamePage:PWideChar):Boolean;stdcall;
external NameHistoryLibrary;
//удаляем закладку на архив
//по полному имени или только имени файла
function DeleteBookmarkArchive(Name:PWideChar;FullPathMode:Boolean):Boolean;stdcall;
external NameHistoryLibrary;
//удаляем закладку на архив
//по полному пути и имени закладки
function DeleteBookmarkArchivePage(Name:PWideChar;NamePage:PWideChar):Boolean;stdcall;
external NameHistoryLibrary;
//возвращаем последние
//открываемые папки
function FindHistoryDirLast(CountRes:Integer):TIndexHistoryArray;stdcall;
external NameHistoryLibrary;
//ищем по индексу
function FindHistoryDirIndex(Index:Integer):PWideChar;stdcall;
external NameHistoryLibrary;
//добавляем в историю
//папку
function AddHistoryDir(Dir:PWideChar):Boolean;stdcall;
external NameHistoryLibrary;

//ищем последние записи в истории
function FindHistoryArcLast(CountRes:Integer):TIndexHistoryArray;stdcall;
external NameHistoryLibrary;
//ищемзапись по индексу
function FindHistoryArcIndex(Index:Integer):PWideChar;stdcall;
external NameHistoryLibrary;
//добавляем архив в
//историю
function AddHistoryArc(Dir:PWideChar):Boolean;stdcall;
external NameHistoryLibrary;

//показываем диалог истории
function ShowDialogHistory:TResultDialog;stdcall;
external NameHistoryLibrary;

//показываем диалог истории
function ShowDocumentationDialog(language,version,defaultpage:PWideChar):Boolean;stdcall;
external NameDocumentationLibrary;

{$ENDREGION}

{$REGION 'Сортировка файлов'}

//основна функция сортировки
function SortFilesMainFunc(Mode:Byte):Boolean;stdcall;
external NameSortFilesLibrary;
//целиковая функция сортировки
function SortingFilesAtList(Mode:Byte;Strings:TStringList):Boolean;stdcall;
external NameSortFilesLibrary;

//контекст сортировки
function SortFilesContext(Control:TWinControl):Boolean;
external NameSortFilesLibrary;

{$ENDREGION}

{$REGION 'Формат comread'}

//распарсить файл формата comread
function ParseDataComReadAtFile(FileName:PWideChar):TCRComicsData;stdcall;
external NameOnlineArcLibrary;

{$ENDREGION}

implementation

end.
