#include "hbqtgui.ch"

PROCEDURE TINCreate ( oWnd, tFileName)

   LOCAL oMB, otMessage, nF_Error, otDetail, oFileDialog, nRecCnt, cRecOut, cRecError

   LOCAL oFileOutName, nFhndl, cLastName

   LOCAL oBtnOk, oBtnQuit

   nF_Error         := 0
   nRecCnt          := 0
   nFhndl           := 0
   otMessage        := " "
   otDetail         := " "
   cRecOut          := " "

   oMB := QMessageBox(oWnd)
   oMB:Icon(QMessageBox_Information)
   oMB:setStandardButtons( QMessageBox_Ok )
   oMB:setDefaultButton( QMessageBox_Ok )
   oMB:resize( 250, 300 )

   oFileOutName := "c:\temp\IRS_TIN_MATCHING_FILE_" + DToC( Date() ) + ".CSV"
   
   nFhndl := FCreate(oFileOutName)

   nF_Error = FError()
   
   if nF_Error <> 0
      otMessage := "Error opening file "
      otDetail  := "File Name " + oFileOutName + ", error code (" + hb_ntos(nF_Error ) + ")"
      oMB:setWindowTitle( "File Open Error" )
      oMB:setInformativeText(otMessage)
      oMB:setDetailedText(otDetail)
      oMB:exec(oWnd)
      quit
   else
      tFilename:SetText ( oFileOutName )
   end-if
   
   use payee index payee

   do while .not. eof()
      nRecCnt += 1
      cLastName = ltrim(payee->last_name)
      cLastName = strtran(cLastName,"'")
      cLastName = strtran(cLastName,".")
      cLastName = rtrim(cLastName)
      cRecOut    =  '2;' + payee->record_id + ';' + cLastName + ';' + CHR(13) + CHR (10)
      FWrite (nfhndl,cRecOut)

      nF_Error = FError()

      if nF_Error <> 0
         otMessage := "Error writing file "
         otDetail  := "File Name " + oFileOutName + ", error code (" + hb_ntos(nF_Error ) + ")"
         oMB:setWindowTitle( "File Write Error" )
         oMB:setInformativeText(otMessage)
         oMB:setDetailedText(otDetail)
         oMB:exec(oWnd)
         quit
      end-if
   
      skip
   enddo

 FClose( oFileOutName )
 nF_Error = FError()

 if nF_Error <> 0
    otMessage := "Error closing file "
    otDetail  := "File Name " + oFileOutName + ", error code (" + hb_ntos(nF_Error ) + ")"
    oMB:setWindowTitle( "File Open Error" )
    oMB:setInformativeText(otMessage)
    oMB:setDetailedText(otDetail)
    oMB:exec(oWnd)
    quit
 end-if
   
 otMessage := "File Create Processing Complete"
 otDetail  := "Record Count: " + Chr(9)  + hb_ntos(nRecCnt )
 oMB:setWindowTitle( "File Processing Complete" )
 oMB:setInformativeText(otMessage)
 oMB:setDetailedText(otDetail)

 oMB:exec(oWnd)

 RETURN