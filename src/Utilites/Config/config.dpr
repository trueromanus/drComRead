{
  drComRead
  Config Library

  Copyright (c) 2008-2012 Romanus
}
library config;

uses
  ConfigGlobal in 'ConfigGlobal.pas',
  ConfigSynchronized in 'ConfigSynchronized.pas',
  MainProgramHeader in '..\Headers\MainProgramHeader.pas',
  ConfigNextGen in 'ConfigNextGen.pas' {FormConfig},
  Main.ScaleMode in 'Main.ScaleMode.pas' {ScaleMode: TFrame},
  Main.Background in 'Main.Background.pas' {MainBackground: TFrame},
  Main.ActiveScroll in 'Main.ActiveScroll.pas' {MainActiveScroll: TFrame},
  Main.WindowAndLanguage in 'Main.WindowAndLanguage.pas' {MainWindowAndLanguage: TFrame},
  Main.TwoPage in 'Main.TwoPage.pas' {MainTwopage: TFrame},
  Main.Navigate in 'Main.Navigate.pas' {MainNavigate: TFrame},
  Archives.Main in 'Archives.Main.pas' {FrameArchiveMain: TFrame},
  Archives.Sort in 'Archives.Sort.pas' {FrameArchiveSort: TFrame},
  History.Bookmarks in 'History.Bookmarks.pas' {HistoryBookmark: TFrame},
  ColorCorrectMain in 'ColorCorrectMain.pas' {FrameColorCorrectMain: TFrame},
  History.History in 'History.History.pas' {FrameHistory: TFrame};

{$R *.res}

exports
  ShowConfigFormDialog;

begin
end.
