ALTER VIEW [dbo].[ccd_person]
AS
SELECT ctl.PCUCODE AS hospcode,
    LTRIM(PT.hn) AS hn,
    REPLACE(CASE
            WHEN S.CardID IS NULL OR S.CardID = ''
                THEN S.CardID
            ELSE S.CardID
            END, '-', '') AS cid,
    dbo.PTITLEMAP(PT.titleCode, 'OPPP') AS provis_pname,
    isnull(PT.firstName, '-') AS fname,
    CASE
        WHEN PT.lastName = NULL
            THEN '-'
        WHEN PT.lastName = ' '
            THEN '-'
        ELSE isnull(PT.lastName, '-')
        END AS lname,
    ISNULL((CONVERT(DATE, CONVERT(CHAR, PT.birthDay - 5430000))), ' ') AS birthday,
    CASE PT.sex
        WHEN 'ช'
            THEN '1'
        WHEN 'ญ'
            THEN '2'
        ELSE '2'
        END AS sex,
    CASE
        WHEN T.titleName LIKE 'พระ%'
            THEN '6'
        ELSE ISNULL(PT.marital, '9')
        END AS nhso_marriage_code,
    ISNULL(RIGHT('000' + RTRIM(dbo.NATIONMAP(PT.nation, 'OPPP')), 3), '999') AS nation_code,
    ISNULL(RIGHT('000' + RTRIM(dbo.NATIONMAP(PT.race, 'OPPP')), 3), '999') AS citizenship,
    CASE
        WHEN PT.religion IS NULL
            THEN '99'
        WHEN PT.religion IS NOT NULL
            THEN '0' + PT.religion
        END AS religion_code,
    RTRIM(PT.addr1) AS address,
    PT.moo,
    PT.addr2 AS street,
    RIGHT(TB.tambonCode, 2) AS subdistrict_code,
    RIGHT(PT.regionCode, 2) AS district_code,
    PT.areaCode AS province_code,
    TB.tambonCode AS address_id,
    replace(PT.phone, '-', '') AS telephone,
    replace(PT.mobilephone, '-', '') AS mobile,
    RTRIM(S.relatives) AS informname,
    S.relativePhone AS informtel,
    PT.medAlergy AS drugallergy
FROM dbo.PATIENT PT
LEFT JOIN dbo.PTITLE(NOLOCK) T ON T.titleCode = PT.titleCode
LEFT JOIN Tambon TB ON TB.tambonCode = PT.regionCode + PT.tambonCode
LEFT JOIN REGION R ON R.regionCode = PT.regionCode
LEFT JOIN dbo.PatSS(NOLOCK) S ON S.hn = PT.hn
LEFT JOIN PPOP_CON AS ctl ON ctl.CON_KEY = '000'