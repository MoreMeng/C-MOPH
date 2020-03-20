ALTER VIEW [dbo].[ccd_dispense_items]
AS
SELECT ctl.PCUCODE AS hospcode,
    LTRIM(p.hn) AS hn,
    p.registNo AS vn,
    p.invCode AS hosp_drug_code,
    M.name AS drug_name,
    RTRIM(L1.lamed_name) + '  ' + RTRIM(p.lamedQty) + '  ' + RTRIM(L2.lamed_name) + '  ' + RTRIM(p.lamedTimeText) AS drug_usage,
    ISNULL(p.accQty, 0) AS qty,
    RTRIM(M.package) AS unit,
    CONVERT(FLOAT, ISNULL(M.opd_prc, 0)) AS unit_price,
    (CONVERT(FLOAT, ISNULL(p.accAmt, 0))) AS sum_price,
    LEFT(ISNULL(g.invGovCode24, M.code), 24) AS didstd,
    dc.TMTID AS tmtcode,
    M.last_lot_no AS lot_no,
    NULL AS serial_no
FROM dbo.Patmed AS p (NOLOCK)
LEFT JOIN dbo.OPD_H AS o WITH (NOLOCK) ON p.hn = o.hn AND p.registNo = o.regNo
LEFT JOIN dbo.Med_inv M WITH (NOLOCK) ON p.invCode = M.code AND M.site = '1'
LEFT JOIN dbo.Drugcatalog_producttype dc WITH (NOLOCK) ON dc.hospDrugCode = M.code
LEFT JOIN dbo.Lamed L1 WITH (NOLOCK) ON L1.lamed_code = p.lamedHow
LEFT JOIN dbo.Lamed L2 WITH (NOLOCK) ON L2.lamed_code = p.lamedUnit
LEFT JOIN dbo.Med_Gov24Map AS g WITH (NOLOCK) ON g.invCode = M.code AND g.invType = 'M'
LEFT JOIN dbo.PPOP_CON AS ctl WITH (NOLOCK) ON ctl.CON_KEY = '000'
WHERE p.registDate > '25621001'
    -- AND LTRIM(p.hn) = '144207' AND p.registNo = '0005'
    -- WHERE p.invCode = 'THCO1'
    -- WHERE dc.TMTID LIKE '1129720'