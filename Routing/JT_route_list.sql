
------------------------------------------------
-- Get T&A Routes
-- James Tuttle
-- 10/29/2012
--
-- Exclude transfers: xx-xx
------------------------------------------------

ALTER PROC JT_route_list AS

SELECT *
FROM OPENQUERY (GSFL2K,
	'SELECT rtrout
	FROM route
	WHERE rtrout NOT LIKE ''%-%''
	ORDER BY rtrout
	')