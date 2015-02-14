{
  drComRead

  Модуль работы с
  файловой абстракцией

  Copyright (c) 2009-2010 Romanus
}
unit CRFile;

interface

uses
  Classes;

//устанавливаем глобальный
//путь для извлечения
function SetGlobalTempPath(ConfigPath:WideString):WideString;
//загружаем конфигурационные
//данные
function LoadConfigData(fname:string):boolean;
//загружаем данные из памяти
function LoadConfigDataFromMemory:Boolean;
//обрабатываем командную строку
function FormatCommandLine:TStringList;
//получаем данные из
//мультиязыкового файла
function MultiLanguage_GetGroupValue(Group,Key:String):String;
//загружаем данные в
//меню
procedure LoadToPopUpMenu;
//проверяем новую версию
procedure CheckNewVersion(const DialogNotVersion:Boolean = false);

implementation

uses
  Dialogs,
  Windows, Messages, SysUtils, Graphics, Forms,
  CRGlobal, MainForm;

{$REGION 'Работаем с конфигурационным файлом'}

//определяем путь к
//системной временной папке
function GetWindowsTempPath:String;
var
  pTempPath:PChar;
begin
  pTempPath := StrAlloc(MAX_PATH + 1);
  GetTempPath(MAX_PATH+1, pTempPath);
  Result := string(pTempPath);
  StrDispose(pTempPath);
end;

//устанавливаем глобальный
//путь для извлечения
function SetGlobalTempPath(ConfigPath:WideString):WideString;
var
  WStr:WideString;
begin
  WStr:=ConfigPath;
  if WStr = '{windows|temp}' then
  begin
    PathToBaseDir:=GetWindowsTempPath;
  end else
  begin
    //признак того что путь полный
    if Pos(':',WStr) <> 0 then
      PathToBaseDir:=ConfigPath
    else
      //если нет то прибавляем к
      //текущему пути к программе
      PathToBaseDir:=PathToProgramDir+ConfigPath;
    //если папка не существует
    //пытаемся создать
    if not DirectoryExists(PathToBaseDir) then
      MkDir(PathToBaseDir);
  end;
end;

//загружаем конфигурационные
//данные
function LoadConfigData(fname:string):boolean;
begin
  //если нет основной секции
  //то валимся с ошибкой
  if not GlobalConfigData.SectionExists(CONFIG_MAINSECTION) then
    Exit(false);
  try
    //SensitivityMouseHigh:=GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,'sensivity_mouse',30);
    //SensitivityMouseLow:=0-SensitivityMouseHigh;
    //чувствительность активной прокрутки
    FormMain.ASTimer.Interval:=GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,'sensivity_level',20);
    //полноэкранный режим
    FullScreenOpened:=Boolean(GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,'full_screen',0));
    //режим отображения
    ImageMode:=GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,'get_view_mode',0);
    //режим отображения
    //для вертикальных
    //изображений
    ImageModeLandscape:=GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,'get_view_mode_vert',0);
    //режим отображения
    //для двухстарничного
    //просмотра
    ImageModeTwoPage:=GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,'get_view_mode_twopage',0);
    //минимизация
    StartMinimize:=Boolean(GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,'window_minimize',0));
    //активный скролинг
    StartActiveScroll:=Boolean(GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,'active_scroll',0));
    //режим сортировки по умолчанию
    SortFileMode:=GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,'sort_opened',0);
    //путь к временной папке
    SetGlobalTempPath(GlobalConfigData.ReadString(CONFIG_MAINSECTION,'get_temp_path',''));
    Result:=true;
  except
    Result:=false;
  end;
end;

//загружаем данные из памяти
function LoadConfigDataFromMemory:Boolean;
var
  ModeBackground:Integer;
begin
  Result:=false;
  try
    //Основные настройки
    //чувствительность прокрутки
    //SensitivityMouseHigh:=GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,'sensivity_mouse',30);
    //SensitivityMouseLow:=0-SensitivityMouseHigh;
    //чувствительность активной прокрутки
    FormMain.ASTimer.Interval:=GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,'sensivity_level',20);

    with FormMain do
    begin
      //режимы масштабирования
      //тоже сливаем те что установлены
      //в диалоге
      ImageMode:=ReadIntConfig('get_view_mode');
      ImageModeLandscape:=ReadIntConfig('get_view_mode_vert');
      ImageModeTwoPage:=ReadIntConfig('get_view_mode_twopage');
      //режимы фоновых закрасок
      ModeBackground:=GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,'modebackground',0);
      //если нужно рисовать фон
      if ModeBackground = 2 then
      begin
        MainImage.Background:=clBtnface;
        MainImage.WallPaper.LoadFromFile(GlobalConfigData.ReadString(CONFIG_MAINSECTION,'backgroundtile',PathToProgramDir + 'data\imagetile.jpg'));
      end else
      begin
        //для начала стираем фон
        MainImage.WallPaper:=nil;
        case ModeBackground of
          //установленный цвет
          1:
            begin
              if DirObj.NotEmpty then
                MainImage.Background:=GlobalConfigData.ReadInteger(CONFIG_MAINSECTION,'backgroundcolor',0)
              else
                MainImage.Background:=clBtnface;
            end;
          //авто цвет
          3:
            begin
              if DirObj.NotEmpty then
              begin
                MainImage.Background:=MainImage.Bitmap.Canvas.Pixels[0,0];
              end else
                MainImage.Background:=clBtnface;
            end;
          //без изменений
          4:MainImage.Background:=clBtnface;
        end;
      end;
      MainImage.Repaint;
    end;
    Result:=true;
  except
    Exit;
  end;
end;

{$ENDREGION}

//обрабатываем командную строку
function FormatCommandLine:TStringList;
var
  pos:integer;
begin
  Result:=TStringList.Create;
  if ParamCount = 0 then
    Exit;
  for pos:=1 to ParamCount do
  begin
    Result.Add(ParamStr(pos));
  end;
end;

function MultiLanguage_GetGroupValue(Group,Key:String):String;
begin
  Result:=GlobalLangData.ReadString(Group,Key,'');
end;

//загружаем данные в
//меню
procedure LoadToPopUpMenu;
begin
  //загружаем язык
  //для всплывающей подсказки
  //при переходе между страницами
  GetPageString:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'currentpage');
  NewPageString:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'togoingpage');
  CountPageString:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'countpvpages');
  with FormMain do
  begin
    Menu_OpenDir.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'opendir');
    Menu_OpenFile.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'openfile');
    Menu_CloseCurrent.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'closefile');
    Menu_CloseAll.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'closeall');

    Menu_Navigate.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'navigate');
    Menu_NextImage.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'navigate_next');
    Menu_PrevImage.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'navigate_prev');
    Menu_StartImage.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'navigate_start');
    Menu_EndImage.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'navigate_end');

    Menu_WinControl.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'window');
    Menu_FullScreen.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'window_fscr');
    Menu_SinglePreview.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'window_deff');
    Menu_Minimize.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'window_min');
    Menu_Navigator.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'window_magn');

    Menu_ImageControl.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'image');
    Menu_Zoom.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'image_zoom');
    Menu_Stretch.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'image_stretch');
    Menu_Original.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'image_original');
    Menu_FitHeight.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'image_height');

    Menu_About.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'image_about');
    Menu_Exit.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'image_exit');

    Menu_ListArchive.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'listarchive');
    Menu_NextArchive.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'navigate_nextarc');
    Menu_PrevArchive.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'navigate_prevarc');
    Menu_StartArchive.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'navigate_startarc');
    Menu_EndArchive.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'navigate_endarc');
    Menu_ArchiveList.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'archivedialog');
    Menu_FileInfo.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'fileinfo');
    Menu_SortFiles.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'sortfiles');
    Menu_FileManaged.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'filemanagers');

    Menu_Flip.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'flip');
    Menu_FlipHorizontal.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'flip_horizontal');
    Menu_FlipVertical.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'flip_vertical');
    Menu_FlipHorizontalAll.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'flip_horizontalall');
    Menu_FlipVerticalAll.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'flip_verticalall');

    Menu_Rotate.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'rotate');
    Menu_Rotate80CW.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'rotate_cw');
    Menu_Rotate80CWAll.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'rotate_cwall');
    Menu_Rotate80CCW.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'rotate_ccw');
    Menu_Rotate80CCWAll.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'rotate_ccwall');

    Menu_SaveToFile.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'savetofile');
    Menu_SaveToBuffer.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'savetoclipboard');

    Menu_OpenCurves.Caption:=MultiLanguage_GetGroupValue('CURVES','opencurves');
    Menu_SaveCurves.Caption:=MultiLanguage_GetGroupValue('CURVES','savecurves');
    Menu_ApplyCurves.Caption:=MultiLanguage_GetGroupValue('CURVES','applycurves');
    Menu_ResetCurves.Caption:=MultiLanguage_GetGroupValue('CURVES','resetcurves');

    Menu_Addbookmark.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'addbookmark');
    Menu_NextBookmark.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'nextbookmark');
    Menu_PrevBookmark.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'prevbookmark');
    Menu_ClearBookmarks.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'clearallbookmark');
    Menu_DirHistory.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'dirhistory');
    Menu_ArcHistory.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'archistory');
    Menu_Bookmarks.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'bookmarks');

    Menu_HistoryDialog.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'historydialog');

    Menu_CreateArchive.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'createarchive');
    Menu_CreateRAR.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'createrar');
    Menu_CreateZip.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'createzip');
    Menu_Create7Zip.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'create7zip');
    Menu_CreatePDF.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'createpdf');
    Menu_CreateTIFF.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'createtiff');
    Menu_CreateGIF.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'creategif');

    Menu_RecreateArchive.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'repackarchive');
    Menu_Recreateandrewrite.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'repackandrewrite');
    Menu_Recreateandsaveas.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'repackandsaveas');

    Menu_CheckUpdates.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'checkupdatesmenu');

    Menu_Addons.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'addonsmenu');
    Menu_AddonsManage.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'addonsmanage');

    Menu_Documentation.Caption:=MultiLanguage_GetGroupValue(CONFIG_MAINSECTION,'documentation');
  end;
end;

function ExecuteFile(FileName, StdInput: string;
  TimeOut: integer;
  var StdOutput: string): boolean;

label
  Error;

type
  TPipeHandles = (IN_WRITE, IN_READ,
    OUT_WRITE, OUT_READ,
    ERR_WRITE, ERR_READ);

type
  TPipeArray = array[TPipeHandles] of THandle;

var
  i: Cardinal;
  ph: TPipeHandles;
  sa: TSecurityAttributes;
  Pipes: TPipeArray;
  StartInf: TStartupInfo;
  ProcInf: TProcessInformation;
  Buf: array[0..1024] of byte;
  TimeStart: TDateTime;

  function ReadOutput: string;
  var
    i: integer;
    s: string;
    BytesRead: Cardinal;
    CurPos:Integer;
  begin
    Result := '';
    repeat

      Buf[0] := 26;
      WriteFile(Pipes[OUT_WRITE], Buf, 1, BytesRead, nil);
      if ReadFile(Pipes[OUT_READ], Buf, 1024, BytesRead, nil) then
      begin
        if BytesRead > 0 then
        begin
          buf[BytesRead] := 0;
          for CurPos:=0 to High(Buf) do
            s:=s+Chr(Buf[CurPos]);
          //s := StrPas(PWideChar(Buf[0]));
          i := Pos(#26, s);
          if i > 0 then
            s := copy(s, 1, i - 1);
          Result := Result + s;
        end;
      end;

      if BytesRead < 1024 then
        break;
    until false;
  end;

begin
  Result := false;
  for ph := Low(TPipeHandles) to High(TPipeHandles) do
    Pipes[ph] := INVALID_HANDLE_VALUE;

  // Создаем пайпы
  sa.nLength := sizeof(sa);
  sa.bInheritHandle := TRUE;
  sa.lpSecurityDescriptor := nil;

  if not CreatePipe(Pipes[IN_READ], Pipes[IN_WRITE], @sa, 0) then
    goto Error;
  if not CreatePipe(Pipes[OUT_READ], Pipes[OUT_WRITE], @sa, 0) then
    goto Error;
  if not CreatePipe(Pipes[ERR_READ], Pipes[ERR_WRITE], @sa, 0) then
    goto Error;

  // Пишем StdIn
  StrPCopy(@Buf[0], stdInput + ^Z);
  WriteFile(Pipes[IN_WRITE], Buf, Length(stdInput), i, nil);

  // Хендл записи в StdIn надо закрыть - иначе выполняемая программа
  // может не прочитать или прочитать не весь StdIn.

  CloseHandle(Pipes[IN_WRITE]);

  Pipes[IN_WRITE] := INVALID_HANDLE_VALUE;

  FillChar(StartInf, sizeof(TStartupInfo), 0);
  StartInf.cb := sizeof(TStartupInfo);
  StartInf.dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;

  StartInf.wShowWindow := SW_HIDE; // SW_HIDE если надо запустить невидимо

  StartInf.hStdInput := Pipes[IN_READ];
  StartInf.hStdOutput := Pipes[OUT_WRITE];
  StartInf.hStdError := Pipes[ERR_WRITE];

  if not CreateProcess(nil, PChar(FileName), nil,
    nil, True, NORMAL_PRIORITY_CLASS,
    nil, nil, StartInf, ProcInf) then
    goto Error;

  TimeStart := Now;

  repeat
    Application.ProcessMessages;
    i := WaitForSingleObject(ProcInf.hProcess, 100);
    if i = WAIT_OBJECT_0 then
      break;
    if (Now - TimeStart) * SecsPerDay > TimeOut then
      break;
  until false;

  if i > WAIT_OBJECT_0 then
    goto Error;
  StdOutput := ReadOutput;

  for ph := Low(TPipeHandles) to High(TPipeHandles) do
    if Pipes[ph] = INVALID_HANDLE_VALUE then
      CloseHandle(Pipes[ph]);

  CloseHandle(ProcInf.hProcess);
  CloseHandle(ProcInf.hThread);
  Result := true;
  Exit;

  Error:

  if ProcInf.hProcess = INVALID_HANDLE_VALUE then
  begin
    CloseHandle(ProcInf.hThread);
    i := WaitForSingleObject(ProcInf.hProcess, 1000);
    CloseHandle(ProcInf.hProcess);
    if i = WAIT_OBJECT_0 then
    begin
      ProcInf.hProcess := OpenProcess(PROCESS_TERMINATE,
        FALSE,
        ProcInf.dwProcessId);
      if ProcInf.hProcess = 0 then
      begin
        TerminateProcess(ProcInf.hProcess, 0);
        CloseHandle(ProcInf.hProcess);
      end;
    end;
  end;

  for ph := Low(TPipeHandles) to High(TPipeHandles) do
    if Pipes[ph] = INVALID_HANDLE_VALUE then
      CloseHandle(Pipes[ph]);
end;

//проверяем новую версию
procedure CheckNewVersion(const DialogNotVersion:Boolean = false);
var
  Output:String;
begin
  ExecuteFile
    (
      PathToProgramDir+'iupdater.exe check ' + PROGRAM_VERSION,
      '',
      4,
      Output
    );
  //это значит что
  //доступна новая версия
  Output:=Copy(Output,0,Length(Output)-2);
  if Output = 'true' then
  begin
    if MessageDlg
      (
        ReadLang('MAIN','newversiontext'),
        mtConfirmation,
        [mbYes,mbNo],
        0
      ) = Integer(mbYes) then
        ExecuteFile
          (
            PathToProgramDir+'iupdater.exe checkandupdate ' + PROGRAM_VERSION,
            '',
            4,
            Output
          );
  end else
  begin
    if DialogNotVersion then
      ShowMessage(ReadLang('MAIN','notcheckupdates'));
  end;
end;


end.
