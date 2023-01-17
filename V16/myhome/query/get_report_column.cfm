<cfquery name="GET_REPORT_COLUMN" datasource="#DSN#">
	SELECT
		REPORT_COLUMNS.*,
		REPORT_TABLES.TABLE_NAME,
		REPORT_TABLES.NICK_NAME_TR,
		REPORT_TABLES.PERIOD_YEAR
	FROM
		REPORT_COLUMNS,
		REPORT_TABLES
	WHERE
		REPORT_COLUMNS.COLUMN_ID = #attributes.column_id# AND
		REPORT_TABLES.TABLE_ID = REPORT_COLUMNS.TABLE_ID
</cfquery>