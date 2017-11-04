unit u_passet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  StdCtrls, Forms, Buttons, DB, ADODB;

type
  Tfrm_passset = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edt_passet: TEdit;
    edt_rpasset: TEdit;
    btn_ok: TBitBtn;
    btn_add: TBitBtn;
    cmbUID: TComboBox;
    edt_userset: TEdit;
    Label4: TLabel;
    ADODataSet1: TADODataSet;
    CheckBox_tag: TCheckBox;
    ADOQuery1: TADOQuery;
    procedure btn_addClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cmbUIDChange(Sender: TObject);
  private
    curOpering:WideString;
    { Private declarations }
  public
    newAddFlag,clickAddFlag,managerB:Boolean;
    procedure checkTagA;
    function queryUserNameA(UIDStr:WideString):WideString;
    { Public declarations }
  end;

var
  frm_passset: Tfrm_passset;
    
implementation

uses umain,UDataModule_ado;

{$R *.dfm}

procedure Tfrm_passset.btn_addClick(Sender: TObject);
var
  ndUid,cmbICount:integer;
begin
//
  if not clickAddFlag then
  begin
    edt_userset.Text:='';
  end;
    
  if newAddFlag then
  begin
    //
    ADODataSet1.Close;
    ADODataSet1.CommandText:='select Max(OperID) from operator where OperID<9009';
    ADODataSet1.Open;

    ndUid:=ADODataSet1.Fields[0].AsInteger;
    if ndUid=0 then
    begin
      //9999
      if operatorStr='9999' then
      begin
        ndUid:=9997;
        CheckBox_tag.Checked:=True;
        CheckBox_tag.Enabled:=False;
      end
      else
      begin
        ndUid:=1000;
        CheckBox_tag.Checked:=False;
      end;
    end;
    cmbUID.Items.Append(IntToStr(ndUid+1));
    cmbICount:=cmbUID.Items.Count;
    cmbUID.ItemIndex:=cmbICount-1 ;
    //
    newAddFlag:=False;
    clickAddFlag:=True;
  end
  else
  begin
    Application.MessageBox('请保存新增用户！','hint',MB_OK);
    Exit;
  end;
end;

procedure Tfrm_passset.FormCreate(Sender: TObject);
begin
  newAddFlag:=True;
end;

procedure Tfrm_passset.btn_okClick(Sender: TObject);
var
  UIDStr,userNameStr,PWDStr:WideString;
  //
  tagB:Boolean;
begin
  //
  UIDStr:=cmbUID.Text;
  if CheckBox_tag.Checked then
  begin
    tagB:=True;
  end
  else
  begin
    tagB:=False;
  end;
  userNameStr:=edt_userset.Text;
  //check edit val
  if userNameStr=''then
  begin
    Application.MessageBox('请输入用户名！','hint',MB_OK);
    Exit;
  end;
  if edt_passet.Text=''then
  begin
    Application.MessageBox('请输入密码！','hint',MB_OK);
    Exit;
  end;
  if edt_passet.Text<>edt_rpasset.Text then
  begin
    Application.MessageBox('两次密码不相同，请重新输入！','hint',MB_OK);
    Exit;
  end
  else
  begin
    PWDStr:=edt_passet.Text;
  end;
  //new add
  if clickAddFlag then
  begin
    ADOQuery1.Close;
    ADOQuery1.SQL.Clear;
    ADOQuery1.SQL.Text:='insert into operator values('
                                +UIDStr+','+''''+userNameStr+''''+','
                                +''''+PWDStr+''''+','+''''+curOpering+''''+','
                                +BoolToStr(tagB,True)+')';
    ADOQuery1.ExecSQL;
    Application.MessageBox('新增操作员成功!','hint',MB_OK);
    edt_userset.Text:='';
    edt_passet.Text:='';
    edt_rpasset.Text:='';
    //
    clickAddFlag:=False;
    newAddFlag:=True;
    //
    frame1.addMemoLog('新增操作员成功!');
    //9999
    if operatorStr='9999'then
    begin
      frm_passset.Close;
      //
      ADOQuery1.Close;
      ADOQuery1.SQL.Clear;
      ADOQuery1.SQL.Text:='DELETE from operator where OperID=9999';
      ADOQuery1.ExecSQL;

      frmMain.pwd3.Enabled:=False;   
    end;

    Exit;
  end;

  //update normal operator
  if managerB=false then
  begin
    ADOQuery1.Close;
    ADOQuery1.SQL.Clear;
    ADOQuery1.SQL.Text:='update operator set OperPassWord='
                                        +''''+PWDStr+''''+' where OperID='+UIDStr;
    ADOQuery1.ExecSQL;
    //
    frame1.addMemoLog('更改密码成功!');
    Application.MessageBox('更改密码成功!','hint',MB_OK);
    Close;
  end
  else
  begin
    ADOQuery1.Close;
    ADOQuery1.SQL.Clear;
    ADOQuery1.SQL.Text:='update operator set OperPassWord='+''''+PWDStr+''''
                        +',OperName='+''''+userNameStr+''''
                        +',tag='+BoolToStr(tagB,True)+' where OperID='+UIDStr;
    ADOQuery1.ExecSQL;
    //
    frame1.addMemoLog('修改资料成功!');
    Application.MessageBox('修改资料成功!','hint',MB_OK);
  end;
  edt_passet.Text:='';
  edt_rpasset.Text:='';
  CheckBox_tag.Checked:=False;
end;

function Tfrm_passset.queryUserNameA(UIDStr:WideString):WideString;
var
  operNameA:WideString;
begin
  ADODataSet1.Close;
  ADODataSet1.CommandText:='select OperName from operator where OperID='+UIDStr;
  ADODataSet1.Open;

  operNameA:=ADODataSet1.Fields[0].AsString;
  Result:=operNameA;
end;

procedure Tfrm_passset.checkTagA;
var
  tagValA:Boolean;
begin
  ADODataSet1.Close;
  ADODataSet1.CommandText:='select tag from operator where OperID='+cmbUID.Text;
  ADODataSet1.Open;

  tagValA:=ADODataSet1.Fields[0].AsBoolean;
  if tagValA then
  begin
    CheckBox_tag.Checked:=True;
  end
  else
  begin
    CheckBox_tag.Checked:=False;
  end;
end;

procedure Tfrm_passset.FormShow(Sender: TObject);
begin
  edt_userset.Text:=queryUserNameA(cmbUID.Text);
  checkTagA;
  //current operator
  curOpering:=cmbUID.Text;
end;

procedure Tfrm_passset.cmbUIDChange(Sender: TObject);
begin
  edt_userset.Text:=queryUserNameA(cmbUID.Text);
  checkTagA;
end;

end.

