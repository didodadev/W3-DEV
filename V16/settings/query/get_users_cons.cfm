<cfif attributes.consumer_ids is "">
	<cfset attributes.consumer_ids = "0,0">
</cfif>

<cfquery name="GET_USERS_CONS" datasource="#dsn#">
	SELECT 
		CONSUMER_ID,
		CONSUMER_NAME,
		CONSUMER_SURNAME,
		CONSUMER_EMAIL
	FROM 
		CONSUMER
	WHERE
		CONSUMER_ID IN (#LISTSORT(attributes.CONSUMER_IDS,"NUMERIC")#)
	<cfif isDefined("attributes.searchKey") and len(attributes.searchKey)>
	AND
		(
		CONSUMER_NAME LIKE '%#attributes.searchKey#%'
		OR
		CONSUMER_SURNAME LIKE '%#attributes.searchKey#%'
		)
	</cfif>		
</cfquery>
