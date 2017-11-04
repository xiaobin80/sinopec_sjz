object frm_passset: Tfrm_passset
  Left = 330
  Top = 265
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #35774#23450#23494#30721
  ClientHeight = 203
  ClientWidth = 354
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 62
    Width = 60
    Height = 13
    Caption = #29992'  '#25143'  '#21517#65306
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 24
    Top = 96
    Width = 60
    Height = 13
    Caption = #23494'        '#30721#65306
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 24
    Top = 136
    Width = 60
    Height = 13
    Caption = #30830#35748#23494#30721#65306
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 24
    Top = 24
    Width = 67
    Height = 13
    Caption = #29992'  '#25143'ID'#65306
  end
  object edt_passet: TEdit
    Left = 88
    Top = 93
    Width = 241
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
  end
  object edt_rpasset: TEdit
    Left = 88
    Top = 132
    Width = 241
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
  end
  object btn_ok: TBitBtn
    Left = 256
    Top = 168
    Width = 75
    Height = 25
    Caption = #30830#35748'(&O)'
    Default = True
    TabOrder = 3
    OnClick = btn_okClick
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      3333333333333333333333330000333333333333333333333333F33333333333
      00003333344333333333333333388F3333333333000033334224333333333333
      338338F3333333330000333422224333333333333833338F3333333300003342
      222224333333333383333338F3333333000034222A22224333333338F338F333
      8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
      33333338F83338F338F33333000033A33333A222433333338333338F338F3333
      0000333333333A222433333333333338F338F33300003333333333A222433333
      333333338F338F33000033333333333A222433333333333338F338F300003333
      33333333A222433333333333338F338F00003333333333333A22433333333333
      3338F38F000033333333333333A223333333333333338F830000333333333333
      333A333333333333333338330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object btn_add: TBitBtn
    Left = 88
    Top = 168
    Width = 75
    Height = 25
    Cancel = True
    Caption = #26032#22686'(&N)'
    TabOrder = 4
    Visible = False
    OnClick = btn_addClick
    Glyph.Data = {
      76010000424D7601000000000000760000002800000020000000100000000100
      04000000000000010000130B0000130B00001000000000000000000000000000
      800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      33333333FF33333333FF333993333333300033377F3333333777333993333333
      300033F77FFF3333377739999993333333333777777F3333333F399999933333
      33003777777333333377333993333333330033377F3333333377333993333333
      3333333773333333333F333333333333330033333333F33333773333333C3333
      330033333337FF3333773333333CC333333333FFFFF77FFF3FF33CCCCCCCCCC3
      993337777777777F77F33CCCCCCCCCC3993337777777777377333333333CC333
      333333333337733333FF3333333C333330003333333733333777333333333333
      3000333333333333377733333333333333333333333333333333}
    NumGlyphs = 2
  end
  object cmbUID: TComboBox
    Left = 88
    Top = 20
    Width = 185
    Height = 21
    Style = csDropDownList
    Color = clBtnFace
    Enabled = False
    ItemHeight = 13
    TabOrder = 5
    TabStop = False
    OnChange = cmbUIDChange
  end
  object edt_userset: TEdit
    Left = 88
    Top = 56
    Width = 241
    Height = 21
    Enabled = False
    TabOrder = 0
  end
  object CheckBox_tag: TCheckBox
    Left = 272
    Top = 24
    Width = 57
    Height = 17
    Alignment = taLeftJustify
    Caption = #31649#29702#21592
    Enabled = False
    TabOrder = 6
  end
  object ADODataSet1: TADODataSet
    Connection = DataModule_ado.adoConnMain
    Parameters = <>
    Left = 8
  end
  object ADOQuery1: TADOQuery
    Connection = DataModule_ado.adoConnMain
    Parameters = <>
    Left = 48
  end
end
