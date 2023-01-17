<cfquery name="REPLY_COUNT" datasource="#dsn#">
	SELECT 
		COUNT(REPLYID) AS TOTAL
	FROM 
		FORUM_REPLYS
	WHERE 
		TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.topicid#">
</cfquery>
	
