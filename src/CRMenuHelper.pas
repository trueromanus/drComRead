{
  drComRead

  ������ ��������
  ��� ��������� ����

  Copyright (c) 2009-2011 Romanus
}
unit CRMenuHelper;

interface

uses
  Menus,
  Generics.Collections;

type
  TCRMenuHelperEvent = function:Boolean;

  //������ ������ ��������
  //��������� ����
  TCRMenuHelperRecord = record
    Menu:TMenuItem;
    Event:TCRMenuHelperEvent;
  end;

var
  MenuHelper:TList<TCRMenuHelperRecord>;

//�������������� ��������� ����
procedure InitMenuHelpers;
//���������������� ����������
procedure DeInitMenuHelpers;
//��������� ������� ����������
//����
procedure UpdateMenu;

implementation

uses
  CRGlobal,
  MainForm;

function MenuHelperRecord(MenuItem:TMenuItem;EventFunc:TCRMenuHelperEvent):TCRMenuHelperRecord;
begin
  Result.Menu:=MenuItem;
  Result.Event:=EventFunc;
end;

//������ �� �����
function IsArchiveOpened:Boolean;
begin
  Result:=DirObj.ArchiveOpened;
end;

//������ �� �����
function IsImagesNotEmpty:Boolean;
begin
  Result:=DirObj.NotEmpty;
end;

//������ �� �����
function IsManyArchives:Boolean;
begin
  Result:=(DirObj.Archives.Count > 1);
end;

//��� ���������� ������
function IsArchiveNext:Boolean;
begin
  Result:=IsManyArchives and (DirObj.ArchivesPos < (DirObj.Archives.Count-1));
end;

//��� ����������� ������
function IsArchivePrev:Boolean;
begin
  Result:=IsManyArchives and (DirObj.ArchivesPos > 0);
end;

//��� ������� ������
function IsArchiveFirst:Boolean;
begin
  Result:=IsManyArchives and (DirObj.ArchivesPos <> 0);
end;

//��� ���������� ������
function IsArchiveLast:Boolean;
begin
  Result:=IsManyArchives and (DirObj.ArchivesPos <> (DirObj.Archives.Count-1));
end;

//������ �� �����
function IsTxtFilesExist:Boolean;
begin
  Result:=(DirObj.TxtFiles.Count > 0);
end;

//����� �� ������� �����
function IsCreateArchive:Boolean;
begin
  Result:=(DirObj.NotEmpty and not DirObj.ArchiveOpened);
end;

//�������������� ��������� ����
procedure InitMenuHelpers;
begin
  MenuHelper:=TList<TCRMenuHelperRecord>.Create;
  //��������� �� ������ �����������
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_NextImage,IsImagesNotEmpty));
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_PrevImage,IsImagesNotEmpty));
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_StartImage,IsImagesNotEmpty));
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_EndImage,IsImagesNotEmpty));

  //������ � �������������
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_ImageControl,IsImagesNotEmpty));

  //��������
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_Bookmarks,IsArchiveOpened));

  //������� ���������� ��������
  //�������
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_ArchiveList,IsManyArchives));
  //�����������
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_SortFiles,IsImagesNotEmpty));
  //��������� ������
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_FileInfo,IsTxtFilesExist));

  //�������� �������
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_CreateArchive,IsCreateArchive));
  //����������� �������
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_RecreateArchive,IsArchiveOpened));

  //��������� �� ������ �������
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_NextArchive,IsArchiveNext));
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_PrevArchive,IsArchivePrev));
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_StartArchive,IsArchiveFirst));
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_EndArchive,IsArchiveLast));

  //��������� �����������
  MenuHelper.Add(MenuHelperRecord(FormMain.Menu_SinglePreview,IsImagesNotEmpty));
end;

//���������������� ����������
procedure DeInitMenuHelpers;
begin
  MenuHelper.Free;
end;

//��������� ������� ����������
//����
procedure UpdateMenu;
var
  HelperRecord:TCRMenuHelperRecord;
begin
  for HelperRecord in MenuHelper do
    HelperRecord.Menu.Enabled:=HelperRecord.Event;
end;

end.
