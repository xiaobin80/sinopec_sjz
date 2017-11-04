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
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cmbSaveTimeChange(Sender: TObject);
    procedure btnExpQuantClick(Sender: TObject);
  private
    h1:THandle;
    connstrADO:WideString;
    csvFilePath1,fcnFilePath1:WideString;
    { Private declarations }
  public
    operNameStr:WideString;
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
begin
  operSqlStr3:='select DISTINCT saveTime from stevedore';
  recDataCount:=DataModule_ado.queryRecordCount(operSqlStr3);
  for i5:=0 to recDataCount-1 do
  begin
    saveTimeStr:=DataModule_ado.ADOQuery_temp.Fields[0].Text;
    cmbSaveTime.Items.Append(saveTimeStr);
    DataModule_ado.ADOQuery_temp.Next;
  end;
end;

procedure TfrmExpQuant.FormShow(Sender: TObject);
var
  i1:Integer;
  diStr:WideString;
  dayStr:WideString;
begin
  DataModule_ado.ADODataSet_stevedore.Close;
  DataModule_ado.ADODataSet_stevedore.CommandText:='select car_breed AS ����,'
                +'car_number AS ����,station AS ����վ,cargo_name AS Ʒ��,'
                +'past_time AS ����,entrant_time AS װж��ʼ,finish_time AS װж���,'
                +'takeout_time AS �ҳ�'
                +' from stevedore where stevedoreNO='
                +IntToStr(DataModule_ado.maxStevedoreNO);
  DataModule_ado.ADODataSet_stevedore.Open;

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
    Application.MessageBox('��ϵͳ�Ͽ������������ӣ�','hint',MB_OK);
    Exit;
  end;
end;

procedure TfrmExpQuant.cmbSaveTimeChange(Sender: TObject);
begin
  DataModule_ado.ADODataSet_stevedore.Close;
  DataModule_ado.ADODataSet_stevedore.CommandText:='select car_breed AS ����,'
                +'car_number AS ����,station AS ����վ,cargo_name AS Ʒ��,'
                +'past_time AS ����,entrant_time AS װж��ʼ,finish_time AS װж���,'
                +'takeout_time AS �ҳ�'                
                +' from stevedore where saveTime='+''''+cmbSaveTime.Text+'''';
  DataModule_ado.ADODataSet_stevedore.Open;

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
    Application.MessageBox('ѡ������!','hint',MB_OK);
    Exit;
  end;
  if cmbDI.Text='' then
  begin
    Application.MessageBox('ѡ�������!','hint',MB_OK);
    Exit;
  end;
  if edtGroup.Text='' then
  begin
    Application.MessageBox('������·�����!','hint',MB_OK);
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
  sqlStr2:='stevedore where saveTime='+''''+saveTimeStr+'''';
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
    Application.MessageBox('�����ɹ�!','Hint',MB_OK);
    StatusBar1.SimpleText:='����'+IntToStr(DataSource1.DataSet.RecordCount)+' ������';
  end
  else
  begin
    Application.MessageBox('����ʧ��!','Hint',MB_OK);
    Exit;
  end;  
end;

end.