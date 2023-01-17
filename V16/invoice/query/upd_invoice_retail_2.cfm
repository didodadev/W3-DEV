<cfquery name="UPD_INVOICE" datasource="#dsn2#">
	UPDATE 
		INVOICE 
	SET 
		IS_CASH=<cfif isDefined("attributes.cash")>#attributes.cash#,<cfelse>NULL,</cfif>
	<cfif isDefined("attributes.EMPO_ID") and len(attributes.EMPO_ID)>
		<cfif attributes.EMPO_ID neq 0>
			SALE_EMP=#EMPO_ID#,
			SALE_PARTNER=null,
		<cfelse>
			SALE_EMP=NULL,
			SALE_PARTNER=#PARTO_ID#,
		</cfif>
	</cfif>
	<cfif isDefined("attributes.company_id") and len(attributes.company_id)>
		COMPANY_ID=#attributes.company_id#,
		PARTNER_ID=<cfif isDefined("attributes.partner_id") and len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
		CONSUMER_ID=NULL,
	<cfelse>
		COMPANY_ID=NULL,
		PARTNER_ID=NULL,
		CONSUMER_ID=#attributes.consumer_id#,
	</cfif>
		IS_IPTAL=0,
		CANCEL_TYPE_ID = NULL,
		DEPARTMENT_ID=#attributes.department_id#,
		DEPARTMENT_LOCATION=#attributes.location_id#,
		DELIVER_EMP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LEFT(TRIM(DELIVER_GET),50)#">,
		NOTE=<cfif isDefined("NOTE") and len(NOTE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#NOTE#"><cfelse>NULL</cfif>,
		SHIP_METHOD=<cfif isdefined("attributes.ship_method") and len(attributes.ship_method)>#attributes.ship_method#<cfelse>NULL</cfif>,
		DUE_DATE = <cfif isdefined("invoice_due_date") and len(invoice_due_date)>#invoice_due_date#<cfelse>NULL</cfif>,
		INVOICE_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.INVOICE_NUMBER#">,
		INVOICE_DATE = #attributes.invoice_date#,
		INVOICE_CAT = #INVOICE_CAT#,
		NETTOTAL=#form.basket_net_total#,
		GROSSTOTAL=#form.basket_gross_total#,
		TAXTOTAL=#form.basket_tax_total#,
		OTV_TOTAL =	<cfif len(form.basket_otv_total)>#form.basket_otv_total#<cfelse>NULL</cfif>,
		SA_DISCOUNT = #form.genel_indirim#,
		OTHER_MONEY=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.basket_money#">,
		OTHER_MONEY_VALUE=#((form.BASKET_NET_TOTAL*form.BASKET_RATE1)/form.BASKET_RATE2)#,<!--- #form.basket_rate2# --->
		PROCESS_CAT = #FORM.PROCESS_CAT#,
		TEVKIFAT = <cfif isdefined("attributes.tevkifat_box")>1<cfelse>0</cfif>,
		TEVKIFAT_ORAN = <cfif isdefined("attributes.tevkifat_oran") and len(attributes.tevkifat_oran)>#attributes.tevkifat_oran#<cfelse>NULL</cfif>,
		TEVKIFAT_ID = <cfif isdefined("attributes.tevkifat_id") and len(attributes.tevkifat_id)>#attributes.tevkifat_id#<cfelse>NULL</cfif>,
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP=#SESSION.EP.USERID#,
		ZONE_ID=<cfif isdefined("get_customer_info.SALES_COUNTY") and len(get_customer_info.SALES_COUNTY)>#get_customer_info.SALES_COUNTY#<cfelse>NULL</cfif>,
		RESOURCE_ID = <cfif isdefined("get_customer_info.RESOURCE_ID") and len(get_customer_info.RESOURCE_ID)>#get_customer_info.RESOURCE_ID#<cfelse>NULL</cfif>,
		IMS_CODE_ID = <cfif isdefined("get_customer_info.IMS_CODE_ID") and len(get_customer_info.IMS_CODE_ID)>#get_customer_info.IMS_CODE_ID#<cfelse>NULL</cfif>,
		ASSETP_ID = <cfif isdefined("attributes.asset_id") and len(attributes.asset_id) and len(attributes.asset_name)>#attributes.asset_id#<cfelse>NULL</cfif>,
		CUSTOMER_VALUE_ID = <cfif isdefined("get_customer_info.CUSTOMER_VALUE_ID") and len(get_customer_info.CUSTOMER_VALUE_ID)>#get_customer_info.CUSTOMER_VALUE_ID#<cfelse>NULL</cfif>
		<cfif session.ep.our_company_info.project_followup eq 1>
			,PROJECT_ID = <cfif len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#<cfelse>NULL</cfif>
		</cfif>
    WHERE 
		INVOICE_ID = #form.invoice_id#
</cfquery>
