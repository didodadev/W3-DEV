<cfquery name="GET_CONTENT_NAME" datasource="#DSN#">
	SELECT 
		CONTENT_ID,
		CONT_HEAD
	FROM 
		CONTENT 
	WHERE 
		CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.content_id#">
</cfquery>
