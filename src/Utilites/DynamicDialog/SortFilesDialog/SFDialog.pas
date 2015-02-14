{
  drComRead

  Sorting Library

  ћодуль с описанием
  диалога сортировки

  Copyright (c) 2008-2011 Romanus
}
unit SFDialog;

interface

uses
  Windows, SysUtils, Classes, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Controls, Buttons;

type
  TSortDialog = class(TForm)
    DescButton: TButton;
    AscButton: TButton;
    ApplyButton: TButton;
    CancelButton: TButton;
    FilesListBox: TListBox;
    ButtonsPanel: TPanel;
    ShowFullPathFiles: TCheckBox;
    EasySelect: TCheckBox;
    CheckBoxSensitive: TCheckBox;
    PanelBackground: TPanel;
    SpeedButton_Help: TSpeedButton;
    procedure CancelButtonClick(Sender: TObject);
    procedure ApplyButtonClick(Sender: TObject);
    procedure ShowFullPathFilesClick(Sender: TObject);
    procedure DescButtonClick(Sender: TObject);
    procedure AscButtonClick(Sender: TObject);
    procedure SelectButtonClick(Sender: TObject);
    procedure FilesListBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FilesListBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure EasySelectClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure DeselectButtonClick(Sender: TObject);
    procedure CheckBoxSensitiveClick(Sender: TObject);
    procedure pasteToClick(Sender: TObject);
    procedure SpeedButton_HelpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
  public
    //обновл€ем горизонтальный
    //скролинг
    procedure HorizontalScroll;
    //чистим список индексов
    procedure ClearIndexList;
    //загружаем из списка
    procedure LoadToList(List:TStrings);
    //преставл€ем элементы
    //в обоих листах
    procedure ExchangeTwoList(Index1,Index2:Integer);
    //удаление из обоих списков
    function DeleteTwoList(Index:Integer):Boolean;
  end;

var
  //сам диалог
  SortDialog: TSortDialog;
  //результат диалога
  //если true то значит
  //принимаем изменени€
  ResultDialog:Boolean = false;
  //текущий индекс
  //дл€ перетаскивани€
  GetItemIndex:Integer = -1;
  //список выделенных
  //элементов
  GetSelectedIndex:TList;

//отображаем диалог
function ShowSortFilesDialog(Left,Top:Integer):Boolean;stdcall;

//создаем или получаем
//диалог сортировки
function SortFilesContext(Control:TWinControl):Boolean;stdcall;

implementation

uses
  MainProgramHeader, SFGlobal, SFSorting,
  Messages;

{$R *.dfm}

{$REGION 'ќсновные кнопки'}

procedure TSortDialog.ApplyButtonClick(Sender: TObject);
begin
  ResultDialog:=true;
  Self.Close;
end;

procedure TSortDialog.AscButtonClick(Sender: TObject);
begin
  if not ShowFullPathFiles.Checked then
    AscSortList
  else
    AscSortListOF;
  Self.LoadToList(FilesCollection);
end;

procedure TSortDialog.DescButtonClick(Sender: TObject);
begin
  if not ShowFullPathFiles.Checked then
    DescSortList
  else
    DescSortListOF;
  Self.LoadToList(FilesCollection);
end;

procedure TSortDialog.CancelButtonClick(Sender: TObject);
begin
  ResultDialog:=false;
  Self.Close;
end;

procedure TSortDialog.CheckBoxSensitiveClick(Sender: TObject);
begin
  if CheckBoxSensitive.Checked then
    MultiLanguage_SetConfigValue('sort_imagesensitive','-1')
  else
    MultiLanguage_SetConfigValue('sort_imagesensitive','0');
end;

{$ENDREGION}

{$REGION '—ложна€ сортировка'}

procedure TSortDialog.SelectButtonClick(Sender: TObject);
var
  GetPos:Integer;
  PGetPos:Pointer;
begin
  //если включена легка€
  //сортировка то игнорируем
  if EasySelect.Checked then
    Exit;
  //если не выделенных
  //то игнорируем
  if FilesListBox.SelCount = 0 then
    Exit;
  //чистим список
  Self.ClearIndexList;
  //проходим по списку и собираем
  //индексы выделенных пунктов
  for GetPos:=0 to FilesListBox.Count-1 do
  begin
    if FilesListBox.Selected[GetPos] then
    begin
      New(PGetPos);
      //PGetPos:=GetPos;
      GetSelectedIndex.Add(PGetPos);
    end;
  end;
end;

procedure TSortDialog.DeselectButtonClick(Sender: TObject);
begin
  //если включена легка€
  //сортировка то игнорируем
  if EasySelect.Checked then
    Exit;
  //чистим список
  GetSelectedIndex.Clear;
  //индекс на первый элемент
  FilesListBox.ItemIndex:=0;
end;

{$ENDREGION}

{$REGION '–аботаем с легкой ручной сортировкой'}

procedure TSortDialog.FilesListBoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //если включен режим
  //легкой ручной сортировки
  if not EasySelect.Checked then
    Exit;
  //получаем текущий выбранный
  //элемент
  GetItemIndex:=FilesListBox.ItemAtPos(Point(X,Y),false);
  //если ничего не выбрали
  //ничего и не делаем
  if GetItemIndex = -1 then
    Exit;
end;

procedure TSortDialog.FilesListBoxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  SetItemIndex:Integer;
begin
  if GetItemIndex = -1 then
    Exit;
  if not EasySelect.Checked then
    Exit;
  SetItemIndex:=FilesListBox.ItemAtPos(Point(X,Y),false);
  if (SetItemIndex = -1) or
     (SetItemIndex = GetItemIndex) then
    Exit;
  ExchangeTwoList(GetItemIndex,SetItemIndex);
end;

procedure TSortDialog.FormCreate(Sender: TObject);
begin
  SpeedButton_Help.Glyph.LoadFromFile(GetGifFileDocumentation);
end;

procedure TSortDialog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 112 then
    SpeedButton_HelpClick(nil);
end;

procedure TSortDialog.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    //Enter
    #13:Self.ApplyButton.Click;
    //Esc
    #27:Self.CancelButton.Click;
  end;

end;

procedure TSortDialog.EasySelectClick(Sender: TObject);
begin
  if EasySelect.Checked then
    FilesListBox.MultiSelect:=false
  else
    FilesListBox.MultiSelect:=true
end;

{$ENDREGION}

{$REGION '–аботаем со списком'}

procedure TSortDialog.ShowFullPathFilesClick(Sender: TObject);
var
  GetPos:Integer;
  GetStr:WideString;
begin
  //чистим список
  FilesListBox.Items.Clear;
  //заполн€ем его значени€ми
  for GetPos:=0 to FilesCollection.Count - 1 do
  begin
    GetStr:=StringReplace(FilesCollection[GetPos],'/','\',[rfReplaceAll]);
    if ShowFullPathFiles.Checked then
      GetStr:=ExtractFileName(GetStr);
    FilesListBox.Items.Add(GetStr);
  end;
end;

procedure TSortDialog.SpeedButton_HelpClick(Sender: TObject);
begin
  ShowDocumentation(PWideChar('sortfiles'));
end;

//обновл€ем горизонтальный
//скролинг
procedure TSortDialog.HorizontalScroll;
var
  GetPos,MaxWidth: integer;
begin
  MaxWidth:= 0;
  with FilesListBox do
  begin
    for GetPos:=0 to FilesListBox.Items.Count - 1 do
      if MaxWidth < Canvas.TextWidth(Items.Strings[GetPos]) then
        MaxWidth := Canvas.TextWidth(Items.Strings[GetPos]);
    SendMessage(Handle, LB_SETHORIZONTALEXTENT, MaxWidth + 2,0);
  end;
end;

//чистим список индексов
procedure TSortDialog.ClearIndexList;
begin
  GetSelectedIndex.Clear;
end;

//загружаем из списка
procedure TSortDialog.LoadToList(List:TStrings);
var
  GetPos:Integer;
  GetStr:String;
begin
  FilesListBox.Items.Clear;
  for GetPos:=0 to FilesCollection.Count - 1 do
  begin
    GetStr:=StringReplace(FilesCollection[GetPos],'/','\',[rfReplaceAll]);
    if ShowFullPathFiles.Checked then
      GetStr:=ExtractFileName(GetStr);
    FilesListBox.Items.Add(GetStr);
  end;
  Self.HorizontalScroll;
end;

procedure TSortDialog.pasteToClick(Sender: TObject);
begin

end;

//преставл€ем элементы
//в обоих листах
procedure TSortDialog.ExchangeTwoList(Index1,Index2:Integer);
begin
  FilesCollection.Exchange(Index1,Index2);
  FilesListBox.Items.Exchange(Index1,Index2);
end;

//удаление из обоих списков
function TSortDialog.DeleteTwoList(Index:Integer):Boolean;
begin
  try
    FilesCollection.Delete(Index);
    FilesListBox.Items.Delete(Index);
    Result:=true;
  except
    Result:=false;
  end;
end;

{$ENDREGION}

//загружаем мульти€зыковые данные
//из основной программы
function LangLoadToMainProgram:Boolean;
const
  //им€ группы
  NameOfGroup : PWideChar = 'sortandarcdialog';
begin
  try
    //получем ссылку
    //управл€ющую на функцию
    SortDialog.Caption:=MultiLanguage_GetGroupValue(NameOfGroup,'sort_title');
    with SortDialog do
    begin
      ApplyButton.Caption:=MultiLanguage_GetGroupValue(NameOfGroup,'change');
      CancelButton.Caption:=MultiLanguage_GetGroupValue(NameOfGroup,'cancel');
      AscButton.Caption:=MultiLanguage_GetGroupValue(NameOfGroup,'asc');
      DescButton.Caption:=MultiLanguage_GetGroupValue(NameOfGroup,'desc');
      ShowFullPathFiles.Caption:=MultiLanguage_GetGroupValue(NameOfGroup,'show_path_files');
      EasySelect.Caption:=MultiLanguage_GetGroupValue(NameOfGroup,'easy_select');
      CheckBoxSensitive.Caption:=MultiLanguage_GetGroupValue(NameOfGroup,'casesensitive');
      CheckBoxSensitive.Checked:=(MultiLanguage_GetConfigValue(PWideChar('sort_imagesensitive')) = '-1');
    end;
    Result:=true;
  except
    Result:=false;
  end;
end;

//отображаем диалог
function ShowSortFilesDialog(Left,Top:Integer):Boolean;
var
  GetPos:Integer;
begin
  Result:=false;
  GetSelectedIndex:=TList.Create;
  InitLinks;
  CursorsLoading;
  //если нет ничего в списке
  //нечего и делать
  if ListImage_Count = 0 then
    Exit;
  //создаем диалог
  SortDialog:=TSortDialog.Create(nil);
  //мульти€зыковые данные
  if not LangLoadToMainProgram then
    Exit;
  FilesCollection.Clear;
  for GetPos:=0 to ListImage_Count-1 do
    FilesCollection.Add(ListImage_GetFileName(GetPos));
  //позици€ окна
  SortDialog.Left:=Left;
  SortDialog.Top:=Top;
  //грузим в диалог
  SortDialog.LoadToList(FilesCollection);
  //отображаем диалог
  SortDialog.ShowModal;
  //чистим за собой
  SortDialog.Free;
  GetSelectedIndex.Free;
  //возвращаем результат
  Result:=ResultDialog;
  if ResultDialog then
    for GetPos:=0 to ListImage_Count-1 do
      ListImage_SetFileName(GetPos,PWideChar(FilesCollection[GetPos]));
end;

//создаем или получаем
//диалог сортировки
function SortFilesContext(Control:TWinControl):Boolean;
var
  Current:Integer;
begin
  if not Assigned(SortDialog) then
  begin
    SortDialog:=TSortDialog.Create(nil);
    for Current:=0 to SortDialog.ComponentCount-1 do
      TWinControl(SortDialog.Components[Current]).Parent:=Control;
  end;
  Result:=true;
end;

end.
