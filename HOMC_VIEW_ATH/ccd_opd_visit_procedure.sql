

CREATE  FUNCTION [dbo].[ccd_opd_visit_procedure]
(	
	-- Add the parameters for the function here
	@SDATE char(8),
	@EDATE char(8)
)
RETURNS TABLE 
AS
RETURN 
(


SELECT     ctl.PCUCODE AS hospcode
,  LTRIM(o.hn) AS hn
,o.regNo AS vn 
,d.ICDCode as icdcm
,ICDCM1.DES as proced_name
,'' proced_type
,dc.CID

 
 FROM         dbo.OPD_H AS o  (nolock) 
inner  JOIN  dbo.PATDIAG AS d (nolock) ON d.Hn = o.hn AND d.regNo = o.regNo  and d.DiagType= 'P'   and dxtype in ('1','4')   
inner join  ICDCM1  (nolock) on ICDCM1.CODE=d.ICDCode
inner  JOIN  PPOP_PROVIDER AS dc (nolock) ON dc.PROVIDER = d.DocCode                                                     
LEFT JOIN    dbo.PPOP_CON AS ctl (nolock) ON ctl.CON_KEY = '000'

WHERE o.ipdStatus ='0'
and  o.registDate between @SDATE and @EDATE

)



GO


select * from ICDCM1