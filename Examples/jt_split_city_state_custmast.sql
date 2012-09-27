--=========================================================== 
-- James Tuttle  4/22/2011
-- 
-- Split the City and State from CMADR3 in CUSTMAST Table
--===========================================================



select *, CMADR3, 
	rtrim(reverse(substring(reverse(CMADR3),3,len(CMADR3)))) City,
	reverse(left(reverse(CMADR3),2)) State
from pubs.dbo.GSFL2K_CUSTMAST

