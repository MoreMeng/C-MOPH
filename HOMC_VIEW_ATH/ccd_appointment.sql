




CREATE   FUNCTION [dbo].[ccd_appointment]
(	
	-- Add the parameters for the function here
	@SDATE char(8),
	@EDATE char(8)
)
RETURNS TABLE 
AS
RETURN 
(

    

SELECT  ctl.PCUCODE AS hospcode
,  LTRIM(o.hn) AS hn
,o.regNo AS vn 
 ,  (convert(DateTime,convert(char,A.appoint_date -5430000))) AS next_visit_date
 ,convert(time,(appoint_time_from) ,108) AS vsttime   

,dc.CID as doctor_cid
,A.appoint_note as app_note



FROM         dbo.Appoint AS A LEFT OUTER JOIN 
             dbo.OPD_H AS o ON A.hn = o.hn AND (A.appoint_regNo = o.regNo or (convert(char,convert(numeric,convert(char,keyin_time,112))+5430000)=o.registDate ) )    LEFT OUTER JOIN 
  		     PPOP_PROVIDER AS dc (nolock) ON dc.PROVIDER = A.doctor     LEFT OUTER JOIN 
			  dbo.PPOP_CON AS ctl ON ctl.CON_KEY = '000'
    where 
 registDate between @SDATE and @EDATE 
  and ipdStatus='0'

  


)





GO

