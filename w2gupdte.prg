function w2g0901 ()

local   aStru     := {}                    // Create Empty Array

dbcloseall()

select 1
use payer

if FieldExists('STATE_TAX') .and. ;
   FieldExists('LASER')
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
  	  replace payer1->name	    with payer->name	   
	  replace payer1->address1  with payer->address1 
	  replace payer1->address2  with payer->address2 
	  replace payer1->city	    with payer->city	   
	  replace payer1->state	    with payer->state	   
	  replace payer1->zip	    with payer->zip	   
	  replace payer1->ein	    with payer->ein	   
	  replace payer1->name_cntl with payer->name_cntl
	  replace payer1->tcc       with payer->tcc      
	  replace payer1->state_tax with space(01)
	  replace payer1->laser     with space(01)
      dbcloseall()
      ferase ("PAYER.DBF")
      frename("PAYER1.DBF", "PAYER.DBF")
      select 1
      use payer
      do w2g0900
      dbcloseall()
   endif   
endif   

select 2
return(nil)