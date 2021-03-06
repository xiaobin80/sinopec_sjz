unit Ulog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, Grids, DBGrids, DB, ADODB, UpublicFunc,
  Menus, ImgList, XPMenu, StdCtrls, ComObj;

type
  TfrmLog = class(TForm)
    pnlTop: TPanel;
    StatusBar1: TStatusBar;
    pnlMain: TPanel;
    DBGrid1: TDBGrid;
    ADODataSet1: TADODataSet;
    DataSource1: TDataSource;
    PopupMenu1: TPopupMenu;
    EXCELE1: TMenuItem;
    ImageList1: TImageList;
    XPMenu1: TXPMenu;
    Memo2: TMemo;
    TreeView1: TTreeView;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EXCELE1Click(Sender: TObject);
  private
    procedure appAgent(sender:TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLog: TfrmLog;

implementation
uses
  UDataModule_ado;
{$R *.dfm}

procedure TfrmLog.FormShow(Sender: TObject);
begin
  ADODataSet1.Close;
  ADODataSet1.CommandText:=pnlMain.Caption;
  ADODataSet1.Open;

  normGridColWidth(DBGrid1,160);
end;

procedure TfrmLog.appAgent(sender:TObject);
begin
  StatusBar1.SimpleText:=Application.Hint;
end;

procedure TfrmLog.FormCreate(Sender: TObject);
begin
  //application hint
  Application.OnHint:=appAgent;
  //
  XPMenu1.Active:=True;
end;

procedure TfrmLog.EXCELE1Click(Sender: TObject);
var
 colnum,slnum,i:integer;
 headstr:string;
begin
  //
  TreeView1.Items.Clear;
  Memo2.Lines.Clear ;
  colnum:=ADODataSet1.FieldDefList.Count;
  Maxnum :=1;
  //slnum:=0;
  for i:=1 to colnum do
  begin
   slnum:=1;
   headstr:=ADODataSet1.FieldDefList[i-1].Name;
   while Pos('|',headstr) > 0 do
     begin
      Delete(headstr, 1, Pos('|', headstr));
      slnum:=slnum+1;
     end;
    if slNum>Maxnum then Maxnum:=slNum;
  end;
  treeADO(ADODataSet1,TreeView1);
  try
    myexcel := createoleobject('excel.application');
    myexcel.application.workbooks.add;
    myexcel.caption:=pnlTop.Caption;
    myexcel.application.visible:=true;
    workbook:=myexcel.application.workbooks[1];
    worksheet:=workbook.worksheets.item[1];
  except
    application.MessageBox('没有发现Excel,请安装office!','提示信息',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  WriteheaderADO(ADODataSet1,pnlTop.Caption,26,TreeView1);
  WriteExcelData(ADODataSet1);
  //页脚设置
  myexcel.activesheet.pagesetup.centerfooter:='第&P页';
  //
  worksheet.saveAs(excelDir+'\'+dateTimeStrFull+'log.xls');
  //workbook.close;
  //myexcel.quit;
end;

end.
