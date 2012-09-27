
--SELECT * 
--FROM [Grant]

--EXEC UpdateGrant '011','Bigg Giver Tom',7,95900


CREATE PROC UpsertGrant1
@GrID char(3), @GrName varchar(50),
@EmpID int, @Amt smallmoney
AS
BEGIN
	MERGE [Grant] as gr
	USING (SELECT @GrID, @GrName, @EmpID, @Amt) 
		as src (GrantID, GrantName, EmpID, Amount)
	ON gr.GrantID = src.GrantID
	WHEN MATCHED THEN
		UPDATE SET gr.GrantName = src.GrantName, gr.EmpId = src.EmpID,
		gr.Amount = src.Amount
	WHEN NOT MATCHED THEN
		INSERT (GrantID, GrantName, EmpID, Amount)
		VALUES (src.GrantID, src.GrantName, src.EmpID, src.Amount);
END