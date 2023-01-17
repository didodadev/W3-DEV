<cffunction name="get_paymethod_autocomplete" access="public" returnType="query" output="no">
    <cfargument name="paymethod" required="yes" type="string">
    <cfargument name="maxrows" required="yes" type="string" default="">
    <cfargument name="paymethod_tip" required="no" type="string" default="1,2">
    <cfquery name="GET_PAYMETHOD" datasource="#dsn#">
		<cfif ListFind(arguments.paymethod_tip,1,',')>
			SELECT 
				SP.PAYMETHOD,
				SP.PAYMETHOD_ID AS PAYMETHOD_ID,
				NULL AS PAYMENT_TYPE_ID
			FROM
				SETUP_PAYMETHOD SP,
				SETUP_PAYMETHOD_OUR_COMPANY SPOC
			WHERE 
				SP.PAYMETHOD_STATUS = 1
				AND SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
				AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				AND SP.PAYMETHOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.paymethod#%">
		</cfif> 
		<cfif ListFind(arguments.paymethod_tip,1,',') and ListFind(arguments.paymethod_tip,2,',')> 
			UNION ALL
		</cfif> 
		<cfif ListFind(arguments.paymethod_tip,2,',')>
			SELECT 
				CARD_NO AS PAYMETHOD,
				NULL AS PAYMETHOD_ID,
				PAYMENT_TYPE_ID
			FROM  
				#dsn3_alias#.CREDITCARD_PAYMENT_TYPE 
			WHERE 
				IS_ACTIVE = 1 AND
				CARD_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.paymethod#%">
		</cfif>
    </cfquery>
	<cfreturn get_paymethod>
</cffunction>
