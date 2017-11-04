object frmCarKind: TfrmCarKind
  Left = 277
  Top = 250
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  ClientHeight = 191
  ClientWidth = 458
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 458
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Color = clWindow
    Font.Charset = GB2312_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 172
    Width = 458
    Height = 19
    Panels = <>
    SimplePanel = False
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 41
    Width = 458
    Height = 131
    Hint = #36710#31181#31616#31216#19981#20801#35768#37325#22797
    Align = alClient
    DataSource = DataSource1
    PopupMenu = PopupMenu1
    TabOrder = 2
    TitleFont.Charset = GB2312_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -13
    TitleFont.Name = #23435#20307
    TitleFont.Style = []
  end
  object ADODataSet1: TADODataSet
    Connection = DataModule_ado.adoConnMain
    OnEditError = ADODataSet1EditError
    OnPostError = ADODataSet1PostError
    Parameters = <>
    Left = 8
    Top = 8
  end
  object DataSource1: TDataSource
    DataSet = ADODataSet1
    Left = 48
    Top = 8
  end
  object PopupMenu1: TPopupMenu
    Left = 256
    Top = 104
    object E1: TMenuItem
      Caption = #32534#36753'(&E)'
      OnClick = E1Click
    end
    object A1: TMenuItem
      Caption = #22686#21152'(&A)'
      OnClick = A1Click
    end
    object S1: TMenuItem
      Caption = #20445#23384'(&S)'
      OnClick = S1Click
    end
    object D1: TMenuItem
      Caption = #21024#38500'(&D)'
      OnClick = D1Click
    end
  end
end
