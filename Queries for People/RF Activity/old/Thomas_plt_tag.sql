---------------------------------------------------------------------------------------
--  James Tuttle 12/12/11
-- 
-- Gather the DISTINCT COUNT() on the pallet tag #'s by USER
-- at location 50 (Kent)
--
-- NOTE:: Details of item detail by USER Commented out at the bottom
-- TODO:: Comment out the USERID
--====================================================================================
--
-- FILES: TRANSFER | USERFILE | USERXTRA | PREMPM
--
-- NOTE:: 12/21/11 TRANSFER USER UPDATES to last USER that updated the order
---------------------------------------------------------------------------------------
-- Get User ID #
-- TODO:: Comment out the USERID
WITH CTE AS
	(SELECT emname as Name, ememp# as empno
	FROM OPENQUERY (GSFL2K, 'SELECT emname,
								  ememp#
							FROM prempm
							WHERE ememp# = 1992  /***** Using 1 user #  ****/
							ORDER BY ememp#
							')
),

-- Gather: Pallet tag | dates | for TRANSFERS
 CTE2 AS (
	SELECT COUNT( itxpal) OVER(PARTITION BY usxemp#) AS PltCnt,  usxemp# as [User]
	FROM OPENQUERY (GSFL2K, 'SELECT usxemp#,
									itxpal
								FROM transfer xe
								INNER JOIN userxtra ux
									ON xe.ituser = ux.usxid
								INNER JOIN userfile uf
									ON ux.usxid = uf.usid
								INNER JOIN oolrfuser hst
									ON (hst.olrico = xe.itico
										AND hst.olrilo = xe.itiloc
										AND hst.olrord = xe.itord#
										AND hst.olrrel = xe.itrel#
										AND hst.olritm = xe.ititem)
								WHERE xe.itdate >= ''2011-10-01''
									AND xe.itdate <= ''2011-10-31'' 
									AND xe.itico = 1	
									AND xe.itiloc = 50	  
									AND xe.itxpal != 0
								GROUP BY xe.itxpal, ux.usxemp#
								ORDER BY ux.usxemp#, xe.itxpal
								')
GROUP BY usxemp#, itxpal
)
--*************************************************************************************
---------------------------------------------------------------------------------------
-- Results Returned for Reporting
---------------------------------------------------------------------------------------
--*************************************************************************************
SELECT CTE2.[User], CTE.Name, CTE2.PltCnt,'10/01/2011' AS StartDate, '10/31/2011' AS EndDate
FROM CTE2
INNER JOIN CTE
	ON CTE2.[User] = CTE.empno
GROUP BY CTE2.[User], CTE2.PltCnt ,CTE.Name
ORDER BY CTE2.[User] 



/*************************************************************************
**																		**
**		DISTINCT DETAILS BY USER NUMBER & PALLET TAG #					**
**																		**
**************************************************************************
-- TODO:: Comment out the USERID
--
SELECT  DISTINCT itxpal AS pltCnt, usxemp#							
FROM OPENQUERY (GSFL2K, 'SELECT ituser,								
								usxemp#,
								itxpal
							FROM transfer xe
							INNER JOIN userxtra ux
								ON xe.ituser = ux.usxid
							INNER JOIN userfile uf
								ON ux.usxid = uf.usid
							WHERE xe.itdate >= ''2011-10-01''
								AND xe.itdate <= ''2011-10-31'' 
								AND xe.itico = 1	
								AND xe.itiloc = 50	  
								AND xe.itxpal != 0
								AND ux.usxemp# = 1992 /*## USER ID# ##*/
							ORDER BY xe.ituser
							')
-------------------------------------------------------------------------
-- With ITEM record Details
-------------------------------------------------------------------------
---- TODO: Comment out the USERID
--
SELECT *							
FROM OPENQUERY (GSFL2K, 'SELECT ituser,								
								usxemp#,
								itxpal,
								itord#,
								itrel#,
								itseq#,
								ititem
							FROM transfer xe
							INNER JOIN userxtra ux
								ON xe.ituser = ux.usxid
							INNER JOIN userfile uf
								ON ux.usxid = uf.usid
							WHERE xe.itdate >= ''2011-10-01''
								AND xe.itdate <= ''2011-10-31'' 
								AND xe.itico = 1	
								AND xe.itiloc = 50	  
								AND xe.itxpal != 0
								AND ux.usxemp# = 1992  /*## USER ID# ##*/
								AND EXISTS ( SELECT 1
											 FROM oolrfuser hst
											 WHERE hst.olrico = xe.itico
												AND hst.olrilo = xe.itiloc
												AND hst.olrord = xe.itord#
												AND hst.olrrel = xe.itrel#
												AND hst.olritm = xe.ititem
												AND hst.olrusr = ux.usxemp#)
							ORDER BY xe.ituser
							')
*****************************************************************************/


/*       Checking with OOLRFHST <------------------------------------------<<<

SELECT *							
FROM OPENQUERY (GSFL2K, 'SELECT ituser,								
								usxemp#,
								itxpal,
								itord#,
								itrel#,
								itseq#,
								ititem
							FROM transfer xe
							INNER JOIN userxtra ux
								ON xe.ituser = ux.usxid
							INNER JOIN userfile uf
								ON ux.usxid = uf.usid
							INNER JOIN oolrfuser hst
								ON (hst.olrilo = xe.itiloc
									AND hst.olrord = xe.itord#
									AND hst.olrrel = xe.itrel#
									AND hst.olritm = xe.ititem
									AND hst.olrseq = xe.itseq#)
							WHERE xe.itdate >= ''2011-10-01''
								AND xe.itdate <= ''2011-10-31'' 
								AND xe.itico = 1	
								AND xe.itiloc = 50	  
								AND xe.itxpal != 0
								AND ux.usxemp# = 1992  /*## USER ID# ##*/
							ORDER BY xe.ituser
							')
***************************************************************************************************/