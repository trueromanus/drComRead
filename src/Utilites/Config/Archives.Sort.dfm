object FrameArchiveSort: TFrameArchiveSort
  Left = 0
  Top = 0
  Width = 470
  Height = 384
  Cursor = crArrow
  TabOrder = 0
  object Label_Sensitivy: TLabel
    Left = 12
    Top = 19
    Width = 221
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Caption = 'Sensitive files'
  end
  object Label_SortingFiles: TLabel
    Left = 12
    Top = 51
    Width = 221
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Caption = 'Sorting files'
  end
  object Label_SensitiveArchives: TLabel
    Left = 12
    Top = 89
    Width = 221
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Caption = 'Sensitive archive'
  end
  object Label_SortingArchives: TLabel
    Left = 12
    Top = 123
    Width = 221
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Caption = 'Sorting archives'
  end
  object Panel_Separator: TPanel
    Left = 12
    Top = 7
    Width = 445
    Height = 3
    Cursor = crArrow
    BevelInner = bvLowered
    TabOrder = 0
  end
  object Button_Apply: TButton
    Left = 328
    Top = 280
    Width = 129
    Height = 25
    Cursor = crArrow
    Caption = 'Apply'
    TabOrder = 1
    OnClick = Button_ApplyClick
  end
  object CheckBox_Sensitive: TCheckBox
    Left = 248
    Top = 16
    Width = 209
    Height = 17
    Cursor = crArrow
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 12
    Top = 77
    Width = 445
    Height = 3
    Cursor = crArrow
    BevelInner = bvLowered
    TabOrder = 3
  end
  object ComboBox_SortingFiles: TComboBox
    Left = 248
    Top = 48
    Width = 209
    Height = 21
    Cursor = crArrow
    ItemHeight = 13
    TabOrder = 4
    Text = 'ComboBox_SortingFiles'
  end
  object CheckBox_SensitiveArchive: TCheckBox
    Left = 248
    Top = 89
    Width = 209
    Height = 17
    Cursor = crArrow
    TabOrder = 5
  end
  object Panel2: TPanel
    Left = 12
    Top = 148
    Width = 445
    Height = 3
    Cursor = crArrow
    BevelInner = bvLowered
    TabOrder = 6
  end
  object ComboBox_SortingArchives: TComboBox
    Left = 248
    Top = 120
    Width = 209
    Height = 21
    Cursor = crArrow
    ItemHeight = 13
    TabOrder = 7
    Text = 'ComboBox_SortingFiles'
  end
end
