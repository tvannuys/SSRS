
-- Two TEMP tables in DB2 --

SELECT *
FROM OPENQUERY(GSFL2K,
 'WITH
	tempIB AS ( SELECT ibqoh AS QOH
				,ibloc AS Loc
				,ibitem AS Item
			  FROM itembal )
 ,tempMN AS
	(	SELECT * 
		FROM manifest
		WHERE mnco = 1
		  AND mnvend = 24020 ) 
		 
SELECT ib.Loc
		,mn.mnloc
		,mn.mnman#
		,ib.Item
		,mn.mnitem
		,ib.QOH	
				  
FROM tempIB ib
	,tempMN mn

WHERE ib.Item = mn.mnitem
	AND ib.Loc = mn.mnloc


 ') 