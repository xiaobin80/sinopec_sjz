unit UtrainBlend;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, DB, StdCtrls, Menus, Buttons, ActnList,
  Grids, DBGrids, XPMenu, ImgList, StrUtils;

type
  TfrmTrainBlend = class(TForm)
    pnlTop: TPanel;
    sbTrain: TStatusBar;
    DataSource_load: TDataSource;
    pnlOrd: TPanel;
    Image1: TImage;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    pnlGrid: TPanel;
    pnlTime: TPanel;
    Bevel14: TBevel;
    DBGridWaitProcess: TDBGrid;
    SplitterBottom: TSplitter;
    pnlInstall: TPanel;
    pnlUninstall: TPanel;
    Splitter1: TSplitter;
    DBGrid_load: TDBGrid;
    DBGrid_unload: TDBGrid;
    PopupMenu_WPC: TPopupMenu;
    Al1S: TMenuItem;
    Au1S: TMenuItem;
    DataSource_unload: TDataSource;
    DataSource_wait: TDataSource;
    PopupMenu_load: TPopupMenu;
    PopupMenu_unload: TPopupMenu;
    l1W: TMenuItem;
    u1W: TMenuItem;
    N2: TMenuItem;
    l2sS: TMenuItem;
    N3: TMenuItem;
    u2sS: TMenuItem;
    view: TMenuItem;
    hidden: TMenuItem;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    cmbCompose: TComboBox;
    lbl_explanatory: TLabel;
    N7: TMenuItem;
    Al2U: TMenuItem;
    Al3D: TMenuItem;
    N8: TMenuItem;
    Au2U: TMenuItem;
    Au3D: TMenuItem;
    N11: TMenuItem;
    l3U: TMenuItem;
    l4D: TMenuItem;
    N12: TMenuItem;
    u3U: TMenuItem;
    u4D: TMenuItem;
    XPMenu1: TXPMenu;
    ImageList1: TImageList;
    ImageList_wpc: TImageList;
    GroupBox1: TGroupBox;
    Label19: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    dtp_dateEntrant: TDateTimePicker;
    dtp_timeEntrant: TDateTimePicker;
    dtp_dateFinish: TDateTimePicker;
    dtp_timeFinish: TDateTimePicker;
    dtp_dateTakeout: TDateTimePicker;
    dtp_timeTakeout: TDateTimePicker;
    edtPlace: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure l1WClick(Sender: TObject);
    procedure u1WClick(Sender: TObject);
    procedure Al1SClick(Sender: TObject);
    procedure Au1SClick(Sender: TObject);
    procedure l2sSClick(Sender: TObject);
    procedure u2sSClick(Sender: TObject);
    procedure viewClick(Sender: TObject);
    procedure hiddenClick(Sender: TObject);
    procedure cmbComposeChange(Sender: TObject);
    procedure l3UClick(Sender: TObject);
    procedure l4DClick(Sender: TObject);
    procedure u3UClick(Sender: TObject);
    procedure u4DClick(Sender: TObject);
    procedure Al2UClick(Sender: TObject);
    procedure Al3DClick(Sender: TObject);
    procedure Au2UClick(Sender: TObject);
    procedure Au3DClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    lsnStr,usnStr,wsnStr:WideString;
    entrantDateTimeStr,finishDateTimeStr,takeOutDateTimeStr:WideString;
    //
    nowStr1,nowStr:WideString;
    nowInt:Integer;
    //
    maxBNO_load,maxBNO_unload:integer;
    recInt_sb1:Integer;
    //
    randInt:Integer;
    //
    procedure appAgent(sender:TObject);
    { Private declarations }
  public
    //tag- utrainBlend
    postFlag1,postFlag2:Boolean;
    //
    procedure dbgridManagement;
    procedure refreshData_trainBlend;
    { Public declarations }
  end;

var
  frmTrainBlend: TfrmTrainBlend;

implementation
uses
  UDataModule_ado,UpublicFunc;
{$R *.dfm}

procedure TfrmTrainBlend.appAgent(sender:TObject);
begin
  sbTrain.SimpleText:=Application.Hint;
end;

procedure TfrmTrainBlend.FormCreate(Sender: TObject);
begin
  //application hint
  Application.OnHint:=appAgent;
  XPMenu1.Active:=True;
  maxBNO_load:=DataModule_ado.maxBatchNO2task('load_car')+1;
  maxBNO_unload:=DataModule_ado.maxBatchNO2task('unload_car')+1;
end;

procedure TfrmTrainBlend.dbgridManagement;
begin
  //DBGrid_load
  normGridColWidth(DBGrid_load,80);
  DBGrid_load.Columns[6].ReadOnly:=True;
  DBGrid_load.Columns[7].ReadOnly:=True;
  DBGrid_load.Columns[8].ReadOnly:=True;
  DBGrid_load.Columns[10].Visible:=False;//sn
  DBGrid_load.Columns[11].Visible:=False;//past_time
  DBGrid_load.Columns[12].Visible:=False;//saveTime
  DBGrid_load.Columns[13].Visible:=False;//car_breed
  DBGrid_load.Columns[14].Visible:=False;//dictionary    
  //DBGrid_unload
  normGridColWidth(DBGrid_unload,80);
  DBGrid_unload.Columns[6].ReadOnly:=True;
  DBGrid_unload.Columns[7].ReadOnly:=True;
  DBGrid_unload.Columns[8].ReadOnly:=True;
  DBGrid_unload.Columns[10].Visible:=False;
  DBGrid_unload.Columns[11].Visible:=False;//past_time
  DBGrid_unload.Columns[12].Visible:=False;//saveTime
  DBGrid_unload.Columns[13].Visible:=False;//car_breed
  DBGrid_unload.Columns[14].Visible:=False;//dictionary   
  //DBGridWaitProcess
  normGridColWidth(DBGridWaitProcess,80);
  DBGridWaitProcess.Columns[10].Visible:=False;
end;

procedure TfrmTrainBlend.FormShow(Sender: TObject);
begin
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
  edtPlace.Text:=' ';  
end;

procedure TfrmTrainBlend.refreshData_trainBlend;
begin
  //Refresh data
  DataModule_ado.ADODataSet_load.Close;
  DataModule_ado.ADODataSet_load.Open;
  DataModule_ado.ADODataSet_unload.Close;
  DataModule_ado.ADODataSet_unload.Open;
  DataModule_ado.ADODataSet_waitProcess.Close;
  DataModule_ado.ADODataSet_waitProcess.Open;
  //
  dbgridManagement;
end;

procedure TfrmTrainBlend.l1WClick(Sender: TObject);
begin
  lsnStr:=DataModule_ado.ADODataSet_load.FieldByName('SN').AsString;
  if lsnStr='' then Exit;
  DataModule_ado.addWPC_single(lsnStr,1);

  DataModule_ado.subtract2TaskTable(lsnStr,1);
  refreshData_trainBlend;
end;

procedure TfrmTrainBlend.u1WClick(Sender: TObject);
begin
  usnStr:=DataModule_ado.ADODataSet_unload.FieldByName('SN').AsString;
  if usnStr='' then Exit;
  DataModule_ado.addWPC_single(usnStr,2);

  DataModule_ado.subtract2TaskTable(usnStr,2);
  refreshData_trainBlend;
end;
//load_car
procedure TfrmTrainBlend.l2sSClick(Sender: TObject);
begin
  lsnStr:=DataModule_ado.ADODataSet_load.FieldByName('SN').AsString;
  if lsnStr='' then Exit;
  if cmbCompose.Text='' then Exit;
  if edtPlace.Text='' then Exit;
  //
  entrantDateTimeStr:=dateTimePiece(dtp_dateEntrant,dtp_timeEntrant);
  finishDateTimeStr:=dateTimePiece(dtp_dateFinish,dtp_timeFinish);
  takeOutDateTimeStr:=dateTimePiece(dtp_dateTakeout,dtp_timeTakeout);
  if cmbCompose.Text='' then Exit;
  DataModule_ado.modify2Task_singleB(lsnStr,entrantDateTimeStr,
                finishDateTimeStr,takeOutDateTimeStr,
                edtPlace.Text,cmbCompose.Text,maxBNO_load,1);
  //
  refreshData_trainBlend;
  //
  postFlag1:=True;
end;

procedure TfrmTrainBlend.l3UClick(Sender: TObject);
begin
 //
  entrantDateTimeStr:=dateTimePiece(dtp_dateEntrant,dtp_timeEntrant);
  finishDateTimeStr:=dateTimePiece(dtp_dateFinish,dtp_timeFinish);
  takeOutDateTimeStr:=dateTimePiece(dtp_dateTakeout,dtp_timeTakeout);
  //exit
  if cmbCompose.Text='' then Exit;
  if edtPlace.Text='' then Exit;
  if DataModule_ado.ADODataSet_load.Bof then Exit;

  lsnStr:= DataModule_ado.ADODataSet_load.FieldByName('SN').AsString;
  if lsnStr='' then Exit;
  //bof
  while not DataModule_ado.ADODataSet_load.Bof do
  begin
    lsnStr:= DataModule_ado.ADODataSet_load.FieldByName('SN').AsString;
    DataModule_ado.modify2Task_singleB(lsnStr,entrantDateTimeStr,
                finishDateTimeStr,takeOutDateTimeStr,
                edtPlace.Text,cmbCompose.Text,maxBNO_load,1);
    //
    DataModule_ado.ADODataSet_load.Prior;
  end;
  //
  refreshData_trainBlend;
  //
  postFlag1:=True;
end;

procedure TfrmTrainBlend.l4DClick(Sender: TObject);
begin
 //
  entrantDateTimeStr:=dateTimePiece(dtp_dateEntrant,dtp_timeEntrant);
  finishDateTimeStr:=dateTimePiece(dtp_dateFinish,dtp_timeFinish);
  takeOutDateTimeStr:=dateTimePiece(dtp_dateTakeout,dtp_timeTakeout);
  //exit
  if cmbCompose.Text='' then Exit;
  if edtPlace.Text='' then Exit;
  if DataModule_ado.ADODataSet_load.Eof then Exit;

  lsnStr:= DataModule_ado.ADODataSet_load.FieldByName('SN').AsString;
  if lsnStr='' then Exit;
  //eof
  while not DataModule_ado.ADODataSet_load.Eof do
  begin
    lsnStr:= DataModule_ado.ADODataSet_load.FieldByName('SN').AsString;
    DataModule_ado.modify2Task_singleB(lsnStr,entrantDateTimeStr,
                finishDateTimeStr,takeOutDateTimeStr,
                edtPlace.Text,cmbCompose.Text,maxBNO_load,1);
    //
    DataModule_ado.ADODataSet_load.Next;
  end;
  //
  refreshData_trainBlend;
  //
  postFlag1:=True;
end;
//unload_car 
procedure TfrmTrainBlend.u2sSClick(Sender: TObject);
begin
  usnStr:=DataModule_ado.ADODataSet_unload.FieldByName('SN').AsString;
  if usnStr='' then Exit;
  if cmbCompose.Text='' then Exit;
  if edtPlace.Text='' then Exit;  
  //
  entrantDateTimeStr:=dateTimePiece(dtp_dateEntrant,dtp_timeEntrant);
  finishDateTimeStr:=dateTimePiece(dtp_dateFinish,dtp_timeFinish);
  takeOutDateTimeStr:=dateTimePiece(dtp_dateTakeout,dtp_timeTakeout);
  if cmbCompose.Text='' then Exit;
  DataModule_ado.modify2Task_singleB(usnStr,entrantDateTimeStr,
                finishDateTimeStr,takeOutDateTimeStr,
                edtPlace.Text,cmbCompose.Text,maxBNO_unload,2);
  //
  refreshData_trainBlend;
  //
  postFlag2:=True;
end;

procedure TfrmTrainBlend.u3UClick(Sender: TObject);
begin
 //
  entrantDateTimeStr:=dateTimePiece(dtp_dateEntrant,dtp_timeEntrant);
  finishDateTimeStr:=dateTimePiece(dtp_dateFinish,dtp_timeFinish);
  takeOutDateTimeStr:=dateTimePiece(dtp_dateTakeout,dtp_timeTakeout);
  //exit
  if cmbCompose.Text='' then Exit;
  if edtPlace.Text='' then Exit;
  if DataModule_ado.ADODataSet_unload.Bof then Exit;
  
  usnStr:= DataModule_ado.ADODataSet_unload.FieldByName('SN').AsString;
  if usnStr='' then Exit;
  //bof
  while not DataModule_ado.ADODataSet_unload.Bof do
  begin
    usnStr:= DataModule_ado.ADODataSet_unload.FieldByName('SN').AsString;
    DataModule_ado.modify2Task_singleB(usnStr,entrantDateTimeStr,
                finishDateTimeStr,takeOutDateTimeStr,
                edtPlace.Text,cmbCompose.Text,maxBNO_unload,2);
    //
    DataModule_ado.ADODataSet_unload.Prior;
  end;
  //
  refreshData_trainBlend;
  //
  postFlag2:=True;
end;

procedure TfrmTrainBlend.u4DClick(Sender: TObject);
begin
 //
  entrantDateTimeStr:=dateTimePiece(dtp_dateEntrant,dtp_timeEntrant);
  finishDateTimeStr:=dateTimePiece(dtp_dateFinish,dtp_timeFinish);
  takeOutDateTimeStr:=dateTimePiece(dtp_dateTakeout,dtp_timeTakeout);
  //exit
  if cmbCompose.Text='' then Exit;
  if edtPlace.Text='' then Exit;
  if DataModule_ado.ADODataSet_unload.Eof then Exit;

  usnStr:= DataModule_ado.ADODataSet_unload.FieldByName('SN').AsString;
  if usnStr='' then Exit;
  //eof
  while not DataModule_ado.ADODataSet_unload.Eof do
  begin
    usnStr:= DataModule_ado.ADODataSet_unload.FieldByName('SN').AsString;
    DataModule_ado.modify2Task_singleB(usnStr,entrantDateTimeStr,
                finishDateTimeStr,takeOutDateTimeStr,
                edtPlace.Text,cmbCompose.Text,maxBNO_unload,2);
    //
    DataModule_ado.ADODataSet_unload.Next;
  end;
  //
  refreshData_trainBlend;
  //
  postFlag2:=True;
end;

procedure TfrmTrainBlend.viewClick(Sender: TObject);
begin
  DataModule_ado.viewTask_allWPC;
  sbTrain.SimpleText:=IntToStr(recInt_sb1)+' 条数据';  
  //
  refreshData_trainBlend;
end;

procedure TfrmTrainBlend.hiddenClick(Sender: TObject);
begin
  DataModule_ado.viewTask_watiProcess(pnlOrd.Caption);
  sbTrain.SimpleText:=IntToStr(recInt_sb1)+' 条数据';
  //
  refreshData_trainBlend;
end;

procedure TfrmTrainBlend.cmbComposeChange(Sender: TObject);
begin
  //
  lbl_explanatory.Caption:=addExplanatory(DataModule_ado.ADODataSet_breed,cmbCompose.Text);
end;
//wpc->load_car
procedure TfrmTrainBlend.Al1SClick(Sender: TObject);
begin
  wsnStr:=DataModule_ado.ADODataSet_waitProcess.FieldByName('waitPID').AsString;
  if wsnStr='' then Exit;
  DataModule_ado.subtractWPC_single(wsnStr,1);

  DataModule_ado.subtractWPCTable(wsnStr);
  refreshData_trainBlend;
end;

procedure TfrmTrainBlend.Al2UClick(Sender: TObject);
begin
  //exit
  if DataModule_ado.ADODataSet_waitProcess.Bof then Exit;
  
  wsnStr:=DataModule_ado.ADODataSet_waitProcess.FieldByName('waitPID').AsString;
  if wsnStr='' then Exit;
  //bof
  while not DataModule_ado.ADODataSet_waitProcess.Bof do
  begin
    wsnStr:=DataModule_ado.ADODataSet_waitProcess.FieldByName('waitPID').AsString;

    DataModule_ado.subtractWPC_single(wsnStr,1);

    DataModule_ado.subtractWPCTable(wsnStr);
    //
    DataModule_ado.ADODataSet_waitProcess.Prior;
  end;
  refreshData_trainBlend;
end;

procedure TfrmTrainBlend.Al3DClick(Sender: TObject);
begin
  //exit
  if DataModule_ado.ADODataSet_waitProcess.Eof then Exit;
  
  wsnStr:=DataModule_ado.ADODataSet_waitProcess.FieldByName('waitPID').AsString;
  if wsnStr='' then Exit;
  //eof
  while not DataModule_ado.ADODataSet_waitProcess.Eof do
  begin
    wsnStr:=DataModule_ado.ADODataSet_waitProcess.FieldByName('waitPID').AsString;
    DataModule_ado.subtractWPC_single(wsnStr,1);

    DataModule_ado.subtractWPCTable(wsnStr);
    //
    DataModule_ado.ADODataSet_waitProcess.Next;
  end;
  refreshData_trainBlend;
end;
//wpc->uload_car
procedure TfrmTrainBlend.Au1SClick(Sender: TObject);
begin
  wsnStr:=DataModule_ado.ADODataSet_waitProcess.FieldByName('waitPID').AsString;
  if wsnStr='' then Exit;
  DataModule_ado.subtractWPC_single(wsnStr,2);

  DataModule_ado.subtractWPCTable(wsnStr);
  refreshData_trainBlend;
end;

procedure TfrmTrainBlend.Au2UClick(Sender: TObject);
begin
  //exit
  if DataModule_ado.ADODataSet_waitProcess.Bof then Exit;

  wsnStr:=DataModule_ado.ADODataSet_waitProcess.FieldByName('waitPID').AsString;
  if wsnStr='' then Exit;
  //bof
  while not DataModule_ado.ADODataSet_waitProcess.Bof do
  begin
    wsnStr:=DataModule_ado.ADODataSet_waitProcess.FieldByName('waitPID').AsString;
    DataModule_ado.subtractWPC_single(wsnStr,2);

    DataModule_ado.subtractWPCTable(wsnStr);
    //
    DataModule_ado.ADODataSet_waitProcess.Prior;
  end;
  refreshData_trainBlend;
end;

procedure TfrmTrainBlend.Au3DClick(Sender: TObject);
begin
  //exit
  if DataModule_ado.ADODataSet_waitProcess.Eof then Exit;

  wsnStr:=DataModule_ado.ADODataSet_waitProcess.FieldByName('waitPID').AsString;
  if wsnStr='' then Exit;
  //eof
  while not DataModule_ado.ADODataSet_waitProcess.Eof do
  begin
    wsnStr:=DataModule_ado.ADODataSet_waitProcess.FieldByName('waitPID').AsString;
    DataModule_ado.subtractWPC_single(wsnStr,2);

    DataModule_ado.subtractWPCTable(wsnStr);
    //
    DataModule_ado.ADODataSet_waitProcess.Next;
  end;
  refreshData_trainBlend;
end;

procedure TfrmTrainBlend.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  recI1,recI2:integer;
begin
  recI1:=DataModule_ado.getNullTime_2task('load_car');
  recI2:=DataModule_ado.getNullTime_2task('unload_car');

  if (recI1<>0)or(recI2<>0) then
  begin
    CanClose:=False;
    Application.MessageBox('有"时间"数据空项，请检查！','hint',MB_OK);
  end;
end;

procedure TfrmTrainBlend.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //
  Randomize;
  while randInt<10 do
  begin
    randInt:=Random(59);
  end;
  //
  nowStr1:=DateTimeToStr(Now);
  nowInt:=length(nowStr1);
  nowStr:=LeftStr(nowStr1,nowInt-3)+':'+IntToStr(randInt);
  if postFlag1 then
  begin
    //save 2task
    DataModule_ado.save2taskBlend('load_car',nowStr,'wpc','L');
    DataModule_ado.viewTask_load('L',IntToStr(maxBNO_load));
    //save stevedore
    DataModule_ado.addStevedore(DataModule_ado.ADODataSet_load,3);
  end;
  if postFlag2 then
  begin
    DataModule_ado.save2taskBlend('unload_car',nowStr,'wpc','U');
    DataModule_ado.viewTask_unload('U',IntToStr(maxBNO_unload));
    DataModule_ado.addStevedore(DataModule_ado.ADODataSet_unload,3);
  end;
end;

end.
