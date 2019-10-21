CREATE FUNCTION [dbo].[ccd_opd_visit_diag_text] (
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
			REPLACE(CASE
					WHEN s.CardID IS NULL
						OR s.CardID = ''
						THEN s.CardID
					ELSE s.CardID
					END, '-', '') AS cid,
			d.DiagNote AS diag_text
		FROM dbo.OPD_H AS o(NOLOCK)
		INNER JOIN dbo.PATDIAG AS d(NOLOCK) ON d.Hn = o.hn
			AND d.regNo = o.regNo
			AND d.DiagType <> 'P'
			AND dxtype IN ('1', '4')
		LEFT JOIN dbo.PatSS(NOLOCK) AS s ON s.hn = o.hn
		LEFT JOIN dbo.PPOP_CON AS ctl(NOLOCK) ON ctl.CON_KEY = '000'
		WHERE o.ipdStatus = '0'
			--and  o.registDate between @SDATE and @EDATE
			AND o.registDate BETWEEN '25620926'
				AND '25620926'
		)
GO


