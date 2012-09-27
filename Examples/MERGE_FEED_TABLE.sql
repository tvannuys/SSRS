
 
 --SELECT * FROM [Grant] 
 
 --SELECT * FROM [GrantFeed] 
 
 MERGE [Grant] as gr
 USING GrantFeed as gf
 ON gr.GrantID = gf.GrantID
 WHEN MATCHED THEN
	UPDATE SET gr.GrantID = gf.GrantID, gr.GrantName = gf.GrantName,
		gr.Amount=gf.Amount
 WHEN NOT MATCHED THEN
	INSERT (GrantID, GrantName, EmpID, AMount)
	VALUES(gf.GrantID, gf.GrantName, gf.EmpID, gf.Amount);