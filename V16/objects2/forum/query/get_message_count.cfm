<cfquery name="MESSAGE_COUNT" datasource="#dsn#">
	SELECT 
		COUNT(REPLYID) AS COUNT_REPLYS 
	FROM 
		FORUM_REPLYS 
	WHERE 
		TOPICID IN 
		(
		SELECT 
			TOPICID 
		FROM 
			FORUM_TOPIC 
		WHERE 
			FORUMID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.forumid#">
		) 
</cfquery>
	
