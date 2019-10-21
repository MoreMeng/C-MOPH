
CREATE     FUNCTION [dbo].[ccd_person]
(	
	-- Add the parameters for the function here
	@SDATE char(8),
	@EDATE char(8)
)
RETURNS TABLE 
AS
RETURN 
(--ค้นหาข้อมูลผู้ป่วยนอก
SELECT  distinct       
ctl.PCUCODE as hospcode
, REPLACE(CASE WHEN s.CardID IS NULL or  s.CardID  = '' THEN s.CardID ELSE s.CardID END, '-', '') AS cid
, ltrim(o.hn) AS hn
, o.regNo as vn
    ,dbo.PTITLEMAP( p.titleCode, 'OPPP') as  provis_pname
    , isnull(p.firstName,'-') AS fname
    , case when p.lastName =NULL  then '-'
           when p.lastName =' ' then '-' 
                else  isnull(p.lastName,'-')  end AS lname
    , isnull( (convert(DateTime,convert(char,birthDay-5430000)))  ,' ')AS birthday
    , CASE p.sex
    WHEN 'ช' THEN '1' 
    WHEN  'ญ' THEN '2'  
    else '2' END AS sex

    ,case   when t.titleName like 'พระ%' then '6'  --21/12/59  คำนำหน้าชื่อเป็นพระ สถานะสมรสต้องเป็น สมณะ
    else ISNULL( p.marital ,'9')
    end as nhso_marriage_code
    ,ISNULL( RIGHT('000' + RTRIM(dbo.NATIONMAP(p.nation,'OPPP')), 3),'999') AS nation_code                      
	,ISNULL( RIGHT('000' + RTRIM(dbo.NATIONMAP(p.race,'OPPP')), 3),'999')  AS citizenship
    ,case 
    when  p.religion  IS  null then '99' 
    when  p.religion  IS not null then   '0'+ p.religion end  as religion_code  
	,p.addr1 as address
	,p.moo 
	,p.addr2 as street
,right(tb.tambonCode,2) as subdistrict_code
,right(p.regionCode,2) as district_code
,p.areaCode as province_code
,tb.tambonCode as address_id
,replace (p.phone,'-','') as telephone
,replace (p.mobilephone,'-','') as mobile
,s.relatives as informname
,s.relativePhone as informtel
,allergy.drugallergy


FROM OPD_H o (nolock)  
  --     dbo.PPOP_PERSON   pp on o.hn=pp.HN  LEFT OUTER JOIN
left join      Ipd_h I (nolock) ON I.hn = o.hn and I.regist_flag = o.regNo  
left join      dbo.PPOP_CON  (nolock) AS ctl ON ctl.CON_KEY = '000' 
left JOIN      dbo.PATIENT  (nolock) AS p ON p.hn = o.hn 
left JOIN      dbo.PTITLE  (nolock) AS t ON t.titleCode = p.titleCode 
left JOIN     dbo.PatSS  (nolock) AS s ON s.hn = p.hn
left join Tambon tb on tb.tambonCode=p.regionCode+p.tambonCode
left  join REGION r on r.regionCode=p.regionCode
outer apply ( SELECT DISTINCT REPLACE( replace(STUFF((SELECT  ', '+rtrim(gen_name) 
				from medalery  a
				left join Med_inv m on m.site ='1' and a.medCode = m.code
				where a.hn=o.hn and (delFlag is null or delFlag <> 'Y' ) FOR XML PATH('')),1,1,''
				), '&gt;', '>'), '&lt;', '<') as drugallergy
			) as allergy



--where  ((registDate between '25611001' and '25611001'    and ipdStatus='0')or  (discharge_date between '25591001' and '25591001'      and ipdStatus='D'))  
where  ((registDate between @SDATE and @EDATE  )or  (discharge_date between @SDATE and @EDATE and ipdStatus='D'))
and exists (select * from Bill_h h(nolock) where o.hn=h.hn and o.regNo=h.regNo)--ไม่เอายืมบัตร


)


GO






