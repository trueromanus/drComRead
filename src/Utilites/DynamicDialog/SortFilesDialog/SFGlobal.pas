{
  drComRead

  Sorting Library

  ������ � ���������
  ���������� ��������
  � ����������

  Copyright (c) 2008-2009 Romanus
}
unit SFGlobal;

interface

uses
  Classes;

var
  //������ ��� ��������
  //������ �� ������
  FilesCollection:TStringList;

implementation

initialization

  FilesCollection:=TStringList.Create;

finalization

  FilesCollection.Free;

end.
