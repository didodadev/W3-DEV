<cfquery name="REPLY" datasource="#DSN#">
	SELECT 
		REPLYID,
        TOPICID,
        FORUM_REPLY_FILE,
        FORUM_REPLY_FILE_SERVER_ID,
        IMAGEID,
        REPLY,
        IS_ACTIVE,
        SPECIAL_DEFINITION_ID
	FROM 
		FORUM_REPLYS
	WHERE 
		REPLYID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.replyid#">
</cfquery>
