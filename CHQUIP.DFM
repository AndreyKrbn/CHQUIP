object FrmMain: TFrmMain
  Left = 192
  Top = 107
  Width = 769
  Height = 522
  Caption = 'FrmMain'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = LoadDate
  PixelsPerInch = 96
  TextHeight = 13
  object StrGrd1: TStringGrid
    Left = 40
    Top = 72
    Width = 361
    Height = 81
    ColCount = 6
    DefaultColWidth = 35
    RowCount = 3
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 0
    RowHeights = (
      24
      23
      21)
  end
  object LblEdtT: TLabeledEdit
    Left = 40
    Top = 40
    Width = 41
    Height = 21
    EditLabel.Width = 121
    EditLabel.Height = 13
    EditLabel.Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1083#1077#1090' '#1074' '#1087#1083#1072#1085#1077
    TabOrder = 1
    OnExit = GetStrGrd1
  end
  object LblEdtPo: TLabeledEdit
    Left = 360
    Top = 40
    Width = 41
    Height = 21
    EditLabel.Width = 178
    EditLabel.Height = 13
    EditLabel.Caption = #1042#1099#1088#1091#1095#1082#1072' '#1086#1090' '#1087#1088#1086#1076#1072#1078#1080' '#1086#1073#1086#1088#1091#1076#1086#1074#1072#1085#1080#1103
    TabOrder = 2
  end
  object LblEdtPn: TLabeledEdit
    Left = 176
    Top = 40
    Width = 49
    Height = 21
    EditLabel.Width = 167
    EditLabel.Height = 13
    EditLabel.Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1085#1086#1074#1086#1075#1086' '#1086#1073#1086#1088#1091#1076#1086#1074#1072#1085#1080#1103
    TabOrder = 3
  end
  object BtnUpdate: TButton
    Left = 40
    Top = 160
    Width = 89
    Height = 25
    Caption = 'Update of Data'
    TabOrder = 4
    OnClick = Update_d
  end
  object BtnSolve: TButton
    Left = 144
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Solve'
    TabOrder = 5
    OnClick = GetSolve
  end
  object Memo1: TMemo
    Left = 40
    Top = 208
    Width = 361
    Height = 273
    Lines.Strings = (
      '')
    ScrollBars = ssVertical
    TabOrder = 6
  end
end
