object MainNavigate: TMainNavigate
  Left = 0
  Top = 0
  Width = 470
  Height = 384
  Cursor = crArrow
  TabOrder = 0
  object Label_DirectOpenArchive: TLabel
    Left = 12
    Top = 19
    Width = 173
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Caption = 'Direct open archive at next to list'
  end
  object Label_EdgePagesPaging: TLabel
    Left = 12
    Top = 59
    Width = 173
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Caption = 'Enabled edge pages changes'
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
  object CheckBox_DirectOpenArchive: TCheckBox
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
  object CheckBox_EdgePagesPaging: TCheckBox
    Left = 297
    Top = 56
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
end
