object frmExpQuant: TfrmExpQuant
  Left = 267
  Top = 164
  Width = 696
  Height = 480
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
    Width = 688
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
    Top = 434
    Width = 688
    Height = 19
    Panels = <>
    SimplePanel = False
  end
  object pnlMain: TPanel
    Left = 0
    Top = 41
    Width = 688
    Height = 393
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object pnlDateS: TPanel
      Left = 0
      Top = 0
      Width = 688
      Height = 49
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        688
        49)
      object Bevel10: TBevel
        Left = 0
        Top = 47
        Width = 688
        Height = 2
        Align = alBottom
      end
      object Label1: TLabel
        Left = 16
        Top = 16
        Width = 39
        Height = 13
        Caption = #26085#26399#65306
      end
      object Label3: TLabel
        Left = 400
        Top = 16
        Width = 78
        Height = 13
        Anchors = [akRight, akBottom]
        Caption = #38081#36335#32534#32452#21495#65306
      end
      object Label2: TLabel
        Left = 232
        Top = 16
        Width = 52
        Height = 13
        Anchors = [akRight, akBottom]
        Caption = #40857#32452#21495#65306
      end
      object cmbSaveTime: TComboBox
        Left = 56
        Top = 12
        Width = 169
        Height = 21
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnChange = cmbSaveTimeChange
      end
      object btnExpQuant: TButton
        Left = 560
        Top = 10
        Width = 113
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = #23548#20986#35745#37327#25968#25454'(&E)'
        TabOrder = 1
        OnClick = btnExpQuantClick
      end
      object edtGroup: TEdit
        Left = 472
        Top = 12
        Width = 81
        Height = 21
        Anchors = [akRight, akBottom]
        BevelEdges = [beRight, beBottom]
        TabOrder = 2
      end
      object cmbDI: TComboBox
        Left = 288
        Top = 12
        Width = 105
        Height = 21
        BevelEdges = [beRight, beBottom]
        Style = csDropDownList
        Anchors = [akRight, akBottom]
        ItemHeight = 13
        TabOrder = 3
      end
    end
    object DBGrid1: TDBGrid
      Left = 0
      Top = 49
      Width = 688
      Height = 344
      Align = alClient
      DataSource = DataSource1
      ReadOnly = True
      TabOrder = 1
      TitleFont.Charset = GB2312_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -13
      TitleFont.Name = #23435#20307
      TitleFont.Style = []
    end
  end
  object DataSource1: TDataSource
    DataSet = DataModule_ado.ADODataSet_stevedore
    Left = 16
    Top = 136
  end
end
