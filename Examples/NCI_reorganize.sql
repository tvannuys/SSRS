

/* REBUILD Index Script since Fragmentation is around 30% */
USE pubs
GO
ALTER INDEX ALL ON dbo.WarehouseProductivity REORGANIZE 
GO

/*
-- See avg fragmentation in % onthe table 
--
SELECT ps.database_id, ps.OBJECT_ID,
ps.index_id, b.name,
ps.avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS ps
INNER JOIN sys.indexes AS b ON ps.OBJECT_ID = b.OBJECT_ID
AND ps.index_id = b.index_id
WHERE ps.database_id = DB_ID()
	AND ps.OBJECT_ID = 1755153298
ORDER BY ps.OBJECT_ID 
GO

*/