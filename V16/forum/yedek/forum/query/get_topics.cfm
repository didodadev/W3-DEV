<cfquery name="TOPICS" datasource="#dsn#">
	SELECT 
		*
	FROM 
		FORUM_TOPIC
	WHERE 
		FORUM_TOPIC.FORUMID = #attributes.FORUMID#
		AND FORUM_TOPIC.TOPIC_STATUS = 1
	ORDER BY 
		RECORD_DATE DESC
</cfquery>