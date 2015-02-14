object Form_Info: TForm_Info
  Left = 0
  Top = 0
  Cursor = crArrow
  BorderStyle = bsDialog
  ClientHeight = 465
  ClientWidth = 498
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton_Help: TSpeedButton
    Left = 453
    Top = 425
    Width = 37
    Height = 37
    OnClick = SpeedButton_HelpClick
  end
  object Combo_List: TComboBox
    Left = 0
    Top = 370
    Width = 497
    Height = 21
    Cursor = crArrow
    BevelInner = bvNone
    BevelOuter = bvNone
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = Combo_ListChange
    Items.Strings = (
      '1'
      '2'
      '3')
  end
  object Button_Close: TButton
    Left = 168
    Top = 397
    Width = 161
    Height = 25
    Cursor = crArrow
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = Button_CloseClick
  end
  object ChangeColorBox: TColorBox
    Left = 408
    Top = 397
    Width = 89
    Height = 22
    Cursor = crArrow
    Selected = clNone
    Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbCustomColor, cbPrettyNames, cbCustomColors]
    Color = clBtnFace
    Ctl3D = True
    ItemHeight = 16
    ParentCtl3D = False
    ParentShowHint = False
    ShowHint = False
    TabOrder = 2
    OnChange = ChangeColorBoxChange
  end
  object FontDialogButton: TButton
    Left = 8
    Top = 397
    Width = 25
    Height = 25
    Cursor = crArrow
    Caption = '...'
    TabOrder = 3
    OnClick = FontDialogButtonClick
  end
  object Memo_Text: TRichEdit
    Left = 0
    Top = 0
    Width = 497
    Height = 369
    Cursor = crArrow
    BorderStyle = bsNone
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 4
  end
end
