<cfquery name="REPLY_COUNT" datasource="#dsn#">
	SELECT 
		COUNT(REPLYID) AS TOTAL
	FROM 
		FORUM_REPLYS
	WHERE 
		TOPICID = #attributes.TOPICID#
</cfquery>
	
