ALTER VIEW [dbo].[ccd_opd_visit_diag_text]
AS
SELECT ctl.PCUCODE AS hospcode,
    LTRIM(o.hn) AS hn,
    o.regNo AS vn,
    REPLACE(CASE
            WHEN s.CardID IS NULL OR s.CardID = ''
                THEN s.CardID
            ELSE s.CardID
            END, '-', '') AS cid,
    d.DiagNote AS diag_text
FROM dbo.OPD_H AS o(NOLOCK)
INNER JOIN dbo.PATDIAG AS d(NOLOCK) ON d.Hn = o.hn AND d.regNo = o.regNo AND d.DiagType <> 'P' AND d.dxtype IN ('1', '4')
LEFT JOIN dbo.PatSS(NOLOCK) AS s ON s.hn = o.hn
LEFT JOIN dbo.PPOP_CON AS ctl(NOLOCK) ON ctl.CON_KEY = '000'
WHERE o.ipdStatus = '0' AND o.registDate >= '25621001'
AND (d.ICDCode IS NOT NULL) AND (d.ICDCode <> '') AND (d.DiagType = 'P')
-- AND LTRIM(o.hn) = '18972'
    -- AND o.registDate = '25621202'
