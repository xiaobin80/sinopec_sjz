unit UGeneralCSV;

interface
uses
  SysUtils, Classes, ADODB;

var
  saveFilePath:WideString;

function generalCSV(ADOconnectString,ColName,TableName1,
                        dragonIDStrA,consistStrA,operStrA,
                        ExprotFileName1,wTimeStrA:WideString;
                        ColCount:integer):Boolean;

implementation
uses
  Uquantification;


function generalCSV(ADOconnectString,ColName,TableName1,
                        dragonIDStrA,consistStrA,operStrA,
                        ExprotFileName1,wTimeStrA:WideString;
                        ColCount:integer):Boolean;
var
  ADOConnectX:TADOConnection;
  ADOQueryX:TADOQuery;
  
  TempStr:WideString;
  iFor: integer;
  TempList:TStringList;
  //
  snStr,carNumStr,pTimeStr:WideString;
begin
  ADOConnectX:=TADOConnection.Create(nil);
  ADOQueryX:=TADOQuery.Create(nil);

  ADOConnectX.LoginPrompt:=False;
  ADOConnectX.Close;
  ADOConnectX.ConnectionString:=ADOconnectString;
  ADOConnectX.Open;
  
  ADOQueryX.Connection:=ADOConnectX;
  ADOQueryX.Close;
  ADOQueryX.SQL.Text:='select '+ColName+' from '+TableName1;
  ADOQueryX.Open;


  TempStr := '';
  TempList := TStringList.Create;
  ADOQueryX.First;
  while not ADOQueryX.Eof do
  begin
    TempStr := '';
    for iFor := 0 to ColCount-1 do//colcount��
    begin
      if iFor=0 then
      begin
        TempStr := TempStr + ADOQueryX.Fields[iFor].AsString;
      end
      else
      begin
        TempStr := TempStr +','+ ADOQueryX.Fields[iFor].AsString;
      end;
    end;
    //insert GHCH-ORA
    snStr:=ADOQueryX.Fields[0].AsString;
    carNumStr:=ADOQueryX.Fields[1].AsString;
    pTimeStr:=ADOQueryX.Fields[2].AsString;
    try
      DataModule_quantification.addGHCH_ORA(dragonIDStrA,consistStrA,snStr,
                                        carNumStr,pTimeStr,wTimeStrA,operStrA);
    except

    end;
    //
    TempList.Append(consistStrA+','+TempStr);
    ADOQueryX.Next;
  end;

  saveFilePath:=ExprotFileName1;
  TempList.SaveToFile(saveFilePath);
  //free object
  FreeAndNil(TempList);
  FreeAndNil(ADOConnectX);
  FreeAndNil(ADOQueryX);

  Result:=True;

end;

end.
