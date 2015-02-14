object MainTwopage: TMainTwopage
  Left = 0
  Top = 0
  Width = 470
  Height = 384
  Cursor = crArrow
  TabOrder = 0
  object Label_Activate: TLabel
    Left = 12
    Top = 19
    Width = 253
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Caption = 'ActivateTwoPage'
  end
  object Label_TwoPageJapan: TLabel
    Left = 12
    Top = 56
    Width = 253
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Caption = 'TwoPageJapan'
  end
  object Label_OnePagePaging: TLabel
    Left = 12
    Top = 89
    Width = 253
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Caption = 'OnePagePaging'
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
  object CheckBox_Activate: TCheckBox
    Left = 297
    Top = 16
    Width = 160
    Height = 17
    Cursor = crArrow
    TabOrder = 1
    OnClick = CheckBox_ActivateClick
  end
  object Panel_Separator2: TPanel
    Left = 12
    Top = 43
    Width = 445
    Height = 3
    Cursor = crArrow
    BevelInner = bvLowered
    TabOrder = 2
  end
  object Button_Apply: TButton
    Left = 328
    Top = 280
    Width = 129
    Height = 25
    Cursor = crArrow
    Caption = 'Apply'
    TabOrder = 3
    OnClick = Button_ApplyClick
  end
  object CheckBox_Japan: TCheckBox
    Left = 297
    Top = 53
    Width = 160
    Height = 17
    Cursor = crArrow
    TabOrder = 4
    OnClick = CheckBox_JapanClick
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
  object CheckBox_OnePagePaging: TCheckBox
    Left = 297
    Top = 88
    Width = 160
    Height = 17
    Cursor = crArrow
    TabOrder = 6
    OnClick = CheckBox_OnePagePagingClick
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
