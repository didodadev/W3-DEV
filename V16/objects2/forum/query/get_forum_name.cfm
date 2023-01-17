<cfquery name="GET_FORUM_NAME" datasource="#DSN#">
	SELECT 
		FORUMNAME
	FROM 
		FORUM_MAIN
	WHERE
		FORUMID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.forumid#">
</cfquery>

