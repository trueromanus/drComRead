program configTests;
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
  Forms,
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  ConfigSynchronized in '..\ConfigSynchronized.pas',
  ConfigNextGen in '..\ConfigNextGen.pas' {FormConfig},
  ConfgiNextGenTests in 'ConfgiNextGenTests.pas',
  ConfigAPI in '..\ConfigAPI.pas',
  Main.Background in '..\Main.Background.pas',
  Main.ScaleMode in '..\Main.ScaleMode.pas';

{$R *.RES}

begin
  Application.Initialize;
  if IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;
end.

