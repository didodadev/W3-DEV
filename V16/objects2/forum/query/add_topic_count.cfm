<cfquery name="ADD_COUNT_TOPIC" datasource="#DSN#">
	UPDATE
		FORUM_TOPIC
	SET
		VIEW_COUNT = VIEW_COUNT + 1
	WHERE
		TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#topicid#">
</cfquery>	
	
