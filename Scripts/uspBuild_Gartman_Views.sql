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
	CREATE view [dbo].[OOHEAD] as 
	select *
	from openquery(gsfl2k,'
	select *
	from OOHEAD
	fetch first 1 row only
	')
	GO;
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.OOLINE', 'V') IS NOT NULL
	DROP VIEW dbo.OOLINE ;
	GO
	-- Create View
	CREATE view [dbo].[OOLINE] as 
	select *
	from openquery(gsfl2k,'
	select *
	from OOLINE
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.CUSTBGRP', 'V') IS NOT NULL
	DROP VIEW dbo.CUSTBGRP ;
	GO
	-- Create View
	CREATE view [dbo].[CUSTBGRP] as 
	select *
	from openquery(gsfl2k,'
	select *
	from CUSTBGRP
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.CUSTBILL', 'V') IS NOT NULL
	DROP VIEW dbo.CUSTBILL ;
	GO
	-- Create View
	CREATE view [dbo].[CUSTBILL] as 
	select *
	from openquery(gsfl2k,'
	select *
	from CUSTBILL
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.CUSTCLAS', 'V') IS NOT NULL
	DROP VIEW dbo.CUSTCLAS ;
	GO
	-- Create View
	CREATE view [dbo].[CUSTCLAS] as 
	select *
	from openquery(gsfl2k,'
	select *
	from CUSTCLAS
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.CUSTCNDTL', 'V') IS NOT NULL
	DROP VIEW dbo.CUSTCNDTL ;
	GO
	-- Create View
	CREATE view [dbo].[CUSTCNDTL] as 
	select *
	from openquery(gsfl2k,'
	select *
	from CUSTCNDTL
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.CUSTCONT', 'V') IS NOT NULL
	DROP VIEW dbo.CUSTCONT ;
	GO
	-- Create View
	CREATE view [dbo].[CUSTCONT] as 
	select *
	from openquery(gsfl2k,'
	select *
	from CUSTCONT
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.CUSTEPR', 'V') IS NOT NULL
	DROP VIEW dbo.CUSTEPR ;
	GO
	-- Create View
	CREATE view [dbo].[CUSTEPR] as 
	select *
	from openquery(gsfl2k,'
	select *
	from CUSTEPR
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.CUSTEXTN', 'V') IS NOT NULL
	DROP VIEW dbo.CUSTEXTN ;
	GO
	-- Create View
	CREATE view [dbo].[CUSTEXTN] as 
	select *
	from openquery(gsfl2k,'
	select *
	from CUSTEXTN
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.CUSTMAST', 'V') IS NOT NULL
	DROP VIEW dbo.CUSTMAST ;
	GO
	-- Create View
	CREATE view [dbo].[CUSTMAST] as 
	select *
	from openquery(gsfl2k,'
	select *
	from CUSTMAST
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.CUSTMKTG', 'V') IS NOT NULL
	DROP VIEW dbo.CUSTMKTG ;
	GO
	-- Create View
	CREATE view [dbo].[CUSTMKTG] as 
	select *
	from openquery(gsfl2k,'
	select *
	from CUSTMKTG
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.CUSTVEND', 'V') IS NOT NULL
	DROP VIEW dbo.CUSTVEND ;
	GO
	-- Create View
	CREATE view [dbo].[CUSTVEND] as 
	select *
	from openquery(gsfl2k,'
	select *
	from CUSTVEND
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.CUSTXTRA', 'V') IS NOT NULL
	DROP VIEW dbo.CUSTXTRA ;
	GO
	-- Create View
	CREATE view [dbo].[CUSTXTRA] as 
	select *
	from openquery(gsfl2k,'
	select *
	from CUSTXTRA
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.ITEMMAST', 'V') IS NOT NULL
	DROP VIEW dbo.ITEMMAST ;
	GO
	-- Create View
	CREATE view [dbo].[ITEMMAST] as 
	select *
	from openquery(gsfl2k,'
	select *
	from ITEMMAST
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.ITEMRECH', 'V') IS NOT NULL
	DROP VIEW dbo.ITEMRECH ;
	GO
	-- Create View
	CREATE view [dbo].[ITEMRECH] as 
	select *
	from openquery(gsfl2k,'
	select *
	from ITEMRECH
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.ITEMXTRA', 'V') IS NOT NULL
	DROP VIEW dbo.ITEMXTRA ;
	GO
	-- Create View
	CREATE view [dbo].[ITEMXTRA] as 
	select *
	from openquery(gsfl2k,'
	select *
	from ITEMXTRA
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.OOHEAD', 'V') IS NOT NULL
	DROP VIEW dbo.OOHEAD ;
	GO
	-- Create View
	CREATE view [dbo].[OOHEAD] as 
	select *
	from openquery(gsfl2k,'
	select *
	from OOHEAD
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.OOLINE', 'V') IS NOT NULL
	DROP VIEW dbo.OOLINE ;
	GO
	-- Create View
	CREATE view [dbo].[OOLINE] as 
	select *
	from openquery(gsfl2k,'
	select *
	from OOLINE
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.OOLRFHST', 'V') IS NOT NULL
	DROP VIEW dbo.OOLRFHST ;
	GO
	-- Create View
	CREATE view [dbo].[OOLRFHST] as 
	select *
	from openquery(gsfl2k,'
	select *
	from OOLRFHST
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.POHEAD', 'V') IS NOT NULL
	DROP VIEW dbo.POHEAD ;
	GO
	-- Create View
	CREATE view [dbo].[POHEAD] as 
	select *
	from openquery(gsfl2k,'
	select *
	from POHEAD
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.POLINE', 'V') IS NOT NULL
	DROP VIEW dbo.POLINE ;
	GO
	-- Create View
	CREATE view [dbo].[POLINE] as 
	select *
	from openquery(gsfl2k,'
	select *
	from POLINE
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.SHHEAD', 'V') IS NOT NULL
	DROP VIEW dbo.SHHEAD ;
	GO
	-- Create View
	CREATE view [dbo].[SHHEAD] as 
	select *
	from openquery(gsfl2k,'
	select *
	from SHHEAD
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.SHLINE', 'V') IS NOT NULL
	DROP VIEW dbo.SHLINE ;
	GO
	-- Create View
	CREATE view [dbo].[SHLINE] as 
	select *
	from openquery(gsfl2k,'
	select *
	from SHLINE
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.VENDMAST', 'V') IS NOT NULL
	DROP VIEW dbo.VENDMAST ;
	GO
	-- Create View
	CREATE view [dbo].[VENDMAST] as 
	select *
	from openquery(gsfl2k,'
	select *
	from VENDMAST
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.[ROUTE]', 'V') IS NOT NULL
	DROP VIEW dbo.[ROUTE] ;
	GO
	-- Create View
	CREATE view [dbo].[ROUTE] as 
	select *
	from openquery(gsfl2k,'
	select *
	from [ROUTE]
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.OOROUTE', 'V') IS NOT NULL
	DROP VIEW dbo.OOROUTE ;
	GO
	-- Create View
	CREATE view [dbo].[OOROUTE] as 
	select *
	from openquery(gsfl2k,'
	select *
	from OOROUTE
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.QSHEAD', 'V') IS NOT NULL
	DROP VIEW dbo.QSHEAD ;
	GO
	-- Create View
	CREATE view [dbo].[QSHEAD] as 
	select *
	from openquery(gsfl2k,'
	select *
	from QSHEAD
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.HQSHEAD', 'V') IS NOT NULL
	DROP VIEW dbo.HQSHEAD ;
	GO
	-- Create View
	CREATE view [dbo].[HQSHEAD] as 
	select *
	from openquery(gsfl2k,'
	select *
	from HQSHEAD
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.HQSLINE', 'V') IS NOT NULL
	DROP VIEW dbo.HQSLINE ;
	GO
	-- Create View
	CREATE view [dbo].[HQSLINE] as 
	select *
	from openquery(gsfl2k,'
	select *
	from HQSLINE
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.QSLINE', 'V') IS NOT NULL
	DROP VIEW dbo.QSLINE ;
	GO
	-- Create View
	CREATE view [dbo].[QSLINE] as 
	select *
	from openquery(gsfl2k,'
	select *
	from QSLINE
	fetch first 1 row only
	')
	GO
---------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.QSTEXT', 'V') IS NOT NULL
	DROP VIEW dbo.QSTEXT ;
	GO
	-- Create View
	CREATE view [dbo].[QSTEXT] as 
	select *
	from openquery(gsfl2k,'
	select *
	from QSTEXT
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------
---------------------------------------------------------------------------
	-- Drop View if EXIST
	IF OBJECT_ID ('dbo.HQSTEXT', 'V') IS NOT NULL
	DROP VIEW dbo.HQSTEXT ;
	GO
	-- Create View
	CREATE view [dbo].[HQSTEXT] as 
	select *
	from openquery(gsfl2k,'
	select *
	from HQSTEXT
	fetch first 1 row only
	')
	GO
--------------------------------------------------------------------------

END
