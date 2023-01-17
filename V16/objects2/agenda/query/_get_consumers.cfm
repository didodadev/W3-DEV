<cfquery name="GET_CONSUMERS" datasource="#dsn#">
	SELECT 
		CONSUMER_ID,
		CONSUMER_NAME,
		CONSUMER_SURNAME
	FROM 
		CONSUMER
	WHERE
		CONSUMER_STATUS = 1
	<cfif isDefined("attributes.CONSUMER_CAT_ID")>
		AND
		CONSUMER_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CONSUMER_CAT_ID#">
	<cfelseif isDefined("attributes.CONSUMER_IDS")>
		AND
		CONSUMER_ID IN (#attributes.CONSUMER_IDS#)
	</cfif>
</cfquery>
