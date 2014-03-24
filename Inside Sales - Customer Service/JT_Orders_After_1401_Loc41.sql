/*********************************************************************************
**																				**
** SR# 9814			Date:04/15/2013												**
** Programmer: James Tuttle														**
** ---------------------------------------------------------------------------- **
** Purpose:	Orders were released from credit after 2:01pm						**
**																				**
**																				**	
**																				**
**																				**
**																				**
**********************************************************************************/

ALTER PROC JT_Orders_After_1401_Loc41 AS
BEGIN
 SELECT ohco		AS Co
		,ohloc		AS Loc
		,ohord#		AS [Order]
		,ohrel#		AS Rel
		,cmname		AS Customer
		,ortrt		AS [Route]
		,ohuser		AS Created_By
		---------------------------------------------
		,CAST( SUBSTRING(RIGHT('000000' + CONVERT(VARCHAR(6),ohtime),6),1,2) + ':'
			 + SUBSTRING(RIGHT('000000' + CONVERT(VARCHAR(6),ohtime),6),3,2) + ':'
			 + SUBSTRING(RIGHT('000000' + CONVERT(VARCHAR(6),ohtime),6),5,2) AS TIME)
  					AS Created_Time
		---------------------------------------------
		,oDt		AS Created_Date
		---------------------------------------------
		,CASE 
			WHEN ohcrhl	= 'Y' THEN 'ON CREDIT HOLD' ELSE 'RELEASED'
		 END		AS Credit_Hold
		---------------------------------------------	
		,ohcrus		AS Released_By
		---------------------------------------------
		,CASE
			WHEN ohcrtm	!= 0 THEN CAST( SUBSTRING(RIGHT('000000' + CONVERT(VARCHAR(6),ohcrtm),6),1,2) + ':'
			 + SUBSTRING(RIGHT('000000' + CONVERT(VARCHAR(6),ohcrtm),6),3,2) + ':'
			 + SUBSTRING(RIGHT('000000' + CONVERT(VARCHAR(6),ohcrtm),6),5,2) AS TIME) 
		
		 END		AS Released_Time
		 ---------------------------------------------
		,CASE
			WHEN cDt != '0001-01-01' THEN cDt
		 END		AS Released_Date
		 ---------------------------------------------
 FROM OPENQUERY(GSFL2K,	
	'SELECT ohco 
		,ohloc 
		,ohord# 
		,ohrel# 
		,cmname
		,ortrt
		,ohuser 
	 	,ohtime
		,MONTH(ohdate) || ''/'' || DAY(ohdate) || ''/''  ||	YEAR(ohdate) AS oDt
		,ohcrhl 
		,ohcrus 
		,ohcrtm
		,MONTH(ohcrdt) || ''/'' || DAY(ohcrdt) || ''/''  ||	YEAR(ohcrdt) AS cDt
		
	FROM oohead oh
	LEFT JOIN custmast cm ON cm.cmcust = oh.ohcust
	LEFT JOIN ooroute ort ON (ort.ortco = oh.ohco
							AND ort.ortloc = oh.ohloc
							AND ort.ortord = oh.ohord#
							AND ort.ortrel = oh.ohrel#)
	
	WHERE oh.ohtime >= 140100
		AND oh.ohdate = CURRENT_DATE
		AND oh.ohco = 2
		AND ort.ortrt != ''  ''
		AND ohcrus != '' ''
	')
END
