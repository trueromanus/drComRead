program readinfotest;

uses
  SysUtils,
  Forms,
  ReadForm in 'ReadForm.pas',
  RFGlobal in 'RFGlobal.pas',
  RFMainClass in 'RFMainClass.pas',
  RLibStrings in '..\..\..\..\RLib\Strings\RLibStrings.pas',
  LangLibHeader in '..\..\Headers\LangLibHeader.pas',
  RLibDynArrayObj in '..\..\..\..\RLib\Arrays\RLibDynArrayObj.pas',
  LMHeader in '..\..\Headers\LMHeader.pas';

begin
  ReadInfo:=TRFReadInfo.Create;
  //грузим данные
  if not CreateFiles('C:\Романус\',0) then
    Exit;
  Application.Initialize;
  Application.CreateForm(TForm_Info,Form_Info);
  //загружаем данные в комбо
  LoadToCombo;
  //загружаем первый файл
  LoadFileToMemo(0);
  Application.Run;
  ReadInfo.Free;  
end.
