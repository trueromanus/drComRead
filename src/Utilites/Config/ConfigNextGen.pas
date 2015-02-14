{
  drComRead

  Модуль с главной формой

  Copyright (c) 2009-2012 Romanus
}
unit ConfigNextGen;

interface

uses
  Windows, SysUtils, Classes,  Controls, Forms,
  ComCtrls, ExtCtrls, Main.Background, Main.ScaleMode, Main.TwoPage,
  Main.ActiveScroll, Main.WindowAndLanguage, Main.Navigate, History.Bookmarks,
  ColorCorrectMain, Archives.Sort, Archives.Main, History.History;

type
  TFormConfig = class(TForm)
    TreeViewNavigate: TTreeView;
    Panel_FrameArea: TPanel;
    MainScaleMode: TScaleMode;
    MainBackground: TMainBackground;
    MainActiveScroll: TMainActiveScroll;
    MainTwoPage: TMainTwopage;
    WindowAndLanguage: TMainWindowAndLanguage;
    MainNavigate: TMainNavigate;
    HistoryBookmark: THistoryBookmark;
    ColorCorrectMain: TFrameColorCorrectMain;
    ArchiveSort: TFrameArchiveSort;
    ArchiveMain: TFrameArchiveMain;
    FrameHistory: TFrameHistory;
    procedure FormCreate(Sender: TObject);
    procedure TreeViewNavigateChange(Sender: TObject; Node: TTreeNode);
    procedure TreeViewNavigateClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    //последний отображаемый фрейм
    FLastVisibleFrame:TFrame;
    //загружаем язык
    procedure LoadLanguage;
  public
    //страница по уомлчанию открытая сразу
    DefaultPage:string;
  end;

var
  FormConfig: TFormConfig;

//отображаем диалог на определенной
//странице
function ShowConfigFormDialog(Page:PWideChar):Boolean;stdcall;

implementation

{$R *.dfm}

uses
  ConfigSynchronized, MainProgramHeader, ConfigGlobal;

//загружаем язык
procedure TFormConfig.FormKeyPress(Sender: TObject; var Key: Char);
begin
  //ToDo:сделать проверки на измененные
  //группы настроек
  if Key = #27 then
    Close;
end;

procedure TFormConfig.FormShow(Sender: TObject);
var
  PageIndex:Integer;
  Item:TTreeNode;
begin
  if DefaultPage = '' then
    DefaultPage:='MainScaleMode';

  PageIndex:=ConfigList.GetFrameIndex(DefaultPage);
  if PageIndex <> -1 then
  begin
    for Item in TreeViewNavigate.Items do
    begin
      if Item.ImageIndex = PageIndex then
      begin
        TreeViewNavigate.Select(Item);
        Break;
      end;
    end;
  end;
end;

procedure TFormConfig.LoadLanguage;
begin
  Caption:=LangArrayValue('main_title');
  TreeViewNavigate.Items[0].Text:=LangArrayValue('mainoptions_vk');
  TreeViewNavigate.Items[1].Text:=LangArrayValue('scalemode_vk');
  TreeViewNavigate.Items[2].Text:=LangArrayValue('windowbackground_vk');
  TreeViewNavigate.Items[3].Text:=LangArrayValue('activescroll_vk');
  TreeViewNavigate.Items[4].Text:=LangArrayValue('windowandlanguage_vk');
  TreeViewNavigate.Items[5].Text:=LangArrayValue('twopages_vk');
  TreeViewNavigate.Items[6].Text:=LangArrayValue('navigate_vk');
  TreeViewNavigate.Items[7].Text:=LangArrayValue('historybookmark_vk');
  TreeViewNavigate.Items[8].Text:=LangArrayValue('bookmark_vk');
  TreeViewNavigate.Items[9].Text:=LangArrayValue('history_vk');
  TreeViewNavigate.Items[10].Text:=LangArrayValue('arcoptions_vk');
  TreeViewNavigate.Items[11].Text:=LangArrayValue('main_vk');
  TreeViewNavigate.Items[12].Text:=LangArrayValue('sorting_vk');
  TreeViewNavigate.Items[13].Text:=LangArrayValue('coloroptions_vk');
  TreeViewNavigate.Items[14].Text:=LangArrayValue('main_vk');
end;

procedure TFormConfig.FormCreate(Sender: TObject);
var
  TreeNode:TTreeNode;
begin
  LoadLanguage;
  FLastVisibleFrame:=nil;
  //открываем все регионы
  for TreeNode in TreeViewNavigate.Items do
    TreeNode.Expanded:=true;
end;

procedure TFormConfig.TreeViewNavigateChange(Sender: TObject; Node: TTreeNode);
var
  Frame:TFrame;
begin
  if Node.ImageIndex <= 0 then
    Exit;

  Frame:=ConfigList.GetFrame(Node.ImageIndex);

  //если он уже открыт
  //ничего не делаем
  if (FLastVisibleFrame <> nil) and (FLastVisibleFrame.Name = Frame.Name) then
    Exit;

  //скрываем старый
  if FLastVisibleFrame <> nil then
    FLastVisibleFrame.Visible:=false;

  //отображаем необходимый
  Frame.Visible:=true;
  FLastVisibleFrame:=Frame;
end;

procedure TFormConfig.TreeViewNavigateClick(Sender: TObject);
begin
  if TreeViewNavigate.Selected.Level = 0 then
  begin
    TreeViewNavigate.Select(TreeViewNavigate.Selected.Item[0]);
    Exit;
  end;
end;

//отображаем диалог на определенной
//странице
function ShowConfigFormDialog(Page:PWideChar):Boolean;stdcall;
begin
  //инициализируем ссылки
  InitLinks;
  //грузим курсоры
  CursorsLoading;
  //инициализация списка
  InitConfigList;
  //инициализацию формы
  FormConfig:=TFormConfig.Create(nil);
  FormConfig.DefaultPage:=Page;
  FormConfig.ShowModal;
  FormConfig.Free;
end;

end.
