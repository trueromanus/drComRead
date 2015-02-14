object DirDialog: TDirDialog
  Left = 0
  Top = 0
  Cursor = crArrow
  BorderStyle = bsDialog
  Caption = #1054#1090#1082#1088#1099#1090#1100' '#1082#1072#1090#1072#1083#1086#1075
  ClientHeight = 325
  ClientWidth = 535
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesigned
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton_Help: TSpeedButton
    Left = 490
    Top = 284
    Width = 37
    Height = 37
    OnClick = SpeedButton_HelpClick
  end
  object Button_Open: TButton
    Left = 88
    Top = 296
    Width = 139
    Height = 25
    Cursor = crArrow
    Caption = #1054#1090#1082#1088#1099#1090#1100' '#1082#1072#1090#1072#1083#1086#1075
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button_Cancel: TButton
    Left = 296
    Top = 296
    Width = 139
    Height = 25
    Cursor = crArrow
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
  object DirList: TShellTreeView
    Left = 0
    Top = 0
    Width = 265
    Height = 265
    Cursor = crArrow
    ObjectTypes = [otFolders]
    Root = 'rfMyComputer'
    ShellListView = FileList
    UseShellImages = True
    AutoRefresh = False
    Indent = 19
    ParentColor = False
    RightClickSelect = True
    ShowRoot = False
    TabOrder = 0
  end
  object FileList: TShellListView
    Left = 268
    Top = 0
    Width = 266
    Height = 265
    Cursor = crArrow
    ObjectTypes = [otNonFolders]
    Root = 'rfMyComputer'
    ShellTreeView = DirList
    Sorted = True
    ReadOnly = False
    HideSelection = False
    OnChanging = FileListChanging
    ShowColumnHeaders = False
    TabOrder = 3
    ViewStyle = vsList
  end
  object CheckBoxFullPath: TCheckBox
    Left = 8
    Top = 273
    Width = 476
    Height = 17
    Cursor = crArrow
    Caption = 'CheckBoxFullPath'
    TabOrder = 4
    OnClick = CheckBoxFullPathClick
  end
end
