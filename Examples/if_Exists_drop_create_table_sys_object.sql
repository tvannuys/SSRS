

USE [LearnItFirst.com] 
GO

IF EXISTS(
	SELECT * 
	FROM sys.objects
	WHERE object_id = OBJECT_ID('CompanyDepartment')
	 AND schema_id = SCHEMA_ID('dbo')
	 AND type = 'U'
)
DROP TABLE dbo.CompanyDepartment

CREATE TABLE dbo.CompanyDepartment(
	DepartmentID INT NOT NULL IDENTITY(1,1) PRIMARY KEY
	,Name NVARCHAR(255) NOT NULL
	,GroupName NVARCHAR(255) NOT NULL
	,ModifiedDate DATETIME NOT NULL
)

--SELECT * FROM dbo.CompanyDepartment 