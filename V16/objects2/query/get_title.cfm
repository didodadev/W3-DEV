<cfquery name="GET_TITLE" datasource="#DSN#">
	SELECT 
		TITLE
	FROM 
		SETUP_TITLE	
	WHERE 
		TITLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.title_id#">
</cfquery>
