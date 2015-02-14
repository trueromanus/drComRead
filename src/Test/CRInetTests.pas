{
  drComRead

  Тесты работы с интернетом

  Copyright (c) 2012 Romanus
}
unit CRInetTests;

interface

uses
  TestFrameWork, CRInet;

type
  TInetTest = class(TTestCase)
  published
    procedure HttpTests;
  end;


implementation

uses
  SysUtils, Classes;

procedure TInetTest.HttpTests;
var
  HttpObject:TCRHttpInet;
  HttpObjectFile:TCRHttpInet;
  HeadPageData:String;
  Bytes:TBytes;
  Encoding:TEncoding;
  Stream:TMemoryStream;
begin
  HttpObject:=TCRHttpInet.Create('http://atticfloor.ru/index.php');
  try
    HeadPageData:=HttpObject.GetData;
  except
    CheckTrue(false,'TCRHttpInet.GetData error data receive');
  end;
  CheckTrue(HeadPageData <> '','TCRHttpInet.GetData is error');
  HttpObjectFile:=TCRHttpInet.Create('http://drcomread.atticfloor.ru/uploads/progscreens/drcomreadlink.gif');
  Stream:=TMemoryStream(HttpObjectFile.GetFile);
  Stream.SaveToFile('c:\test.gif');
  Stream.Free;
end;

initialization
 TestFramework.RegisterTest(TInetTest.Suite);

end.
