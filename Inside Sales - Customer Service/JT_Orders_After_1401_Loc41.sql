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

CREATE PROC JT_Orders_After_1401_Loc41 AS
BEGIN
 SELECT ohco		AS Co
		,ohloc		AS Loc
		,ohord#		AS [Order]
		,ohrel#		AS Rel
		,cmname		AS Customer
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
			WHEN ohcrhl	= 'Y' THEN 'ON CREDIT HOLD'
		 END		AS Credit_Hold
		---------------------------------------------	
		,ohcrus		AS Released_By
		---------------------------------------------
		,CASE
			WHEN ohcrtm	= 0 THEN ' '
		 END		AS Released_Time
		 ---------------------------------------------
		,CASE
			WHEN cDt = '1/1/1' THEN ' '
		 END		AS Released_Date
		 ---------------------------------------------
 FROM OPENQUERY(GSFL2K,	
	'SELECT ohco 
		,ohloc 
		,ohord# 
		,ohrel# 
		,cmname
		,ohuser 
	 	,ohtime
		,MONTH(ohdate) || ''/'' || DAY(ohdate) || ''/''  ||	YEAR(ohdate) AS oDt
		,ohcrhl 
		,ohcrus 
		,ohcrtm
		,MONTH(ohcrdt) || ''/'' || DAY(ohcrdt) || ''/''  ||	YEAR(ohcrdt) AS cDt
	FROM oohead oh
	LEFT JOIN custmast cm ON cm.cmcust = oh.ohcust
	WHERE oh.ohtime >= 140100
		AND oh.ohdate = CURRENT_DATE 
	')
END
