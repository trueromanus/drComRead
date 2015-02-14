{
  drComRead

  “есты работы с диалогом
  диалогов ;)

  Copyright (c) 2012 Romanus
}
unit CRDialogPanelTests;

interface

uses
  TestFrameWork, CRDialogPanel, Forms;

type
  TDPanelTest = class(TTestCase)
  published
    procedure VisualTests;
  end;


implementation

uses
  CRGlobal, SysUtils, CRDir;

procedure TDPanelTest.VisualTests;
var
  Panel:TCRDialogsPanel;
  TestForm:TForm;
begin
  //инициализируем
  //только нужны глобальные объекты
  PathToProgramDir:=ExtractFilePath(ParamStr(0));
  //создаем тестовую форму
  TestForm:=TForm.Create(nil);
  TestForm.Width:=500;
  TestForm.Height:=500;
  TestForm.Caption:='Test form';
  Panel:=TCRDialogsPanel.Create(TestForm,nil);
  Panel.ShowOnlyControls;
  //отображаем форму
  TestForm.ShowModal;
  //чистим за собой
  //FreeAndNil(Panel);
  FreeAndNil(TestForm);
  FreeAndNil(Panel);
end;

initialization
 TestFramework.RegisterTest(TDPanelTest.Suite);

end.
