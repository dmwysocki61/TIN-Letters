#include "hbqtgui.ch"

PROCEDURE Main()
   LOCAL oBtnOk, oBtnQuit, oBtnTIN
   LOCAL oDate, oSBar
   LOCAL oLabel1, olFileName
   LOCAL otFileName, oRect1, oRect2, oRect3
   local oFileDialog
   public oWnd
   
   // HBQT_ERRORSYS()
   // REQUEST DBFCDX
   // REQUEST HB_GT_WIN_DEFAULT
   set(_SET_DEBUG,.T.)
   set century on
   set date ansi
   
   oWnd := QMainWindow()
   oWnd:setWindowTitle( "Create TIN Matching file or TIN Letters Merge File" )
   oWnd:resize( 525, 400 )

   oLabel1 := QLabel( oWnd )
   oLabel1:resize( 250, 70 )
   oLabel1:move( 142, 15 )

   oLabel1:setText( "<font color=black size=4>" + "Click Button to create TIN file or Merge File" + "</font>" )

   // oDate := QCalendarWidget( oWnd )
   // oDate:resize( 400, 275 )
   // oDate:move( 50, 50 )
   // oDate:setFirstDayOfWeek( 1 )
   // oDate:setGridVisible( .T. )

   oRect1             := QRect()

   olFileName         := QLabel ( oWnd )
   otFileName         := QLineEdit ( oWnd )
   olFileName:SetText ( "File Name" )
   otFileName:SetText ( "" )
   olFileName:resize  ( 100, 20 )
   otFileName:resize  ( 300, 20 )
   olFileName:move    ( 50, 100 )
   otFileName:move    ( 200, 100 )
   otFileName:setAlignment  ( Qt_AlignLeft  )
   otFileName:setEnabled(.F.)

   oBtnTIN := QPushButton( oWnd )
   oBtnTIN:setText( "Create TIN Matching File" )
   oBtnTIN:resize (200,50)
   oBtnTIN:move( 50, 150 )
   oBtnTIN:Connect( "clicked()", {|| tincreate ( oWnd, otFileName) } )

   oBtnOk := QPushButton( oWnd )
   oBtnOk:setText( "Process TIN Results - Create Merge File" )
   oBtnOk:resize (200, 50)
   oBtnOk:move( 50, 225 )
   oBtnOk:Connect( "clicked()", {|| fileopen ( oWnd, otFileName) } )

   oBtnQuit := QPushButton( oWnd )
   oBtnQuit:setText( "Quit" )
   oBtnQuit:resize(200, 50)
   oBtnQuit:move( 50, 300 )
   oBtnQuit:Connect( "clicked()", {|| appquit () } )

   oSBar := QStatusBar( oWnd )
   oWnd:setStatusBar( oSBar )

   oSBar:showMessage( "Ready!" )

   oWnd:show()
   QApplication():exec(oWnd)

   RETURN

PROCEDURE appquit  (oWnd)
   hb_gcAll(oWnd)
   QApplication():quit(oWnd)
   RETURN