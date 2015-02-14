object MainWindowAndLanguage: TMainWindowAndLanguage
  Left = 0
  Top = 0
  Width = 470
  Height = 384
  Cursor = crArrow
  TabOrder = 0
  object Label_ActivateFullScreen: TLabel
    Left = 12
    Top = 19
    Width = 253
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Caption = 'ActivateFullScreenStart'
  end
  object Label_MinimizeStart: TLabel
    Left = 12
    Top = 56
    Width = 253
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Caption = 'ActivateMinimazeStart'
  end
  object Label_Language: TLabel
    Left = 12
    Top = 92
    Width = 253
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Caption = 'Language'
  end
  object Button_Apply: TButton
    Left = 328
    Top = 280
    Width = 129
    Height = 25
    Cursor = crArrow
    Caption = 'Apply'
    TabOrder = 0
    OnClick = Button_ApplyClick
  end
  object Panel_Separator: TPanel
    Left = 12
    Top = 7
    Width = 445
    Height = 3
    Cursor = crArrow
    BevelInner = bvLowered
    TabOrder = 1
  end
  object CheckBox_ActivateFullScreen: TCheckBox
    Left = 297
    Top = 16
    Width = 160
    Height = 17
    Cursor = crArrow
    TabOrder = 2
  end
  object Panel_Separator2: TPanel
    Left = 12
    Top = 43
    Width = 445
    Height = 3
    Cursor = crArrow
    BevelInner = bvLowered
    TabOrder = 3
  end
  object CheckBox_MinimizeStart: TCheckBox
    Left = 297
    Top = 53
    Width = 160
    Height = 17
    Cursor = crArrow
    TabOrder = 4
  end
  object Panel_Separator3: TPanel
    Left = 12
    Top = 79
    Width = 445
    Height = 3
    Cursor = crArrow
    BevelInner = bvLowered
    TabOrder = 5
  end
  object ComboBoxLanguage: TComboBox
    Left = 297
    Top = 88
    Width = 160
    Height = 21
    Cursor = crArrow
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
  end
  object Panel_Separator4: TPanel
    Left = 12
    Top = 111
    Width = 445
    Height = 3
    Cursor = crArrow
    BevelInner = bvLowered
    TabOrder = 7
  end
end
