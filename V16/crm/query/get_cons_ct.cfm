<cfquery name="GET_CONS_CT" datasource="#dsn#">
	SELECT
		*
	FROM
		CONSUMER,
		CONSUMER_CAT 
	WHERE
		CONSUMER.CONSUMER_CAT_ID = CONSUMER_CAT.CONSCAT_ID
		<cfif isDefined("attributes.search_potential") and LEN(attributes.search_potential)>
	AND 
		ISPOTANTIAL = #attributes.search_potential#
		</cfif>
		<cfif isDefined("attributes.search_status") and LEN(attributes.search_status)> 
	AND
		CONSUMER.CONSUMER_STATUS = #attributes.search_status#
		</cfif>
		<cfif isDefined("attributes.CONS_CAT") and len(attributes.CONS_CAT)>
	AND 
		CONSUMER.CONSUMER_CAT_ID=#attributes.CONS_CAT#
	AND 
		CONSUMER_CAT.CONSCAT_ID=#attributes.CONS_CAT#
		</cfif>
		<cfif isDefined("attributes.keyword") AND len(attributes.keyword)>
	AND 
		( 
		CONSUMER_NAME LIKE '%#attributes.keyword#%' OR CONSUMER_SURNAME LIKE '%#attributes.keyword#%'
		)
		</cfif>								
</cfquery>

