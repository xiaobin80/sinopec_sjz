//*****************************************//
//project name:CDP_x5.dpr                  //
//purpose:processing list                  //
//writ code:xiao bin                       //
//date:2007.01.03                          //
//*****************************************//


program CDP_x5;

uses
  Forms,
  windows,
  SysUtils,
  Umain in 'Umain.pas' {frmMain},
  u_about in 'u_about.pas' {frm_about},
  UtrainOrd in 'UtrainOrd.pas' {frmTrainOrd},
  u_login in 'u_login.pas' {frm_login},
  u_passet in 'u_passet.pas' {frm_passset},
  Uquantification in 'quantification\Uquantification.pas' {DataModule_quantification: TDataModule},
  Ulog in 'Ulog.pas' {frmLog},
  UpublicFunc in 'public\UpublicFunc.pas',
  Ubreed in 'Ubreed.pas' {frmBreed},
  UDataModule_ado in 'UDataModule_ado.pas' {DataModule_ado: TDataModule},
  UlogMemo in 'public\UlogMemo.pas' {frame_log: TFrame},
  UqueryType in 'UqueryType.pas' {frmType},
  UtrainBlend in 'UtrainBlend.pas' {frmTrainBlend},
  Ustevedore in 'Ustevedore.pas' {frmStevedore},
  UqueryDate in 'UqueryDate.pas' {frmQueryDate},
  UexpQuant in 'quantification\UexpQuant.pas' {frmExpQuant},
  UGeneralCSV in 'GeneralCSV\UGeneralCSV.pas',
  UprintRv5 in 'template\UprintRv5.pas' {DataModule_print: TDataModule},
  UpublicSet in 'public\UpublicSet.pas' {frmPulicSet};

{$R *.res}

Var

  hMutex:HWND;

  Ret:Integer;
begin
  hMutex:=CreateMutex(nil,False,'车号数据处理');
  Ret:=GetLastError;
  If Ret<>ERROR_ALREADY_EXISTS Then
  begin
    Application.Initialize;
    Application.Title := '车号数据处理';
    //DM first RUN
    Application.CreateForm(TDataModule_ado, DataModule_ado);
  try
      frm_login :=Tfrm_login.Create(nil);
      frm_login.ShowModal;
    finally
      frm_login.Free;
    end;
    if handlers<>'' then
    begin
      application.MessageBox('没有正确登录，不能使用本软件!','提示',mb_ok);
      Exit;
    end ;
    Application.CreateForm(TfrmMain, frmMain);
    Application.CreateForm(TDataModule_print, DataModule_print);
    Application.CreateForm(TDataModule_quantification, DataModule_quantification);
    Application.Run;
  end
  else
  begin
    Application.MessageBox('程序已经在运行！','提示',MB_OK+MB_ICONHAND);
    Exit;
  end;
end.
