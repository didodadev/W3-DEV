<cfquery name="GET_CONSUMER_DETAIL" datasource="#dsn#">
	SELECT
		*
	FROM
		CONSUMER,
		CONSUMER_CAT
	WHERE
		CONSUMER.CONSUMER_ID = #CONSUMER_ID#
	AND
		CONSUMER.CONSUMER_CAT_ID=CONSUMER_CAT.CONSCAT_ID
</cfquery>

