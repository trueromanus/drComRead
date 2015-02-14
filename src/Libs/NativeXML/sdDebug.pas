{ unit sdDebug

  universal method for debugging

  Exceptions often are a hindrance, so instead use these classes
  to give important info to the application or user with these
  three basic classes

  Besides debug methods, this unit also defines a few D5 compatibility
  types. The include file simdesign.inc defines $D5UP and after the
  uses-clause these types for D5 are defined. This way, many simdesign
  projects are compatible with Delphi 5.

  Author: Nils Haeck M.Sc.
  Original Date: 08nov2010
  copyright (c) SimDesign BV (www.simdesign.nl)
}
unit sdDebug;

{$i simdesign.inc}

interface

uses
  Classes;

{$ifdef D5UP}
// D5 compatibility types
const
  MinsPerHour = 60;
  MinsPerDay = MinsPerHour * 24;
  soCurrent = soFromCurrent;
  soBeginning = soFromBeginning;
  soEnd = soFromEnd;
  
type
  Utf8String = AnsiString;
  TSeekOrigin = word;

  PIntegerArray = ^TIntegerArray;
  TIntegerArray = array of Integer;

  IInterface = IUnknown;

  PByte = ^Byte;
  PInteger = ^Integer;
  PSingle = ^Single;
  PDouble = ^Double;

  PWord= ^Word;

  function StrToFloatDef(S: AnsiString; Default: Double = 0): Double;
  function StrToBool(S: AnsiString): Boolean;
  function StrToBoolDef(S: AnsiString; Default: Boolean): Boolean;
{$endif}

type
  TsdWarnStyle = (wsInfo, wsHint, wsWarn, wsFail);

const
  cWarnStyleNames: array[TsdWarnStyle] of Utf8String = ('info', 'hint', 'warn', 'fail');

type
  // event with debug data
  TsdDebugEvent = procedure(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String) of object;

  // simple update event
  TsdUpdateEvent = procedure(Sender: TObject) of object;

  IDebugMessage = interface(IInterface)
    procedure DoDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
  end;

  TDebugComponent = class(TComponent)
  protected
    FOnDebugOut: TsdDebugEvent;
  public
    procedure DoDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String); virtual;
    property OnDebugOut: TsdDebugEvent read FOnDebugOut write FOnDebugOut;
  end;

  TDebugPersistent = class(TPersistent)
  protected
    FOwner: TDebugComponent;
    procedure DoDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String); virtual;
  end;

  TDebugObject = class(TObject)
  protected
    FOnDebugOut: TsdDebugEvent;
    procedure DoDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String); virtual;
  public
    property OnDebugOut: TsdDebugEvent read FOnDebugOut write FOnDebugOut;
  end;

implementation

{$ifdef D5UP}
// D5 compatibility types
uses SysUtils;

function StrToFloatDef(S: AnsiString; Default: Double = 0): Double;
begin
  try
    Result:= StrToFloat(S);
  except
    Result:= Default;
  end;
end;

// Only basic support
function StrToBool(S: AnsiString): Boolean;
begin
  S := LowerCase(S);
  if (S = 'no') or (S = '0') or (S = 'false') then
    Result := False
  else
    if (S = 'yes') or (S = '1') or (S = 'true') then
      Result:= True
    else
      raise EConvertError.Create('');
end;

function StrToBoolDef(S: AnsiString; Default: Boolean): Boolean;
begin
  try
    Result := StrToBool(S);
  except
    Result := Default;
  end;
end;
{$endif}

{ TDebugComponent }

procedure TDebugComponent.DoDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
begin
  if assigned(FOnDebugOut) then
    FOnDebugOut(Sender, WarnStyle, AMessage)
end;

{ TDebugPersistent }

procedure TDebugPersistent.DoDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
begin
  if FOwner is TDebugComponent then
    TDebugComponent(FOwner).DoDebugOut(Sender, WarnStyle, AMessage);
end;

{ TDebugObject }

procedure TDebugObject.DoDebugOut(Sender: TObject; WarnStyle: TsdWarnStyle; const AMessage: Utf8String);
begin
  if assigned(FOnDebugOut) then
    FOnDebugOut(Sender, WarnStyle, AMessage);
end;

end.


