{
  drComRead

  Модуль с диалогом
  О Программе

  Copyright (c) 2009-2011 Romanus
}
unit AboutForm;

interface

uses
  Classes, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Graphics;

type
  TAboutDialog = class(TForm)
    Image_Logo: TImage;
    Label_Name: TLabel;
    Label_Copyright: TLabel;
    Label_Programmer: TLabel;
    Label_Tester: TLabel;
    Label_UsedComponent: TLabel;
    Button_Close: TButton;
    Label_LinkPortal: TLabel;
    Label_SupportMail: TLabel;
    ContributorsThirtyPartComponents: TMemo;
    Panel1: TPanel;
    procedure Label_SupportMailClick(Sender: TObject);
    procedure Label_LinkPortalClick(Sender: TObject);
  private
  public
  end;

var
  AboutDialog: TAboutDialog;

//отображаем диалог
procedure ShowAboutDialog(Left,Top:integer;Version:PChar);stdcall;

implementation

uses
  SysUtils, ShellApi, MainProgramHeader;

{$R *.dfm}

//отображаем диалог
procedure ShowAboutDialog(Left,Top:integer;Version:PChar);stdcall;
begin
  InitLinks;
  CursorsLoading;
  AboutDialog:=TAboutDialog.Create(nil);
  AboutDialog.Label_Name.Caption:=AboutDialog.Label_Name.Caption+' version '+ Version;
  AboutDialog.Left:=Left;
  AboutDialog.Top:=Top;
  AboutDialog.ShowModal;
  AboutDialog.Free;
end;

procedure TAboutDialog.Label_LinkPortalClick(Sender: TObject);
begin
  ShellExecute
              (
                Self.Handle,
                PChar('open'),
                PChar(Label_LinkPortal.Caption),
                nil,
                nil,
                0
              );
end;

procedure TAboutDialog.Label_SupportMailClick(Sender: TObject);
begin
  ShellExecute
              (
                Self.Handle,
                PChar('open'),
                PChar('mailto:'+Label_SupportMail.Caption),
                nil,
                nil,
                0
              );
end;

end.
