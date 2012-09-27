
--CREATE PROC JT_SAF_Murano AS


/*------------------------------------------------------------------------	
	Date: 10/07/2011
	Programmer: James Tuttle
	Request By: Joe Fata
	
	Will you build a query for me that will run daily and show the 
	Johnsonite Murano colors and roll sizes available in the system?
	
	 We are blowing out all of this inventory and the reps are calling
	 or emailing me daily to see what is left.		
	 Joe Fata

	Customer Service Supervisor
	Pacific Mat & Commercial Flooring
	800-345-6287    Ext. 1352
	Fax# 253-872-9022
	joef@pacmat.com	
-------------------------------------------------------------------------*/

SELECT *
FROM OPENQUERY(GSFL2K, 'SELECT idco as co,
								idloc as loc,
							   iditem as item, 
						       imdesc as details,
						       idqoh - idqoo as availible
						FROM itemdetl JOIN itemmast ON iditem = imitem
						WHERE idloc = 57
							AND idvend = 22949
							AND idfmcd = ''V9''	
							AND  idqoh - idqoo > 0	
						
					')
