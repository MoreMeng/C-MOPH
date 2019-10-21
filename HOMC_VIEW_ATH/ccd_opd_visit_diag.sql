

CREATE  FUNCTION [dbo].[ccd_opd_visit_diag]
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
,d.ICDCode as icd10
,ICD101.DES as diagname
, CASE WHEN DiagType = 'E' THEN '5' ELSE d .dxtype END AS diag_type
,d.DocCode
,dc.CID

 
 FROM         dbo.OPD_H AS o  (nolock) 
inner  JOIN  dbo.PATDIAG AS d (nolock) ON d.Hn = o.hn AND d.regNo = o.regNo  and d.DiagType<>'P'   and dxtype in ('1','4')   
inner join  ICD101  (nolock) on ICD101.CODE=d.ICDCode
inner  JOIN  PPOP_PROVIDER AS dc (nolock) ON dc.PROVIDER = d.DocCode                                                     
LEFT JOIN    dbo.PPOP_CON AS ctl (nolock) ON ctl.CON_KEY = '000'

WHERE o.ipdStatus ='0'
and  o.registDate between @SDATE and @EDATE


)
GO


