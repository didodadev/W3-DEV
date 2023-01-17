<cf_xml_page_edit fuseact="myhome.welcome">
<cfif not isDefined("control_purchase_sales")><cfset control_purchase_sales = 0></cfif>
<cfif not isDefined("control_offer_zone")><cfset control_offer_zone = 0></cfif>

<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
	<cfinclude template="../../member/query/get_ims_control.cfm">
</cfif>

<cfquery name="get_offer_list" datasource="#dsn3#">
	SELECT
		OFFER_ID,
		CONSUMER_ID,
		PARTNER_ID,
		OFFER_NUMBER,
		PRICE,
		OTHER_MONEY_VALUE,
		OTHER_MONEY,
		TAX TAXPRICE
	FROM 
		OFFER
	WHERE 
		PURCHASE_SALES = #control_purchase_sales# AND
		OFFER_ZONE = #control_offer_zone# AND
		<cfif control_offer_zone eq 0>
			(
				EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR
				RECORD_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR
				UPDATE_MEMBER = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR
				SALES_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
			) AND
		</cfif>
		OFFER_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',1,now())#"> AND
		OFFER_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',-1,now())#">
		<cfif session.ep.their_records_only eq 1>
			AND SALES_EMP_ID = #session.ep.userid#
		</cfif>
		<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
			AND
				(
				(CONSUMER_ID IS NULL AND COMPANY_ID IS NULL) 
				OR (COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#))
				OR (CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#))
				)
		</cfif>
	ORDER BY 
		OFFER.OFFER_DATE DESC	  
</cfquery>