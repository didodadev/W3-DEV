<cfquery name="GET_CONTENT_CAT_NAME" datasource="#DSN#">
	SELECT 
		CONTENTCAT_ID, 
		CONTENTCAT 
	FROM 
		CONTENT_CAT 
	WHERE 
		CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.contentcat_id#">
</cfquery>


