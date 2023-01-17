<cfquery name="GET_CONTENT_HEAD" datasource="#dsn#">
	SELECT 
		CONT_HEAD 
	FROM 
		CONTENT 
	WHERE 
		CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.content_id#">
</cfquery>
