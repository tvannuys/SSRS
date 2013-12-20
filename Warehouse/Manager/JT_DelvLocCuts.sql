/*****************************************************************************************************
**																									**
** SR# 16642																						**
** Programmer: James Tuttle		Date: 12/18/2013													**
** ------------------------------------------------------------------------------------------------ **
** Purpose:	Get the vinyl and carpet cuts and determine where they are going to be delivered		**
**			To help bring to the surface where cuts are being made and where they are going			**
**																									**
**																									**
**																									**
**																									**
******************************************************************************************************/

ALTER PROC JT_DelvLocCuts AS
BEGIN
 SELECT olrloc [Location]										-- Locations grouped
		,SUM(CASE WHEN imdiv = 3 THEN 1 ELSE 0 END) [Vinyl]		-- Division 3 for Vinyl
		,SUM(CASE WHEN imdiv = 11 THEN 1 ELSE 0 END) [Carpet]	-- Division 11 for Carpet

 FROM OPENQUERY(GSFL2K,	
	'SELECT *
		
	FROM oolrfhst olr
	LEFT JOIN itemmast im ON im.imitem = olr.olritm
	
	WHERE olr.olrilo IN (60, 42, 59)
		 AND (( olr.olrtyp = ''C'' ) OR ( olr.olrtyp = ''S'' AND olr.olrfr = ''Y'' ))
		 AND olr.olrdat = ''12/18/2013'' 
	')
GROUP BY olrloc	
ORDER BY olrloc
END

----- JT_DelvLocCuts

/* ---------------------------------------------------------------------------------------------------------
------------- D E T A I L S ----------------------------	
BEGIN
 SELECT olrloc [Location]										
		,olrord
		,olrrel
		,olrqty

 FROM OPENQUERY(GSFL2K,	
	'SELECT *
		
	FROM oolrfhst olr
	LEFT JOIN itemmast im ON im.imitem = olr.olritm
	
	WHERE olr.olrilo IN (60, 42, 59)
		 AND (( olr.olrtyp = ''C'' ) OR ( olr.olrtyp = ''S'' AND olr.olrfr = ''Y'' ))
		 AND olr.olrdat = ''12/18/2013'' 
		 AND imdiv IN (3,11)
	')

ORDER BY olrloc
		,olrord
END

--------------------------------------------------------------------------------------------------------------- */

-- SELECT * FROM OPENQUERY(GSFL2K,'SELECT * FROM itemmast WHERE imdiv=41')



---------------------------------------------------------------------------------------------------------------
/*--------------------------- A V E R A G E -----------------------------
BEGIN
 SELECT olrloc [Location]										

		,ROUND(AVG(olrqty),0) AS [AvgFeetCut]

 FROM OPENQUERY(GSFL2K,	
	'SELECT *
		
	FROM oolrfhst olr
	LEFT JOIN itemmast im ON im.imitem = olr.olritm
	LEFT JOIN shline sl ON ( sl.slco = olr.olrco
						AND sl.slloc = olr.olrloc
						AND sl.slord# = olr.olrord
						AND sl.slrel# = olr.olrrel
						AND sl.slitem = olr.olritm 
						AND sl.slseq# = olr.olrseq )
	
	LEFT JOIN ooline ol ON ( ol.olco = olr.olrco
						AND ol.olloc = olr.olrloc
						AND ol.olord# = olr.olrord
						AND ol.olrel# = olr.olrrel
						AND ol.olitem = olr.olritm 
						AND ol.olseq# = olr.olrseq )
	
	WHERE olr.olrilo IN (60, 42, 59)
		 AND olr.olrtyp = ''C''  
		 AND olr.olrfr != ''Y'' 
		 AND olr.olrdat >= ''01/01/2013'' 
		 AND imdiv IN (3,11)
		 AND (( sl.slcut != ''N'') OR (ol.olcut != ''N'' ))
	')
GROUP BY olrloc	
ORDER BY olrloc

END

=======================================================================================================================
---- O R D E R		L I N E			D E T A I L S ------------------
BEGIN
 SELECT olrord
		,olritm
		,olrqty
		,slcut
		,olcut
 FROM OPENQUERY(GSFL2K,	
	'SELECT *
		
	FROM oolrfhst olr
	LEFT JOIN itemmast im ON im.imitem = olr.olritm
	LEFT JOIN shline sl ON ( sl.slco = olr.olrco
						AND sl.slloc = olr.olrloc
						AND sl.slord# = olr.olrord
						AND sl.slrel# = olr.olrrel
						AND sl.slitem = olr.olritm 
						AND sl.slseq# = olr.olrseq )
	
	LEFT JOIN ooline ol ON ( ol.olco = olr.olrco
						AND ol.olloc = olr.olrloc
						AND ol.olord# = olr.olrord
						AND ol.olrel# = olr.olrrel
						AND ol.olitem = olr.olritm 
						AND ol.olseq# = olr.olrseq )
						
	
	WHERE olr.olrilo IN (60, 42, 59)
		 AND (( olr.olrtyp = ''C'' ) OR ( olr.olrtyp = ''S'' AND olr.olrfr = ''Y'' ))
		 AND olr.olrdat = ''12/18/2013'' 
		 AND im.imdiv IN (3,11)
		 AND (( sl.slcut != ''N'') OR (ol.olcut != ''N'' ))
		
	')

ORDER BY olrloc
		,olrord 
END



--------------------------------------------------------------------------------------------------------------------- */




