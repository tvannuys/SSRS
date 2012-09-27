/* http://www.sql-server-helper.com/functions/trim-leading-zeros.aspx */

-- trim leading Zeros
DECLARE @LeadingZeros    VARCHAR(10)
SET @LeadingZeros = '0000012345'
SELECT @LeadingZeros AS [Leading0s],
       CAST(CAST(@LeadingZeros AS INT) AS VARCHAR(10))
       AS [Trimmed0s]

