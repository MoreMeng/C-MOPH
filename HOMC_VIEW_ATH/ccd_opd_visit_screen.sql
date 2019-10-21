
CREATE      FUNCTION [dbo].[ccd_opd_visit_screen]
(	
	-- Add the parameters for the function here
	@SDATE char(8),
	@EDATE char(8)
)
RETURNS TABLE 
AS
RETURN 
(

SELECT    ctl.PCUCODE as hospcode
,  LTRIM(o.hn) AS hn
,o.regNo AS vn 
,v.Symtom as cc
,''as hpi
,case when  CONVERT (decimal(18,0), ISNULL ( (CONVERT(float,v.Lbloodpress))  ,'0.00')) ='0' then null
   else CONVERT (decimal(18,0), ISNULL ( (CONVERT(float,v.Lbloodpress))  ,'0.00'))  end as dbp
 ,case when  CONVERT (decimal(18,0), ISNULL ( (CONVERT(float,v.Hbloodpress ))  ,'0.00')) ='0' then null
   else CONVERT (decimal(18,0), ISNULL ( (CONVERT(float,v.Hbloodpress ))  ,'0.00')) end    as sbp
,case when CONVERT (decimal(18,0), ISNULL ( (CONVERT(float,v.Pulse ))  ,'0.00'))='0' then null
   else CONVERT (decimal(18,0), ISNULL ( (CONVERT(float,v.Pulse ))  ,'0.00')) end as pulse
,case when  CONVERT (decimal(18,0), ISNULL ( (CONVERT(float,v.Breathe ))  ,'0.00'))='0' then null 
   else CONVERT (decimal(18,0), ISNULL ( (CONVERT(float,v.Breathe ))  ,'0.00')) end as  respiratory_rate

,LTRIM(STR(v.Temperature, 4, 1))  as temperature
,case when  CONVERT (decimal(18,2), ISNULL ( (CONVERT(float,v.Weight))  ,'0.00')) ='0' then null
   else CONVERT (decimal(18,2), ISNULL ( (CONVERT(float,v.Weight))  ,'0.00'))  end as weight
 ,case when  CONVERT (decimal(18,2), ISNULL ( (CONVERT(float,v.Height ))  ,'0.00')) ='0' then null
   else CONVERT (decimal(18,2), ISNULL ( (CONVERT(float,v.Height ))  ,'0.00')) end    as height 

,case when (v.Weight is not null and v.Height is not null ) then convert(decimal(18,2), (CONVERT(float,v.Weight))  /(power((v.Height *.01),2 )) )
else 0 end as bmi
,case when  CONVERT (decimal(18,2), ISNULL ( (CONVERT(float,v.Waist))  ,'0.00')) ='0' then null
   else CONVERT (decimal(18,2), ISNULL ( (CONVERT(float,v.Waist))  ,'0.00'))  end as waist
,v.Treatment as pe
,case v.Alchohol when 'Y' then '1'
                 when NULL then 'NA'
				 else '2' end  as alcohol_use
,case v.Smoke    when 'Y' then '1'
                 when NULL then 'NA'
				 else '2' end   as cigar_use 
,''as pregnant
,''as lactation
,''as pain_score
,''as note 



FROM  dbo.OPD_H AS o (nolock) 
       LEFT  JOIN  SSREGIST v  (nolock) on v.hn=o.hn and v.RegNo=o.regNo
       LEFT JOIN   PPOP_CON AS ctl ON ctl.CON_KEY = '000' 
   
--where  registDate between '25611002' and '25611002'
where  registDate between @SDATE and @EDATE  
and exists (select * from Bill_h h(nolock) where o.hn=h.hn and o.regNo=h.regNo)
and not exists (select * from PPOP_DEATH D (nolock)  where D.HN=o.hn and o.registDate>D.DDEATH)

  
  )

GO


