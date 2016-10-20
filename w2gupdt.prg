function w2gupdt ()

local   aStru     := {}                    // Create Empty Array
local   aTicket   := {}
local   aRpt0235  := {}
local   aRpt0245  := {}
local   aRpt0270  := {}
local   aRpt0720  := {}
local   aRpt0740  := {}
local   aBatchCtl := {}
local   aTemp     := {}
local   aGauge
local   nStart

setcolor(MAKECOLOR(pWHITE/pBLUE, pBLACK/pWHITE,pRED,, pWHITE/pBLUE) )

cls

aGauge := gaugenew(maxrow()-3, 0, maxrow()-1, maxcol())

dbcloseall()

select 1
use payer

if FieldExists('STATE_TAX') .and. ;
   FieldExists('LASER')
   @ 4,0 say 'Payer Database checked, no modifications necessary.'
else
   aadd( aStru, {"NAME",        "C", 45, 0} )
   aadd( aStru, {"ADDRESS1",    "C", 30, 0} )
   aadd( aStru, {"ADDRESS2",    "C", 30, 0} )
   aadd( aStru, {"CITY",        "C", 30, 0} )
   aadd( aStru, {"STATE",       "C", 02, 0} )
   aadd( aStru, {"ZIP",         "C", 10, 0} )
   aadd( aStru, {"EIN",         "C", 10, 0} )
   aadd( aStru, {"NAME_CNTL",   "C", 04, 0} )
   aadd( aStru, {"TCC",         "C", 05, 0} )
   aadd( aStru, {"STATE_TAX",   "C", 01, 0} )
   aadd( aStru, {"LASER",       "C", 01, 0} )
   dbcreate("PAYER1", aStru)
   if file("PAYER1.DBF")
      select 2
      use payer1
      dbappend()
            replace payer1->name            with payer->name
          replace payer1->address1  with payer->address1
          replace payer1->address2  with payer->address2
          replace payer1->city            with payer->city
          replace payer1->state            with payer->state
          replace payer1->zip            with payer->zip
          replace payer1->ein            with payer->ein
          replace payer1->name_cntl with payer->name_cntl
          replace payer1->tcc       with payer->tcc
          replace payer1->state_tax with space(01)
          replace payer1->laser     with space(01)
      dbcloseall()
      ferase ("PAYER.DBF")
      frename("PAYER1.DBF", "PAYER.DBF")
      dbcloseall()
   endif
   @ 4,0 say 'Payer Database checked, modifications complete.'
endif

wait

dbcloseall()

cls

select 1
use ticket

if FieldExists('STA_WITH')
   @ 4,0 say 'Ticket Database checked, no modifications necessary.'
else
   aadd( aTicket, {"RECORD_ID",   "C", 09, 0} )
   aadd( aTicket, {"BATCH_DATE",  "D", 08, 0} )
   aadd( aTicket, {"BATCH_NUM",   "N", 04, 0} )
   aadd( aTicket, {"GROSS",       "N", 12, 2} )
   aadd( aTicket, {"FED_WITH",    "N", 12, 2} )
   aadd( aTicket, {"STA_WITH",    "N", 12, 2} )
   aadd( aTicket, {"DATE_WON",    "D", 08, 0} )
   aadd( aTicket, {"TRANS",       "C", 10, 0} )
   aadd( aTicket, {"RACE",        "N", 02, 0} )
   aadd( aTicket, {"WINNINGS",    "C", 10, 0} )
   aadd( aTicket, {"CASHIER",     "N", 04, 0} )
   aadd( aTicket, {"WINDOW",      "N", 04, 0} )
   aadd( aTicket, {"PERF_NUM",    "C", 04, 0} )

   dbcreate("TICKET1", aTicket)

   if file("TICKET1.DBF")

      GaugeDisplay ( aGauge)

          @ 4,0 say 'Creating New Ticket Database'

      select 2
      use ticket1

      select 1

      while .not. eof()
         GaugeDisplay ( aGauge, recno()/lastrec() )
         select 2
         dbappend()

                replace ticket1->record_id  with ticket->record_id
             replace ticket1->batch_date with ticket->batch_date
             replace ticket1->batch_num  with ticket->batch_num
             replace ticket1->gross             with ticket->gross
             replace ticket1->fed_with   with ticket->fed_with
             replace ticket1->sta_with   with 0
             replace ticket1->date_won         with ticket->date_won
             replace ticket1->trans                 with ticket->trans
             replace ticket1->race                 with ticket->race
             replace ticket1->winnings         with ticket->winnings
             replace ticket1->cashier         with ticket->cashier
         replace ticket1->window         with ticket->window
         replace ticket1->perf_num         with ticket->perf_num

         select 1
         skip

      enddo

      GaugeDisplay ( aGauge, recno()/lastrec() )

      dbcloseall()

      ferase ("TICKET.DBF")
      frename("TICKET1.DBF", "TICKET.DBF")

      select 1
      use ticket

      @ 6,0 Say 'Creating Ticket Index...'

      index on ticket->record_id to ticket.ntx ;
               eval (GaugeUpdate( aGauge, recno()/lastrec() ), .t.)

      @ 8,0 Say 'Creating BatchId Index...'

      index on dtoc(ticket->batch_date) + str(ticket->batch_num,4) + ;
              ticket->record_id to batchid.ntx ;
               eval (GaugeUpdate( aGauge, recno()/lastrec() ), .t.)

      @ 10,0 Say 'Creating Batch Date Index...'

      index on ticket->batch_date to btchdate.ntx ;
               eval (GaugeUpdate( aGauge, recno()/lastrec() ), .t.)

      index on ticket->batch_date to bdate.ntx ;
               eval (GaugeUpdate( aGauge, recno()/lastrec() ), .t.)

      dbcloseall()
      @ 12,0 say 'Ticket Database checked, modifications complete.'
   endif
endif

wait

cls

dbcloseall()

select 1
use rpt0235

if FieldExists('STA_WITH')
   @ 4,0 say 'RPT0235 Database checked, no modifications necessary.'
else
   aadd( aRPT0235, {"RECORD_ID",   "C", 09, 0} )
   aadd( aRPT0235, {"NAME",        "C", 32, 0} )
   aadd( aRPT0235, {"ADDRESS",     "C", 30, 0} )
   aadd( aRPT0235, {"CITY",        "C", 25, 0} )
   aadd( aRPT0235, {"STATE",       "C", 02, 0} )
   aadd( aRPT0235, {"ZIP",         "C", 05, 0} )
   aadd( aRPT0235, {"GROSS",       "N", 12, 2} )
   aadd( aRPT0235, {"FED_WITH",    "N", 12, 2} )
   aadd( aRPT0235, {"STA_WITH",    "N", 12, 2} )

   dbcreate("RPT02351", aRPT0235)

   if file("RPT02351.DBF")
      dbcloseall()

      ferase ("RPT0235.DBF")
      frename("RPT02351.DBF", "RPT0235.DBF")

      dbcloseall()
      @ 4,0 say 'RPT0235 Database checked, modifications complete.'
   endif
endif

wait

cls

dbcloseall()

select 1

use rpt0245

if FieldExists('STA_WITH')
   @ 4,0 say 'RPT0245 Database checked, no modifications necessary.'
else
   aadd( aRPT0245, {"RECORD_ID",   "C", 09, 0} )
   aadd( aRPT0245, {"NAME",        "C", 32, 0} )
   aadd( aRPT0245, {"ADDRESS",     "C", 30, 0} )
   aadd( aRPT0245, {"CITY",        "C", 25, 0} )
   aadd( aRPT0245, {"STATE",       "C", 02, 0} )
   aadd( aRPT0245, {"ZIP",         "C", 05, 0} )
   aadd( aRPT0245, {"GROSS",       "N", 12, 2} )
   aadd( aRPT0245, {"FED_WITH",    "N", 12, 2} )
   aadd( aRPT0245, {"STA_WITH",    "N", 12, 2} )

   dbcreate("RPT0245_1", aRPT0245)

   if file("RPT0245_1.DBF")
      dbcloseall()

      ferase ("RPT0245.DBF")
      frename("RPT0245_1.DBF", "RPT0245.DBF")

      dbcloseall()
      @ 4,0 say 'RPT0245 Database checked, modifications complete.'
   endif
endif

wait

cls

dbcloseall()

select 1
use rpt0270

if FieldExists('STA_WITH')
   @ 4,0 say 'RPT0270 Database checked, no modifications necessary.'
else
   aadd( aRPT0270, {"BATCH_DATE",  "D", 08, 0} )
   aadd( aRPT0270, {"BATCH_NUM",   "N", 04, 0} )
   aadd( aRPT0270, {"GROSS",       "N", 12, 2} )
   aadd( aRPT0270, {"FED_WITH",    "N", 12, 2} )
   aadd( aRPT0270, {"STA_WITH",    "N", 12, 2} )

   dbcreate("RPT0270_1", aRPT0270)

   if file("RPT0270_1.DBF")
      dbcloseall()

      ferase ("RPT0270.DBF")
      frename("RPT0270_1.DBF", "RPT0270.DBF")

      dbcloseall()
      @ 4,0 say 'RPT0270 Database checked, modifications complete.'
   endif
endif

wait

cls

dbcloseall()

select 1
use rpt0720

if FieldExists('STA_WITH')
   @ 4,0 say 'RPT0720 Database checked, no modifications necessary.'
else
   aadd( aRPT0720, {"RECORD_ID",   "C", 09, 0} )
   aadd( aRPT0720, {"BATCH_DATE",  "D", 08, 0} )
   aadd( aRPT0720, {"BATCH_NUM",   "N", 04, 0} )
   aadd( aRPT0720, {"GROSS",       "N", 12, 2} )
   aadd( aRPT0720, {"FED_WITH",    "N", 12, 2} )
   aadd( aRPT0720, {"STA_WITH",    "N", 12, 2} )
   aadd( aRPT0720, {"DATE_WON",    "D", 08, 0} )
   aadd( aRPT0720, {"TRANS",       "C", 10, 0} )
   aadd( aRPT0720, {"RACE",        "N", 02, 0} )
   aadd( aRPT0720, {"WINNINGS",    "C", 10, 0} )
   aadd( aRPT0720, {"CASHIER",     "N", 04, 0} )
   aadd( aRPT0720, {"WINDOW",      "N", 04, 0} )
   aadd( aRPT0720, {"PERF_NUM",    "C", 04, 0} )


   dbcreate("RPT0720_1", aRPT0720)

   if file("RPT0720_1.DBF")
      dbcloseall()

      ferase ("RPT0720.DBF")
      frename("RPT0720_1.DBF", "RPT0720.DBF")

      dbcloseall()
      @ 4,0 say 'RPT0720 Database checked, modifications complete.'
   endif
endif

wait

cls

dbcloseall()

select 1
use rpt0740

if FieldExists('TOTAL_STA')
   @ 4,0 say 'RPT0740 Database checked, no modifications necessary.'
else
   aadd( aRPT0740, {"BATCH_DATE",  "D", 08, 0} )
   aadd( aRPT0740, {"BATCH_NUM",   "N", 04, 0} )
   aadd( aRPT0740, {"TOTAL_GROSS", "N", 12, 2} )
   aadd( aRPT0740, {"TOTAL_FED",   "N", 12, 2} )
   aadd( aRPT0740, {"TOTAL_STA",   "N", 12, 2} )
   aadd( aRPT0740, {"PERF_NUM",    "C", 04, 0} )
   aadd( aRPT0740, {"DESCRPT",     "C", 40, 0} )


   dbcreate("RPT0741", aRPT0740)

   if file("RPT0741.DBF")
      dbcloseall()

      ferase ("RPT0740.DBF")
      frename("RPT0741.DBF", "RPT0740.DBF")

      dbcloseall()
      @ 4,0 say 'RPT0740 Database checked, modifications complete.'
   endif
endif

wait

cls

select 1
use batchctl

if FieldExists('TOTAL_STA')
   @ 4,0 say 'Batch Control Database checked, no modifications necessary.'
else
   aadd( aBatchCtl, {"BATCH_DATE",  "D", 08, 0} )
   aadd( aBatchCtl, {"BATCH_NUM",   "N", 04, 0} )
   aadd( aBatchCtl, {"TOTAL_GROS",  "N", 12, 2} )
   aadd( aBatchCtl, {"TOTAL_FED",   "N", 12, 2} )
   aadd( aBatchCtl, {"TOTAL_STA",   "N", 12, 2} )
   aadd( aBatchCtl, {"PERF_NUM",    "C", 04, 0} )

   dbcreate("BATCHCT1", aBatchCtl)

   if file("BATCHCT1.DBF")

      GaugeDisplay ( aGauge)

          @ 4,0 say 'Creating New BatchCtl Database'

      select 2

      use batchct1

      select 1

      while .not. eof()
         GaugeDisplay ( aGauge, recno()/lastrec() )
         select 2
         dbappend()

             replace batchct1->batch_date with batchctl->batch_date
             replace batchct1->batch_num  with batchctl->batch_num
             replace batchct1->total_gros with batchctl->total_gros
             replace batchct1->total_fed  with batchctl->total_fed
             replace batchct1->total_sta  with 0
         replace batchct1->perf_num   with batchctl->perf_num

         select 1
         skip

      enddo

      GaugeDisplay ( aGauge, recno()/lastrec() )

      dbcloseall()

      ferase ("BATCHCTL.DBF")
      frename("BATCHCT1.DBF", "BATCHCTL.DBF")

      select 1

      use batchctl

      @ 6,0 Say 'Creating batchctl Index...'

      index on dtoc(batchctl->batch_date) + str(batchctl->batch_num,4) ;
            to batchctl.ntx eval (GaugeUpdate( aGauge, recno()/lastrec() ), .t.)

      dbcloseall()

      @ 8,0 say 'BatchCtl Database checked, modifications complete.'

   endif

endif

wait

cls

dbcloseall()

select 1
use temp

if FieldExists('STA_WITH')
   @ 4,0 say 'TEMP Database checked, no modifications necessary.'
else
   aadd( aTEMP, {"RECORD_ID",   "C", 09, 0} )
   aadd( aTEMP, {"BATCH_DATE",  "D", 08, 0} )
   aadd( aTEMP, {"BATCH_NUM",   "N", 04, 0} )
   aadd( aTEMP, {"GROSS",       "N", 12, 2} )
   aadd( aTEMP, {"FED_WITH",    "N", 12, 2} )
   aadd( aTEMP, {"STA_WITH",    "N", 12, 2} )
   aadd( aTEMP, {"DATE_WON",    "D", 08, 0} )
   aadd( aTEMP, {"TRANS",       "C", 10, 0} )
   aadd( aTEMP, {"RACE",        "N", 02, 0} )
   aadd( aTEMP, {"WINNINGS",    "C", 10, 0} )
   aadd( aTEMP, {"CASHIER",     "N", 04, 0} )
   aadd( aTEMP, {"WINDOW",      "N", 04, 0} )
   aadd( aTEMP, {"PERF_NUM",    "C", 04, 0} )


   dbcreate("TEMP_1", aTEMP)

   if file("TEMP_1.DBF")
      dbcloseall()

      ferase ("TEMP.DBF")
      frename("TEMP_1.DBF", "TEMP.DBF")

      dbcloseall()
      @ 4,0 say 'TEMP Database checked, modifications complete.'
   endif
endif

wait

return(nil)