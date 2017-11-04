unit UqueryType;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmType = class(TForm)
    GroupBox1: TGroupBox;
    rbFill: TRadioButton;
    rbClear: TRadioButton;
    rbBlend: TRadioButton;
    procedure rbFillClick(Sender: TObject);
    procedure rbClearClick(Sender: TObject);
    procedure rbBlendClick(Sender: TObject);
  private
    { Private declarations }
  public
    flagTask:integer;
    { Public declarations }
  end;

var
  frmType: TfrmType;

implementation

{$R *.dfm}

procedure TfrmType.rbFillClick(Sender: TObject);
begin
  flagTask:=1;
end;

procedure TfrmType.rbClearClick(Sender: TObject);
begin
  flagTask:=2;
end;

procedure TfrmType.rbBlendClick(Sender: TObject);
begin
  flagTask:=3;
end;

end.
