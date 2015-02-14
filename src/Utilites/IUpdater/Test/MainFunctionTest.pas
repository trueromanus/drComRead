{
  IUpdater

  Юнит тесты основных
  функций программы

  Copyright (c) 2011 Romanus
}
unit MainFunctionTest;

interface

uses
  TestFrameWork, UpdaterUtils;

type
  TMainFunction = class(TTestCase)
  {protected
    //иниицализация
    procedure SetUp; override;
    //деинициализация
    procedure TearDown; override;}
  published
    //конвертация строки в версию
    procedure TestConvertStringToVersion;
    //обнуление версий
    procedure TestVersionsEmpty;
    //сравнение версий
    procedure TestCompareVersion;
    //скачивание файла
    procedure TestDownloadFile;
    //скачивание html
    procedure TestDownloadHtml;
  end;

implementation

uses
  SysUtils, Classes,
  Generics.Collections;

//конвертация строки в версию
procedure TMainFunction.TestConvertStringToVersion;
var
  List:TList<Integer>;
begin
  List:=ConvertStringToVersion('1.14.2.1.5');
  Check(List[0] = 1,'ConvertToString error in index 0');
  Check(List[1] = 14,'ConvertToString error in index 1');
  Check(List[2] = 2,'ConvertToString error in index 2');
  Check(List[3] = 1,'ConvertToString error in index 3');
  Check(List[4] = 5,'ConvertToString error in index 4');
end;

//обнуление версий
procedure TMainFunction.TestVersionsEmpty;
var
  List:TList<Integer>;
begin
  List:=ConvertStringToVersion('1.14.2.1.5');
  VersionsEmpty(List,6);
  Check(List.Count = 6,'VersionsEmpty error count added');
  Check(List[5] = 0,'VersionsEmpty error last element not in zero');
end;

//сравнение версий
procedure TMainFunction.TestCompareVersion;
begin
  CheckTrue
    (
      CompareVersions
          (
            ConvertStringToVersion('1.14.2.1.5'),
            ConvertStringToVersion('1.14.3.1.5')
          )
      ,'Version not in high latest version'
    );
  CheckFalse
    (
      CompareVersions
          (
            ConvertStringToVersion('1.14.2.1.5'),
            ConvertStringToVersion('1.14.2.1.5')
          )
      ,'Version not in equal versions'
    );
  CheckFalse
    (
      CompareVersions
          (
            ConvertStringToVersion('1.14.3.1.5'),
            ConvertStringToVersion('1.14.2.1.5')
          )
      ,'Version not in low version'
    );
end;

//скачивание файла
procedure TMainFunction.TestDownloadFile;
var
  Stream:TFileStream;
  Flag:Boolean;
begin
  Flag:=false;
  DownloadFile
    (
      'http://drcomread.atticfloor.ru/application/maxsite/templates/clouds/images/header.jpg',
      'c:\test\header.jpg'
    );
  Check(FileExists('c:\test\header.jpg'),'Download file failed');
  try
    Stream:=TFileStream.Create('c:\test\header.jpg',fmOpenRead);
    Check(Stream.Size > 0,'Download file is zero size');
    Stream.Free;
    Flag:=true;
  except
    Flag:=false;
  end;
  CheckTrue(Flag,'Download file incorrect read file');
end;

//скачивание html
procedure TMainFunction.TestDownloadHtml;
var
  Strings:TStringList;
begin
  Strings:=DownloadHtml('http://drcomread.atticfloor.ru/');
  Check(Strings.Count > 0,'Download html failed');
  Strings.Free;
end;

initialization
 TestFramework.RegisterTest(TMainFunction.Suite);

end.
