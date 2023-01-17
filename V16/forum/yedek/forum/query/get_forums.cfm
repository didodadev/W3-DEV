<cfquery name="FORUMS" datasource="#DSN#">
	SELECT
		FORUMID,
        FORUMNAME,
		ADMIN_POS
	FROM
		FORUM_MAIN
	WHERE
		FORUM_EMPS = 1 OR
		ADMIN_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ep.position_code#,%">
	ORDER BY
		FORUMNAME
</cfquery>	
	
