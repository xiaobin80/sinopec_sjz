unit UDataModule_ado;

interface

uses
  Windows, SysUtils, Classes, DB, ADODB, StrUtils, Forms, DBGrids,
  Math,IniFiles;

type
  TDataModule_ado = class(TDataModule)
    adoConnMain: TADOConnection;
    ADOQuery_Exec: TADOQuery;
    ADODataSet_trainOrder: TADODataSet;
    ADODataSet_traintotalh: TADODataSet;
    ADODataSet_breed: TADODataSet;
    ADODataSet_carNumber: TADODataSet;
    ADODataSet_Excel: TADODataSet;
    ADOQuery_temp: TADOQuery;
    adodataset_login: TADODataSet;
    ADODataSet_load: TADODataSet;
    ADODataSet_stevedore: TADODataSet;
    ADODataSet_2task: TADODataSet;
    ADODataSet_waitProcess: TADODataSet;
    ADODataSet_unload: TADODataSet;
    ADODataSet_getTrainData: TADODataSet;
    ADODataSet_get2TaskData: TADODataSet;
    ADODataSet_WPCprocess: TADODataSet;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    currentDir1:WideString;
    xbfini:TIniFile;
    { Private declarations }
  public
    titleFrmMain:WideString;
    titleExcelStr:WideString;
    csvFilePath2:WideString;
    DBconnect:WideString;
    //
    function clearExportExcelTable(tableNameStrA:WideString):Boolean;
    function queryNormalOperatorCount:Integer;
    function queryRecordCount(sqlStr:WideString):Integer;
    function queryRecCo2task(tableNameStrA,maxBatchNOStrA:WideString):Integer;
    function queryRecCo2taskBlend(tableNameStrA,WPCFlagStrA:WideString):Integer;
    function getOperatorName(operIDStrA:WideString):WideString;
    function getDataTrain(past_timeStr:WideString):Integer;
    function getNullTime_2task(tableNameStrA:WideString):Integer;
    function getFreeTime(dictionaryStrA:WideString):Double;
    function getUnivalent(dictionaryStrA:WideString):Double;
    function getTaskType(saveTimeStrA:WideString):Integer;
    function extractExcelData_load(saveTimeStrA:WideString):Boolean;
    function extractExcelData_unload(saveTimeStrA:WideString):Boolean;
    function viewDataTrain(time_rportStr:WideString):Integer;
    function view2task(tableNameStr,sqlStrA,time_rportstrA:WideString):Integer;
    function viewTask_load(WPCFlagStrA,maxBNOStrA:WideString):Integer;
    function viewTask_unload(WPCFlagStrA,maxBNOStrA:WideString):Integer;
    function viewTask_watiProcess(time_rportstrA:WideString):Integer;
    function viewTask_allWPC:Integer;
    function compareTrain2car_number:Boolean;
    function maxCar_number:integer;
    function maxTrainTotalH:Integer;
    function maxBatchNO2task(tableNameStr:WideString):Integer;
    function maxStevedoreNO:Integer;
    function addLogTableData(operIDStrA,operNameStrA,operLogStrA,
                                                operLogTimeStrA:WideString):Boolean;
    function addTrianOrder(idMaster:integer):Boolean;
    function addCar_nmuber(trian_number:integer):Boolean;
    function add2Task_more(past_timeStrA:WideString;taskType:Integer):Boolean;
    function addWPC_more(past_timeStrA:WideString):Boolean;
    function addStevedore(adoDataSetX:TADODataSet;tagI:Integer):Boolean;
    function addWPC_single(snStrA:WideString;taskType:Integer):Boolean;
    function subtractTrainOrder(past_timeStrA:WideString):Boolean;
    function subtract2TaskTable(snStrA:WideString;taskType:Integer):Boolean;
    function subtractWPCTable(wsnStrA:WideString):Boolean;
    function subtractWPC_single(wsnStrA:WideString;taskType:Integer):Boolean;
    function exportExcel_ord(time_rportStrA:WideString):Boolean;
    function exprotExcel_stevedore(saveTimeStr:WideString;taskTagI:Integer):Boolean;
    function save2task(tableNameStr,saveTimeStr,maxBNOStrA:WideString):Boolean;
    function save2taskBlend(tableNameStr,saveTimeStr,OldwpcFlagStrA,
                                                NewwpcFlagStrA:WideString):Boolean;
    function modifyTrainOrd4(snStrA,pStationStrA,cargoStrA,
                                oStationStrA,noteStrA,pTimeStrA:WideString):Boolean;
    function modify2Task_singleA(snStrA,
                                entrant_timeStrA,finish_timeStrA,takeout_timeStrA,
                                placeStrA,dictionaryStrA:WideString;
                                taskType:Integer):Boolean;
    function modify2Task_singleB(snStrA,
                            entrant_timeStrA,finish_timeStrA,takeout_timeStrA,
                            placeStrA,dictionaryStrA:WideString;
                            maxBatchNOInt,taskType:Integer):Boolean;
    { Public declarations }
  end;

  TreadXBF=function(DimRecord: Integer;filename1:WideString):WideString;stdcall;

var
  DataModule_ado: TDataModule_ado;

  connstring:TreadXBF;
  //
  handlers:WideString;
  operatorStr:WideString;
  xbf:WideString;    //xbf path

implementation

{$R *.dfm}

//clear
function TDataModule_ado.clearExportExcelTable(tableNameStrA:WideString):Boolean;
begin
  ADOQuery_temp.Close;
  ADOQuery_temp.SQL.Clear;
  ADOQuery_temp.SQL.Text:='DELETE from '+tableNameStrA;
  ADOQuery_temp.ExecSQL;

  Result:=True;
end;
//exprot
function TDataModule_ado.exprotExcel_stevedore(saveTimeStr:WideString;taskTagI:Integer):Boolean;
begin
  case taskTagI of
    1:
      begin
        ADODataSet_Excel.Close;
        ADODataSet_Excel.CommandText:='select LC.seriary_number AS [装车作业_顺序],LC.cargo_name AS [装车作业_品名],'
                              +'LC.car_number AS [装车作业_车号],LC.loadMemo AS [装车作业_备注],'
                              +'LC.past_station AS [装车作业_到站],'
                              +'LC.load_place AS [装车作业_装车地点],LC.entrant_time AS [装车作业_送入时间],'
                              +'LC.finish_time AS [装车作业_装完时间],LC.takeout_time AS [装车作业_取出时间],'
                              +'LC.load_notepad AS [装车作业_记事],'
                              +'ULC.seriary_number AS [卸车作业_顺序],ULC.cargo_name AS [卸车作业_品名],'
                              +'ULC.car_number AS [卸车作业_车号],ULC.unloadMemo AS [卸车作业_备注],'
                              +'ULC.send_station AS [卸车作业_到站],ULC.unload_place AS [卸车作业_装车地点],'
                              +'ULC.entrant_time AS [卸车作业_送入时间],ULC.finish_time AS [卸车作业_装完时间],'
                              +'ULC.takeout_time AS [卸车作业_取出时间],ULC.unload_notepad AS [卸车作业_记事]'
                              +' from load_car LC LEFT OUTER JOIN unload_car ULC ON LC.saveTime=ULC.saveTime'
                              +' where LC.saveTime='+''''+saveTimeStr+''''
                              +' OR ULC.saveTime='+''''+saveTimeStr+''''
                              +' ORDER BY LC.seriary_number ASC,ULC.seriary_number ASC';
        ADODataSet_Excel.Open;
      end;
    2:
      begin
        ADODataSet_Excel.Close;
        ADODataSet_Excel.CommandText:='select LC.seriary_number AS [装车作业_顺序],LC.cargo_name AS [装车作业_品名],'
                              +'LC.car_number AS [装车作业_车号],LC.loadMemo AS [装车作业_备注],'
                              +'LC.past_station AS [装车作业_到站],'
                              +'LC.load_place AS [装车作业_装车地点],LC.entrant_time AS [装车作业_送入时间],'
                              +'LC.finish_time AS [装车作业_装完时间],LC.takeout_time AS [装车作业_取出时间],'
                              +'LC.load_notepad AS [装车作业_记事],'
                              +'ULC.seriary_number AS [卸车作业_顺序],ULC.cargo_name AS [卸车作业_品名],'
                              +'ULC.car_number AS [卸车作业_车号],ULC.unloadMemo AS [卸车作业_备注],'
                              +'ULC.send_station AS [卸车作业_到站],ULC.unload_place AS [卸车作业_装车地点],'
                              +'ULC.entrant_time AS [卸车作业_送入时间],ULC.finish_time AS [卸车作业_装完时间],'
                              +'ULC.takeout_time AS [卸车作业_取出时间],ULC.unload_notepad AS [卸车作业_记事]'
                              +' from load_car LC RIGHT OUTER JOIN unload_car ULC ON LC.saveTime=ULC.saveTime'
                              +' where LC.saveTime='+''''+saveTimeStr+''''
                              +' OR ULC.saveTime='+''''+saveTimeStr+''''
                              +' ORDER BY LC.seriary_number ASC,ULC.seriary_number ASC';
        ADODataSet_Excel.Open;
      end;
    else
      begin
        ADODataSet_Excel.Close;
        ADODataSet_Excel.CommandText:='select Lsn AS [装车作业_顺序],Lcargo_name AS [装车作业_品名],'
                              +'Lcar_number AS [装车作业_车号],LloadMemo AS [装车作业_备注],'
                              +'Lpast_station AS [装车作业_到站],'
                              +'Lload_place AS [装车作业_装车地点],Lentrant_time AS [装车作业_送入时间],'
                              +'Lfinish_time AS [装车作业_装完时间],Ltakeout_time AS [装车作业_取出时间],'
                              +'Lload_notepad AS [装车作业_记事],'
                              +'Usn AS [卸车作业_顺序],Ucargo_name AS [卸车作业_品名],'
                              +'Ucar_number AS [卸车作业_车号],UunloadMemo AS [卸车作业_备注],'
                              +'Usend_station AS [卸车作业_到站],Uunload_place AS [卸车作业_装车地点],'
                              +'Uentrant_time AS [卸车作业_送入时间],Ufinish_time AS [卸车作业_装完时间],'
                              +'Utakeout_time AS [卸车作业_取出时间],Uunload_notepad AS [卸车作业_记事]'
                              +' from exportExcel'
                              +' where saveTime='+''''+saveTimeStr+''''
                              +' ORDER BY Lsn ASC,Usn ASC';
        ADODataSet_Excel.Open;
      end;
    end;//case
  Result:=True;
end;

function TDataModule_ado.exportExcel_ord(time_rportStrA:WideString):Boolean;
begin
  ADODataSet_Excel.Close;
  ADODataSet_Excel.CommandText:='select seriary_number AS 顺序,car_breed AS 车种,car_number AS 车号,'
                        +'ordMemo AS 备注,past_station AS 到站,cargo_name AS 货物名称,'
                        +'original_station AS 发站,tarpaulin AS 蓬布, ord_notepad AS 记事'
                        +' from trainOrder where past_time='+''''+time_rportStrA+''''
                        +' order by seriary_number';
  ADODataSet_Excel.Open;
  //
  Result:=True;
end;
//query
function TDataModule_ado.queryNormalOperatorCount:Integer;
var
  recordContI5:integer;
begin
  ADOQuery_temp.Close;
  ADOQuery_temp.SQL.Clear;
  ADOQuery_temp.SQL.Text:='select OperID from operator where tag=false order by OperID';
  ADOQuery_temp.Open;

  recordContI5:=ADOQuery_temp.RecordCount;
  Result:=recordContI5;
end;

function TDataModule_ado.queryRecordCount(sqlStr:WideString):Integer;
var
  recI1:integer;
begin
  try
    ADOQuery_temp.Close;
    ADOQuery_temp.SQL.Clear;
    ADOQuery_temp.SQL.Text:=sqlStr;
    ADOQuery_temp.Open;

    recI1:=ADOQuery_temp.RecordCount;
    Result:=recI1;
  except
    Result:=-1;
  end;
end;

function TDataModule_ado.queryRecCo2task(tableNameStrA,maxBatchNOStrA:WideString):Integer;
var
  recI8:integer;
begin
  ADODataSet_get2TaskData.Close;
  ADODataSet_get2TaskData.CommandText:='select * from '+tableNameStrA
                                        +' where batchNO='+maxBatchNOStrA;
  ADODataSet_get2TaskData.Open;

  recI8:=ADODataSet_get2TaskData.RecordCount;
  Result:=recI8;
end;

function TDataModule_ado.queryRecCo2taskBlend(tableNameStrA,WPCFlagStrA:WideString):Integer;
var
  recI8:integer;
begin
  ADODataSet_get2TaskData.Close;
  ADODataSet_get2TaskData.CommandText:='select * from '+tableNameStrA
                                        +' where WPCFlag='+''''+WPCFlagStrA+'''';
  ADODataSet_get2TaskData.Open;

  recI8:=ADODataSet_get2TaskData.RecordCount;
  Result:=recI8;
end;
//extract
function TDataModule_ado.extractExcelData_load(saveTimeStrA:WideString):Boolean;
var
  recCountI1,I1:integer;
  //
  LsnStr,Lcargo_nameStr,Lcar_numberStr,LloadMemoStr,Lpast_stationStr:WideString;
  Lload_placeStr,Lentrant_timeStr,Lfinish_timeStr,Ltakeout_timeStr,Lload_notepadStr:WideString;
begin
  //load_car
  ADODataSet_load.Close;
  ADODataSet_load.CommandText:='select * from load_car where saveTime='+''''+saveTimeStrA+''''
                                +' order by seriary_number';
  ADODataSet_load.Open;

  recCountI1:=ADODataSet_load.RecordCount;
  
  for I1:=0 to recCountI1-1 do
  begin
    LsnStr:=ADODataSet_load.FieldByName('seriary_number').AsString;
    Lcargo_nameStr:=ADODataSet_load.FieldByName('cargo_name').AsString;
    Lcar_numberStr:=ADODataSet_load.FieldByName('car_number').AsString;
    LloadMemoStr:=ADODataSet_load.FieldByName('loadMemo').AsString;
    Lpast_stationStr:=ADODataSet_load.FieldByName('past_station').AsString;
    Lload_placeStr:=ADODataSet_load.FieldByName('load_place').AsString;
    Lentrant_timeStr:=ADODataSet_load.FieldByName('entrant_time').AsString;
    Lfinish_timeStr:=ADODataSet_load.FieldByName('finish_time').AsString;
    Ltakeout_timeStr:=ADODataSet_load.FieldByName('takeout_time').AsString;
    Lload_notepadStr:=ADODataSet_load.FieldByName('load_notepad').AsString;

    ADOQuery_Exec.Close;
    ADOQuery_Exec.SQL.Clear;
    ADOQuery_Exec.SQL.Text:='INSERT INTO exportExcel(Lsn,Lcargo_name,Lcar_number,'
                  +'LloadMemo,Lpast_station,Lload_place,'
                  +'Lentrant_time,Lfinish_time,Ltakeout_time,Lload_notepad,saveTime)'
                  +' values('
                  +''+LsnStr+''+','
                  +''''+Lcargo_nameStr+''''+','
                  +''''+Lcar_numberStr+''''+','
                  +''''+LloadMemoStr+''''+','+''''
                  +Lpast_stationStr+''''+','
                  +''''+Lload_placeStr+''''+','
                  +''''+Lentrant_timeStr+''''+','
                  +''''+Lfinish_timeStr+''''+','
                  +''''+Ltakeout_timeStr+''''+','
                  +''''+Lload_notepadStr+''''+','
                  +''''+saveTimeStrA+''''
                  +')';
    ADOQuery_Exec.ExecSQL;

    ADODataSet_load.Next;
  end;

  Result:=True;
end;

function TDataModule_ado.extractExcelData_unload(saveTimeStrA:WideString):Boolean;
var
  recCountI2,I2:integer;
  //
  UsnStr,Ucargo_nameStr,Ucar_numberStr,UunloadMemoStr,Usend_stationStr:WideString;
  Uunload_placeStr,Uentrant_timeStr,Ufinish_timeStr,Utakeout_timeStr,Uunload_notepadStr:WideString;
begin
  //unload_car
  ADODataSet_unload.Close;
  ADODataSet_unload.CommandText:='select * from unload_car where saveTime='+''''+saveTimeStrA+''''
                                 +' order by seriary_number';
  ADODataSet_unload.Open;

  recCountI2:=ADODataSet_unload.RecordCount;

  for I2:=0 to recCountI2-1 do
  begin
    UsnStr:=ADODataSet_unload.FieldByName('seriary_number').AsString;
    Ucargo_nameStr:=ADODataSet_unload.FieldByName('cargo_name').AsString;
    Ucar_numberStr:=ADODataSet_unload.FieldByName('car_number').AsString;
    UunloadMemoStr:=ADODataSet_unload.FieldByName('unloadMemo').AsString;
    Usend_stationStr:=ADODataSet_unload.FieldByName('send_station').AsString;
    Uunload_placeStr:=ADODataSet_unload.FieldByName('unload_place').AsString;
    Uentrant_timeStr:=ADODataSet_unload.FieldByName('entrant_time').AsString;
    Ufinish_timeStr:=ADODataSet_unload.FieldByName('finish_time').AsString;
    Utakeout_timeStr:=ADODataSet_unload.FieldByName('takeout_time').AsString;
    Uunload_notepadStr:=ADODataSet_unload.FieldByName('unload_notepad').AsString;
    //
    ADOQuery_Exec.Close;
    ADOQuery_Exec.SQL.Clear;
    ADOQuery_Exec.SQL.Text:='INSERT INTO exportExcel(Usn,Ucargo_name,Ucar_number,UunloadMemo,Usend_station,'
                  +'Uunload_place,Uentrant_time,Ufinish_time,Utakeout_time,Uunload_notepad,saveTime)'
                  +' values('
                  +''+UsnStr+''+','+''''+Ucargo_nameStr+''''+','
                  +''''+Ucar_numberStr+''''+','
                  +''''+UunloadMemoStr+''''+','+''''+Usend_stationStr+''''+','
                  +''''+Uunload_placeStr+''''+','
                  +''''+Uentrant_timeStr+''''+','+''''+Ufinish_timeStr+''''+','
                  +''''+Utakeout_timeStr+''''+','
                  +''''+Uunload_notepadStr+''''+','+''''+saveTimeStrA+''''
                  +')';
    ADOQuery_Exec.ExecSQL;

    ADODataSet_unload.Next;
  end;

  Result:=True;
end;
//get
function TDataModule_ado.getOperatorName(operIDStrA:WideString):WideString;
var
  operNameStr:WideString;
begin
  ADOQuery_temp.Close;
  ADOQuery_temp.SQL.Clear;
  ADOQuery_temp.SQL.Text:='select operName from operator where operID='+operIDStrA;
  ADOQuery_temp.Open;

  operNameStr:=ADOQuery_temp.Fields[0].AsString;
  Result:=operNameStr;
end;

function TDataModule_ado.getDataTrain(past_timeStr:WideString):Integer;
var
  recordCountI6:integer;
begin
  ADODataSet_getTrainData.Close;
  ADODataSet_getTrainData.CommandText:='select seriary_number,car_breed,car_number,'
                        +'ordMemo,past_station,cargo_name,original_station,'
                        +'tarpaulin,ord_notepad'
                        +' from trainOrder where past_time='+''''+past_timeStr+''''
                        +' order by seriary_number';
  ADODataSet_getTrainData.Open;

  //
  recordCountI6:=ADODataSet_getTrainData.RecordCount;
  Result:=recordCountI6;
end;

function TDataModule_ado.getNullTime_2task(tableNameStrA:WideString):Integer;
var
  recordCountI7:integer;
  spaceStrB,maxBNOStr:WideString;
begin
  spaceStrB:=' ';
  maxBNOStr:=IntToStr(maxBatchNO2task(tableNameStrA));
  ADOQuery_temp.Close;
  ADOQuery_temp.SQL.Clear;
  ADOQuery_temp.SQL.Text:='select entrant_time from '+tableNameStrA
                                +' where(entrant_time='+''''+spaceStrB+''''
                                +')and(batchNO='+''+maxBNOStr+''+')';
  ADOQuery_temp.Open;

  recordCountI7:=ADOQuery_temp.RecordCount;
  Result:=recordCountI7;
end;

function TDataModule_ado.getFreeTime(dictionaryStrA:WideString):Double;
var
  freeTimeF:Double;
begin
  ADODataSet_breed.Close;
  ADODataSet_breed.CommandText:='select freeTime from breedSet where dictionary='
                                                +''''+dictionaryStrA+'''';
  ADODataSet_breed.Open;

  freeTimeF:=ADODataSet_breed.Fields[0].AsFloat;
  Result:=freeTimeF;
end;

function TDataModule_ado.getUnivalent(dictionaryStrA:WideString):Double;
var
  univalentF:Double;
begin
  ADODataSet_breed.Close;
  ADODataSet_breed.CommandText:='select univalent from breedSet where dictionary='
                                                +''''+dictionaryStrA+'''';
  ADODataSet_breed.Open;

  univalentF:=ADODataSet_breed.Fields[0].AsFloat;
  Result:=univalentF;
end;

function TDataModule_ado.getTaskType(saveTimeStrA:WideString):Integer;
var
  taskVal:Integer;
begin
  ADOQuery_temp.Close;
  ADOQuery_temp.SQL.Clear;
  ADOQuery_temp.SQL.Text:='select DISTINCT taskTag from stevedore where saveTime='
                                                +''''+saveTimeStrA+'''';
  ADOQuery_temp.Open;

  taskVal:=ADOQuery_temp.Fields[0].AsInteger;
  Result:=taskVal;
end;
//view
function TDataModule_ado.view2task(tableNameStr,sqlStrA,time_rportstrA:WideString):Integer;
var
  recordCountI5:integer;
begin
  ADODataSet_2task.Close;
  ADODataSet_2task.CommandText:='select '+sqlStrA+' from '
                        +tableNameStr+' where past_time='
                        +''''+time_rportstrA+''''
                        +'OR batchNO=0'
                        +' order by seriary_number';
  ADODataSet_2task.Open;

  recordCountI5:=ADODataSet_2task.RecordCount;
  Result:=recordCountI5;
end;

function TDataModule_ado.viewTask_load(WPCFlagStrA,maxBNOStrA:WideString):Integer;
var
  recordCountI4:integer;
begin
  ADODataSet_load.Close;
  ADODataSet_load.CommandText:='select '
                        +'seriary_number AS 顺序,cargo_name AS 品名,car_number AS 车号,loadMemo AS 备注,'
                        +'past_station AS 到站,load_place AS 装车地点,entrant_time AS 送入时间,'
                        +'finish_time AS 装完时间,takeout_time AS 取出时间,load_notepad AS 记事,'
                        +'SN,past_time,saveTime,car_breed,dictionary'
                        +' from load_car'
                        +' where WPCFlag='+''''+WPCFlagStrA+''''
                        +'OR batchNO='+maxBNOStrA
                        +' order by seriary_number';
  ADODataSet_load.Open;

  recordCountI4:=ADODataSet_load.RecordCount;
  Result:=recordCountI4;
end;

function TDataModule_ado.viewTask_unload(WPCFlagStrA,maxBNOStrA:WideString):Integer;
var
  recordCountI3:integer;
begin
  ADODataSet_unload.Close;
  ADODataSet_unload.CommandText:='select '
                        +'seriary_number AS 顺序,cargo_name AS 品名,'
                        +'car_number AS 车号,unloadMemo AS 备注,'
                        +'send_station AS 发站,unload_place AS 卸车地点,'
                        +'entrant_time AS 送入时间,finish_time AS 卸完时间,takeout_time AS 取出时间,'
                        +'unload_notepad AS 记事,'
                        +'SN,past_time,saveTime,car_breed,dictionary'
                        +' from unload_car'
                        +' where WPCFlag='+''''+WPCFlagStrA+''''
                        +'OR batchNO='+maxBNOStrA
                        +' order by seriary_number';
  ADODataSet_unload.Open;

  recordCountI3:=ADODataSet_unload.RecordCount;
  Result:=recordCountI3;
end;

function TDataModule_ado.viewTask_watiProcess(time_rportstrA:WideString):Integer;
var
  recordCountI2:integer;
begin
  ADODataSet_waitProcess.Close;
  ADODataSet_waitProcess.CommandText:='select seriary_number AS 顺序,cargo_name AS 品名,'
                        +'car_number AS 车号,waitMemo AS 备注,'
                        +'station AS 发到站,place AS 装卸地点,entrant_time AS 送入时间,'
                        +'finish_time AS 装完时间,takeout_time AS 取出时间,wait_notepad AS 记事,waitPID'
                        +' from waitProcess_car where past_time='+''''+time_rportstrA+''''
                        +' order by seriary_number';
  ADODataSet_waitProcess.Open;

  recordCountI2:=ADODataSet_waitProcess.RecordCount;
  Result:=recordCountI2;
end;

function TDataModule_ado.viewTask_allWPC:Integer;
var
  recordCountI2:integer;
begin
  ADODataSet_waitProcess.Close;
  ADODataSet_waitProcess.CommandText:='select seriary_number AS 顺序,cargo_name AS 品名,'
                        +'car_number AS 车号,waitMemo AS 备注,'
                        +'station AS 发到站,place AS 装卸地点,entrant_time AS 送入时间,'
                        +'finish_time AS 装完时间,takeout_time AS 取出时间,'
                        +'wait_notepad AS 记事,waitPID'
                        +' from waitProcess_car'
                        +' order by waitPID';
  ADODataSet_waitProcess.Open;

  recordCountI2:=ADODataSet_waitProcess.RecordCount;
  Result:=recordCountI2;
end;

function TDataModule_ado.viewDataTrain(time_rportStr:WideString):Integer;
var
  recordCountI1:integer;
begin
  ADODataSet_trainOrder.Close;
  ADODataSet_trainOrder.CommandText:='select seriary_number,car_breed,car_number,'
                        +'ordMemo,past_station,cargo_name,original_station,'
                        +'tarpaulin,ord_notepad'
                        +' from trainOrder where past_time='+''''+time_rportStr+''''
                        +' order by seriary_number';
  ADODataSet_trainOrder.Open;

  //
  recordCountI1:=ADODataSet_trainOrder.RecordCount;
  Result:=recordCountI1;
end;
//max
function TDataModule_ado.maxStevedoreNO:Integer;
var
  maxI4:integer;
begin
  ADOQuery_temp.Close;
  ADOQuery_temp.SQL.Clear;
  ADOQuery_temp.SQL.Text:='select Max(stevedoreNO) from stevedore';
  ADOQuery_temp.Open;

  maxI4:=ADOQuery_temp.Fields[0].AsInteger;
  Result:=maxI4;
end;

function TDataModule_ado.maxBatchNO2task(tableNameStr:WideString):Integer;
var
  batchNO:integer;
begin
  ADOQuery_temp.Close;
  ADOQuery_temp.SQL.Clear;
  ADOQuery_temp.SQL.Text:='select Max(batchNO) from '+tableNameStr;
  ADOQuery_temp.Open;
  
  batchNO:=ADOQuery_temp.Fields[0].AsInteger;
  Result:=batchNO;
end;

function TDataModule_ado.maxCar_number:integer;
var
  car_NO:Integer;
begin
  ADOQuery_temp.Close;
  ADOQuery_temp.SQL.Clear;
  ADOQuery_temp.SQL.Text:='select Max(trian_number) from car_number';
  ADOQuery_temp.Open;

  car_NO:=ADOQuery_temp.Fields[0].AsInteger;

  Result:=car_NO;
end;

function TDataModule_ado.maxTrainTotalH:Integer;
var
  train_NO:integer;
begin
  ADOQuery_temp.Close;
  ADOQuery_temp.SQL.Clear;
  ADOQuery_temp.SQL.Text:='select Max(id_master) from traintotalh';
  ADOQuery_temp.Open;

  train_NO:=ADOQuery_temp.Fields[0].AsInteger;

  Result:=train_NO;
end;
//compare
function TDataModule_ado.compareTrain2car_number:Boolean;
begin
  if maxTrainTotalH-maxCar_number=0 then
  begin
    Result:=False;
  end
  else
  begin
    Result:=True;
  end;
end;
//add
function TDataModule_ado.addLogTableData(operIDStrA,operNameStrA,
                                operLogStrA,operLogTimeStrA:WideString):Boolean;
begin
  ADOQuery_Exec.Close;
  ADOQuery_Exec.SQL.Clear;
  ADOQuery_Exec.SQL.Text:='INSERT INTO logTable(operID,operName,operLog,operTime) values('
                      +''+operIDStrA+''+','
                      +''''+operNameStrA+''''+','
                      +''''+operLogStrA+''''+','
                      +''''+operLogTimeStrA+''''+')';
  ADOQuery_Exec.ExecSQL;

  Result:=True;
end;

function TDataModule_ado.add2Task_more(past_timeStrA:WideString;taskType:Integer):Boolean;
var
  recI1,I1:integer;
  //
  snStr,cBreedStr,cNumStr,ordMemoStr,pStationStr,cargoNameStr,oStationStr,oNotepadStr:WideString;
  spaceStrA:WideString;
  maxBatchNoI1,maxBatchNoI2:integer;
  maxBatchNoStr1,maxBatchNoStr2:WideString;
begin
  recI1:=getDataTrain(past_timeStrA);
  //
  maxBatchNoI1:=maxBatchNO2task('load_car')+1;
  maxBatchNoStr1:=IntToStr(maxBatchNoI1);

  maxBatchNoI2:=maxBatchNO2task('unload_car')+1;
  maxBatchNoStr2:=IntToStr(maxBatchNoI2);    
  //
  for I1:=0 to recI1-1 do
  begin
    snStr:=ADODataSet_getTrainData.FieldByName('seriary_number').AsString;
    cBreedStr:=ADODataSet_getTrainData.FieldByName('car_breed').AsString;
    cNumStr:=ADODataSet_getTrainData.FieldByName('car_number').AsString;
    ordMemoStr:=ADODataSet_getTrainData.FieldByName('ordMemo').AsString;
    pStationStr:=ADODataSet_getTrainData.FieldByName('past_station').AsString;
    cargoNameStr:=ADODataSet_getTrainData.FieldByName('cargo_name').AsString;
    oStationStr:=ADODataSet_getTrainData.FieldByName('original_station').AsString;
    oNotepadStr:=ADODataSet_getTrainData.FieldByName('ord_notepad').AsString;
    //control null
    if ordMemoStr='' then
    begin
      ordMemoStr:=' ';
    end;
    if pStationStr='' then
    begin
      pStationStr:=' ';
    end;
    if cargoNameStr='' then
    begin
      cargoNameStr:=' ';
    end;
    if oStationStr='' then
    begin
      oStationStr:=' ';
    end;
    if oNotepadStr='' then
    begin
      oNotepadStr:=' '; 
    end;
    
    spaceStrA:=' ';
    //insert load and unload
    case taskType of
      1://load_car
        begin
          ADOQuery_Exec.Close;
          ADOQuery_Exec.SQL.Clear;
          ADOQuery_Exec.SQL.Text:='INSERT INTO load_car(seriary_number,cargo_name,'
                        +'car_number,loadMemo,past_station,load_notepad,past_time,'
                        +'car_breed,entrant_time,finish_time,takeout_time,batchNO) values('
                        +''+snStr+''+','+''''+cargoNameStr+''''+','+''''+cNumStr+''''+','
                        +''''+ordMemoStr+''''+','+''''+pStationStr+''''+','
                        +''''+oNotepadStr+''''+','+''''+past_timeStrA+''''+','
                        +''''+cBreedStr+''''+','
                        +''''+spaceStrA+''''+','
                        +''''+spaceStrA+''''+','
                        +''''+spaceStrA+''''+','
                        +''+maxBatchNoStr1+''+')';
          ADOQuery_Exec.ExecSQL;
        end;
      2://unload_car
        begin
          ADOQuery_Exec.Close;
          ADOQuery_Exec.SQL.Clear;
          ADOQuery_Exec.SQL.Text:='INSERT INTO unload_car(seriary_number,cargo_name,'
                        +'car_number,unloadMemo,send_station,unload_notepad,past_time,'
                        +'car_breed,entrant_time,finish_time,takeout_time,batchNO) values('
                        +''+snStr+''+','+''''+cargoNameStr+''''+','+''''+cNumStr+''''+','
                        +''''+ordMemoStr+''''+','+''''+pStationStr+''''+','
                        +''''+oNotepadStr+''''+','+''''+past_timeStrA+''''+','
                        +''''+cBreedStr+''''+','
                        +''''+spaceStrA+''''+','
                        +''''+spaceStrA+''''+','
                        +''''+spaceStrA+''''+','
                        +''+maxBatchNoStr2+''+')';
          ADOQuery_Exec.ExecSQL;
        end;
    end;//case end
    
    ADODataSet_getTrainData.Next;
  end;//for end
  Result:=True;
end;

function TDataModule_ado.addWPC_more(past_timeStrA:WideString):Boolean;
var
  recI2,I2:integer;
  //
  snStr,cBreedStr,cNumStr,ordMemoStr,pStationStr,cargoNameStr,oStationStr,oNotepadStr:WideString;
begin
  recI2:=getDataTrain(past_timeStrA);
  for I2:=0 to recI2-1 do
  begin
    snStr:=ADODataSet_getTrainData.FieldByName('seriary_number').AsString;
    cBreedStr:=ADODataSet_getTrainData.FieldByName('car_breed').AsString;
    cNumStr:=ADODataSet_getTrainData.FieldByName('car_number').AsString;
    ordMemoStr:=ADODataSet_getTrainData.FieldByName('ordMemo').AsString;
    pStationStr:=ADODataSet_getTrainData.FieldByName('past_station').AsString;
    cargoNameStr:=ADODataSet_getTrainData.FieldByName('cargo_name').AsString;
    oStationStr:=ADODataSet_getTrainData.FieldByName('original_station').AsString;
    oNotepadStr:=ADODataSet_getTrainData.FieldByName('ord_notepad').AsString;
    //control null
    if ordMemoStr='' then
    begin
      ordMemoStr:=' ';
    end;
    if pStationStr='' then
    begin
      pStationStr:=' ';
    end;
    if cargoNameStr='' then
    begin
      cargoNameStr:=' ';
    end;
    if oStationStr='' then
    begin
      oStationStr:=' ';
    end;
    if oNotepadStr='' then
    begin
      oNotepadStr:=' '; 
    end;
    //
    ADOQuery_Exec.Close;
    ADOQuery_Exec.SQL.Clear;
    ADOQuery_Exec.SQL.Text:='INSERT INTO waitProcess_car(seriary_number,'
                  +'cargo_name,car_number,waitMemo,station,'
                  +'wait_notepad,past_time,car_breed) values('
                  +''+snStr+''+','+''''+cargoNameStr+''''+','+''''+cNumStr+''''+','
                  +''''+ordMemoStr+''''+','+''''+pStationStr+''''+','
                  +''''+oNotepadStr+''''+','+''''+past_timeStrA+''''+','
                  +''''+cBreedStr+''''+')';
    ADOQuery_Exec.ExecSQL;

    ADODataSet_getTrainData.Next;
  end;//for end
  
  Result:=True;
end;

function TDataModule_ado.addStevedore(adoDataSetX:TADODataSet;tagI:Integer):Boolean;
var
  recI9,i2:integer;
  //
  tarryTimeD,tarryTimeD1,tarryTimeD2:Double;
  freeTimeI1:Double;
  //
  tarry_expensesD,tarry_expensesD1:Double;
  //
  dictionaryStr:WideString;
  //
  snStr,cargoNameStr,cNumStr,steMemoStr,stationStr,placeStr,eTimeStr,fTimeStr,tTimeStr:WideString;
  tarryTimeStr,tarryEStr:WideString;
  sNotepadStr,sNOStr,pTimeStr,cBreedStr:WideString;
  taskTagStr,saveTimeStr:WideString;
begin

  recI9:=adoDataSetX.RecordCount;
  //
  sNOStr:=IntToStr(maxStevedoreNO+1);
  //  
  for i2:=0 to recI9-1 do
  begin
    snStr:=adoDataSetX.Fields[0].AsString;
    cargoNameStr:=adoDataSetX.Fields[1].AsString;
    cNumStr:=adoDataSetX.Fields[2].AsString;
    steMemoStr:=adoDataSetX.Fields[3].AsString;
    stationStr:=adoDataSetX.Fields[4].AsString;
    placeStr:=adoDataSetX.Fields[5].AsString;
    eTimeStr:=adoDataSetX.Fields[6].AsString;
    fTimeStr:=adoDataSetX.Fields[7].AsString;
    tTimeStr:=adoDataSetX.Fields[8].AsString;
    sNotepadStr:=adoDataSetX.Fields[9].AsString;
    //
    taskTagStr:=IntToStr(tagI);
    saveTimeStr:=adoDataSetX.FieldByName('saveTime').AsString;
    //
    pTimeStr:=adoDataSetX.FieldByName('past_time').AsString;
    cBreedStr:=adoDataSetX.FieldByName('car_breed').AsString;
    //
    dictionaryStr:=adoDataSetX.FieldByName('dictionary').AsString;
    //
    freeTimeI1:=getFreeTime(dictionaryStr);
    tarryTimeD2:=StrToDateTime(tTimeStr)-StrToDateTime(pTimeStr);
    tarryTimeD1:=tarryTimeD2*24-freeTimeI1;
    tarryTimeD:=RoundTo(tarryTimeD1,-1);
    //
    if tarryTimeD<0.5 then
    begin
      tarryTimeD:=0;
      tarryTimeStr:='0';
    end
    else
    begin
      tarryTimeStr:=FloatToStr(tarryTimeD);
    end;
    //
    tarry_expensesD1:=getUnivalent(dictionaryStr);
    tarry_expensesD:=tarry_expensesD1*tarryTimeD;
    tarryEStr:=FloatToStr(tarry_expensesD);
    //
    if placeStr='' then
    begin
      placeStr:=' ';
    end;
    //
    ADOQuery_temp.Close;
    ADOQuery_temp.SQL.Clear;
    ADOQuery_temp.SQL.Text:='INSERT INTO stevedore(seriary_number,cargo_name,car_number,'
                        +'steMemo,station,place,entrant_time,finish_time,takeout_time,'
                        +'tarryTime,tarry_expenses,'                             //停留小时,延时费
                        +'stevedore_notepad,stevedoreNO,past_time,car_breed,'
                        +'taskTag,'//作业标记：1为装车作业；2为卸车作业；3为混合作业
                        +'saveTime) values('
                        +''+snStr+''+','+''''+cargoNameStr+''''+','+''''+cNumStr+''''+','
                        +''''+steMemoStr+''''+','+''''+stationStr+''''+','+''''+placeStr+''''+','
                        +''''+eTimeStr+''''+','+''''+fTimeStr+''''+','+''''+tTimeStr+''''+','
                        +''+tarryTimeStr+''+','+''+tarryEStr+''+','
                        +''''+sNotepadStr+''''+','+''''+sNOStr+''''+','+''''+pTimeStr+''''+','
                        +''''+cBreedStr+''''+','+''+taskTagStr+''+','
                        +''''+saveTimeStr+''''
                        +')';

    ADOQuery_temp.ExecSQL;

    adoDataSetX.Next;
  end;

  Result:=True;
end;

function TDataModule_ado.addWPC_single(snStrA:WideString;taskType:Integer):Boolean;
var
  snStr,cBreedStr,cNumStr,MemoStr,stationStr,cargoNameStr,wNotepadStr,placeStr:WideString;
  eTimeStr,fTimeStr,tTimeStr,pTimeStr:WideString;
begin
  case taskType of
    1:
      begin
        ADODataSet_get2TaskData.Close;
        ADODataSet_get2TaskData.CommandText:='select seriary_number,cargo_name,'
                        +'car_number,loadMemo,past_station,load_place,entrant_time,'
                        +'finish_time,takeout_time,load_notepad,past_time,car_breed'
                        +' from load_car where SN='+snStrA;
        ADODataSet_get2TaskData.Open;
      end;
    2:
      begin
        ADODataSet_get2TaskData.Close;
        ADODataSet_get2TaskData.CommandText:='select seriary_number,cargo_name,'
                        +'car_number,unloadMemo,send_station,unload_place,entrant_time,'
                        +'finish_time,takeout_time,unload_notepad,past_time,car_breed'
                        +' from unload_car where SN='+snStrA;
        ADODataSet_get2TaskData.Open;
      end;
  end;
  //
  snStr:=ADODataSet_get2TaskData.Fields[0].AsString;
  cargoNameStr:=ADODataSet_get2TaskData.Fields[1].AsString;
  cNumStr:=ADODataSet_get2TaskData.Fields[2].AsString;
  MemoStr:=ADODataSet_get2TaskData.Fields[3].AsString;
  stationStr:=ADODataSet_get2TaskData.Fields[4].AsString;
  placeStr:=ADODataSet_get2TaskData.Fields[5].AsString;
  eTimeStr:=ADODataSet_get2TaskData.Fields[6].AsString;
  fTimeStr:=ADODataSet_get2TaskData.Fields[7].AsString;
  tTimeStr:=ADODataSet_get2TaskData.Fields[8].AsString;
  wNotepadStr:=ADODataSet_get2TaskData.Fields[9].AsString;
  pTimeStr:=ADODataSet_get2TaskData.Fields[10].AsString;
  cBreedStr:=ADODataSet_get2TaskData.Fields[11].AsString;

  if cargoNameStr='' then
  begin
    cargoNameStr:=' ';
  end;
  if MemoStr='' then
  begin
    MemoStr:=' ';
  end;
  if stationStr='' then
  begin
    stationStr:=' ';
  end;
  if placeStr='' then
  begin
    placeStr:=' ';
  end;
  if eTimeStr='' then
  begin
    eTimeStr:=' ';
  end;
  if fTimeStr='' then
  begin
    fTimeStr:=' ';
  end;
  if tTimeStr='' then
  begin
    tTimeStr:=' ';
  end;
  if wNotepadStr='' then
  begin
    wNotepadStr:=' ';
  end;
  if cBreedStr='' then
  begin
    cBreedStr:=' ';
  end;
  //

  ADOQuery_Exec.Close;
  ADOQuery_Exec.SQL.Clear;
  ADOQuery_Exec.SQL.Text:='INSERT INTO waitProcess_car(seriary_number,'
                  +'cargo_name,car_number,waitMemo,station,place,entrant_time,'
                  +'finish_time,takeout_time,wait_notepad,past_time,car_breed'
                  +') values('+''+snStr+''+','+''''+cargoNameStr+''''+','
                  +''''+cNumStr+''''+','+''''+MemoStr+''''+','+''''+stationStr+''''+','
                  +''''+placeStr+''''+','+''''+eTimeStr+''''+','+''''+fTimeStr+''''+','
                  +''''+tTimeStr+''''+','+''''+wNotepadStr+''''+','+''''+pTimeStr+''''+','
                  +''''+cBreedStr+''''+')';
  ADOQuery_Exec.ExecSQL;

  Result:=True;
end;

function TDataModule_ado.addTrianOrder(idMaster:integer):Boolean;
var
   recI2,I2:Integer;
  snStr,cNumStr,tNumStr,cMarqueStr:WideString;
  carBreedStr:WideString;
  //
  time_rportStr:WideString;
begin
  //
  ADODataSet_traintotalh.Close;
  ADODataSet_traintotalh.CommandText:='select train_no,number,id_master,'
                        +'time_report,type from traintotalh where id_master>'
                        +''+IntToStr(idMaster)+'';
  ADODataSet_traintotalh.Open;
  //
  recI2:=ADODataSet_traintotalh.RecordCount;
  //
  for I2:=0 to recI2-1 do
  begin
    snStr:=ADODataSet_traintotalh.Fields[0].AsString;
    cNumStr:=ADODataSet_traintotalh.Fields[1].AsString;
    tNumStr:=ADODataSet_traintotalh.Fields[2].AsString;
    time_rportStr:=ADODataSet_traintotalh.Fields[3].AsString;
    cMarqueStr:=LeftStr(ADODataSet_traintotalh.Fields[4].AsString,1);
    //breed
    if (cMarqueStr<>'')or(cMarqueStr<>' ')then
    begin
      ADODataSet_breed.Close;
      ADODataSet_breed.CommandText:='select car_kind from carKind where initial='
                        +''''+cMarqueStr+'''';
      ADODataSet_breed.Open;

      carBreedStr:=ADODataSet_breed.Fields[0].AsString;
    end
    else
    begin
      carBreedStr:='未知';
    end;
    //insert trianOrder
    ADOQuery_Exec.Close;
    ADOQuery_Exec.SQL.Clear;
    ADOQuery_Exec.SQL.Text:='INSERT INTO trainOrder(seriary_number,car_number,'
                        +'trian_number,past_time,car_breed,car_marque) values('
                        +''+snStr+''+','+''''+cNumStr+''''+','+''+tNumStr+''+','
                        +''''+time_rportStr+''''+','
                        +''''+carBreedStr+''''+','+''''+cMarqueStr+''''+')';
    ADOQuery_Exec.ExecSQL;
      
    ADODataSet_traintotalh.Next;
  end;

  Result:=True;
end;

function TDataModule_ado.addCar_nmuber(trian_number:integer):Boolean;
var
  recI3,I3:Integer;
  snStr,cNumStr,tNumStr,cMarqueStr:WideString;
  //
  past_timeStr:WideString;
begin
 //
  ADODataSet_carNumber.Close;
  ADODataSet_carNumber.CommandText:='select seriary_number,car_number,'
                        +'trian_number,past_time,car_marque from trainOrder'
                        +' where trian_number>'
                        +''+IntToStr(trian_number)+'';
  ADODataSet_carNumber.Open;
  //
  recI3:=ADODataSet_carNumber.RecordCount;
  for I3:=0 to recI3-1 do
  begin
    snStr:=ADODataSet_carNumber.Fields[0].AsString;
    cNumStr:=ADODataSet_carNumber.Fields[1].AsString;
    tNumStr:=ADODataSet_carNumber.Fields[2].AsString;
    past_timeStr:=ADODataSet_carNumber.Fields[3].AsString;
    cMarqueStr:=ADODataSet_carNumber.Fields[4].AsString;
    //insert Car_nmuber
    ADOQuery_Exec.Close;
    ADOQuery_Exec.SQL.Clear;
    ADOQuery_Exec.SQL.Text:='INSERT INTO Car_number(seriary_number,car_number,'
                        +'trian_number,past_time,car_marque) values('
                        +''+snStr+''+','+''''+cNumStr+''''+','+''+tNumStr+''+','
                        +''''+past_timeStr+''''
                        +','+''''+cMarqueStr+''''+')';
    ADOQuery_Exec.ExecSQL;
      
    ADODataSet_carNumber.Next;
  end;

  Result:=True;
end;
//sub
function TDataModule_ado.subtractTrainOrder(past_timeStrA:WideString):Boolean;
begin
  ADOQuery_Exec.Close;
  ADOQuery_Exec.SQL.Clear;
  ADOQuery_Exec.SQL.Text:='DELETE from trainOrder where past_time='+''''+past_timeStrA+'''';
  ADOQuery_Exec.ExecSQL;

  Result:=True;
end;

function TDataModule_ado.subtract2TaskTable(snStrA:WideString;taskType:Integer):Boolean;
begin
  case taskType of
    1://load_car
      begin
        ADOQuery_Exec.Close;
        ADOQuery_Exec.SQL.Clear;
        ADOQuery_Exec.SQL.Text:='DELETE from load_car where SN='+''+snStrA+'';
        ADOQuery_Exec.ExecSQL;
      end;
    2://unload_car
      begin
        ADOQuery_Exec.Close;
        ADOQuery_Exec.SQL.Clear;
        ADOQuery_Exec.SQL.Text:='DELETE from unload_car where SN='+''+snStrA+'';
        ADOQuery_Exec.ExecSQL;
      end;
  end;
  
  Result:=True;
end;

function TDataModule_ado.subtractWPCTable(wsnStrA:WideString):Boolean;
begin
  ADOQuery_Exec.Close;
  ADOQuery_Exec.SQL.Clear;
  ADOQuery_Exec.SQL.Text:='DELETE from waitProcess_car where waitPID='
                                                                +''+wsnStrA+'';
  ADOQuery_Exec.ExecSQL;

  Result:=True;
end;

function TDataModule_ado.subtractWPC_single(wsnStrA:WideString;taskType:Integer):Boolean;
var
  snStr,cBreedStr,cNumStr,MemoStr,stationStr,cargoNameStr,wNotepadStr,placeStr:WideString;
  eTimeStr,fTimeStr,tTimeStr,pTimeStr:WideString;
  //
  WPC_Str:WideString;
begin
  ADODataSet_WPCprocess.Close;
  ADODataSet_WPCprocess.CommandText:='select seriary_number,cargo_name,'
                  +'car_number,waitMemo,station,place,entrant_time,'
                  +'finish_time,takeout_time,wait_notepad,past_time,car_breed'
                  +' from waitProcess_car where waitPID='+wsnStrA;
  ADODataSet_WPCprocess.Open;
 //
  snStr:=ADODataSet_WPCprocess.Fields[0].AsString;
  cargoNameStr:=ADODataSet_WPCprocess.Fields[1].AsString;
  cNumStr:=ADODataSet_WPCprocess.Fields[2].AsString;
  MemoStr:=ADODataSet_WPCprocess.Fields[3].AsString;
  stationStr:=ADODataSet_WPCprocess.Fields[4].AsString;
  placeStr:=ADODataSet_WPCprocess.Fields[5].AsString;
  eTimeStr:=ADODataSet_WPCprocess.Fields[6].AsString;
  fTimeStr:=ADODataSet_WPCprocess.Fields[7].AsString;
  tTimeStr:=ADODataSet_WPCprocess.Fields[8].AsString;
  wNotepadStr:=ADODataSet_WPCprocess.Fields[9].AsString;
  pTimeStr:=ADODataSet_WPCprocess.Fields[10].AsString;
  cBreedStr:=ADODataSet_WPCprocess.Fields[11].AsString;

  if cargoNameStr='' then
  begin
    cargoNameStr:=' ';
  end;
  if MemoStr='' then
  begin
    MemoStr:=' ';
  end;
  if stationStr='' then
  begin
    stationStr:=' ';
  end;
  if placeStr='' then
  begin
    placeStr:=' ';
  end;
  if eTimeStr='' then
  begin
    eTimeStr:=' ';
  end;
  if fTimeStr='' then
  begin
    fTimeStr:=' ';
  end;
  if tTimeStr='' then
  begin
    tTimeStr:=' ';
  end;
  if wNotepadStr='' then
  begin
    wNotepadStr:=' ';
  end;
  if cBreedStr='' then
  begin
    cBreedStr:=' ';
  end;  
  //
  WPC_Str:='wpc';
  //
  case taskType of
    1://load_car
      begin
        ADOQuery_Exec.Close;
        ADOQuery_Exec.SQL.Clear;
        ADOQuery_Exec.SQL.Text:='INSERT INTO load_car(seriary_number,'
                        +'cargo_name,car_number,loadMemo,past_station,load_place,entrant_time,'
                        +'finish_time,takeout_time,load_notepad,past_time,car_breed,WPCFlag'
                        +') values('+''+snStr+''+','+''''+cargoNameStr+''''+','
                        +''''+cNumStr+''''+','+''''+MemoStr+''''+','+''''+stationStr+''''+','
                        +''''+placeStr+''''+','+''''+eTimeStr+''''+','+''''+fTimeStr+''''+','
                        +''''+tTimeStr+''''+','+''''+wNotepadStr+''''+','+''''+pTimeStr+''''+','
                        +''''+cBreedStr+''''+','+''''+WPC_Str+''''+')';
        ADOQuery_Exec.ExecSQL;
      end;
    2://unload_car
      begin
        ADOQuery_Exec.Close;
        ADOQuery_Exec.SQL.Clear;
        ADOQuery_Exec.SQL.Text:='INSERT INTO unload_car(seriary_number,'
                        +'cargo_name,car_number,unloadMemo,send_station,unload_place,entrant_time,'
                        +'finish_time,takeout_time,unload_notepad,past_time,car_breed,WPCFlag'
                        +') values('+''+snStr+''+','+''''+cargoNameStr+''''+','
                        +''''+cNumStr+''''+','+''''+MemoStr+''''+','+''''+stationStr+''''+','
                        +''''+placeStr+''''+','+''''+eTimeStr+''''+','+''''+fTimeStr+''''+','
                        +''''+tTimeStr+''''+','+''''+wNotepadStr+''''+','+''''+pTimeStr+''''+','
                        +''''+cBreedStr+''''+','+''''+WPC_Str+''''+')';
        ADOQuery_Exec.ExecSQL;

      end;
  end;

  Result:=True;
end;
//modify
function TDataModule_ado.modifyTrainOrd4(snStrA,pStationStrA,cargoStrA,
                                oStationStrA,noteStrA,pTimeStrA:WideString):Boolean;
begin
  ADOQuery_temp.Close;
  ADOQuery_temp.SQL.Clear;
  ADOQuery_temp.SQL.Text:='UPDATE trainOrder set past_station='
                        +''''+pStationStrA+''''+','
                        +'cargo_name='
                        +''''+cargoStrA+''''+','
                        +'original_station='
                        +''''+oStationStrA+''''+','
                        +'ord_notepad='
                        +''''+noteStrA+''''
                        +' where seriary_number='+''+snStrA+''
                        +' and past_time='
                        +''''+pTimeStrA+'''';
  ADOQuery_temp.ExecSQL;

  Result:=True;
end;

function TDataModule_ado.modify2Task_singleA(snStrA,
                                entrant_timeStrA,finish_timeStrA,takeout_timeStrA,
                                placeStrA,dictionaryStrA:WideString;
                                taskType:Integer):Boolean;
begin
  case taskType of
    1:
      begin
        ADOQuery_temp.Close;
        ADOQuery_temp.SQL.Clear;
        ADOQuery_temp.SQL.Text:='UPDATE load_car set entrant_time='
                              +''''+entrant_timeStrA+''''
                              +',finish_time='+''''+finish_timeStrA+''''
                              +',takeout_time='+''''+takeout_timeStrA+''''
                              +',load_place='+''''+placeStrA+''''
                              +',dictionary='+''''+dictionaryStrA+''''
                              +' where SN='+''+snStrA+'';
        ADOQuery_temp.ExecSQL;      
      end;
    2:
      begin
        ADOQuery_temp.Close;
        ADOQuery_temp.SQL.Clear;
        ADOQuery_temp.SQL.Text:='UPDATE unload_car set entrant_time='
                              +''''+entrant_timeStrA+''''
                              +',finish_time='+''''+finish_timeStrA+''''
                              +',takeout_time='+''''+takeout_timeStrA+''''
                              +',unload_place='+''''+placeStrA+''''
                              +',dictionary='+''''+dictionaryStrA+''''
                              +' where SN='+''+snStrA+'';
        ADOQuery_temp.ExecSQL;  
      end;
  end;

  Result:=True;
end;

function TDataModule_ado.modify2Task_singleB(snStrA,
                                entrant_timeStrA,finish_timeStrA,takeout_timeStrA,
                                placeStrA,dictionaryStrA:WideString;
                                maxBatchNOInt,taskType:Integer):Boolean;
begin
  case taskType of
    1:
      begin
        ADOQuery_temp.Close;
        ADOQuery_temp.SQL.Clear;
        ADOQuery_temp.SQL.Text:='UPDATE load_car set entrant_time='
                              +''''+entrant_timeStrA+''''
                              +',finish_time='+''''+finish_timeStrA+''''
                              +',takeout_time='+''''+takeout_timeStrA+''''
                              +',dictionary='+''''+dictionaryStrA+''''
                              +',load_place='+''''+placeStrA+''''
                              +',batchNO='+''+IntToStr(maxBatchNOInt)+''
                              +' where SN='+''+snStrA+'';
        ADOQuery_temp.ExecSQL;      
      end;
    2:
      begin
        ADOQuery_temp.Close;
        ADOQuery_temp.SQL.Clear;
        ADOQuery_temp.SQL.Text:='UPDATE unload_car set entrant_time='
                              +''''+entrant_timeStrA+''''
                              +',finish_time='+''''+finish_timeStrA+''''
                              +',takeout_time='+''''+takeout_timeStrA+''''
                              +',dictionary='+''''+dictionaryStrA+''''
                              +',unload_place='+''''+placeStrA+''''
                              +',batchNO='+''+IntToStr(maxBatchNOInt)+''
                              +' where SN='+''+snStrA+'';
        ADOQuery_temp.ExecSQL;  
      end;
  end;

  Result:=True;
end;
//save
function TDataModule_ado.save2task(tableNameStr,saveTimeStr,maxBNOStrA:WideString):Boolean;
var
  recI7,i1:integer;
begin
  recI7:=queryRecCo2task(tableNameStr,maxBNOStrA);
  //
  for i1:=0 to recI7-1 do
  begin
    ADOQuery_temp.Close;
    ADOQuery_temp.SQL.Clear;
    ADOQuery_temp.SQL.Text:='UPDATE '+tableNameStr+' set saveTime='+''''+saveTimeStr+''''
                    +' where batchNO='+maxBNOStrA;
    ADOQuery_temp.ExecSQL;
    
    ADODataSet_get2TaskData.Next;
  end;
  Result:=True;
end;

function TDataModule_ado.save2taskBlend(tableNameStr,saveTimeStr,
                                OldwpcFlagStrA,NewwpcFlagStrA:WideString):Boolean;
var
  recI7,i1:integer;
begin
  recI7:=queryRecCo2taskBlend(tableNameStr,OldwpcFlagStrA);
  //
  for i1:=0 to recI7-1 do
  begin
    ADOQuery_temp.Close;
    ADOQuery_temp.SQL.Clear;
    ADOQuery_temp.SQL.Text:='UPDATE '+tableNameStr+' set saveTime='+''''+saveTimeStr+''''
                        +',WPCFlag='+''''+NewwpcFlagStrA+''''
                        +' where WPCFlag='+''''+OldwpcFlagStrA+'''';
    ADOQuery_temp.ExecSQL;
    
    ADODataSet_get2TaskData.Next;
  end;
  Result:=True;

end;

procedure TDataModule_ado.DataModuleCreate(Sender: TObject);
var
  xbftemp:string;
  //
  h4:THandle;
begin
  //
  currentDir1:=ExtractFilePath(ParamStr(0));
  xbfini:=TIniFile.Create(currentDir1+'CDPconfig.ini');
  xbftemp:=xbfini.ReadString('filePath','3','zlnr1.xbf');
  xbf:=currentDir1+xbftemp;

  titleFrmMain:=xbfini.ReadString('title','1','CDP_x5');
  titleExcelStr:=xbfini.ReadString('title','2','CDP_x5');
  //csv file
  csvFilePath2:=xbfini.ReadString('filePath','2','c:\datasb.txt');
  h4:=0;  
  try
    h4:=LoadLibrary('XBFGenerate.dll');
    if h4<>0 then
        @connstring:=GetprocAddress(h4,'readXBF_mdb');
      if (@connstring<>nil)then
          DBconnect:=connstring(-1,xbf);
    //
  finally
    FreeLibrary(h4);
  end;  
  //
  adoConnMain.ConnectionString:=DBconnect;
end;

procedure TDataModule_ado.DataModuleDestroy(Sender: TObject);
begin
  xbfini.Destroy;
end;

end.
