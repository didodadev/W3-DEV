<cfquery name="TOPICS" datasource="#DSN#">
	SELECT 
    	IMAGEID,
        LOCKED,
        TOPICID,
        TITLE,
        USERKEY,
        REPLY_COUNT,
        VIEW_COUNT,
        LAST_REPLY_USERKEY,
        LAST_REPLY_DATE,
		RECORD_CON,
        RECORD_PAR,
        RECORD_DATE
	FROM 
		FORUM_TOPIC
	WHERE 
		FORUM_TOPIC.FORUMID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.forumid#">
</cfquery>

