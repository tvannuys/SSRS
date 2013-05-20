
ALTER PROC JT_shelf_life_v2 As

/*==========================================================*
** James Tuttle												*
** Date: 11/11/2011											*
**															*
** FROM VFP: shelflifev2.prg								*
**															*
**  Reporting on the shelf life on 365 days and greater		*
**	Family Code: A1,A4,A3,A6,C7,U3							*
**															*
**==========================================================*/ 

-- SR# 10556
-- Added Items to exclude and sorted by loc and date DESC
-- James Tuttle    05/06/2013


SELECT *
FROM Openquery(GSFL2K, 'SELECT id.idco as co,
							id.idloc as loc,
							im.imsi as stocking,
							im.imdrop as drop,
							im.imitem as item,
							im.imdesc as description,
							im.imcolr as color,
							month(id.iddate) || ''/'' || day(id.iddate) || ''/'' || year(id.iddate) as date,
							id.idbin as bin,
							id.idqoh as QOH,
							id.idqoo as QOO,
							DAYS(CURRENT_DATE) - DAYS(id.iddate) as age_in_days
						FROM itemdetl as id INNER JOIN itemmast as im
							ON id.iditem = im.imitem
						WHERE im.imclas != ''SA''
							AND id.idqoo = 0
							AND im.imdiv = 6
							AND id.idqoh > 0
							AND im.imprcd NOT IN (900, 905, 906)
							AND im.imitem NOT IN (''CUDL75'', ''WATH115F12VDC'', ''TAUOBLACKLIGHT'',''CUC924OF'',
								''MA4005KIT'', ''AQSAMAMPG'',''TAHAVSMDSTAPE '',''HAVSMDSTAPE'')
							AND DAYS(id.iddate) < DAYS(CURRENT_DATE) - 365
							AND im.imfmcd IN (''A1'', ''A4'', ''A3'',''A6'',''C7'',''U3'')
						ORDER BY id.idco
								,id.idloc
								
						
						')