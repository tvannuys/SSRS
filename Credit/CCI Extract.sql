/* Embedded SQL used in CCI Extract Report for Credit  */

select * from openquery(gsfl2k,'

select 
/* FIELD 1 */
''C'' as RecordCode,
/* FIELD 2 */
''49924'' as MemberID,
/* FIELD 3 */
cmname as AccountName,
/* FIELD 4 */
cmname as DBA,
/* FIELD 5 */
cmadr1,
/* FIELD 6 */
cmadr2,
/* FIELD 7 */
Left(CMADR3,23) AS City, 
/* FIELD 8 */
CMZIP AS ZipCode, 
/* FIELD 9 */
Right(CMADR3,2) AS State, 
/* FIELD 10 */
substring(char(current_date),6,2) || right(char(current_date),2) || substring(char(current_date),3,2) as ExtractDate,
/* FIELD 11 */
'' '' as Reserved1,
/* FIELD 12 */
CMPHON as Phone,
/* FIELD 13 */
substring(char(CMLSAL),6,2) || substring(char(CMLSAL),3,2) as LastSale,

/* FIELD 14 */
case CMTERM 
	when ''2'' then ''COD''
	when ''Y'' then ''CBD''
	else ''   ''
end as Terms,

/* Field 15 */
''0'' as HighCreditCode,
/* Field 16 */
CMHICR as HighCredit,
/* Field 17 */
''0'' as AccountBalanceCode,
/* Field 18 */
CMCRAM as AccountBalance,
/* Field 19 */
''0'' as AccountBalanceSign,
/* Field 20 */
CMCUR as CurrentBalance,
/* Field 21 */
''0'' as CurrentBalanceSign,
/* Field 22 */
CMU30 as ThirtyDayBalance,
/* Field 23 */
''0'' as ThirtyDayBalanceSign,
/* Field 24 */
CMO30 as SixtyDayBalance,
/* Field 25 */
''0'' as SixtyDayBalanceSign,
/* Field 26 */
CMO60 as NinetyDayBalance,
/* Field 27 */
''0'' as NinetyDayBalanceSign,
/* Field 28 */
CMO90 as OverNinetyBalance,
/* Field 29 */
''0'' as OverNinetyBalanceSign,

/* Field 30 */
case 
	when (select max(days(current_date)-days(oidsd1)) from OPENITEM where OICUST = custmast.cmcust and oitype not in (''RA'',''RI'',''CS'',''CL'')) is null then ''05'' 
	when (select max(days(current_date)-days(oidsd1)) from OPENITEM where OICUST = custmast.cmcust and oitype not in (''RA'',''RI'',''CS'',''CL'')) <= 5 then ''05'' 
	when (select max(days(current_date)-days(oidsd1)) from OPENITEM where OICUST = custmast.cmcust and oitype not in (''RA'',''RI'',''CS'',''CL'')) <= 30 then ''02''
	else ''01''
end as PaymentHistory,

/* Field 31 */
case 
	when (select max(days(current_date)-days(oidsd1)) from OPENITEM where OICUST = custmast.cmcust and oitype not in (''RA'',''RI'',''CS'',''CL'')) is null then ''00'' 
	when (select max(days(current_date)-days(oidsd1)) from OPENITEM where OICUST = custmast.cmcust and oitype not in (''RA'',''RI'',''CS'',''CL'')) <= 5 then ''00'' 
	else (select max(days(current_date)-days(oidsd1)) from OPENITEM where OICUST = custmast.cmcust and oitype not in (''RA'',''RI'',''CS'',''CL''))
end as DaysSlow,

/* Field 32 */
''000'' as CountryCode,
/* Field 33 */
''0000'' as CityCode,
/* Field 34 */
''00000000000000'' as Rerserved2,
/* Field 35 */
''               '' as Rerserved3,
/* Field 36 */
''0'' as Rerserved4

from custmast

where cmcust in (select b.cmcust
from custmast B 
where ((b.cmcust = b.cmbill) or cmbill = '' '')
and b.cmco = 1
and b.cmdelt <> ''H'')
')
