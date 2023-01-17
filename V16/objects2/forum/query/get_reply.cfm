<cfquery name="REPLY" datasource="#DSN#">
	SELECT 
		TOPICID,
        REPLY,
        FORUM_REPLY_FILE,
        FORUM_REPLY_FILE_SERVER_ID,
        IMAGEID
	FROM 
		FORUM_REPLYS
	WHERE 
		REPLYID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.replyid#">
</cfquery>
