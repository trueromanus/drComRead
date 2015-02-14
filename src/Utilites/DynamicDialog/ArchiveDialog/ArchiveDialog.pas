{
  drComRead

  Archive Dialog Library

  ������ � ������� ������ 

  Copyright (c) 2008-2009 Romanus
}
unit ArchiveDialog;

interface

uses
  SysUtils, Classes, Controls, Forms,
  StdCtrls, ComCtrls, ArchiveFind, ExtCtrls, Buttons;

type
  TArcForm = class(TForm)
    ArcList: TListBox;
    FilterEdit: TEdit;
    FilterLabel: TLabel;
    ChangeButton: TButton;
    CancelButton: TButton;
    UpDown: TUpDown;
    SortLabel: TLabel;
    CheckBoxNotShowFullPath: TCheckBox;
    CheckBoxCaseSensitive: TCheckBox;
    ButtonPrevFind: TButton;
    ButtonNextFind: TButton;
    PanelBackground1: TPanel;
    PanelBackground2: TPanel;
    SpeedButton_Help: TSpeedButton;
    procedure CancelButtonClick(Sender: TObject);
    procedure ChangeButtonClick(Sender: TObject);
    procedure FilterEditChange(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure UpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure CheckBoxNotShowFullPathClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonPrevFindClick(Sender: TObject);
    procedure ButtonNextFindClick(Sender: TObject);
    procedure SpeedButton_HelpClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FSortFlag:Boolean;
  public
    //������� ������ �������
    MainArcList:TStringList;
    //������� ����������
    property SortFlag:Boolean read FSortFlag write FSortFlag default false;
  end;

var
  ArcForm: TArcForm;
  //������ �� ������ ��������
  ChangeButtonClicked:Boolean = false;
  //����� �������
  ArchiveFind:TArchiveFind;

//������� ��� �����������
function ShowArchiveDialog(Left,Top:Integer):PWideChar;stdcall;
//��������� ������ �
//������ ��������� ���� � �����������
function SortArchivesList(Mode:Byte):Boolean;stdcall;

implementation

uses
  Windows, Dialogs, MainProgramHeader;

{$R *.dfm}

{$REGION '��������� �������'}

procedure LoadToListBox;
var
  GetPos:Integer;
  GetFileName:String;
begin
  ArcForm.ArcList.Clear;
  for GetPos:=0 to ArcForm.MainArcList.Count - 1 do
  begin
    GetFileName:=ArcForm.MainArcList.Strings[GetPos];
    if ArcForm.CheckBoxNotShowFullPath.Checked then
      GetFileName:=ExtractFileName(GetFileName);
    ArcForm.ArcList.Items.Add(GetFileName);
  end;
end;

//���������� ����������
function CompareStringsDesc(const S1, S2: string): Integer;
begin
  if S1 > S2 then result := -1
  else if S1 = S2 then result := 0
  else result := 1;
end;

//���������� ����������
function CompareStringsAsc(const S1, S2: string): Integer;
begin
  if S1 < S2 then result := -1
  else if S1 = S2 then result := 0
  else result := 1;
end;

//���������� ����������
function AscSort(List: TStringList; Index1, Index2: Integer): Integer;
begin
  Result:=CompareStringsAsc(List.Strings[Index1],List.Strings[Index2]);
end;

//���������� ����������
function DescSort(List: TStringList; Index1, Index2: Integer): Integer;
begin
  Result:=CompareStringsDesc(List.Strings[Index1],List.Strings[Index2]);
end;

//���������� ������ �� �����
function AscSortOnlyFile(List: TStringList; Index1, Index2: Integer): Integer;
begin
  Result:=CompareStringsAsc(ExtractFileName(List.Strings[Index1]),ExtractFileName(List.Strings[Index2]));
end;

//���������� ������ �� �����
function DescSortOnlyFile(List: TStringList; Index1, Index2: Integer): Integer;
begin
  Result:=CompareStringsDesc(ExtractFileName(List.Strings[Index1]),ExtractFileName(List.Strings[Index2]));
end;


{$ENDREGION}

{$REGION '����������� �����'}

procedure TArcForm.ButtonNextFindClick(Sender: TObject);
begin
  ArcList.ItemIndex:=ArchiveFind.FindAtPosToEnd(FilterEdit.Text,ArcList.ItemIndex);
end;

procedure TArcForm.ButtonPrevFindClick(Sender: TObject);
begin
  ArcList.ItemIndex:=ArchiveFind.FindAtStartToPos(FilterEdit.Text,ArcList.ItemIndex);
end;

procedure TArcForm.CancelButtonClick(Sender: TObject);
begin
  ChangeButtonClicked:=false;
  ArcList.ItemIndex:=-1;
  ArcForm.SortFlag:=false;
end;

procedure TArcForm.ChangeButtonClick(Sender: TObject);
begin
  if ArcList.ItemIndex = -1 then
    ArcList.ItemIndex:=0;
  ChangeButtonClicked:=true;
  Self.Close;
end;

procedure TArcForm.CheckBoxNotShowFullPathClick(Sender: TObject);
begin
  LoadToListBox;
end;

//���� � ������ �������
function FindTemplateFilter(Filter:String):Integer;
var
  GetPos:Integer;
begin
  for GetPos:=0 to ArcForm.ArcList.Count-1 do
    if Pos(Filter,ArcForm.ArcList.Items[GetPos]) = 1 then
      Exit(GetPos);
  Exit(-1);
end;

procedure TArcForm.FilterEditChange(Sender: TObject);
var
  Index:Integer;
begin
  Index:=FindTemplateFilter(FilterEdit.Text);
  if Index <> -1 then
    ArcList.ItemIndex:=Index
  else
    ArcList.ItemIndex:=-1;
end;

procedure TArcForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not ChangeButtonClicked then
    CancelButtonClick(nil);
end;

procedure TArcForm.FormCreate(Sender: TObject);
begin
  MainArcList:=TStringList.Create;
  ArchiveFind:=TArchiveFind.Create(MainArcList);
  SpeedButton_Help.Glyph.LoadFromFile(GetGifFileDocumentation);
end;

procedure TArcForm.FormDestroy(Sender: TObject);
begin
  ArchiveFind.Free;
  MainArcList.Free;
end;

procedure TArcForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 112 then
    SpeedButton_HelpClick(nil);
end;

procedure TArcForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    //���� ������ ������
    #27:CancelButton.Click;
    //���� ������ ������
    #13:ChangeButton.Click;
    //������
    //#32:UpDownClick(nil,btNext);
    //Backspace
    //#8:UpDownClick(nil,btPrev);
  end;
end;

procedure TArcForm.SpeedButton_HelpClick(Sender: TObject);
begin
  ShowDocumentation(PWideChar('sortfiles'));
end;

procedure TArcForm.UpDownClick(Sender: TObject; Button: TUDBtnType);
var
  GetPos: Integer;
begin
  if CheckBoxNotShowFullPath.Checked then
  begin
    if Button = btNext then
      MainArcList.CustomSort(AscSortOnlyFile)
    else
      MainArcList.CustomSort(DescSortOnlyFile);
  end else
  begin
    if Button = btNext then
      MainArcList.CustomSort(AscSort)
    else
      MainArcList.CustomSort(DescSort);
  end;
  ArcList.Clear;
  if CheckBoxNotShowFullPath.Checked then
    for GetPos:=0 to MainArcList.Count-1 do
      ArcList.Items.Add(ExtractFileName(MainArcList.Strings[GetPos]))
  else
    ArcList.Items.AddStrings(MainArcList);
  SortFlag:=true;
end;

{$ENDREGION}

{$REGION '������� ��� ������� �������������'}

//��������� ��������������
//������
function LoadMultiLanguageData:Boolean;
const
  //��� ������
  NameOfGroup : PWideChar = 'sortandarcdialog';
begin
  try
    ArcForm.Caption:=MultiLanguage_GetGroupValue(NameOfGroup,PWideChar('arc_title'));
    with ArcForm do
    begin
      FilterLabel.Caption:=MultiLanguage_GetGroupValue(NameOfGroup,PWideChar('filter'));
      ChangeButton.Caption:=MultiLanguage_GetGroupValue(NameOfGroup,PWideChar('change'));
      SortLabel.Caption:=MultiLanguage_GetGroupValue(NameOfGroup,PWideChar('sortarc'));
      CancelButton.Caption:=MultiLanguage_GetGroupValue(NameOfGroup,PWideChar('cancel'));
      CheckBoxNotShowFullPath.Caption:=MultiLanguage_GetGroupValue(NameOfGroup,PWideChar('show_path_files'));
      CheckBoxCaseSensitive.Caption:=MultiLanguage_GetGroupValue(NameOfGroup,PWideChar('casesensitive'));
    end;
    Result:=true;
  except
    Result:=false;
  end;
end;

//��������� ������
procedure LoadArchivesName;
var
  GetPos:Integer;
  Str:String;
begin
  for GetPos:=0 to GetArchivesCount-1 do
  begin
    Str:=WideCharToString(GetArchiv(GetPos));
    ArcForm.MainArcList.Add(Str);
  end;
  LoadToListBox;
end;

function ShowArchiveDialog(Left,Top:Integer):PWideChar;
var
  WStr:WideString;
  GetPos:Integer;
begin
  Result:='';
  InitLinks;
  CursorsLoading;
  //���� ��� �����������
  //������� �� ������ ��
  //������
  if GetArchivesCount = 0 then
    Exit;
  //������� �����
  ArcForm:=TArcForm.Create(nil);
  //�������������� ������
  //������ � �����
  if not LoadMultiLanguageData then
    Exit;
  ArcForm.Left:=Left;
  ArcForm.Top:=Top;
  ArcForm.ArcList.ItemIndex:=-1;
  //������ ������ �� �������
  LoadArchivesName;
  //������������� ������� �������
  //� ������ �������
  ArcForm.ArcList.ItemIndex:=GetArchivPosition;
  //���������� ������
  ArcForm.ShowModal;
  //������� ������ ����
  //�� ����������� �
  //������ �� �������
  if (ArcForm.ArcList.ItemIndex = -1) and
     not ArcForm.SortFlag then
  begin
    ArcForm.Free;
    Exit;
  end;
  //���� �����������
  //�� ��������� ����� ����������
  with ArcForm do
  begin
    if SortFlag then
      for GetPos:=0 to ArcList.Count-1 do
        SetNameArchiv(GetPos,PWideChar(MainArcList.Strings[GetPos]));
  end;
  //���� �� ������� �����
  //������
  if ArcForm.ArcList.ItemIndex = -1 then
    WStr:=ArcForm.MainArcList.Strings[0]
  else
    //���� ���������
    WStr:=ArcForm.MainArcList.Strings[ArcForm.ArcList.ItemIndex];
  Result:=PWideChar(WStr);
  ArcForm.Free;
end;

//��������� ������ �
//������ ��������� ���� � �����������
function SortArchivesList(Mode:Byte):Boolean;stdcall;
var
  ListArchive:TStringList;
  GetPos: Integer;
  GetStr:String;
  GetParam:String;
begin
  InitLinks;
  if (Mode = 0) or (GetArchivesCount = 0) then
    Exit(false);
  ListArchive:=TStringList.Create;
  GetParam:=MultiLanguage_GetConfigValue(System.PWideChar('sort_archivesensitive'));
  if GetParam = '-1' then
  begin
    //�������� ������
    for GetPos:=0 to GetArchivesCount-1 do
    begin
      GetStr:=GetArchiv(GetPos);
      ListArchive.Add(LowerCase(GetStr));
    end;
  end else
  begin
    //�������� ������
    for GetPos:=0 to GetArchivesCount-1 do
      ListArchive.Add(GetArchiv(GetPos));
  end;
  //���� �� ������ ����
  //�� �������� ���� � �����
  if (Mode = 3) or (Mode = 4) then
    for GetPos:=0 to GetArchivesCount-1 do
      ListArchive.Strings[GetPos]:=ExtractFileName(ListArchive.Strings[GetPos]);
  //����������
  if (Mode = 1) or (Mode = 3) then
    ListArchive.CustomSort(AscSort);
  //����������
  if (Mode = 2) or (Mode = 4) then
    ListArchive.CustomSort(DescSort);
  for GetPos:=0 to ListArchive.Count-1 do
    SetNameArchiv(GetPos,PWideChar(ListArchive.Strings[GetPos]));
  Result:=true;
end;

{$ENDREGION}

end.
