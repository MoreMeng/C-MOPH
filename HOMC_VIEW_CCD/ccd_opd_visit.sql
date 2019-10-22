ALTER VIEW [dbo].[ccd_opd_visit]
AS
SELECT DISTINCT ctl.PCUCODE AS hospcode,
    LTRIM(o.hn) AS hn,
    o.regNo AS vn,
    I.ladmit_n AS an,
    (convert(DATETIME, convert(CHAR, regist_date - 5430000))) AS vstdate,
    convert(TIME, (left(o.timePt, 2) + ':' + right(o.timePt, 2)), 108) AS vsttime,
    isnull(RTRIM(dbo.DEPTMAP(d.deptCode, 'OPPP')), '00100') AS clinic_code,
    CASE
        WHEN (dbo.PAYTYPEMAP(b.useDrg, 'OPPP') = NULL) OR (dbo.PAYTYPEMAP(b.useDrg, 'OPPP') = '')
            THEN '9100'
        ELSE isnull(dbo.PAYTYPEMAP(b.useDrg, 'OPPP'), '9100')
        END AS pttype_std_code,
    DEPT.deptDesc AS name,
    '' AS pttype_std_name
FROM dbo.OPD_H AS o(NOLOCK)
LEFT JOIN Ipd_h I(NOLOCK) ON I.hn = o.hn AND I.regist_flag = o.regNo
INNER JOIN Deptq_d d(NOLOCK) ON o.hn = d.hn AND o.regNo = d.regNo
INNER JOIN DEPT(NOLOCK) ON d.deptCode = DEPT.deptCode
INNER JOIN Bill_h AS b(NOLOCK) ON b.hn = o.hn AND b.regNo = o.regNo
LEFT JOIN PPOP_CON AS ctl ON ctl.CON_KEY = '000'
