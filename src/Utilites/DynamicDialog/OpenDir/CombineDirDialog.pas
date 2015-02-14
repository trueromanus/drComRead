unit CombineDirDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ShellCtrls;

type
  TCombineDirForm = class(TForm)
    ShellTreeView: TShellTreeView;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CombineDirForm: TCombineDirForm;

implementation

{$R *.dfm}

end.
