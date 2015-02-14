object ConfigFormDialog: TConfigFormDialog
  Left = 0
  Top = 0
  Cursor = crArrow
  BorderStyle = bsDialog
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072
  ClientHeight = 424
  ClientWidth = 516
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object LabelOlive: TLabel
    Left = 16
    Top = 341
    Width = 49
    Height = 13
    Caption = 'LabelOlive'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clOlive
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object LabelGreen: TLabel
    Left = 16
    Top = 358
    Width = 54
    Height = 13
    Caption = 'LabelGreen'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object LabelBlue: TLabel
    Left = 16
    Top = 376
    Width = 45
    Height = 13
    Caption = 'LabelBlue'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object SpeedButton_Help: TSpeedButton
    Left = 471
    Top = 383
    Width = 37
    Height = 37
    OnClick = SpeedButton_HelpClick
  end
  object Button_Cancel: TButton
    Left = 411
    Top = 352
    Width = 97
    Height = 25
    Cursor = crArrow
    Caption = #1047#1072#1082#1088#1099#1090#1100
    ModalResult = 2
    TabOrder = 1
  end
  object MainTabSheet: TPageControl
    Left = 8
    Top = 8
    Width = 498
    Height = 327
    Cursor = crArrow
    ActivePage = ColorCorrectOptions
    MultiLine = True
    TabOrder = 0
    TabPosition = tpRight
    TabStop = False
    object MainOptions: TTabSheet
      Cursor = crArrow
      Caption = 'MainOptions'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label_ASLevel: TLabel
        Left = 3
        Top = 17
        Width = 100
        Height = 13
        Cursor = crArrow
        Caption = 'Level Active Scrolling'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label_ASExponent: TLabel
        Left = 3
        Top = 44
        Width = 77
        Height = 13
        Cursor = crArrow
        Caption = 'Level of Destiny'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object CheckBox_DisableEffect: TCheckBox
        Left = 3
        Top = 213
        Width = 257
        Height = 17
        Cursor = crArrow
        Caption = 'Active Scroll'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clOlive
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object CheckBox_FullScreen: TCheckBox
        Left = 3
        Top = 236
        Width = 257
        Height = 17
        Cursor = crArrow
        Caption = 'Full Screen'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clOlive
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
      object CheckBox_DisableSound: TCheckBox
        Left = 3
        Top = 259
        Width = 257
        Height = 17
        Cursor = crArrow
        Caption = 'Minimize'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clOlive
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
      end
      object RadioGroup_View: TRadioGroup
        Left = 237
        Top = 41
        Width = 227
        Height = 152
        Cursor = crArrow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        Items.Strings = (
          'Original'
          'Fit To Width'
          'Scale'
          'Fit To Height'
          'Fit To User')
        ParentFont = False
        TabOrder = 3
        OnClick = RadioGroup_ViewClick
      end
      object Edit_ASExponent: TEdit
        Left = 161
        Top = 14
        Width = 40
        Height = 21
        Cursor = crArrow
        TabOrder = 4
        Text = '30'
      end
      object UpDown_ASExponent: TUpDown
        Left = 201
        Top = 14
        Width = 16
        Height = 21
        Cursor = crArrow
        Associate = Edit_ASExponent
        Min = 10
        Max = 50
        Position = 30
        TabOrder = 5
      end
      object Edit_ASLevel: TEdit
        Left = 161
        Top = 41
        Width = 40
        Height = 21
        Cursor = crArrow
        TabOrder = 6
        Text = '21'
      end
      object UpDown_ASLevel: TUpDown
        Left = 201
        Top = 41
        Width = 16
        Height = 21
        Cursor = crArrow
        Associate = Edit_ASLevel
        Min = 1
        Max = 60
        Position = 21
        TabOrder = 7
      end
      object Button_Save: TButton
        Left = 360
        Top = 274
        Width = 97
        Height = 26
        Cursor = crArrow
        Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
        Default = True
        TabOrder = 8
        OnClick = Button_SaveClick
      end
      object ChangeModeCombo: TComboBox
        Left = 237
        Top = 14
        Width = 230
        Height = 21
        Cursor = crArrow
        Style = csDropDownList
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemHeight = 0
        ItemIndex = 0
        ParentFont = False
        TabOrder = 9
        Text = #1055#1086#1088#1090#1088#1077#1090
        OnChange = ChangeModeComboChange
        Items.Strings = (
          #1055#1086#1088#1090#1088#1077#1090
          #1040#1083#1100#1073#1086#1084
          #1044#1074#1091#1093#1089#1090#1088#1072#1085#1080#1095#1085#1099#1081)
      end
      object BackgroundColorPanel: TPanel
        Left = 3
        Top = 68
        Width = 228
        Height = 99
        Cursor = crArrow
        TabOrder = 10
        object BackgroundColorBox: TColorBox
          Left = 122
          Top = 8
          Width = 97
          Height = 22
          Cursor = crArrow
          Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeNone, cbIncludeDefault, cbCustomColor, cbPrettyNames, cbCustomColors]
          DoubleBuffered = True
          DropDownCount = 10
          Enabled = False
          ItemHeight = 16
          ParentDoubleBuffered = False
          TabOrder = 0
        end
        object RadioBackgroundColor: TRadioButton
          Tag = 1
          Left = 3
          Top = 10
          Width = 113
          Height = 17
          Cursor = crArrow
          Caption = 'Background color'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = RadioBackgroundColorClick
        end
        object RadioNoneBackground: TRadioButton
          Tag = 4
          Left = 3
          Top = 77
          Width = 113
          Height = 17
          Cursor = crArrow
          Caption = 'None background'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = RadioBackgroundColorClick
        end
        object RadioFileTile: TRadioButton
          Tag = 2
          Left = 3
          Top = 35
          Width = 113
          Height = 17
          Cursor = crArrow
          Caption = 'Background tile'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = RadioBackgroundColorClick
        end
        object ButtonOpenFileBackground: TButton
          Left = 122
          Top = 36
          Width = 94
          Height = 16
          Cursor = crArrow
          Caption = 'Open file'
          TabOrder = 4
          OnClick = ButtonOpenFileBackgroundClick
        end
        object RadioAutoColor: TRadioButton
          Tag = 3
          Left = 3
          Top = 56
          Width = 113
          Height = 17
          Cursor = crArrow
          Caption = 'Auto color'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnClick = RadioBackgroundColorClick
        end
      end
      object EditUserScale: TEdit
        Left = 240
        Top = 200
        Width = 81
        Height = 21
        Cursor = crArrow
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 11
        Text = '0'
        OnChange = EditUserScaleChange
      end
      object UpDownScale: TUpDown
        Left = 321
        Top = 200
        Width = 16
        Height = 21
        Cursor = crArrow
        Associate = EditUserScale
        Enabled = False
        TabOrder = 12
      end
      object ComboBoxUser: TComboBox
        Left = 343
        Top = 199
        Width = 114
        Height = 21
        Cursor = crArrow
        Style = csDropDownList
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ItemHeight = 0
        ItemIndex = 0
        ParentFont = False
        TabOrder = 13
        Text = 'Percent'
        OnChange = ComboBoxUserChange
        Items.Strings = (
          'Percent'
          'Width Px'
          'Height Px')
      end
      object PanelLanguageProgram: TPanel
        Left = 3
        Top = 282
        Width = 257
        Height = 30
        TabOrder = 14
        object LabelLanguage: TLabel
          Left = 13
          Top = 8
          Width = 100
          Height = 13
          Cursor = crArrow
          AutoSize = False
          Caption = 'Language'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clOlive
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object ComboBoxLanguage: TComboBox
          Left = 119
          Top = 4
          Width = 132
          Height = 21
          Cursor = crArrow
          AutoComplete = False
          Style = csDropDownList
          ItemHeight = 0
          ItemIndex = 0
          TabOrder = 0
          Text = 'russian.lng'
          Items.Strings = (
            'russian.lng')
        end
      end
    end
    object KeysOptions: TTabSheet
      Cursor = crArrow
      Caption = 'ExtOptions'
      ImageIndex = 1
      object Label_RARLocate: TLabel
        Left = 16
        Top = 16
        Width = 177
        Height = 13
        Cursor = crArrow
        AutoSize = False
        Caption = 'Rar console locate'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Edit_RarConsoleLocate: TEdit
        Left = 199
        Top = 13
        Width = 210
        Height = 21
        Cursor = crArrow
        TabOrder = 0
      end
      object Button_RarLocate: TButton
        Left = 415
        Top = 11
        Width = 26
        Height = 25
        Cursor = crArrow
        Caption = '...'
        TabOrder = 1
        OnClick = Button_RarLocateClick
      end
      object Button_ApplyExt: TButton
        Left = 360
        Top = 272
        Width = 99
        Height = 25
        Cursor = crArrow
        Caption = 'Apply'
        Default = True
        TabOrder = 2
        OnClick = Button_ApplyExtClick
      end
      object CheckBoxAutoUpdate: TCheckBox
        Left = 16
        Top = 48
        Width = 425
        Height = 17
        Cursor = crArrow
        Caption = 'AutoUpdate'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clOlive
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object GroupBoxBookmarks: TGroupBox
        Left = 16
        Top = 80
        Width = 425
        Height = 127
        Cursor = crArrow
        Caption = 'GroupBoxBookmarks'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        object CheckBoxChangeToLastBookmark: TCheckBox
          Left = 6
          Top = 24
          Width = 411
          Height = 17
          Cursor = crArrow
          Caption = 'ChangeToLastBookmark'
          TabOrder = 0
        end
        object CheckBoxBookmarkIsOne: TCheckBox
          Left = 6
          Top = 49
          Width = 411
          Height = 17
          Cursor = crArrow
          Caption = 'BookmarkIsOne'
          TabOrder = 1
        end
        object CheckBoxAddBookmarkCloseProgram: TCheckBox
          Left = 6
          Top = 72
          Width = 411
          Height = 17
          Cursor = crArrow
          Caption = 'AddBookmarkCloseProgram'
          TabOrder = 2
        end
        object CheckBoxAddBookmarkCloseArchive: TCheckBox
          Left = 6
          Top = 97
          Width = 411
          Height = 17
          Cursor = crArrow
          Caption = 'AddBookmarkCloseArchive'
          TabOrder = 3
        end
      end
    end
    object ArchiveOptions: TTabSheet
      Cursor = crArrow
      Caption = 'ArchiveOptions'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object LabelSortFiles: TLabel
        Left = 11
        Top = 83
        Width = 278
        Height = 13
        Cursor = crArrow
        AutoSize = False
        Caption = 'Sort to opened'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object LabelSortArchives: TLabel
        Left = 11
        Top = 129
        Width = 278
        Height = 13
        Cursor = crArrow
        AutoSize = False
        Caption = 'Sort archives to opened'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object PathToTempDir: TLabeledEdit
        Left = 11
        Top = 24
        Width = 438
        Height = 21
        Cursor = crArrow
        BiDiMode = bdLeftToRight
        Color = clBtnHighlight
        EditLabel.Width = 82
        EditLabel.Height = 13
        EditLabel.Caption = 'Path To Temp Dir'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clOlive
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentBiDiMode = False
        ParentFont = False
        TabOrder = 0
        Text = 'temp\'
      end
      object ApplyArchive: TButton
        Left = 352
        Top = 283
        Width = 97
        Height = 25
        Cursor = crArrow
        Caption = 'Apply'
        TabOrder = 1
        OnClick = ApplyArchiveClick
      end
      object ModeSortFiles: TComboBox
        Left = 11
        Top = 102
        Width = 438
        Height = 21
        Cursor = crArrow
        ItemHeight = 0
        ItemIndex = 0
        TabOrder = 2
        Text = 'None'
        Items.Strings = (
          'None'
          'AscFull'
          'DescFull'
          'Asc'
          'Desc')
      end
      object WindowsSysDir: TCheckBox
        Left = 11
        Top = 51
        Width = 438
        Height = 17
        Cursor = crArrow
        Caption = 'Windows System Temp Dir'
        TabOrder = 3
        OnClick = WindowsSysDirClick
      end
      object ModeSortArchives: TComboBox
        Left = 11
        Top = 148
        Width = 438
        Height = 21
        Cursor = crArrow
        ItemHeight = 0
        ItemIndex = 0
        TabOrder = 4
        Text = 'None'
        Items.Strings = (
          'None'
          'AscFull'
          'DescFull'
          'Asc'
          'Desc')
      end
      object CheckBoxDirectChangerArchives: TCheckBox
        Left = 14
        Top = 271
        Width = 321
        Height = 17
        Cursor = crArrow
        Caption = 'Direct open archive at next to list'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
      end
      object TwoPagesGroupBox: TGroupBox
        Left = 11
        Top = 175
        Width = 438
        Height = 90
        Cursor = crArrow
        Caption = 'TwoPages View Group'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        object CheckBoxTwoPages: TCheckBox
          Left = 11
          Top = 18
          Width = 321
          Height = 17
          Cursor = crArrow
          Caption = 'TwoPages Mode'
          TabOrder = 0
        end
        object CheckBoxTwoPagesJapan: TCheckBox
          Left = 11
          Top = 41
          Width = 321
          Height = 17
          Cursor = crArrow
          Caption = 'TwoPages Japan mode'
          TabOrder = 1
        end
        object CheckBoxTwoPagesLong: TCheckBox
          Left = 11
          Top = 64
          Width = 321
          Height = 17
          Cursor = crArrow
          Caption = 'CheckBoxTwoPagesLong'
          TabOrder = 2
        end
      end
      object CheckBoxFilesSensitive: TCheckBox
        Left = 304
        Top = 82
        Width = 137
        Height = 17
        Cursor = crArrow
        Caption = 'Sensitive'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 7
      end
      object CheckBoxArchiveSensitive: TCheckBox
        Left = 304
        Top = 129
        Width = 137
        Height = 17
        Cursor = crArrow
        Caption = 'Sensitive'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 8
      end
    end
    object ColorCorrectOptions: TTabSheet
      Cursor = crArrow
      Caption = 'Color Correct'
      ImageIndex = 3
      object GroupCommonOptions: TGroupBox
        Left = 3
        Top = 3
        Width = 454
        Height = 150
        Cursor = crArrow
        Caption = 'GroupCommonOptions'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object LabelContrastImage: TLabel
          Left = 18
          Top = 123
          Width = 224
          Height = 13
          Cursor = crArrow
          AutoSize = False
          Caption = 'Change contrast image (disabled with 0)'
        end
        object LabelGammaCorrection: TLabel
          Left = 39
          Top = 95
          Width = 232
          Height = 13
          Cursor = crArrow
          AutoSize = False
          Caption = 'Change gamma correct (disabled with 1.0)'
        end
        object CheckBoxEnabledCurves: TCheckBox
          Left = 18
          Top = 24
          Width = 433
          Height = 17
          Cursor = crArrow
          Caption = 'CheckBoxEnabledCurves'
          TabOrder = 0
        end
        object CheckBoxSharpen: TCheckBox
          Left = 18
          Top = 47
          Width = 433
          Height = 17
          Cursor = crArrow
          Caption = 'CheckBoxSharpen'
          TabOrder = 1
        end
        object CheckBoxGammaCorrection: TCheckBox
          Left = 18
          Top = 94
          Width = 15
          Height = 17
          Cursor = crArrow
          TabOrder = 2
        end
        object UpDownContrast: TUpDown
          Left = 419
          Top = 119
          Width = 16
          Height = 21
          Cursor = crArrow
          Associate = EditContrast
          DoubleBuffered = True
          ParentDoubleBuffered = False
          TabOrder = 3
        end
        object EditContrast: TEdit
          Left = 248
          Top = 119
          Width = 171
          Height = 21
          Cursor = crArrow
          TabOrder = 4
          Text = '0'
        end
        object EditGammaCorrectOne: TEdit
          Left = 277
          Top = 92
          Width = 57
          Height = 21
          Cursor = crArrow
          TabOrder = 5
          Text = '1'
        end
        object UpDownGammaCorrectOne: TUpDown
          Left = 334
          Top = 92
          Width = 16
          Height = 21
          Cursor = crArrow
          Associate = EditGammaCorrectOne
          Min = 1
          Position = 1
          TabOrder = 6
        end
        object EditGammaCorrectTwo: TEdit
          Left = 362
          Top = 92
          Width = 57
          Height = 21
          Cursor = crArrow
          TabOrder = 7
          Text = '0'
        end
        object UpDown1: TUpDown
          Left = 419
          Top = 92
          Width = 16
          Height = 21
          Cursor = crArrow
          Position = 1
          TabOrder = 8
        end
        object CheckBoxSaturation: TCheckBox
          Left = 18
          Top = 72
          Width = 224
          Height = 17
          Cursor = crArrow
          Caption = 'Saturation'
          TabOrder = 9
          OnClick = CheckBoxSaturationClick
        end
        object EditSaturation: TEdit
          Left = 248
          Top = 68
          Width = 171
          Height = 21
          Cursor = crArrow
          TabOrder = 10
          Text = '0'
        end
        object UpDownSaturation: TUpDown
          Left = 419
          Top = 68
          Width = 16
          Height = 21
          Cursor = crArrow
          Associate = EditSaturation
          Min = -100
          TabOrder = 11
        end
      end
      object ButtonApplyColorCurves: TButton
        Left = 368
        Top = 291
        Width = 99
        Height = 25
        Cursor = crArrow
        Caption = 'Apply'
        TabOrder = 1
        OnClick = ButtonApplyColorCurvesClick
      end
    end
  end
end
