
USE 
GartmanReport
GO

-- Inventory Adjustments Codes
-- 25 39 02 PI

ALTER PROC Inv_Adj_TableFeed AS

-- Truncate table
--TRUNCATE dbo.InventoryAdjustmentsWH

-- INSERT into table after TRUNCATED
INSERT dbo.InventoryAdjustmentsWH (Co, Loc, ReasonCode, Item, [Description], IRTag, [Date], [Month], [Year], Serial, DyeLot, Comment, Each, UM, Cost, TotalCost, [User])

-- commentied out fields. Was used for debugging and comparison
SELECT irco			AS Co
		,irloc		AS Loc
		,irreason	AS ReasonCode
		,iritem		AS Item
		,imdesc		AS [Description]
		,irky		AS IRTag
		,irDate		AS [Date]
		,[Month]
		,[Year]
		,irserl		AS Serial
		,irdylt		AS DyeLot
		,ircomt		AS Comment
		,Each
		,UM
		,ircost		AS Cost														
		,TotalCost
		,iruser		AS [User]

FROM OPENQUERY(GSFL2K,'
	SELECT irco
		,irloc
		,irreason
		,iritem
		,imdesc
		,irky
		,MONTH(irdate) || ''/'' || DAY(irdate) || ''/'' || YEAR(irdate) as irDate
		,MONTHNAME(irdate) AS Month
		,YEAR(irdate) AS Year
		,irserl
		,irdylt
		,ircomt
		
/* ---- Show each or billable units	------------------------------------------------------- */
		,CASE
			WHEN irblu = 0
				THEN irqty
			ELSE irblu
		END AS Each
		
/* ---- Logic for using Unit Bill when adjustment done and the system converts outside on ITEMMAST else use ITEMMAST conversion ---- */		

		,CASE
			WHEN irblu = 0 THEN
			    CASE 
					WHEN (immd = ''M'' AND immd2 = '' '') 
						THEN CAST(ROUND((irqty * imfact) * ircost,3) AS decimal (18,2))
					WHEN (immd = ''M'' AND immd2 = ''D'') 
						THEN CAST(ROUND(((irqty * imfact) / imfac2) * ircost,3) AS decimal (18,2))
					END
			ELSE CAST(ROUND(irblu * ircost,3) AS decimal (18,2))
		 END AS TotalCost
		 
/* ---- If use billable units conversion then display the U/M by the conversion ELSE use the ITEMMAST conversion ---- */	
	 
      ,CASE 
            WHEN (irum1 = ''    '' AND irum2 = ''    '') 
                  THEN imum1
            ELSE irum2
      END AS UM
/* ------------------------------------------------------------------------------------------------------ */		 
		,imum1	
		,IRBLU
		,irum2
		,irqty
		,ircost
		,immd
		,immd2
		,imfact
		,imfac2
		,irum1
		,iruser

FROM itemrech ir
LEFT JOIN itemmast im ON im.imitem = ir.iritem

WHERE irloc IN(41, 50, 52, 57)
	AND irreason IN(''25'', ''39'', ''02'',''38'',''PI'')
	AND irdate >= (CURRENT_DATE - (MONTH(CURRENT_DATE)-1) MONTHS - (DAY(CURRENT_DATE)-1) DAYS) - 3 YEARS

GROUP BY irco
		,irloc
		,irreason
		,iritem
		,imdesc
		,irky
		,irdate
		,MONTH(irdate) 
		,YEAR(irdate)
		,irserl
		,irdylt
		,ircomt
		,irqty
		,ircost
		,irum1
		,iruser
		,immd
		,immd2
		,imfact
		,imfac2
		,IRBLU
		,irum2
		,imum1
	
ORDER BY irco
			,irloc
			,irdate
			,irreason 

')

-- SELECT * FROM InventoryAdjustmentsWH


/********** TABLE ****************************

IF EXISTS (SELECT * FROM sys.objects 
	WHERE OBJECT_ID = object_id(N'[dbo].[InventoryAdjustmentsWH]')
		AND TYPE IN (N'U'))
	
DROP TABLE dbo.InventoryAdjustmentsWH
GO 

CREATE TABLE dbo.InventoryAdjustmentsWH
(
  ID int IDENTITY (1,1) PRIMARY KEY NOT NULL
  ,Co varchar(3) NOT NULL
  ,Loc varchar(2)NOT NULL
  ,ReasonCode varchar(2) NOT NULL
  ,Item varchar(18) NOT NULL
  ,[Description] varchar(30) NULL
  ,IRTag varchar(10) NOT NULL
  ,[Date] varchar(10) NOT NULL
  ,[Month] varchar(12) NOT NULL
  ,[Year] varchar(4) NOT NULL
  ,Serial varchar(10) NULL
  ,DyeLot varchar(10) NULL
  ,Comment varchar(30) NULL
  ,Each float NOT NULL
  ,UM varchar(4)
  ,Cost float
  ,TotalCost float
  ,[User] varchar(8)
)
GO

SELECT * FROM InventoryAdjustmentsWH

**************************************************************************/
