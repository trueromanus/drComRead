{
  drComRead

  ������ ��� ����������
  ������������ �������

  Copyright (c) 2008-2009 Romanus
}
unit DLLHeaders;

interface

uses
  CRGlobal, Classes, Controls, ComReadSerialize;

type
  //������ ��������
  TALIntArray = array of integer;
  //��� ��� ����������� ����������
  //�������� ������
  TIndexHistoryArray = array of Integer;
  //������ �����
  TWideCharHistoryArray = array of PWideChar;

  //��������� �������
  TResultDialog = record
    //���� ��������� �����������
    Complete:Boolean;
    //��� ������������ �����
    TypeDate:Byte;
    //��� �����
    NameFile:PWideChar;
    //������������� ������
    IDRecord:Integer;
  end;

const
  NameSortFilesLibrary      =       'dialogs\sortfiles.dll';
  NameArcSortFilesLibrary   =       'dialogs\arcdialog.dll';
  NameHistoryLibrary        =       'dialogs\history.dll';
  NamePreviewLibrary        =       'dialogs\previewpage.dll';
  NameDocumentationLibrary  =       'crod\crod.dll';
  NameOnlineArcLibrary      =       'onlinearc.dll';

{$REGION '�������� � ���������'}

//������ ������ �������
function ShowArchiveDialog(Left,Top:Integer):PWideChar;stdcall;
external 'dialogs\arcdialog.dll';
function SortArchivesList(Mode:Byte):Boolean;stdcall;
external 'dialogs\arcdialog.dll';
//������ � ���������
procedure ShowAboutDialog(Left,Top:integer;Version:PChar);stdcall;
external 'dialogs\information.dll';
//������ ������������ ���������
function ShowConfigDialog(fname:PWideChar):boolean;stdcall;
external 'dialogs\config.dll';
function ShowConfigFormDialog(fname:PWideChar):boolean;stdcall;
external 'dialogs\config.dll';
//������ � ����������� � ������/�������
function ShowReadForm(Path:PWideChar;Mode:Byte):Boolean;stdcall;
external 'dialogs\readinfo.dll';
//���������� ������ ��������
//���������
function ShowDirDialog(Left,Top:Integer):PWideChar;stdcall;
external 'dialogs\opendir.dll';
//���������� ������ ����������
function ShowSortFilesDialog(Left,Top:Integer):Boolean;stdcall;
external 'dialogs\sortfiles.dll';

//���������� ������ ��������
//���� �������������
function ShowPrevOneDialog(Position:Integer):Integer;stdcall;
external NamePreviewLibrary;
//������������� �����������
function LoadImagesCollection:Boolean;stdcall;
external NamePreviewLibrary;
//��������������� �����������
function ClearBitmapList:Boolean;stdcall;
external NamePreviewLibrary;
//����������� �� ������ ��� ���
function BitmapListIsLoading:Boolean;stdcall;
external NamePreviewLibrary;

//�������������� �������� ���� ����������
function CloseNavigatorWindow:Boolean;stdcall;
external 'dialogs\navigator.dll';
//���������� ������ ����������
function ShowNavigatorDialog:Boolean;stdcall;
external 'dialogs\navigator.dll';
//�������������� ������
function InitNavigatorDialog(Control:Pointer):Boolean;stdcall;
external 'dialogs\navigator.dll';

//��������� ������
function OpenArchiveDialog():Boolean;stdcall;
external 'dialogs\openfiledialog.dll';
//���������� ����������� ������
function OpenDialogFilesCount():Integer;stdcall;
external 'dialogs\openfiledialog.dll';
//�������� ���� � ������������ �����
function OpenDialogFilesName(Index:Integer):PWideChar;stdcall;
external 'dialogs\openfiledialog.dll';

//�������� ��� �������
//���� ���� ������ �
//����������� � ��� ������
function InitDataBase:Boolean;stdcall;
external NameHistoryLibrary;
//���� ��������
//��� �������� ������
//���� ������� ����������
//������ ��� ����� �����������
//�� ������
function FindBookmarkArchive(Name:PWideChar;FullPathMode:Boolean):PWideChar;stdcall;
external NameHistoryLibrary;
//���� ��� ��������
//��� �������� ������
//� ���������� ��
//� ���� ������� �� ��������
function FindAllBookmarkArchive(Name:PWideChar;FullPathMode:Boolean):TWideCharHistoryArray;stdcall;
external NameHistoryLibrary;
//��������� �������� ��
//����� � ������� ����
//��� ��� ����������
//�������������� ������
function AddBookmarkArchive(Name,NamePage:PWideChar):Boolean;stdcall;
external NameHistoryLibrary;
//������� �������� �� �����
//�� ������� ����� ��� ������ ����� �����
function DeleteBookmarkArchive(Name:PWideChar;FullPathMode:Boolean):Boolean;stdcall;
external NameHistoryLibrary;
//������� �������� �� �����
//�� ������� ���� � ����� ��������
function DeleteBookmarkArchivePage(Name:PWideChar;NamePage:PWideChar):Boolean;stdcall;
external NameHistoryLibrary;
//���������� ���������
//����������� �����
function FindHistoryDirLast(CountRes:Integer):TIndexHistoryArray;stdcall;
external NameHistoryLibrary;
//���� �� �������
function FindHistoryDirIndex(Index:Integer):PWideChar;stdcall;
external NameHistoryLibrary;
//��������� � �������
//�����
function AddHistoryDir(Dir:PWideChar):Boolean;stdcall;
external NameHistoryLibrary;

//���� ��������� ������ � �������
function FindHistoryArcLast(CountRes:Integer):TIndexHistoryArray;stdcall;
external NameHistoryLibrary;
//���������� �� �������
function FindHistoryArcIndex(Index:Integer):PWideChar;stdcall;
external NameHistoryLibrary;
//��������� ����� �
//�������
function AddHistoryArc(Dir:PWideChar):Boolean;stdcall;
external NameHistoryLibrary;

//���������� ������ �������
function ShowDialogHistory:TResultDialog;stdcall;
external NameHistoryLibrary;

//���������� ������ �������
function ShowDocumentationDialog(language,version,defaultpage:PWideChar):Boolean;stdcall;
external NameDocumentationLibrary;

{$ENDREGION}

{$REGION '���������� ������'}

//������� ������� ����������
function SortFilesMainFunc(Mode:Byte):Boolean;stdcall;
external NameSortFilesLibrary;
//��������� ������� ����������
function SortingFilesAtList(Mode:Byte;Strings:TStringList):Boolean;stdcall;
external NameSortFilesLibrary;

//�������� ����������
function SortFilesContext(Control:TWinControl):Boolean;
external NameSortFilesLibrary;

{$ENDREGION}

{$REGION '������ comread'}

//���������� ���� ������� comread
function ParseDataComReadAtFile(FileName:PWideChar):TCRComicsData;stdcall;
external NameOnlineArcLibrary;

{$ENDREGION}

implementation

end.
