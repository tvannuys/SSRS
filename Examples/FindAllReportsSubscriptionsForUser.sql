------------------------------------------------------------------------------------------
--    This will pull a list of all reports the person receives where 
-- their email is in the To, CC, or BCC.  It will NOT however find 
-- any subscriptions where the recipient user is built in a data 
-- driven subscription.
-- http://www.bidn.com/blogs/Daniel/ssas/1708/find-all-report-subscriptions-for-a-user
-------------------------------------------------------------------------------------------

USE ReportServer
GO


DECLARE @Email VARCHAR(50)
SET @Email = 'mharchuck@pacmat.com'
			
			
SELECT cat.[Path]
	,cat.[Name]
	,sub.SubscriptionID
FROM dbo.Catalog AS cat
	INNER JOIN dbo.Subscriptions AS sub
		ON cat.ItemID = sub.Report_OID
WHERE extensionSettings LIKE '%' + @Email + '%'	
ORDER BY cat.[Path]
	,cat.[Name]
