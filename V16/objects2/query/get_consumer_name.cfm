<cfquery name="get_consumer_name" datasource="#dsn#">
	SELECT
		CONSUMER_NAME,
		CONSUMER_SURNAME
	FROM
		CONSUMER
	WHERE
		CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
</cfquery>
