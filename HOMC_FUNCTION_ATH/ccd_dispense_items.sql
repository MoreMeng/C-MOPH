CREATE FUNCTION [dbo].[ccd_dispense_items] (
	-- Add the parameters for the function here
	@SDATE CHAR(8),
	@EDATE CHAR(8)
	)
RETURNS TABLE
AS
RETURN (
		SELECT DISTINCT ctl.PCUCODE AS hospcode,
			LTRIM(p.hn) AS hn,
			p.registNo AS vn,
			p.invCode AS hosp_drug_code,
			M.name AS drug_name,
			rtrim(L1.lamed_name) + '  ' + rtrim(lamedQty) + '  ' + rtrim(L2.lamed_name) + '  ' + rtrim(lamedTimeText) AS drug_usage,
			(CONVERT(MONEY, isnull(p.accQty, 0))) AS qty,
			rtrim(L2.lamed_name) AS unit,
			CONVERT(MONEY, isnull(M.opd_prc, 0)) AS unit_price,
			(CONVERT(MONEY, isnull(p.accAmt, 0))) AS sum_price,
			LEFT(ISNULL(g.invGovCode24, M.code), 24) AS didstd,
			dc.TMTID AS tmtcode
		FROM dbo.OPD_H AS o(NOLOCK)
		INNER JOIN Patmed p WITH (NOLOCK) ON o.hn = p.hn
			AND o.regNo = p.registNo
		LEFT JOIN Med_inv M WITH (NOLOCK) ON p.invCode = M.code
			AND M.site = '1'
		LEFT JOIN Lamed L1 WITH (NOLOCK) ON (
				(L1.lamed_code = '*' + p.lamedHow)
				OR (L1.lamed_code = p.lamedHow)
				)
			AND (
				p.lamedHow <> '*.'
				OR p.lamedHow IS NOT NULL
				)
		LEFT JOIN Lamed L2 WITH (NOLOCK) ON (L2.lamed_code = '!' + p.lamedUnit)
			OR (L2.lamed_code = p.lamedUnit)
			AND (
				p.lamedUnit <> '!.'
				OR p.lamedUnit IS NOT NULL
				)
		LEFT JOIN Lamed L3 WITH (NOLOCK) ON (L3.lamed_code = '&' + p.lamedTime)
			OR (L3.lamed_code = p.lamedTime)
			AND (
				p.lamedTime <> '&.'
				OR p.lamedTime IS NOT NULL
				)
		LEFT JOIN Lamed L4 WITH (NOLOCK) ON (L4.lamed_code = '@' + p.lamedSpecial)
			OR (L4.lamed_code = p.lamedSpecial)
			AND (
				p.lamedSpecial <> '@.'
				OR p.lamedSpecial IS NOT NULL
				)
		LEFT JOIN dbo.Med_Gov24Map AS g(NOLOCK) ON g.invCode = M.code
			AND g.invType = 'M'
		LEFT JOIN Drugcatalog_producttype dc(NOLOCK) ON dc.hospDrugCode = M.code
		LEFT JOIN dbo.PPOP_CON AS ctl(NOLOCK) ON ctl.CON_KEY = '000'
		WHERE o.registDate BETWEEN @SDATE
				AND @EDATE
			AND (o.ipdStatus = '0')
			AND (p.invType = 'M')
		)
GO


