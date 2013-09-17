
 ALTER PROC JT_factory_order_hourly_alert AS
/*----------------------------------------------------------*
**															*
**	Converted from Eurisko VFP Reports						*
**  By: James Tuttle			Date: 08/22/2011			*
**															*
**	Report is testing for order location and Print Location *
**  are not equal.											*
**															*
**----------------------------------------------------------*/
-- Date		  By			 Ticket#/Description
-- =========  =============  ===============================
-- 9/17/2013  James Tuttle    SR# 14244 
-- Took out the ROW COUNT and will add the PARM in the SSRS 
-- to control a zero count and not email the subscription
-------------------------------------------------------------

--DECLARE @Rows INT

--SELECT @Rows = -1

-- see if any orders meet the condition
SELECT *
FROM OPENQUERY (GSFL2K, 'SELECT ohco as Company,
								ohloc as Location,
								ohord# as Order,
								ohrel# as Release,
								ohotyp as Type
						FROM oohead
						WHERE ohloc != ohprlo
							AND ohotyp = ''FO''
							AND ohodat = CURRENT_DATE
				')
-- Check row count. If nothing returned from the main Select
-- Then this will throw the Error so SSRS will not send an
-- empty email every hour.
-- users will only get an email if there is atleast one record
				
--SELECT @Rows = @@ROWCOUNT 
--IF ( @Rows < 1)
--BEGIN
--	RAISERROR ('No rows returned', 11, 1);
--END
 						





