USE [GartmanReport]
GO

/****** Object:  StoredProcedure [dbo].[JT_BinCheck_v2]    Script Date: 4/14/2014 2:29:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[JT_BinCheck_v2] AS

/* -----------------------------------------------------*
** James Tuttle 4/26/2011								*
** -----------------------------------------------------*
** Report on inventory that is							*
** not committed in a stage/ship type					*
** bin location at any location							*
** based off the bin location's "section' = XXXXX		*
**------------------------------------------------------*
*/

-- Query
SELECT idco 'Company', 
idloc 'Location', 
iditem 'Item', 
idbin 'Bin', 
blgrp 'Section', 
idqoh 'On Hand'

FROM OPENQUERY (GSFL2K, '
select * 
from itemdetl id INNER JOIN binloc bl ON idbin = blbin AND idloc = blloc
WHERE idqoh > 0.07 
AND idqoo <= 0 
AND blgrp IN (''XXXXX'', ''WCSTG'')')

ORDER BY idloc ASC, idbin ASC;

-- END --
GO


