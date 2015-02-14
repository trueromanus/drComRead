{
  drComRead

  ConfigNextGen

  Тестовый модуль
  новой версии диалога конфигурации

  Copyright (c) 2011
}
unit ConfgiNextGenTests;

interface

uses
  TestFrameWork;

type
  TConfigTest = class(TTestCase)
  published
    procedure InitDialog;
    procedure TestSubSystems;
    procedure TestDeInit;
  end;


implementation

uses
  Forms, ConfigNextGen,ConfigSynchronized;

procedure TConfigTest.InitDialog;
begin
  try
    InitConfigList;
  except
    CheckTrue(false,'Not create at ConfigList');
  end;
  try
    FormConfig:=TFormConfig.Create(nil);
  except
    CheckTrue(false,'Not create at TFormConfig object class');
  end;
end;

procedure TConfigTest.TestSubSystems;
begin
  Application.Initialize;
  Application.Title := 'drComRead';
  Application.CreateForm(TFormConfig, FormConfig);
  Application.Run;
end;

procedure TConfigTest.TestDeInit;
begin
  try
    DeInitConfigList;
  except
    CheckTrue(false,'Not deinit ConfigList');
  end;
  try
    FormConfig.Free;
  except
    CheckTrue(false,'Not free FormConfig');
  end;
end;

initialization
 TestFramework.RegisterTest(TConfigTest.Suite);

end.
