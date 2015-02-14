unit CRPHardwareInfo;

interface

type
  TCPUInfo = packed record
    IDString : array [0..11] of AnsiChar;
    Stepping : Integer;
    Model    : Integer;
    Family   : Integer;
    FPU,
    VirtualModeExtensions,
    DebuggingExtensions,
    PageSizeExtensions,
    TimeStampCounter,
    K86ModelSpecificRegisters,
    MachineCheckException,
    CMPXCHG8B,
    APIC,
    MemoryTypeRangeRegisters,
    GlobalPagingExtension,
    ConditionalMoveInstruction,
    MMX     : Boolean;
    SYSCALLandSYSRET,
    FPConditionalMoveInstruction,
    AMD3DNow : Boolean;
    CPUName : AnsiString;
  end;

//поддерживает ли процессор 64 битный режим
function Is64bitAvail:Boolean;assembler;
function ExistCPUID:Boolean;
function CPUIDInfo(out info: TCPUInfo):Boolean;
function ExistMMX:Boolean;
procedure EMMS;
procedure FEMMS;

implementation

//поддерживает ли процессор 64 битный режим
function Is64bitAvail:Boolean;assembler;
asm
  mov eax, $80000001
  cpuid
  mov eax, 1
  shl eax, 29
  and edx, eax
  mov eax, edx
end;

function ExistCPUID : Boolean;
asm
  pushfd
  pop eax
  mov ebx, eax
  xor eax, 00200000h
  push eax
  popfd
  pushfd
  pop ecx
  mov eax,0
  cmp ecx, ebx
  jz @NO_CPUID
  inc eax
  @NO_CPUID:
end;

function CPUIDInfo(out info: TCPUInfo):Boolean;

  function ExistExtendedCPUIDFunctions:Boolean;
  asm
    mov eax,080000000h
    db $0F,$A2
  end;

var
  name : array [0..47] of AnsiChar;
  p : Pointer;
begin
  if ExistCPUID then asm
    jmp @Start
    @BitLoop:
    mov al,dl
    and al,1
    mov [edi],al
    shr edx,1
    inc edi
    loop @BitLoop
    ret
    @Start:
    mov edi,info
    mov eax,0
    db $0F,$A2
    mov [edi],ebx
    mov [edi+4],edx
    mov [edi+8],ecx
    mov eax,1
    db $0F,$A2
    mov ebx,eax
    and eax,0fh;
    mov [edi+12],eax;
    shr ebx,4
    mov eax,ebx
    and eax,0fh
    mov [edi+12+4],eax
    shr ebx,4
    mov eax,ebx
    and eax,0fh
    mov [edi+12+8],eax
    add edi,24
    mov ecx,6
    call @BitLoop
    shr edx,1
    mov ecx,3
    call @BitLoop
    shr edx,2
    mov ecx,2
    call @BitLoop
    shr edx,1
    mov ecx,1
    call @BitLoop
    shr edx,7
    mov ecx,1
    call @BitLoop
    mov p,edi
  end;
  if (info.IDString = 'AuthenticAMD') and ExistExtendedCPUIDFunctions then
  begin
  asm
    mov edi,p
    mov eax,080000001h
    db $0F,$A2
    mov eax,edx
    shr eax,11
    and al,1
    mov [edi],al
    mov eax,edx
    shr eax,16
    and al,1
    mov [edi+1],al
    mov eax,edx
    shr eax,31
    and al,1
    mov [edi+2],al
    lea edi,name
    mov eax,0
    mov [edi],eax
    mov eax,080000000h
    db $0F,$A2
    cmp eax,080000004h
    jl @NoString
    mov eax,080000002h
    db $0F,$A2
    mov [edi],eax
    mov [edi+4],ebx
    mov [edi+8],ecx
    mov [edi+12],edx
    add edi,16
    mov eax,080000003h
    db $0F,$A2
    mov [edi],eax
    mov [edi+4],ebx
    mov [edi+8],ecx
    mov [edi+12],edx
    add edi,16
    mov eax,080000004h
    db $0F,$A2
    mov [edi],eax
    mov [edi+4],ebx
    mov [edi+8],ecx
    mov [edi+12],edx
    @NoString:
  end;
  info.CPUName:=name;
  end else
  with info do
  begin
    SYSCALLandSYSRET:=False;
    FPConditionalMoveInstruction:=False;
    CPUName:='';
  end;
  Result:=ExistCPUID;
end;

function ExistMMX:Boolean;
var
  info : TCPUInfo;
begin
  if CPUIDInfo(info) then
    Result:=info.MMX
  else
    Result:=False;
end;

procedure EMMS;
asm
  db $0F,$77
end;

procedure FEMMS;
asm
  db $0F,$03
end;

end.
