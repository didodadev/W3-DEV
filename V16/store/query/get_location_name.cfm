<cfquery name="get_location_name" datasource="#dsn#">
	SELECT 
		COMMENT,
		DEPARTMENT_LOCATION 
	FROM
		STOCKS_LOCATION 
	WHERE 
		LOCATION_ID=#attributes.location_id# 
		AND 
		DEPARTMENT_ID=#attributes.department_id#
</cfquery>
