<cfquery name="TOPIC" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		FORUM_TOPIC
	WHERE 
		TOPICID = #attributes.TOPICID#
</cfquery>

