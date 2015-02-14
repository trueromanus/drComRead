{
  drComRead

  History library

  ������ ��� ��������
  ������ ������ �������
  � ���� ������ ��������

  Copyright (c) 2010-2011 Romanus
}
unit CRExports;

interface

type
  //��� ��� ����������� ����������
  //������� ���������
  TDirHistoryArray = array of PWideChar;
  //������ � ���������
  TIndexHistoryArray = array of Integer;

  //��������� �������
  TResultDialog = record
    //���� ��������� �����������
    Complete:Boolean;
    //��� ������������ �����
    TypeDate:Byte;
    //��� �����
    NameFile:PWideChar;
    //������������� ������
    IDRecord:Integer;
  end;

{$REGION '��������'}

//���� ��������
//��� �������� ������
//���� ������� ����������
//������ ��� ����� �����������
//�� ������
function FindBookmarkArchive(Name:PWideChar;FullPathMode:Boolean):PWideChar;stdcall;
//���� ��� ��������
//��� �������� ������
//� ���������� ��
//� ���� ������� �� ��������
function FindAllBookmarkArchive(Name:PWideChar;FullPathMode:Boolean):TDirHistoryArray;stdcall;
//��������� �������� ��
//����� � ������� ����
//��� ��� ����������
//�������������� ������
function AddBookmarkArchive(Name,NamePage:PWideChar):Boolean;stdcall;
//������� �������� �� �����
//�� ������� ����� ��� ������ ����� �����
function DeleteBookmarkArchive(Name:PWideChar;FullPathMode:Boolean):Boolean;stdcall;
//������� �������� �� �����
//�� ������� ���� � ����� ��������
function DeleteBookmarkArchivePage(Name:PWideChar;NamePage:PWideChar):Boolean;stdcall;

{$ENDREGION}

{$REGION '������� ���������'}

//���������� ���������
//����������� �����
function FindHistoryDirLast(CountRes:Integer):TIndexHistoryArray;stdcall;
//���� �� �������
function FindHistoryDirIndex(Index:Integer):PWideChar;stdcall;
//��������� � �������
//�����
function AddHistoryDir(Dir:PWideChar):Boolean;stdcall;

{$ENDREGION}

{$REGION '������� �������'}

//���� ��������� ������ � �������
function FindHistoryArcLast(CountRes:Integer):TIndexHistoryArray;stdcall;
//�������� �� ������� ������ ����
function FindHistoryArcIndex(Index:Integer):PWideChar;stdcall;
//��������� ����� �
//�������
function AddHistoryArc(Dir:PWideChar):Boolean;stdcall;

{$ENDREGION}

{$REGION '��������� � �������� ��������'}

//�������� ��� �������
//���� ���� ������ �
//����������� � ��� ������
function InitDataBase:Boolean;stdcall;
function DeInitDataBase:Boolean;stdcall;

{$ENDREGION}

{$REGION '������ �������'}

//���������� ������ �������
function ShowDialogHistory:TResultDialog;stdcall;

{$ENDREGION}

implementation

uses
  MainProgramHeader,
  CRGlobal,historyform,
  SQLiteTable3,Forms,Controls,
  Windows, SysUtils, Classes;

{$REGION '��������'}

var
  BookmarksStrings:TStrings;

function GetUTF8(Str:String):PWideChar;
begin
  Result:=PWideChar(UTF8ToString(RawByteString(Str)));
end;

//���� ��������� ��������
//��� �������� ������
//���� ������� ����������
//������ ��� ����� �����������
//�� ������
function FindBookmarkArchive(Name:PWideChar;FullPathMode:Boolean):PWideChar;
var
  Table:TSQLIteTable;
begin
  if FullPathMode then
  begin
    //���� �� ������� ����
    Table:=SQLSelect(
        'SELECT NamePage FROM bookmarks ' +
        'WHERE FullPath=' + SQLStringFormat(Name) + ' ' +
        'ORDER BY DateRecord DESC'
      );
    if Table.Count>0 then
      Exit(GetUTF8(Table.FieldAsString(Table.FieldIndex['NamePage'])));
  end else
  begin
    //���� ������ �� ����� �����
    Table:=SQLSelect(
        'SELECT NamePage FROM bookmarks ' +
        'WHERE FileName=' + SQLStringFormat(SysUtils.ExtractFileName(Name))
      );
    if Table.Count>0 then
      Exit(GetUTF8(Table.FieldAsString(Table.FieldIndex['NamePage'])));
  end;
  Result:='';
end;

procedure SqlSelectIteration(Table:TSQLiteTable);
begin
  //�������� ����������
  //�� ���� ����� ���
  //����� ������ :)
  BookmarksStrings.Add
    (
      GetUTF8
        (
          Table.FieldAsString(Table.FieldIndex['NamePage'])
        )
    );
end;

//���� ��� ��������
//��� �������� ������
//� ���������� ��
//� ���� ������� �� ��������
function FindAllBookmarkArchive(Name:PWideChar;FullPathMode:Boolean):TDirHistoryArray;
var
  SqlReq:String;
  GetPos:Integer;
begin
  //�������� ������ �������
  if FullPathMode then
  begin
    SqlReq:='SELECT NamePage FROM bookmarks ' +
            'WHERE FullPath=' + SQLStringFormat(Name) + ' ' +
            'ORDER BY DateRecord DESC';
  end else
  begin
    SqlReq:='SELECT NamePage FROM bookmarks ' +
            'WHERE FileName=' + SQLStringFormat(SysUtils.ExtractFileName(Name)) + ' ' +
            'ORDER BY DateRecord DESC'
  end;
  BookmarksStrings:=TStringList.Create;
  SQLSelectFor(SqlReq,SqlSelectIteration);
  //ToDo:���������� ������ ��
  //������ � �������� ������
  SetLength(Result,BookmarksStrings.Count);
  for GetPos:=0 to BookmarksStrings.Count-1 do
    Result[GetPos]:=PWideChar(BookmarksStrings[GetPos]);
  BookmarksStrings.Free;
end;

//��������� �������� ��
//����� � ������ ����
//��� ��� ����������
//�������������� ������
function AddBookmarkArchive(Name,NamePage:PWideChar):Boolean;
var
  Table:TSQLIteTable;
  UpdateId:String;
begin
  try
    //������ ��������� � �� ������
    //� �� �������� �.�. ��������
    //������ �������������
    Table:=SQLSelect(
        'SELECT ID FROM bookmarks ' +
        'WHERE FullPath=' + SQLStringFormat(Name) + ' ' +
        'AND NamePage=' + SQLStringFormat(NamePage)
      );
    //���� ����� ��� ����
    //�� ������������ ���
    if Table.Count <> 0 then
    begin
      UpdateId:=Table.FieldAsString(Table.FieldIndex['ID']);
      SQLRequest(
          'UPDATE bookmarks SET FullPath=' + SQLStringFormat(Name) + ' ' +
          ',FileName=' + SQLStringFormat(ExtractFileName(Name)) + ' ' +
          ',DateRecord=DATETIME(' + SQLStringFormat('NOW') + ') ' +
          ',NamePage=' + SQLStringFormat(NamePage) + ' ' +
          'WHERE ID=' + UpdateId
        );
    end else
    begin
      //���� ������ ���
      //�� ������� ������
      SQLRequest(
          'INSERT INTO bookmarks (FullPath,FileName,DateRecord,NamePage) VALUES ('
          + SQLStringFormat(Name) + ','
          + SQLStringFormat(ExtractFileName(Name)) + ',' +
          'DATETIME(' + SQLStringFormat('NOW') + '),'
          + SQLStringFormat(NamePage) + ')'
        );
    end;
  except
    Exit(false);
  end;
  Result:=true;
end;

//������� �������� �� �����
//�� ������� ���� ��� ������ ����� �����
function DeleteBookmarkArchive(Name:PWideChar;FullPathMode:Boolean):Boolean;
begin
  if FullPathMode then
    Result:=SQLRequest('DELETE FROM bookmarks WHERE FullPath=' + SQLStringFormat(Name))
  else
    Result:=SQLRequest('DELETE FROM bookmarks WHERE FileName=' + SQLStringFormat(Name));
end;

//������� �������� �� �����
//�� ������� ���� � ����� ��������
function DeleteBookmarkArchivePage(Name:PWideChar;NamePage:PWideChar):Boolean;
begin
  Result:=SQLRequest
    (
      'DELETE FROM bookmarks WHERE FullPath=' + SQLStringFormat(Name) +
      ' AND NamePage=' + SQLStringFormat(NamePage)
    );
end;


{$ENDREGION}

{$REGION '������� ���������'}

//���������� ���������
//����������� �����
function FindHistoryDirLast(CountRes:Integer):TIndexHistoryArray;
var
  GetPos:Integer;
begin
  with SQLSelect('SELECT ID,FullPath FROM historydir ORDER BY DateRecord DESC LIMIT ' + IntToStr(CountRes)) do
  begin
    if Count = 0 then
      Exit(nil);
    SetLength(Result,Count+1);
    //����� ������
    Result[0]:=FieldAsInteger(FieldIndex['ID']);
    GetPos:=1;
    while Next and not EOF do
    begin
      Result[GetPos]:=FieldAsInteger(FieldIndex['ID']);
      Inc(GetPos);
    end;
  end;
end;

//���� �� �������
function FindHistoryDirIndex(Index:Integer):PWideChar;
begin
  with SQLSelect('SELECT ID,FullPath FROM historydir WHERE ID=' + IntToStr(Index)) do
  begin
    if Count = 0 then
      Exit(PWideChar(''));
    Result:=GetUTF8(FieldAsString(FieldIndex['FullPath']))
  end;
end;

//��������� � �������
//�����
function AddHistoryDir(Dir:PWideChar):Boolean;
begin
  with SQLSelect('SELECT FullPath FROM historydir WHERE FullPath=' +
                SQLStringFormat(Dir)) do
  begin
    if Count = 0 then
    begin
      SQLRequest('INSERT INTO historydir (FullPath,DateRecord) VALUES (' +
        SQLStringFormat(Dir) + ',datetime(' + SQLStringFormat('now') + '))'
        );
    end else
    begin
      SQLRequest('UPDATE historydir SET FullPath='+SQLStringFormat(Dir)+',' +
        'DateRecord=datetime(' + SQLStringFormat('now') + ') WHERE ' +
        'FullPath='+SQLStringFormat(Dir)
        );
    end;
  end;
  Exit(true);
end;

{$ENDREGION}

{$REGION '������� �������'}

//���� ��������� ������ � �������
function FindHistoryArcLast(CountRes:Integer):TIndexHistoryArray;
var
  GetPos:Integer;
begin
  with SQLSelect('SELECT ID,FullPath FROM historyarchives ORDER BY DateLastOpened DESC LIMIT ' + IntToStr(CountRes)) do
  begin
    if Count = 0 then
      Exit(nil);
    SetLength(Result,Count+1);
    //����� ������
    Result[0]:=FieldAsInteger(FieldIndex['ID']);
    //����� ���������
    GetPos:=1;
    while Next and not EOF do
    begin
      Result[GetPos]:=FieldAsInteger(FieldIndex['ID']);
      Inc(GetPos);
    end;
  end;
end;

//�������� �� ������� ������ ����
function FindHistoryArcIndex(Index:Integer):PWideChar;
begin
  with SQLSelect('SELECT FullPath FROM historyarchives WHERE ID=' + IntToStr(Index)) do
  begin
    if Count = 0 then
      Exit(PWideChar(''));
    Result:=GetUTF8(FieldAsString(FieldIndex['FullPath']));
  end;
end;

//��������� ����� �
//�������
function AddHistoryArc(Dir:PWideChar):Boolean;
begin
  with SQLSelect('SELECT FullPath FROM historyarchives WHERE FullPath=' +
                SQLStringFormat(Dir)) do
  begin
    if Count = 0 then
    begin
      SQLRequest('INSERT INTO historyarchives (FullPath,DateLastOpened) VALUES (' +
        SQLStringFormat(Dir) + ',datetime(' + SQLStringFormat('now') + '))'
        );
    end else
    begin
      SQLRequest('UPDATE historyarchives SET FullPath='+SQLStringFormat(Dir)+
        ',DateLastOpened=datetime('+SQLStringFormat('now')+') WHERE ' +
        'FullPath='+SQLStringFormat(Dir)
        );
    end;
  end;
  Result:=true;
end;

{$ENDREGION}

{$REGION '��������� � �������� ��������'}

//���������� ���� �
//��������� ��������� �����
function GetWindowsTempPath:String;
var
  pTempPath:PChar;
begin
  pTempPath := StrAlloc(MAX_PATH + 1);
  GetTempPath(MAX_PATH+1, pTempPath);
  Result := string(pTempPath);
  StrDispose(pTempPath);
end;

//�������� ��� �������
//���� ���� ������ �
//����������� � ��� ������
function InitDataBase:Boolean;stdcall;
begin
  try
    HistoryDataBase:=TSQLiteDatabase.Create(GetWindowsTempPath + 'history.db');
    //������� ��� �������� ��������
    if not HistoryDataBase.TableExists('bookmarks') then
    begin
      HistoryDataBase.BeginTransaction;
      //FullPath - ������ ����
      //FileName - ������ ��� �����
      //DateRecord - ���� ������
      //NamePage - ��� ��������
      HistoryDataBase.ExecSQL(
        'CREATE TABLE bookmarks '+
        '([ID] INTEGER PRIMARY KEY AUTOINCREMENT,[FullPath] TEXT,' +
        '[FileName] TEXT NOT NULL,[DateRecord] DATE NOT NULL,[NamePage] TEXT);'
      );
      //������� �������
      HistoryDataBase.ExecSQL(
        'CREATE INDEX idbookmarks ON [bookmarks]([ID]); '
      );
      HistoryDataBase.ExecSQL(
        'CREATE INDEX fpbookmarks ON [bookmarks]([FullPath]); '
      );
      HistoryDataBase.ExecSQL(
        'CREATE INDEX fnbookmarks ON [bookmarks]([FileName]); '
      );
      HistoryDataBase.ExecSQL(
        'CREATE INDEX npbookmarks ON [bookmarks]([NamePage]); '
      );
      HistoryDataBase.ExecSQL(
        'CREATE INDEX drbookmarks ON [bookmarks]([DateRecord]); '
      );
      HistoryDataBase.Commit;
    end;
    //������� ��� �������� ���������
    if not HistoryDataBase.TableExists('historydir') then
    begin
      //FullPath - ������ ����
      //DateRecord - ���� ������
      HistoryDataBase.BeginTransaction;
      HistoryDataBase.ExecSQL(
        'CREATE TABLE historydir '+
        '([ID] INTEGER PRIMARY KEY AUTOINCREMENT,[FullPath] TEXT,' +
        '[DateRecord] DATETIME NOT NULL);'
      );
      HistoryDataBase.ExecSQL(
        'CREATE INDEX fpindex ON [historydir]([ID]); '
      );
      HistoryDataBase.ExecSQL(
        'CREATE INDEX fphistory ON [historydir]([FullPath]); '
      );
      HistoryDataBase.ExecSQL(
        'CREATE INDEX drhistory ON [historydir]([DateRecord]); '
      );
      HistoryDataBase.Commit;
    end;
    //������� ��� �������� �������
    if not HistoryDataBase.TableExists('historyarchives') then
    begin
      //FullPath - ������ ����
      //DateRecord - ���� ������
      HistoryDataBase.BeginTransaction;
      HistoryDataBase.ExecSQL(
        'CREATE TABLE historyarchives '+
        '([ID] INTEGER PRIMARY KEY AUTOINCREMENT,[FullPath] TEXT,' +
        '[DateLastOpened] DATETIME NOT NULL);'
      );
      HistoryDataBase.ExecSQL(
        'CREATE INDEX dlohistoryarc ON [historyarchives]([DateLastOpened]); '
      );
      HistoryDataBase.ExecSQL(
        'CREATE INDEX fpohistoryarc ON [historyarchives]([FullPath]); '
      );
      HistoryDataBase.ExecSQL(
        'CREATE INDEX indexohistoryarc ON [historyarchives]([ID]); '
      );
      HistoryDataBase.Commit;
    end;
  except
    Exit(false);
  end;
  Result:=true;
end;

function DeInitDataBase:Boolean;
begin
  if Assigned(HistoryDataBase) then
  begin
    HistoryDataBase.Free;
    Exit(true);
  end;
  Result:=false;
end;

{$ENDREGION}

{$REGION '������ �������'}

//���������� ������ �������
function ShowDialogHistory:TResultDialog;
begin
  //������������� ������
  InitLinks;
  CursorsLoading;
  //������� � ��������� ������
  //�� ����
  HistoryDialog:=THistoryDialog.Create(nil);
  HistoryDialog.UpdateAll;
  LoadLanguage;
  if HistoryDialog.ShowModal = 1 then
  begin
    with HistoryDialog do
    begin
      Result.TypeDate:=MainTabs.ActivePageIndex;
      case MainTabs.ActivePageIndex of
        //������� �������
        0:
          begin
            Result.NameFile:=PWideChar(GetArchiveRecord(ArchiveListBox.ItemIndex).FullArcPath);
            Result.IDRecord:=GetArchiveRecord(ArchiveListBox.ItemIndex).IdRecord;
          end;
        //������� ���������
        1:
          begin
            Result.NameFile:=PWideChar(DirListBox.Items.Strings[DirListBox.ItemIndex]);
          end;
        //��������
        2:
          begin
            Result.NameFile:=PWideChar(GetBookmarkRecord(BookmarksListBox.ItemIndex).FullArcPath);
            Result.IDRecord:=GetBookmarkRecord(BookmarksListBox.ItemIndex).IdRecord;
          end;
      end;
    end;
    Result.Complete:=true;
  end else
  begin
    Result.Complete:=false;
    Result.TypeDate:=255;
    Result.NameFile:=PWideChar('');
    Result.IDRecord:=-1;
  end;
  //������ �� �����
  HistoryDialog.Free;
end;

{$ENDREGION}

end.
