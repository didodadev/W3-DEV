<cfquery name="REPLIES" datasource="#DSN#">
	SELECT 
		REPLYID,
        USERKEY,
        IMAGEID,
        UPDATE_DATE,
        REPLY  
	FROM 
		FORUM_REPLYS
	WHERE 
		TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.topicid#"> AND
		RELATION_REPLYID IS NULL
</cfquery>
	
