{
  drComRead

  ћодуль настроек программы

  Ќастройки навигации

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
    //конвертим (если это возможно в булев тип)
    function ConvertStringToBool(Value:String):Boolean;
    //загружаем €зык
    procedure LoadLanguage;
    //загружаем данные
    procedure LoadData;
    //сохран€ем данные
    procedure SaveDataToMainProgram;
  public
    //конструктор
    constructor Create(Owner:TComponent);override;
  end;

implementation

{$R *.dfm}

uses
  ConfigSynchronized, MainProgramHeader, ConfigGlobal;

//конвертим (если это возможно в булев тип)
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

//загружаем €зык
procedure TMainNavigate.LoadLanguage;
begin
  Label_DirectOpenArchive.Caption:=LangArrayValue('paging_endarchive');
  Label_EdgePagesPaging.Caption:=LangArrayValue('paging_edgemode');
end;

//загружаем данные
procedure TMainNavigate.LoadData;
begin
  FEndPaging:=ConvertStringToBool(ConfArrayValue(ArchiveDirectPagingOption));
  FEdgePaging:=ConvertStringToBool(ConfArrayValue(ActiveEdgePagingOption));
  CheckBox_DirectOpenArchive.Checked:=FEndPaging;
  CheckBox_EdgePagesPaging.Checked:=FEdgePaging;
  Button_Apply.Caption:=LangArrayValue('save_button');
end;

//сохран€ем данные
procedure TMainNavigate.SaveDataToMainProgram;
begin
  SetConfArrayValue(ArchiveDirectPagingOption,BoolToStr(FEndPaging));
  SetConfArrayValue(ActiveEdgePagingOption,BoolToStr(FEdgePaging));
end;

//конструктор
constructor TMainNavigate.Create(Owner:TComponent);
begin
  inherited Create(Owner);
  LoadLanguage;
  LoadData;
end;

end.
