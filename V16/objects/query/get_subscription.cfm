 <cfif not isDefined("GET_SUBSCRIPTION_AUTHORITY")>
 	<!--- include edildiği sayfada çekilmiş olabilir bu nedenle kontrol ekledik Author: Tolga Sütlü, Ahmet Yolcu--->
	<cfset gsa = createObject("component","V16.objects.cfc.subscriptionNauthority")/>
	<cfset GET_SUBSCRIPTION_AUTHORITY= gsa.SelectAuthority()/>
</cfif>
<cfquery name="GET_SUBSCRIPTIONS" datasource="#DSN3#">
	SELECT
		SC.SUBSCRIPTION_ID,
		SC.PROJECT_ID,
		SC.SUBSCRIPTION_NO,
		SC.SUBSCRIPTION_HEAD,
		SC.COMPANY_ID,
		SC.PARTNER_ID,
		SC.CONSUMER_ID,
		SC.SUBSCRIPTION_TYPE_ID,
		SC.SUBSCRIPTION_STAGE,
		SC.SHIP_ADDRESS,
		SC.SHIP_COUNTRY_ID,
		SC.SHIP_CITY_ID,
		SC.SHIP_COUNTY_ID,
		SST.SUBSCRIPTION_TYPE,
		PTR.STAGE
	FROM
		SUBSCRIPTION_CONTRACT SC,
		SETUP_SUBSCRIPTION_TYPE SST,
		#dsn_alias#.PROCESS_TYPE_ROWS PTR
	WHERE
		SC.SUBSCRIPTION_TYPE_ID = SST.SUBSCRIPTION_TYPE_ID AND
		SC.SUBSCRIPTION_STAGE = PTR.PROCESS_ROW_ID 
		<cfif  len(attributes.keyword)>
			AND 
        	(
				SC.SUBSCRIPTION_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR 
				SC.SUBSCRIPTION_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
            )
	  	</cfif>
		<cfif isdefined("attributes.member_type") and (attributes.member_type is 'PARTNER') and len(attributes.member_name) and len(attributes.company_id)>
	        AND SC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
        </cfif>
		<cfif isdefined("attributes.subscription_type") and len(attributes.subscription_type)>
			AND SC.SUBSCRIPTION_TYPE_ID IN (#attributes.subscription_type#) 
		</cfif>
		<cfif isdefined("attributes.member_type") and (attributes.member_type is 'CONSUMER') and len(attributes.member_name) and len(attributes.consumer_id)>
	        AND SC.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
        </cfif>
		<cfif isdefined("attributes.subscription_status") and attributes.subscription_status eq "0">
	        AND SC.IS_ACTIVE = 0
        <cfelseif isdefined("attributes.subscription_status") and attributes.subscription_status eq "1">				
    	    AND SC.IS_ACTIVE = 1
        </cfif>
		<cfif get_subscription_authority.IS_SUBSCRIPTION_AUTHORITY eq 1>
			AND EXISTS 
			(
				SELECT
				SPC.SUBSCRIPTION_TYPE_ID
				FROM        
				#dsn#.EMPLOYEE_POSITIONS AS EP,
				SUBSCRIPTION_GROUP_PERM SPC
				WHERE
				EP.POSITION_CODE = #session.ep.position_code# AND
				(
					SPC.POSITION_CODE = EP.POSITION_CODE OR
					SPC.POSITION_CAT = EP.POSITION_CAT_ID
				)
					AND SC.SUBSCRIPTION_TYPE_ID = spc.SUBSCRIPTION_TYPE_ID
			)
		</cfif>
</cfquery>

