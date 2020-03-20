ALTER VIEW [dbo].[ccd_opd_visit_procedure]
AS
SELECT ctl.PCUCODE AS hospcode,
    -- o.registDate,
	LTRIM(o.hn) AS hn,
	o.regNo AS vn,
	RTRIM(d.ICDCode) AS icdcm,
	-- RTRIM(d.ICDCode) AS icd,
	-- RTRIM(d.ICDCode) AS icd10,
	-- ICDCM1.DES AS diag_name,
	ICDCM1.DES AS proced_name,
	-- d.DiagNo AS diag_type,
	d.DiagNo AS proced_type,
	dc.CID AS doctor_cid
FROM dbo.OPD_H AS o(NOLOCK)
INNER JOIN dbo.PATDIAG AS d(NOLOCK) ON d.Hn = o.hn
	AND d.regNo = o.regNo
	AND d.DiagType = 'P'
	AND d.dxtype IN ('1', '4')
INNER JOIN dbo.ICDCM1(NOLOCK) ON ICDCM1.CODE = d.ICDCode
INNER JOIN dbo.PROVIDER dc(NOLOCK) ON dc.PROVIDER = d.DocCode
LEFT JOIN dbo.PPOP_CON ctl(NOLOCK) ON ctl.CON_KEY = '000'
WHERE
o.registDate >= '25621001'
AND (d.ICDCode IS NOT NULL) AND (d.ICDCode <> '') AND (d.DiagType = 'P')
-- AND LTRIM(o.hn) IN ('321420','18972', '202042' ,'282876','81247')
