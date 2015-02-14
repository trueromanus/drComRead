{
  drComRead

  ������ � ������
  ��������� ����������

  Copyright (c) 2008-2011 Romanus
}
unit ReadForm;

interface

uses
  Classes, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons;

type
  TForm_Info = class(TForm)
    Combo_List: TComboBox;
    Button_Close: TButton;
    ChangeColorBox: TColorBox;
    FontDialogButton: TButton;
    Memo_Text: TRichEdit;
    SpeedButton_Help: TSpeedButton;
    procedure Combo_ListChange(Sender: TObject);
    procedure ChangeColorBoxChange(Sender: TObject);
    procedure FontDialogButtonClick(Sender: TObject);
    procedure Button_CloseClick(Sender: TObject);
    procedure SpeedButton_HelpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  public
    //������ ������������ �����
    LoadIndex:integer;
    //��������� ���������
    procedure LoadSettings;
  end;

var
  Form_Info: TForm_Info;
  //������ �� �������� ����
  LangHandle:Integer;

//��������� �������� ������
function LoadLangData:boolean;
//��������� ������ � �����
procedure LoadToCombo;
//��������� ����
procedure LoadFileToMemo(Index:integer);
//�������������� ��������
//���������
function CreateFiles(Path:PWideChar;Mode:Byte):Boolean;
//���������� ������ � �����������
function ShowReadForm(Path:PWideChar;Mode:Byte):boolean;stdcall;

implementation

uses
  Windows, SysUtils, RFGlobal,
  RFMainClass, MainProgramHeader;

{$R *.dfm}

//��������� �������� ������
function LoadLangData:boolean;
var
  NameGroup:String;
begin
  Result:=false;
  NameGroup:='readinfodialog';
  //��������� ����
  Form_Info.Caption:=MultiLanguage_GetGroupValue(PWideChar(NameGroup),'name_dialog');
  //������ �������
  Form_Info.Button_Close.Caption:=MultiLanguage_GetGroupValue(PWideChar(NameGroup),'button_close');
end;

procedure SetConfValue(KeyName,Value:String);
begin
  MultiLanguage_SetConfigValue(PWideChar(KeyName),PWideChar(Value));
end;

function GetConfValue(KeyName:String):String;
begin
  Result:=WideString(MultiLanguage_GetConfigValue(PWideChar(KeyName)));
end;

{$REGION '�������� �� �������'}

//��������� ������ � �����
procedure LoadToCombo;
var
  GetPos:integer;
  getstr:string;
begin
  //������� ������
  Form_Info.Combo_List.Items.Clear;
  //��������� � ���� ������
  for getpos:=0 to ReadInfo.Count-1 do
  begin
    getstr:=ReadInfo.GetFileName(getpos);
    getstr:=ExtractFileName(getstr);
    getstr:=copy(getstr,1,Pos('.',getstr)-1);
    Form_Info.Combo_List.Items.Add(getstr);
  end;
  if Form_Info.Combo_List.Items.Count >= 1 then
    Form_Info.Combo_List.ItemIndex:=0;
end;

//��������� ����
procedure LoadFileToMemo(Index:integer);
var
  StringList:TStrings;
  Poi:Pointer;
begin
  if Index >= ReadInfo.Count then
    Exit;
  Poi:=ReadInfo.GetPointer(Index);
  if Poi = nil then
    Exit;  
  StringList:=TStrings(Poi);
  Form_Info.Memo_Text.Lines:=StringList;
  Form_Info.LoadIndex:=Index;
end;

//��������� ������ ����
procedure TForm_Info.Button_CloseClick(Sender: TObject);
begin
  //��������� ����� � ���������
  SetConfValue('readformfontname',Memo_Text.Font.Name);
  SetConfValue('readformfontsize',IntToStr(Memo_Text.Font.Size));
  SetConfValue('readformfontcolor',IntToStr(Memo_Text.Font.Color));
  SetConfValue('readformfontorientation',IntToStr(Memo_Text.Font.Orientation));
  SetConfValue('readformfontcharset',IntToStr(Memo_Text.Font.Charset));
  //��������� ���� ����
  //������
  SetConfValue('readformmemocolor',IntToStr(Memo_Text.Color));
  //SetConfValue('readformfontstyle',IntToStr(Memo_Text.Font.Style));
end;

procedure TForm_Info.ChangeColorBoxChange(Sender: TObject);
begin
  Memo_Text.Color:=ChangeColorBox.Selected;
end;

procedure TForm_Info.Combo_ListChange(Sender: TObject);
begin
  if Combo_List.ItemIndex <> LoadIndex then
    LoadFileToMemo(Combo_List.ItemIndex);
end;

procedure TForm_Info.FontDialogButtonClick(Sender: TObject);
var
  FontDialog:TFontDialog;
begin
  FontDialog:=TFontDialog.Create(nil);
  FontDialog.Options:=FontDialog.Options + [fdAnsiOnly];
  FontDialog.Font:=Memo_Text.Font;
  if FontDialog.Execute then
    Memo_Text.Font:=FontDialog.Font;
end;

procedure TForm_Info.FormCreate(Sender: TObject);
begin
  SpeedButton_Help.Glyph.LoadFromFile(GetGifFileDocumentation);
end;

//��������� ���������
procedure TForm_Info.LoadSettings;
begin
  //��������� ����� � ���������
  Memo_Text.Font.Name:=GetConfValue('readformfontname');
  try
    Memo_Text.Font.Size:=StrToInt(GetConfValue('readformfontsize'));
    Memo_Text.Font.Color:=StrToInt(GetConfValue('readformfontcolor'));
    Memo_Text.Font.Orientation:=StrToInt(GetConfValue('readformfontorientation'));
    Memo_Text.Font.Charset:=StrToInt(GetConfValue('readformfontcharset'));
    Memo_Text.Color:=StrToInt(GetConfValue('readformmemocolor'));
  except
  end;
end;

procedure TForm_Info.SpeedButton_HelpClick(Sender: TObject);
begin
  ShowDocumentation(PWideChar('textdialog'));
end;

{$ENDREGION}

{$REGION '�������� � �������'}

//������ ����� �� ��������
function LoadFromDir(Path:PWideChar):Boolean;
var
  //������ � �����
  findRes:TSearchRec;
begin
  //���� ��� �����
  //� ������� ��������
  if FindFirst(Path+'*.*',faAnyFile,findRes) = 0 then
  begin
    //������ � �����
    //��� �����
    repeat
      if ExtractFileExt(findRes.Name) = '.txt' then
        ReadInfo.AddFile(Path+findRes.Name);
    until FindNext(findRes) <> 0;
    //������ �� �����
    FindClose(findRes);
  end;
  Result:=true;
end;

//��������� ������ �� ������
function LoadFromArchive:Boolean;
var
  GetPos,
  Count:Integer;
  FName,
  MainPath:WideString;
begin
  Result:=false;
  //���������� ������
  Count:=TxtFiles_Count;
  //���� ��� ����������
  MainPath:=Paths_GetTempPath;
  //���� ���������� ������
  //� ������ 0 ��
  //����� �������
  if Count = 0 then
    Exit;
  for GetPos:=0 to Count-1 do
  begin
    //�������� ��� �����
    FName:=TxtFiles_GetFileName(GetPos);
    if not TxtFiles_ExtractByName(PWideChar(FName)) then
      Continue;
    //�������� ���� � �����������
    FName:=MainPath+ExtractFileName(FName);
    //�������� ��� ���������
    //� ���������
    try
      ReadInfo.AddFile(FName);
    except
      //��������� ������ ���
      //��������� ������� � �����
      Exit;
    end;
    //������� ����
    DeleteFile(FName);
  end;
  Result:=true;
end;

//�������������� ��������
//���������
function CreateFiles(Path:PWideChar;Mode:Byte):Boolean;
begin
  if Mode = 0 then
    Result:=LoadFromDir(Path)
  else
    Result:=LoadFromArchive;
end;

{$ENDREGION}

//���������� ������ � �����������
function ShowReadForm(Path:PWideChar;Mode:Byte):boolean;
begin
  Result:=false;
  //������ ������
  InitLinks;
  CursorsLoading;
  ReadInfo:=TRFReadInfo.Create;
  //������ ������
  if not CreateFiles(Path,Mode) then
    Exit;
  if ReadInfo.Count = 0 then
    Exit;  
  //������� �����
  Form_Info:=TForm_Info.Create(nil);
  Form_Info.LoadIndex:=-1;
  //��������� ���������
  Form_Info.LoadSettings;
  //��������� �������� ������
  LoadLangData;
  //��������� ������ � �����
  LoadToCombo;
  //��������� ������ ����
  LoadFileToMemo(0);
  //�������� � ������
  Form_Info.ShowModal;
  Form_Info.Free;
  ReadInfo.Free;
end;

end.
