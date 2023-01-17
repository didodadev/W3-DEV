<cfquery name="GET_CONSUMER" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		CONSUMER
	WHERE 
		<cfif isdefined("URL.CID")>
		CONSUMER_ID = #URL.CID#	
		<cfelseif isdefined("attributes.consumer_id")>
		CONSUMER_ID = #attributes.consumer_id#
		</cfif>
</cfquery>
