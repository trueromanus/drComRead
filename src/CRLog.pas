{
  drComRead

  Модуль общего
  логирования всего приложения

  Copyright (c) 2012 Romanus
}
unit CRLog;

interface

uses
  Classes, CRDataBase;

type

  //режим постообработки
  TCRLogModePost = (lmNone,lmEmail,lmHttp);

  //класс лога
  TCRLog = class
  private
    //постообработка
    FPost:TCRLogModePost;
    //доступ к базе данных
    FDataBase:TCRLogDataBase;
  protected
    //постообработка
    //сообщения
    procedure PostEvent;
  public
    //конструктор
    constructor Create(Post:TCRLogModePost);
    //конструктор
    destructor Destroy;override;
    //печать в лог сообщения
    procedure Print(Msg:String;Group:String);
    //печать в лог сообщения об ошибке
    procedure PrintError(Msg:String;Group:String);
    //печать в лог системного сообщения
    procedure PrintSystem(Msg:String);
    //печать в лог критической ошибки
    procedure PrintCritical(Msg:String;Group:String);
  end;

implementation

uses
  SysUtils, CRGlobal;

//постообработка
//сообщения
procedure TCRLog.PostEvent;
begin
  case FPost of
    //просто в файл
    lmNone:;
    //почта
    lmEmail:;
    //отослать на сайт
    lmHttp:;
  end;

end;

//конструктор
constructor TCRLog.Create(Post:TCRLogModePost);
begin
  FPost:=Post;
  FDataBase:=TCRLogDataBase.Create(PathToProgramDir);
end;

//конструктор
destructor TCRLog.Destroy;
begin
  FDataBase.Free;
  inherited Destroy;
end;

//печать в лог сообщения
procedure TCRLog.Print(Msg:String;Group:String);
begin
  if Group <> '' then
    FDataBase.CreateRoutineMessage(Msg,Group)
  else
    FDataBase.CreateRoutineMessage(Msg);
end;

//печать в лог сообщения об ошибке
procedure TCRLog.PrintError(Msg:String;Group:String);
begin
  if Group <> '' then
    FDataBase.CreateErrorMessage(Msg,Group)
  else
    FDataBase.CreateErrorMessage(Msg);
end;

//печать в лог системного сообщения
procedure TCRLog.PrintSystem(Msg:String);
begin
  FDataBase.CreateSystemMessage(Msg);
end;

//печать в лог критической ошибки
procedure TCRLog.PrintCritical(Msg:String;Group:String);
begin
  if Group <> '' then
    FDataBase.CreateCriticalMessage(Msg,Group)
  else
    FDataBase.CreateCriticalMessage(Msg);
end;

end.
