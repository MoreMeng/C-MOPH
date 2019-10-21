CREATE FUNCTION [dbo].[ccd_lab_result] (
	@SDATE CHAR(8),
	@EDATE CHAR(8)
	)
RETURNS TABLE
AS
RETURN (
		SELECT CTL.PCUCODE AS hospcode,
			LTRIM(O.hn) AS hn,
			O.regNo AS vn,
			(convert(DATETIME, convert(CHAR, LH.req_date - 5430000))) AS order_date,
			LR.lab_code AS hosp_lab_code,
			L.labName AS lab_group_name,
			TB.OUTVALUE AS provis_labcode,
			S.result_name AS lab_items_name,
			R.real_res AS lab_order_result,
			S.result_unit,
			R.low_normal + '-' + R.high_normal AS lab_items_normal_value
		FROM dbo.OPD_H(NOLOCK) AS O
		INNER JOIN dbo.Bill_h(NOLOCK) AS H ON H.hn = O.hn
			AND H.regNo = O.regNo
		LEFT JOIN dbo.Labreq_h AS LH ON LH.hn = O.hn
			AND LH.reg_flag = O.regNo
		INNER JOIN dbo.Labreq_d AS LR ON LR.req_no = LH.req_no
		INNER JOIN Lab AS L ON L.labType = LR.lab_type
			AND L.labCode = LR.lab_code
		INNER JOIN HCTABLEMAP AS TB ON TB.HCVALUE = LR.lab_code
			AND HCTABLE = 'Lab'
			AND TB.SYSMAP = 'OPPP'
		INNER JOIN Labres_d R ON R.req_no = LH.req_no
			AND LR.lab_type = R.lab_type
			AND R.lab_code = LR.lab_code
		INNER JOIN Labre_s S ON S.labType = R.lab_type
			AND S.lab_code = R.lab_code
		LEFT JOIN dbo.PatSS AS s(NOLOCK) ON s.hn = O.hn
		INNER JOIN dbo.PPOP_CON AS CTL ON CTL.CON_KEY = '000'
		WHERE
			--O.registDate between  '25620901' and '25620901'
			O.registDate BETWEEN @SDATE
				AND @EDATE
			AND O.ipdStatus = '0'
			AND LR.res_ready = 'Y'
		)
GO


