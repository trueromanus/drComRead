program drComReadTests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  ExceptionLog,
  Forms,
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  CRInetTests in 'CRInetTests.pas',
  CRDialogPanel in '..\CRDialogPanel.pas',
  CRDialogPanelTests in 'CRDialogPanelTests.pas',
  CRGlobal in '..\CRGlobal.pas',
  CRImageVisual in '..\CRImageVisual.pas',
  NWS_IEUtils in '..\ComLibs\NWS_IEUtils.pas',
  RGBCurvesdiagrammer in '..\ComLibs\RGBCurvesdiagrammer.pas',
  RGBCurvesmath in '..\ComLibs\RGBCurvesmath.pas',
  RGBCurvesReg in '..\ComLibs\RGBCurvesReg.pas',
  CRFastActions in '..\CRFastActions.pas',
  ArcCreate in '..\Libs\ArcCreate.pas',
  ArcFunc in '..\Libs\ArcFunc.pas',
  DLLHeaders in '..\Libs\DLLHeaders.pas',
  FuncExports in '..\Libs\FuncExports.pas',
  GIFImage in '..\Libs\GIFImage.pas',
  LALoadAnim in '..\Libs\LALoadAnim.pas',
  RAR in '..\Libs\RAR.pas',
  RAR_DLL in '..\Libs\RAR_DLL.pas',
  sevenzip in '..\Libs\sevenzip.pas',
  CRDir in '..\CRDir.pas',
  MainForm in '..\MainForm.pas' {FormMain},
  ArcReCreate in '..\ArcReCreate.pas',
  RLibString in '..\..\Romanus-Library\RLibString.pas',
  CRPlugins in '..\CRPlugins.pas',
  CRFile in '..\CRFile.pas',
  CRImageInfo in '..\CRImageInfo.pas',
  CRInet in '..\CRInet.pas',
  CRMenuHelper in '..\CRMenuHelper.pas';

{$R *.RES}

begin
  Application.Initialize;
  if IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;
end.

