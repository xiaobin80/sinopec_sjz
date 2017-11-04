unit UqueryDate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, UpublicFunc;

type
  TfrmQueryDate = class(TForm)
    GroupBox1: TGroupBox;
    cmbSaveTime: TComboBox;
    bntPrtRv: TBitBtn;
    procedure bntPrtRvClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    date8Str:WideString;
    { Private declarations }
  public
    saveTimeWStr:WideString;
    { Public declarations }
  end;

var
  frmQueryDate: TfrmQueryDate;

implementation
uses
  UprintRv5;
{$R *.dfm}

procedure TfrmQueryDate.bntPrtRvClick(Sender: TObject);
var
  sumTimeStr,sumExpensesStr:WideString;
begin
  if cmbSaveTime.Text='' then Exit;
  saveTimeWStr:=cmbSaveTime.Text;
  //
  sumTimeStr:='停留时间总计：'+DataModule_print.SUM_TarryTime(saveTimeWStr)+' 小时';
  sumExpensesStr:='延时费总计：'+DataModule_print.SUM_TarryExpenses(saveTimeWStr)+' 元';
  //
  DataModule_print.InitializeRaveDataSet(saveTimeWStr);
  try
    DataModule_print.printRv513(DataModule_print.rvFilePathStr,
                DataModule_print.rvTitleStr,date8Str,sumTimeStr,sumExpensesStr);
  except
    Application.MessageBox('打印文件丢失，请还原文件"template01.rav"','hint',MB_OK);
    Exit;
  end;
end;

procedure TfrmQueryDate.FormShow(Sender: TObject);
begin
  DataModule_print.adoDataSetRv.Close;
  DataModule_print.adoDataSetRv.CommandText:='select DISTINCT saveTime from stevedore';
  DataModule_print.adoDataSetRv.Open;

  while not DataModule_print.adoDataSetRv.Eof do
  begin
    saveTimeWStr:=DataModule_print.adoDataSetRv.Fields[0].AsString;
    cmbSaveTime.Items.Add(saveTimeWStr);

    DataModule_print.adoDataSetRv.Next;
  end;
  //
  date8Str:=IntToStr(DataModule_print.year)+'年 '
                +IntToStr(DataModule_print.month)+'月 '
                +IntToStr(DataModule_print.day)+'日';
          

end;

end.
