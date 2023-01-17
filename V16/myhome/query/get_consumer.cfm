<cfquery name="get_consumer" datasource="#dsn#">
	SELECT 
		CONSUMER_ID,
		CONSUMER_NAME,
		CONSUMER_SURNAME
	FROM 
		CONSUMER
	WHERE 
		<cfif isdefined("attributes.consumer_id")>
		CONSUMER_ID = #attributes.consumer_id#
		<cfelse>
		CONSUMER_ID IN (#LISTSORT(attributes.CONS_IDS,"NUMERIC")#)
		</cfif>
</cfquery>
