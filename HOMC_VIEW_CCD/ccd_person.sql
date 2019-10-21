CREATE VIEW [dbo].[ccd_person]
AS
SELECT DISTINCT ctl.PCUCODE AS hospcode,
	REPLACE(CASE
			WHEN s.CardID IS NULL
				OR s.CardID = ''
				THEN s.CardID
			ELSE s.CardID
			END, '-', '') AS cid,
	ltrim(o.hn) AS hn,
	o.regNo AS vn,
	dbo.PTITLEMAP(p.titleCode, 'OPPP') AS provis_pname,
	isnull(p.firstName, '-') AS fname,
	CASE
		WHEN p.lastName = NULL
			THEN '-'
		WHEN p.lastName = ' '
			THEN '-'
		ELSE isnull(p.lastName, '-')
		END AS lname,
	isnull((convert(DATETIME, convert(CHAR, birthDay - 5430000))), ' ') AS birthday,
	CASE p.sex
		WHEN 'ช'
			THEN '1'
		WHEN 'ญ'
			THEN '2'
		ELSE '2'
		END AS sex,
	CASE
		WHEN t.titleName LIKE 'พระ%'
			THEN '6' --21/12/59  คำนำหน้าชื่อเป็นพระ สถานะสมรสต้องเป็น สมณะ
		ELSE ISNULL(p.marital, '9')
		END AS nhso_marriage_code,
	ISNULL(RIGHT('000' + RTRIM(dbo.NATIONMAP(p.nation, 'OPPP')), 3), '999') AS nation_code,
	ISNULL(RIGHT('000' + RTRIM(dbo.NATIONMAP(p.race, 'OPPP')), 3), '999') AS citizenship,
	CASE
		WHEN p.religion IS NULL
			THEN '99'
		WHEN p.religion IS NOT NULL
			THEN '0' + p.religion
		END AS religion_code,
	p.addr1 AS address,
	p.moo,
	p.addr2 AS street,
	right(tb.tambonCode, 2) AS subdistrict_code,
	right(p.regionCode, 2) AS district_code,
	p.areaCode AS province_code,
	tb.tambonCode AS address_id,
	replace(p.phone, '-', '') AS telephone,
	replace(p.mobilephone, '-', '') AS mobile,
	s.relatives AS informname,
	s.relativePhone AS informtel,
	allergy.drugallergy
FROM OPD_H o(NOLOCK)
--     dbo.PPOP_PERSON   pp on o.hn=pp.HN  LEFT OUTER JOIN
LEFT JOIN Ipd_h I(NOLOCK) ON I.hn = o.hn
	AND I.regist_flag = o.regNo
LEFT JOIN dbo.PPOP_CON(NOLOCK) AS ctl ON ctl.CON_KEY = '000'
LEFT JOIN dbo.PATIENT(NOLOCK) AS p ON p.hn = o.hn
LEFT JOIN dbo.PTITLE(NOLOCK) AS t ON t.titleCode = p.titleCode
LEFT JOIN dbo.PatSS(NOLOCK) AS s ON s.hn = p.hn
LEFT JOIN Tambon tb ON tb.tambonCode = p.regionCode + p.tambonCode
LEFT JOIN REGION r ON r.regionCode = p.regionCode
OUTER APPLY (
	SELECT DISTINCT REPLACE(replace(STUFF((
						SELECT ', ' + rtrim(gen_name)
						FROM medalery a
						LEFT JOIN Med_inv m ON m.site = '1'
							AND a.medCode = m.code
						WHERE a.hn = o.hn
							AND (
								delFlag IS NULL
								OR delFlag <> 'Y'
								)
						FOR XML PATH('')
						), 1, 1, ''), '&gt;', '>'), '&lt;', '<') AS drugallergy
	) AS allergy
