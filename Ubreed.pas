unit Ubreed;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, Grids, DBGrids, Buttons, DB, ADODB,
  UpublicFunc, StrUtils;

type
  TfrmBreed = class(TForm)
    pnlTop: TPanel;
    Panel2: TPanel;
    pnlBtn: TPanel;
    pnlEdt: TPanel;
    Label1: TLabel;
    label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    DBGrid1: TDBGrid;
    btn_close: TBitBtn;
    btn_save: TBitBtn;
    btn_modif: TBitBtn;
    edtBreed: TEdit;
    edtFreeTime: TEdit;
    edtUnivalent: TEdit;
    btn_del: TBitBtn;
    Label5: TLabel;
    edtSlap: TEdit;
    DataSource1: TDataSource;
    ADODataSet1: TADODataSet;
    Label6: TLabel;
    edtMemo: TEdit;
    cmbBatch: TComboBox;
    procedure btn_closeClick(Sender: TObject);
    procedure btn_delClick(Sender: TObject);
    procedure cmbBatchKeyPress(Sender: TObject; var Key: Char);
    procedure edtSlapKeyPress(Sender: TObject; var Key: Char);
    procedure edtFreeTimeKeyPress(Sender: TObject; var Key: Char);
    procedure edtUnivalentKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure btn_saveClick(Sender: TObject);
    procedure btn_modifClick(Sender: TObject);
  private
    breedNameStr,memoB,flagB:WideString;
    freeTimeStr,univalentStr:WideString;

    modifBool:Boolean;
    { Private declarations }
  public
    procedure qualifiedInputKey(edtInputX:TEdit;var Key: Char);
    { Public declarations }
  end;

var
  frmBreed: TfrmBreed;

implementation
  uses UDataModule_ado;
{$R *.dfm}

procedure TfrmBreed.btn_closeClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmBreed.btn_delClick(Sender: TObject);
begin
  ADODataSet1.Delete;

end;

procedure TfrmBreed.qualifiedInputKey(edtInputX:TEdit;var Key: Char);
begin
 //防止非数字，删除键，.的输入
  if Key='.'then
    if Pos('.',edtInputX.Text)>0 then
    begin
      key:=#0;
      exit;
    end;
  if Length(edtInputX.Text)>13 then
    begin
      Key:=#8;
      Exit;
    end;
  if not(key in['0'..'9',#8,'.'])then key:=#0;
   if Copy(edtInputX.Text,1,1)='.'then
     begin
       Key:=#8;
       Exit;
     end;
end;

procedure TfrmBreed.cmbBatchKeyPress(Sender: TObject; var Key: Char);
begin
  if not(key in['0'..'9',#8])then key:=#0;
end;

procedure TfrmBreed.edtSlapKeyPress(Sender: TObject; var Key: Char);
begin
  if not(key in['A'..'Z','a'..'z',#8])then key:=#0;
  if Length(edtSlap.Text)>3 then
  begin
    Key:=#8;
    Exit;
  end;
end;

procedure TfrmBreed.edtFreeTimeKeyPress(Sender: TObject; var Key: Char);
begin
  qualifiedInputKey(edtFreeTime,Key);
end;

procedure TfrmBreed.edtUnivalentKeyPress(Sender: TObject; var Key: Char);
begin
  qualifiedInputKey(edtUnivalent,Key);
end;

procedure TfrmBreed.FormShow(Sender: TObject);
var
  i1:integer;
begin
  //
  for i1:=1 to 9 do
  begin
    cmbBatch.Items.Append(IntToStr(i1));
  end;
  ADODataSet1.Close;
  ADODataSet1.CommandText:='select breedName AS 品种名称,freeTime AS [无偿占用时间(小时)],'
                +'univalent AS [单价(1车/小时/元)],dictionary AS 简记,breedMemo AS 备注 from breedSet';
  ADODataSet1.Open;

  normGridColWidth(DBGrid1,120);
end;

procedure TfrmBreed.btn_saveClick(Sender: TObject);
begin
  breedNameStr:=edtBreed.Text;
  memoB:=edtMemo.Text;
  flagB:=edtSlap.Text+cmbBatch.Text;

  freeTimeStr:=edtFreeTime.Text;
  univalentStr:=edtUnivalent.Text;
  if (edtBreed.Text='')or(edtSlap.Text='')or(edtUnivalent.Text='')
                                or(edtFreeTime.Text='')or(cmbBatch.Text='')then
  begin
    Exit;
  end;
  try
    if modifBool then
    begin
      //
      DataModule_ado.ADOQuery_Exec.Close;
      DataModule_ado.ADOQuery_Exec.SQL.Clear;
      DataModule_ado.ADOQuery_Exec.SQL.Text:='update breedSet set breedName='
                                    +''''+breedNameStr+''''
                                    +',freeTime='+''+freeTimeStr+''
                                    +',univalent='+''+univalentStr+''
                                    +',breedMemo='+''''+memoB+''''
                                    +' where(dictionary='+''''+flagB+''''+')';
      DataModule_ado.ADOQuery_Exec.ExecSQL;
      Application.MessageBox('修改资料成功！','hint',MB_OK);
    end
    else
    begin
      //
      DataModule_ado.ADOQuery_Exec.Close;
      DataModule_ado.ADOQuery_Exec.SQL.Clear;
      DataModule_ado.ADOQuery_Exec.SQL.Text:='INSERT INTO breedSet values('
                                    +''''+breedNameStr+''''+','+''+freeTimeStr+''+','
                                    +''+univalentStr+''+','+''''+flagB+''''+','
                                    +''''+memoB+''''
                                    +')';
      DataModule_ado.ADOQuery_Exec.ExecSQL;
      Application.MessageBox('增加资料成功！','hint',MB_OK);
    end;
    //
    ADODataSet1.Close;
    ADODataSet1.Open;
    normGridColWidth(DBGrid1,120);
    //
    edtBreed.Text:='';
    edtSlap.Text:='';
    edtUnivalent.Text:='';
    edtFreeTime.Text:='';
    cmbBatch.Text:='';
    edtMemo.Text:='';
    edtSlap.Enabled:=True;
    edtSlap.Color:=clWindow;
    cmbBatch.Enabled:=True;
    cmbBatch.Color:=clWindow;
  
    modifBool:=False;
  except


  end;

end;

procedure TfrmBreed.btn_modifClick(Sender: TObject);
var
  batchStr:WideString;
  batchLen:integer;
begin
  batchStr:=ADODataSet1.Fields[3].AsString;
  batchLen:=length(batchStr);
  
  edtBreed.Text:=ADODataSet1.Fields[0].AsString;
  edtMemo.Text:=ADODataSet1.Fields[4].AsString;
  edtSlap.Text:=LeftStr(batchStr,batchLen-1);
  cmbBatch.Text:=RightStr(batchStr,1);
  edtFreeTime.Text:=FloatToStr(ADODataSet1.Fields[1].AsFloat);
  edtUnivalent.Text:=FloatToStr(ADODataSet1.Fields[2].AsFloat);

  edtSlap.Enabled:=False;
  edtSlap.Color:=clBtnFace;
  cmbBatch.Enabled:=False;
  cmbBatch.Color:=clBtnFace;
  
  modifBool:=True;
end;

end.
