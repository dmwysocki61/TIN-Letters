#include "hbqtgui.ch"
#include "fileio.ch"


PROCEDURE fileopen ( oWnd, tFileName)

   LOCAL cListOfFiles, nReturned, oMB, otMessage, nF_Error, otDetail, otFileName, oFileDialog, nRecCnt, cRecIn, cRecError, nTokens

   LOCAL cRecId, oFileOutName,nFhndl, nFhndl_In, cFirstName, cLastName, cAddress, cCity, cState, cPostal, cRecOut, cMsg, nEOF
   
   LOCAL aArrayIn := Array(4)
   LOCAL oBtnOk, oBtnQuit, oQDate

   nReturned        := 0
   nF_Error         := 0
   nRecCnt          := 0
   nTokens          := 0
   nFhndl           := 0
   nFhndl_In        := 0
   nEOF             := 0
   otMessage        := " "
   otDetail         := " "
   cRecIn           := " "
   cRecError        := " "
   cRecId           := " "
   cFirstName       := " "
   cLastName        := " "
   cAddress         := " "
   cCity            := " "
   cState           := " "
   cPostal          := " "
   cRecOut          := " "
   cMsg             := " "

   oMB := QMessageBox(oWnd)
   oMB:Icon(QMessageBox_Information)
   oMB:setStandardButtons( QMessageBox_Ok )
   oMB:setDefaultButton( QMessageBox_Ok )
   oMB:resize( 250, 300 )

   oFileOutName := "c:\temp\TIN_LETTERS_MERGE_FILE_" + DToC( Date() ) + ".CSV"
   nFhndl := FCreate(oFileOutName)
   nF_Error = FError()
   
   if nF_Error <> 0
      nF_Error := ft_FError()
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
   
   cRecOut := 'FIRST_NAME,LAST_NAME,ADDRESS,CITY,STATE,POSTAL,MESSAGE' + CHR(13) + CHR (10)
   
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
   
   oFileDialog := QFileDialog(oWnd)
   oFileDialog:SetDirectory ( "c:\temp" )
   oFileDialog:setNameFilter( "*.txt" )
   oFileDialog:setViewMode( QFileDialog_Detail )
   oFileDialog:setOption( QFileDialog_DontUseNativeDialog)

   oFileDialog:exec(oWnd)

   cListOfFiles := oFileDialog:selectedFiles()
   otFileName := cListOfFiles:At( 0 )

   //__hbqt_destroy( oFileDialog )
   nFhndl_In := FOpen ( otFileName)
   
   IF ( nFhndl_In == -1)      // open text file
      nF_Error  := FError()
      otMessage := "Error opening file "
      otDetail  := "File Name " + otFileName + ", error code (" + hb_ntos(nF_Error ) + ")"
      oMB:setWindowTitle( "File Open Error" )
      oMB:setInformativeText(otMessage)
      oMB:setDetailedText(otDetail)
      oMB:exec(oWnd)
   END-IF

   select 1
   
   use payee index payee
   nEOF := 0
   nEOF := hb_FReadLine(nFhndl_In, @cRecIn, Chr(10))
   DO WHILE (nEOF == 0)
      nRecCnt += 1
      cMsg   := ' '
      

      nTokens := NumToken(cRecIn,';')

      // if nTokens == 3
         aArrayIn := hb_atokens(cRecIn,';')
         if aArrayIn[4] <> '0'
            cRecId := aArrayIn[2]
            dbseek (cRecId)
            if found()
               cLastName  := rtrim(ltrim(payee->last_name))
               cFirstName := rtrim(ltrim(payee->first_name))
               cAddress   := rtrim(ltrim(payee->address))
               cCity      := rtrim(ltrim(payee->city))
               cAddress   := strtran(cAddress,","," ")
               cCity      := strtran(cCity,","," ")
               cState     := rtrim(ltrim(payee->state))
               cPostal    := rtrim(ltrim(payee->zip))
               if aArrayIn[4] == '2'
                  cmsg    := 'Social Security Number invalid. SSN not currently issued.'
               end-if
               if aArrayIn[4] == '3'
                  cmsg    := 'Social Security Number and do not match IRS records.'
               end-if
               cRecOut    := cFirstName + ',' + ;
                             cLastName  + ',' + ;
                             cAddress   + ',' + ;
                             cCity      + ',' + ;
                             cState     + ',' + ;
                             cPostal    + ',' + ;
                             cMsg       + CHR(13) + CHR (10)
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
            else
               otMessage := "Error processing record: " + hb_ntos(nRecCnt)
               otDetail  := "TIN not found in Payee database: " + cRecId
               oMB:setWindowTitle( "Processing Error. Press Ok to Continue." )
               oMB:setInformativeText(otMessage)
               oMB:setDetailedText(otDetail)
               oMB:exec()
            end-if
         end-if   
      //else
      //   otMessage := "Error processing record: " + hb_ntos(nRecCnt)
      //   otDetail  := "Incorrect file format. Number of ; delimiters must be 3. Found: " + hb_ntos(nTokens)
      //   oMB:setWindowTitle( "File Processing Error" )
      //   oMB:setInformativeText(otMessage)
      //   oMB:setDetailedText(otDetail)
      //   oMB:exec()
      //   cRecError := .T.
      //   break
      //end-if
      nEOF := hb_FReadLine(nFhndl_In, @cRecIn, Chr(10))
   END-WHILE
   ft_DFClose( otFileName  )
   
   otMessage := "File Processing Complete"
   otDetail  := "Record Count: " + Chr(9)  + hb_ntos(nRecCnt )
   oMB:setWindowTitle( "File Processing Complete" )
   oMB:setInformativeText(otMessage)
   oMB:setDetailedText(otDetail)

   oMB:exec(oWnd)

   RETURN