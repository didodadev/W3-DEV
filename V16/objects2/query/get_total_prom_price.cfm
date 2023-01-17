<cfif isdefined('control_prom_id') and len(control_prom_id) and isdefined('prom_condition_price_catid') and len(prom_condition_price_catid)>
	<cfif isdefined('check_prom_id_list') and isdefined('attributes.order_id') and len(attributes.order_id)><!--- servis iade urunden cagriliyorsa --->
		<cfquery name="get_total_price_info" datasource="#dsn3#">
			SELECT 
				SUM(PRICE_KDV*QUANTITY) AS TOTAL_PRICE
			FROM 
			(
			SELECT
				PRICE.PRICE_KDV,
				OPR.STOCK_ID,
				OPR.PRODUCT_ID,
				OPR.QUANTITY,
				OPR.PROM_ID,
				ISNULL(IS_PROMOTION,0) AS IS_PROM_ASIL_HEDIYE
			FROM
				ORDER_ROW OPR,
				PRICE
			WHERE
				ISNULL(OPR.IS_PRODUCT_PROMOTION_NONEFFECT,0)=0 AND <!--- promosyonları etkilemeyen satırlar dahil edilmiyor --->
				ISNULl(IS_PROMOTION,0)=0 AND
				OPR.PRODUCT_ID=PRICE.PRODUCT_ID AND
				<cfif isdefined('prom_condition_stock_list') and len(prom_condition_stock_list) and prom_condition_stock_list neq 0>
				OPR.STOCK_ID IN (#prom_condition_stock_list#) AND
				</cfif>
				<cfif isdefined('attributes.stock_list') and len(attributes.stock_list)>
				OPR.STOCK_ID NOT IN (#attributes.stock_list#) AND
				</cfif>
				OPR.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> AND
				PRICE.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#prom_condition_price_catid#"> AND
				ISNULL(PRICE.STOCK_ID,0)=0 AND 
				ISNULL(PRICE.SPECT_VAR_ID,0)=0 AND 
				PRICE.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#"> AND 
				(PRICE.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#"> OR PRICE.FINISHDATE IS NULL)
			UNION ALL
				SELECT 
					ISNULL(PP.PRODUCT_PRICE_OTHER_LIST,0) AS PRICE_KDV,
					OPR.STOCK_ID,
					OPR.PRODUCT_ID,
					OPR.QUANTITY,
					OPR.PROM_ID,
					ISNULL(IS_PROMOTION,0) AS IS_PROM_ASIL_HEDIYE
				FROM
					ORDERS ORD,
					ORDER_ROW OPR,
					PROMOTION_PRODUCTS PP
				WHERE
					ORD.ORDER_ID=OPR.ORDER_ID AND 
					ISNULL(OPR.IS_PROMOTION,0)=0 AND <!--- promosyonları etkilemeyen satırlar dahil edilmiyor --->
					ISNULl(IS_PROMOTION,0)=1 AND
					OPR.PRODUCT_ID=PP.PRODUCT_ID AND 
					OPR.STOCK_ID=PP.STOCK_ID AND 
					OPR.PROM_ID=PP.PROMOTION_ID AND 
					<cfif isdefined('prom_condition_stock_list') and len(prom_condition_stock_list) and prom_condition_stock_list neq 0>
					OPR.STOCK_ID IN (#prom_condition_stock_list#) AND
					</cfif>
					<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
					ORD.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
					<cfelseif isdefined('attributes.company_id') and len(attributes.company_id)>
					ORD.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
					ORD.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#"> AND
					</cfif>
					OPR.PROM_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#control_prom_id#">
			) AS A1
		</cfquery>
	<cfelse>
		<cfquery name="get_total_price_info" datasource="#dsn3#"><!--- hızlı siparisten urun eklerken promosyon calısma bolumu --->
			SELECT 
				SUM(PRICE_KDV*QUANTITY) AS TOTAL_PRICE
			FROM 
			(
			SELECT
				PRICE.PRICE_KDV,
				ISNULL(OPR.PRE_STOCK_ID,OPR.STOCK_ID) AS STOCK_ID,
				ISNULL(OPR.PRE_PRODUCT_ID,OPR.PRODUCT_ID) AS PRODUCT_ID,
				OPR.QUANTITY,
				OPR.PROM_ID,
				ISNULL(IS_PROM_ASIL_HEDIYE,0) AS IS_PROM_ASIL_HEDIYE
			FROM
				ORDER_PRE_ROWS OPR,
				PRICE
			WHERE
				ISNULL(OPR.STOCK_ACTION_TYPE,0) NOT IN (1) AND <!--- bekleyen siparişe alınmaz aşamasındakiler promosyona dahil edilmiyor --->
				<cfif (isdefined("demand_product_type") and demand_product_type eq 0) or not isdefined("demand_product_type")>
					ISNULL(OPR.STOCK_ACTION_TYPE,0) NOT IN (2,3) AND<!--- promosyondan gelen parametreye göre bekleyen siparişe alınan ürünler de dahil edilmiyor --->
				</cfif>
				ISNULL(OPR.IS_PRODUCT_PROMOTION_NONEFFECT,0)= 0 AND <!--- promosyonları etkilemeyen satırlar dahil edilmiyor --->
				<cfif (isdefined("demand_order_product_type") and demand_order_product_type eq 0) or not isdefined("demand_order_product_type")>
					OPR.DEMAND_ID IS NULL AND
				<cfelse>
					ISNULL(OPR.STOCK_ACTION_TYPE,0) <> -2 AND<!--- bekleyen siparişten eklenen ürünler parametreye göre promosyona ekleniyor stock_action_type -2 olanlar faiz olduğu için onlar alınmıyor--->
				</cfif>
				ISNULl(IS_PROM_ASIL_HEDIYE,0)=0 AND
				ISNULL(OPR.PRE_PRODUCT_ID,OPR.PRODUCT_ID) = PRICE.PRODUCT_ID AND
				<cfif isdefined('prom_condition_stock_list') and len(prom_condition_stock_list) and prom_condition_stock_list neq 0>
				ISNULL(OPR.PRE_STOCK_ID,OPR.STOCK_ID) IN (#prom_condition_stock_list#) AND
				</cfif>
				<cfif isdefined("session.pp")>
					OPR.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
				<cfelseif isdefined("session.ww.userid")>
					OPR.RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
				<cfelseif isdefined("session.ep.userid")>
					OPR.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
				<cfelse>
					1=2 AND
				</cfif>
				PRICE.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#prom_condition_price_catid#"> AND
				ISNULL(PRICE.STOCK_ID,0)=0 AND 
				ISNULL(PRICE.SPECT_VAR_ID,0)=0 AND 
				PRICE.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#"> AND 
				(PRICE.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#"> OR PRICE.FINISHDATE IS NULL)
			UNION ALL
				SELECT 
					ISNULL(PP.PRODUCT_PRICE_OTHER_LIST,0) AS PRICE_KDV,
					ISNULL(OPR.PRE_STOCK_ID,OPR.STOCK_ID) AS STOCK_ID,
					ISNULL(OPR.PRE_PRODUCT_ID,OPR.PRODUCT_ID) AS PRODUCT_ID,
					OPR.QUANTITY,
					OPR.PROM_ID,
					ISNULL(IS_PROM_ASIL_HEDIYE,0) AS IS_PROM_ASIL_HEDIYE
				FROM
					ORDER_PRE_ROWS OPR,
					PROMOTION_PRODUCTS PP
				WHERE
					ISNULL(OPR.STOCK_ACTION_TYPE,0) NOT IN (1) AND <!--- bekleyen siparişe alınmaz aşamasındakiler promosyona dahil edilmiyor --->
					<cfif (isdefined("demand_product_type") and demand_product_type eq 0) or not isdefined("demand_product_type")>
						ISNULL(OPR.STOCK_ACTION_TYPE,0) NOT IN (2,3) AND<!--- promosyondan gelen parametreye göre bekleyen siparişe alınan ürünler de dahil edilmiyor --->
					</cfif>
					ISNULL(OPR.IS_PRODUCT_PROMOTION_NONEFFECT,0)=0 AND <!--- promosyonları etkilemeyen satırlar dahil edilmiyor --->
					<cfif (isdefined("demand_order_product_type") and demand_order_product_type eq 0) or not isdefined("demand_order_product_type")>
						OPR.DEMAND_ID IS NULL AND
					<cfelse>
						ISNULL(OPR.STOCK_ACTION_TYPE,0) <> -2 AND<!--- bekleyen siparişten eklenen ürünler parametreye göre promosyona ekleniyor stock_action_type -2 olanlar faiz olduğu için onlar alınmıyor--->
					</cfif>
					ISNULL(IS_PROM_ASIL_HEDIYE,0)=1 AND
					ISNULL(OPR.PRE_PRODUCT_ID,OPR.PRODUCT_ID)=PP.PRODUCT_ID AND 
					ISNULL(OPR.PRE_STOCK_ID,OPR.STOCK_ID)=PP.STOCK_ID AND 
					OPR.PROM_ID=PP.PROMOTION_ID AND 
					<cfif isdefined('prom_condition_stock_list') and len(prom_condition_stock_list) and prom_condition_stock_list neq 0>
					OPR.PRE_STOCK_ID IN (#prom_condition_stock_list#) AND
					</cfif>
					<cfif isdefined("session.pp")>
						OPR.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
					<cfelseif isdefined("session.ww.userid")>
						OPR.RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
					<cfelseif isdefined("session.ep.userid")>
						OPR.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
					<cfelse>
						1=2 AND
					</cfif>
					OPR.PROM_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#control_prom_id#">
		<cfif isdefined("control_return_type") and control_return_type eq 1><!--- Iadeler düşülecek --->
			UNION ALL
				SELECT 
					CASE WHEN (ORR.NETTOTAL-ORR.TAXTOTAL+ORR.SA_DISCOUNT)<=0 THEN -1*(ORD_R.NETTOTAL+((ORD_R.NETTOTAL*ORD_R.TAX)/100)+ORD_R.OTVTOTAL) ELSE -1*((1-(ORR.SA_DISCOUNT/(ORR.NETTOTAL-ORR.TAXTOTAL+ISNULL(ORR.SA_DISCOUNT,0) ) ))*(ORD_R.NETTOTAL+((ORD_R.NETTOTAL*ORD_R.TAX)/100)+OTVTOTAL)) END AS PRICE_KDV,
					ORD_R.STOCK_ID AS STOCK_ID,
					ORD_R.PRODUCT_ID AS PRODUCT_ID,
					ORD_R.AMOUNT QUANTITY,
					0 PROM_ID,
					0 AS IS_PROM_ASIL_HEDIYE
				FROM
					#dsn2_alias#.INVOICE ORR,
					#dsn2_alias#.INVOICE_ROW ORD_R,
					STOCKS S
				WHERE
					ORR.INVOICE_ID = ORD_R.INVOICE_ID AND
					ORD_R.STOCK_ID = S.STOCK_ID AND
					ORR.INVOICE_CAT = 55
				<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
					AND ORR.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				<cfelseif isdefined('attributes.company_id') and len(attributes.company_id)>
					AND ORR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
					AND ORR.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#"> 
				</cfif>
				<cfif isdefined('get_prom_info.startdate') and len(get_prom_info.startdate)>
					AND ORR.INVOICE_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(get_prom_info.startdate)#">
				</cfif>
				<cfif isdefined('get_prom_info.finishdate') and len(get_prom_info.finishdate)>
					AND ORR.INVOICE_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(get_prom_info.finishdate)#">
				</cfif>
					AND ORR.IS_IPTAL = 0 
			</cfif>					
			) AS A1,
			STOCKS
			WHERE
				A1.STOCK_ID=STOCKS.STOCK_ID
				<!--- AND STOCKS.IS_INVENTORY=1 --->
		</cfquery>
	</cfif>
<cfelse>
	<cfset get_total_price_info.recordcount=0>
</cfif>

