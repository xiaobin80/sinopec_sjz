unit u_login;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, jpeg;

type
  Tfrm_login = class(TForm)
    combox_user: TComboBox;
    edt_pass: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    login: TLabel;
    cancel: TLabel;
    close_label: TLabel;
    procedure loginClick(Sender: TObject);
    procedure cancelClick(Sender: TObject);
    procedure close_labelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edt_passKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_login: Tfrm_login;
  
implementation
uses
  UDataModule_ado;
{$R *.dfm}

procedure Tfrm_login.loginClick(Sender: TObject);
var
  operIDStr,operPWDStr:WideString;
begin
  //
  handlers:='';
  if edt_pass.Text='' then
  begin
    Application.MessageBox('请输入密码!','提示',MB_OK);
    Exit;
  end;
  //
  operIDStr:=combox_user.Text;
  operPWDStr:=edt_pass.Text;
  //
  DataModule_ado.adodataset_login.Close;
  DataModule_ado.adodataset_login.CommandText:='select OperID, OperPassWord from operator'
                                                +' where OperID='+''+operIDStr+''
                                                +' and OperPassWord='+''''+operPWDStr+'''';
  DataModule_ado.adodataset_login.Open;
  //
  if DataModule_ado.adodataset_login.RecordCount<>0 then
  begin
    operatorStr:=combox_user.Text;
    //
    Close;
  end
  else
  begin
    Application.MessageBox('你输入的密码不正确！','提示',MB_OK+MB_ICONINFORMATION);
    edt_pass.Text:='';
    Exit;
  end;
end;

procedure Tfrm_login.cancelClick(Sender: TObject);
begin
  Close;
  handlers:='123';
end;

procedure Tfrm_login.close_labelClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure Tfrm_login.FormShow(Sender: TObject);
var
  i:integer;
  user1:string;
begin
  DataModule_ado.adodataset_login.Close;
  DataModule_ado.adodataset_login.CommandText:='select OperID, OperPassWord from operator order by OperID';
  DataModule_ado.adodataset_login.Open;

  for i:=0 to DataModule_ado.adodataset_login.RecordCount-1 do
  begin
    user1:=DataModule_ado.adodataset_login.Fields[0].Text;
    combox_user.Items.Append(user1);
    DataModule_ado.adodataset_login.Next;
  end;

  combox_user.ItemIndex:=0;
end;

procedure Tfrm_login.edt_passKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then
  begin
    loginClick(nil);
  end;
end;

end.

