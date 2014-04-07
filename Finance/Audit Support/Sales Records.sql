/* 

Order Type FN - finance user
SHUSER = ARMDATA - armstrong transactions prior to acquisition

*/

select * from openquery (gsfl2k,'

SELECT      SHHEAD.SHINV# AS InvoiceNbr, 
            SHHEAD.SHIDAT AS InvoiceDate, 
            SHHEAD.SHLOC AS Location, 
            SHHEAD.SHVIAC AS ShipViaCode,
            SHHEAD.SHVIA AS ShipViaDesc,
            SHHEAD.SHCUST AS CustNbr, 
            CUSTMAST.CMNAME AS CustName, 
            CUSTMAST.CMADR1 as BillingAddr1, 
            CUSTMAST.CMADR2 as BillingAddr2,
            Left(CMADR3,23) AS BillingCity, 
            Right(CMADR3,2) AS BillingState,  
            CUSTMAST.CMZIP as BillingZip, 
            SHHEAD.SHSTA1 AS ShipToAddr1, 
            SHHEAD.SHSTA2 AS ShipToAddr2, 
            Left(SHSTA3,23) AS ShipToCity, 
            Right(SHSTA3,2) AS ShipToState, 
            SHHEAD.SHZIP AS ShipToZipCode, 
            SHHEAD.SHEMDS AS Subtotal,
            SHSPC1 AS DeliveryCharge,
            SHSPC2 AS Restock,
            SHSPC4 AS FreightHandling,
            SHSPC5 AS FuelSurcharge, 
            SHHEAD.SHESTA AS StateTaxAmt, 
            SHHEAD.SHECNA AS CountyTaxAmt, 
            SHHEAD.SHECIA AS CityTaxAmt, 
            SHHEAD.SHTOTL AS InvoiceTotal,
            shhead.shuser as User,
            shhead.shotyp as OrderType

FROM SHHEAD 
      INNER JOIN CUSTMAST ON SHHEAD.SHCUST = CUSTMAST.CMCUST

WHERE SHHEAD.SHIDAT Between ''01/01/2011'' And ''12/31/2011'' 
      AND SHHEAD.SHCO = 2
      
ORDER BY SHHEAD.SHIDAT

fetch first 1000 rows only

')
