unit UprintRv5;

interface

uses
  SysUtils, Classes, RpCon, RpConDS, RpBase, RpSystem, RpDefine, RpRave,
  DB, ADODB, IniFiles, RpRenderPreview;

type
  TDataModule_print = class(TDataModule)
    RvProject1: TRvProject;
    RvDataSetConnection1: TRvDataSetConnection;
    adoDataSetRv: TADODataSet;
    adoQuerySUM: TADOQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    rvPrintIni:TIniFile;
    { Private declarations }
  public
    rvFilePathStr,rvTitleStr:WideString;
    year,month,day,DOW:Word;
    //
    function InitializeRaveDataSet(saveTimeStrA:WideString):Boolean;
    function SUM_TarryTime(saveTimeStrA:WideString):WideString;
    function SUM_TarryExpenses(saveTimeStrA:WideString):WideString;
    function printRv513(rvFileStrA,rvTitleStrA,dateStrA,
                sumTarryTimeStrA,sumExpensesStrA:WideString):Boolean;
    { Public declarations }
  end;

var
  DataModule_print: TDataModule_print;

implementation
uses
  UDataModule_ado,RVClass, RVProj, RVCsStd,RvCsRpt,RvCsData;
{$R *.dfm}

function TDataModule_print.InitializeRaveDataSet(saveTimeStrA:WideString):Boolean;
begin
  adoDataSetRv.Close;
  adoDataSetRv.CommandText:='select seriary_number AS SN,car_breed AS breedCar,'
                        +'car_number AS numberCar,'
                        +'station AS SPstation,cargo_name AS cargoName,'
                        +'past_time AS timeStart,entrant_time AS entrantTime,'
                        +'finish_time AS finishTime,takeout_time AS takeoutTime,'
                        +'tarryTime AS tarryTime,tarry_expenses AS expenses,'
                        +'stevedore_notepad AS notepad'
                        +' from stevedore where saveTime='+''''+saveTimeStrA+''''
                        +' ORDER BY seriary_number';
  adoDataSetRv.Open;

  Result:=True;
end;

function TDataModule_print.SUM_TarryTime(saveTimeStrA:WideString):WideString;
var
  sumTarryStr:WideString;
begin
  adoQuerySUM.Close;
  adoQuerySUM.SQL.Clear;
  adoQuerySUM.SQL.Text:='select Sum(tarryTime) from stevedore where saveTime='
                                                        +''''+saveTimeStrA+'''';
  adoQuerySUM.Open;

  sumTarryStr:=adoQuerySUM.Fields[0].AsString;
  Result:=sumTarryStr;
end;

function TDataModule_print.SUM_TarryExpenses(saveTimeStrA:WideString):WideString;
var
  sumTarryExpensesStr:WideString;
begin
  adoQuerySUM.Close;
  adoQuerySUM.SQL.Clear;
  adoQuerySUM.SQL.Text:='select Sum(tarry_expenses) from stevedore where saveTime='
                                                        +''''+saveTimeStrA+'''';
  adoQuerySUM.Open;

  sumTarryExpensesStr:=adoQuerySUM.Fields[0].AsString;
  Result:=sumTarryExpensesStr
end;

function TDataModule_print.printRv513(rvFileStrA,rvTitleStrA,dateStrA,
                sumTarryTimeStrA,sumExpensesStrA:WideString):Boolean;
var
  MyPage1:TRavePage;
  RvTitleHeader:TRaveText;
  RvTarryTimeSUM,RvExpensesSUM:TRaveText;
  //
  RvRailwayVisa,RvPrivateSquare,RvDate8Count:TRaveText;
begin
   //RvProject1.ProjectFile:=rvFileStrA;
   //
   RvProject1.Open;

   With RvProject1.ProjMan do
   begin
     MyPage1:=findravecomponent('Report1.Page1',nil)as TRavePage;
     RvTitleHeader:=findravecomponent('RvTitleHeader',MyPage1)as TRaveText;
     //
     RVTarryTimeSUM:=FindRaveComponent('tarryTimeSUM',MyPage1)as TRaveText;
     RvExpensesSUM:=FindRaveComponent('expensesSUM',MyPage1)as TRaveText;
     //
     RvRailwayVisa:=FindRaveComponent('RailwayVisa',MyPage1)as TRaveText;
     RvPrivateSquare:=FindRaveComponent('PrivateSquare',MyPage1)as TRaveText;
     RvDate8Count:=FindRaveComponent('Date8Count',MyPage1)as TRaveText;
     //
     RvTitleHeader.Text:=rvTitleStrA;
     //
     RvTarryTimeSUM.Text:=sumTarryTimeStrA;
     RvExpensesSUM.Text:=sumExpensesStrA;
     //
     RvRailwayVisa.Text:='铁路方签章';
     RvPrivateSquare.Text:='专用线签章';
     RvDate8Count.Text:=dateStrA;
   end;
   //
   RvProject1.ExecuteReport('Report1');

   RvProject1.Close;

   Result:=True;
end;

procedure TDataModule_print.DataModuleCreate(Sender: TObject);
begin
  rvPrintIni:=TIniFile.Create(ExtractFilePath(ParamStr(0))+'CDPconfig.ini');
  rvFilePathStr:=rvPrintIni.ReadString('filePath','4','c:\template01.rav');
  rvTitleStr:=rvPrintIni.ReadString('title','3','石炼编组站');
  DecodeDateFully(Now,year,month,day,DOW);
end;

procedure TDataModule_print.DataModuleDestroy(Sender: TObject);
begin
  rvPrintIni.Free;
end;

end.
