/*********************************************************
**														**
**	SR# 6814											**
**	Programmer: James Tuttle		Date: 01/14/2013	**
** ---------------------------------------------------- **
**	Purpose:	 Script to Drop and create Views from	**
**	selected Gartman tables when needed.				**
**														**
**														**
**														**
**														**
**														**
**********************************************************/


ALTER PROC uspBuild_Gartman_Views AS

---------------------------------------------------------------------------
	
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'OOHEAD')
   DROP VIEW OOHEAD
GO
-- Create View
CREATE VIEW [dbo].[OOHEAD]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from OOHEAD
	fetch first 1 row only
	')
GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'OOLINE')
   DROP VIEW OOLINE
GO
-- Create View
CREATE VIEW [dbo].[OOLINE]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from OOLINE
	fetch first 1 row only
	')
GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'CUSTBGRP')
   DROP VIEW CUSTBGRP
GO
-- Create View
CREATE VIEW [dbo].[CUSTBGRP]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from CUSTBGRP
	fetch first 1 row only
	')
GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'CUSTBILL')
   DROP VIEW CUSTBILL
GO
-- Create View
CREATE VIEW [dbo].[CUSTBILL]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from CUSTBILL
	fetch first 1 row only
	')
GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'CUSTCLAS')
   DROP VIEW CUSTCLAS
GO
-- Create View
CREATE VIEW [dbo].[CUSTCLAS]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from CUSTCLAS
	fetch first 1 row only
	')
GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'CUSTCNDTL')
   DROP VIEW CUSTCNDTL
GO
-- Create View
CREATE VIEW [dbo].[CUSTCNDTL]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from CUSTCNDTL
	fetch first 1 row only
	')
GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'CUSTCONT')
   DROP VIEW CUSTCONT
GO
-- Create View
CREATE VIEW [dbo].[CUSTCONT]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from CUSTCONT
	fetch first 1 row only
	')
GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'CUSTEPR')
   DROP VIEW CUSTEPR
GO
-- Create View
CREATE VIEW [dbo].[CUSTEPR]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from CUSTEPR
	fetch first 1 row only
	')
GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'CUSTEXTN')
   DROP VIEW CUSTEXTN
GO
-- Create View
CREATE VIEW [dbo].[CUSTEXTN]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from CUSTEXTN
	fetch first 1 row only
	')
GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'CUSTMAST')
   DROP VIEW CUSTMAST
GO
-- Create View
CREATE VIEW [dbo].[custmast]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from CUSTMAST
	fetch first 1 row only
	')
GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'CUSTMKTG')
   DROP VIEW CUSTMKTG
GO
-- Create View
CREATE VIEW [dbo].[CUSTMKTG]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from CUSTMKTG
	fetch first 1 row only
	')
GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'CUSTVEND')
   DROP VIEW CUSTVEND
GO
-- Create View
CREATE VIEW [dbo].[CUSTVEND]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from CUSTVEND
	fetch first 1 row only
	')
GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'CUSTXTRA')
   DROP VIEW CUSTXTRA
GO
-- Create View
CREATE VIEW [dbo].[CUSTXTRA]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from CUSTXTRA
	fetch first 1 row only
	')
GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'ITEMMAST')
   DROP VIEW ITEMMAST
GO
-- Create View
CREATE VIEW [dbo].[ITEMMAST]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from ITEMMAST
	fetch first 1 row only
	')
GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'ITEMRECH')
   DROP VIEW ITEMRECH
GO
-- Create View
CREATE VIEW [dbo].[ITEMRECH]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from ITEMRECH
	fetch first 1 row only
	')
GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'ITEMXTRA')
   DROP VIEW ITEMXTRA
GO
-- Create View
CREATE VIEW [dbo].[ITEMXTRA]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from ITEMXTRA
	fetch first 1 row only
	')
GO

--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'OOLRFHST')
   DROP VIEW OOLRFHST
GO
-- Create View
CREATE VIEW [dbo].[OOLRFHST]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from OOLRFHST
	fetch first 1 row only
	')
GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'POHEAD')
   DROP VIEW POHEAD
GO
-- Create View
CREATE VIEW [dbo].[POHEAD]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from POHEAD
	fetch first 1 row only
	')
GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'POLINE')
   DROP VIEW POLINE
GO
-- Create View
CREATE VIEW [dbo].[POLINE]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from POLINE
	fetch first 1 row only
	')
GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'SHHEAD')
   DROP VIEW SHHEAD
GO
-- Create View
CREATE VIEW [dbo].[SHHEAD]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from SHHEAD
	fetch first 1 row only
	')
GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'SHLINE')
   DROP VIEW SHLINE
GO
-- Create View
CREATE VIEW [dbo].[SHLINE]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from SHLINE
	fetch first 1 row only
	')
GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'VENDMAST')
   DROP VIEW VENDMAST
GO
-- Create View
CREATE VIEW [dbo].[VENDMAST]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from VENDMAST
	fetch first 1 row only
	')
GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'ROUTE')
   DROP VIEW [ROUTE]
GO
-- Create View
CREATE VIEW [dbo].[ROUTE]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from ROUTE
	fetch first 1 row only
	')
GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'OOROUTE')
   DROP VIEW OOROUTE
GO
-- Create View
CREATE VIEW [dbo].[OOROUTE]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from OOROUTE
	fetch first 1 row only
	')
GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'QSHEAD')
   DROP VIEW QSHEAD
GO
-- Create View
CREATE VIEW [dbo].[QSHEAD]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from QSHEAD
	fetch first 1 row only
	')
GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'HQSHEAD')
   DROP VIEW HQSHEAD
GO
-- Create View
CREATE VIEW [dbo].[HQSHEAD]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from HQSHEAD
	fetch first 1 row only
	')
GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'HQSLINE')
   DROP VIEW HQSLINE
GO
-- Create View
CREATE VIEW [dbo].[HQSLINE]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from HQSLINE
	fetch first 1 row only
	')
GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'QSLINE')
   DROP VIEW QSLINE
GO
-- Create View
CREATE VIEW [dbo].[QSLINE]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from QSLINE
	fetch first 1 row only
	')
GO
---------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'QSTEXT')
   DROP VIEW QSTEXT
GO
-- Create View
CREATE VIEW [dbo].[QSTEXT]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from QSTEXT
	fetch first 1 row only
	')
GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.VIEWS
         WHERE TABLE_NAME = 'HQSTEXT')
   DROP VIEW HQSTEXT
GO
-- Create View
CREATE VIEW [dbo].[HQSTEXT]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from HQSTEXT
	fetch first 1 row only
	')
GO
--------------------------------------------------------------------------


