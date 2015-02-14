{
  drComRead

  Модуль для описания
  экспортируемых функций

  Copyright (c) 2008-2009 Romanus
}
unit FuncExports;

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

{$REGION 'Спиcок архивов'}

//количество архивов
function GetArchivesCount:Integer;stdcall;
//возвращаем имя архива
function GetArchiv(Index:Integer):PWideChar;stdcall;
//установить новое имя для архива
function SetNameArchiv(Index:Integer;NewName:PWideChar):Boolean;stdcall;
//возвращаем позицию
//в списке архивов
function GetArchivPosition:Integer;stdcall;
//открываем архив
//с указанной позицией индекса
function GetArchivOpenIndex(Index:Integer):Boolean;stdcall;

{$ENDREGION}

{$REGION 'Навигация'}

//следующее изображение
function Navigation_NextImage:Boolean;stdcall;
//предыдущее изображение
function Navigation_PrevImage:Boolean;stdcall;
//начальное изображение
function Navigation_StartImage:Boolean;stdcall;
//конечное изображение
function Navigation_EndImage:Boolean;stdcall;
//получить текущую позицию
function Navigation_Position:Integer;stdcall;
//следующий архив
function Navigation_NextArc:Boolean;stdcall;
//предыдущий архив
function Navigation_PrevArc:Boolean;stdcall;
//первый архив
function Navigation_StartArc:Boolean;stdcall;
//последний архив
function Navigation_EndArc:Boolean;stdcall;
//позиция в списке архивов
function Navigation_ArcPosition:Boolean;stdcall;
//установить новую позицию
//в списке
function Navigation_NewPosition(Index:Integer):Boolean;stdcall;

{$ENDREGION}

{$REGION 'Список изображений'}

//количество изображений
function ListImage_Count:Integer;stdcall;
//получить изображение
//из списка
function ListImage_GetFileName(Index:Integer):PWideChar;stdcall;
//устанавливаем изображение
//для списка
function ListImage_SetFileName(Index:Integer;FileName:PWideChar):Boolean;stdcall;
function ListImage_SaveGetToFile(FileName:PWideChar):Boolean;stdcall;
function ListImage_SaveGetToClipboard:Boolean;stdcall;
function ListImage_RotateGetTo80CW:Boolean;stdcall;
function ListImage_RotateGetTo80CWAll:Boolean;stdcall;
function ListImage_RotateGetTo80CCW:Boolean;stdcall;
function ListImage_RotateGetTo80CCWAll:Boolean;stdcall;
//зеркальные повороты
//текущего изображения
function ListImage_FlipImage(Vert:Boolean):Boolean;stdcall;
//зеркальные повороты
//всех изображений
function ListImage_FlipImageAll(Vert:Boolean):Boolean;stdcall;
//получай признак того
//что изображения зачитаны из архива
function ListImage_OpenArchive:Boolean;stdcall;

{$ENDREGION}

{$REGION 'Список текстовых файлов'}

//количество файлов
function TxtFiles_Count:Integer;stdcall;
//получаем имя файла
function TxtFiles_GetFileName(Index:Integer):PWideChar;stdcall;
//извлекаем файл
//во временную папку
function TxtFiles_ExtractByName(Name:PWideChar):Boolean;stdcall;

{$ENDREGION}

{$REGION 'Пути'}

function Paths_GetApplicationPath():PWideChar;stdcall;
function Paths_GetTempPath():PWideChar;stdcall;

{$ENDREGION}

{$REGION 'Программа'}

//версия программы
function Program_VersionProg:PWideChar;stdcall;
//фильтр изображений
function Program_ImageFilter:PWideChar;stdcall;
//фильтр для архивов
function Program_ArchiveFilter:PWideChar;stdcall;
//режим масштабирования
function Program_ImageMode:Byte;stdcall;
//запускаем команду меню
function Program_RunMenuCommand(Index:Integer):Boolean;stdcall;
//стрелочный курсор
function Program_GetArrowCursor:HCURSOR;stdcall;
//загрузочный курсор
function Program_GetLoadCursor:HCURSOR;stdcall;

{$ENDREGION}

{$REGION 'Режимы программы'}

//включение/выключение
//режима прокрутки
function Scrolling_SetActiveScroll(Mode:Boolean):Boolean;stdcall;
//отображаем состояние
//активной прокрутки
function Scrolling_GetActiveScroll:Boolean;stdcall;

{$ENDREGION}

{$REGION 'Окно программы'}

//полноэкранный ли режим
//изображения
function Window_FullScreenMode:Boolean;stdcall;
//возвращаем позицию
//и ширину длину окна
function Window_GetWindowPosition:TFEWindowPosition;stdcall;
//активно ли окно
function Window_ActivatedWindow:Boolean;stdcall;
//возвращаем основную форму
function Window_GetFormHandle:Pointer;stdcall;

{$ENDREGION}

{$REGION 'Мультиязыковой интерфейс и конфигурация'}

function GetConfigHandle:Integer;stdcall;
//получить первое значение
//в группе
function MultiLanguage_GetGroupValue(Group,Key:PWideChar):PWideChar;stdcall;
//получить значение из одиночного
//списка
function MultiLanguage_GetConfigValue(Key:PWideChar):PWideChar;stdcall;
//установить значение в одиночном списке
function MultiLanguage_SetConfigValue(Key,NewValue:PWideChar):Boolean;stdcall;

{$ENDREGION}

{$REGION 'Работаем с архивами'}

//извлечь изображение
//с индексом Index с учетом
//сортировки SortMode и которая
//учитываем или нет регистр через CaseSensitive
function ExtractImageWithIndex(ArcName:PWideChar;Index,SortMode:Integer;CaseSensitive:Boolean):PWideChar;stdcall;
//извлечь изображение с именем ImageName
function ExtractImageWithName(ArcName,ImageName:PWideChar):Boolean;stdcall;

{$ENDREGION}

{$REGION 'Документация'}

//открываем документацию
//на определенной странице
function ShowDocumentation(Page:PWideChar):Boolean;
//получить путь к файлу иконки
function GetGifFileDocumentation:PWideChar;

{$ENDREGION}

{$REGION 'Логирование'}

//печать сообщения в лог
function PrintToProgramLog(Msg:PWideChar;Group:PWideChar):Boolean;
//печать ошибки в лог
function PrintErrorToProgramLog(Msg:PWideChar;Group:PWideChar):Boolean;

{$ENDREGION}

implementation

uses
  Forms, Clipbrd, Classes, SysUtils, Controls,
  Generics.Collections, Generics.Defaults,
  MainForm,
  CRGlobal, CRDir, CRImageVisual, CRLog,
  DllHeaders, ArcFunc;

function FEStringToWideString(Str:String):PWideChar;
var
  WStr:WideString;
begin
  WStr:=Str;
  Result:=PWideChar(WStr);
end;

{$REGION 'Спиcок архивов'}

//Работаем с архивами
//количество архивов
function GetArchivesCount:Integer;
begin
  Result:=DirObj.Archives.Count;
end;

//возвращаем имя архива
function GetArchiv(Index:Integer):PWideChar;
begin
  Result:='';
  if (Index >= DirObj.Archives.Count) or (Index < 0) then
    Exit;
  Result:=FEStringToWideString(DirObj.Archives.Strings[Index]);
end;

//установить новое имя для архива
function SetNameArchiv(Index:Integer;NewName:PWideChar):Boolean;stdcall;
begin
  Result:=false;
  if (Index >= DirObj.Archives.Count) or (Index < 0) then
    Exit;
  DirObj.Archives.Strings[Index]:=NewName;
  Result:=true;
end;

//возвращаем позицию
//в списке архивов
function GetArchivPosition:Integer;
begin
  Result:=DirObj.ArchivesPos;
end;

//открываем архив
//с указанной позицией индекса
function GetArchivOpenIndex(Index:Integer):Boolean;
begin
  LoadToArchiveNumber(Index);
  Result:=true;
end;

{$ENDREGION}

{$REGION 'Навигация'}

//следующее изображение
function Navigation_NextImage:Boolean;
begin
  Result:=FormMain.LoadNavigateBitmap(1);
end;

//предыдущее изображение
function Navigation_PrevImage:Boolean;
begin
  Result:=FormMain.LoadNavigateBitmap(2);
end;

//начальное изображение
function Navigation_StartImage:Boolean;
begin
  Result:=FormMain.LoadNavigateBitmap(0);
end;

//конечное изображение
function Navigation_EndImage:Boolean;
begin
  Result:=FormMain.LoadNavigateBitmap(3);
end;

//получить текущую позицию
function Navigation_Position:Integer;
begin
  Result:=DirObj.Position;
end;

//следующий архив
function Navigation_NextArc:Boolean;
begin
  FormMain.Menu_NextArchiveClick(nil);
  Result:=true;
end;

//предыдущий архив
function Navigation_PrevArc:Boolean;
begin
  FormMain.Menu_PrevArchiveClick(nil);
  Result:=true;
end;

//первый архив
function Navigation_StartArc:Boolean;stdcall;
begin
  FormMain.Menu_StartArchiveClick(nil);
  Result:=true;
end;

//последний архив
function Navigation_EndArc:Boolean;stdcall;
begin
  FormMain.Menu_EndArchiveClick(nil);
  Result:=true;
end;

//позиция в списке архивов
function Navigation_ArcPosition:Boolean;
begin
  FormMain.Menu_PrevArchiveClick(nil);
  Result:=true;
end;

//установить новую позицию
//в списке
function Navigation_NewPosition(Index:Integer):Boolean;stdcall;
begin
  Result:=FormMain.LoadNavigateBitmap(4,Index);
end;

{$ENDREGION}

{$REGION 'Список изображений'}

//количество изображений
function ListImage_Count:Integer;
begin
  Result:=DirObj.BitmapList.Count;
end;

//получить изображение
//из списка
function ListImage_GetFileName(Index:Integer):PWideChar;
var
  FileRecord:PCRFileRecord;
  WStr:WideString;
begin
  Result:='';
  if (Index >= DirObj.BitmapList.Count) or (Index < 0) then
    Exit;
  FileRecord:=DirObj.BitmapList.Items[Index];
  WStr:=FileRecord.FileName;
  Result:=PWideChar(WStr);
end;

//устанавливаем изображение
//для списка
function ListImage_SetFileName(Index:Integer;FileName:PWideChar):Boolean;
var
  FileRecord:PCRFileRecord;
begin
  Result:=false;
  if Index >= DirObj.BitmapList.Count then
    Exit;
  FileRecord:=DirObj.BitmapList.Items[Index];
  FileRecord.FileName:=FileName;
  Result:=true;
end;

function ListImage_SaveGetToFile(FileName:PWideChar):Boolean;stdcall;
var
  Ext:string;
begin
  Result:=false;
  //если нет изображений
  //нечего и сохранять
  if DirObj.BitmapList.Count = 0 then
    Exit;
  DirObj.GetBitmap;
  if FormMain.MainImage.LayersCount = 0 then
    Exit;
  Ext:=ExtractFileExt(FileName);
  Ext:=LowerCase(Ext);
  try
    //сохраняем в bmp
    if Ext = '.bmp' then
      FormMain.MainImage.IO.SaveToFileBMP(FileName);
    //сохраняем в tiff
    if (Ext = '.tif') or (Ext = '.tiff') then
      FormMain.MainImage.IO.SaveToFileTIFF(FileName);
    //сохраняем в jpeg
    if (Ext = '.jpg') or (Ext = '.jpeg') then
      FormMain.MainImage.IO.SaveToFileJpeg(FileName);
    //сохраняем в psd
    if (Ext = '.psd') then
      FormMain.MainImage.IO.SaveToFilePSD(FileName);
    //сохраняем в pdf
    if (Ext = '.pdf') then
      FormMain.MainImage.IO.SaveToFilePDF(FileName);
    //сохраняем в gif
    if (Ext = '.gif') then
      FormMain.MainImage.IO.SaveToFileGIF(FileName);
    //сохраняем в png
    if (Ext = '.png') then
      FormMain.MainImage.IO.SaveToFilePNG(FileName);
    //сохраняем в tga
    if (Ext = '.tga') then
      FormMain.MainImage.IO.SaveToFileTGA(FileName);
    //сохраняем в hdp
    if (Ext = '.hdp') then
      FormMain.MainImage.IO.SaveToFileHDP(FileName);
    Result:=true;
  except
    //ошибка сохранения
  end;
end;

function ListImage_SaveGetToClipboard:Boolean;stdcall;
begin
  Result:=false;
  //если нет изображений
  //нечего и сохранять
  if DirObj.BitmapList.Count = 0 then
    Exit;
  DirObj.GetBitmap;
  if FormMain.MainImage.LayersCount = 0 then
    Exit;
  try
    FormMain.MainImage.Proc.CopyToClipboard();
    Result:=true;
  except
    //ошибка сохранения
  end;
end;

function ListImage_RotateGetTo80CW:Boolean;stdcall;
var
  FileRec:PCRFileRecord;
begin
  Result:=false;
  //если нет изображений
  //нечего и поворачивать
  if DirObj.BitmapList.Count = 0 then
    Exit(false);
  FileRec:=DirObj.GetElement(DirObj.Position);
  if FileRec = nil then
    Exit;
  try
    FileRec:=DirObj.GetElement(DirObj.Position);
    FileRec.TransformMode:=1;
    if FileRec.TransformRotState = 3 then
    begin
      //типа оригинальное
      //положение
      FileRec.TransformRotState:=0;
      FileRec.TransformMode:=0;
    end else
      Inc(FileRec.TransformRotState);
    MainForm.FormMain.LoadNavigateBitmap(4,DirObj.Position);
    Result:=true;
  except
    Result:=false;
  end;
end;

function ListImage_RotateGetTo80CWAll:Boolean;stdcall;
var
  FileRec:PCRFileRecord;
  GetPos:Integer;
begin
  //если нет изображений
  //нечего и поворачивать
  if DirObj.BitmapList.Count = 0 then
    Exit(false);
  for GetPos:=0 to DirObj.BitmapList.Count-1 do
  begin
    FileRec:=DirObj.GetElement(GetPos);
    if FileRec = nil then
      Exit(false);
    try
      FileRec.TransformMode:=1;
      if FileRec.TransformRotState = 3 then
      begin
        //типа оригинальное
        //положение
        FileRec.TransformRotState:=0;
        FileRec.TransformMode:=0;
      end else
        Inc(FileRec.TransformRotState);
    except
      //если свалились
      //валим из функции
      Exit(false);
    end;
  end;
  MainForm.FormMain.LoadNavigateBitmap(4,DirObj.Position);
  Result:=true;
end;

function ListImage_RotateGetTo80CCW:Boolean;stdcall;
var
  FileRec:PCRFileRecord;
begin
  //если нет изображений
  //нечего и поворачивать
  if DirObj.BitmapList.Count = 0 then
    Exit(false);
  FileRec:=DirObj.GetElement(DirObj.Position);
  if FileRec = nil then
    Exit(false);
  try
    FileRec:=DirObj.GetElement(DirObj.Position);
    FileRec.TransformMode:=2;
    if FileRec.TransformRotState = 1 then
    begin
      FileRec.TransformRotState:=0;
      FileRec.TransformMode:=0;
    end;
    if FileRec.TransformRotState = 0 then
      FileRec.TransformRotState:=4;
    Dec(FileRec.TransformRotState);
    MainForm.FormMain.LoadNavigateBitmap(4,DirObj.Position);
    Result:=true;
  except
    Result:=false;
  end;
end;

function ListImage_RotateGetTo80CCWAll:Boolean;stdcall;
var
  FileRec:PCRFileRecord;
  GetPos:Integer;
begin
  //если нет изображений
  //нечего и поворачивать
  if DirObj.BitmapList.Count = 0 then
    Exit(false);
  for GetPos:=0 to DirObj.BitmapList.Count-1 do
  begin
    FileRec:=DirObj.GetElement(GetPos);
    if FileRec = nil then
      Exit(false);
    try
      FileRec.TransformMode:=2;
      if FileRec.TransformRotState = 1 then
      begin
        FileRec.TransformRotState:=0;
        FileRec.TransformMode:=0;
      end;
      Dec(FileRec.TransformRotState);
    except
      Exit(false);
    end;
  end;
  MainForm.FormMain.LoadNavigateBitmap(4,DirObj.Position);
  Result:=true;
end;

//зеркальные повороты
//текущего изображения
function ListImage_FlipImage(Vert:Boolean):Boolean;stdcall;
var
  FileRec:PCRFileRecord;
begin
  //если нет изображений
  //нечего и поворачивать
  if DirObj.BitmapList.Count = 0 then
    Exit(false);
  FileRec:=DirObj.GetElement(DirObj.Position);
  if FileRec = nil then
    Exit(false);
  try
    FileRec:=DirObj.GetElement(DirObj.Position);
    if Vert then
      FileRec.TransformMode:=4
    else
      FileRec.TransformMode:=3;
    MainForm.FormMain.LoadNavigateBitmap(4,DirObj.Position);
    Result:=true;
  except
    Result:=false;
  end;
end;

//зеркальные повороты
//всех изображений
function ListImage_FlipImageAll(Vert:Boolean):Boolean;stdcall;
var
  FileRec:PCRFileRecord;
  GetPos:Integer;
begin
  //если нет изображений
  //нечего и поворачивать
  if DirObj.BitmapList.Count = 0 then
    Exit(false);
  for GetPos:=0 to DirObj.BitmapList.Count-1 do
  begin
    FileRec:=DirObj.GetElement(GetPos);
    if FileRec = nil then
      Exit(false);
    try
      if Vert then
        FileRec.TransformMode:=4
      else
        FileRec.TransformMode:=3;
    except
      Exit(false);
    end;
  end;
  MainForm.FormMain.LoadNavigateBitmap(4,DirObj.Position);
  Result:=true;
end;

//получаем признак того
//что изображения зачитаны из архива
function ListImage_OpenArchive:Boolean;
begin
  Result:=DirObj.ArchiveOpened;
end;

{$ENDREGION}

{$REGION 'Список текстовых файлов'}

function TxtFiles_Count:Integer;
begin
  Result:=DirObj.TxtFiles.Count;
end;

function TxtFiles_GetFileName(Index:Integer):PWideChar;
var
  WStr:WideString;
begin
  Result:='';
  if Index >= DirOBj.TxtFiles.Count then
    Exit;
  WStr:=DirObj.TxtFiles.Strings[Index];
  Result:=PWideChar(WStr);
end;

//извлекаем файл
//во временную папку
function TxtFiles_ExtractByName(Name:PWideChar):Boolean;stdcall;
begin
  try
    if not ArcFunc.ExtractSingleC(Name) then
      Exit(false);
    Result:=true;
  except
    Result:=false;
  end;
end;

{$ENDREGION}

{$REGION 'Пути'}

function Paths_GetApplicationPath():PWideChar;
var
  WStr:WideString;
begin
  WStr:=PathToProgramDir;
  Result:=PWideChar(WStr);
end;

function Paths_GetTempPath():PWideChar;
begin
  Result:=PWideChar(PathToBaseDir);
end;

{$ENDREGION}

{$REGION 'Программа'}

//версия программы
function Program_VersionProg:PWideChar;
begin
  Result:=FEStringToWideString(PROGRAM_VERSION);
end;

//фильтр изображений
function Program_ImageFilter:PWideChar;
begin
  Result:=FEStringToWideString(IMAGE_FILTER);
end;

//фильтр для архивов
function Program_ArchiveFilter:PWideChar;
begin
  Result:=FEStringToWideString(ARC_FILTER);
end;

//режим масштабирования
function Program_ImageMode:Byte;
begin
  Result:=ImageMode;
end;

//запускаем команду меню
function Program_RunMenuCommand(Index:Integer):Boolean;stdcall;
begin
  with MainForm.FormMain do
  begin
    case Index of
      //открыть папку
      1:FormMain.Menu_OpenDirClick(nil);
      //открыть файл
      2:FormMain.Menu_OpenFileClick(nil);
      //закрыть файл
      3:FormMain.Menu_CloseCurrentClick(nil);
      //сортировка файлов
      4:FormMain.Menu_SortFilesClick(nil);
      //сортировка архивов
      5:FormMain.Menu_ArchiveListClick(nil);
      //информация о файле
      6:FormMain.Menu_FileInfoClick(nil);
      //следующее изображение
      7:FormMain.Menu_NextImageClick(nil);
      //предыдущее изображение
      8:FormMain.Menu_PrevImageClick(nil);
      //начальное изображение
      9:FormMain.Menu_StartImageClick(nil);
      //конечное изображение
      10:FormMain.Menu_EndImageClick(nil);
      //следующий архив
      11:FormMain.Menu_NextArchiveClick(nil);
      //предыдущий архив
      12:FormMain.Menu_PrevArchiveClick(nil);
      //начальный архив
      13:FormMain.Menu_StartArchiveClick(nil);
      //конечный архив
      14:FormMain.Menu_EndArchiveClick(nil);
      //полный экран
      15:FormMain.Menu_FullScreenClick(nil);
      //единичный просмотрщик
      16:FormMain.Menu_SinglePreviewClick(nil);
      //минимизировать
      17:FormMain.Menu_MinimizeClick(nil);
      //навигатор
      18:FormMain.Menu_NavigatorClick(nil);
      //масштабирование
      19:FormMain.Menu_ZoomClick(nil);
      //выровнять по ширине
      20:FormMain.Menu_StretchClick(nil);
      //выровнять по высоте
      21:FormMain.Menu_FitHeightClick(nil);
      //оригинал
      22:FormMain.Menu_OriginalClick(nil);
      //выход
      23:FormMain.Menu_ExitClick(nil);
      //80CW
      24:ListImage_RotateGetTo80CW;
      //80CCW
      25:ListImage_RotateGetTo80CCW;
      //Flip -
      26:ListImage_FlipImage(true);
      //Flip |
      27:ListImage_FlipImage(false);
      //80CW Все
      28:;
      //80CCW Все
      29:;
      //Flip - Все
      30:;
      //Flip | Все
      31:;
      //mouser
      32:FormMain.Menu_MouserClick(nil);
    end;
  end;
  Result:=true;
end;

//стрелочный курсор
function Program_GetArrowCursor:HCURSOR;
begin
  Result:=HCURSOR(Screen.Cursors[crArrow]);
end;

//загрузочный курсор
function Program_GetLoadCursor:HCURSOR;
begin
  Result:=HCURSOR(Screen.Cursors[crHourGlass]);
end;

{$ENDREGION}

{$REGION 'Режимы программы'}

//включение/выключение
//режима прокрутки
function Scrolling_SetActiveScroll(Mode:Boolean):Boolean;
begin
  try
    if Mode then
    begin
      ActiveScroll.Activate;
    end else
    begin
      ActiveScroll.DeActivate;
    end;
    Result:=true;      
  except
    Result:=false;
  end;
end;
//отображаем состояние
//активной прокрутки
function Scrolling_GetActiveScroll:Boolean;
begin
  Result:=ActiveScroll.Active;  
end;

{$ENDREGION}

{$REGION 'Окно программы'}

//полноэкранный ли режим
//изображения
function Window_FullScreenMode:Boolean;
begin
  Result:=false;
  if FormMain.FormStyle = fsStayOnTop then
    Result:=true;
end;

//возвращаем позицию
//и ширину длину окна
function Window_GetWindowPosition:TFEWindowPosition;
begin
  Result.X:=FormMain.Left;
  Result.Y:=FormMain.Top;
  Result.Width:=FormMain.Width;
  Result.Height:=FormMain.Height;
end;

//активно ли окно
function Window_ActivatedWindow:Boolean;
begin
  Result:=FormMain.Active;
end;

//возвращаем основную форму
function Window_GetFormHandle:Pointer;
begin
  Result:=Application;
end;

{$ENDREGION}

{$REGION 'Мультиязыковой интерфейс'}

function GetConfigHandle:Integer;
begin
  Result:=MainLangHandle;
end;

//получить первое значение
//в группе
function MultiLanguage_GetGroupValue(Group,Key:PWideChar):PWideChar;
begin
  Result:=PWideChar(GlobalLangData.ReadString(Group,Key,''));
end;

//получить значение из одиночного
//списка
function MultiLanguage_GetConfigValue(Key:PWideChar):PWideChar;
begin
  Result:=PWideChar(GlobalConfigData.ReadString(CONFIG_MAINSECTION,WideCharToString(Key),''));
end;

//установить значение в одиночном списке
function MultiLanguage_SetConfigValue(Key,NewValue:PWideChar):Boolean;
begin
  GlobalConfigData.WriteString(CONFIG_MAINSECTION,Key,NewValue);
  Result:=true;
end;

{$ENDREGION}

{$REGION 'Работаем с архивами'}

//извлечь изображение
//с индексом Index с учетом
//сортировки SortMode и которая
//учитываем или нет регистр через CaseSensitive
function ExtractImageWithIndex(ArcName:PWideChar;Index,SortMode:Integer;CaseSensitive:Boolean):PWideChar;
var
  Arc:T7Zip;
  GetPos:Integer;
  ImagesList:TList<String>;
begin
  Result:=PWideChar('');
  try
    Arc:=T7Zip.Create(ArcName);
    ImagesList:=TList<String>.Create();
    //ели архив не открыт
    //или список файлы не прочитан
    //значит нечего и делать
    if not Arc.TestArchive or not Arc.ReadListOfFiles then
      Exit;
    //получаем список изображений
    for GetPos:=0 to Arc.Files.Count-1 do
      if GetFileType(Arc.Files.Strings[GetPos]) = ftImage then
        ImagesList.Add(Arc.Files.Strings[GetPos]);
    //проверяем индекс по диапазону
    if Index >= ImagesList.Count then
      Exit;
    //сортируем список
    case SortMode of
      0:;
      //убывающая с полными путями
      1:ImagesList.Sort(TComparer<String>.Construct(
        function (const L, R: String): integer
        var
          NL,NR:String;
        begin
          NL:=L;
          NR:=R;
          if CaseSensitive then
          begin
            NL:=LowerCase(NL);
            NR:=LowerCase(NR);
          end;
          if NL < NR then
            Exit(-1);
          if NL = NR then
            Exit(0)
          else
            Exit(1);
        end
       ));
      2:ImagesList.Sort(TComparer<String>.Construct(
        function (const L, R: String): integer
        var
          NL,NR:string;
        begin
          if CaseSensitive then
          begin
            NL:=LowerCase(L);
            NR:=LowerCase(R);
          end;
          if NL > NR then
            Exit(-1);
          if NL = NR then
            Exit(0)
          else
            Exit(1);
        end
       ));
      3:ImagesList.Sort(TComparer<String>.Construct(
        function (const L, R: String): integer
        var
          NL,NR:string;
        begin
          NL:=ExtractFileName(L);
          NR:=ExtractFileName(R);
          if CaseSensitive then
          begin
            NL:=LowerCase(NL);
            NR:=LowerCase(NR);
          end;
          if NL < NR then
            Exit(-1);
          if NL = NR then
            Exit(0)
          else
            Exit(1);
        end
       ));
      4:ImagesList.Sort(TComparer<String>.Construct(
        function (const L, R: String): integer
        var
          NL,NR:string;
        begin
          NL:=ExtractFileName(L);
          NR:=ExtractFileName(R);
          if CaseSensitive then
          begin
            NL:=LowerCase(NL);
            NR:=LowerCase(NR);
          end;
          if NL > NR then
            Exit(-1);
          if NL = NR then
            Exit(0)
          else
            Exit(1);
        end
       ));
    end;
    //извлекаем изображение по индексу
    if Arc.ExtractByName(PathToBaseDir,ImagesList.Items[Index]) then
      Result:=PWideChar(PathToBaseDir+ExtractFileName(ImagesList.Items[Index]));
    ImagesList.Free;
    FreeAndNil(Arc);
  except
    if Assigned(Arc) then
      FreeAndNil(Arc);
    if Assigned(ImagesList) then
      FreeAndNil(ImagesList);
  end;
end;

//извлечь изображение с именем ImageName
function ExtractImageWithName(ArcName,ImageName:PWideChar):Boolean;
var
  Arc:T7Zip;
  NImageName:String;
begin
  try
    Arc:=T7Zip.Create(ArcName);
    //тестируем архив
    //и читаем список файлов
    if not Arc.TestArchive then
      Exit(false);
    if not Arc.ReadListOfFiles then
      Exit(false);
    NImageName:=ImageName;
    NImageName:=StringReplace(NImageName,'/','\',[rfReplaceAll]);
    Result:=Arc.ExtractByName(PathToBaseDir,NImageName);
    FreeAndNil(Arc);
  except
    Result:=false;
    if Assigned(Arc) then
      FreeAndNil(Arc);
  end;
end;

{$ENDREGION}

{$REGION 'Документация'}

//открываем документацию
//на определенной странице
function ShowDocumentation(Page:PWideChar):Boolean;
var
  Lang:String;
begin
  Lang:=GlobalConfigData.ReadString(CONFIG_MAINSECTION,'defaultlng','');
  Lang:=Copy(Lang,0,Pos('.',Lang)-1);
  PrintToLog('Program.FuncExports.ShowDocumentation(' + Lang + ',' + PROGRAM_VERSION + ',' + Page + ')');
  Result:=ShowDocumentationDialog(PWideChar(Lang),PWideChar(PROGRAM_VERSION),Page);
end;
//получить путь к файлу иконки
function GetGifFileDocumentation:PWideChar;
var
  FullPath:String;
begin
  FullPath:=PathToProgramDir+'data\help.bmp';
  PrintToLog('Program.FuncExports.GetGifFileDocumentation(' + FullPath + ')');
  Result:=PWideChar(FullPath);
end;

{$ENDREGION}

{$REGION 'Логирование'}

//печать сообщения в лог
function PrintToProgramLog(Msg:PWideChar;Group:PWideChar):Boolean;
var
  Srt,Grp:String;
begin
  Srt:=Msg;
  Grp:=Group;
  PrintToLog(Srt,Grp);
end;

//печать ошибки в лог
function PrintErrorToProgramLog(Msg:PWideChar;Group:PWideChar):Boolean;
begin
  PrintErrorToLog(Msg,Group);
end;

{$ENDREGION}

end.

