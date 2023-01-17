<cfquery name="GET_CONSUMER" datasource="#dsn#">
	SELECT 
		*
	FROM
		CONSUMER,
		CONSUMER_CAT
	WHERE
		CONSUMER.CONSUMER_CAT_ID=CONSUMER_CAT.CONSCAT_ID
		<cfif isDefined("attributes.CONSUMER_ID")>
		  <cfif len(attributes.CONSUMER_ID)>
			AND
			CONSUMER.CONSUMER_ID=#attributes.CONSUMER_ID#
		  <cfelse>
			AND
			CONSUMER.CONSUMER_ID=-1		  	
		  </cfif>	
		<cfelse>
			<cfif len(attributes.CONSUMER_NAME)>
			AND 
				CONSUMER_NAME LIKE '%#attributes.CONSUMER_NAME#%' 
			</cfif>
			<cfif len(attributes.CONSUMER_EMAIL)>
			AND 
				CONSUMER_EMAIL='#attributes.CONSUMER_EMAIL#'
			</cfif>
		
			<cfif len(attributes.CONSUMER_SURNAME)>
			AND 
				CONSUMER_SURNAME LIKE '%#attributes.CONSUMER_SURNAME#%'
			</cfif>
		
			<cfif len(attributes.COMPANY)>
			AND
				CONSUMER_COMPANY LIKE '%#attributes.COMPANY#%'
			</cfif>
		
			<cfif len(attributes.CONSUMER_ID)>
			AND
				CONSUMER_ID =#attributes.CONSUMER_ID#
			</cfif>
		</cfif>
</cfquery>

<cfif isdefined("attributes.CONSUMER_ID")>
    <cfif attributes.CONSUMER_ID EQ "">
        <cfset id=-1>
    <cfelse>
	    <cfset id = #attributes.CONSUMER_ID#> 
    </cfif>
	<cfquery name="GET_SERVICE_SUPPORT" datasource="#dsn3#">
		SELECT
			*
		FROM
			SERVICE_SUPPORT,
			#dsn_alias#.SETUP_SUPPORT AS SETUP_SUPPORT
		WHERE
			SERVICE_SUPPORT.SUPPORT_CAT_ID = SETUP_SUPPORT.SUPPORT_CAT_ID
			AND
			(SERVICE_SUPPORT.SALES_CONSUMER_ID=#id#
		OR
			SERVICE_SUPPORT.SERVICE_CONSUMER_ID=#id#)
		
	</cfquery>
</cfif>
