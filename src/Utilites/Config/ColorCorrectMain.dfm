object FrameColorCorrectMain: TFrameColorCorrectMain
  Left = 0
  Top = 0
  Width = 470
  Height = 384
  Cursor = crArrow
  TabOrder = 0
  object Label_EnabledCurves: TLabel
    Left = 12
    Top = 19
    Width = 279
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Caption = 'Enabled curves'
  end
  object Label_Sharpen: TLabel
    Left = 12
    Top = 52
    Width = 279
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Caption = 'Enabled sharpen'
  end
  object Label_Saturation: TLabel
    Left = 12
    Top = 82
    Width = 279
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Caption = 'Enabled saturation'
  end
  object Label_GammaCorrection: TLabel
    Left = 12
    Top = 139
    Width = 279
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Caption = 'Enabled gamma correction'
  end
  object Label_EnabledContrast: TLabel
    Left = 12
    Top = 203
    Width = 279
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Caption = 'Enabled contrast'
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
  object CheckBox_EnabledCurves: TCheckBox
    Left = 297
    Top = 16
    Width = 160
    Height = 17
    Cursor = crArrow
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 12
    Top = 39
    Width = 445
    Height = 3
    Cursor = crArrow
    BevelInner = bvLowered
    TabOrder = 3
  end
  object CheckBox_Sharpen: TCheckBox
    Left = 297
    Top = 48
    Width = 160
    Height = 17
    Cursor = crArrow
    TabOrder = 4
  end
  object Panel2: TPanel
    Left = 12
    Top = 71
    Width = 445
    Height = 3
    Cursor = crArrow
    BevelInner = bvLowered
    TabOrder = 5
  end
  object CheckBox_Saturation: TCheckBox
    Left = 297
    Top = 80
    Width = 160
    Height = 17
    Cursor = crArrow
    TabOrder = 6
    OnClick = CheckBox_SaturationClick
  end
  object Panel3: TPanel
    Left = 12
    Top = 128
    Width = 445
    Height = 3
    Cursor = crArrow
    BevelInner = bvLowered
    TabOrder = 7
  end
  object Edit_Saturation: TEdit
    Left = 297
    Top = 103
    Width = 144
    Height = 21
    Cursor = crArrow
    TabOrder = 8
    Text = '0'
  end
  object UpDown_Saturation: TUpDown
    Left = 441
    Top = 103
    Width = 16
    Height = 21
    Cursor = crArrow
    Associate = Edit_Saturation
    Min = -100
    TabOrder = 9
  end
  object Panel4: TPanel
    Left = 12
    Top = 192
    Width = 445
    Height = 3
    Cursor = crArrow
    BevelInner = bvLowered
    TabOrder = 10
  end
  object CheckBox_GammaCorrect: TCheckBox
    Left = 297
    Top = 137
    Width = 160
    Height = 17
    Cursor = crArrow
    TabOrder = 11
    OnClick = CheckBox_GammaCorrectClick
  end
  object Edit_GammaFirst: TEdit
    Left = 297
    Top = 165
    Width = 56
    Height = 21
    Cursor = crArrow
    TabOrder = 12
    Text = '1'
  end
  object Edit_GammaSecond: TEdit
    Left = 384
    Top = 165
    Width = 57
    Height = 21
    Cursor = crArrow
    TabOrder = 13
    Text = '0'
  end
  object UpDown_GammaFirst: TUpDown
    Left = 353
    Top = 165
    Width = 16
    Height = 21
    Cursor = crArrow
    Associate = Edit_GammaFirst
    Min = 1
    Position = 1
    TabOrder = 14
  end
  object UpDown_GammaSecond: TUpDown
    Left = 441
    Top = 165
    Width = 16
    Height = 21
    Cursor = crArrow
    Associate = Edit_GammaSecond
    TabOrder = 15
  end
  object Panel5: TPanel
    Left = 12
    Top = 256
    Width = 445
    Height = 3
    Cursor = crArrow
    BevelInner = bvLowered
    TabOrder = 16
  end
  object CheckBox_Contrast: TCheckBox
    Left = 297
    Top = 201
    Width = 160
    Height = 17
    Cursor = crArrow
    TabOrder = 17
    OnClick = CheckBox_ContrastClick
  end
  object Edit_Contrast: TEdit
    Left = 297
    Top = 229
    Width = 144
    Height = 21
    Cursor = crArrow
    TabOrder = 18
    Text = '0'
  end
  object UpDown_Contrast: TUpDown
    Left = 441
    Top = 229
    Width = 16
    Height = 21
    Cursor = crArrow
    Associate = Edit_Contrast
    TabOrder = 19
  end
end
