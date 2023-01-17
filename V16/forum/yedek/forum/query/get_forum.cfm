<cfquery name="FORUM" datasource="#DSN#">
	SELECT 
		*
	FROM 
		FORUM_MAIN
	WHERE
		FORUMID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.forumid#">
</cfquery>
