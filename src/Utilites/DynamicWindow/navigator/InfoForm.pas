{
  drComRead

  Navigator Window

  ћодуль с окном
  вывода имени файла

  Copyright (c) 2009-2012 Romanus
}
unit InfoForm;

interface

uses
  Classes, Controls, Forms, StdCtrls, ExtCtrls, ScreenTips, Graphics;

type
  TInfoListForm = class(TForm)
    PanelNameFile: TPanel;
    ScreenTipsManager: TScreenTipsManager;
    ScreenTipsPopup: TScreenTipsPopup;
    procedure PanelNameFileClick(Sender: TObject);
    procedure PanelNameFileMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  InfoListForm: TInfoListForm;

implementation

uses
  NRMainForm, MainProgramHeader;

{$R *.dfm}

procedure TInfoListForm.FormCreate(Sender: TObject);
var
  Str:WideString;
begin
  Str:=WideString(MultiLanguage_GetGroupValue('navigator','listpaneltooltip'));
  with Self.ScreenTipsPopup.ScreenTip do
  begin
    Header:=copy(Str,0,Pos(';',Str)-1);
    Description.Clear;
    Description.Add(copy(Str,Pos(';',Str)+1,Length(Str)));
  end;
end;

procedure TInfoListForm.PanelNameFileClick(Sender: TObject);
begin
  if PanelNameFile.Caption = '' then
    Exit;
  case CRNavigator.TypeListComboBox.ItemIndex of
    //список изображений
    0:Navigation_NewPosition(CRNavigator.ListElementsTrackBar.Position-1);
    //список архивов
    1:GetArchivOpenIndex(CRNavigator.ListElementsTrackBar.Position-1);
  end;
end;

procedure TInfoListForm.PanelNameFileMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbMiddle then
  begin
    Self.Close;
    CRNavigator.Close;
  end;
end;

end.
