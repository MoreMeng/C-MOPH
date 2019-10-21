CREATE FUNCTION [dbo].[ccd_opd_visit_procedure] (
	-- Add the parameters for the function here
	@SDATE CHAR(8),
	@EDATE CHAR(8)
	)
RETURNS TABLE
AS
RETURN (
		SELECT ctl.PCUCODE AS hospcode,
			LTRIM(o.hn) AS hn,
			o.regNo AS vn,
			d.ICDCode AS icdcm,
			ICDCM1.DES AS proced_name,
			'' proced_type,
			dc.CID
		FROM dbo.OPD_H AS o(NOLOCK)
		INNER JOIN dbo.PATDIAG AS d(NOLOCK) ON d.Hn = o.hn
			AND d.regNo = o.regNo
			AND d.DiagType = 'P'
			AND dxtype IN ('1', '4')
		INNER JOIN ICDCM1(NOLOCK) ON ICDCM1.CODE = d.ICDCode
		INNER JOIN PROVIDER AS dc(NOLOCK) ON dc.PROVIDER = d.DocCode
		LEFT JOIN dbo.PPOP_CON AS ctl(NOLOCK) ON ctl.CON_KEY = '000'
		WHERE o.ipdStatus = '0'
			AND o.registDate BETWEEN @SDATE
				AND @EDATE
		)
GO

SELECT *
FROM ICDCM1
