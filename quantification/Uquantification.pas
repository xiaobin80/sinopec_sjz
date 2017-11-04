unit Uquantification;

interface

uses
  Windows, SysUtils, Classes, DBXpress, Provider, SqlExpr, DB, DBClient, DBLocal,
  DBLocalS,IniFiles, FMTBcd;

type
  TDataModule_quantification = class(TDataModule)
    quantificationConn: TSQLConnection;
    SQLClientDataSet_ghch: TSQLClientDataSet;
    SQLQuery_exec: TSQLQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    h1:THandle;
    XBFconnect2,xbf,CurrentDir,IniFilePath1:WideString;
    fileConfig:TIniFile;
    { Private declarations }
  public
    function getDragonItemID(dayStrA:WideString):Integer;
    function getWriteFlag(dragonID:WideString):WideString;
    function addGHCH_ORA(dragonIDStrA,consistStrA,SnStrA,carNumStrA,pTimeStrA,
                                wTimeStrA,operStrA:WideString):Boolean;
    { Public declarations }
  end;

type
  Tfun_readORAConnectStr=function(DimRecord: Integer;filename1:WideString):WideString;stdcall;
  
var
  DataModule_quantification: TDataModule_quantification;
  //dll function
  connectStrORA:Tfun_readORAConnectStr;
  
implementation

{$R *.dfm}

function TDataModule_quantification.getDragonItemID(dayStrA:WideString):Integer;
var
  recI3:Integer;
begin
  SQLClientDataSet_ghch.Close;
  SQLClientDataSet_ghch.CommandText:='select DISTINCT YW_LZBM FROM "SJZGHCH"."GHCH" where YW_TIME like '
                                        +''''+dayStrA+'''';
  SQLClientDataSet_ghch.Open;

  recI3:=SQLClientDataSet_ghch.RecordCount;
  Result:=recI3;
end;

function TDataModule_quantification.getWriteFlag(dragonID:WideString):WideString;
var
  tagStr:WideString;
begin
  SQLClientDataSet_ghch.Close;
  SQLClientDataSet_ghch.CommandText:='select DISTINCT YW_SIGN FROM "SJZGHCH"."GHCH" where YW_LZBM='
                                        +''''+dragonID+'''';
  SQLClientDataSet_ghch.Open;

  tagStr:=SQLClientDataSet_ghch.Fields[0].AsString;
  Result:=tagStr;
end;

function TDataModule_quantification.addGHCH_ORA(dragonIDStrA,consistStrA,SnStrA,
                        carNumStrA,pTimeStrA,wTimeStrA,operStrA:WideString):Boolean;
begin
  SQLQuery_exec.Close;
  SQLQuery_exec.SQL.Text:='UPDATE "SJZGHCH"."GHCH" set YW_TLBZ='
                        +''''+consistStrA+''''+','
                        +'YW_CH='
                        +''''+carNumStrA+''''+','
                        +'YW_SMSJ='
                        +''''+pTimeStrA+''''+','
                        +'YW_XRSJ='
                        +''''+wTimeStrA+''''+','
                        +'YW_CZY='
                        +''''+operStrA+''''
                        +' where YW_LZBM='+''''+dragonIDStrA+''''
                        +' and YW_GHXH='
                        +''''+SnStrA+'''';
  SQLQuery_exec.ExecSQL(True);
  //
  Result:=True;
end;

procedure TDataModule_quantification.DataModuleCreate(Sender: TObject);
var
  SepCharPos:Integer;
  Mystr:WideString;
  i1:integer;
  myList:TStringList;
begin
  CurrentDir:=ExtractFilePath(ParamStr(0));
  IniFilePath1:=CurrentDir+'CDPconfig.ini';
  fileConfig:=TIniFile.Create(IniFilePath1);
  xbf:=CurrentDir+fileConfig.ReadString('filePath','1','jlsystem.xbf');
  //
  h1:=0;
  try
  h1:=LoadLibrary('OmLnkLib.dll');

  if h1<>0 then
    @connectStrORA:=GetprocAddress(h1,'readORA');
  if (@connectStrORA<>nil)then
      XBFconnect2:=connectStrORA(-1,xbf);//SJZJLU--DataBase
  finally
   FreeLibrary(h1);
  end;
  //
  myList:=TStringList.Create;

  for i1:=1 to 8 do
  begin
    SepCharPos:=pos(#13,XBFconnect2);
    Mystr:=copy(XBFconnect2,1,SepCharPos-1);
    Delete(XBFconnect2,1,SepCharPos);
    myList.Add(Mystr);
  end;
  try
    quantificationConn.Close;
    quantificationConn.Params:=myList;
    quantificationConn.Open;
  except
    
  end;
  //
  FreeAndNil(myList);
end;

procedure TDataModule_quantification.DataModuleDestroy(Sender: TObject);
begin
//
  fileConfig.Free;
end;

end.