ALTER VIEW [dbo].[ccd_dispense_items]
AS
SELECT TOP 100 ctl.PCUCODE AS hospcode,
	LTRIM(p.hn) AS hn,
	p.registNo AS vn,
	p.invCode AS hosp_drug_code,
	M.name AS drug_name,
	RTRIM(L1.lamed_name) + '  ' + RTRIM(p.lamedQty) + '  ' + RTRIM(L2.lamed_name) + '  ' + RTRIM(p.lamedTimeText) AS drug_usage,
	ISNULL(p.accQty, 0) AS qty,
	RTRIM(M.package) AS unit,
	CONVERT(MONEY, ISNULL(M.opd_prc, 0)) AS unit_price,
	(CONVERT(MONEY, ISNULL(p.accAmt, 0))) AS sum_price,
	LEFT(ISNULL(g.invGovCode24, M.code), 24) AS didstd,
	dc.TMTID AS tmtcode
FROM dbo.Patmed AS p
LEFT OUTER JOIN dbo.OPD_H AS o WITH (NOLOCK) ON p.hn = o.hn AND p.registNo = o.regNo
LEFT OUTER JOIN dbo.Med_inv M WITH (NOLOCK) ON p.invCode = M.code AND M.site = '1'
LEFT OUTER JOIN dbo.Drugcatalog_producttype dc WITH (NOLOCK) ON dc.hospDrugCode = M.code
LEFT OUTER JOIN dbo.Lamed L1 WITH (NOLOCK) ON L1.lamed_code = p.lamedHow
LEFT OUTER JOIN dbo.Lamed L2 WITH (NOLOCK) ON L2.lamed_code = p.lamedUnit
LEFT OUTER JOIN dbo.Med_Gov24Map AS g WITH (NOLOCK) ON g.invCode = M.code AND g.invType = 'M'
LEFT OUTER JOIN dbo.PPOP_CON AS ctl WITH (NOLOCK) ON ctl.CON_KEY = '000'
-- WHERE p.invCode = 'THCO1'
-- WHERE dc.TMTID LIKE '1129720'

