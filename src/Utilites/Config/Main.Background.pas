{
  drComRead

  ������ �������� ���������

  �������� ���������
  ����� �������� ����

  Copyright (c) 2012 Romanus
}
unit Main.Background;

interface

uses
  Dialogs, SysUtils, Controls, Forms,
  ExtCtrls, StdCtrls, ieview, imageenview, Classes, Generics.Collections;

const
  BackgroundModeOption          =         'modebackground';
  BackgroundColorOption         =         'backgroundcolor';
  BackgroundTileOption          =         'backgroundtile';

  BackgroundModeNone            =         0;
  BackgroundModeTile            =         1;
  BackgroundModeAutoColor       =         2;
  BackgroundModeColor           =         3;

type
  TMainBackground = class(TFrame)
    Panel_Separator: TPanel;
    Label_Mode: TLabel;
    ComboBox_Background: TComboBox;
    Panel_Separator2: TPanel;
    Label_ConcreteColor: TLabel;
    ColorBox_Color: TColorBox;
    Button_Apply: TButton;
    Panel_Separator3: TPanel;
    Label_BackgroundImage: TLabel;
    ImageView: TImageEnView;
    Button_ChangeImage: TButton;
    Panel_Separator4: TPanel;
    procedure ComboBox_BackgroundChange(Sender: TObject);
    procedure ColorBox_ColorChange(Sender: TObject);
    procedure Button_ChangeImageClick(Sender: TObject);
    procedure Button_ApplyClick(Sender: TObject);
  private
    //���������� ����
    FConcreteColor:Integer;
    //���
    FTileImage:String;
    //����� �����������
    FModeBackground:Integer;
    //�������������� ������� (��� �������� ������������� �
    //����������� �������� ���������)
    FRetype:TDictionary<Integer,Integer>;
    //�������������� ������� ������� (��� �������� ������������� �
    //����������� �������� ���������)
    FRetypeBack:TDictionary<Integer,Integer>;
    //��������� ����
    procedure LoadLanguage;
    //��������� ������
    procedure LoadData;
    //��������� ������
    procedure SaveDataToMainProgram;
    //���������� ������ �����
    procedure EnabledColor(Enabled:Boolean);
    //���������� ������ �����������
    procedure EnabledImage(Enabled:Boolean);
  public
    //�����������
    constructor Create(Owner:TComponent);override;
  end;

implementation

{$R *.dfm}

uses
  ConfigSynchronized, MainProgramHeader, ConfigGlobal;

//��������� ����
procedure TMainBackground.LoadLanguage;
begin
  Label_Mode.Caption:=LangArrayValue('background_type');
  Label_ConcreteColor.Caption:=LangArrayValue('background_color');
  Label_BackgroundImage.Caption:=LangArrayValue('background_tile');
  Button_ChangeImage.Caption:=LangArrayValue('background_tilebutton');
  ComboBox_Background.Items.Clear;
  with ComboBox_Background do
  begin
    Items.Add(LangArrayValue('background_none'));
    Items.Add(LangArrayValue('background_tile'));
    Items.Add(LangArrayValue('background_auto'));
    Items.Add(LangArrayValue('background_color'));
    ItemIndex:=0;
  end;
  Button_Apply.Caption:=LangArrayValue('save_button');
end;

//��������� ������
procedure TMainBackground.LoadData;
begin
  //���������� ����
  try
    FConcreteColor:=StrToInt(ConfArrayValue(BackgroundColorOption));
  except
    FConcreteColor:=0;
  end;
  ColorBox_Color.Selected:=FConcreteColor;
  //������� ��������
  FTileImage:=ConfArrayValue(BackgroundTileOption);
  if not FileExists(FTileImage) then
    FTileImage:='';
  //��������� �����
  try
    FModeBackground:=StrToInt(ConfArrayValue(BackgroundModeOption));
    //������ ��? :)
    FModeBackground:=FRetypeBack[FModeBackground];
  except
    FModeBackground:=0;
  end;
  ComboBox_Background.ItemIndex:=FModeBackground;
end;

//��������� ������
procedure TMainBackground.SaveDataToMainProgram;
begin
  SetConfArrayValue(BackgroundModeOption,IntToStr(FRetype[FModeBackground]));
  SetConfArrayValue(BackgroundColorOption,IntToStr(FConcreteColor));
  SetConfArrayValue(BackgroundTileOption,FTileImage);
end;

//�����������
procedure TMainBackground.Button_ApplyClick(Sender: TObject);
begin
  SaveDataToMainProgram;
end;

procedure TMainBackground.Button_ChangeImageClick(Sender: TObject);
var
  OpenDialog:TOpenDialog;
begin
  OpenDialog:=TOpenDialog.Create(nil);
  OpenDialog.Filter:='Images (*.bmp;*.jpg)|*.bmp;*.jpg;*.jpeg';
  if OpenDialog.Execute then
  begin
    FTileImage:=OpenDialog.FileName;
    try
      ImageView.IO.LoadFromFile(FTileImage);
    except
      ImageView.LayersClear;
      ImageView.Repaint;
    end;
  end;
  OpenDialog.Free;
end;

procedure TMainBackground.ColorBox_ColorChange(Sender: TObject);
begin
  FConcreteColor:=ColorBox_Color.Selected;
end;

procedure TMainBackground.ComboBox_BackgroundChange(Sender: TObject);
begin
  case ComboBox_Background.ItemIndex of
    BackgroundModeNone,BackgroundModeAutoColor:
      begin
        EnabledImage(false);
        EnabledColor(false);
      end;
    BackgroundModeTile:
      begin
        EnabledImage(true);
        EnabledColor(false);
      end;
    BackgroundModeColor:
      begin
        EnabledImage(false);
        EnabledColor(true);
      end;
  end;
  FModeBackground:=ComboBox_Background.ItemIndex;
end;

//���������� ������ �����
procedure TMainBackground.EnabledColor(Enabled:Boolean);
begin
  Label_ConcreteColor.Enabled:=Enabled;
  ColorBox_Color.Enabled:=Enabled;
end;

//���������� ������ �����������
procedure TMainBackground.EnabledImage(Enabled:Boolean);
begin
  Label_BackgroundImage.Enabled:=Enabled;
  Button_ChangeImage.Enabled:=Enabled;
  ImageView.Enabled:=Enabled;
  try
    if Enabled and (FTileImage <> '') then
      ImageView.IO.LoadFromFile(FTileImage);
  except
    ImageView.LayersClear;
    ImageView.Repaint;
  end;
end;

constructor TMainBackground.Create(Owner:TComponent);
begin
  inherited Create(Owner);
  FRetype:=TDictionary<Integer,Integer>.Create;
  FRetype.Add(0,4);
  FRetype.Add(1,2);
  FRetype.Add(2,3);
  FRetype.Add(3,1);
  FRetypeBack:=TDictionary<Integer,Integer>.Create;
  FRetypeBack.Add(4,0);
  FRetypeBack.Add(2,1);
  FRetypeBack.Add(3,2);
  FRetypeBack.Add(1,3);
  LoadLanguage;
  LoadData;
  ComboBox_BackgroundChange(nil);
end;

end.
