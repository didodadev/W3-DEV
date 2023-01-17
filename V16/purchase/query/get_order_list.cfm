<cfquery name="GET_ORDER_LIST" datasource="#DSN3#">
	SELECT 
		<cfif len(attributes.product_id) or len(attributes.currency_id) or len(attributes.position_code) or len(attributes.prod_cat)>
			DISTINCT
		</cfif>
		O.ORDER_ID,
		O.ORDER_NUMBER, 
		O.ORDER_CURRENCY, 
		O.RECORD_DATE, 
		O.ORDER_HEAD,
		O.PARTNER_ID,
		O.RECORD_EMP,
		O.COMPANY_ID,
        O.CONSUMER_ID,
		O.DELIVER_DEPT_ID,
		O.ORDER_DATE,
		O.IS_PROCESSED,
		O.PROJECT_ID,
	<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)><!--- Eğer satır bazında listeleme yapılıyorsa --->
		ORR.ORDER_ROW_ID,
		<cfif isdefined('xml_dsp_ship_amount_info_') and xml_dsp_ship_amount_info_ eq 1><!--- irsaliyelesen miktar listelenirken kullanılıyor --->
			ORR.WRK_ROW_ID,
		</cfif>
		<cfif (isdefined('xml_dsp_row_other_money_') and xml_dsp_row_other_money_ eq 1) or (isdefined('xml_dps_price_from_row_amount_') and xml_dps_price_from_row_amount_ eq 1)>
		ORR.PRICE_OTHER,
		</cfif>
		ORR.ORDER_ROW_CURRENCY,
		ORR.QUANTITY,
		ORR.CANCEL_AMOUNT,
		ORR.UNIT,
		ORR.STOCK_ID,
		PRODUCT.PRODUCT_ID,
		PRODUCT.PRODUCT_NAME,
		PRODUCT.PRODUCT_CODE,
		<cfif isdefined('xml_dps_price_from_row_amount_') and xml_dps_price_from_row_amount_ eq 1>
		ORR.PRICE,	
		</cfif>
		ORR.NETTOTAL AS NETTOTAL,
		ORR.OTHER_MONEY_VALUE AS OTHER_MONEY_VALUE,
		ORR.OTHER_MONEY AS OTHER_MONEY,
	<cfelse>
		O.NETTOTAL,
		O.OTHER_MONEY,
		O.OTHER_MONEY_VALUE,
	</cfif>
		O.ORDER_STAGE,
		(SELECT BRANCH_NAME FROM #dsn_alias#.BRANCH WHERE BRANCH_ID IN (SELECT BRANCH_ID FROM #dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = O.DELIVER_DEPT_ID)) AS BRANCH_NAME
	FROM 
		ORDERS O
	<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2) or len(attributes.prod_cat) or len(attributes.position_code)>
		,PRODUCT 
	</cfif>	
	<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2) or len(attributes.product_id) or len(attributes.currency_id) or len(attributes.prod_cat) or len(attributes.position_code)>
		,ORDER_ROW ORR
	</cfif>				
	WHERE 
		O.PURCHASE_SALES = 0 AND
		O.ORDER_ZONE = 0
	<cfif isdefined("attributes.start_date") and isdate(attributes.start_date) and isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
		AND O.ORDER_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
	</cfif>
	<cfif len(attributes.currency_id)>
		AND ORR.ORDER_ROW_CURRENCY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.currency_id#">
	</cfif>
	<cfif len(attributes.department_id)>
		AND O.DELIVER_DEPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
	</cfif>
	<cfif len(attributes.order_status)>
		AND O.ORDER_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.order_status#">
	</cfif>
	<cfif isdefined("attributes.project_id") and len (attributes.project_id) and isdefined("attributes.project_head") and len (attributes.project_head)>
		AND O.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
	</cfif>
	<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2) or len(attributes.product_id) or len(attributes.prod_cat) or len(attributes.position_code) or len(attributes.currency_id)>
		AND ORR.ORDER_ID = O.ORDER_ID
	</cfif>
	<cfif len(attributes.product_id) and len(attributes.product_name)>
		AND ORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
	</cfif>		
	<cfif len(attributes.position_code) and len(attributes.position_name)>
		AND PRODUCT.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">
	</cfif>
	<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2) or len(attributes.prod_cat) or len(attributes.position_code)>
		AND PRODUCT.PRODUCT_ID=ORR.PRODUCT_ID
	</cfif>	
	<cfif len(attributes.prod_cat)>
		AND PRODUCT.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.prod_cat#.%">
	</cfif>	
	<cfif len(attributes.keyword)>
		AND (
				O.ORDER_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
				O.ORDER_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			)
	</cfif>
	<cfif len(attributes.order_no)>
		AND O.ORDER_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.order_no#">
	</cfif>	
	<cfif isdefined('attributes.company_id') and len(attributes.company_id) and len(attributes.company)>
	   AND O.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
    <cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id) and len(attributes.company)>
       	AND O.CONSUMER_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
	</cfif>
	<cfif len(attributes.employee_id) and len(attributes.employee)>
	   AND O.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
	</cfif>
	<cfif isdefined('attributes.order_stage') and len(attributes.order_stage)>
		AND ORDER_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_stage#">
	</cfif>
	<cfif session.ep.isBranchAuthorization>
		AND DELIVER_DEPT_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">)
	</cfif>
	<cfif isdefined('attributes.zone_id') and len(attributes.zone_id)>
		AND DELIVER_DEPT_ID IN 
			(SELECT 
				D.DEPARTMENT_ID 
			FROM 
				#dsn_alias#.DEPARTMENT D,
				#dsn_alias#.BRANCH B
			WHERE 
				D.BRANCH_ID = B.BRANCH_ID AND
				B.ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#">
			)
	</cfif>
	ORDER BY
		<cfif attributes.sort_type eq 1>
			O.DELIVERDATE ASC,
		<cfelseif attributes.sort_type eq 2>
			O.DELIVERDATE DESC,
		<cfelseif attributes.sort_type eq 3>
			O.ORDER_DATE ASC,
		<cfelseif attributes.sort_type eq 4>
			O.ORDER_DATE DESC,
		</cfif>
		O.ORDER_ID DESC
</cfquery>
