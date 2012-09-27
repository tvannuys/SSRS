

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IRRComments]') AND type in (N'U'))
DROP TABLE [dbo].[IRRComments]
GO


select Company,
Location,
[Order],
Release,
STTSEQ,
Comment1,
Comment2

into IRRComments

from openquery(GSFL2K,'
select STCO as Company,
STLOC as Location,
STORD# as Order,
STREL# as Release,
STTSEQ,
STCMT1 as Comment1,
STCMT2 as Comment2

from shtext
left join shhead on shtext.stco = shhead.shco
      and shtext.stloc = shhead.shloc
      and shtext.stord# = shhead.shord#
      and shtext.strel# = shhead.shrel#
      and shtext.stcust = shhead.shcust
where shotyp in (''IR'',''RI'')
and shidat >= ''01/01/2011''

')

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IRRCommentSummary]') AND type in (N'U'))
DROP TABLE [dbo].[IRRCommentSummary]
GO


SELECT Company,
Location,
[Order],
Release
, SUBSTRING(
      (SELECT ', ' + comment1 + ', ' + comment2
      FROM IRRComments e2
    WHERE e2.[order] = e1.[order]
    FOR XML PATH(''))
  , 2, 999) AS Comments

into IRRCommentSummary

FROM IRRComments e1

GROUP BY Company,
Location,
[Order],
Release

SELECT * FROM IRRCommentSummary