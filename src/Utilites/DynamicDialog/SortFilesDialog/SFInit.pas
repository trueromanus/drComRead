{
  drComRead

  Sorting Library

  ������ �������������
  ����������

  Copyright (c) 2008-2009 Romanus
}
unit SFInit;

interface

type
  PSFFileList = ^TSFFileList;
  TSFFileList = array of string;

//������� �������������
//������ ������
function InitListFiles(FileList:PSFFileList;Count:Integer):Boolean;

implementation

uses
  Classes,
  SFGlobal;

//������� �������������
//������ ������
function InitListFiles(FileList:PSFFileList;Count:Integer):Boolean;
var
  GetPos:Integer;
begin
  Result:=false;
  if FileList = nil then
    Exit;
  //setlength(FilesCollection,Count);
  //for GetPos:=0 to Count do
    //FilesCollection[GetPos]:=TSFFileList(FileList)[GetPos];
end;

end.
