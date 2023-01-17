<cfquery name="TOPIC" datasource="#DSN#">
	SELECT 
		FORUM_TOPIC_FILE,
        FORUM_TOPIC_FILE_SERVER_ID,
        IMAGEID,
        FORUMID,
        EMAIL_EMPS,
        LOCKED,
        TITLE,
        TOPIC 
	FROM 
		FORUM_TOPIC
	WHERE 
		TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.topicid#">
</cfquery>

