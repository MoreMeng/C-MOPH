



CREATE    FUNCTION [dbo].[ccd_lab_result]
(	
	@SDATE char(8),
	@EDATE char(8)
)
RETURNS TABLE 
AS
RETURN 
( 

SELECT  CTL.PCUCODE AS hospcode
,  LTRIM(O.hn) AS hn
,O.regNo AS vn 
, (convert(DateTime,convert(char,LH.req_date -5430000))) AS order_date
,LR.lab_code as hosp_lab_code
,L.labName  as lab_group_name
,TB.OUTVALUE   AS provis_labcode 
,S.result_name as lab_items_name
,R.real_res as lab_order_result
,S.result_unit
,R.low_normal+'-'+R.high_normal as lab_items_normal_value
  FROM         dbo.OPD_H (nolock) AS O inner join 					 
                      dbo.Bill_h  (nolock) AS H on H.hn=O.hn and H.regNo=O.regNo                           LEFT OUTER JOIN
                      dbo.Labreq_h AS LH ON LH.hn = O.hn AND LH.reg_flag = O.regNo   INNER JOIN
                      dbo.Labreq_d  AS LR ON LR.req_no = LH.req_no                       INNER JOIN
					  Lab as L ON L.labType=LR.lab_type and L.labCode=LR.lab_code    INNER JOIN
                      HCTABLEMAP as  TB ON TB.HCVALUE=LR.lab_code   and HCTABLE='Lab'  and TB.SYSMAP='OPPP'        INNER JOIN
					  Labres_d  R ON R.req_no = LH.req_no  and LR.lab_type=R.lab_type and R.lab_code=LR.lab_code     INNER JOIN
					  Labre_s S ON S.labType = R.lab_type and S.lab_code=R.lab_code left join 
                      dbo.PatSS       AS s  (nolock) ON s.hn = O.hn  
     JOIN        dbo.PPOP_CON AS CTL ON CTL.CON_KEY = '000'
where 
--O.registDate between  '25620901' and '25620901' 
O.registDate between @SDATE and @EDATE  
and O.ipdStatus='0'
and  LR.res_ready='Y'
       
)




 
GO

