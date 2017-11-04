unit UcarKind;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, Grids, DBGrids, DB, ADODB, UpublicFunc,
  Menus;

type
  TfrmCarKind = class(TForm)
    pnlTop: TPanel;
    StatusBar1: TStatusBar;
    DBGrid1: TDBGrid;
    ADODataSet1: TADODataSet;
    DataSource1: TDataSource;
    PopupMenu1: TPopupMenu;
    E1: TMenuItem;
    A1: TMenuItem;
    S1: TMenuItem;
    D1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure E1Click(Sender: TObject);
    procedure A1Click(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure D1Click(Sender: TObject);
    procedure ADODataSet1PostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure ADODataSet1EditError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
  private
    procedure appAgent(sender:TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCarKind: TfrmCarKind;

implementation
uses
  UDataModule_ado;
{$R *.dfm}

procedure TfrmCarKind.FormShow(Sender: TObject);
begin
  ADODataSet1.Close;
  ADODataSet1.CommandText:='select car_kind AS 车种名称,initial AS 车种简称 from carKind';
  ADODataSet1.Open;

  normGridColWidth(DBGrid1,160);
end;

procedure TfrmCarKind.appAgent(sender:TObject);
begin
  StatusBar1.SimpleText:=Application.Hint;
end;

procedure TfrmCarKind.FormCreate(Sender: TObject);
begin
  //application hint
  Application.OnHint:=appAgent;
end;

procedure TfrmCarKind.E1Click(Sender: TObject);
begin
  ADODataSet1.Edit;
end;

procedure TfrmCarKind.A1Click(Sender: TObject);
begin
  ADODataSet1.Append;
end;

procedure TfrmCarKind.S1Click(Sender: TObject);
begin
  ADODataSet1.Post;
end;

procedure TfrmCarKind.D1Click(Sender: TObject);
begin
  ADODataSet1.Delete;
end;

procedure TfrmCarKind.ADODataSet1PostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  E.Message:='车种简称重复，请选择其他字母。';
end;

procedure TfrmCarKind.ADODataSet1EditError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  e.Message:='请重新进入本窗体进行设置';
end;

end.
