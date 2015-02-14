object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'drComRead'
  ClientHeight = 414
  ClientWidth = 525
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  PopupMenu = PopupMenu
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnClick = FormClick
  OnClose = FormClose
  OnContextPopup = FormContextPopup
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnMouseMove = MainImageMouseMove
  OnMouseWheel = FormMouseWheel
  OnPaint = FormPaint
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object MainImage: TImageEnView
    Left = 0
    Top = 0
    Width = 525
    Height = 414
    ParentCtl3D = False
    BorderStyle = bsNone
    ZoomFilter = rfHermite
    ScrollBars = ssNone
    MouseInteract = [miScroll]
    ImageEnVersion = '3.1.2'
    WallPaperStyle = iewoTile
    OnMouseWheel = FormMouseWheel
    EnableInteractionHints = True
    Align = alClient
    TabOrder = 0
    OnClick = FormClick
    OnDblClick = MainImageDblClick
    OnMouseDown = MainImageMouseDown
    OnMouseMove = MainImageMouseMove
    OnMouseUp = MainImageMouseUp
    object InfoMainForm: TLabel
      Left = 3
      Top = 142
      Width = 6
      Height = 83
      Alignment = taCenter
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      Visible = False
    end
    object NumberNextImage: TLabel
      Left = 0
      Top = 395
      Width = 525
      Height = 19
      Align = alBottom
      Alignment = taRightJustify
      Caption = 'NumberNextImage'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = False
      Layout = tlCenter
      Visible = False
      WordWrap = True
      ExplicitLeft = 370
      ExplicitWidth = 155
    end
    object LoadingImageView: TImageEnMView
      Left = 200
      Top = 142
      Width = 102
      Height = 99
      ParentCtl3D = False
      BorderStyle = bsNone
      ScrollBars = ssNone
      MouseInteract = []
      KeyInteract = []
      DisplayMode = mdSingle
      ThumbnailsBorderColor = clBlack
      ImageEnVersion = '3.1.2'
      Visible = False
      TabOrder = 0
    end
    object PagingAnimPanel: TPanel
      Left = 0
      Top = 0
      Width = 100
      Height = 132
      TabOrder = 1
      Visible = False
      object LeftTopLabel: TLabel
        Left = 0
        Top = 106
        Width = 100
        Height = 24
        Alignment = taCenter
        AutoSize = False
        Caption = '0'
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Transparent = True
        OnClick = LeftTopImageClick
      end
      object LeftTopImage: TImageEnMView
        Left = 0
        Top = 0
        Width = 100
        Height = 100
        ParentCtl3D = False
        BorderStyle = bsNone
        ScrollBars = ssNone
        MouseInteract = []
        KeyInteract = []
        ThumbnailsBorderColor = clBlack
        ImageEnVersion = '3.1.2'
        TabOrder = 0
        OnClick = LeftTopImageClick
      end
    end
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 352
    Top = 80
    object Menu_OpenDir: TMenuItem
      Caption = 'Open Dir'
      ShortCut = 16452
      OnClick = Menu_OpenDirClick
    end
    object Menu_OpenFile: TMenuItem
      Caption = 'Open File'
      ShortCut = 16463
      OnClick = Menu_OpenFileClick
    end
    object Menu_CloseCurrent: TMenuItem
      Caption = 'Close'
      ShortCut = 16472
      OnClick = Menu_CloseCurrentClick
    end
    object Menu_CloseAll: TMenuItem
      Caption = 'CloseAll'
      ShortCut = 24664
      OnClick = Menu_CloseAllClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Menu_Navigate: TMenuItem
      Caption = 'Navigate'
      object Menu_NextImage: TMenuItem
        Caption = 'Next Image'
        ShortCut = 78
        OnClick = Menu_NextImageClick
      end
      object Menu_PrevImage: TMenuItem
        Caption = 'Prev Image'
        ShortCut = 80
        OnClick = Menu_PrevImageClick
      end
      object Menu_StartImage: TMenuItem
        Caption = 'Start Image'
        ShortCut = 83
        OnClick = Menu_StartImageClick
      end
      object Menu_EndImage: TMenuItem
        Caption = 'End Image'
        ShortCut = 69
        OnClick = Menu_EndImageClick
      end
      object Menu_NextArchive: TMenuItem
        Caption = 'Next Archive'
        ShortCut = 16462
        OnClick = Menu_NextArchiveClick
      end
      object Menu_PrevArchive: TMenuItem
        Caption = 'Prev Archive'
        ShortCut = 16464
        OnClick = Menu_PrevArchiveClick
      end
      object Menu_StartArchive: TMenuItem
        Caption = 'Start Archive'
        ShortCut = 16467
        OnClick = Menu_StartArchiveClick
      end
      object Menu_EndArchive: TMenuItem
        Caption = 'End Archive'
        ShortCut = 16453
        OnClick = Menu_EndArchiveClick
      end
    end
    object Menu_WinControl: TMenuItem
      Caption = 'Window Control'
      object Menu_FullScreen: TMenuItem
        Caption = 'FullScreen'
        ShortCut = 32838
        OnClick = Menu_FullScreenClick
      end
      object Menu_SinglePreview: TMenuItem
        Caption = 'Single Preview'
        ShortCut = 116
        OnClick = Menu_SinglePreviewClick
      end
      object Menu_Minimize: TMenuItem
        Caption = 'Minimize'
        ShortCut = 32845
        OnClick = Menu_MinimizeClick
      end
      object Menu_Navigator: TMenuItem
        Caption = 'Navigator'
        ShortCut = 117
        OnClick = Menu_NavigatorClick
      end
      object Menu_Mouser: TMenuItem
        Caption = 'Mouser'
        Visible = False
        OnClick = Menu_MouserClick
      end
    end
    object Menu_ImageControl: TMenuItem
      Caption = 'Image Control'
      object Menu_Zoom: TMenuItem
        Caption = 'Zoom'
        ShortCut = 8282
        OnClick = Menu_ZoomClick
      end
      object Menu_Stretch: TMenuItem
        Caption = 'Fit_Width'
        ShortCut = 8275
        OnClick = Menu_StretchClick
      end
      object Menu_Original: TMenuItem
        Caption = 'Original'
        ShortCut = 8271
        OnClick = Menu_OriginalClick
      end
      object Menu_FitHeight: TMenuItem
        Caption = 'Fit_Height'
        ShortCut = 8264
        OnClick = Menu_FitHeightClick
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object Menu_SaveToFile: TMenuItem
        Caption = 'Save To File'
        ShortCut = 24659
        OnClick = Menu_SaveToFileClick
      end
      object Menu_SaveToBuffer: TMenuItem
        Caption = 'Save To Buffer'
        ShortCut = 16451
        OnClick = Menu_SaveToBufferClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object Menu_Rotate: TMenuItem
        Caption = 'Rotate'
        object Menu_Rotate80CW: TMenuItem
          Caption = 'Rotate 80CW'
          OnClick = Menu_Rotate80CWClick
        end
        object Menu_Rotate80CCW: TMenuItem
          Caption = 'Rotate 80 CCW'
          OnClick = Menu_Rotate80CCWClick
        end
        object Menu_Rotate80CWAll: TMenuItem
          Caption = 'Rotate 80CW All'
          OnClick = Menu_Rotate80CWAllClick
        end
        object Menu_Rotate80CCWAll: TMenuItem
          Caption = 'Rotate 80 CCW All'
          OnClick = Menu_Rotate80CCWAllClick
        end
      end
      object Menu_Flip: TMenuItem
        Caption = 'Flip'
        object Menu_FlipHorizontal: TMenuItem
          Caption = 'Flip Horizontal'
          OnClick = Menu_FlipHorizontalClick
        end
        object Menu_FlipVertical: TMenuItem
          Caption = 'Flip Vertical'
          OnClick = Menu_FlipVerticalClick
        end
        object Menu_FlipHorizontalAll: TMenuItem
          Caption = 'Flip Horizontal All'
          OnClick = Menu_FlipHorizontalAllClick
        end
        object Menu_FlipVerticalAll: TMenuItem
          Caption = 'Flip Vertical All'
          OnClick = Menu_FlipVerticalAllClick
        end
      end
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Menu_ListArchive: TMenuItem
      Caption = 'List archive'
    end
    object Menu_FileManaged: TMenuItem
      Caption = 'File Managed'
      object Menu_ArchiveList: TMenuItem
        Caption = 'Archive dialog'
        ShortCut = 16449
        OnClick = Menu_ArchiveListClick
      end
      object Menu_SortFiles: TMenuItem
        Caption = 'Sort Files'
        ShortCut = 16454
        OnClick = Menu_SortFilesClick
      end
      object Menu_FileInfo: TMenuItem
        Caption = 'File Info'
        ShortCut = 16457
        OnClick = Menu_FileInfoClick
      end
      object Menu_HistoryDialog: TMenuItem
        Caption = 'History dialog'
        ShortCut = 16456
        OnClick = Menu_HistoryDialogClick
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object Menu_CreateArchive: TMenuItem
        Caption = 'Create Arhive'
        object Menu_CreateRAR: TMenuItem
          Caption = 'Create RAR'
          OnClick = Menu_CreateRARClick
        end
        object Menu_CreateZip: TMenuItem
          Caption = 'Create Zip'
          OnClick = Menu_CreateZipClick
        end
        object Menu_Create7Zip: TMenuItem
          Caption = 'Create 7Zip'
          OnClick = Menu_Create7ZipClick
        end
        object Menu_CreatePDF: TMenuItem
          Caption = 'Create PDF'
          OnClick = Menu_CreatePDFClick
        end
        object Menu_CreateTIFF: TMenuItem
          Caption = 'CreateTIFF'
          OnClick = Menu_CreateTIFFClick
        end
        object Menu_CreateGIF: TMenuItem
          Caption = 'Create GIF'
          OnClick = Menu_CreateGIFClick
        end
      end
      object Menu_RecreateArchive: TMenuItem
        Caption = 'Recreate Archive'
        object Menu_Recreateandrewrite: TMenuItem
          Caption = 'Recreate and rewrite'
          OnClick = Menu_RecreateandrewriteClick
        end
        object Menu_Recreateandsaveas: TMenuItem
          Caption = 'Recreate and save as'
          OnClick = Menu_RecreateandsaveasClick
        end
      end
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Menu_ArcHistory: TMenuItem
      Caption = 'Archive history'
    end
    object Menu_DirHistory: TMenuItem
      Caption = 'Dir History'
    end
    object Menu_Bookmarks: TMenuItem
      Caption = 'Bookmarks'
      object Menu_NextBookmark: TMenuItem
        Caption = 'NextBookmark'
        ShortCut = 121
        OnClick = Menu_NextBookmarkClick
      end
      object Menu_PrevBookmark: TMenuItem
        Caption = 'PrevBookmark'
        ShortCut = 120
        OnClick = Menu_PrevBookmarkClick
      end
      object Menu_Addbookmark: TMenuItem
        Caption = 'Add bookmark'
        ShortCut = 122
        OnClick = Menu_AddbookmarkClick
      end
      object Menu_ClearBookmarks: TMenuItem
        Caption = 'ClearBookmarks'
        ShortCut = 123
        OnClick = Menu_ClearBookmarksClick
      end
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object Menu_Addons: TMenuItem
      Caption = 'Addons'
      Visible = False
      object Menu_AddonsManage: TMenuItem
        Tag = -1
        Caption = 'Manage'
        Visible = False
      end
    end
    object MenuSeparator50: TMenuItem
      Caption = '-'
      Visible = False
    end
    object Menu_CheckUpdates: TMenuItem
      Caption = 'CheckUpdates'
      OnClick = Menu_CheckUpdatesClick
    end
    object Menu_Documentation: TMenuItem
      Caption = 'Documentation'
      ShortCut = 112
      OnClick = Menu_DocumentationClick
    end
    object Menu_About: TMenuItem
      Caption = 'About'
      ShortCut = 16496
      OnClick = Menu_AboutClick
    end
    object Menu_Exit: TMenuItem
      Caption = 'Exit'
      ShortCut = 32856
      OnClick = Menu_ExitClick
    end
  end
  object ASTimer: TTimer
    Enabled = False
    OnTimer = ASTimerTimer
    Left = 352
    Top = 120
  end
  object CurvesPopUp: TPopupMenu
    Left = 280
    Top = 248
    object Menu_ApplyCurves: TMenuItem
      Caption = 'Apply curves'
      OnClick = Menu_ApplyCurvesClick
    end
    object Menu_ResetCurves: TMenuItem
      Caption = 'ResetPoints'
      OnClick = Menu_ResetCurvesClick
    end
    object Menu_SaveCurves: TMenuItem
      Caption = 'Save as curves'
      OnClick = Menu_SaveCurvesClick
    end
    object Menu_OpenCurves: TMenuItem
      Caption = 'Open curves'
      OnClick = Menu_OpenCurvesClick
    end
    object Menu_OpenDefaultCurves: TMenuItem
      Caption = 'Open default'
      OnClick = Menu_OpenDefaultCurvesClick
    end
  end
end
