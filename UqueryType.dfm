object frmType: TfrmType
  Left = 389
  Top = 238
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #36135#36710#20316#19994#31867#22411
  ClientHeight = 191
  ClientWidth = 154
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 154
    Height = 191
    Align = alClient
    Caption = #31867#22411
    TabOrder = 0
    object rbFill: TRadioButton
      Left = 32
      Top = 48
      Width = 89
      Height = 17
      Caption = #35013#36710#20316#19994
      TabOrder = 0
      OnClick = rbFillClick
    end
    object rbClear: TRadioButton
      Left = 32
      Top = 96
      Width = 81
      Height = 17
      Caption = #21368#36710#20316#19994
      TabOrder = 1
      OnClick = rbClearClick
    end
    object rbBlend: TRadioButton
      Left = 32
      Top = 144
      Width = 89
      Height = 17
      Caption = #28151#21512#20316#19994
      TabOrder = 2
      OnClick = rbBlendClick
    end
  end
end
