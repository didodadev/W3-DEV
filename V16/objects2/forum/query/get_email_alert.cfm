<cfquery name="EMAIL_ALERT" datasource="#DSN#">
	SELECT
		EMAIL_EMPS
	FROM
		FORUM_TOPIC
	WHERE
		TOPICID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.topicid#">
</cfquery>
	
