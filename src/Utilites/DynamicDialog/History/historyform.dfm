object HistoryDialog: THistoryDialog
  Left = 0
  Top = 0
  Cursor = crArrow
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'History Dialog'
  ClientHeight = 503
  ClientWidth = 687
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object DateTimeLabel: TLabel
    Left = 8
    Top = 431
    Width = 436
    Height = 13
    Cursor = crArrow
    AutoSize = False
  end
  object ErrorLabel: TLabel
    Left = 8
    Top = 456
    Width = 425
    Height = 13
    Cursor = crArrow
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object SpeedButton_Help: TSpeedButton
    Left = 642
    Top = 450
    Width = 37
    Height = 37
    OnClick = SpeedButton_HelpClick
  end
  object MainTabs: TPageControl
    Left = -2
    Top = 0
    Width = 681
    Height = 425
    Cursor = crArrow
    ActivePage = ArcTab
    TabOrder = 0
    OnChange = MainTabsChange
    object ArcTab: TTabSheet
      Cursor = crArrow
      Caption = 'Archive History'
      object LabelOrderDate: TLabel
        Left = 3
        Top = 7
        Width = 151
        Height = 16
        Cursor = crArrow
        AutoSize = False
        Caption = 'Sorting'
      end
      object ArchiveListBox: TListBox
        Left = 0
        Top = 29
        Width = 417
        Height = 350
        Cursor = crArrow
        ItemHeight = 13
        TabOrder = 0
        OnClick = ArchiveListBoxClick
      end
      object ImageView: TImageEnView
        Left = 423
        Top = 0
        Width = 246
        Height = 394
        Cursor = crArrow
        ParentCtl3D = False
        ZoomFilter = rfLanczos3
        AutoFit = True
        ImageEnVersion = '3.1.2'
        EnableInteractionHints = True
        TabOrder = 1
      end
      object ComboOrderDate: TComboBox
        Left = 160
        Top = 3
        Width = 257
        Height = 21
        Cursor = crArrow
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 2
        Text = 'DescWithDate'
        OnChange = ComboOrderDateChange
        Items.Strings = (
          'DescWithDate'
          'AscWithDate'
          'DescWitnName'
          'AscWithName')
      end
      object TabSetArhives: TTabSet
        Left = 0
        Top = 379
        Width = 417
        Height = 22
        Cursor = crArrow
        AutoScroll = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        SoftTop = True
        Style = tsSoftTabs
        Tabs.Strings = (
          'All'
          'Today'
          'Weekly'
          'Mounth')
        TabIndex = 0
        OnChange = TabSetArhivesChange
      end
    end
    object DirTab: TTabSheet
      Cursor = crArrow
      Caption = 'Dir History'
      ImageIndex = 1
      object DirListBox: TListBox
        Left = 0
        Top = 0
        Width = 417
        Height = 401
        Cursor = crArrow
        ItemHeight = 13
        TabOrder = 0
        OnClick = DirListBoxClick
      end
      object TreeView: TShellTreeView
        Left = 416
        Top = 0
        Width = 254
        Height = 401
        Cursor = crArrow
        ObjectTypes = [otNonFolders, otHidden]
        Root = 'rfDesktop'
        UseShellImages = True
        AutoRefresh = False
        Indent = 19
        ParentColor = False
        RightClickSelect = True
        ShowButtons = False
        ShowLines = False
        ShowRoot = False
        TabOrder = 1
      end
    end
    object BookmarkTab: TTabSheet
      Cursor = crArrow
      Caption = 'Bookmarks'
      ImageIndex = 2
      object LabelBookmarkSorting: TLabel
        Left = 3
        Top = 6
        Width = 167
        Height = 13
        Cursor = crArrow
        AutoSize = False
        Caption = 'Sorting'
      end
      object BookmarksListBox: TListBox
        Left = 0
        Top = 29
        Width = 417
        Height = 365
        Cursor = crArrow
        ItemHeight = 13
        TabOrder = 0
        OnClick = BookmarksListBoxClick
      end
      object ImageBookmarks: TImageEnView
        Left = 423
        Top = 0
        Width = 247
        Height = 394
        Cursor = crArrow
        ParentCtl3D = False
        ZoomFilter = rfLanczos3
        SelectionOptions = [iesoMoveable]
        MouseInteract = [miScroll]
        AutoFit = True
        ImageEnVersion = '3.1.2'
        EnableInteractionHints = True
        TabOrder = 1
      end
      object ComboBoxBookmarkSorting: TComboBox
        Left = 176
        Top = 3
        Width = 241
        Height = 21
        Cursor = crArrow
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 2
        Text = 'DateDesc'
        OnClick = ComboBoxBookmarkSortingClick
        Items.Strings = (
          'DateDesc'
          'DateAsc'
          'NameDesc'
          'NameAsc')
      end
    end
  end
  object ButtonOpen: TButton
    Left = 450
    Top = 431
    Width = 95
    Height = 25
    Cursor = crArrow
    Caption = 'Open'
    ModalResult = 1
    TabOrder = 1
  end
  object ButtonCancel: TButton
    Left = 450
    Top = 462
    Width = 95
    Height = 25
    Cursor = crArrow
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
