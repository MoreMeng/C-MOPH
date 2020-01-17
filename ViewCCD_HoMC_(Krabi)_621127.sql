

--/******  ก่อน RUN ให้แทน [KRABI] ทุกตำแหน่ง ด้วย Database ของโรงพยาบาล/

USE [KRABI]
GO

/****** Object:  View [dbo].[ccd_appointment]    Script Date: 27/11/2562 15:40:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[ccd_appointment] AS 
SELECT       -- TOP (5000)
 '10738' AS hospcode, p.hn, p.VisitNo AS vn, a.appoint_date AS next_visit_date, a.appoint_time_from AS next_visit_time, a.doctor AS doctor_cid, a.appoint_note AS app_note
FROM            dbo.Appoint AS a WITH (nolock) LEFT OUTER JOIN
                         dbo.OPD_H AS p WITH (nolock) ON a.hn = p.hn AND a.appoint_regNo = p.regNo
WHERE        (ISDATE(CONVERT(char, p.registDate - 5430000)) = 1) AND (LTRIM(RTRIM(p.registDate)) <> '') AND (LEN(p.registDate) >= 8) AND (ISDATE(CONVERT(char, a.appoint_date - 5430000)) = 1) AND (LTRIM(RTRIM(a.appoint_date)) <> '') 
                         AND (LEN(a.appoint_date) >= 8) AND (LTRIM(RTRIM(a.appoint_time_from)) <> '')

GO


USE [KRABI]
GO

/****** Object:  View [dbo].[ccd_dispense_items]    Script Date: 27/11/2562 15:40:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[ccd_dispense_items] AS 
SELECT       -- TOP (5000) 
'10738' AS hospcode, p.hn, o.VisitNo AS vn, p.invCode AS hosp_drug_code, m.name AS drug_name, RTRIM(lh.lamed_name) + RTRIM(p.qtyPerFeed) + RTRIM(lu.lamed_name) + RTRIM(lt.lamed_name) AS drug_usage, 
                         p.accQty AS qty, m.package AS unit, LTRIM(m.opd_prc) AS unit_price, p.accAmt AS sum_price, CASE WHEN g.NDC24 IS NOT NULL THEN g.NDC24 ELSE '' END AS didstd, CASE WHEN g.TMTID IS NOT NULL 
                         THEN g.TMTID ELSE '' END AS tmtcode
FROM            dbo.Patmed AS p LEFT OUTER JOIN
                         dbo.OPD_H AS o WITH (NOLOCK) ON p.hn = o.hn AND p.registNo = o.regNo LEFT OUTER JOIN
                         dbo.Med_inv AS m WITH (NOLOCK) ON m.code = p.invCode AND m.site = '1' LEFT OUTER JOIN
                         dbo.KB_Drugcatalog AS g WITH (NOLOCK) ON g.HospDrugCode = p.invCode LEFT OUTER JOIN
                         dbo.Lamed AS lh WITH (NOLOCK) ON lh.lamed_code = p.lamedHow LEFT OUTER JOIN
                         dbo.Lamed AS lu WITH (NOLOCK) ON lu.lamed_code = p.lamedUnit LEFT OUTER JOIN
                         dbo.Lamed AS lt WITH (NOLOCK) ON lt.lamed_code = p.lamedTime

GO


USE [KRABI]
GO

/****** Object:  View [dbo].[ccd_lab_result]    Script Date: 27/11/2562 15:40:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[ccd_lab_result] AS 
SELECT        --TOP (5000) 
'10738' AS hospcode, o.hn, o.VisitNo AS vn, l.req_date AS order_date, d.lab_code AS hosp_lab_code, la.labName AS lab_group_name, '' AS provis_labcode, r.result_name AS lab_items_name, 
                         r.real_res AS lab_order_result, '' AS lab_items_unit, '' AS lab_items_normal_value
FROM            dbo.OPD_H AS o WITH (NOLOCK) LEFT OUTER JOIN
                         dbo.PATIENT AS p WITH (NOLOCK) ON o.hn = p.hn LEFT OUTER JOIN
                         dbo.Labreq_h AS l WITH (NOLOCK) ON l.hn = o.hn AND l.reg_flag = o.regNo LEFT OUTER JOIN
                         dbo.Labreq_d AS d WITH (NOLOCK) ON d.req_no = l.req_no LEFT OUTER JOIN
                         dbo.Labres_d AS r WITH (NOLOCK) ON r.req_no = l.req_no LEFT OUTER JOIN
                         dbo.Lab AS la WITH (NOLOCK) ON la.labCode = d.lab_code
WHERE        (o.registDate BETWEEN '25620701' AND '25620731') AND (p.unuseshn IS NULL OR
                         p.unuseshn = ' ' OR
                         p.unuseshn = 'N')

GO


USE [KRABI]
GO

/****** Object:  View [dbo].[ccd_opd_visit]    Script Date: 27/11/2562 15:40:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[ccd_opd_visit] AS 
SELECT        /*TOP (5000)*/ '10738' AS hospcode, ltrim(o.hn) as hn , o.VisitNo AS vn, isnull(i.ladmit_n,'') AS an,
dbo.ymd2ce(o.registDate)  AS vstdate, 
convert(time, left(o.timePt,2)+':'+substring(o.timePt,3,2) + ':00' ) AS vsttime, 
RTRIM(dbo.DEPTMAP(d.deptCode, 
                         'OPPP')) AS clinic_code, de.deptDesc AS name, CASE WHEN RTRIM(isnull(dbo.PAYTYPEMAP(b.useDrg, 'OPPP'), '')) = '' THEN
                             (SELECT        TOP 1 RTRIM(isnull(dbo.PAYTYPEMAP(b1.useDrg, 'OPPP'), ''))
                               FROM            dbo.Bill_h b1(NOLOCK)
                               WHERE        b1.hn = b.hn AND b1.regNo < b.regNo) ELSE RTRIM(isnull(dbo.PAYTYPEMAP(b.useDrg, 'OPPP'), '')) END AS pttype_std_code, pt.pay_typedes
FROM            dbo.OPD_H AS o WITH (NOLOCK) LEFT OUTER JOIN
                         dbo.Deptq_d AS d WITH (NOLOCK) ON d.hn = o.hn AND d.regNo = o.regNo LEFT OUTER JOIN
                         dbo.Ipd_h AS i WITH (NOLOCK) ON i.hn = o.hn AND i.regist_flag = o.regNo LEFT OUTER JOIN
                         dbo.PATIENT AS p WITH (NOLOCK) ON p.hn = o.hn LEFT OUTER JOIN
                         dbo.Bill_h AS b WITH (NOLOCK) ON b.hn = o.hn AND b.regNo = o.regNo LEFT OUTER JOIN
                         dbo.DEPT AS de WITH (NOLOCK) ON de.deptCode = d.deptCode LEFT OUTER JOIN
                         dbo.Paytype AS pt WITH (NOLOCK) ON pt.pay_typecode = b.useDrg
WHERE        ((p.unuseshn IS NULL) OR
                         (p.unuseshn = '') OR
                         (p.unuseshn = 'N'))
--AND o.registDate = dbo.ce2ymd(getDate())

GO


USE [KRABI]
GO

/****** Object:  View [dbo].[ccd_opd_visit_diag]    Script Date: 27/11/2562 15:40:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[ccd_opd_visit_diag] AS 
SELECT        --TOP (5000) 
'10738' AS hospcode, o.hn, o.VisitNo AS vn, RTRIM(d.ICDCode) AS icd10, ic.DES AS diag_name, CASE WHEN DiagType = 'P' THEN '5' ELSE d .dxtype END AS diag_type, 
                         CASE WHEN doctorID = '' THEN RTRIM(DocCode) ELSE RTRIM(doctorID) END AS doctor_cid
FROM            dbo.OPD_H AS o WITH (NOLOCK) LEFT OUTER JOIN
                         dbo.PATDIAG AS d WITH (NOLOCK) ON d.Hn = o.hn AND d.regNo = o.regNo LEFT OUTER JOIN
                         dbo.PATIENT AS p WITH (NOLOCK) ON o.hn = p.hn LEFT OUTER JOIN
                         dbo.ICD101 AS ic WITH (NOLOCK) ON ic.CODE = d.ICDCode
WHERE        (p.unuseshn IS NULL OR
                         p.unuseshn = ' ' OR
                         p.unuseshn = 'N') AND (LEFT(RTRIM(d.ICDCode), 1) BETWEEN 'A' AND 'Z')

GO


USE [KRABI]
GO

/****** Object:  View [dbo].[ccd_opd_visit_diag_text]    Script Date: 27/11/2562 15:40:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[ccd_opd_visit_diag_text] AS 
SELECT        --TOP (5000) 
'10738' AS hospcode, o.hn, o.VisitNo AS vn, CASE WHEN doctorID = '' THEN RTRIM(DocCode) ELSE RTRIM(doctorID) END AS cid, '' AS diag_text
FROM            dbo.OPD_H AS o WITH (NOLOCK) LEFT OUTER JOIN
                         dbo.PATDIAG AS d WITH (NOLOCK) ON d.Hn = o.hn AND d.regNo = o.regNo LEFT OUTER JOIN
                         dbo.PATIENT AS p WITH (NOLOCK) ON o.hn = p.hn
WHERE        (p.unuseshn IS NULL) OR
                         (p.unuseshn = ' ') OR
                         (p.unuseshn = 'N')

GO


USE [KRABI]
GO

/****** Object:  View [dbo].[ccd_opd_visit_procedure]    Script Date: 27/11/2562 15:39:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[ccd_opd_visit_procedure] AS 
SELECT        --TOP (5000)
 '10738' AS hospcode, o.hn, o.VisitNo AS vn, RTRIM(d.ICDCode) AS icdcm, ic.DES AS proced_name, d.DiagNo AS proced_type, CASE WHEN (DiagType = 'P' AND dxtype = '4' AND 
                         DiagNote IS NOT NULL AND DiagNote <> '') THEN RTRIM(DiagNote) ELSE RTRIM(d .DocCode)  END AS doctor_cid
FROM            dbo.OPD_H AS o WITH (NOLOCK) LEFT OUTER JOIN
                         dbo.PATDIAG AS d WITH (NOLOCK) ON d.Hn = o.hn AND d.regNo = o.regNo LEFT OUTER JOIN
                         dbo.PatSS AS s WITH (NOLOCK) ON o.hn = s.hn LEFT OUTER JOIN
                         dbo.DOCC AS do WITH (NOLOCK) ON d.DocCode = do.docCode LEFT OUTER JOIN
                         dbo.PATIENT AS p WITH (NOLOCK) ON o.hn = p.hn LEFT OUTER JOIN
                         dbo.ICDCM1 AS ic WITH (NOLOCK) ON ic.CODE = d.ICDCode
WHERE        (p.unuseshn IS NULL OR
                         p.unuseshn = ' ' OR
                         p.unuseshn = 'N') AND (d.ICDCode IS NOT NULL) AND (d.ICDCode <> '') AND (d.DiagType = 'P')

GO


USE [KRABI]
GO

/****** Object:  View [dbo].[ccd_opd_visit_screen]    Script Date: 27/11/2562 15:39:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[ccd_opd_visit_screen] AS 
SELECT        --TOP (5000) 
'10738' AS hospcode, o.hn, o.VisitNo AS vn, '' AS cc, '' AS hpi, CASE WHEN g.Lbloodpress IS NULL OR
                         g.Lbloodpress = '' THEN 0 ELSE g.Lbloodpress END AS dbp, CASE WHEN g.Hbloodpress IS NULL OR
                         g.Hbloodpress = '' THEN 0 ELSE g.Hbloodpress END AS sbp, CASE WHEN g.Pulse IS NULL OR
                         g.Pulse = '' THEN 0 ELSE g.Pulse END AS pulse, CASE WHEN g.Breathe IS NULL OR
                         g.Breathe = '' THEN 0 ELSE g.Breathe END AS respiratory_rate, 
CONVERT(DECIMAL(10, 1), g.Temperature) AS temperature, 
g.Weight AS weight, 
g.Height AS height, 0 AS bmi, g.Waist AS waist, '' AS pe, 
                         CASE WHEN g.NO_ALCOHOL IS NULL THEN 0 WHEN g.NO_ALCOHOL = 'Y' THEN 2 ELSE 1 END AS alcohol_use, 
CASE WHEN g.NO_SMOKE IS NULL THEN 0 WHEN g.NO_SMOKE = 'Y' THEN 2 ELSE 1 END AS cigar_use, 
                         0 AS pregnant, 
'0' AS lactation, '' AS pain_score, '' AS note
FROM            dbo.OPD_H AS o WITH (NOLOCK) LEFT OUTER JOIN
                         dbo.SSREGIST AS g WITH (NOLOCK) ON o.hn = g.hn AND o.regNo = g.RegNo LEFT OUTER JOIN
                         dbo.PATIENT AS p WITH (NOLOCK) ON p.hn = o.hn
WHERE        (p.unuseshn IS NULL) OR
                         (p.unuseshn = '') OR
                         (p.unuseshn = 'N')

GO


USE [KRABI]
GO

/****** Object:  View [dbo].[ccd_person]    Script Date: 27/11/2562 15:39:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[ccd_person] AS 
SELECT        /*TOP (5000) */'10738' AS hospcode, LTRIM(p.hn) AS hn,rtrim( s.CardID) as cid,
(select MAX(o.VisitNo) from OPD_H o (NOLOCK) Where o.hn = p.hn) AS vn, 
h1.OUTVALUE AS provis_pname, RTRIM(p.firstName) AS fname, RTRIM(p.lastName) AS lname, 

STUFF(STUFF(convert(char,p.birthDay -5430000),5,0,'-'),8,0,'-') as birthday, 
                         CASE WHEN p.sex = 'ช' THEN 1 ELSE 2 END AS sex, CASE WHEN p.marital = '' OR
                         p.marital IS NULL THEN '9' ELSE rtrim(p.marital) END AS nhso_marriage_code, CASE WHEN p.nation = '' OR
                         p.nation IS NULL THEN '999' ELSE RTRIM(h3.OUTVALUE) END AS nation_code, CASE WHEN p.race = '' OR
                         p.race IS NULL THEN '999' ELSE RTRIM(h4.OUTVALUE) END AS citizenship, CASE WHEN p.religion IS NULL OR
                         p.religion = '' OR
                         p.religion = '5' THEN '99' ELSE CASE WHEN p.religion = '0' THEN '01' ELSE CASE WHEN p.religion = '1' THEN '03' ELSE CASE WHEN p.religion = '2' THEN '02' ELSE CASE WHEN p.religion = '3' OR
                         p.religion = '4' THEN '04' END END END END END AS religion_code, p.addr1 AS address, isnull(p.moo,'') as moo, '' AS street, p.tambonCode AS subdistrict_code, RIGHT(p.regionCode, 2) AS district_code, p.areaCode AS province_code, 
                         p.regionCode + p.tambonCode AS address_id, CASE WHEN p.phone = '' OR
                         p.phone IS NULL THEN '' ELSE p.phone END AS telephone, CASE WHEN p.mobilephone = '' OR
                         p.mobilephone IS NULL THEN '' ELSE p.mobilephone END AS mobile, CASE WHEN p.mother = '' THEN s.father ELSE mother END AS informname, s.relativePhone AS informtel, '' AS drugallergy
FROM           dbo.PATIENT AS p WITH (NOLOCK) LEFT OUTER JOIN
                        --dbo.OPD_H AS o WITH (NOLOCK) LEFT OUTER JOIN
                         dbo.PatSS AS s WITH (NOLOCK) ON s.hn = p.hn LEFT OUTER JOIN
                        -- dbo.PATIENT AS p WITH (NOLOCK) ON p.hn = o.hn LEFT OUTER JOIN
                         dbo.PTITLE AS t WITH (NOLOCK) ON t.titleCode = p.titleCode LEFT OUTER JOIN
                         dbo.HCTABLEMAP AS h1 WITH (NOLOCK) ON p.titleCode = h1.HCVALUE AND h1.HCTABLE = 'PTITLE' AND h1.SYSMAP = 'OPPP' LEFT OUTER JOIN
                         dbo.HCTABLEMAP AS h3 WITH (NOLOCK) ON p.nation = h3.HCVALUE AND h3.HCTABLE = 'Nation' AND h3.HCFIELD = 'NATCODE' AND h3.SYSMAP = 'OPPP' LEFT OUTER JOIN
                         dbo.HCTABLEMAP AS h4 WITH (NOLOCK) ON p.race = h4.HCVALUE AND h4.HCTABLE = 'Nation' AND h4.HCFIELD = 'NATCODE' AND h4.SYSMAP = 'OPPP' --LEFT OUTER JOIN
                         --dbo.medalery AS a WITH (NOLOCK) ON a.hn = o.hn LEFT OUTER JOIN
                         --dbo.Med_inv AS m WITH (NOLOCK) ON m.site = '1' AND a.medCode = m.abbr
WHERE      (  (p.unuseshn IS NULL) OR
                         (p.unuseshn = '') OR
                         (p.unuseshn = 'N'))
--and s.CardID in ('3319900049588','1311101037948')

GO


