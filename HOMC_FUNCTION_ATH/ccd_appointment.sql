CREATE FUNCTION [dbo].[ccd_appointment] (
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
			(convert(DATETIME, convert(CHAR, A.appoint_date - 5430000))) AS next_visit_date,
			convert(TIME, (appoint_time_from), 108) AS vsttime,
			dc.CID AS doctor_cid,
			A.appoint_note AS app_note
		FROM dbo.Appoint AS A
		LEFT JOIN dbo.OPD_H AS o ON A.hn = o.hn
			AND (
				A.appoint_regNo = o.regNo
				OR (convert(CHAR, convert(NUMERIC, convert(CHAR, keyin_time, 112)) + 5430000) = o.registDate)
				)
		LEFT JOIN PROVIDER AS dc(NOLOCK) ON dc.PROVIDER = A.doctor
		LEFT JOIN dbo.PPOP_CON AS ctl ON ctl.CON_KEY = '000'
		WHERE registDate BETWEEN @SDATE
				AND @EDATE
			AND ipdStatus = '0'
		)
GO


