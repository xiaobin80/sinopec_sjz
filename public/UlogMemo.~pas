unit UlogMemo;

interface

uses 
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  Tframe_log = class(TFrame)
    memoLog: TMemo;
  private
    { Private declarations }
  public
    //
    procedure addMemoLog(logStrA:WideString);  
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure Tframe_log.addMemoLog(logStrA:WideString);
begin
  memoLog.Lines.Add(logStrA+'  '+DateTimeToStr(Now));
end;

end.
