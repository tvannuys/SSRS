
--ALTER PROC JT_Non_Stock_Drop_XFR_Daily AS

BEGIN
	SELECT *
	FROM OPENQUERY(GSFL2K,'SELECT MONTH(olrdat) || ''/'' || DAY(olrdat) || ''/'' || YEAR(olrdat) AS Recv_Date
								  ,olrrte AS Route
								  ,olrilo AS loc
								  ,olrtyp AS Type
								  ,olrord AS Order
								  ,olritm AS Item
								  ,imdesc AS Desc
								  ,olrqty AS Qty_Recvd
								  ,idqoo AS Qty_Cmtd
								  ,imdrop AS Drop
								  ,imsi AS Stock
							FROM oolrfhst hst
							JOIN itemmast im
								ON hst.olritm = im.imitem
							JOIN itemdetl id
								ON id.iditem = hst.olritm
									AND id.idky = hst.olridk
							WHERE olrdat = CURRENT_DATE
								AND hst.olrtyp = ''X''
								AND hst.olrord != 0
								AND id.idqoo <= 0
								AND im.imsi != ''Y''
								AND hst.olrilo = 50
					')
END
