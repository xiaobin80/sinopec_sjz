unit u_about;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, jpeg, ExtCtrls, ShellApi;

type
  Tfrm_about = class(TForm)
    im_about: TImage;
    im_bout02: TImage;
    mo_about: TMemo;
    BitBtn_about: TBitBtn;
    Label7: TLabel;
    Label8: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    StaticText8: TStaticText;
    StaticText9: TStaticText;
    StaticText10: TStaticText;
    StaticText11: TStaticText;
    Label4: TLabel;
    procedure BitBtn_aboutClick(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Label10Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_about: Tfrm_about;

implementation

{$R *.dfm}

procedure Tfrm_about.BitBtn_aboutClick(Sender: TObject);
begin
  frm_about.Close;
end;

procedure Tfrm_about.Label4Click(Sender: TObject);
begin
  StaticText8.Visible:=False;
  StaticText9.Visible:=False;
  StaticText10.Visible:=False;
  StaticText11.Visible:=False;
  Label7.Visible:=False;
  Label8.Visible:=False;
  Label5.Visible:=False;
  Label6.Visible:=False;
  Label9.Visible:=False;
  Label10.Visible:=False;
  Label4.Visible:=False;
  im_bout02.Visible:=True;
end;

procedure Tfrm_about.Label10Click(Sender: TObject);
begin
//
    ShellExecute(Handle,
				 nil,
				 PChar(Label10.Caption),
				 nil,
				 nil,
				 SW_SHOWNORMAL);
end;

end.
