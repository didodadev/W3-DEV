<cfquery name="GET_CONSUMER_DET" datasource="#dsn#">
	SELECT 
		CONSUMER_NAME,
		CONSUMER_SURNAME,
		CONSUMER_ID
	FROM 
		CONSUMER
	WHERE 
		<cfif isdefined("attributes.CONSUMER_ID")>
		CONSUMER_ID =  #attributes.CONSUMER_ID #
		<cfelse>
		CONSUMER_ID IN (#LISTSORT(attributes.CONS,"NUMERIC")#)
		</cfif>
</cfquery>
