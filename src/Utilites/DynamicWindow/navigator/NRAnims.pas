{
  drComRead

  Navigator Window

  Модуль для работы
  с визуальным функционалом
  навигатора

  Copyright (c) 2009-2010 Romanus
}
unit NRAnims;

interface

const
  //массив файлов картинок
  ArrayImagesName:array[0..13] of WideString =
                                  (
                                    'start.bmp',
                                    'end.bmp',
                                    'up.bmp',
                                    'down.bmp',
                                    'background.jpg',
                                    'arcup.bmp',
                                    'arcdown.bmp',
                                    'navup.bmp',
                                    'navdown.bmp',
                                    'centralpanel.bmp',
                                    'rightdownhide.bmp',
                                    'leftdownhide.bmp',
                                    'leftuphide.bmp',
                                    'rightuphide.bmp'
                                  );
var
  //путь к приложению
  PathToApp:WideString;
  FlagLoaded:Boolean=false;

{$REGION 'Работаем с отображением элементов'}

//простое скрытие элементов
procedure EasyHideElement(Visible:Boolean);

{$ENDREGION}

{$REGION 'Грузим картинки с диска'}

//проверка на существование
//картинок для отображения
function ExistingImages:Boolean;
//грузим картинки
function LoadImages:Boolean;

{$ENDREGION}

implementation

uses
  NRMainForm, Controls, Dialogs, SysUtils,
  MainProgramHeader;

{$REGION 'Работаем с отображением элементов'}

//простое скрытие элементов
procedure EasyHideElement(Visible:Boolean);
begin
  (*with CRNavigator do
  begin
    UpPanel.Visible:=Visible;
    DownPanel.Visible:=Visible;
    LeftPanel.Visible:=Visible;
    RightPanel.Visible:=Visible;
    Panel1.Visible:=Visible;
    Panel2.Visible:=Visible;
    Panel3.Visible:=Visible;
    Panel4.Visible:=Visible;
  end;*)
end;

//изменяем размеры элемента
procedure CanvasElementSize(Obj:TControl;Exponent:Integer);
begin
  Obj.Left:=Obj.Left+Exponent;
  Obj.Top:=Obj.Top+Exponent;
  Obj.Width:=Obj.Top-Exponent;
  Obj.Height:=Obj.Top-Exponent;
end;

{$ENDREGION}

{$REGION 'Грузим картинки с диска'}

//проверка на существование
//картинок для отображения
function ExistingImages:Boolean;
var
  GPos,Count:Integer;
begin
  Result:=false;
  try
    PathToApp:=Paths_GetApplicationPath;
  except
    Exit;
  end;
  PathToApp:=PathToApp+'Data\';
  Count:=High(ArrayImagesName);
  for GPos:=0 to Count do
    if not FileExists(PathToApp+ArrayImagesName[GPos]) then
      Exit;
  Result:=true;
end;

//грузим картинки
function LoadImages:Boolean;
begin
  Result:=false;
  if not ExistingImages then
    Exit;
  try
    CRNavigator.LeftImage.Picture.LoadFromFile(PathToApp+ArrayImagesName[0]);
    CRNavigator.RightImage.Picture.LoadFromFile(PathToApp+ArrayImagesName[1]);
    CRNavigator.UpImage.Picture.LoadFromFile(PathToApp+ArrayImagesName[2]);
    CRNavigator.DownImage.Picture.LoadFromFile(PathToApp+ArrayImagesName[3]);
    CRNavigator.CountPosImage.Picture.LoadFromFile(PathToApp+ArrayImagesName[4]);
    CRNavigator.ActiveScrollImage.Picture.LoadFromFile(PathToApp+ArrayImagesName[4]);
    CRNavigator.RotateSaveImage.Picture.LoadFromFile(PathToApp+ArrayImagesName[4]);
    CRNavigator.FuncImage.Picture.LoadFromFile(PathToApp+ArrayImagesName[4]);
    CRNavigator.PrevArchive.Picture.LoadFromFile(PathToApp+ArrayImagesName[5]);
    CRNavigator.NextArchive.Picture.LoadFromFile(PathToApp+ArrayImagesName[6]);
    CRNavigator.UpNavigationImage.Picture.LoadFromFile(PathToApp+ArrayImagesName[7]);
    CRNavigator.DownNavigationImage.Picture.LoadFromFile(PathToApp+ArrayImagesName[8]);
    CRNavigator.UpArchiveNavigation.Picture.LoadFromFile(PathToApp+ArrayImagesName[7]);
    CRNavigator.DownArchiveNavigation.Picture.LoadFromFile(PathToApp+ArrayImagesName[8]);
    CRNavigator.ImageBackgroundCountPages.Picture.LoadFromFile(PathToApp+ArrayImagesName[4]);
    CRNavigator.ImageDragPanel.Picture.LoadFromFile(PathToApp+ArrayImagesName[9]);
    CRNavigator.ImageRightDown.Picture.LoadFromFile(PathToApp+ArrayImagesName[10]);
    CRNavigator.ImageLeftDownHide.Picture.LoadFromFile(PathToApp+ArrayImagesName[11]);
    CRNavigator.ImageLeftUpHide.Picture.LoadFromFile(PathToApp+ArrayImagesName[12]);
    CRNavigator.ImageRightUpHide.Picture.LoadFromFile(PathToApp+ArrayImagesName[13]);
  except
    Exit;
  end;
  FlagLoaded:=true;
  Result:=true;
end;

{$ENDREGION}


end.
