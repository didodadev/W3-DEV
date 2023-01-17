<cfquery name="GET_PROPERTY_NAME" datasource="#DSN#">
	SELECT 
		NAME
	FROM
		CONTENT_PROPERTY
	WHERE 
		CONTENT_PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#content_property_id#">
</cfquery>
