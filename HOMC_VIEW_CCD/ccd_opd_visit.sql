ALTER VIEW [dbo].[ccd_opd_visit]
AS
SELECT DISTINCT CTL.PCUCODE AS hospcode,
    LTRIM(O.hn) AS hn,
    O.regNo AS vn,
    I.ladmit_n AS an,
    -- CONVERT(DATE, CONVERT(CHAR(8), (O.registDate - 10860000))) AS vstdate,
    (CONVERT(DATE, CONVERT(CHAR(8), O.registDate - 5430000))) AS vstdate,
    CONVERT(TIME, LEFT(O.timePt, 2) + ':' + SUBSTRING(O.timePt, 3, 2) + ':00') AS vsttime,
    ISNULL(RTRIM(dbo.DEPTMAP(Q.deptCode, 'OPPP')), '00100') AS clinic_code,
    CASE
        WHEN (dbo.PAYTYPEMAP(B.useDrg, 'OPPP') = NULL) OR (dbo.PAYTYPEMAP(B.useDrg, 'OPPP') = '')
            THEN '9100'
        ELSE ISNULL(RTRIM(dbo.PAYTYPEMAP(B.useDrg, 'OPPP')), '9100')
        END AS pttype_std_code,
    D.deptDesc AS name,
    PT.pay_typedes AS pttype_std_name
FROM dbo.OPD_H O(NOLOCK)
LEFT JOIN dbo.Ipd_h I(NOLOCK) ON I.hn = O.hn AND I.regist_flag = O.regNo
INNER JOIN dbo.Deptq_d Q(NOLOCK) ON O.hn = Q.hn AND O.regNo = Q.regNo
INNER JOIN dbo.DEPT D(NOLOCK) ON Q.deptCode = D.deptCode
INNER JOIN dbo.Bill_h B(NOLOCK) ON B.hn = O.hn AND B.regNo = O.regNo
LEFT JOIN dbo.Paytype PT WITH (NOLOCK) ON PT.pay_typecode = B.useDrg
LEFT JOIN dbo.PPOP_CON CTL ON CTL.CON_KEY = '000'
WHERE O.registDate > '25621001'
-- AND LTRIM(O.hn) = '81247'
