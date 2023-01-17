<cfquery name="GET_PRIORITY" datasource="#DSN#">
	SELECT 
		PRIORITY_ID,
		#dsn#.Get_Dynamic_Language(PRIORITY_ID,'#session.ep.language#','SETUP_PRIORITY','PRIORITY',NULL,NULL,PRIORITY) AS PRIORITY
	FROM 
		SETUP_PRIORITY WITH (NOLOCK)
		<cfif isdefined("attributes.priority_id")>
	WHERE
		PRIORITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.priority_id#">
		</cfif>
	ORDER BY
		PRIORITY
</cfquery>
