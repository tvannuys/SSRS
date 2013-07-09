
-- Recursive CTE 

WITH recursive_CTE AS
(
	SELECT col1
		,col2
		,...
	FROM base_table
	
	UNION ALL
	
	SELECT col1
		,col2
		,...
	FROM base_table
	INNER JOIN recursive_CTE
	ON ...
)