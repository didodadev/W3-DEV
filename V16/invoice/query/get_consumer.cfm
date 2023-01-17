<cfquery name="get_consumer" datasource="#dsn#">
	SELECT
		COMPANY,
		CONSUMER_NAME,
		CONSUMER_SURNAME
	FROM
		CONSUMER
	WHERE
		CONSUMER_ID =#attributes.consumer_id#
</cfquery>
