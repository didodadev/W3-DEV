<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
	<cfquery name="control_filter_par_id" datasource="#dsn#">
		SELECT
			PARTNER_ID
		FROM
			COMPANY_PARTNER 
		WHERE 
		COMPANY_PARTNER_NAME LIKE '%#attributes.keyword#%' OR
		COMPANY_PARTNER_SURNAME LIKE '%#attributes.keyword#%'
	</cfquery>
	<cfquery name="control_filter_comp_id" datasource="#dsn#">
		SELECT
			COMPANY_ID
		FROM
			COMPANY
		WHERE 
			NICKNAME LIKE '%#attributes.keyword#%'  
	</cfquery>
</cfif>
<cfquery name="GET_ORDER_LIST" datasource="#dsn3#">
	SELECT
	<cfif isdefined("attributes.product_id")>
		DISTINCT
	</cfif>
		ORDERS.ORDER_ID,
		ORDERS.CONSUMER_ID,
		ORDERS.PARTNER_ID,
		ORDERS.COMPANY_ID,
		ORDERS.ORDER_NUMBER,
		ORDERS.ORDER_CURRENCY,
		ORDERS.ORDER_HEAD,
		ORDERS.OTHER_MONEY,
		ORDERS.TAX,
		ORDERS.PRIORITY_ID,
		ORDERS.COMMETHOD_ID,
		ORDERS.GROSSTOTAL, 
		ORDERS.ORDER_CURRENCY, 
		ORDERS.ORDER_DATE, 
		ORDERS.DELIVERDATE, 
		ORDERS.RECORD_EMP, 
		ORDERS.ORDER_ZONE, 
		ORDERS.COMMETHOD_ID,
		<!--- ORDERS.SALES_POSITION_CODE, PK 02022006--->
		ORDERS.SALES_PARTNER_ID
	FROM 
	<cfif isDefined("FILTER_CAT") and len(filter_cat)>
		<cfif (FILTER_CAT CONTAINS "1") or (FILTER_CAT CONTAINS "3")>
			#dsn_alias#.CONSUMER AS CONSUMER,
		<cfelseif (FILTER_CAT CONTAINS "2") or (FILTER_CAT CONTAINS "4")>
			#dsn_alias#.COMPANY_PARTNER AS COMPANY_PARTNER,
			#dsn_alias#.COMPANY AS COMPANY,
		</cfif>
	</cfif>
	<cfif isdefined("attributes.product_id")>
		ORDER_ROW ORR,
	</cfif>
		ORDERS
	WHERE 
		(
			( ORDERS.PURCHASE_SALES = 1 AND ORDERS.ORDER_ZONE = 0 )
			OR
			( ORDERS.PURCHASE_SALES = 0 AND ORDERS.ORDER_ZONE = 1 )
		)
	<cfif isdefined("attributes.product_id")>
		 AND ORR.ORDER_ID = ORDERS.ORDER_ID
		 AND ORR.PRODUCT_ID = #attributes.product_id#
	</cfif>
	<cfif isDefined("filter_cat") and len(filter_cat)>
		<cfif filter_cat is "1">
		AND ORDERS.CONSUMER_ID = CONSUMER.CONSUMER_ID
		AND CONSUMER.ISPOTANTIAL = 0
		<cfelseif filter_cat is "3">
		AND ORDERS.CONSUMER_ID = CONSUMER.CONSUMER_ID
		AND CONSUMER.ISPOTANTIAL = 1
		<cfelseif filter_cat is "2">
		AND ORDERS.PARTNER_ID = COMPANY_PARTNER.PARTNER_ID
		AND COMPANY.ISPOTANTIAL = 0
		AND COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID
		<cfelseif filter_cat is "4">
		AND ORDERS.PARTNER_ID = COMPANY_PARTNER.PARTNER_ID
		AND COMPANY.ISPOTANTIAL = 1
		AND COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID
		</cfif>
	</cfif>
	<cfif isDefined("status") and len(status)>
		AND ORDERS.ORDER_STATUS = #status# 
	<cfelseif not isDefined("status")>
		AND ORDERS.ORDER_STATUS = 1 
	</cfif>
	<cfif isDefined("attributes.PRIORITY") and len(attributes.PRIORITY)>
	  AND ORDERS.PRIORITY_ID = #attributes.PRIORITY#
	</cfif>
	<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND
		(
			ORDERS.ORDER_HEAD LIKE '%#attributes.keyword#%' OR
			ORDERS.ORDER_NUMBER LIKE '%#attributes.keyword#%'
		<cfif control_filter_par_id.RECORDCOUNT>
			OR ORDERS.PARTNER_ID = #control_filter_par_id.PARTNER_ID#
		</cfif>
		<cfif control_filter_comp_id.RECORDCOUNT>
			OR ORDERS.COMPANY_ID = #control_filter_comp_id.COMPANY_ID#
		</cfif>
		)
	</cfif>
	<cfif isDefined("currency_id") and len(currency_id)>
		AND ORDERS.ORDER_CURRENCY = #currency_id#
	</cfif>
	<cfif isDefined("attributes.company_id") and  isDefined("attributes.ismyhome")>
		AND ORDERS.COMPANY_ID = #attributes.company_id#
	</cfif>
	<cfif isDefined("attributes.consumer_id") and  isDefined("attributes.ismyhome")>
		AND ORDERS.CONSUMER_ID = #attributes.consumer_id#
	</cfif>
	ORDER BY
		ORDERS.ORDER_DATE DESC
</cfquery>
