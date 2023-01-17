<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
  <cf_date tarih = "attributes.start_date">
</cfif>
<cfquery name="get_ship_rows" datasource="#dsn2#">
	SELECT
		S.SHIP_NUMBER,
		S.SHIP_DATE,
		S.PARTNER_ID,
		S.CONSUMER_ID,
		S.COMPANY_ID,
		SR.SHIP_ID,
		SR.PURCHASE_SALES,
		SR.STOCK_ID,
		SR.AMOUNT,
		P.PRODUCT_NAME,
		P.PRODUCT_ID,
		ST.PRODUCT_ID,
		S.DEPARTMENT_IN, 
		S.DELIVER_STORE_ID, 
		ST.STOCK_CODE
	FROM
		SHIP S,
		SHIP_ROW SR,
		#dsn3_alias#.STOCKS ST,
		#dsn3_alias#.PRODUCT P
	WHERE
		S.SHIP_ID = SR.SHIP_ID AND
		SR.STOCK_ID = ST.STOCK_ID AND
		<cfif isdefined("stock_ids") and len(stock_ids)>
			SR.STOCK_ID NOT IN (#stock_ids#) AND
		</cfif>
		ST.PRODUCT_ID = P.PRODUCT_ID
		<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
			AND S.SHIP_DATE >= #attributes.start_date#
		</cfif>
		<cfif isDefined("attributes.department_id") and len(attributes.DEPARTMENT_ID)>
			AND (
					S.DEPARTMENT_IN = #attributes.DEPARTMENT_ID# 
					OR 			
					S.DELIVER_STORE_ID = #attributes.DEPARTMENT_ID#
				)
		</cfif> 
		<cfif isdefined('attributes.ship_no') and len(attributes.ship_no)>
			AND	S.SHIP_NUMBER  LIKE '%#attributes.ship_no#%'
		</cfif>
		<cfif isdefined('attributes.stock_id') and len(attributes.stock_id) and isdefined('attributes.product_name') and len(attributes.product_name)>
			AND P.PRODUCT_NAME = '#attributes.product_name#'
		</cfif>
		<cfif isDefined("attributes.take")>
			AND SR.PURCHASE_SALES = 0 
		<cfelseif isDefined("attributes.sale")>
			AND SR.PURCHASE_SALES = 1
		</cfif>
		<cfif len(attributes.consumer_id) and attributes.consumer_id gt 0>
			AND S.CONSUMER_ID = #attributes.consumer_id#
		</cfif>
		<cfif len(attributes.company_id) and attributes.company_id gt 0>
			AND S.COMPANY_ID = #attributes.company_id#		
		</cfif>
	ORDER BY 
		S.SHIP_DATE DESC
</cfquery>
