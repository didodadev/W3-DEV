<cfquery name="DETAIL_VISITED_CONSUMER" datasource="#dsn#">
	SELECT
		CONSUMER_NAME,
		CONSUMER_SURNAME
	FROM
		CONSUMER
	WHERE 
		CONSUMER_ID = #NOTE_GIVEN_ID#
</cfquery>
