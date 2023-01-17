<cfquery name="GET_CONSUMER_NAME" datasource="#DSN#">
	SELECT
		CONSUMER_NAME,
		CONSUMER_SURNAME,
		CONSUMER_EMAIL,
		COMPANY
	FROM
		CONSUMER
	WHERE
		<cfif isDefined("attributes.consumer_id")>
            CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
        <cfelseif isDefined("consumer_id")>
            CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#consumer_id#">
        </cfif>
</cfquery>
