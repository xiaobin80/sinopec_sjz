unit UexpQuant;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Grids, DBGrids, DB, Menus, UpublicFunc, StrUtils,ComCtrls;

type
  TfrmExpQuant = class(TForm)
    pnlTop: TPanel;
    StatusBar1: TStatusBar;
    pnlMain: TPanel;
    pnlDateS: TPanel;
    Bevel10: TBevel;
    cmbSaveTime: TComboBox;
    Label1: TLabel;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    btnExpQuant: TButton;
    Label3: TLabel;
    edtGroup: TEdit;
    cmbDI: TComboBox;
    Label2: TLabel;
    PopupMenu1: TPopupMenu;
    D1car: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cmbSaveTimeChange(Sender: TObject);
    procedure btnExpQuantClick(Sender: TObject);
    procedure D1carClick(Sender: TObject);
  private
    h1:THandle;
    connstrADO:WideString;
    csvFilePath1,fcnFilePath1:WideString;
    { Private declarations }
  public
    operNameStr:WideString;
    //
    pTimeStr_cur:WideString;//2007.4.5
    { Public declarations }
  end;

type
  Tpro_saveFCN=procedure(saveFile1,CheckFilePath:WideString);stdcall;

var
  frmExpQuant: TfrmExpQuant;

  //dll function
  saveFCNA:Tpro_saveFCN;

implementation
uses
  UDataModule_ado,UGeneralCSV,Uquantification;
{$R *.dfm}

procedure TfrmExpQuant.FormCreate(Sender: TObject);
var
  operSqlStr3,saveTimeStr:WideString;
  i5,recDataCount:integer;
  //2007.4.5
  opersqlStr4:WideString;
  i6,trainOrderRec:integer;
begin
  operSqlStr3:='select DISTINCT past_time from trainOrder';
  recDataCount:=DataModule_ado.queryRecordCount(operSqlStr3);
  for i5:=0 to recDataCount-1 do
  begin
    saveTimeStr:=DataModule_ado.ADOQuery_temp.Fields[0].Text;
    cmbSaveTime.Items.Append(saveTimeStr);
    DataModule_ado.ADOQuery_temp.Next;
  end;
  //clear All tag-"Nexp"
  opersqlStr4:='select * from trainOrder';
  trainOrderRec:=DataModule_ado.queryRecordCount(opersqlStr4);
  for i6:=0 to trainOrderRec-1 do
  begin
    DataModule_ado.clearQuanExpTag(' ');
  end;
  //
  cmbSaveTime.ItemIndex:=cmbSaveTime.Items.Count-1;
  pTimeStr_cur:=cmbSaveTime.Text;
end;

procedure TfrmExpQuant.FormShow(Sender: TObject);
var
  i1:Integer;
  diStr:WideString;
  dayStr:WideString;
begin
  DataModule_ado.viewExpTrainOrd(pTimeStr_cur,' ');

  normGridColWidth(DBGrid1,120);
  try
    //cmbDI
    dayStr:=LeftStr(DateToStr(Now),10)+'%';
    for i1:=0 to DataModule_quantification.getDragonItemID(dayStr)-1 do
    begin
      diStr:=DataModule_quantification.SQLClientDataSet_ghch.Fields[0].AsString;
      cmbDI.Items.Add(diStr);
      DataModule_quantification.SQLClientDataSet_ghch.Next;
    end;
  except
    Application.MessageBox('与计量系统断开，请重新连接！','hint',MB_OK);
    Exit;
  end;
end;

procedure TfrmExpQuant.cmbSaveTimeChange(Sender: TObject);
begin
  DataModule_ado.viewExpTrainOrd(cmbSaveTime.Text,' ');

  normGridColWidth(DBGrid1,120);
end;

procedure TfrmExpQuant.btnExpQuantClick(Sender: TObject);
var
  csvLen:integer;
  dragonItemStr,consistStr:WideString;
  colStr1,sqlStr2:WideString;
  //
  writeVal:WideString;
  //
  saveTimeStr:WideString;
begin
  if cmbSaveTime.Text='' then
  begin
    Application.MessageBox('选择日期!','hint',MB_OK);
    Exit;
  end;
  if cmbDI.Text='' then
  begin
    Application.MessageBox('选择龙组号!','hint',MB_OK);
    Exit;
  end;
  if edtGroup.Text='' then
  begin
    Application.MessageBox('输入铁路编组号!','hint',MB_OK);
    Exit;
  end;
  //
  saveTimeStr:=cmbSaveTime.Text;
  dragonItemStr:=cmbDI.Text;
  consistStr:=edtGroup.Text;
  //
  writeVal:=DataModule_quantification.getWriteFlag(dragonItemStr);
  if writeVal='1' then
  begin
    Exit;
  end;
  //export csv quantification system
  connstrADO:=DataModule_ado.DBconnect;
  csvFilePath1:=DataModule_ado.csvFilePath2;
  csvLen:=length(csvFilePath1);
  fcnFilePath1:=LeftStr(csvFilePath1,csvLen-4)+'.fcn';
  //
  colStr1:='seriary_number,car_number,past_time';
  sqlStr2:='trainOrder where past_time='
                        +''''+saveTimeStr+''''
                        +' and quanExpTag='+''''+' '+'''';
  //export csv file
  operNameStr:=DataModule_ado.getOperatorName(operatorStr);
  if generalCSV(connstrADO,colStr1,sqlStr2,dragonItemStr,consistStr,operNameStr,csvFilePath1,
                                                                        DateTimeToStr(Now),3) then
  begin
    h1:=0;
    try
    h1:=LoadLibrary('FCN.dll');
    
    if h1<>0 then
      @saveFCNA:=GetprocAddress(h1,'saveFCN');
    if (@saveFCNA<>nil)then
      saveFCNA(fcnFilePath1,csvFilePath1);
    finally
     FreeLibrary(h1);
    end;
    //
    Application.MessageBox('导出成功!','Hint',MB_OK);
    StatusBar1.SimpleText:='导出'+IntToStr(DataSource1.DataSet.RecordCount)+' 条数据';
  end
  else
  begin
    Application.MessageBox('导出失败!','Hint',MB_OK);
    Exit;
  end;  
end;

procedure TfrmExpQuant.D1carClick(Sender: TObject);
begin
  DataModule_ado.modifyQuanExpTag('Nexp',DataSource1.DataSet.Fields[0].AsString,
                                        DataSource1.DataSet.Fields[1].AsString);
  DataModule_ado.viewExpTrainOrd(cmbSaveTime.Text,' ');
end;

end.
