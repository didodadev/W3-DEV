<cfquery name="HEAD_TOPIC" datasource="#DSN#">
	SELECT 
		FORUM_MAIN.FORUMID,
		FORUM_MAIN.FORUMNAME,
		FORUM_MAIN.ADMIN_POS,
		FORUM_MAIN.ADMIN_CONS,
		FORUM_MAIN.ADMIN_PARS,
		FORUM_MAIN.FORUM_CONS_CATS,
		FORUM_MAIN.FORUM_COMP_CATS,
		FORUM_MAIN.FORUM_EMPS,
		FORUM_MAIN.LAST_MSG_USERKEY,
		FORUM_MAIN.LAST_MSG_DATE,
		FORUM_MAIN.REPLY_COUNT,
		FORUM_MAIN.TOPIC_COUNT,
		FORUM_MAIN.RECORD_EMP,
		FORUM_TOPIC.TITLE, 
		FORUM_TOPIC.TOPIC, 
		FORUM_TOPIC.LOCKED, 
		FORUM_TOPIC.FORUM_TOPIC_FILE, 
		FORUM_TOPIC.IMAGEID,
		FORUM_TOPIC.USERKEY
	FROM 
		FORUM_TOPIC,  
		FORUM_MAIN
	WHERE 
		FORUM_MAIN.FORUMID = FORUM_TOPIC.FORUMID AND
		FORUM_TOPIC.TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.topicid#">
</cfquery>

