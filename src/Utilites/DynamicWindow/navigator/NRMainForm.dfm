object CRNavigator: TCRNavigator
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  Caption = #1053#1072#1074#1080#1075#1072#1090#1086#1088
  ClientHeight = 215
  ClientWidth = 298
  Color = clBtnFace
  TransparentColor = True
  TransparentColorValue = clFuchsia
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnMouseDown = FormMouseDown
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object FocusPanel: TPanel
    Left = 152
    Top = 96
    Width = 0
    Height = 0
    TabOrder = 0
    Visible = False
  end
  object DragPanel: TPanel
    Left = 135
    Top = 86
    Width = 32
    Height = 18
    Cursor = crDrag
    BevelOuter = bvNone
    Caption = '< >'
    Color = clSkyBlue
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnMouseDown = DragPanelMouseDown
    OnMouseMove = DragPanelMouseMove
    OnMouseUp = DragPanelMouseUp
    object ImageDragPanel: TImage
      Left = 0
      Top = 0
      Width = 32
      Height = 18
      Cursor = crArrow
      Align = alClient
      OnMouseDown = DragPanelMouseDown
      OnMouseMove = DragPanelMouseMove
      OnMouseUp = DragPanelMouseUp
      ExplicitLeft = 8
      ExplicitTop = 8
      ExplicitWidth = 105
      ExplicitHeight = 105
    end
  end
  object UpPanel: TPanel
    Left = 136
    Top = 30
    Width = 34
    Height = 34
    Cursor = crArrow
    BevelKind = bkFlat
    BevelOuter = bvNone
    TabOrder = 2
    object UpImage: TImage
      Tag = 1
      Left = 0
      Top = 0
      Width = 30
      Height = 30
      Cursor = crArrow
      ParentShowHint = False
      ShowHint = True
      OnClick = UpImageClick
      OnMouseDown = FormMouseDown
    end
  end
  object LeftPanel: TPanel
    Left = 88
    Top = 80
    Width = 34
    Height = 34
    Cursor = crArrow
    BevelKind = bkFlat
    BevelOuter = bvNone
    TabOrder = 3
    object LeftImage: TImage
      Tag = 2
      Left = 0
      Top = 0
      Width = 30
      Height = 30
      Cursor = crArrow
      ParentShowHint = False
      ShowHint = True
      OnClick = LeftImageClick
      OnMouseDown = FormMouseDown
    end
  end
  object RightPanel: TPanel
    Left = 183
    Top = 80
    Width = 34
    Height = 34
    Cursor = crArrow
    BevelKind = bkFlat
    BevelOuter = bvNone
    TabOrder = 4
    object RightImage: TImage
      Tag = 3
      Left = 0
      Top = 0
      Width = 30
      Height = 30
      Cursor = crArrow
      ParentShowHint = False
      ShowHint = True
      OnClick = RightImageClick
      OnMouseDown = FormMouseDown
    end
  end
  object DownPanel: TPanel
    Left = 136
    Top = 120
    Width = 34
    Height = 34
    Cursor = crArrow
    BevelKind = bkFlat
    BevelOuter = bvNone
    TabOrder = 5
    object DownImage: TImage
      Tag = 4
      Left = 0
      Top = 0
      Width = 30
      Height = 30
      Cursor = crArrow
      ParentShowHint = False
      ShowHint = True
      OnClick = DownImageClick
      OnMouseDown = FormMouseDown
    end
  end
  object ActiveScrollPanel: TPanel
    Tag = 5
    Left = 48
    Top = 16
    Width = 73
    Height = 25
    Cursor = crArrow
    Color = clSkyBlue
    TabOrder = 6
    OnClick = ActiveScrollPanelClick
    object ActiveScrollImage: TImage
      Left = 1
      Top = 1
      Width = 71
      Height = 23
      Align = alClient
      Stretch = True
      OnClick = ActiveScrollPanelClick
      ExplicitLeft = 13
      ExplicitTop = -13
      ExplicitWidth = 40
      ExplicitHeight = 34
    end
    object ActiveScrollLabel: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 65
      Height = 17
      Cursor = crArrow
      Align = alClient
      Alignment = taCenter
      AutoSize = False
      Color = clFuchsia
      ParentColor = False
      ParentShowHint = False
      ShowHint = True
      Transparent = True
      Layout = tlCenter
      OnClick = ActiveScrollPanelClick
      OnMouseDown = FormMouseDown
      ExplicitLeft = 22
      ExplicitTop = 8
      ExplicitWidth = 31
      ExplicitHeight = 13
    end
  end
  object FuncPanel: TPanel
    Tag = 6
    Left = 183
    Top = 16
    Width = 73
    Height = 25
    Cursor = crArrow
    Color = clSkyBlue
    TabOrder = 7
    object FuncImage: TImage
      Left = 1
      Top = 1
      Width = 71
      Height = 23
      Align = alClient
      Stretch = True
      ExplicitLeft = 16
      ExplicitTop = -12
      ExplicitWidth = 37
      ExplicitHeight = 33
    end
    object FuncLabel: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 65
      Height = 17
      Align = alClient
      Alignment = taCenter
      AutoSize = False
      Color = clFuchsia
      ParentColor = False
      Transparent = True
      Layout = tlCenter
      OnMouseDown = FormMouseDown
      ExplicitLeft = 22
      ExplicitTop = 8
      ExplicitWidth = 31
      ExplicitHeight = 13
    end
    object PrevArchive: TImage
      Left = 0
      Top = 0
      Width = 33
      Height = 20
      Cursor = crArrow
      ParentShowHint = False
      ShowHint = True
      Transparent = True
      OnClick = PrevArchiveClick
      OnMouseDown = PrevArchiveMouseDown
    end
    object NextArchive: TImage
      Left = 41
      Top = 0
      Width = 33
      Height = 20
      Cursor = crArrow
      ParentShowHint = False
      ShowHint = True
      Transparent = True
      OnClick = NextArchiveClick
      OnMouseDown = PrevArchiveMouseDown
    end
  end
  object RotateSavePanel: TPanel
    Tag = 8
    Left = 176
    Top = 161
    Width = 80
    Height = 23
    Cursor = crArrow
    Color = clSkyBlue
    ParentShowHint = False
    ShowHint = False
    TabOrder = 8
    object RotateSaveImage: TImage
      Left = 1
      Top = 1
      Width = 78
      Height = 21
      Align = alClient
      Stretch = True
      ExplicitLeft = 13
      ExplicitTop = -13
      ExplicitWidth = 40
      ExplicitHeight = 34
    end
    object RotateSaveLabel: TLabel
      Tag = 1
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 72
      Height = 15
      Align = alClient
      Alignment = taCenter
      AutoSize = False
      Caption = 'List'
      Color = clFuchsia
      ParentColor = False
      ParentShowHint = False
      ShowHint = True
      Transparent = True
      Layout = tlCenter
      OnMouseDown = FormMouseDown
      ExplicitLeft = 22
      ExplicitTop = 8
      ExplicitWidth = 31
      ExplicitHeight = 13
    end
    object TypeListComboBox: TComboBox
      Left = 1
      Top = 1
      Width = 78
      Height = 21
      Cursor = crArrow
      Align = alClient
      AutoComplete = False
      AutoDropDown = True
      BevelInner = bvNone
      BevelOuter = bvNone
      Style = csDropDownList
      Color = clSilver
      DoubleBuffered = False
      ItemHeight = 13
      ItemIndex = 0
      ParentDoubleBuffered = False
      TabOrder = 0
      Text = 'images'
      OnChange = TypeListComboBoxChange
      Items.Strings = (
        'images'
        'archives')
    end
  end
  object PosCountImagesPanel: TPanel
    Tag = 7
    Left = 48
    Top = 152
    Width = 73
    Height = 25
    Cursor = crArrow
    Color = clSkyBlue
    TabOrder = 9
    object CountPosImage: TImage
      Left = 1
      Top = 1
      Width = 71
      Height = 23
      Align = alClient
      Stretch = True
      ExplicitLeft = 16
      ExplicitTop = -12
      ExplicitWidth = 37
      ExplicitHeight = 33
    end
    object CountPosLabel: TLabel
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 65
      Height = 17
      Cursor = crArrow
      Align = alClient
      Alignment = taCenter
      AutoSize = False
      Caption = '0/0'
      Color = clFuchsia
      ParentColor = False
      Transparent = True
      Layout = tlCenter
      OnMouseDown = FormMouseDown
      ExplicitLeft = 22
      ExplicitTop = 8
      ExplicitWidth = 31
      ExplicitHeight = 13
    end
  end
  object NextArchiveToolTip: TScreenTipsPopup
    Left = 356
    Top = 64
    Width = 12
    Height = 12
    Associate = NextArchive
    ScreenTip.Header = 'Open next archive to list:'
    ScreenTip.ShowFooter = False
    ScreenTipManager = ToolTipsManager
    Transparent = False
    Visible = False
  end
  object PrevArchiveToolTip: TScreenTipsPopup
    Left = 356
    Top = 64
    Width = 12
    Height = 12
    Associate = PrevArchive
    ScreenTip.Description.Strings = (
      'dsafasdfasdfasdfasdfadsfasdfasdfasd'
      'fa'
      'sdf'
      'as'
      'df'
      'asd'
      'f'
      'asdf'
      'a'
      'sdf'
      'a'
      'sdf')
    ScreenTip.Header = 'Open previous archive to list:'
    ScreenTip.ShowFooter = False
    ScreenTipManager = ToolTipsManager
    Transparent = False
    Visible = False
  end
  object MenuActionsToolTip: TScreenTipsPopup
    Left = 356
    Top = 64
    Width = 12
    Height = 12
    Associate = RotateSaveLabel
    ScreenTip.Description.Strings = (
      
        'Click right mouse button to open menu actions, or and change to ' +
        'menu action and click there with action execute')
    ScreenTip.Header = 'Actions Menu'
    ScreenTip.ShowFooter = False
    ScreenTipManager = ToolTipsManager
  end
  object NavigateStartToolTip: TScreenTipsPopup
    Left = 600
    Top = 72
    Width = 12
    Height = 12
    Associate = LeftImage
    ScreenTip.Description.Strings = (
      'Goto start image to list')
    ScreenTip.ShowFooter = False
    ScreenTipManager = ToolTipsManager
  end
  object NavigateEndToolTip: TScreenTipsPopup
    Left = 600
    Top = 54
    Width = 12
    Height = 12
    Associate = RightImage
    ScreenTip.Description.Strings = (
      'Goto end image to list')
    ScreenTip.ShowFooter = False
    ScreenTipManager = ToolTipsManager
  end
  object NavigatePrevToolTip: TScreenTipsPopup
    Left = 600
    Top = 72
    Width = 12
    Height = 12
    Associate = UpImage
    ScreenTip.Description.Strings = (
      'Goto previous image to list')
    ScreenTip.ShowFooter = False
    ScreenTipManager = ToolTipsManager
  end
  object NavigateNextToolTip: TScreenTipsPopup
    Left = 600
    Top = 54
    Width = 12
    Height = 12
    Associate = DownImage
    ScreenTip.Header = 'Goto next image to list'
    ScreenTip.ShowFooter = False
    ScreenTipManager = ToolTipsManager
  end
  object ActiveScrollTip: TScreenTipsPopup
    Left = 600
    Top = 56
    Width = 12
    Height = 12
    Associate = ActiveScrollLabel
    ScreenTip.Description.Strings = (
      'Change mode active scrolling to press get button')
    ScreenTip.Header = 'Active Scroll'
    ScreenTip.ShowFooter = False
    ScreenTipManager = ToolTipsManager
  end
  object CenterPanelToolTip: TScreenTipsPopup
    Left = 600
    Top = 64
    Width = 12
    Height = 12
    Associate = DragPanel
    ScreenTip.Description.Strings = (
      'With moving navigator left and hold left button and moving mouse')
    ScreenTip.Header = 'Moving'
    ScreenTip.ShowFooter = False
    ScreenTipManager = ToolTipsManager
  end
  object NavigateArcStart: TScreenTipsPopup
    Left = 356
    Top = 82
    Width = 12
    Height = 12
    Associate = DownArchiveNavigation
    ScreenTip.Description.Strings = (
      'Open start archive to get list')
    ScreenTip.Header = 'Archive Start'
    ScreenTipManager = ToolTipsManager
  end
  object NavigateArcEnd: TScreenTipsPopup
    Left = 356
    Top = 100
    Width = 12
    Height = 12
    Associate = UpArchiveNavigation
    ScreenTip.Description.Strings = (
      'Open end archive to get list')
    ScreenTip.Header = 'Archive End'
    ScreenTipManager = ToolTipsManager
  end
  object ListElementsTrackBar: TTrackBar
    Left = 152
    Top = 185
    Width = 104
    Height = 22
    Cursor = crArrow
    DoubleBuffered = True
    Max = 0
    ParentDoubleBuffered = False
    ParentShowHint = False
    ShowHint = False
    ShowSelRange = False
    TabOrder = 21
    ThumbLength = 18
    TickStyle = tsNone
    OnChange = ListElementsTrackBarChange
  end
  object TrackBarHelpTooltip: TScreenTipsPopup
    Left = 500
    Top = 128
    Width = 188
    Height = 13
    Associate = ListElementsTrackBar
    PopupType = ptCustom
    ScreenTip.ShowFooter = False
    ScreenTipManager = ToolTipsManager
  end
  object RightDownPanelHider: TPanel
    Left = 172
    Top = 116
    Width = 16
    Height = 16
    BevelOuter = bvNone
    Caption = 'RD'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 23
    OnClick = RightDownPanelHiderClick
    object ImageRightDown: TImage
      Left = 0
      Top = 0
      Width = 16
      Height = 16
      Cursor = crArrow
      Align = alClient
      OnClick = RightDownPanelHiderClick
      ExplicitHeight = 17
    end
  end
  object LeftDownPanelHider: TPanel
    Left = 118
    Top = 116
    Width = 16
    Height = 16
    BevelOuter = bvNone
    Caption = 'LD'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 24
    OnClick = LeftDownPanelHiderClick
    object ImageLeftDownHide: TImage
      Left = 0
      Top = 0
      Width = 16
      Height = 16
      Cursor = crArrow
      Align = alClient
      OnClick = LeftDownPanelHiderClick
      ExplicitWidth = 21
    end
  end
  object LeftUpPanelHider: TPanel
    Left = 118
    Top = 63
    Width = 16
    Height = 16
    BevelOuter = bvNone
    Caption = 'LU'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 25
    OnClick = LeftUpPanelHiderClick
    object ImageLeftUpHide: TImage
      Left = 0
      Top = 0
      Width = 16
      Height = 16
      Cursor = crArrow
      Align = alClient
      OnClick = LeftUpPanelHiderClick
      ExplicitLeft = 8
      ExplicitTop = 8
      ExplicitWidth = 105
      ExplicitHeight = 105
    end
  end
  object RightUpPanelHider: TPanel
    Left = 172
    Top = 63
    Width = 16
    Height = 16
    BevelOuter = bvNone
    Caption = 'RU'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 26
    OnClick = RightUpPanelHiderClick
    object ImageRightUpHide: TImage
      Left = 0
      Top = 0
      Width = 16
      Height = 16
      Cursor = crArrow
      Align = alClient
      OnClick = RightUpPanelHiderClick
      ExplicitLeft = 8
      ExplicitTop = 8
      ExplicitWidth = 105
      ExplicitHeight = 105
    end
  end
  object LeftUpPanelHide: TScreenTipsPopup
    Left = 356
    Top = 118
    Width = 12
    Height = 12
    Associate = LeftUpPanelHider
    ScreenTip.ShowFooter = False
    ScreenTipManager = ToolTipsManager
    Visible = False
  end
  object LeftDownPanelHide: TScreenTipsPopup
    Left = 364
    Top = 126
    Width = 12
    Height = 12
    Associate = LeftDownPanelHider
    ScreenTip.ShowFooter = False
    ScreenTipManager = ToolTipsManager
    Visible = False
  end
  object RightUpPanelHide: TScreenTipsPopup
    Left = 364
    Top = 144
    Width = 12
    Height = 12
    Associate = RightUpPanelHider
    ScreenTip.ShowFooter = False
    ScreenTipManager = ToolTipsManager
    Visible = False
  end
  object RightDownPanelHide: TScreenTipsPopup
    Left = 323
    Top = 118
    Width = 12
    Height = 12
    Associate = RightDownPanelHider
    ScreenTip.ShowFooter = False
    ScreenTipManager = ToolTipsManager
    Visible = False
  end
  object DownPanelPanel: TPanel
    Left = 47
    Top = 178
    Width = 74
    Height = 13
    TabOrder = 31
    object DownNavigationImage: TImage
      Left = 0
      Top = 0
      Width = 74
      Height = 13
      Cursor = crArrow
      OnMouseDown = DownNavigationImageMouseDown
      OnMouseUp = DownNavigationImageMouseUp
    end
  end
  object UpPanelPanel: TPanel
    Left = 47
    Top = 138
    Width = 74
    Height = 13
    TabOrder = 32
    object UpNavigationImage: TImage
      Left = 0
      Top = 0
      Width = 74
      Height = 13
      Cursor = crArrow
      OnMouseDown = UpNavigationImageMouseDown
      OnMouseUp = DownNavigationImageMouseUp
    end
  end
  object UpArcPanelPanel: TPanel
    Left = 183
    Top = 2
    Width = 74
    Height = 13
    TabOrder = 33
    object UpArchiveNavigation: TImage
      Left = 0
      Top = 0
      Width = 74
      Height = 13
      Cursor = crArrow
      OnClick = UpArchiveNavigationClick
      OnMouseDown = PrevArchiveMouseDown
      OnMouseUp = DownNavigationImageMouseUp
    end
  end
  object DownArcPanelPanel: TPanel
    Left = 183
    Top = 42
    Width = 74
    Height = 13
    TabOrder = 34
    object DownArchiveNavigation: TImage
      Left = 0
      Top = 0
      Width = 74
      Height = 13
      Cursor = crArrow
      OnClick = DownArchiveNavigationClick
      OnMouseDown = PrevArchiveMouseDown
      OnMouseUp = DownNavigationImageMouseUp
    end
  end
  object PanelNumberPages: TPanel
    Left = 190
    Top = 141
    Width = 65
    Height = 18
    Cursor = crArrow
    Color = clFuchsia
    ParentBackground = False
    TabOrder = 35
    object ImageBackgroundCountPages: TImage
      Left = 1
      Top = 1
      Width = 63
      Height = 16
      Cursor = crArrow
      Align = alClient
      Stretch = True
      Transparent = True
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 177
      ExplicitHeight = 41
    end
    object GetPosListElementsLabel: TLabel
      Left = 1
      Top = 2
      Width = 27
      Height = 13
      Cursor = crArrow
      Alignment = taCenter
      AutoSize = False
      Caption = '0'
      ParentShowHint = False
      ShowHint = True
      Transparent = True
      OnMouseDown = FormMouseDown
    end
    object CountListElementsLabel: TLabel
      Left = 34
      Top = 2
      Width = 27
      Height = 13
      Cursor = crArrow
      Alignment = taCenter
      AutoSize = False
      BiDiMode = bdLeftToRight
      Caption = '0'
      ParentBiDiMode = False
      ParentShowHint = False
      ShowHint = True
      Transparent = True
      OnMouseDown = FormMouseDown
    end
  end
  object UpdateTimer: TTimer
    Enabled = False
    Interval = 50
    OnTimer = UpdateTimerTimer
    Left = 8
    Top = 72
  end
  object ToolTipsManager: TScreenTipsManager
    FooterImage.Data = {
      07544269746D61709E020000424D9E0200000000000036000000280000000E00
      00000E000000010018000000000068020000C40E0000C40E0000000000000000
      0000FF0099FF0099FF0099B8B8B8DADADABDAFAAC7ACA2C9AEA3C1B3ADE7E7E7
      CFCFCFFF0099FF0099FF00990000FF0099FF0099C7C7C7BDA49BA65336B85029
      BC532AC1572BC55A2CB86039CBB0A4D9D9D9FF0099FF00990000FF0099C7C7C7
      9D6B5CAE4927B24C28BC6241DCBCAFDDAF9CC2582BC5592CC4592BB37E68D9D9
      D9FF00990000C7C7C7B9A099A84426AC4727B14B28C18E7CCFCFCFE3E3E3BF55
      2AC0562BC0562BBE552AC8AEA4CFCFCF0000DCDCDCA4543AA84627AA4626AE49
      27B25231B5826FC4836BBA522ABB532ABB532ABA5229AA5636E7E7E70000BEB1
      ADB0502FB65631A84426AB4727AD5B3FA8A8A8AB9188B64F29B75029B64F29B5
      4E29B34D28BFB1AC0000C2ABA3B35633BD6138B85932A84426AB4727A2A2A2A7
      A7A7AE5C3FB24C28B24C28B14B28AF4A27C4ABA20000C8B2AAB55B37BD643BC2
      693CBE6338AF4E2CA66855A8A8A8A9A3A1B3684EAD4827AC4827AB4726C2A9A1
      0000CFC6C2B96744BC673EC06A3EC26B3EC46C3DBF6538BF907CC7C7C7CFC2BE
      AA4727AE4B29AC4929BCAFAB0000EBEBEBC89780BB6A42BE6C41C98B6ADCC1B2
      CF9474DBBAA9E8E8E8EEEEEEC06137BA5932A6553BDBDBDB0000B8B8B8EBE3E0
      C2805DBB6F45CA8F6FF4F4F4F5F5F5F5F5F5F6F6F6E5C9BCBB5E37B25230C0A7
      A0C7C7C70000FF0099CECECEDBCAC1C2835FBE7952D8AE96E9D1C4EEDACFD9AA
      93BF6C47B45936A37465C7C7C7FF00990000FF0099FF0099DCDCDCEBE4E1C9A0
      87BC7751B96F46BA6C44B96740B06B4DC1AAA2C7C7C7FF0099FF00990000FF00
      99FF0099FF0099D6D6D6ECECECD3CCC8D1BFB5CEBBB2C9BFBADEDEDEB8B8B8FF
      0099FF0099FF00990000}
    Left = 248
    Top = 64
  end
  object UpdateShowTimer: TTimer
    Interval = 300
    OnTimer = UpdateShowTimerTimer
    Left = 24
    Top = 128
  end
end
