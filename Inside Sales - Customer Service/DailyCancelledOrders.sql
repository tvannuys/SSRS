/*****************************************************************************************************
**																									**
** SR# 17027																						**
** Programmer: Thomas Van Nuys		Date: 01/04/2014												**
** ------------------------------------------------------------------------------------------------ **
** Purpose:		Look for orders canceled the prior day and are not transfer or showroom XE.			**
**																									**
**																									**
**																									**
**		JAMES TUTTLE:: Was in the SSRS. I took it out and made it a PROC							**
**																									**
******************************************************************************************************/

ALTER PROC DailyCancelledOrders 

	@CSV varchar(100)
AS
BEGIN

	select * from openquery (gsfl2k,'

	select	olco as Co,
			olloc as Loc,
			olord# as OrderNum,
			olrel# as Release,
			olcust as CustNum,
			cmname as CustName,
			oldate as OrderDate,
			olreas as Reason,
			olcusr as UserToCancel,
			olitem as ItemNum,
			imsi as StockStatus,
			imdrop as Drop,
			olqord as OrderQty,
			oleprc as ExtendedPrice
			
			
	from oclhist oc
		left join custmast cm on cm.cmcust = oc.olcust
		left join itemmast im on im.imitem = oc.olitem
		
		
	where olcdte = (current_date)-3 day
		and oldirs <>''T''
		and olcust not like (''SHOWR%'')
		and olcust not like (''TRANS%'')
		and olcust not like (''XFER%'')

	order by olco asc,olloc asc,olord# asc,olrel# asc


	')
	WHERE StockStatus IN (SELECT * FROM dbo.udfCSVToList(@CSV))
 
END


-- DailyCancelledOrders 'Y'