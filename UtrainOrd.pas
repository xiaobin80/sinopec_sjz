unit UtrainOrd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, DB, StdCtrls, Menus, Buttons, ActnList,
  Grids, DBGrids, Mask, DBCtrls, XPMenu, ImgList, StrUtils;

type
  TfrmTrainOrd = class(TForm)
    pnlTop: TPanel;
    sbTrain: TStatusBar;
    DataSource1: TDataSource;
    pnlOrd: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    pnlGrid: TPanel;
    pnlTime: TPanel;
    Bevel14: TBevel;
    DBGrid2: TDBGrid;
    SplitterBottom: TSplitter;
    DBGrid1: TDBGrid;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    t1W: TMenuItem;
    A1T: TMenuItem;
    DataSource2: TDataSource;
    N2: TMenuItem;
    t2S: TMenuItem;
    N3: TMenuItem;
    V1: TMenuItem;
    H1: TMenuItem;
    pnlPastTimeStr: TPanel;
    pnlSQLstr: TPanel;
    GroupBox1: TGroupBox;
    Label19: TLabel;
    dtp_dateEntrant: TDateTimePicker;
    dtp_timeEntrant: TDateTimePicker;
    Label3: TLabel;
    dtp_dateFinish: TDateTimePicker;
    dtp_timeFinish: TDateTimePicker;
    Label4: TLabel;
    dtp_dateTakeout: TDateTimePicker;
    dtp_timeTakeout: TDateTimePicker;
    GroupBox2: TGroupBox;
    cmbCompose: TComboBox;
    Label5: TLabel;
    lbl_explanatory: TLabel;
    N4: TMenuItem;
    t3U: TMenuItem;
    t4D: TMenuItem;
    N5: TMenuItem;
    A2U: TMenuItem;
    A2D: TMenuItem;
    XPMenu1: TXPMenu;
    ImageList1: TImageList;
    Label6: TLabel;
    edtPlace: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure t1WClick(Sender: TObject);
    procedure A1TClick(Sender: TObject);
    procedure t2SClick(Sender: TObject);
    procedure V1Click(Sender: TObject);
    procedure H1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cmbComposeChange(Sender: TObject);
    procedure t3UClick(Sender: TObject);
    procedure t4DClick(Sender: TObject);
    procedure A2UClick(Sender: TObject);
    procedure A2DClick(Sender: TObject);
  private
    wsnStr,snStr:WideString;
    entrantDateTimeStr,finishDateTimeStr,takeOutDateTimeStr:WideString;
    //
    //
    recInt_sb1:Integer;
    //
    procedure appAgent(sender:TObject);
    { Private declarations }
  public
    taskVal:integer;
    tableNameStrB:WideString;
    procedure dbgridManagement;
    procedure refreshData_trainOrd;
    { Public declarations }
  end;

var
  frmTrainOrd: TfrmTrainOrd;

implementation
uses
  UDataModule_ado,UpublicFunc;
{$R *.dfm}

procedure TfrmTrainOrd.appAgent(sender:TObject);
begin
  sbTrain.SimpleText:=Application.Hint;
end;

procedure TfrmTrainOrd.FormCreate(Sender: TObject);
begin
  //application hint
  Application.OnHint:=appAgent;
  XPMenu1.Active:=True;
end;

procedure TfrmTrainOrd.dbgridManagement;
begin
  normGridColWidth(DBGrid1,80);
  DBGrid1.Columns[6].ReadOnly:=True;
  DBGrid1.Columns[7].ReadOnly:=True;
  DBGrid1.Columns[8].ReadOnly:=True;

  DBGrid1.Columns[10].Visible:=False;//sn
  DBGrid1.Columns[11].Visible:=False;//past_time
  DBGrid1.Columns[12].Visible:=False;//saveTime
  DBGrid1.Columns[13].Visible:=False;//car_breed
  DBGrid1.Columns[14].Visible:=False;//dictionary
  //
  normGridColWidth(DBGrid2,80);
  DBGrid2.Columns[10].Visible:=False;//waitPID
end;

procedure TfrmTrainOrd.FormShow(Sender: TObject);
begin
  //
  dbgridManagement;
  addDictionary(DataModule_ado.ADODataSet_breed,cmbCompose);
  //
  dtp_dateEntrant.Date:=Now;
  dtp_dateFinish.Date:=Now;
  dtp_dateTakeout.Date:=Now;

  dtp_timeEntrant.Time:=Now;
  dtp_timeFinish.Time:=Now;
  dtp_timeTakeout.Time:=Now;
  //
  taskVal:=StrToInt(pnlOrd.Caption);
  tableNameStrB:=pnlTop.Caption;
  //
  edtPlace.Text:=' '
end;

procedure TfrmTrainOrd.refreshData_trainOrd;
begin
  //Refresh data
  DataModule_ado.ADODataSet_2task.Close;
  DataModule_ado.ADODataSet_2task.Open;
  DataModule_ado.ADODataSet_waitProcess.Close;
  DataModule_ado.ADODataSet_waitProcess.Open;
  //
  dbgridManagement;
end;

procedure TfrmTrainOrd.t1WClick(Sender: TObject);
begin
  snStr:= DataModule_ado.ADODataSet_2task.FieldByName('SN').AsString;
  if snStr='' then Exit;
  DataModule_ado.addWPC_single(snStr,taskVal);
  DataModule_ado.subtract2TaskTable(snStr,taskVal);

  refreshData_trainOrd;
end;

procedure TfrmTrainOrd.t2SClick(Sender: TObject);
begin
  snStr:= DataModule_ado.ADODataSet_2task.FieldByName('SN').AsString;
  //
  entrantDateTimeStr:=dateTimePiece(dtp_dateEntrant,dtp_timeEntrant);
  finishDateTimeStr:=dateTimePiece(dtp_dateFinish,dtp_timeFinish);
  takeOutDateTimeStr:=dateTimePiece(dtp_dateTakeout,dtp_timeTakeout);
  if cmbCompose.Text='' then Exit;
  if edtPlace.Text='' then Exit;
  DataModule_ado.modify2Task_singleA(snStr,entrantDateTimeStr,finishDateTimeStr,
                        takeOutDateTimeStr,edtPlace.Text,cmbCompose.Text,taskVal);
  //
  refreshData_trainOrd;
end;

procedure TfrmTrainOrd.t3UClick(Sender: TObject);
begin
  //
  entrantDateTimeStr:=dateTimePiece(dtp_dateEntrant,dtp_timeEntrant);
  finishDateTimeStr:=dateTimePiece(dtp_dateFinish,dtp_timeFinish);
  takeOutDateTimeStr:=dateTimePiece(dtp_dateTakeout,dtp_timeTakeout);
  //
  if cmbCompose.Text='' then Exit;
  if edtPlace.Text='' then Exit;
  if DataModule_ado.ADODataSet_2task.Bof then Exit;
  //
  while not DataModule_ado.ADODataSet_2task.Bof do
  begin
    snStr:= DataModule_ado.ADODataSet_2task.FieldByName('SN').AsString;
    DataModule_ado.modify2Task_singleA(snStr,entrantDateTimeStr,finishDateTimeStr,
                        takeOutDateTimeStr,edtPlace.Text,cmbCompose.Text,taskVal);
    //
    DataModule_ado.ADODataSet_2task.Prior;
  end;
  //
  refreshData_trainOrd;
end;

procedure TfrmTrainOrd.t4DClick(Sender: TObject);
begin
  //
  entrantDateTimeStr:=dateTimePiece(dtp_dateEntrant,dtp_timeEntrant);
  finishDateTimeStr:=dateTimePiece(dtp_dateFinish,dtp_timeFinish);
  takeOutDateTimeStr:=dateTimePiece(dtp_dateTakeout,dtp_timeTakeout);
  //
  if cmbCompose.Text='' then Exit;
  if edtPlace.Text='' then Exit;
  if DataModule_ado.ADODataSet_2task.Eof then Exit;
  //
  while not DataModule_ado.ADODataSet_2task.Eof do
  begin
    snStr:= DataModule_ado.ADODataSet_2task.FieldByName('SN').AsString;
    DataModule_ado.modify2Task_singleA(snStr,entrantDateTimeStr,finishDateTimeStr,
                        takeOutDateTimeStr,edtPlace.Text,cmbCompose.Text,taskVal);
    //
    DataModule_ado.ADODataSet_2task.Next;
  end;
  //
  refreshData_trainOrd;
end;

procedure TfrmTrainOrd.V1Click(Sender: TObject);
begin
  recInt_sb1:=DataModule_ado.viewTask_allWPC;
  sbTrain.SimpleText:=IntToStr(recInt_sb1)+' 条数据';
  //
  refreshData_trainOrd;
end;

procedure TfrmTrainOrd.H1Click(Sender: TObject);
begin
  DataModule_ado.viewTask_watiProcess(pnlPastTimeStr.Caption);
  sbTrain.SimpleText:=IntToStr(recInt_sb1)+' 条数据';  
  //
  refreshData_trainOrd;
end;

procedure TfrmTrainOrd.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  recI1:integer;
begin
  recI1:=DataModule_ado.getNullTime_2task(tableNameStrB);
  if recI1<>0 then
  begin
    CanClose:=False;
    Application.MessageBox('有"时间"数据空项，请检查！','hint',MB_OK);
  end;
end;

procedure TfrmTrainOrd.cmbComposeChange(Sender: TObject);
begin
  lbl_explanatory.Caption:=addExplanatory(DataModule_ado.ADODataSet_breed,cmbCompose.Text);
end;

procedure TfrmTrainOrd.A1TClick(Sender: TObject);
begin
  wsnStr:=DataModule_ado.ADODataSet_waitProcess.FieldByName('waitPID').AsString;
  if wsnStr='' then Exit;
  DataModule_ado.subtractWPC_single(wsnStr,taskVal);
  DataModule_ado.subtractWPCTable(wsnStr);

  refreshData_trainOrd;
end;

procedure TfrmTrainOrd.A2UClick(Sender: TObject);
begin
  if DataModule_ado.ADODataSet_waitProcess.Bof then Exit;
  while not DataModule_ado.ADODataSet_waitProcess.Bof do
  begin
    wsnStr:=DataModule_ado.ADODataSet_waitProcess.FieldByName('waitPID').AsString;
    //
    DataModule_ado.subtractWPC_single(wsnStr,taskVal);
    DataModule_ado.subtractWPCTable(wsnStr);
    //
    DataModule_ado.ADODataSet_waitProcess.Prior;
  end;
  refreshData_trainOrd;
end;

procedure TfrmTrainOrd.A2DClick(Sender: TObject);
begin
  if DataModule_ado.ADODataSet_waitProcess.Eof then Exit;
  while not DataModule_ado.ADODataSet_waitProcess.Eof do
  begin
    wsnStr:=DataModule_ado.ADODataSet_waitProcess.FieldByName('waitPID').AsString;
    //
    DataModule_ado.subtractWPC_single(wsnStr,taskVal);
    DataModule_ado.subtractWPCTable(wsnStr);
    //
    DataModule_ado.ADODataSet_waitProcess.Next;
  end;
  refreshData_trainOrd;
end;

procedure TfrmTrainOrd.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //save 2task
  DataModule_ado.save2task(tableNameStrB,DateTimeToStr(Now),
                        IntToStr(DataModule_ado.maxBatchNO2task(tableNameStrB)));
  refreshData_trainOrd;
  //save stevedore
  DataModule_ado.addStevedore(DataModule_ado.ADODataSet_2task,taskVal);
end;

end.
