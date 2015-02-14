{
  drComRead

  Модуль с формой
  просмотра информации

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
    //индекс загруженного файла
    LoadIndex:integer;
    //загружаем настройки
    procedure LoadSettings;
  end;

var
  Form_Info: TForm_Info;
  //ссылка на языковой файл
  LangHandle:Integer;

//загружаем языковые данные
function LoadLangData:boolean;
//загружаем данные в комбо
procedure LoadToCombo;
//загружаем файл
procedure LoadFileToMemo(Index:integer);
//инициализируем файловую
//коллекцию
function CreateFiles(Path:PWideChar;Mode:Byte):Boolean;
//показываем диалог с информацией
function ShowReadForm(Path:PWideChar;Mode:Byte):boolean;stdcall;

implementation

uses
  Windows, SysUtils, RFGlobal,
  RFMainClass, MainProgramHeader;

{$R *.dfm}

//загружаем языковые данные
function LoadLangData:boolean;
var
  NameGroup:String;
begin
  Result:=false;
  NameGroup:='readinfodialog';
  //заголовок окна
  Form_Info.Caption:=MultiLanguage_GetGroupValue(PWideChar(NameGroup),'name_dialog');
  //кнопка закрыть
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

{$REGION 'Работаем со списком'}

//загружаем данные в комбо
procedure LoadToCombo;
var
  GetPos:integer;
  getstr:string;
begin
  //очищаем список
  Form_Info.Combo_List.Items.Clear;
  //загружаем в него данные
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

//загружаем файл
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

//загружаем нужный файл
procedure TForm_Info.Button_CloseClick(Sender: TObject);
begin
  //сохраняем шрифт в настройки
  SetConfValue('readformfontname',Memo_Text.Font.Name);
  SetConfValue('readformfontsize',IntToStr(Memo_Text.Font.Size));
  SetConfValue('readformfontcolor',IntToStr(Memo_Text.Font.Color));
  SetConfValue('readformfontorientation',IntToStr(Memo_Text.Font.Orientation));
  SetConfValue('readformfontcharset',IntToStr(Memo_Text.Font.Charset));
  //сохраняем цвет фона
  //текста
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

//загружаем настройки
procedure TForm_Info.LoadSettings;
begin
  //сохраняем шрифт в настройки
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

{$REGION 'Работаем с данными'}

//грузим файлы из каталога
function LoadFromDir(Path:PWideChar):Boolean;
var
  //запись о файле
  findRes:TSearchRec;
begin
  //ищем все файлы
  //в текущем каталоге
  if FindFirst(Path+'*.*',faAnyFile,findRes) = 0 then
  begin
    //читаем в цикле
    //все файлы
    repeat
      if ExtractFileExt(findRes.Name) = '.txt' then
        ReadInfo.AddFile(Path+findRes.Name);
    until FindNext(findRes) <> 0;
    //чистим за собой
    FindClose(findRes);
  end;
  Result:=true;
end;

//загружаем данные из архива
function LoadFromArchive:Boolean;
var
  GetPos,
  Count:Integer;
  FName,
  MainPath:WideString;
begin
  Result:=false;
  //количество файлов
  Count:=TxtFiles_Count;
  //путь для извлечения
  MainPath:=Paths_GetTempPath;
  //если количество файлов
  //в архиве 0 то
  //сразу выходим
  if Count = 0 then
    Exit;
  for GetPos:=0 to Count-1 do
  begin
    //получаем имя файла
    FName:=TxtFiles_GetFileName(GetPos);
    if not TxtFiles_ExtractByName(PWideChar(FName)) then
      Continue;
    //получаем путь к изображению
    FName:=MainPath+ExtractFileName(FName);
    //пытаемся его загрузить
    //в коллекцию
    try
      ReadInfo.AddFile(FName);
    except
      //произошла ошибка при
      //получению доступа к файлу
      Exit;
    end;
    //удаляем файл
    DeleteFile(FName);
  end;
  Result:=true;
end;

//инициализируем файловую
//коллекцию
function CreateFiles(Path:PWideChar;Mode:Byte):Boolean;
begin
  if Mode = 0 then
    Result:=LoadFromDir(Path)
  else
    Result:=LoadFromArchive;
end;

{$ENDREGION}

//показываем диалог с информацией
function ShowReadForm(Path:PWideChar;Mode:Byte):boolean;
begin
  Result:=false;
  //грузим ссылки
  InitLinks;
  CursorsLoading;
  ReadInfo:=TRFReadInfo.Create;
  //грузим данные
  if not CreateFiles(Path,Mode) then
    Exit;
  if ReadInfo.Count = 0 then
    Exit;  
  //создаем форму
  Form_Info:=TForm_Info.Create(nil);
  Form_Info.LoadIndex:=-1;
  //загружаем настройки
  Form_Info.LoadSettings;
  //загружаем языковые данные
  LoadLangData;
  //загружаем данные в комбо
  LoadToCombo;
  //загружаем первый файл
  LoadFileToMemo(0);
  //работаем с формой
  Form_Info.ShowModal;
  Form_Info.Free;
  ReadInfo.Free;
end;

end.
