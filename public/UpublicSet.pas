unit UpublicSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, Grids, DBGrids, DB, ADODB, UpublicFunc,
  Menus;

type
  TfrmPulicSet = class(TForm)
    pnlTop: TPanel;
    StatusBar1: TStatusBar;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    PopupMenu1: TPopupMenu;
    E1: TMenuItem;
    A1: TMenuItem;
    S1: TMenuItem;
    D1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure E1Click(Sender: TObject);
    procedure A1Click(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure D1Click(Sender: TObject);
    procedure ADODataSet1PostError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure ADODataSet1EditError(DataSet: TDataSet; E: EDatabaseError;
      var Action: TDataAction);
    procedure FormShow(Sender: TObject);
  private
    procedure appAgent(sender:TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPulicSet: TfrmPulicSet;

implementation
uses
  UDataModule_ado;
{$R *.dfm}

procedure TfrmPulicSet.appAgent(sender:TObject);
begin
  StatusBar1.SimpleText:=Application.Hint;
end;

procedure TfrmPulicSet.FormCreate(Sender: TObject);
begin
  //application hint
  Application.OnHint:=appAgent;
end;

procedure TfrmPulicSet.E1Click(Sender: TObject);
begin
  DataModule_ado.ADODataSet_publicSet.Edit;
end;

procedure TfrmPulicSet.A1Click(Sender: TObject);
begin
  DataModule_ado.ADODataSet_publicSet.Append;
end;

procedure TfrmPulicSet.S1Click(Sender: TObject);
begin
  DataModule_ado.ADODataSet_publicSet.Post;
end;

procedure TfrmPulicSet.D1Click(Sender: TObject);
begin
  DataModule_ado.ADODataSet_publicSet.Delete;
end;

procedure TfrmPulicSet.ADODataSet1PostError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  E.Message:='�༭��������鿴�������!';
end;

procedure TfrmPulicSet.ADODataSet1EditError(DataSet: TDataSet;
  E: EDatabaseError; var Action: TDataAction);
begin
  e.Message:='�����½��뱾�����������';
end;

procedure TfrmPulicSet.FormShow(Sender: TObject);
begin
  normGridColWidth(DBGrid1,160);
end;

end.