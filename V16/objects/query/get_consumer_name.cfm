<cfquery name="consumer_name" datasource="#dsn#">
	SELECT 
		CONSUMER_ID,
		CONSUMER_NAME,
		CONSUMER_SURNAME,
		COMPANY
	FROM
		CONSUMER
	WHERE
		CONSUMER_ID = #ATTRIBUTES.CONSUMER_ID#
</cfquery>

