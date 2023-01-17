<cfquery name="get_subject_replies" datasource="#dsn#">
	SELECT
		TITLE,
		REPLY_COUNT 
	FROM
		FORUM_TOPIC
	ORDER BY 
		REPLY_COUNT DESC
</cfquery>
