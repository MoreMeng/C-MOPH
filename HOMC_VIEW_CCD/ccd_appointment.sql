ALTER VIEW [dbo].[ccd_appointment]
AS
SELECT ctl.PCUCODE AS hospcode,
    LTRIM(o.hn) AS hn,
    o.regNo AS vn,
    (CONVERT(DATE, CONVERT(CHAR(8), A.appoint_date - 5430000))) AS next_visit_date,
    -- CONVERT(TIME, (A.appoint_time_from), 108) AS next_visit_time,
    A.appoint_time_from AS next_visit_time,
    dc.CID AS doctor_cid,
    A.appoint_note AS app_note
FROM dbo.Appoint A(NOLOCK)
LEFT JOIN dbo.OPD_H o(NOLOCK) ON A.hn = o.hn AND (A.appoint_regNo = o.regNo OR (convert(CHAR, convert(NUMERIC, convert(CHAR, keyin_time, 112)) + 5430000) = o.registDate))
LEFT JOIN PROVIDER dc(NOLOCK) ON dc.PROVIDER = A.doctor
LEFT JOIN dbo.PPOP_CON ctl ON ctl.CON_KEY = '000'
WHERE o.registDate >= '25621001'
-- AND LTRIM(o.hn) = '18972'
