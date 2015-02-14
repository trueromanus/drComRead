object MainActiveScroll: TMainActiveScroll
  Left = 0
  Top = 0
  Width = 470
  Height = 384
  Cursor = crArrow
  TabOrder = 0
  object Label_StartProgramState: TLabel
    Left = 12
    Top = 19
    Width = 279
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Caption = 'Activescroll run program state'
  end
  object Label_CurrentState: TLabel
    Left = 12
    Top = 56
    Width = 279
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Caption = 'Activescroll current state'
  end
  object Label_ActiveScrollSensitive: TLabel
    Left = 12
    Top = 92
    Width = 279
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Caption = 'ScrollSensitive'
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
  object CheckBox_StartProgramState: TCheckBox
    Left = 297
    Top = 16
    Width = 160
    Height = 17
    Cursor = crArrow
    TabOrder = 2
  end
  object CheckBox_RunProgramState: TCheckBox
    Left = 297
    Top = 56
    Width = 160
    Height = 17
    Cursor = crArrow
    TabOrder = 3
  end
  object Panel_Separator2: TPanel
    Left = 12
    Top = 43
    Width = 445
    Height = 3
    Cursor = crArrow
    BevelInner = bvLowered
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
  object Edit_ScrollSensitive: TEdit
    Left = 297
    Top = 88
    Width = 97
    Height = 21
    Cursor = crArrow
    TabOrder = 6
    Text = '10'
  end
  object UpDownScroll: TUpDown
    Left = 394
    Top = 88
    Width = 16
    Height = 21
    Cursor = crArrow
    Associate = Edit_ScrollSensitive
    Min = 10
    Max = 50
    Position = 10
    TabOrder = 7
  end
  object Panel_Separator4: TPanel
    Left = 12
    Top = 115
    Width = 445
    Height = 3
    Cursor = crArrow
    BevelInner = bvLowered
    TabOrder = 8
  end
end
