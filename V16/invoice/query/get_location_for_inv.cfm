<cfquery name="get_location" datasource="#dsn#">
	SELECT 
		COMMENT,
		DEPARTMENT_LOCATION 
	FROM
		STOCKS_LOCATION 
	WHERE 
		LOCATION_ID=#search_location_id# 
	AND 
		DEPARTMENT_ID=#search_dep_id#
</cfquery>
