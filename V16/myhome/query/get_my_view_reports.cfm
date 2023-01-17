<cfquery datasource="#DSN#" name="get_my_view_reports">
	SELECT
		REPORT_ID
	FROM
		REPORT_VIEW
	WHERE
		POSITION_CODE = #SESSION.EP.POSITION_CODE# 
</cfquery>
