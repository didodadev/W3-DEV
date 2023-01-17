<cfquery name="USER_REPLY_COUNT" datasource="#dsn#">
	SELECT 
		COUNT(REPLYID) TOTAL
	FROM 
		FORUM_REPLYS
	WHERE 
		USERKEY = '#attributes.USERKEY#'
	GROUP BY 
		USERKEY
</cfquery>
	
