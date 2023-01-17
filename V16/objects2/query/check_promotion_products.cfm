<cfsetting showdebugoutput="no">
<cfif isdefined('attributes.invoice_id') and len(attributes.invoice_id)>
	<cfset return_prom_id_list=''>
	<cfset check_prom_id_list=''>
	<cfquery name="GET_ORDERS" datasource="#DSN3#">
		SELECT 
			ORDER_ID
		FROM 
		 	ORDERS_INVOICE 
		WHERE 
			INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.invoice_id#"> AND 
			PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
	</cfquery>
	<cfif get_orders.recordcount>
		<cfquery name="GET_ORDER_ROW" datasource="#DSN3#">
			SELECT 
				SUM(ORR.QUANTITY),ORR.STOCK_ID,ORR.PROM_ID,
				ORD.PARTNER_ID,ORD.CONSUMER_ID
			FROM 
				ORDER_ROW ORR,
				ORDERS ORD
			WHERE
				ORD.ORDER_ID=ORR.ORDER_ID
				AND ORD.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_orders.order_id#">
				<cfif isdefined('attributes.stock_list') and len(attributes.stock_list)>
					AND ORR.STOCK_ID NOT IN (#attributes.stock_list#)
				</cfif>
			GROUP BY
				ORR.STOCK_ID,ORR.PROM_ID,
				ORD.PARTNER_ID, ORD.CONSUMER_ID
		</cfquery>
		<cfif len(get_order_row.partner_id)>
			<cfset attributes.partner_id=get_order_row.partner_id>
			<cfset attributes.consumer_id=''>
		<cfelse>
			<cfset attributes.partner_id=''>
			<cfset attributes.consumer_id=get_order_row.consumer_id>
		</cfif>
		<cfoutput query="get_order_row">
			<cfif len(prom_id) and not listfind(check_prom_id_list,prom_id)>
				<cfset check_prom_id_list=listappend(check_prom_id_list,prom_id)>
			</cfif> 
		</cfoutput>
		<cfset attributes.order_id=get_orders.order_id>
		<cfif listlen(check_prom_id_list)><!--- siparişte kullanılan promosyon varsa --->
			<cfquery name="GET_PROM_INFO" datasource="#DSN3#">
				SELECT 
					PROM_NO,
					PROM_HEAD,
					PROM_ID,
					PROM_TYPE,
					IS_ONLY_FIRST_ORDER,
					PROM_WORK_COUNT,
					ONLY_SAME_PRODUCT,
					PRICE_CATID,
					CONDITION_LIST_WORK_TYPE,
					PRODUCT_PROMOTION_NONEFFECT,
					TOTAL_DISCOUNT_AMOUNT,
					CONDITION_PRICE_CATID,
					PROM_ACTION_TYPE,
					STARTDATE,FINISHDATE,
					IS_REQUIRED_PROM,
					PROM_HIERARCHY,
					MEMBER_ORDER_COUNT,
					MEMBER_RECORD_LINE,
					IS_CONS_REF_PROM,
					IS_DEMAND_PRODUCTS,
					IS_DEMAND_ORDER_PRODUCTS,
					STARTDATE,FINISHDATE
				FROM
					PROMOTIONS 
				WHERE
					PROM_ID IN (#check_prom_id_list#) AND
					IS_DETAIL=1 AND
					PROM_TYPE IN (0,2)  <!---PROM_TYPE 2:dönemsel, 1:sipariş bazlı promosyon  --->
				ORDER BY PROM_HIERARCHY,PROM_ID
			</cfquery>
			<cfloop query="get_prom_info">
				<cfset attributes.prom_type_=get_prom_info.PROM_TYPE>
				<cfinclude template="get_basket_rows_for_promotion.cfm">
				<cfset control_prom_id=get_prom_info.prom_id>
				<cfset use_promotion=0>
				<cfset is_prom_stock_list=''>
				<cfset prom_prod_multiplier=1>
				<cfquery name="GET_PROM_CONDITIONS" datasource="#DSN3#">
					SELECT 
						PROM_C.TOTAL_PRODUCT_AMOUNT,
						PROM_C.TOTAL_PRODUCT_PRICE,
						PROM_C.TOTAL_PRODUCT_PRICE_LAST,
						PROM_C.PROM_CONDITION_ID,
						PROM_CP.STOCK_ID,
						PROM_C.LIST_WORK_TYPE,
						PROM_CP.PRODUCT_AMOUNT,
						PROM_C.TOTAL_PRODUCT_POINT
					FROM 
						PROMOTION_CONDITIONS PROM_C,
						PROMOTION_CONDITIONS_PRODUCTS PROM_CP
					WHERE 
						PROM_CP.PROM_CONDITION_ID = PROM_C.PROM_CONDITION_ID AND
						PROM_C.PROMOTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_prom_id#"> 
						
					UNION ALL
					
					SELECT 
						PROM_C.TOTAL_PRODUCT_AMOUNT,
						PROM_C.TOTAL_PRODUCT_PRICE,
						PROM_C.TOTAL_PRODUCT_PRICE_LAST,
						PROM_C.PROM_CONDITION_ID,
						'' AS STOCK_ID,
						PROM_C.LIST_WORK_TYPE,
						'' AS PRODUCT_AMOUNT,
						PROM_C.TOTAL_PRODUCT_POINT
					FROM 
						PROMOTION_CONDITIONS PROM_C
					WHERE
						PROM_C.PROM_CONDITION_ID NOT IN (SELECT PROM_CP.PROM_CONDITION_ID FROM PROMOTION_CONDITIONS_PRODUCTS PROM_CP ) AND
						PROM_C.PROMOTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_prom_id#">
					ORDER BY
						PROM_C.PROM_CONDITION_ID,
						STOCK_ID
				</cfquery>
				<cfinclude template="../display/dsp_promotion_conditions_scripts.cfm"><!--- promosyon kosulları degerlendirliyor  --->
				<cfif use_promotion neq 1><!--- promosyon kazanılmıssa --->
					<cfset return_prom_id_list=listappend(return_prom_id_list,get_prom_info.prom_id)>
				</cfif> 
			</cfloop>
			<cfif listlen(return_prom_id_list)>
				<cfquery name="GET_RETURN_PRODUCTS" datasource="#DSN3#">
					SELECT 
						(S.PRODUCT_NAME + S.PROPERTY) AS PRODUCT_NAME,ORR.STOCK_ID
					FROM 
						ORDER_ROW ORR,
						STOCKS S
					WHERE
						ORR.STOCK_ID=S.STOCK_ID
						AND ORR.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_orders.order_id#">
						AND ORR.PROM_ID IN (#return_prom_id_list#)
						AND ISNULL(ORR.IS_PROMOTION,0)=1
				</cfquery>
				<cfif get_return_products.recordcount>
					<script type="text/javascript">
						var prod_alert ='';
						<cfoutput query="get_return_products">
							prod_alert = prod_alert+ '#get_return_products.product_name# \n';
						</cfoutput>
						alert("Seçtiğiniz Ürünlerle Birlikte Aşağıdaki Promosyon Ürünlerini de İade Etmelisiniz!\n\n "+prod_alert);
					</script>
				</cfif>
			</cfif>
		</cfif>
	</cfif>
</cfif>
