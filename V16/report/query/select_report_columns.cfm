<cfquery name="SELECT_REPORT_COLUMNS" datasource="#dsn#">
SELECT 
	TABLE_ID , 
	COLUMN_ID , 
	COLUMN_NAME , 
	COLUMN_INREPORT , 
	COLUMN_NAME_TR , 
	COLUMN_NAME_EN 
FROM
	REPORT_COLUMNS
WHERE 
	TABLE_ID = #url.table_id#
</cfquery>
