<!--- 20121019 FBS Kurumsal veya Bireysel Uyeler Icin Odeme Yontemlerini Getirir --->
<cfcomponent>
	<cffunction name="getMemberPaymentMethod" access="public" returntype="query">
		<cfargument name="our_company_id" type="numeric" required="yes" default="">
		<cfargument name="company_id" required="no" default="">
		<cfargument name="consumer_id" required="no" default="">
		<cfargument name="company_credit_id" required="no" default="">
		<cfargument name="is_sales_type" required="yes" default="1"><!--- 1 Satis, 0 Satinalma --->
		<cfargument name="dsn" required="yes" default="">
		<cfquery name="get_Member_Payment_Method" datasource="#arguments.dsn#">
			SELECT 
				CC.COMPANY_CREDIT_ID,
				CC.OUR_COMPANY_ID,
				CC.COMPANY_ID,
				CC.CONSUMER_ID,
				<cfif arguments.is_sales_type eq 1><!--- Satis --->
					CC.REVMETHOD_ID PAYMENT_METHOD_ID,
					CC.CARD_REVMETHOD_ID CARD_PAYMENT_METHOD_ID,
					CASE WHEN CC.REVMETHOD_ID IS NOT NULL THEN SP.PAYMETHOD ELSE CCP.CARD_NO END AS PAYMENT_METHOD_NAME,
					CASE WHEN CC.REVMETHOD_ID IS NOT NULL THEN SP.PAYMENT_VEHICLE ELSE -1 END AS PAYMENT_VEHICLE,
					CASE WHEN CC.REVMETHOD_ID IS NOT NULL THEN '' ELSE CCP.COMMISSION_MULTIPLIER END AS COMMISSION_MULTIPLIER,
					CASE WHEN CC.REVMETHOD_ID IS NOT NULL THEN SP.DUE_DAY ELSE '' END AS DUE_DAY
				<cfelse>
					CC.PAYMETHOD_ID PAYMENT_METHOD_ID,
					CC.CARD_PAYMETHOD_ID CARD_PAYMENT_METHOD_ID,
					CASE WHEN CC.PAYMETHOD_ID IS NOT NULL THEN SP.PAYMETHOD ELSE CCP.CARD_NO END AS PAYMENT_METHOD_NAME,
					CASE WHEN CC.PAYMETHOD_ID IS NOT NULL THEN SP.PAYMENT_VEHICLE ELSE -1 END AS PAYMENT_VEHICLE,
					CASE WHEN CC.PAYMETHOD_ID IS NOT NULL THEN '' ELSE CCP.COMMISSION_MULTIPLIER END AS COMMISSION_MULTIPLIER,
					CASE WHEN CC.PAYMETHOD_ID IS NOT NULL THEN SP.DUE_DAY ELSE '' END AS DUE_DAY
				</cfif>
			FROM 
				COMPANY_CREDIT CC
				<cfif arguments.is_sales_type eq 1>
					LEFT JOIN SETUP_PAYMETHOD SP ON SP.PAYMETHOD_ID = CC.REVMETHOD_ID
					LEFT JOIN #arguments.dsn#_#arguments.our_company_id#.CREDITCARD_PAYMENT_TYPE CCP ON CCP.PAYMENT_TYPE_ID = CC.CARD_REVMETHOD_ID
				<cfelse>
					LEFT JOIN SETUP_PAYMETHOD SP ON SP.PAYMETHOD_ID = CC.PAYMETHOD_ID
					LEFT JOIN #arguments.dsn#_#arguments.our_company_id#.CREDITCARD_PAYMENT_TYPE CCP ON CCP.PAYMENT_TYPE_ID = CC.CARD_PAYMETHOD_ID
				</cfif>
			WHERE
				<cfif isDefined("arguments.company_id") and Len(arguments.company_id)>
					CC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"> AND
				<cfelse>
					CC.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#"> AND
			   </cfif>
                    CC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.our_company_id#">
		</cfquery>
		<cfreturn get_Member_Payment_Method>
	</cffunction> 
</cfcomponent>

