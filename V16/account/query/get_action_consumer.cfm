<cfquery name="GET_ACTION_CONSUMER" datasource="#dsn#">
	SELECT
		CONSUMER_NAME,
		CONSUMER_SURNAME,
		CONSUMER_EMAIL
	FROM
		CONSUMER
	WHERE
		CONSUMER_ID=#CONSUMER_ID#
</cfquery>

