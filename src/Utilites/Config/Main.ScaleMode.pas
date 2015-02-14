{
  drComRead

  ������ �������� ���������

  �������� ���������
  ������� ���������������

  Copyright (c) 2011 Romanus
}
unit Main.ScaleMode;

interface

uses
  SysUtils, Classes, Controls, Forms,
  StdCtrls, ExtCtrls, Generics.Collections;

const
  ScaleModePortrait           =       'get_view_mode';
  ScaleModePortraitUserType   =       'getviewmodeusermode';
  ScaleModePortraitUserValue  =       'getviewmodeuser';

  ScaleModeAlbum              =       'get_view_mode_vert';
  ScaleModeAlbumUserType      =       'getviewmodevertusermode';
  ScaleModeAlbumUserValue     =       'getviewmodevertuser';

  ScaleModeTwoPage            =       'get_view_mode_twopage';
  ScaleModeTwoPageUserType    =       'getviewmodetwopageusermode';
  ScaleModeTwoPageUserValue   =       'getviewmodetwopageuser';

type
  //��� ���������������
  TScaleModeType = (smtOriginal,smtScale,smtFitWidth,smtFitHeight,smtUserValue);

  //����������
  TScaleOrientation = (soPortrait,soAlbum,soTwoPage);

  //��� ���������������� ������� ���������
  TScaleUserModeType = (sumtPercent,sumtPixels);

  //������ � ������� � ���������������
  TScaleModeRecord = class
  private
    //��� ���������������
    FScaleType:TScaleModeType;
    //���������������� ��� ���������������
    FUserMode:TScaleUserModeType;
    //���������������� ��������
    FUserValue:Integer;
  public
    //��� ���������������
    property ScaleType:TScaleModeType read FScaleType write FScaleType;
    //���������������� ��� ���������������
    property UserMode:TScaleUserModeType read FUserMode write FUserMode;
    //���������������� ��������
    property UserValue:Integer read FUserValue write FUserValue;
    //�����������
    constructor Create(ScaleType:TScaleModeType;UserMode:TScaleUserModeType;UserValue:Integer);
  end;

  TScaleMode = class(TFrame)
    ComboBox_ImageOrient: TComboBox;
    LabelOrientation: TLabel;
    RadioGroupScaleMode: TRadioGroup;
    LabelChangeScaleMode: TLabel;
    ComboBoxUserValueRange: TComboBox;
    EditUserValue: TEdit;
    LabelUserValue: TLabel;
    ButtonApply: TButton;
    Panel_Orientation: TPanel;
    Panel_UserValue: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure ComboBox_ImageOrientChange(Sender: TObject);
    procedure RadioGroupScaleModeClick(Sender: TObject);
    procedure ButtonApplyClick(Sender: TObject);
    procedure EditUserValueChange(Sender: TObject);
    procedure ComboBoxUserValueRangeChange(Sender: TObject);
  private
    FScaleModes:TDictionary<TScaleOrientation,TScaleModeRecord>;
    //������� ��������� ��������
    function GetOrientation:Integer;overload;
    //������� ��������� ��������
    function GetOrientation(Throw:Boolean):TScaleOrientation;overload;
    //������� ��������� �������������
    function GetScaleRecord:TScaleModeRecord;
    //���������� �������������
    function GetScaleTypeVisual:TScaleModeType;
    //���������� ���������� ���������
    //����� �������� ������������
    procedure SetEnabledUserValue(Enabled:Boolean);
  public
    //��������� �������� ������
    procedure LoadLanguage;
    //��������� ������
    procedure LoadData;
    //��������� ������ � ���������
    procedure SaveDataToMainProgram;
    //�����������
    constructor Create(Owner:TComponent);override;
    //����������
    destructor Destroy;override;
  end;

implementation

{$R *.dfm}

uses
  ConfigSynchronized, MainProgramHeader, ConfigGlobal;

//������� ��������� ��������
function TScaleMode.GetOrientation:Integer;
begin
  Result:=ComboBox_ImageOrient.ItemIndex;
end;

//������� ��������� ��������
function TScaleMode.GetOrientation(Throw:Boolean):TScaleOrientation;
begin
  Result:=TScaleOrientation(ComboBox_ImageOrient.ItemIndex);
end;

//������� ��������� �������������
function TScaleMode.GetScaleRecord:TScaleModeRecord;
begin
  Result:=FScaleModes[GetOrientation(false)];
end;

//���������� �������������
function TScaleMode.GetScaleTypeVisual:TScaleModeType;
begin
  Result:=TScaleModeType(RadioGroupScaleMode.ItemIndex);
end;

//���������� ���������� ���������
//����� �������� ������������
procedure TScaleMode.SetEnabledUserValue(Enabled:Boolean);
begin
  EditUserValue.Enabled:=Enabled;
  ComboBoxUserValueRange.Enabled:=Enabled;
end;

//�����������
constructor TScaleModeRecord.Create(ScaleType:TScaleModeType;UserMode:TScaleUserModeType;UserValue:Integer);
begin
  //��� ���������������
  FScaleType:=ScaleType;
  //���������������� ��� ���������������
  FUserMode:=UserMode;
  //���������������� ��������
  FUserValue:=UserValue;
end;

//��������� �������� ������
procedure TScaleMode.LoadLanguage;
begin
  //������ ���������
  ButtonApply.Caption:=LangArrayValue('save_button');
  //������ �������������� ����� ������ ���������������
  RadioGroupScaleMode.Items.Clear;
  with RadioGroupScaleMode.Items do
  begin
    Add(LangArrayValue('original'));
    Add(LangArrayValue('width_align'));
    Add(LangArrayValue('zooming'));
    Add(LangArrayValue('height_align'));
    Add(LangArrayValue('user_align'));
  end;
  //���������� ������ ��������� ��������
  ComboBox_ImageOrient.Items.Clear;
  with ComboBox_ImageOrient.Items do
  begin
    Add(LangArrayValue('portrait_combo'));
    Add(LangArrayValue('landscape_combo'));
    Add(LangArrayValue('twopagescale_combo'));
  end;
  ComboBox_ImageOrient.ItemIndex:=0;
  //����� ���������������� ������ ������
  ComboBoxUserValueRange.Items.Clear;
  with ComboBoxUserValueRange.Items do
  begin
    Add(LangArrayValue('user_mode_percent'));
    Add(LangArrayValue('user_mode_width'));
    Add(LangArrayValue('user_mode_height'));
  end;
  ComboBoxUserValueRange.ItemIndex:=0;
  //���������
  LabelUserValue.Caption:=LangArrayValue('user_align');
  LabelOrientation.Caption:=LangArrayValue('change_orientation_label');
  LabelChangeScaleMode.Caption:=LangArrayValue('change_scalemode_label');
end;

//��������� ������
procedure TScaleMode.LoadData;
var
  ScaleModeRecord:TScaleModeRecord;
  AlbumRecord:TScaleModeRecord;
  TwoPageRecord:TScaleModeRecord;
begin
  FScaleModes:=TDictionary<TScaleOrientation,TScaleModeRecord>.Create;
  ScaleModeRecord:=TScaleModeRecord.Create
  (
    TScaleModeType(StrToInt(ConfArrayValue(ScaleModePortrait))),
    TScaleUserModeType(StrToInt(ConfArrayValue(ScaleModePortraitUserType))),
    StrToInt(ConfArrayValue(ScaleModePortraitUserValue))
  );
  AlbumRecord:=TScaleModeRecord.Create
  (
    TScaleModeType(StrToInt(ConfArrayValue(ScaleModeAlbum))),
    TScaleUserModeType(StrToInt(ConfArrayValue(ScaleModeAlbumUserType))),
    StrToInt(ConfArrayValue(ScaleModeAlbumUserValue))
  );
  TwoPageRecord:=TScaleModeRecord.Create
  (
    TScaleModeType(StrToInt(ConfArrayValue(ScaleModeTwoPage))),
    TScaleUserModeType(StrToInt(ConfArrayValue(ScaleModeTwoPageUserType))),
    StrToInt(ConfArrayValue(ScaleModeTwoPageUserValue))
  );
  FScaleModes.Add(soPortrait,ScaleModeRecord);
  FScaleModes.Add(soAlbum,AlbumRecord);
  FScaleModes.Add(soTwoPage,TwoPageRecord);
end;

procedure TScaleMode.RadioGroupScaleModeClick(Sender: TObject);
begin
  GetScaleRecord.ScaleType:=GetScaleTypeVisual;
  SetEnabledUserValue(GetScaleTypeVisual = smtUserValue);
end;

procedure TScaleMode.ButtonApplyClick(Sender: TObject);
begin
  SaveDataToMainProgram;
end;

procedure TScaleMode.ComboBoxUserValueRangeChange(Sender: TObject);
var
  Value:Integer;
begin
  Value:=ComboBoxUserValueRange.ItemIndex;
  GetScaleRecord.UserMode:=TScaleUserModeType(Value);
end;

procedure TScaleMode.ComboBox_ImageOrientChange(Sender: TObject);
begin
  RadioGroupScaleMode.ItemIndex:=Integer(GetScaleRecord.ScaleType);
  EditUserValue.Text:=IntToStr(GetScaleRecord.FUserValue);
  ComboBoxUserValueRange.ItemIndex:=Integer(GetScaleRecord.FUserMode);
  if RadioGroupScaleMode.ItemIndex = 3 then
  begin
    EditUserValue.Enabled:=true;
    ComboBoxUserValueRange.Enabled:=true;
  end else
  begin
    EditUserValue.Enabled:=false;
    ComboBoxUserValueRange.Enabled:=false;
  end;
end;

constructor TScaleMode.Create(Owner:TComponent);
begin
  inherited Create(Owner);
  LoadLanguage;
  LoadData;
  ComboBox_ImageOrientChange(nil);
end;

//����������
destructor TScaleMode.Destroy;
begin
  FScaleModes.Free;
  inherited Destroy;
end;

procedure TScaleMode.EditUserValueChange(Sender: TObject);
var
  Value:Integer;
begin
  try
    if EditUserValue.Text <> '' then
      Value:=StrToInt(EditUserValue.Text)
    else
      Value:=0;
  except
    Value:=0;
  end;
  GetScaleRecord.UserValue:=Value;
end;

//��������� ������ � ���������
procedure TScaleMode.SaveDataToMainProgram;
begin
  SetConfArrayValue(ScaleModePortrait,IntToStr(Integer(FScaleModes[soPortrait].ScaleType)));
  SetConfArrayValue(ScaleModePortraitUserType,IntToStr(Integer(FScaleModes[soPortrait].UserMode)));
  SetConfArrayValue(ScaleModePortraitUserValue,IntToStr(Integer(FScaleModes[soPortrait].UserValue)));

  SetConfArrayValue(ScaleModeAlbum,IntToStr(Integer(FScaleModes[soAlbum].ScaleType)));
  SetConfArrayValue(ScaleModeAlbumUserType,IntToStr(Integer(FScaleModes[soAlbum].UserMode)));
  SetConfArrayValue(ScaleModeAlbumUserValue,IntToStr(Integer(FScaleModes[soAlbum].UserValue)));

  SetConfArrayValue(ScaleModeTwoPage,IntToStr(Integer(FScaleModes[soTwoPage].ScaleType)));
  SetConfArrayValue(ScaleModeTwoPageUserType,IntToStr(Integer(FScaleModes[soTwoPage].UserMode)));
  SetConfArrayValue(ScaleModeTwoPageUserValue,IntToStr(Integer(FScaleModes[soTwoPage].UserValue)));
end;

end.
