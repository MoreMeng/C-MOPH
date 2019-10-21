

CREATE  FUNCTION [dbo].[ccd_opd_visit_diag_text]
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
, REPLACE(CASE WHEN s.CardID IS NULL or  s.CardID  = '' THEN s.CardID ELSE s.CardID END, '-', '') AS cid
,d.DiagNote as diag_text

 
 FROM         dbo.OPD_H AS o  (nolock) 
inner  JOIN  dbo.PATDIAG AS d (nolock) ON d.Hn = o.hn AND d.regNo = o.regNo  and d.DiagType<>'P'   and dxtype in ('1','4')   
left JOIN     dbo.PatSS  (nolock) AS s ON s.hn = o.hn
                                                   
LEFT JOIN    dbo.PPOP_CON AS ctl (nolock) ON ctl.CON_KEY = '000'

WHERE o.ipdStatus ='0'
--and  o.registDate between @SDATE and @EDATE

and  o.registDate between '25620926' and '25620926'
)
GO


