CREATE VIEW [dbo].[ccd_opd_visit_diag]
AS
SELECT ctl.PCUCODE AS hospcode,
	LTRIM(o.hn) AS hn,
	o.regNo AS vn,
	d.ICDCode AS icd10,
	ICD101.DES AS diagname,
	CASE
		WHEN DiagType = 'E'
			THEN '5'
		ELSE d.dxtype
		END AS diag_type,
	d.DocCode,
	dc.CID
FROM dbo.OPD_H AS o(NOLOCK)
INNER JOIN dbo.PATDIAG AS d(NOLOCK) ON d.Hn = o.hn
	AND d.regNo = o.regNo
	AND d.DiagType <> 'P'
	AND dxtype IN ('1', '4')
INNER JOIN ICD101(NOLOCK) ON ICD101.CODE = d.ICDCode
INNER JOIN PROVIDER AS dc(NOLOCK) ON dc.PROVIDER = d.DocCode
LEFT JOIN dbo.PPOP_CON AS ctl(NOLOCK) ON ctl.CON_KEY = '000'
