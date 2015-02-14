{
  drComRead

  Модуль реализующий логику
  выборок по стандартным
  таблицам основной базы данных
  программы

  Copyright (c) 2012 Romanus
}
unit CRDataBase;

interface

uses
  SysUtils, Generics.Collections,
  SQLiteTable3, SQLiteUtils;

const
  //имена типов сообщений
  CRLogMessageTypeNames:array[0..3] of string = ('system','routine','error','critical');

type

  {$REGION 'База данных логирования'}

  //тип сообщения лога
  TCRLogMessageType = (lmtSystem,lmtRoutine,lmtError,lmtCritical);

  TCRLogDataBase = class
  private
    //идентификатор сеанса
    FIDSession:Integer;
    //строковое представление идентификатора
    FIDSessionString:String;
    //писать ли конечное сообщение
    FEndedMessage:Boolean;
    //количество текущий транзакций в очереди
    FCurrentTransactions:Integer;
  public
    //конструктор
    constructor Create(PathToProgram:String);overload;
    //конструктор
    constructor Create(Id:Integer);overload;
    //деструктор
    destructor Destroy;override;
    //создать простое сообщение
    procedure CreateMessage(Msg:String;Tag:String;Group:String);
    //создать обычное сообщение
    procedure CreateRoutineMessage(Msg:String;const Group:string = 'nongroup');
    //создать системное сообщение
    procedure CreateSystemMessage(Msg:String);
    //создать сообщение об ошибке
    procedure CreateErrorMessage(Msg:String;const Group:string = 'nongroup');
    //создать критическое сообщение об ошибке
    procedure CreateCriticalMessage(Msg:String;const Group:string = 'nongroup');
  end;

  {$ENDREGION}

  {$REGION 'База данных мультиязыковых данных'}

  TCRMultiLanguageElement = class
  public

  end;
  TCRMultiLanguageDataBase = class
  private
    //текущий выбранный язык
    FCurrentLanguage:Integer;
  public
    //конструктор
    constructor Create;
    //деструктор
    destructor Destroy;override;
    //получаем все доступные языки
    //function GetAllLanguages:TObjectList<TCRMultiLanguageElement>;
  end;

  {$ENDREGION}

  {$REGION 'База данных настроек'}

  TCRSettingsDataBase = class
  private
    //текущий профиль
    FCurrentProfile:Integer;
    FCurrentProfileString:String;
  protected
    //ищем текущий проифиль настроек
    procedure FindCurrentProfile;
  public
    //конструктор
    constructor Create;
    //деструктор
    destructor Destroy;override;
  end;

  {$ENDREGION}

//инициализация базы данных программы
procedure InitDataBaseAtProgram;
//деинициализация базы данных программы
procedure DeinitDataBaseAtProgram;

implementation

uses
  CRGlobal;


{$REGION 'База данных логирования'}

//конструктор
constructor TCRLogDataBase.Create(PathToProgram:String);
var
  Table:TSQLiteTable;
begin
  //пишем новый сеанс логирования
  Insert('log','[PathToProgram],[DateRecord]',SQLFormat(PathToProgram) + ',' + SQLFormatNow);
  //получаем его идентификатор
  Table:=Select('log','ID','','ID DESC');
  FIDSession:=Table.FieldAsInteger(0);
  FIDSessionString:=IntToStr(FIDSession);
  Table.Free;
  FEndedMessage:=true;
end;

//конструктор
constructor TCRLogDataBase.Create(Id:Integer);
begin
  FIDSession:=Id;
  FIDSessionString:=IntToStr(FIDSession);
  FEndedMessage:=false;
end;

//деструктор
destructor TCRLogDataBase.Destroy;
begin
  if not FEndedMessage then
    Exit;
  Insert(
    'logmessage',
    '[Message],[DateRecord],[Group],[Tag],[PLOG]',
    '''program session ended'',' + SQLFormatNow + ',''program'',''' + CRLogMessageTypeNames[0] + ''',' + FIDSessionString
  );
  if FCurrentTransactions <= 20 then
    ComReadDataBase.Commit;
end;

//создать простое сообщение
procedure TCRLogDataBase.CreateMessage(Msg:String;Tag:String;Group:String);
begin
  if FCurrentTransactions = 0 then
    ComReadDataBase.BeginTransaction;
  Insert(
    'logmessage',
    '[Message],[DateRecord],[Tag],[Group],[PLOG]',
    SQLFormat(Msg) + ',' + SQLFormatNow + ',' + SQLFormat(Tag) + ',' +
    SQLFormat(Group) + ',' + FIDSessionString
  );
  Inc(FCurrentTransactions);
  if FCurrentTransactions > 20 then
  begin
    FCurrentTransactions:=0;
    ComReadDataBase.Commit;
  end;
end;

//создать обычное сообщение
procedure TCRLogDataBase.CreateRoutineMessage(Msg:String;const Group:string = 'nongroup');
begin
  CreateMessage(Msg,CRLogMessageTypeNames[1],Group);
end;

//создать системное сообщение
procedure TCRLogDataBase.CreateSystemMessage(Msg:String);
begin
  CreateMessage(Msg,CRLogMessageTypeNames[0],'');
end;

//создать сообщение об ошибке
procedure TCRLogDataBase.CreateErrorMessage(Msg:String;const Group:string = 'nongroup');
begin
  CreateMessage(Msg,CRLogMessageTypeNames[2],Group);
end;

//создать критическое сообщение об ошибке
procedure TCRLogDataBase.CreateCriticalMessage(Msg:String;const Group:string = 'nongroup');
begin
  CreateMessage(Msg,CRLogMessageTypeNames[3],Group);
end;

{$ENDREGION}

{$REGION 'База данных мультиязыковых данных'}

//конструктор
constructor TCRMultiLanguageDataBase.Create;
begin
  FCurrentLanguage:=-1;
end;

//деструктор
destructor TCRMultiLanguageDataBase.Destroy;
begin
  //ToDo:ну что тут сделать?
end;

{$ENDREGION}

{$REGION 'База данных настроек'}

//ищем текущий проифиль настроек
procedure TCRSettingsDataBase.FindCurrentProfile;
var
  Table:TSQLiteTable;
begin
  Table:=Select('profiles','[ID]','[Current]=1');
  //если нет профиля
  //пытаемся сделать таковым первый попавшийся
  if Table.Count = 0 then
  begin
    Table.Free;
    Table:=Select('profiles','[ID]','[Current]<>1');
    if Table.Count = 0 then
      //ToDo:сделать создание профиля
      //с настройками по умолчанию
  end else
  begin
    FCurrentProfile:=Table.FieldAsInteger(0);
    FCurrentProfileString:=IntToStr(FCurrentProfile);
  end;
end;

//конструктор
constructor TCRSettingsDataBase.Create;
begin
  //ищем текущий профиль настроек
  FindCurrentProfile;
end;

//деструктор
destructor TCRSettingsDataBase.Destroy;
begin

end;

{$ENDREGION}

//инициализация базы данных программы
procedure InitDataBaseAtProgram;
begin
  try
    ComReadDataBase:=TSQLiteDatabase.Create(PathToProgramDir + 'comread.dat');
  except
    raise Exception.Create('ComRead error init connect to database at path ' + PathToProgramDir);
  end;
  //таблица для логов
  if not ComReadDataBase.TableExists('log') then
  begin
    ComReadDataBase.BeginTransaction;
    //Таблица log содержащая
    //записи о логическом логе
    //(как бы это не странно было)
    ComReadDataBase.ExecSQL(
      'CREATE TABLE log '+
      '([ID] INTEGER PRIMARY KEY AUTOINCREMENT,[PathToProgram] TEXT NOT NULL,' +
      '[DateRecord] DATE NOT NULL);'
    );
    ComReadDataBase.ExecSQL(
      'CREATE INDEX liindex ON [log]([ID]); '
    );
    ComReadDataBase.ExecSQL(
      'CREATE INDEX ldindex ON [log]([DateRecord]); '
    );
    ComReadDataBase.ExecSQL(
      'CREATE INDEX lpindex ON [log]([PathToProgram]); '
    );
    //Таблица logmessage содержит
    //записи о сообщениях лога
    ComReadDataBase.ExecSQL(
      'CREATE TABLE logmessage '+
      '([ID] INTEGER PRIMARY KEY AUTOINCREMENT,[Message] TEXT NOT NULL,' +
      '[DateRecord] DATE NOT NULL,[Tag] TEXT,[Group] TEXT,[PLOG] INTEGER NOT NULL);'
    );
    ComReadDataBase.ExecSQL(
      'CREATE INDEX lmiindex ON [logmessage]([ID]); '
    );
    ComReadDataBase.ExecSQL(
      'CREATE INDEX lmpiindex ON [logmessage]([PLOG]); '
    );
    ComReadDataBase.ExecSQL(
      'CREATE INDEX lmtindex ON [logmessage]([Tag]); '
    );
    ComReadDataBase.ExecSQL(
      'CREATE INDEX lmgindex ON [logmessage]([Group]); '
    );
    ComReadDataBase.Commit;
  end;
  //таблица для настроек
  if not ComReadDataBase.TableExists('settings') then
  begin
    ComReadDataBase.BeginTransaction;
    //Таблица settings содержащая
    //записи о настройках программы
    ComReadDataBase.ExecSQL(
      'CREATE TABLE settings '+
      '([Profile] INTEGER NOT NULL,[Group] TEXT NOT NULL,' +
      '[Name] TEXT NOT NULL,[Value] TEXT NOT NULL);'
    );
    ComReadDataBase.ExecSQL(
      'CREATE INDEX stgroup ON [settings]([Group]); '
    );
    ComReadDataBase.ExecSQL(
      'CREATE INDEX stname ON [settings]([Name]); '
    );
    ComReadDataBase.ExecSQL(
      'CREATE INDEX stprofile ON [settings]([Profile]); '
    );
    ComReadDataBase.ExecSQL(
      'CREATE TABLE profiles '+
      '([ID] INTEGER PRIMARY KEY AUTOINCREMENT,[Name] TEXT NOT NULL,[Current] TINYINT NOT NULL);'
    );
    ComReadDataBase.ExecSQL(
      'CREATE INDEX prindex ON [profiles]([ID]); '
    );
    ComReadDataBase.ExecSQL(
      'CREATE INDEX prname ON [profiles]([Name]); '
    );
    ComReadDataBase.ExecSQL(
      'CREATE INDEX prcurrent ON [profiles]([Current]); '
    );
    ComReadDataBase.Commit;
  end;
  //таблица для мультиязыковых данных
  if not ComReadDataBase.TableExists('languages') then
  begin
    ComReadDataBase.BeginTransaction;
    //Таблица languages содержащая
    //записи о доступных языках
    ComReadDataBase.ExecSQL(
      'CREATE TABLE languages '+
      '([LanguageEnglish] TEXT NOT NULL,[LanguageNative] TEXT NOT NULL,[Version] TEXT NOT NULL, [Current] TINYINT NOT NULL);'
    );
    ComReadDataBase.ExecSQL(
      'CREATE INDEX lnenglish ON [languages]([LanguageEnglish]); '
    );
    ComReadDataBase.ExecSQL(
      'CREATE INDEX lnversion ON [languages]([Version]); '
    );
    ComReadDataBase.ExecSQL(
      'CREATE INDEX lncurrent ON [languages]([Current]); '
    );
    ComReadDataBase.ExecSQL(
      'CREATE TABLE locales '+
      '([Language] TEXT NOT NULL,[Group] TEXT NOT NULL,' +
      '[Name] TEXT NOT NULL,[Locale] TEXT NOT NULL);'
    );
    ComReadDataBase.ExecSQL(
      'CREATE INDEX lolang ON [locales]([Language]); '
    );
    ComReadDataBase.ExecSQL(
      'CREATE INDEX logroup ON [locales]([Group]); '
    );
    ComReadDataBase.ExecSQL(
      'CREATE INDEX loname ON [locales]([Name]); '
    );

    ComReadDataBase.Commit;
  end;
  CurrentDataBase:=ComReadDataBase;
end;

//деинициализация базы данных программы
procedure DeinitDataBaseAtProgram;
begin
  ComReadDataBase.Free;
end;


end.
