
CREATE   FUNCTION [dbo].[ccd_dispense_items]
(	
	-- Add the parameters for the function here
	@SDATE char(8),
	@EDATE char(8)
)
RETURNS TABLE 
AS
RETURN 
(

 SELECT distinct ctl.PCUCODE AS hospcode
,  LTRIM(p.hn) AS hn
,p.registNo AS vn 
,p.invCode as hosp_drug_code
,M.name AS drug_name
,rtrim(L1.lamed_name) +'  '+rtrim(lamedQty)+'  '+rtrim(L2.lamed_name) +'  '+rtrim(lamedTimeText) as drug_usage
, (CONVERT(money,isnull(p.accQty ,0))) AS qty

,rtrim(L2.lamed_name) as unit

, CONVERT(money,isnull(M.opd_prc,0)) AS unit_price
, (CONVERT(money,isnull(p.accAmt ,0))) AS sum_price
, LEFT(ISNULL(g.invGovCode24, M.code) , 24) AS didstd

,dc.TMTID as tmtcode




from  dbo.OPD_H AS o  (nolock) 
inner  JOIN Patmed p with (nolock) on o.hn=p.hn and o.regNo=p.registNo
left join Med_inv M   with (nolock) on p.invCode =  M.code    and  M.site ='1'
left join Lamed L1  with (nolock) on ((L1.lamed_code = '*'+p.lamedHow) or (L1.lamed_code = p.lamedHow)) and (p.lamedHow <>'*.' or p.lamedHow is not null)
left join Lamed L2  with (nolock) on (L2.lamed_code = '!'+p.lamedUnit) or (L2.lamed_code = p.lamedUnit) and (p.lamedUnit <>'!.' or p.lamedUnit is not null)
left join Lamed L3  with (nolock) on (L3.lamed_code = '&'+p.lamedTime) or ( L3.lamed_code = p.lamedTime) and (p.lamedTime <>'&.' or p.lamedTime is not null)
left join Lamed L4  with (nolock) on (L4.lamed_code = '@'+p.lamedSpecial ) or ( L4.lamed_code = p.lamedSpecial ) and (p.lamedSpecial <>'@.' or p.lamedSpecial is not null)
LEFT  JOIN   dbo.Med_Gov24Map AS g  (nolock) ON g.invCode = M.code AND g.invType = 'M'  
left join DRUGCatalog dc (nolock) on dc.hospdcode=M.code
LEFT JOIN    dbo.PPOP_CON AS ctl (nolock) ON ctl.CON_KEY = '000'


WHERE   
o.registDate between @SDATE and @EDATE  
 AND (o.ipdStatus = '0')
and   (p.invType = 'M')

)


GO


