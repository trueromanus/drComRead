; drComRead install script version 0.11

[Setup]
AppId={{CE8B8F34-DDC9-4419-A33E-A0A96AB85E41}
AppName=drComRead
AppVerName=drComRead version 0.13.1
AppPublisher=EmptyFlow
AppPublisherURL=http://drcomread.atticfloor.ru/
AppSupportURL=http://forum.atticfloor.ru/
AppUpdatesURL=http://drcomread.atticfloor.ru/downloads
DefaultDirName={pf}\drComRead
DefaultGroupName=drComRead
AllowNoIcons=yes
LicenseFile=../Manuals/license.txt
InfoBeforeFile=../Manuals/readme.txt
OutputBaseFilename=drComRead0131
SetupIconFile=../release/Data/gal1.ico
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

[Registry]
Root: HKCR; Subkey: ".cbr"; ValueType: string; ValueName: ""; ValueData: "DRCOMREADSHL"; Flags: uninsdeletevalue
Root: HKCR; Subkey: ".cbz"; ValueType: string; ValueName: ""; ValueData: "DRCOMREADSHL"; Flags: uninsdeletevalue
Root: HKCR; Subkey: ".cb7"; ValueType: string; ValueName: ""; ValueData: "DRCOMREADSHL"; Flags: uninsdeletevalue
Root: HKCR; Subkey: "DRCOMREADSHL"; ValueType: string; ValueName: ""; ValueData: "Comics arhive"; Flags: uninsdeletekey
Root: HKCR; Subkey: "DRCOMREADSHL\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\drComRead.exe,0"
Root: HKCR; Subkey: "DRCOMREADSHL\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\drComRead.exe"" ""%1"" ""%2"" ""%3"""

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "../release/dialogs/*"; DestDir: "{app}\dialogs"; Flags: ignoreversion
Source: "../release/crod/crod.dll"; DestDir: "{app}\crod"; Flags: ignoreversion
Source: "../release/crod/russian.lng"; DestDir: "{app}\crod"; Flags: ignoreversion
Source: "../release/crod/english.lng"; DestDir: "{app}\crod"; Flags: ignoreversion
Source: "../release/crod/documentation.db"; DestDir: "{app}\crod"; Flags: ignoreversion
Source: "../release/data/*"; DestDir: "{app}\data"; Flags: ignoreversion
Source: "../release/data/toolbar/*"; DestDir: "{app}\data\toolbar"; Flags: ignoreversion
Source: "../release/7z.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "../release/config.cr"; DestDir: "{app}"; Flags: ignoreversion onlyifdoesntexist
Source: "../release/drComRead.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "../release/curves.fcc"; DestDir: "{app}"; Flags: ignoreversion onlyifdoesntexist
Source: "../release/russian.lng"; DestDir: "{app}"; Flags: ignoreversion
Source: "../release/sqlite3.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "../release/unrar.dll"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\drComRead"; Filename: "{app}\drComRead.exe"
Name: "{group}\{cm:UninstallProgram,drComRead}"; Filename: "{uninstallexe}"
Name: "{commondesktop}\drComRead"; Filename: "{app}\drComRead.exe"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\drComRead"; Filename: "{app}\drComRead.exe"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\drComRead.exe"; Description: "{cm:LaunchProgram,drComRead}"; Flags: nowait postinstall skipifsilent
