CREATE VIEW [dbo].[ccd_opd_visit_screen]
AS
SELECT ctl.PCUCODE AS hospcode,
	LTRIM(o.hn) AS hn,
	o.regNo AS vn,
	v.Symtom AS cc,
	'' AS hpi,
	CASE
		WHEN CONVERT(DECIMAL(18, 0), ISNULL((CONVERT(FLOAT, v.Lbloodpress)), '0.00')) = '0'
			THEN NULL
		ELSE CONVERT(DECIMAL(18, 0), ISNULL((CONVERT(FLOAT, v.Lbloodpress)), '0.00'))
		END AS dbp,
	CASE
		WHEN CONVERT(DECIMAL(18, 0), ISNULL((CONVERT(FLOAT, v.Hbloodpress)), '0.00')) = '0'
			THEN NULL
		ELSE CONVERT(DECIMAL(18, 0), ISNULL((CONVERT(FLOAT, v.Hbloodpress)), '0.00'))
		END AS sbp,
	CASE
		WHEN CONVERT(DECIMAL(18, 0), ISNULL((CONVERT(FLOAT, v.Pulse)), '0.00')) = '0'
			THEN NULL
		ELSE CONVERT(DECIMAL(18, 0), ISNULL((CONVERT(FLOAT, v.Pulse)), '0.00'))
		END AS pulse,
	CASE
		WHEN CONVERT(DECIMAL(18, 0), ISNULL((CONVERT(FLOAT, v.Breathe)), '0.00')) = '0'
			THEN NULL
		ELSE CONVERT(DECIMAL(18, 0), ISNULL((CONVERT(FLOAT, v.Breathe)), '0.00'))
		END AS respiratory_rate,
	LTRIM(STR(v.Temperature, 4, 1)) AS temperature,
	CASE
		WHEN CONVERT(DECIMAL(18, 2), ISNULL((CONVERT(FLOAT, v.Weight)), '0.00')) = '0'
			THEN NULL
		ELSE CONVERT(DECIMAL(18, 2), ISNULL((CONVERT(FLOAT, v.Weight)), '0.00'))
		END AS weight,
	CASE
		WHEN CONVERT(DECIMAL(18, 2), ISNULL((CONVERT(FLOAT, v.Height)), '0.00')) = '0'
			THEN NULL
		ELSE CONVERT(DECIMAL(18, 2), ISNULL((CONVERT(FLOAT, v.Height)), '0.00'))
		END AS height,
	CASE
		WHEN (
				v.Weight IS NOT NULL
				AND v.Height IS NOT NULL
				)
			THEN convert(DECIMAL(18, 2), (CONVERT(FLOAT, v.Weight)) / (power((v.Height * .01), 2)))
		ELSE 0
		END AS bmi,
	CASE
		WHEN CONVERT(DECIMAL(18, 2), ISNULL((CONVERT(FLOAT, v.Waist)), '0.00')) = '0'
			THEN NULL
		ELSE CONVERT(DECIMAL(18, 2), ISNULL((CONVERT(FLOAT, v.Waist)), '0.00'))
		END AS waist,
	v.Treatment AS pe,
	CASE v.Alchohol
		WHEN 'Y'
			THEN '1'
		WHEN NULL
			THEN 'NA'
		ELSE '2'
		END AS alcohol_use,
	CASE v.Smoke
		WHEN 'Y'
			THEN '1'
		WHEN NULL
			THEN 'NA'
		ELSE '2'
		END AS cigar_use,
	'' AS pregnant,
	'' AS lactation,
	'' AS pain_score,
	'' AS note
FROM dbo.OPD_H AS o(NOLOCK)
LEFT JOIN SSREGIST v(NOLOCK) ON v.hn = o.hn
	AND v.RegNo = o.regNo
LEFT JOIN PPOP_CON AS ctl ON ctl.CON_KEY = '000'
