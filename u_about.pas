unit u_about;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, jpeg, ExtCtrls, ShellApi;

type
  Tfrm_about = class(TForm)
    mo_about: TMemo;
    Label7: TLabel;
    Label8: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Image1: TImage;
    Label2: TLabel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    Label1: TLabel;
    procedure Label10Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    verStr:string;
    { Public declarations }
  end;

var
  frm_about: Tfrm_about;

implementation
uses
  UpublicFunc;
{$R *.dfm}

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

procedure Tfrm_about.FormShow(Sender: TObject);
var
  szExePathname:array [0..266]of char;
  hMoudleA:DWORD;
begin
  hMoudleA:=GetModuleHandle(nil);
  GetModuleFileName(hMoudleA,szExePathname,MAX_PATH);
  verStr:=GetCDPFileVersion(string(szExePathname));
  mo_about.Lines.Append(#13);
  mo_about.Lines.Append('Ö÷³ÌÐò°æ±¾ºÅ:');
  mo_about.Lines.Add('             '+verStr);
end;

end.
