<cfquery name="USER_REPLY_COUNT" datasource="#DSN#">
	SELECT 
		COUNT(REPLYID) AS TOTAL
	FROM 
		FORUM_REPLYS
	WHERE 
		USERKEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.USERKEY#">
	GROUP BY 
		USERKEY
</cfquery>
	
