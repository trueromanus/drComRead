object ScaleMode: TScaleMode
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
  object LabelOrientation: TLabel
    Left = 12
    Top = 19
    Width = 182
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Caption = 'Change orientation'
  end
  object LabelChangeScaleMode: TLabel
    Left = 12
    Top = 48
    Width = 182
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Caption = 'Change Scale mode'
  end
  object LabelUserValue: TLabel
    Left = 12
    Top = 235
    Width = 182
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Caption = 'Change User value'
  end
  object ComboBox_ImageOrient: TComboBox
    Left = 200
    Top = 16
    Width = 257
    Height = 21
    Cursor = crArrow
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
    OnChange = ComboBox_ImageOrientChange
  end
  object RadioGroupScaleMode: TRadioGroup
    Left = 200
    Top = 43
    Width = 257
    Height = 174
    Cursor = crArrow
    Items.Strings = (
      'Original'
      'Scale'
      'Fit Width'
      'Fit Height'
      'User value')
    TabOrder = 1
    OnClick = RadioGroupScaleModeClick
  end
  object ComboBoxUserValueRange: TComboBox
    Left = 328
    Top = 232
    Width = 129
    Height = 21
    Cursor = crArrow
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 2
    Text = 'Percent'
    OnChange = ComboBoxUserValueRangeChange
    Items.Strings = (
      'Percent'
      'Pixels')
  end
  object EditUserValue: TEdit
    Left = 200
    Top = 232
    Width = 121
    Height = 21
    Cursor = crArrow
    TabOrder = 3
    Text = '0'
    OnChange = EditUserValueChange
  end
  object ButtonApply: TButton
    Left = 328
    Top = 280
    Width = 129
    Height = 25
    Cursor = crArrow
    Caption = 'Apply'
    TabOrder = 4
    OnClick = ButtonApplyClick
  end
  object Panel_Orientation: TPanel
    Left = 12
    Top = 41
    Width = 445
    Height = 3
    Cursor = crArrow
    BevelInner = bvLowered
    TabOrder = 5
  end
  object Panel_UserValue: TPanel
    Left = 12
    Top = 222
    Width = 445
    Height = 3
    Cursor = crArrow
    BevelInner = bvLowered
    TabOrder = 6
  end
  object Panel1: TPanel
    Left = 12
    Top = 7
    Width = 445
    Height = 3
    Cursor = crArrow
    BevelInner = bvLowered
    TabOrder = 7
  end
  object Panel2: TPanel
    Left = 12
    Top = 259
    Width = 445
    Height = 3
    Cursor = crArrow
    BevelInner = bvLowered
    TabOrder = 8
  end
end
