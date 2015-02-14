object MainBackground: TMainBackground
  Left = 0
  Top = 0
  Width = 470
  Height = 384
  Cursor = crArrow
  TabOrder = 0
  object Label_Mode: TLabel
    Left = 12
    Top = 19
    Width = 173
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Caption = 'Background mode'
  end
  object Label_ConcreteColor: TLabel
    Left = 12
    Top = 55
    Width = 173
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Caption = 'Background color'
  end
  object Label_BackgroundImage: TLabel
    Left = 12
    Top = 90
    Width = 173
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Caption = 'Background image'
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
  object ComboBox_Background: TComboBox
    Left = 200
    Top = 16
    Width = 257
    Height = 21
    Cursor = crArrow
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 1
    Text = 'None'
    OnChange = ComboBox_BackgroundChange
    Items.Strings = (
      'None'
      'Tile'
      'AutoColor'
      'Color')
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
  object ColorBox_Color: TColorBox
    Left = 200
    Top = 52
    Width = 257
    Height = 22
    Cursor = crArrow
    ItemHeight = 16
    TabOrder = 3
    OnChange = ColorBox_ColorChange
  end
  object Button_Apply: TButton
    Left = 328
    Top = 280
    Width = 129
    Height = 25
    Cursor = crArrow
    Caption = 'Apply'
    TabOrder = 4
    OnClick = Button_ApplyClick
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
  object ImageView: TImageEnView
    Left = 200
    Top = 113
    Width = 257
    Height = 145
    Cursor = crArrow
    ParentCtl3D = False
    ZoomFilter = rfLanczos3
    ScrollBars = ssNone
    SelectionOptions = [iesoCanScroll]
    AutoFit = True
    ImageEnVersion = '3.1.2'
    EnableInteractionHints = False
    TabOrder = 6
  end
  object Button_ChangeImage: TButton
    Left = 200
    Top = 86
    Width = 257
    Height = 21
    Cursor = crArrow
    Caption = 'Button_ChangeImage'
    TabOrder = 7
    OnClick = Button_ChangeImageClick
  end
  object Panel_Separator4: TPanel
    Left = 12
    Top = 264
    Width = 445
    Height = 3
    Cursor = crArrow
    BevelInner = bvLowered
    TabOrder = 8
  end
end
