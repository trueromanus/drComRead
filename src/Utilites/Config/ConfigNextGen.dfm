object FormConfig: TFormConfig
  Left = 0
  Top = 0
  Cursor = crArrow
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Config'
  ClientHeight = 465
  ClientWidth = 737
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TreeViewNavigate: TTreeView
    Left = 0
    Top = 0
    Width = 265
    Height = 465
    Cursor = crArrow
    Indent = 19
    ReadOnly = True
    TabOrder = 0
    OnChange = TreeViewNavigateChange
    OnClick = TreeViewNavigateClick
    Items.NodeData = {
      0304000000260000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF000000
      000600000001044D00610069006E003E00000001000000FFFFFFFFFFFFFFFFFF
      FFFFFF00000000000000000000000001105300630061006C006500200049006D
      0061006700650020004D006F0064006500400000000200000000000000FFFFFF
      FFFFFFFFFF0000000000000000000000000111570069006E0064006F00770020
      004200610063006B00670072006F0075006E0064003800000003000000000000
      00FFFFFFFFFFFFFFFF000000000000000000000000010D410063007400690076
      00650020005300630072006F006C006C00440000000400000000000000FFFFFF
      FFFFFFFFFF0000000000000000000000000113570069006E0064006F00770020
      0061006E00640020006C0061006E006700750061006700650036000000050000
      0000000000FFFFFFFFFFFFFFFF000000000000000000000000010C540077006F
      00200050006100670065006D006F00640065002E0000000600000000000000FF
      FFFFFFFFFFFFFF00000000000000000000000001084E00610076006900670061
      0074006500460000000000000000000000FFFFFFFFFFFFFFFF00000000000000
      0002000000011448006900730074006F0072007900200061006E006400200062
      006F006F006B006D00610072006B00300000000700000000000000FFFFFFFFFF
      FFFFFF000000000000000000000000010942006F006F006B006D00610072006B
      0073002C0000000D00000000000000FFFFFFFFFFFFFFFF000000000000000000
      000000010748006900730074006F00720079002E0000000000000000000000FF
      FFFFFFFFFFFFFF00000000000000000200000001084100720063006800690076
      0065007300260000000A00000000000000FFFFFFFFFFFFFFFF00000000000000
      000000000001044D00610069006E002C0000000B00000000000000FFFFFFFFFF
      FFFFFF000000000000000000000000010753006F007200740069006E0067003C
      0000000000000000000000FFFFFFFFFFFFFFFF00000000000000000100000001
      0F43006F006C006F00720043006F007200720065006300740069006F006E0026
      0000000C00000000000000FFFFFFFFFFFFFFFF00000000000000000000000001
      044D00610069006E00}
  end
  object Panel_FrameArea: TPanel
    Left = 267
    Top = 0
    Width = 470
    Height = 465
    TabOrder = 1
    inline MainScaleMode: TScaleMode
      Left = 0
      Top = 0
      Width = 470
      Height = 327
      Cursor = crArrow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Visible = False
    end
    inline MainBackground: TMainBackground
      Left = 0
      Top = 0
      Width = 481
      Height = 384
      Cursor = crArrow
      TabOrder = 1
      Visible = False
      ExplicitWidth = 481
    end
    inline MainActiveScroll: TMainActiveScroll
      Left = 1
      Top = 1
      Width = 468
      Height = 463
      Cursor = crArrow
      Align = alClient
      TabOrder = 2
      Visible = False
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 468
      ExplicitHeight = 463
    end
    inline MainTwoPage: TMainTwopage
      Left = 1
      Top = 1
      Width = 468
      Height = 463
      Cursor = crArrow
      Align = alClient
      TabOrder = 3
      Visible = False
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 468
      ExplicitHeight = 463
    end
    inline WindowAndLanguage: TMainWindowAndLanguage
      Left = 1
      Top = 1
      Width = 468
      Height = 463
      Cursor = crArrow
      Align = alClient
      TabOrder = 4
      Visible = False
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 468
      ExplicitHeight = 463
    end
    inline MainNavigate: TMainNavigate
      Left = 1
      Top = 1
      Width = 468
      Height = 463
      Cursor = crArrow
      Align = alClient
      TabOrder = 5
      Visible = False
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 468
      ExplicitHeight = 463
    end
    inline HistoryBookmark: THistoryBookmark
      Left = 1
      Top = 1
      Width = 468
      Height = 463
      Cursor = crArrow
      Align = alClient
      TabOrder = 6
      Visible = False
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 468
      ExplicitHeight = 463
    end
    inline ColorCorrectMain: TFrameColorCorrectMain
      Left = 1
      Top = 1
      Width = 468
      Height = 463
      Cursor = crArrow
      Align = alClient
      TabOrder = 7
      Visible = False
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 468
      ExplicitHeight = 463
    end
    inline ArchiveSort: TFrameArchiveSort
      Left = 1
      Top = 1
      Width = 468
      Height = 463
      Cursor = crArrow
      Align = alClient
      TabOrder = 8
      Visible = False
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 468
      ExplicitHeight = 463
    end
    inline ArchiveMain: TFrameArchiveMain
      Left = 1
      Top = 1
      Width = 468
      Height = 463
      Cursor = crArrow
      Align = alClient
      TabOrder = 9
      Visible = False
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 468
      ExplicitHeight = 463
    end
    inline FrameHistory: TFrameHistory
      Left = 1
      Top = 1
      Width = 468
      Height = 463
      Align = alClient
      TabOrder = 10
      Visible = False
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 468
      ExplicitHeight = 463
    end
  end
end
