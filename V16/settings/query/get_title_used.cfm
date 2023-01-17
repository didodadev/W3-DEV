<cfquery name="TITLE_USED" datasource="#dsn#" maxrows="1">
	SELECT 
		TITLE_ID
	FROM 
		EMPLOYEE_POSITIONS 
	WHERE 
		TITLE_ID = #attributes.title_id#
</cfquery>
