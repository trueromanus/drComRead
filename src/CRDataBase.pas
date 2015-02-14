{
  drComRead

  ������ ����������� ������
  ������� �� �����������
  �������� �������� ���� ������
  ���������

  Copyright (c) 2012 Romanus
}
unit CRDataBase;

interface

uses
  SysUtils, Generics.Collections,
  SQLiteTable3, SQLiteUtils;

const
  //����� ����� ���������
  CRLogMessageTypeNames:array[0..3] of string = ('system','routine','error','critical');

type

  {$REGION '���� ������ �����������'}

  //��� ��������� ����
  TCRLogMessageType = (lmtSystem,lmtRoutine,lmtError,lmtCritical);

  TCRLogDataBase = class
  private
    //������������� ������
    FIDSession:Integer;
    //��������� ������������� ��������������
    FIDSessionString:String;
    //������ �� �������� ���������
    FEndedMessage:Boolean;
    //���������� ������� ���������� � �������
    FCurrentTransactions:Integer;
  public
    //�����������
    constructor Create(PathToProgram:String);overload;
    //�����������
    constructor Create(Id:Integer);overload;
    //����������
    destructor Destroy;override;
    //������� ������� ���������
    procedure CreateMessage(Msg:String;Tag:String;Group:String);
    //������� ������� ���������
    procedure CreateRoutineMessage(Msg:String;const Group:string = 'nongroup');
    //������� ��������� ���������
    procedure CreateSystemMessage(Msg:String);
    //������� ��������� �� ������
    procedure CreateErrorMessage(Msg:String;const Group:string = 'nongroup');
    //������� ����������� ��������� �� ������
    procedure CreateCriticalMessage(Msg:String;const Group:string = 'nongroup');
  end;

  {$ENDREGION}

  {$REGION '���� ������ �������������� ������'}

  TCRMultiLanguageElement = class
  public

  end;
  TCRMultiLanguageDataBase = class
  private
    //������� ��������� ����
    FCurrentLanguage:Integer;
  public
    //�����������
    constructor Create;
    //����������
    destructor Destroy;override;
    //�������� ��� ��������� �����
    //function GetAllLanguages:TObjectList<TCRMultiLanguageElement>;
  end;

  {$ENDREGION}

  {$REGION '���� ������ ��������'}

  TCRSettingsDataBase = class
  private
    //������� �������
    FCurrentProfile:Integer;
    FCurrentProfileString:String;
  protected
    //���� ������� �������� ��������
    procedure FindCurrentProfile;
  public
    //�����������
    constructor Create;
    //����������
    destructor Destroy;override;
  end;

  {$ENDREGION}

//������������� ���� ������ ���������
procedure InitDataBaseAtProgram;
//��������������� ���� ������ ���������
procedure DeinitDataBaseAtProgram;

implementation

uses
  CRGlobal;


{$REGION '���� ������ �����������'}

//�����������
constructor TCRLogDataBase.Create(PathToProgram:String);
var
  Table:TSQLiteTable;
begin
  //����� ����� ����� �����������
  Insert('log','[PathToProgram],[DateRecord]',SQLFormat(PathToProgram) + ',' + SQLFormatNow);
  //�������� ��� �������������
  Table:=Select('log','ID','','ID DESC');
  FIDSession:=Table.FieldAsInteger(0);
  FIDSessionString:=IntToStr(FIDSession);
  Table.Free;
  FEndedMessage:=true;
end;

//�����������
constructor TCRLogDataBase.Create(Id:Integer);
begin
  FIDSession:=Id;
  FIDSessionString:=IntToStr(FIDSession);
  FEndedMessage:=false;
end;

//����������
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

//������� ������� ���������
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

//������� ������� ���������
procedure TCRLogDataBase.CreateRoutineMessage(Msg:String;const Group:string = 'nongroup');
begin
  CreateMessage(Msg,CRLogMessageTypeNames[1],Group);
end;

//������� ��������� ���������
procedure TCRLogDataBase.CreateSystemMessage(Msg:String);
begin
  CreateMessage(Msg,CRLogMessageTypeNames[0],'');
end;

//������� ��������� �� ������
procedure TCRLogDataBase.CreateErrorMessage(Msg:String;const Group:string = 'nongroup');
begin
  CreateMessage(Msg,CRLogMessageTypeNames[2],Group);
end;

//������� ����������� ��������� �� ������
procedure TCRLogDataBase.CreateCriticalMessage(Msg:String;const Group:string = 'nongroup');
begin
  CreateMessage(Msg,CRLogMessageTypeNames[3],Group);
end;

{$ENDREGION}

{$REGION '���� ������ �������������� ������'}

//�����������
constructor TCRMultiLanguageDataBase.Create;
begin
  FCurrentLanguage:=-1;
end;

//����������
destructor TCRMultiLanguageDataBase.Destroy;
begin
  //ToDo:�� ��� ��� �������?
end;

{$ENDREGION}

{$REGION '���� ������ ��������'}

//���� ������� �������� ��������
procedure TCRSettingsDataBase.FindCurrentProfile;
var
  Table:TSQLiteTable;
begin
  Table:=Select('profiles','[ID]','[Current]=1');
  //���� ��� �������
  //�������� ������� ������� ������ ����������
  if Table.Count = 0 then
  begin
    Table.Free;
    Table:=Select('profiles','[ID]','[Current]<>1');
    if Table.Count = 0 then
      //ToDo:������� �������� �������
      //� ����������� �� ���������
  end else
  begin
    FCurrentProfile:=Table.FieldAsInteger(0);
    FCurrentProfileString:=IntToStr(FCurrentProfile);
  end;
end;

//�����������
constructor TCRSettingsDataBase.Create;
begin
  //���� ������� ������� ��������
  FindCurrentProfile;
end;

//����������
destructor TCRSettingsDataBase.Destroy;
begin

end;

{$ENDREGION}

//������������� ���� ������ ���������
procedure InitDataBaseAtProgram;
begin
  try
    ComReadDataBase:=TSQLiteDatabase.Create(PathToProgramDir + 'comread.dat');
  except
    raise Exception.Create('ComRead error init connect to database at path ' + PathToProgramDir);
  end;
  //������� ��� �����
  if not ComReadDataBase.TableExists('log') then
  begin
    ComReadDataBase.BeginTransaction;
    //������� log ����������
    //������ � ���������� ����
    //(��� �� ��� �� ������� ����)
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
    //������� logmessage ��������
    //������ � ���������� ����
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
  //������� ��� ��������
  if not ComReadDataBase.TableExists('settings') then
  begin
    ComReadDataBase.BeginTransaction;
    //������� settings ����������
    //������ � ���������� ���������
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
  //������� ��� �������������� ������
  if not ComReadDataBase.TableExists('languages') then
  begin
    ComReadDataBase.BeginTransaction;
    //������� languages ����������
    //������ � ��������� ������
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

//��������������� ���� ������ ���������
procedure DeinitDataBaseAtProgram;
begin
  ComReadDataBase.Free;
end;


end.
