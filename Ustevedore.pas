unit Ustevedore;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Grids, DBGrids, DB, Menus, UpublicFunc,
  ComObj, ImgList, XPMenu;

type
  TfrmStevedore = class(TForm)
    pnlTop: TPanel;
    StatusBar1: TStatusBar;
    pnlMain: TPanel;
    pnlDateS: TPanel;
    Bevel10: TBevel;
    cmbSaveTime: TComboBox;
    Label1: TLabel;
    DBGrid1: TDBGrid;
    PopupMenu1: TPopupMenu;
    EXCELE1: TMenuItem;
    DataSource1: TDataSource;
    TreeView1: TTreeView;
    Memo2: TMemo;
    ImageList1: TImageList;
    XPMenu1: TXPMenu;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cmbSaveTimeChange(Sender: TObject);
    procedure EXCELE1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmStevedore: TfrmStevedore;

implementation
uses
  UDataModule_ado;
{$R *.dfm}

procedure TfrmStevedore.FormCreate(Sender: TObject);
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
  //
  XPMenu1.Active:=True;
end;

procedure TfrmStevedore.FormShow(Sender: TObject);
begin
  DataModule_ado.ADODataSet_stevedore.Close;
  DataModule_ado.ADODataSet_stevedore.CommandText:='select car_breed AS 车种,'
                +'car_number AS 车号,station AS 发到站,cargo_name AS 品名,'
                +'past_time AS 调妥,entrant_time AS 装卸开始,finish_time AS 装卸完成,'
                +'takeout_time AS 挂出'
                +' from stevedore where stevedoreNO='
                +IntToStr(DataModule_ado.maxStevedoreNO);
  DataModule_ado.ADODataSet_stevedore.Open;

  normGridColWidth(DBGrid1,120);
end;

procedure TfrmStevedore.cmbSaveTimeChange(Sender: TObject);
begin
  DataModule_ado.ADODataSet_stevedore.Close;
  DataModule_ado.ADODataSet_stevedore.CommandText:='select car_breed AS 车种,'
                +'car_number AS 车号,station AS 发到站,cargo_name AS 品名,'
                +'past_time AS 调妥,entrant_time AS 装卸开始,finish_time AS 装卸完成,'
                +'takeout_time AS 挂出'                
                +' from stevedore where saveTime='+''''+cmbSaveTime.Text+'''';
  DataModule_ado.ADODataSet_stevedore.Open;

  normGridColWidth(DBGrid1,120);
end;

procedure TfrmStevedore.EXCELE1Click(Sender: TObject);
var
 colnum,slnum,i:integer;
 headstr:string;
 //
 saveTimeStr:WideString;
 taskType:integer;
begin
  if cmbSaveTime.Text='' then Exit;
  saveTimeStr:=cmbSaveTime.Text;
  taskType:=DataModule_ado.getTaskType(saveTimeStr);
  if taskType>2 then
  begin
    DataModule_ado.extractExcelData_load(saveTimeStr);
    DataModule_ado.extractExcelData_unload(saveTimeStr);
    DataModule_ado.exprotExcel_stevedore(saveTimeStr,3);
  end
  else
  begin
    DataModule_ado.exprotExcel_stevedore(saveTimeStr,taskType);
  end;
  //
  TreeView1.Items.Clear;
  Memo2.Lines.Clear ;
  colnum:=DataModule_ado.ADODataSet_Excel.FieldDefList.Count;
  Maxnum :=1;
  //slnum:=0;
  for i:=1 to colnum do
  begin
   slnum:=1;
   headstr:=DataModule_ado.ADODataSet_Excel.FieldDefList[i-1].Name;
   while Pos('_',headstr) > 0 do
     begin
      Delete(headstr, 1, Pos('_', headstr));
      slnum:=slnum+1;
     end;
    if slNum>Maxnum then Maxnum:=slNum;
  end;
  treeADO(DataModule_ado.ADODataSet_Excel,TreeView1);
  try
    myexcel := createoleobject('excel.application');
    myexcel.application.workbooks.add;
    myexcel.caption:=pnlMain.Caption;
    myexcel.application.visible:=true;
    workbook:=myexcel.application.workbooks[1];
    worksheet:=workbook.worksheets.item[1];
  except
    application.MessageBox('没有发现Excel,请安装office!','提示信息',
                                                        MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  WriteheaderADO(DataModule_ado.ADODataSet_Excel,pnlMain.Caption,13,TreeView1);
  //
  WriteExcelData(DataModule_ado.ADODataSet_Excel);//load_car&unload_car

  //页脚设置
  myexcel.activesheet.pagesetup.centerfooter:='第&P页';
  //
  worksheet.saveAs(excelDir+'\'+dateTimeStrFull+'work.xls');
  //workbook.close;
  //myexcel.quit;

  //clear exportExcel table
  DataModule_ado.clearExportExcelTable('exportExcel');
end;


end.
