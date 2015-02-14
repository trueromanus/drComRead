object FrameArchiveMain: TFrameArchiveMain
  Left = 0
  Top = 0
  Width = 470
  Height = 384
  Cursor = crArrow
  TabOrder = 0
  object Label_PathToTemp: TLabel
    Left = 12
    Top = 19
    Width = 445
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Caption = 'TempPath'
  end
  object Label_RARPath: TLabel
    Left = 12
    Top = 112
    Width = 445
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Caption = 'RarPath'
  end
  object Label_WindowsTemp: TLabel
    Left = 12
    Top = 81
    Width = 213
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Caption = 'Label_WindowsTemp'
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
  object Edit_TempPath: TEdit
    Left = 12
    Top = 38
    Width = 445
    Height = 21
    Cursor = crArrow
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 12
    Top = 68
    Width = 445
    Height = 3
    Cursor = crArrow
    BevelInner = bvLowered
    TabOrder = 3
  end
  object Panel2: TPanel
    Left = 12
    Top = 157
    Width = 445
    Height = 3
    Cursor = crArrow
    BevelInner = bvLowered
    TabOrder = 4
  end
  object Edit_RarPath: TEdit
    Left = 12
    Top = 129
    Width = 445
    Height = 21
    Cursor = crArrow
    TabOrder = 5
  end
  object Panel3: TPanel
    Left = 12
    Top = 103
    Width = 445
    Height = 3
    Cursor = crArrow
    BevelInner = bvLowered
    TabOrder = 6
  end
  object CheckBox_WindowsTemp: TCheckBox
    Left = 248
    Top = 80
    Width = 209
    Height = 17
    Cursor = crArrow
    TabOrder = 7
    OnClick = CheckBox_WindowsTempClick
  end
end
