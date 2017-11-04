object DataModule_quantification: TDataModule_quantification
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 454
  Top = 246
  Height = 194
  Width = 310
  object quantificationConn: TSQLConnection
    DriverName = 'Oracle'
    GetDriverFunc = 'getSQLDriverORACLE'
    LibraryName = 'dbexpora.dll'
    LoginPrompt = False
    Params.Strings = (
      'BlobSize=-1'
      'DataBase=Database Name'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'Password=password'
      'Oracle TransIsolation=ReadCommited'
      'User_Name=user')
    VendorLib = 'OCI.DLL'
    Left = 56
    Top = 16
  end
  object SQLClientDataSet_ghch: TSQLClientDataSet
    Aggregates = <>
    Options = [poAllowCommandText]
    ObjectView = True
    Params = <>
    DBConnection = quantificationConn
    Left = 64
    Top = 80
  end
  object SQLQuery_exec: TSQLQuery
    SQLConnection = quantificationConn
    Params = <>
    Left = 168
    Top = 80
  end
end
