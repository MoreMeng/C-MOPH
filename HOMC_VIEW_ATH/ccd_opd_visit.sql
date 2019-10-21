
CREATE      FUNCTION [dbo].[ccd_opd_visit]
(	
	-- Add the parameters for the function here
	@SDATE char(8),
	@EDATE char(8)
)
RETURNS TABLE 
AS
RETURN 
(

SELECT distinct   ctl.PCUCODE as hospcode
,  LTRIM(o.hn) AS hn
,o.regNo AS vn 
,I.ladmit_n as an
, (convert(DateTime,convert(char,regist_date-5430000)))AS vstdate
, convert(time,(left(o.timePt,2)+':'+right(o.timePt,2)) ,108) AS vsttime   
,isnull(RTRIM( dbo.DEPTMAP(d.deptCode, 'OPPP') ),'00100')AS clinic_code
,DEPT.deptDesc as name
 
, case  when (dbo.PAYTYPEMAP(b.useDrg, 'OPPP') =NULL ) OR (dbo.PAYTYPEMAP(b.useDrg, 'OPPP') ='')  then '9100'  
        else isnull(dbo.PAYTYPEMAP(b.useDrg, 'OPPP'),'9100') end  AS pttype_std_code
, '' as pttype_std_name
    
FROM  dbo.OPD_H AS o (nolock) 
      LEFT  JOIN  Ipd_h I  (nolock) ON I.hn = o.hn and I.regist_flag = o.regNo  
	  inner  JOIN  Deptq_d d (nolock) on o.hn=d.hn and o.regNo=d.regNo
	  inner join   DEPT  (nolock) on d.deptCode = DEPT.deptCode
      inner  JOIN  Bill_h AS b  (nolock) ON b.hn = o.hn AND b.regNo = o.regNo 
      LEFT JOIN   PPOP_CON AS ctl ON ctl.CON_KEY = '000' 
  
where  registDate between @SDATE and @EDATE  -- แก้ไข 9/4/62 
and exists (select * from Bill_h h(nolock) where o.hn=h.hn and o.regNo=h.regNo) --ไม่เอายืมบัตร
and not exists (select * from PPOP_DEATH D (nolock)  where D.HN=o.hn and o.registDate>D.DDEATH) --ไม่เอาvisitหลังตาย 

  
)

GO


