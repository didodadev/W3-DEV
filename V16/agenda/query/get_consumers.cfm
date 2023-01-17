<cfquery name="GET_CONSUMERS" datasource="#DSN#">
	SELECT 
		CONSUMER_ID,
		CONSUMER_NAME,
		CONSUMER_SURNAME
	FROM 
		CONSUMER
	WHERE
		CONSUMER_STATUS = 1
		<cfif isDefined("attributes.consumer_cat_id")>
            AND CONSUMER_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_cat_id#">
        <cfelseif isDefined("attributes.consumer_ids")>
            AND CONSUMER_ID IN (#attributes.consumer_ids#)
        </cfif>
</cfquery>
