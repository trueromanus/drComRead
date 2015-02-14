object ArcForm: TArcForm
  Left = 0
  Top = 0
  Cursor = crArrow
  BorderStyle = bsDialog
  Caption = 'Archive Dialog'
  ClientHeight = 420
  ClientWidth = 436
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object FilterLabel: TLabel
    Left = 8
    Top = 5
    Width = 24
    Height = 13
    Cursor = crArrow
    Caption = 'Filter'
  end
  object SortLabel: TLabel
    Left = 160
    Top = 350
    Width = 81
    Height = 13
    Cursor = crArrow
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Sort'
  end
  object SpeedButton_Help: TSpeedButton
    Left = 391
    Top = 375
    Width = 37
    Height = 37
    OnClick = SpeedButton_HelpClick
  end
  object PanelBackground2: TPanel
    Left = 6
    Top = 46
    Width = 423
    Height = 262
    Cursor = crArrow
    Caption = 'PanelBackground2'
    TabOrder = 10
  end
  object PanelBackground1: TPanel
    Left = 6
    Top = 21
    Width = 358
    Height = 20
    Cursor = crArrow
    Caption = 'PanelBackground1'
    TabOrder = 9
  end
  object ArcList: TListBox
    Left = 8
    Top = 48
    Width = 418
    Height = 257
    Cursor = crArrow
    BorderStyle = bsNone
    ItemHeight = 13
    TabOrder = 2
  end
  object FilterEdit: TEdit
    Left = 8
    Top = 23
    Width = 353
    Height = 15
    Cursor = crArrow
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    DragCursor = crArrow
    TabOrder = 3
  end
  object ChangeButton: TButton
    Left = 40
    Top = 343
    Width = 97
    Height = 25
    Cursor = crArrow
    Hint = 'Enter'
    Caption = 'Change'
    ModalResult = 1
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    TabStop = False
    OnClick = ChangeButtonClick
  end
  object CancelButton: TButton
    Left = 296
    Top = 343
    Width = 98
    Height = 25
    Cursor = crArrow
    Hint = 'Esc'
    Caption = 'Cancel'
    ModalResult = 2
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    TabStop = False
    OnClick = CancelButtonClick
  end
  object UpDown: TUpDown
    Left = 247
    Top = 344
    Width = 26
    Height = 25
    Cursor = crArrow
    TabOrder = 4
    OnClick = UpDownClick
  end
  object CheckBoxNotShowFullPath: TCheckBox
    Left = 8
    Top = 312
    Width = 185
    Height = 17
    Cursor = crArrow
    Caption = 'Not full path to files'
    Checked = True
    State = cbChecked
    TabOrder = 5
    OnClick = CheckBoxNotShowFullPathClick
  end
  object CheckBoxCaseSensitive: TCheckBox
    Left = 224
    Top = 311
    Width = 202
    Height = 17
    Cursor = crArrow
    Caption = 'Case sensitive'
    Enabled = False
    TabOrder = 6
  end
  object ButtonPrevFind: TButton
    Left = 367
    Top = 21
    Width = 27
    Height = 21
    Cursor = crArrow
    Caption = '<'
    TabOrder = 7
    OnClick = ButtonPrevFindClick
  end
  object ButtonNextFind: TButton
    Left = 399
    Top = 21
    Width = 27
    Height = 21
    Cursor = crArrow
    Caption = '>'
    TabOrder = 8
    OnClick = ButtonNextFindClick
  end
end
