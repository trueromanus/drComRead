{
  drComRead

  ������ �������� ���������

  ��������� ���������

  Copyright (c) 2012 Romanus
}
unit Main.Navigate;

interface

uses
  SysUtils, Classes, Controls, Forms, StdCtrls, ExtCtrls;

const
  ArchiveDirectPagingOption           =         'arcendpaging';
  ActiveEdgePagingOption              =         'windowedgepaging';

type
  TMainNavigate = class(TFrame)
    Panel_Separator: TPanel;
    Button_Apply: TButton;
    Label_DirectOpenArchive: TLabel;
    CheckBox_DirectOpenArchive: TCheckBox;
    Panel_Separator2: TPanel;
    Label_EdgePagesPaging: TLabel;
    CheckBox_EdgePagesPaging: TCheckBox;
    Panel_Separator3: TPanel;
    procedure Button_ApplyClick(Sender: TObject);
  private
    FEndPaging:Boolean;
    FEdgePaging:Boolean;
    //��������� (���� ��� �������� � ����� ���)
    function ConvertStringToBool(Value:String):Boolean;
    //��������� ����
    procedure LoadLanguage;
    //��������� ������
    procedure LoadData;
    //��������� ������
    procedure SaveDataToMainProgram;
  public
    //�����������
    constructor Create(Owner:TComponent);override;
  end;

implementation

{$R *.dfm}

uses
  ConfigSynchronized, MainProgramHeader, ConfigGlobal;

//��������� (���� ��� �������� � ����� ���)
procedure TMainNavigate.Button_ApplyClick(Sender: TObject);
begin
  SaveDataToMainProgram;
end;

function TMainNavigate.ConvertStringToBool(Value:String):Boolean;
begin
  try
    if Value = '' then
      Exit(false);
    Result:=StrToBool(Value);
  except
    Result:=false;
  end;
end;

//��������� ����
procedure TMainNavigate.LoadLanguage;
begin
  Label_DirectOpenArchive.Caption:=LangArrayValue('paging_endarchive');
  Label_EdgePagesPaging.Caption:=LangArrayValue('paging_edgemode');
end;

//��������� ������
procedure TMainNavigate.LoadData;
begin
  FEndPaging:=ConvertStringToBool(ConfArrayValue(ArchiveDirectPagingOption));
  FEdgePaging:=ConvertStringToBool(ConfArrayValue(ActiveEdgePagingOption));
  CheckBox_DirectOpenArchive.Checked:=FEndPaging;
  CheckBox_EdgePagesPaging.Checked:=FEdgePaging;
  Button_Apply.Caption:=LangArrayValue('save_button');
end;

//��������� ������
procedure TMainNavigate.SaveDataToMainProgram;
begin
  SetConfArrayValue(ArchiveDirectPagingOption,BoolToStr(FEndPaging));
  SetConfArrayValue(ActiveEdgePagingOption,BoolToStr(FEdgePaging));
end;

//�����������
constructor TMainNavigate.Create(Owner:TComponent);
begin
  inherited Create(Owner);
  LoadLanguage;
  LoadData;
end;

end.
