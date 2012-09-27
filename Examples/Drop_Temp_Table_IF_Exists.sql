

/* DROP a temp table if exists */

IF EXISTS(SELECT * FROM tempdb.dbo.sysobjects WHERE ID = OBJECT_ID (N'tempdb..#TempTable'))
	BEGIN
		DROP TABLE #TempTable
	END;