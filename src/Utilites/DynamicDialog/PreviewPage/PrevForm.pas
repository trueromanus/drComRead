{
  drComRead

  Preview Page Dialog

  ћодуль формы предпросмотра
  списка изображений
  единичный вариант

  Copyright (c) 2008-2011 Romanus
}
unit PrevForm;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms,
  Dialogs, ExtCtrls, ieview, iemview;

type
  TFormPrev = class(TForm)
    MViewImages: TImageEnMView;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MViewImagesClick(Sender: TObject);
    procedure MViewImagesDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MViewImagesMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
  public
    NewNumber:Integer;
  end;

var
  FormPrev: TFormPrev;
  //номер страницы
  NumberPage:integer = 0;
  //признак изменени€
  //страницы
  PageChanged:Boolean = false;
  //флаг того что работает
  //загрузка списка изображений
  FlagLoaded:Boolean = false;
  //задержки дл€ прокрутки
  DelayFlag:Integer = 3;

{$REGION '‘ункции дл€ внешнего доступа'}

//отображаем диалог
//предпромотра
function ShowPrevOneDialog(Position:integer):integer;stdcall;
//загружаем данные в коллекцию
function LoadImagesCollection:Boolean;stdcall;
//чистим данные в коллекции
function ClearBitmapList:Boolean;stdcall;
//загружаетс€ ли список или нет
function BitmapListIsLoading:Boolean;stdcall;

{$ENDREGION}

implementation

{$R *.dfm}

uses
  MainProgramHeader;

{$REGION '‘ункции дл€ внешнего доступа'}

//отображаем диалог
//предпромотра
function ShowPrevOneDialog(Position:integer):Integer;
var
  PosMainWindow:TFEWindowPosition;
begin
  try
    Result:=-1;
    //инициализируем ссылки
    InitLinks;
    CursorsLoading;
    //позици€ в коллекции
    NumberPage:=Position;
    //создаем окно
    if not Assigned(FormPrev) then
    begin
      FormPrev:=TFormPrev.Create(nil);
      FlagLoaded:=true;
      LoadImagesCollection;
      FlagLoaded:=false;
      Position:=Navigation_Position;
    end;
    PosMainWindow:=Window_GetWindowPosition;
    FormPrev.Left:=PosMainWindow.X;
    FormPrev.Top:=PosMainWindow.Y;
    FormPrev.Width:=PosMainWindow.Width;
    FormPrev.MViewImages.SelectionWidthNoFocus:=4;
    FormPrev.MViewImages.SelectedImage:=Position;
    FormPrev.MViewImages.CenterSelected;
    FormPrev.Cursor:=crArrow;
    //отображаем диалог
    FormPrev.ShowModal;

    //если изменили
    if (NumberPage <> FormPrev.NewNumber) and
       (FormPrev.NewNumber <> -1) then
      //грузим первое изображение
      //возвращаем номер
      //страницы
      Result:=FormPrev.NewNumber;
  except
    Result:=-1;
  end;
end;

//загружаем данные в коллекцию
function LoadImagesCollection():Boolean;
var
  CurrentPos:Integer;
  CurrentName:String;
  TempPath:String;
begin
  FormPrev.MViewImages.Clear;
  if ListImage_OpenArchive then
  begin
    //зачитываем из архива
    for CurrentPos:=0 to ListImage_Count-1 do
    begin
       CurrentName:=ListImage_GetFileName(CurrentPos);
       if ExtractImageWithName(GetArchiv(GetArchivPosition),PWideChar(CurrentName)) then
       begin
         try
           CurrentName:=StringReplace(CurrentName,'/','\',[rfReplaceAll]);
           TempPath:=Paths_GetTempPath+ExtractFileName(CurrentName);
           FormPrev.MViewImages.AppendImage(TempPath);
           DeleteFile(TempPath);
           Application.ProcessMessages;
         except
           FormPrev.MViewImages.Clear;
           Exit(false);
         end;
       end;
    end;
  end else
  begin
    //зачитываем с диска
    for CurrentPos:=0 to ListImage_Count-1 do
    begin
      try
        FormPrev.MViewImages.MIO.LoadFromFile(ListImage_GetFileName(CurrentPos));
      except
        FormPrev.MViewImages.Clear;
        Exit(false);
      end;
    end;
  end;
  Result:=true;
end;

//чистим данные в коллекции
function ClearBitmapList:Boolean;
begin
  if Assigned(FormPrev) then
  begin
    FormPrev.MViewImages.Clear;
    FreeAndNil(FormPrev);
  end;
  Result:=true;
end;

//загружаетс€ ли список или нет
function BitmapListIsLoading:Boolean;
begin
  Result:=FlagLoaded;
end;

{$ENDREGION}

procedure TFormPrev.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 27 then
  begin
    NewNumber:=-1;
    Self.Close;
  end;
  if Key = 13 then
  begin
    MViewImagesClick(nil);
    Self.Close;
  end;
end;

procedure TFormPrev.FormShow(Sender: TObject);
begin
  FormPrev.FocusControl(FormPrev.MViewImages);
end;

procedure TFormPrev.MViewImagesClick(Sender: TObject);
begin
  NewNumber:=MViewImages.SelectedImage;
end;

procedure TFormPrev.MViewImagesDblClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TFormPrev.MViewImagesMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if DelayFlag > 0 then
  begin
    Dec(DelayFlag);
    Exit;
  end;
  if WheelDelta < 0 then
  begin
    if MViewImages.SelectedImage <> MViewImages.ImageCount then
      MViewImages.SelectedImage:=MViewImages.SelectedImage+1;
  end else
  begin
    if MViewImages.SelectedImage <> 0 then
      MViewImages.SelectedImage:=MViewImages.SelectedImage-1;
  end;
  MViewImages.CenterSelected;
  DelayFlag:=3;
end;

end.
