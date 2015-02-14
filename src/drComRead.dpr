{
  drComRead

  Copyright (c) 2008-2012 Romanus
}
program drComRead;

uses
  Forms,
  SysUtils,
  CRGlobal in 'CRGlobal.pas',
  MainForm in 'MainForm.pas',
  CRFile in 'CRFile.pas',
  CRDir in 'CRDir.pas',
  CRImageVisual in 'CRImageVisual.pas',
  DLLHeaders in 'Libs\DLLHeaders.pas',
  FuncExports in 'Libs\FuncExports.pas',
  sevenzip in 'Libs\sevenzip.pas',
  ArcFunc in 'Libs\ArcFunc.pas',
  CRFastActions in 'CRFastActions.pas',
  NWS_IEUtils in 'ComLibs\NWS_IEUtils.pas',
  RGBCurvesdiagrammer in 'ComLibs\RGBCurvesdiagrammer.pas',
  RGBCurvesmath in 'ComLibs\RGBCurvesmath.pas',
  RGBCurvesReg in 'ComLibs\RGBCurvesReg.pas',
  CRPlugins in 'CRPlugins.pas',
  ArcCreate in 'Libs\ArcCreate.pas',
  ArcReCreate in 'ArcReCreate.pas',
  RLibString in '..\Romanus-Library\RLibString.pas',
  CRMenuHelper in 'CRMenuHelper.pas',
  CRInet in 'CRInet.pas',
  CRDialogPanel in 'CRDialogPanel.pas',
  CRLog in 'CRLog.pas',
  ComReadSerialize in 'Addons\OnlineArchiveCreator\ComReadSerialize.pas',
  SQLiteTable3 in 'Utilites\DynamicDialog\History\SQLiteTable3.pas',
  SQLite3 in 'Utilites\DynamicDialog\History\SQLite3.pas',
  SQLiteUtils in 'Utilites\Headers\SQLiteUtils.pas',
  CRDataBase in 'CRDataBase.pas';

{$R *.res}

exports
  GetArchivesCount,
  GetArchiv,
  SetNameArchiv,
  GetArchivPosition,
  GetArchivOpenIndex,
  Navigation_NextImage,
  Navigation_PrevImage,
  Navigation_StartImage,
  Navigation_EndImage,
  Navigation_Position,
  Navigation_NextArc,
  Navigation_PrevArc,
  Navigation_StartArc,
  Navigation_EndArc,
  Navigation_ArcPosition,
  Navigation_NewPosition,
  ListImage_Count,
  ListImage_GetFileName,
  ListImage_SetFileName,
  ListImage_SaveGetToFile,
  ListImage_SaveGetToClipboard,
  ListImage_RotateGetTo80CW,
  ListImage_RotateGetTo80CWAll,
  ListImage_RotateGetTo80CCW,
  ListImage_RotateGetTo80CCWAll,
  ListImage_FlipImage,
  ListImage_FlipImageAll,
  ListImage_OpenArchive,
  TxtFiles_Count,
  TxtFiles_GetFileName,
  TxtFiles_ExtractByName,
  Paths_GetApplicationPath,
  Paths_GetTempPath,
  Program_VersionProg,
  Program_ImageFilter,
  Program_ArchiveFilter,
  Program_ImageMode,
  Program_RunMenuCommand,
  Program_GetArrowCursor,
  Program_GetLoadCursor,
  Scrolling_SetActiveScroll,
  Scrolling_GetActiveScroll,
  Window_FullScreenMode,
  Window_GetWindowPosition,
  Window_ActivatedWindow,
  Window_GetFormHandle,
  GetConfigHandle,
  MultiLanguage_GetGroupValue,
  MultiLanguage_GetConfigValue,
  MultiLanguage_SetConfigValue,
  ExtractImageWithIndex,
  ExtractImageWithName,
  ShowDocumentation,
  GetGifFileDocumentation,
  PrintToProgramLog,
  PrintErrorToProgramLog;

begin
  //путь к программе
  PathToProgramDir:=ExtractFilePath(Application.ExeName);
  InitDataBaseAtProgram;
  if EnableTrace then
    LogProgram:=TCRLog.Create(lmNone);
  PrintSystemToLog('drComRead version ' + PROGRAM_VERSION + ' started');
  //основной цикл приложения
  Application.Initialize;
  Application.Title := 'drComRead';
  Application.CreateForm(TFormMain, FormMain);
  //инициализируем диалог
  //навигатора
  InitNavigatorDialog(nil);
  Application.Run;
  ActiveScroll.Free;
  DirObj.Free;
  MainCurves.Free;
  if Assigned(ImageResizer) then
    FreeAndNil(ImageResizer);
  //бахаем лог
  LogProgram.Free;
  DeinitDataBaseAtProgram;
end.
