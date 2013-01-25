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


CREATE PROC uspBuild_Gartman_Views AS
BEGIN
---------------------------------------------------------------------------
	
-- Drop View if EXIST
	
IF OBJECT_ID ('dbo.OOHEAD', 'V') IS NOT NULL
	
DROP VIEW dbo.OOHEAD ;
GO
-- Create View
CREATE VIEW [dbo].[oohead]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from OOHEAD
	fetch first 1 row only
	')
GO;
--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF OBJECT_ID('dbo.OOLINE', 'V') IS NOT NULL
	DROP VIEW dbo.OOLINE;
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
IF OBJECT_ID('dbo.CUSTBGRP', 'V') IS NOT NULL
	DROP VIEW dbo.CUSTBGRP;
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
IF OBJECT_ID('dbo.CUSTBILL', 'V') IS NOT NULL
	DROP VIEW dbo.CUSTBILL;
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
IF OBJECT_ID('dbo.CUSTCLAS', 'V') IS NOT NULL
	DROP VIEW dbo.CUSTCLAS;
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
IF OBJECT_ID('dbo.CUSTCNDTL', 'V') IS NOT NULL
	DROP VIEW dbo.CUSTCNDTL;
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
IF OBJECT_ID('dbo.CUSTCONT', 'V') IS NOT NULL
	DROP VIEW dbo.CUSTCONT;
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
IF OBJECT_ID('dbo.CUSTEPR', 'V') IS NOT NULL
	DROP VIEW dbo.CUSTEPR;
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
IF OBJECT_ID('dbo.CUSTEXTN', 'V') IS NOT NULL
	DROP VIEW dbo.CUSTEXTN;
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
IF OBJECT_ID('dbo.CUSTMAST', 'V') IS NOT NULL
	DROP VIEW dbo.custmast;
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
IF OBJECT_ID('dbo.CUSTMKTG', 'V') IS NOT NULL
	DROP VIEW dbo.CUSTMKTG;
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
IF OBJECT_ID('dbo.CUSTVEND', 'V') IS NOT NULL
	DROP VIEW dbo.CUSTVEND;
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
IF OBJECT_ID('dbo.CUSTXTRA', 'V') IS NOT NULL
	DROP VIEW dbo.CUSTXTRA;
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
IF OBJECT_ID('dbo.ITEMMAST', 'V') IS NOT NULL
	DROP VIEW dbo.ITEMMAST;
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
IF OBJECT_ID('dbo.ITEMRECH', 'V') IS NOT NULL
	DROP VIEW dbo.ITEMRECH;
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
IF OBJECT_ID('dbo.ITEMXTRA', 'V') IS NOT NULL
	DROP VIEW dbo.ITEMXTRA;
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
IF OBJECT_ID('dbo.OOHEAD', 'V') IS NOT NULL
	DROP VIEW dbo.oohead;
GO
-- Create View
CREATE VIEW [dbo].[oohead]
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
IF OBJECT_ID('dbo.OOLINE', 'V') IS NOT NULL
	DROP VIEW dbo.OOLINE;
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
IF OBJECT_ID('dbo.OOLRFHST', 'V') IS NOT NULL
	DROP VIEW dbo.OOLRFHST;
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
IF OBJECT_ID('dbo.POHEAD', 'V') IS NOT NULL
	DROP VIEW dbo.POHEAD;
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
IF OBJECT_ID('dbo.POLINE', 'V') IS NOT NULL
	DROP VIEW dbo.POLINE;
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
IF OBJECT_ID('dbo.SHHEAD', 'V') IS NOT NULL
	DROP VIEW dbo.SHHEAD;
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
IF OBJECT_ID('dbo.SHLINE', 'V') IS NOT NULL
	DROP VIEW dbo.SHLINE;
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
IF OBJECT_ID('dbo.VENDMAST', 'V') IS NOT NULL
	DROP VIEW dbo.VENDMAST;
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
IF OBJECT_ID('dbo.[ROUTE]', 'V') IS NOT NULL
	DROP VIEW dbo.[ROUTE];
GO
-- Create View
CREATE VIEW [dbo].[ROUTE]
AS
SELECT
	*
FROM OPENQUERY(GSFL2K, '
	select *
	from [ROUTE]
	fetch first 1 row only
	')
GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
-- Drop View if EXIST
IF OBJECT_ID('dbo.OOROUTE', 'V') IS NOT NULL
	DROP VIEW dbo.OOROUTE;
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
IF OBJECT_ID('dbo.QSHEAD', 'V') IS NOT NULL
	DROP VIEW dbo.QSHEAD;
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
IF OBJECT_ID('dbo.HQSHEAD', 'V') IS NOT NULL
	DROP VIEW dbo.HQSHEAD;
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
IF OBJECT_ID('dbo.HQSLINE', 'V') IS NOT NULL
	DROP VIEW dbo.HQSLINE;
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
IF OBJECT_ID('dbo.QSLINE', 'V') IS NOT NULL
	DROP VIEW dbo.QSLINE;
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
IF OBJECT_ID('dbo.QSTEXT', 'V') IS NOT NULL
	DROP VIEW dbo.QSTEXT;
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
IF OBJECT_ID('dbo.HQSTEXT', 'V') IS NOT NULL
	DROP VIEW dbo.HQSTEXT;
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

END
