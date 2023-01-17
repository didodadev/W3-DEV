<cfquery name="get_consumer_name" datasource="#dsn#">
	SELECT
		CONSUMER_NAME,
		CONSUMER_SURNAME
	FROM
		CONSUMER
	WHERE
		CONSUMER_ID = #attributes.CONSUMER_ID#
</cfquery>
