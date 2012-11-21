select * from openquery(gsfl2k,'
select ''C'' as RecordCode,
''49924'' as MemberID,
cmname as AccountName,
cmname as DBA,
cmadr1,
cmadr2,
Left(CMADR3,23) AS City, 
CMZIP AS ZipCode, 
Right(CMADR3,2) AS State, 
current_date as ExtractDate,
'' '' as Reserved1,
CMPHON as Phone,
CMLSAL as LastSale,
CMTERM as Terms,
''0'' as HighCreditCode,
CMHICR as HighCredit,
''0'' as AccountBalanceCode,
CMCRAM as AccountBalance,
''0'' as AccountBalanceSign,
CMCUR as CurrentBalance,
''0'' as CurrentBalanceSign,
CMU30 as ThirtyDayBalance,
''0'' as ThirtyDayBalanceSign,
CMO30 as SixtyDayBalance,
''0'' as SixtyDayBalanceSign,
CMO60 as NinetyDayBalance,
''0'' as NinetyDayBalanceSign,
CMO90 as OverNinetyBalance,
''0'' as OverNinetyBalanceSign,
''05'' as PaymentHistory,
CMPDAY as DaysSlow,
''   '' as CountryCode,
''   '' as CityCode,
''    '' as Rerserved2,
''              '' as Rerserved3,
''                                '' as Rerserved4,
'' '' as Rerserved5


from custmast



where cmcust in (
''4112140'',
''6100012'',
''1006825'',
''1012140'',
''4106826'',
''1006829'',
''4106824'',
''1006824'',
''1006826'')
')