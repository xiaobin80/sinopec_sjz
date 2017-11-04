unit UpublicFunc;

interface
uses
  Windows, SysUtils, Classes, DBGrids, ADODB, DB,ComCtrls, Forms, StrUtils,
  Printers, Winsock, StdCtrls;

  function findSysTempDir:WideString;
  function GetAllIP : string;
  function fullScreenArea(var x,y:integer):Boolean;
  function dateTimeStrFull:WideString;
  function addExplanatory(adoDataSetX:TADODataSet;dictionaryStrA:WideString):WideString;
  function dateTimePiece(dateComponentA,timeComponentA:TDateTimePicker):WideString;
  procedure operDir;
  procedure normGridColWidth(dbgridX:TDBGrid;widthInt:integer);
  procedure addDictionary(adoDataSetX:TADODataSet;comboxX:TComboBox);
  procedure treeADO(adoDataSetX:TADODataSet;tvTemplate1:TTreeView);
  procedure numberNode(TNode:TTreenode;tvTemplate2:TTreeView);
  procedure WriteheaderADO(adoDataSetX:TADODataSet;titlehead:string;
                                        ColWidthInt:Integer;tvTemplate3:TTreeView);
  procedure WriteExcelData(adoDataSetX:TADODataSet);
  procedure printGridData(DataSourceX:TDataSource;dbgridX:TDBGrid);
  
var
  Maxnum,childNum,DepthNum:Integer;
  curDir,excelDir:WideString;
  //
  worksheet:olevariant;          //电子表格工作簿
  workbook:olevariant;           //电子表格部分
  myExcel:variant;               //电子表格对象

implementation

function findSysTempDir:WideString;
var
  temppath:PChar;
begin
  GetMem(temppath,255);
  GetTempPath(255,temppath);
  Result:=temppath;
end;

procedure operDir;
begin
  curDir:=ExtractFilePath(ParamStr(0));
  excelDir:=curDir+'excelFile';
  if not DirectoryExists(excelDir)then  //excel directory
  begin
    MkDir(excelDir);
  end;
end;  

function GetAllIP : string;
type
    TaPInAddr = array [0..10] of PInAddr;
    PaPInAddr = ^TaPInAddr;
var
    phe  : PHostEnt;
    pptr : PaPInAddr;
    Buffer : array [0..63] of char;
    I    : Integer;
    GInitData      : TWSADATA;
begin
    WSAStartup($101, GInitData);
    Result := '';
    GetHostName(Buffer, SizeOf(Buffer));
    phe :=GetHostByName(buffer);
    if phe = nil then Exit;
    pptr := PaPInAddr(Phe^.h_addr_list);
    I := 0;
    while pptr^[I] <> nil do begin
      if i=0
      then result:=StrPas(inet_ntoa(pptr^[I]^))
      else result:=result+','+StrPas(inet_ntoa(pptr^[I]^));
      Inc(I);
    end;
    WSACleanup;
end; 

procedure normGridColWidth(dbgridX:TDBGrid;widthInt:integer);
var
  i1:integer;
begin
  for i1:=0 to dbgridX.Columns.Count-1 do
  begin
    dbgridX.Columns[i1].Title.Alignment:=taCenter;
    dbgridX.Columns[i1].Alignment:=taCenter;
    dbgridX.Columns[i1].Width:=widthInt;
  end;

end;

procedure addDictionary(adoDataSetX:TADODataSet;comboxX:TComboBox);
var
  dictStr:WideString;
  recI2,i2:integer;
begin
  adoDataSetX.Close;
  adoDataSetX.CommandText:='select dictionary from breedSet';
  adoDataSetX.Open;

  recI2:=adoDataSetX.RecordCount;
  for i2:=0 to recI2-1 do
  begin
    dictStr:=adoDataSetX.Fields[0].AsString;
    comboxX.Items.Add(dictStr);
    adoDataSetX.Next;
  end;
end;

function addExplanatory(adoDataSetX:TADODataSet;dictionaryStrA:WideString):WideString;
var
  bNameStr,dictStr:WideString;
begin
  adoDataSetX.Close;
  adoDataSetX.CommandText:='select breedName,breedMemo from breedSet where dictionary='
                                                +''''+dictionaryStrA+'''';
  adoDataSetX.Open;

  bNameStr:=adoDataSetX.Fields[0].AsString;
  dictStr:=adoDataSetX.Fields[1].AsString;
  Result:=bNameStr+' '+dictStr;
end;

procedure treeADO(adoDataSetX:TADODataSet;tvTemplate1:TTreeView);
var
  i,j,k,n,pre_p,a_p:integer;
  s,pre_s,tepstr: string;
//  aft_s  cur_s prn_s,
  //
  exportMemo:TStringList;
begin
  //create mylist
  exportMemo:=TStringList.Create;
  //

  pre_s:='';
  for i:=0 to adoDataSetX.FieldDefList.Count-1 do
  begin
    s:= adoDataSetX.FieldDefList[i].Name;
    if pos('_',s)=0 then
    begin
      exportMemo.Add(s);
    end
    else
    begin
      pre_p:=0;
      a_p:=0;
      n:=0;
      for j:=1 to length(s) do
      if s[j]='_' then
      begin
         a_p:=j;
         tepstr:='';
         for k:=1 to n do
         begin
           tepstr:=tepstr+#9;
         end;
         if (copy(s,pre_p+1,a_p-pre_p-1)<>  copy(pre_s,pre_p+1,a_p-pre_p-1)) then
         begin
           exportMemo.Add(tepstr+copy(s,pre_p+1,a_p-pre_p-1));
         end;
         pre_p:= a_p;
         n:=n+1;
      end;
      exportMemo.Add(tepstr+#9+copy(s,a_p+1,length(s)-pre_p));
    end;
    pre_s:= s;
  end;
  exportMemo.SaveToFile(findSysTempDir+'temp.txt');
  TVtemplate1.LoadFromFile(findSysTempDir+'temp.txt');
  DeleteFile(findSysTempDir+'temp.txt');
  //free
  FreeAndNil(exportMemo);
end;

procedure numberNode(TNode:TTreenode;tvTemplate2:TTreeView);
type
   Nodesum=record
   Node:TTreenode; //结点
   Layer:Integer;  //所在层
 end;
var
  a:array of Nodesum;
  Node:TTreenode;
  Depth,i,j,num:Integer;
begin
  Depth:=0;
  i:=0;
  j:=0;
  num:=0;
  Setlength(a,tvTemplate2.Items.Count);
  Node:=TNode;  //使顶结点为您所选择的结点
  a[i].Node:=Node;
  a[i].Layer:=1;
  while a[i].Node<> nil do
    begin
        Node:=a[i].Node.Getfirstchild;//取其第一个子结点
        while Node <> nil do
           begin
             j:=j+1;
             a[j].Node:=Node;
             a[j].Layer:=a[i].Layer+1; //此结点所在的层数
             Node:=Node.GetNextSibling;
           end;//如此循环，以取出此层所有结点
    i:=i+1;
  end;
  i:=0;
 while (a[i].node<>nil)   do
     begin
      if a[i].Layer>Depth then
         Depth:=a[i].Layer;//求最大的层数，即子树深度
      IF (a[i].Node.count=0) THEN
         num:=num+1;
      i:=i+1;
     end;
 If (a[0].Node<>nil)   then
 begin
    childNum :=num;
    DepthNum:=Depth;
 end;
end;

//打印多表头//dbgrid
procedure WriteheaderADO(adoDataSetX:TADODataSet;titlehead:string;
                                        ColWidthInt:Integer;tvTemplate3:TTreeView);
var
  colnum,i,titlnum,Depnum:integer;
  colname,temcaption:string;
  colmix,colmax:string;
  treeno,treecount,colnums,treenotemp:integer;
  childcount:integer;
  Trode:Ttreenode;
  rownum:integer;
begin
 colnum:=adoDataSetX.FieldDefList.Count;
 rownum:=adoDataSetX.RecordCount;
 for i:=1 to colnum do
 begin
  //colwidth
  worksheet.Columns[i].ColumnWidth:=ColWidthInt;
  //
  worksheet.Columns[i].Font.size:=9;
  worksheet.Columns[i].Font.Name := '宋体';
 end;
 if colnum>26 then
   colname:=char(colnum div 26 +64)+ char(colnum mod 26 +64)
 else
   colname:=char(colnum +64);
 if  rownum=0 then rownum:=Maxnum;
 worksheet.Range['A1:'+colname+inttostr(2+rownum+Maxnum-1)].Font.Name := '宋体';
 worksheet.Range['A1:'+colname+inttostr(2+rownum+Maxnum-1)].Font.Size := 9;
 worksheet.range['A1:'+colname+inttostr(2+rownum+Maxnum-1)].HorizontalAlignment := $FFFFEFF4;
 worksheet.range['A1:'+colname+inttostr(2+rownum+Maxnum-1)].VerticalAlignment := $FFFFEFF4;

 worksheet.range['A2:'+colname+inttostr(2+rownum+Maxnum-1)].Borders[1].Weight := 2;
 worksheet.range['A2:'+colname+inttostr(2+rownum+Maxnum-1)].Borders[2].Weight := 2;
 worksheet.range['A2:'+colname+inttostr(2+rownum+Maxnum-1)].Borders[3].Weight := 2;
 worksheet.range['A2:'+colname+inttostr(2+rownum+Maxnum-1)].Borders[4].Weight := 2;

 worksheet.Range['A1',colname+'1'].Merge('false');
 worksheet.Range['A1:'+colname+'1'].Font.Name := '宋体';
 worksheet.Range['A1:'+colname+'1'].Font.Size := 14;
 worksheet.Range['A1:'+colname+'1'].Font.Bold := True;
 worksheet.range['A1:'+colname+'1'].HorizontalAlignment := $FFFFEFF4;
 worksheet.Rows[1].VerticalAlignment := $FFFFEFF4;
 worksheet.range['A1:'+colname+'1'].Value:=titlehead;

 treecount:=tvTemplate3.Items.count;
 treeno:=0 ;
 colnums:=0 ;
 while treeno <= treecount-1 do
  begin
   //取当前头有几层
    titlnum:=1;
    temcaption:=adoDataSetX.FieldDefList[colnums].Name;
     while Pos('_',temcaption) > 0 do
     begin
       Delete(temcaption, 1, Pos('_', temcaption));
       titlnum:=titlnum+1;
     end;
   ///////////////////////
     if  (tvTemplate3.Items[treeno].Parent=nil) and (tvTemplate3.Items[treeno].Count=0)   then
     //无child的第一层节点
     begin
{2004      if (colnums+1) >26  then
        colname:=char((colnums+1) div 26 +64)+ char((colnums+1) mod 26 +64) //colnum 改为 colnums
      else
       colname:=char((colnums+1) +64);
}
      if colnums div 26 = 0 then
        colname := char(colnums MOD 26 + 1 +64)
      else
        colname := char(colnums div 26 +64) + char(colnums MOD 26 + 1 +64) ;

      worksheet.Range[colname+'2',colname+inttostr(Maxnum+1)].Merge('false');
      worksheet.Range[colname+'2',colname+inttostr(Maxnum+1)].Value:= tvTemplate3.Items[treeno].text;
      treeno:=treeno+1;
      colnums:=colnums+1;
     end
    else   //下级结点
     begin
        if (tvTemplate3.Items[treeno].Parent=nil) and (tvTemplate3.Items[treeno].Count<>0) then
        //有child的第一层节点
         begin
             numberNode(tvTemplate3.Items[treeno],tvTemplate3);
             childcount :=childNum;
             Depnum:=Depthnum;//本结点的深度
            // Depnum:=titlnum;
            // childcount := TreeView1.Items[treeno].Count;
//xia加            if treeno >26 then
      if colnums div 26 = 0 then
        colmix := char(colnums MOD 26 + 1 +64)
      else
        colmix := char(colnums div 26 +64) + char(colnums MOD 26 + 1 +64) ;

{ 2004           if (colnums+1) >26 then            //  xia加
               colmix:=char((colnums+1) div 26 +64)+ char((colnums+1) mod 26 +64)
            else
               colmix:=char((colnums+1) +64);
 }

      if (colnums + childcount -1) div 26 = 0 then
        colmax := char((colnums + childcount -1) MOD 26 + 1 +64)
      else
        colmax := char((colnums + childcount -1) div 26 +64)
                                + char((colnums + childcount -1) MOD 26 + 1 +64) ;

{ 2004
            if (colnums+1+childcount-1)>26 then
               colmax:=char((colnums+1+childcount-1) div 26 +64)+ char((colnums+1+childcount-1) mod 26 +64)
            else
               colmax:=char((colnums+1+childcount-1) +64);
}
            worksheet.Range[colmix+'2',colmax+'2'].Merge('false');
            worksheet.Range[colmix+'2',colmax+'2'].Value:= tvTemplate3.Items[treeno].text;
            colnums:=colnums-1;
          //  if colnums =-1 then  colnums:=0;
         end
        else if (tvTemplate3.Items[treeno].Parent<>nil) and (tvTemplate3.Items[treeno].Count<>0) then
          //有child的层节点
          begin
             numberNode(tvTemplate3.Items[treeno],tvTemplate3);
             childcount :=childNum;
             Depnum:=Depthnum;//本结点的深度
           // childcount :=TreeView1.Items[treeno].Count;
           // Depnum:=titlnum;
//xia加            if treeno >26 then
      if colnums div 26 = 0 then
        colmix := char(colnums MOD 26 + 1 +64)
      else
        colmix := char(colnums div 26 +64) + char(colnums MOD 26 + 1 +64) ;

{2004            if (colnums+1) >26 then            //  xia加
            colmix:=char((colnums+1) div 26 +64)+ char((colnums+1) mod 26 +64)
            else
               colmix:=char((colnums+1) +64);
}
      if (colnums + childcount -1) div 26 = 0 then
        colmax := char((colnums + childcount -1) MOD 26 + 1 +64)
      else
        colmax := char((colnums + childcount -1) div 26 +64)
                                + char((colnums + childcount -1) MOD 26 + 1 +64) ;

{2004            if (colnums+1+childcount-1)>26 then
               colmax:=char((colnums+1+childcount-1) div 26 +64)+ char((colnums+1+childcount-1) mod 26 +64)
            else
               colmax:=char((colnums+1+childcount-1) +64);
}
            treenotemp:=0;
            Trode:=tvTemplate3.Items[treeno].Parent;
            while Trode <> nil do
             begin
               treenotemp:=treenotemp+1;
               Trode:=Trode.Parent ;
             end;

            worksheet.Range[colmix+inttostr(2+treenotemp),colmax+inttostr(2+treenotemp)].Merge('false');
            worksheet.Range[colmix+inttostr(2+treenotemp),colmax+inttostr(2+treenotemp)].Value:= tvTemplate3.Items[treeno].text;
            colnums:=colnums-1;
           // if colnums =-1 then  colnums:=0;
          end
        else  //最低层结点
         begin
      if colnums div 26 = 0 then
        colname := char(colnums MOD 26 + 1 +64)
      else
        colname := char(colnums div 26 +64) + char(colnums MOD 26 + 1 +64) ;
{2004            if colnums+1>26 then
             colname:=char((colnums+1) div 26 +64)+ char((colnums+1) mod 26 +64)
            else
             colname:=char((colnums+1) +64);
}
            if Maxnum-titlnum=0 then
               worksheet.cells.item[Maxnum+1,colnums+1]:=tvTemplate3.Items[treeno].text
            else
            begin
              treenotemp:=0;
              Trode:=tvTemplate3.Items[treeno].Parent;
              while Trode <> nil do
              begin
                treenotemp:=treenotemp+1;
                Trode:=Trode.Parent ;
              end;
              worksheet.Range[colname+inttostr(2+titlnum-1),colname+inttostr(2+Maxnum-1)].Merge('false');
              worksheet.Range[colname+inttostr(2+titlnum-1),colname+inttostr(2+Maxnum-1)].Value:= tvTemplate3.Items[treeno].text;
            end;
        end;
        treeno:=treeno+1;
        colnums:=colnums+1;
     end; //else
  end;  //while

  //procedure WriteExcelData(adoDataSetX:TADODataSet);
end;

procedure WriteExcelData(adoDataSetX:TADODataSet);
var
  i1:Integer;
  Tabrow:integer;
  Valuestr:string;  
begin
  adoDataSetX.First ;
  try
     For i1:=0 To  adoDataSetX.Recordcount -1 do
    begin
     for Tabrow:=0 to adoDataSetX.FieldDefList.Count-1  do
      begin
        if not adoDataSetX.Fields[Tabrow].IsNull  then
         begin
           Valuestr:= adoDataSetX.Fields[Tabrow].AsString;
           worksheet.Cells.item[2+Maxnum+i1,Tabrow+1]:=''''+ Valuestr  ;
         end;
      end;
     adoDataSetX.Next;
   end;
  except
  end;

end;
//screen cal
function fullScreenArea(var x,y:integer):Boolean;
var
  rcWork:TRect;
begin
  rcWork.Top:=0;
  rcWork.Left:=0;
  rcWork.Bottom:=GetSystemMetrics(SM_CYSCREEN);
  rcWork.Right:=GetSystemMetrics(SM_CXSCREEN);

  y:=rcWork.Right;
  x:=rcWork.Bottom;

  Result:=True;
end;

//date string(full)
function dateTimeStrFull:WideString;
var
  year,month,day,DOW:Word;
  hours1,mins1,sec1,Msec1:Word;
  //
  dateStr:WideString;
  monStr,dayStr,houStr,minStr:WideString;
begin
  DecodeDateFully(Now,year,month,day,DOW);
  DecodeTime(Now,hours1,mins1,sec1,Msec1);
  
  if month<10 then
  begin
    monStr:='0'+IntToStr(month);
  end
  else
  begin
    monStr:=IntToStr(month);
  end;
  
  if day<10 then
  begin
    dayStr:='0'+IntToStr(day);
  end
  else
  begin
    dayStr:=IntToStr(day);
  end;
  
  if hours1<10 then
  begin
    houStr:='0'+IntToStr(hours1);
  end
  else
  begin
    houStr:=IntToStr(hours1);
  end;

  if mins1<10 then
  begin
    minStr:='0'+IntToStr(mins1);
  end
  else
  begin
    minStr:=IntToStr(mins1);
  end;

  dateStr:=IntToStr(year)+monStr+dayStr+houStr+minStr+IntToStr(sec1);
  Result:=dateStr;
end;

function dateTimePiece(dateComponentA,timeComponentA:TDateTimePicker):WideString;
var
  dateStr,timeStr:WideString;
  retDateTimeStr:WideString;
begin
  dateStr:=FormatDateTime('yyyy-MM-dd',dateComponentA.Date);
  timeStr:=FormatDateTime('HH:mm',timeComponentA.Time);
  retDateTimeStr:=dateStr+' '+timeStr;
  Result:=retDateTimeStr;
end;

//
procedure printGridData(DataSourceX:TDataSource;dbgridX:TDBGrid);
const
  LeftBlank=1;
  RightBlank=1;
  TopBlank=1;
  BottomBlank=1;
var
  PointX,PointY:integer;
  PointScale,PrintStep:integer;
  s:string;
  x,y:integer;
  i:integer;
begin
  PointX:=Trunc(GetDeviceCaps(Printer.Handle,LOGPIXELSX)/2.54);
  PointY:=Trunc(GetDeviceCaps(Printer.Handle,LOGPIXELSY)/2.54);

  PointScale:=Trunc(GetDeviceCaps(Printer.Handle,LOGPIXELSY)/Screen.PixelsPerInch+0.5); //纵向打印
  printer.Orientation:=poPortrait;


  printer.Canvas.Font.Name:='宋体';
  printer.canvas.Font.Size:=10;

  s:='xiaobin';
  PrintStep:=printer.canvas.TextHeight(s)+16;

  x:=PointX*LeftBlank;
  y:=PointY*TopBlank;

  if ((DataSourceX.DataSet).Active=true) and ((DataSourceX.DataSet).RecordCount>0) then
  begin
    printer.BeginDoc;
    (DataSourceX.DataSet).First;
    
    while not (DataSourceX.DataSet).Eof do
    begin
      for i:=0 to dbgridX.FieldCount-1 do
      begin
        if (x+dbgridX.Columns.Items[i].Width*PointScale)<=(Printer.PageWidth-PointX*RightBlank) then
        begin
          Printer.Canvas.Rectangle(x,y,x+dbgridX.Columns.Items[i].Width*PointScale,y+PrintStep);
          if y=PointY*TopBlank then
            Printer.Canvas.TextOut(x+8,y+8,dbgridX.Columns[i].Title.Caption)
          else
            Printer.Canvas.TextOut(x+8,y+8,dbgridX.Fields[i].asString);
        end;
        x:=x+dbgridX.Columns.Items[i].Width*PointScale;
      end;
      if not (y=PointY*TopBlank) then
        (DataSourceX.DataSet).next;
        x:=PointX*LeftBlank;
        y:=y+PrintStep;
      if (y+PrintStep)>(Printer.PageHeight-PointY*BottomBlank) then
      begin
        Printer.NewPage;
        y:=PointY*TopBlank;
      end;
    end;//whil end

    printer.EndDoc;
    (DataSourceX.DataSet).First;
    Application.MessageBox('打印完成','打印',32);

  end;//if end
//
end;

end.
