object SortDialog: TSortDialog
  Left = 0
  Top = 0
  Cursor = crArrow
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'SortDialog'
  ClientHeight = 437
  ClientWidth = 434
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object PanelBackground: TPanel
    Left = 6
    Top = 6
    Width = 422
    Height = 330
    Cursor = crArrow
    Caption = 'PanelBackground'
    TabOrder = 5
  end
  object FilesListBox: TListBox
    Left = 8
    Top = 8
    Width = 417
    Height = 325
    Cursor = crArrow
    AutoComplete = False
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    DoubleBuffered = False
    IntegralHeight = True
    ItemHeight = 13
    ParentDoubleBuffered = False
    ScrollWidth = 100
    TabOrder = 0
    OnMouseDown = FilesListBoxMouseDown
    OnMouseUp = FilesListBoxMouseUp
  end
  object ButtonsPanel: TPanel
    Left = 8
    Top = 360
    Width = 417
    Height = 69
    Cursor = crArrow
    TabOrder = 1
    object SpeedButton_Help: TSpeedButton
      Left = 4
      Top = 28
      Width = 37
      Height = 37
      OnClick = SpeedButton_HelpClick
    end
    object DescButton: TButton
      Left = 322
      Top = 6
      Width = 82
      Height = 25
      Cursor = crArrow
      Caption = 'Desc'
      DoubleBuffered = False
      ParentDoubleBuffered = False
      TabOrder = 0
      OnClick = DescButtonClick
    end
    object AscButton: TButton
      Left = 235
      Top = 6
      Width = 81
      Height = 25
      Cursor = crArrow
      Caption = 'Asc'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = AscButtonClick
    end
    object ApplyButton: TButton
      Left = 235
      Top = 34
      Width = 81
      Height = 25
      Cursor = crArrow
      Caption = 'Change'
      ModalResult = 1
      TabOrder = 2
      OnClick = ApplyButtonClick
    end
    object CancelButton: TButton
      Left = 322
      Top = 34
      Width = 82
      Height = 25
      Cursor = crArrow
      Caption = 'Cancel'
      TabOrder = 3
      OnClick = CancelButtonClick
    end
  end
  object ShowFullPathFiles: TCheckBox
    Left = 8
    Top = 341
    Width = 201
    Height = 17
    Cursor = crArrow
    Caption = 'Show path files'
    TabOrder = 2
    OnClick = ShowFullPathFilesClick
  end
  object EasySelect: TCheckBox
    Left = 416
    Top = 341
    Width = 10
    Height = 17
    Cursor = crArrow
    Caption = 'EasySelect'
    Checked = True
    State = cbChecked
    TabOrder = 3
    Visible = False
    OnClick = EasySelectClick
  end
  object CheckBoxSensitive: TCheckBox
    Left = 215
    Top = 343
    Width = 195
    Height = 17
    Cursor = crArrow
    Caption = 'Sensitive'
    TabOrder = 4
    OnClick = CheckBoxSensitiveClick
  end
end
