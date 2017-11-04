object DataModule_ado: TDataModule_ado
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 111
  Top = 230
  Height = 383
  Width = 852
  object adoConnMain: TADOConnection
    LoginPrompt = False
    Left = 24
    Top = 8
  end
  object ADOQuery_Exec: TADOQuery
    Connection = adoConnMain
    Parameters = <>
    Left = 32
    Top = 136
  end
  object ADODataSet_trainOrder: TADODataSet
    Connection = adoConnMain
    CursorType = ctStatic
    CommandText = 'select * from trainOrder'
    Parameters = <>
    Left = 256
    Top = 64
  end
  object ADODataSet_traintotalh: TADODataSet
    Connection = adoConnMain
    Parameters = <>
    Left = 256
    Top = 8
  end
  object ADODataSet_breed: TADODataSet
    Connection = adoConnMain
    Parameters = <>
    Left = 128
    Top = 64
  end
  object ADODataSet_carNumber: TADODataSet
    Connection = adoConnMain
    Parameters = <>
    Left = 128
    Top = 8
  end
  object ADODataSet_Excel: TADODataSet
    Connection = adoConnMain
    Parameters = <>
    Left = 128
    Top = 136
  end
  object ADOQuery_temp: TADOQuery
    Connection = adoConnMain
    Parameters = <>
    Left = 64
    Top = 208
  end
  object adodataset_login: TADODataSet
    Connection = adoConnMain
    CommandText = 'select OperID, OperPassWord from operator'
    Parameters = <>
    Left = 24
    Top = 64
  end
  object ADODataSet_load: TADODataSet
    Connection = adoConnMain
    Parameters = <>
    Left = 480
    Top = 8
  end
  object ADODataSet_stevedore: TADODataSet
    Connection = adoConnMain
    Parameters = <>
    Left = 368
    Top = 248
  end
  object ADODataSet_2task: TADODataSet
    Connection = adoConnMain
    Parameters = <>
    Left = 368
    Top = 176
  end
  object ADODataSet_waitProcess: TADODataSet
    Connection = adoConnMain
    Parameters = <>
    Left = 480
    Top = 128
  end
  object ADODataSet_unload: TADODataSet
    Connection = adoConnMain
    Parameters = <>
    Left = 480
    Top = 72
  end
  object ADODataSet_getTrainData: TADODataSet
    Connection = adoConnMain
    Parameters = <>
    Left = 224
    Top = 176
  end
  object ADODataSet_get2TaskData: TADODataSet
    Connection = adoConnMain
    Parameters = <>
    Left = 224
    Top = 248
  end
  object ADODataSet_WPCprocess: TADODataSet
    Connection = adoConnMain
    Parameters = <>
    Left = 616
    Top = 128
  end
end
