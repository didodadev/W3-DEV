<cffunction name="get_paymethod" access="public" returnType="query" output="no">
    <cfargument name="paymethod" required="yes" type="string">
    <cfargument name="maxrows" required="yes" type="string" default="">
    <cfargument name="paymethod_tip" required="no" type="string" default="1,2">
    <cfquery name="GET_PAYMETHOD" datasource="#dsn#">
		<cfif ListFind(arguments.paymethod_tip,1,',')>
			SELECT 
				SP.PAYMETHOD,
				SP.PAYMETHOD_ID,
				SP.DUE_DAY,
				SP.PAYMENT_VEHICLE,
				NULL PAYMENT_TYPE_ID,
				NULL NUMBER_OF_INSTALMENT, 
				NULL COMMISSION_STOCK_ID,
				NULL COMMISSION_PRODUCT_ID,
				NULL COMMISSION_MULTIPLIER,
				NULL POS_TYPE
			FROM
				SETUP_PAYMETHOD SP,
				SETUP_PAYMETHOD_OUR_COMPANY SPOC
			WHERE 
				SP.PAYMETHOD_STATUS = 1
				AND SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
				AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				AND PAYMETHOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.paymethod#%">
		</cfif> 
		<cfif ListFind(arguments.paymethod_tip,1,',') and ListFind(arguments.paymethod_tip,2,',')> 
			UNION ALL
		</cfif> 
		<cfif ListFind(arguments.paymethod_tip,2,',')>
			SELECT 
				CARD_NO AS PAYMETHOD,
				NULL PAYMETHOD_ID,
				NULL DUE_DAY,
				NULL PAYMENT_VEHICLE,
				PAYMENT_TYPE_ID,
				NUMBER_OF_INSTALMENT, 
				COMMISSION_STOCK_ID,
				COMMISSION_PRODUCT_ID,
				COMMISSION_MULTIPLIER,
				POS_TYPE
			FROM  
				#dsn3_alias#.CREDITCARD_PAYMENT_TYPE 
			WHERE 
				IS_ACTIVE = 1 AND
				CARD_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.paymethod#%">
		</cfif>
    </cfquery>
<cfreturn get_paymethod>
</cffunction>
	 


