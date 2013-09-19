SELECT oq.*,
TR.itupcg as UpchargePerc,
TotalWeight * TR.itupcg as UpchargeDollars

FROM OPENQUERY(GSFL2K, 
      'SELECT it.itico as FromCompany
			,it.itiloc as FromLocation
			,it.itpco as ToCompany  /* [P]hysical Co(where the inventory is transfereed to) */
            ,it.itploc  as ToLocation/* [P]hysical Loc(where the inventory is transfereed to) */
            ,SUM(im.imwght * it.itqty) AS TotalWeight
        
            
      FROM tranfdatex it
      LEFT JOIN itemmast im ON im.imitem = it.ititem
      
      WHERE MONTH(it.itdate) = 7
            AND YEAR(it.itdate) = ''2013''
      
      GROUP BY itico
			  ,itiloc 
			  ,itpco
              ,itploc

      ORDER BY itpco
              ,itploc

      ') oq

left join TransferRate TR on (oq.FromCompany = TR.itico
						  and oq.FromLocation = TR.itiloc
						  and oq.ToCompany = TR.itpco
						  and oq.ToLocation = TR.itploc)
