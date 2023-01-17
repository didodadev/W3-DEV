<cfquery name="FORUM" datasource="#dsn#">
	SELECT 
		*
	FROM 
		FORUM_MAIN
	WHERE
		FORUMID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.FORUMID#">
</cfquery>

