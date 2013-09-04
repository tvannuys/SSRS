/* SR 13000

Uses CUSTSEG table to identify key customers

*/

select *,CONVERT(datetime, CONVERT(VARCHAR(10), shidat)) as InvoiceDate
from openquery(gsfl2k,'
select  shco,shloc,shord#,shrel#,
shinv#,
shidat,
billto.cmcust,
billto.cmname,
smname,

case
	when csgcus is not null then ''Key Customer''
	else '' ''
end as KeyCustomer,

case 
	when pcprcd = 22900 then ''BBoss Sentinel''
	when pcprcd = 13708 then ''Gala Lake Series''
	when pcprcd in (32607,32608) then ''Swiff Train Lancaster LVT''
	when pcprcd = 32542 then ''Swiff Train EW Camden''
	when pcprcd = 70024 then ''ARM Rejuvenations''
	when pcprcd in (70236,70237,70238,70239) then ''ARM Natural Creations''
	when pcprcd in (70020,70035) then ''ARM Medintech''	
	when pcprcd = 66053 then ''ARM Liberty 150 Glasback''
	when pcprcd = 13431 then ''Greenfield Aspen''	
	when pcprcd = 13430 then ''Greenfield Tahoe''	

	when imfmcd = ''Y2'' then ''Armstrong VCT''
	when imfmcd in (''Y9'',''Y!'') then ''Armstrong Linoleum''
	
	else pcdesc
	
end as ReportProductDesc,

SLECST+SLESC1+SLESC2+SLESC3+SLESC4+SLESC5 as ExtendedCost,
sleprc as ExtendedPrice

from shline
		
		left JOIN SHHEAD ON (SHLINE.SLCO = SHHEAD.SHCO 
									AND SHLINE.SLLOC = SHHEAD.SHLOC 
									AND SHLINE.SLORD# = SHHEAD.SHORD# 
									AND SHLINE.SLREL# = SHHEAD.SHREL# 
									AND SHLINE.SLINV# = SHHEAD.SHINV#) 
		left JOIN CUSTMAST billto ON SHHEAD.SHBIL# = billto.CMCUST 
		left join custmast soldto on shhead.shcust = soldto.cmcust
		LEFT JOIN ITEMMAST ON SHLINE.SLITEM = ITEMMAST.IMITEM 
		LEFT JOIN PRODCODE ON SHLINE.SLPRCD = PRODCODE.PCPRCD 
		left join salesman on shline.SLSLMN = salesman.smno
		left join CUSTSEG on (csgcus = billto.cmcust and csgsgc = ''P('')
		
		
where (slprcd in (22900,13708,32607,32608,32542,70024,70236,70237,70238,70239,70020,70035,66053,13431,13430) 
		or
	   imfmcd in (''Y2'',''Y9'',''Y!'')
	   )
/* and imfmcd not in (''B1'',''Y6'') */
/* and (year(sldate)=year(current_date - 1 month) and month(sldate)=month(current_date)-1) -- REMOVED IN LIEU OF YTD DATA REQUEST FROM KATHY */

and year(shidat) = year(current_date)

and shco=2
and smname not in (''PACMAT HOUSE'',''CLOSED ACCOUNTS'',''DEVELOPMENTAL/SALES MGRS'',''BLOW OUT ORDERS'')  

')

where shidat <= DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()),0))


union all

select *,CONVERT(datetime, CONVERT(VARCHAR(10), shidat)) as InvoiceDate
from openquery(gsfl2k,'
select  0 as shco,
0 as shloc,
0 as shord#,
0 as shrel#,
''000000'' as shinv#,
current_date - 10 days as shidat,
billto.cmcust,
billto.cmname,
smname,

case
	when csgcus is not null then ''Key Customer''
	else '' ''
end as KeyCustomer,

''BBoss Sentinel'' as ReportProductDesc,

0 as ExtendedCost,
0 as ExtendedPrice

from custmast billto
left join CUSTSEG on (csgcus = billto.cmcust and csgsgc = ''P('')
left join salesman on CMSLMN = salesman.smno

where cmco = 2
and smname not in (''PACMAT HOUSE'',''CLOSED ACCOUNTS'',''DEVELOPMENTAL/SALES MGRS'',''BLOW OUT ORDERS'')  

')

/*  Key Customer reference

where (slprcd in (22900,55035,55045,70911,70534,70775,70780,70086,70116,70121,32568,32582,32556,32542,32541,32543,32512,32513,32604,32600,32602) 
		or slprcd between 52030 and 52038
		or slprcd between 52780 and 52785
	   )



and billto.cmcust in (''4110277'',
''4107953'',
''4120258'',
''4120731'',
''4103033'',
''4111414'',
''4120260'',
''4120257'',
''4110713'',
''4120264'',
''4120259'',
''4125393'',
''4112140'',
''4110264'',
''4124270'',
''4113007'',
''4110155'',
''4121956'',
''4111328'',
''4110378'',
''4120743'',
''4110930'',
''4113240'',
''4111018'',
''4111487'',
''4111469'',
''4113127'',
''4120677'',
''4111450'',
''4112346'',
''4120904'',
''4120465'',
''4110053'',
''4110252'',
''4124106'',
''4121948'',
''4110869'',
''4112113'',
''4109749'',
''4100758'',
''4109459'',
''4109878'',
''4109753'',
''4124789'',
''4110463'',
''4117422'',
''4121461'',
''4109967'',
''4122052'',
''4110598'',
''4122056'',
''4117220'',
''4111669'',
''4111244'',
''4111502'',
''4108802'',
''4109994'',
''4109900'',
''4116228'',
''4110137'',
''4111243'',
''4120332'',
''4110103'',
''4120742'',
''4110826'',
''4121439'',
''4109490'',
''4110145'',
''4111753'',
''4120162'',
''4109670'',
''4120000'',
''4110204'',
''4102332'',
''4122332'',
''4114098'',
''4120100'',
''4114855'',
''4106686'',
''4120084'',
''4120083'',
''4106678'',
''4114549'',
''4120981'',
''4114977'',
''4107200'',
''4100131'',
''4104588'',
''4107701'',
''4120320'',
''4107572'',
''4107632'',
''4103165'',
''4101375'',
''4122084'',
''4122925'',
''4114029'',
''4121739'',
''4124390'',
''4101786'',
''4107770'',
''4140350'',
''4100097'',
''4101785'',
''4100761'',
''4101787'',
''4100838'',
''4140368'',
''4121514'',
''4105951'',
''4116025'',
''4101341'',
''4107992'',
''4117272'',
''4140249'',
''4108204'',
''4120497'',
''4116209'',
''4140647'',
''4114628'',
''4120112'',
''4106536'',
''4125348'',
''4108288'',
''4141691'',
''4141993'',
''4120736'',
''4101947'',
''4121243'',
''4115767'',
''4102179'',
''4120916'',
''4116100'',
''4102202'',
''4100354'',
''4101197'',
''4120129'',
''4104231'',
''4120186'',
''4103128'',
''4109100'',
''4113323'',
''4100373'',
''4120386'',
''4113581'',
''4101447'',
''4100144'',
''4121405'',
''4125484'',
''4120909'',
''4106958'',
''4116100'',
''4120736'',
''4121243'',
''4120916'',
''4119014'',
''4101041'',
''4114746'',
''4113323'',
''4115767'',
''4120052'',
''4101236'',
''4100354'',
''4101454'',
''4102353'',
''4100144'',
''4100229'',
''4103128'',
''4121405'',
''4124222'',
''4104231'',
''4102202'',
''4106921'',
''4120557'',
''4120386'',
''4105141'',
''4120186'',
''4102869'',
''4120530'',
''4130382'',
''4100885'',
''4120035'',
''4100382'',
''4101034'',
''4100627'',
''4104152'',
''4102508'',
''4100667'',
''4120256'',
''4108859'',
''4108342'',
''4120096'',
''4120261'',
''4106269'',
''4115169'',
''4101122'',
''4120094'',
''4104087'',
''4120092'',
''4112868'',
''4105050'',
''4101496'',
''4100099'',
''4112850'',
''4104105'',
''4120262'',
''4123992'',
''4107314'',
''4120091'',
''4115048'',
''4120148'',
''4120825'',
''4100028'',
''4103470'',
''4120512'',
''4103895'',
''4101058'',
''4104244'',
''4114781'',
''4105158'',
''4120098'',
''4100521'',
''4120066'',
''4122606'',
''4100985'',
''4114854'',
''4107644'',
''4120097'',
''4100203'',
''4105652'',
''4102328'',
''4112402'',
''4120390'',
''4120816'',
''4102394'',
''4114630'',
''4116788'',
''4107447'',
''4121216'',
''4120095'',
''4108847'',
''4112480'',
''4120168'',
''4109009'',
''4120018'',
''4122044'',
''4101906'',
''4120089'',
''4100791'',
''4101402'',
''4120263'',
''4106564'',
''4106218'',
''4120081'',
''4124517'',
''4106244'',
''4114383'',
''4106270'',
''4140836'',
''4113308'',
''4120130'',
''4111017'',
''4116224'',
''4114323'',
''4117270'',
''4120545'',
''4141284'',
''4142084'',
''4106712'',
''4141698'',
''4140340'',
''4140581'',
''4106573'',
''4108218'',
''4116219'',
''4114347'',
''4142111'',
''4114800'',
''4107856'',
''4120394'',
''4117280'',
''4116401'',
''4120747'',
''4111436'',
''4111698'',
''4110241'',
''4110213'',
''4113538'',
''4120622'',
''4109838'',
''4110545'',
''4109635'',
''4109860'',
''4117007'',
''4117423'',
''4111251'',
''4110122'',
''4109574'',
''4117419'',
''4106412'',
''4112233'',
''4102179'',
''4101947'',
''4101197'',
''4120129'',
''4100373'',
''4125484'',
''4100023'',
''4100074'',
''4119430'',
''4101489'',
''4110203'',
''4107423'',
''4103775'',
''4114448'',
''4120080'',
''4116427'',
''4100584'',
''4110102'',
''4113333'',
''4102104'',
''4100226'',
''4100528'',
''4120207'',
''4102103'',
''4101884'',
''4124113'',
''4109487'',
''4100161'',
''4120049'',
''4104812'',
''4123877'',
''4104533'',
''4105932'',
''4113546'',
''4102161'',
''4121525'',
''4110650'',
''4107511'',
''4120048'',
''4102193'',
''4107971'',
''4100833'',
''4120210'',
''4100070'',
''4100610'',
''4115458'',
''4106023'',
''4100849'',
''4122171'',
''4106005'',
''4120999'',
''4105069'',
''4116295'',
''4100059'',
''4100409'',
''4105742'',
''4122989'',
''4116794'',
''4105045'',
''4115018'',
''4104358'',
''4101221'',
''4102780'',
''4113369'',
''4124391'',
''4121019'',
''4125197'',
''4100866'',
''4104693'',
''4100660'',
''4102143'',
''4106343'',
''4113739'',
''4104780'',
''4104162'',
''4108466'',
''4102142'',
''4106674'',
''4108267'',
''4106826'',
''4120064'',
''4116106'',
''4113647'',
''4105210'',
''4103239'',
''4112296'',
''4124709'',
''4111676'',
''4121487'',
''4111523'',
''4109759'',
''4122539'',
''4112503'',
''4110854'',
''4117714'',
''4120483''
)

*/

