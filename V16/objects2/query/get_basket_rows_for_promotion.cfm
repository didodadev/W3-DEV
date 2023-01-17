<cfquery name="GET_ALL_PRE_ORDER_ROWS" datasource="#DSN3#">
	<cfif isdefined('check_prom_id_list') and isdefined('attributes.order_id') and len(attributes.order_id)><!--- servis urun iade bolumunden cagrılıyor --->
		SELECT 
			ORD_R.STOCK_ID,
			ORD_R.PRODUCT_ID,
			ORD_R.QUANTITY,
			ORD_R.PROM_ID,
			ORD_R.IS_GENERAL_PROM,
			S.IS_INVENTORY,
			0 AS STOCK_ACTION_TYPE,
			ISNULL(ORD_R.IS_PROMOTION,0) AS IS_PROM_ASIL_HEDIYE,
			ORD_R.IS_PRODUCT_PROMOTION_NONEFFECT,
			CASE WHEN (ORR.NETTOTAL-ORR.TAXTOTAL+ORR.SA_DISCOUNT)<=0 THEN (ORD_R.NETTOTAL+((ORD_R.NETTOTAL*ORD_R.TAX)/100)+ORD_R.OTVTOTAL) ELSE ((1-(ORR.SA_DISCOUNT/(ORR.NETTOTAL-ORR.TAXTOTAL+ISNULL(ORR.SA_DISCOUNT,0) ) ))*(ORD_R.NETTOTAL+((ORD_R.NETTOTAL*ORD_R.TAX)/100)+OTVTOTAL)) END AS ROW_TOTAL,
			1 AS RATE2,
			1 AS ROW_KONTROL
		FROM
			ORDERS ORR,
			ORDER_ROW ORD_R,
			STOCKS S
		WHERE
			ORR.ORDER_ID = ORD_R.ORDER_ID AND
			ORR.ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.order_id#"> AND
			ORD_R.STOCK_ID = S.STOCK_ID
			<cfif isdefined('attributes.stock_list') and len(attributes.stock_list)>
				AND ORD_R.STOCK_ID NOT IN (#attributes.stock_list#)
			</cfif>
			AND ISNULL(ORD_R.IS_PRODUCT_PROMOTION_NONEFFECT,0) = 0
			AND ORR.ORDER_STATUS = 1 
	<cfelse><!--- objects2 urun sepetinde kullanılıyor --->
		SELECT
			ISNULL(OPR.PRE_STOCK_ID,OPR.STOCK_ID) AS STOCK_ID,
			ISNULL(OPR.PRE_PRODUCT_ID,OPR.PRODUCT_ID) AS PRODUCT_ID,
			OPR.QUANTITY, <!--- PRE_STOCK_AMOUNT mu gelmeli? --->
			OPR.PROM_ID,
			OPR.IS_GENERAL_PROM,
			S.IS_INVENTORY,
			ISNULL(OPR.STOCK_ACTION_TYPE,0) AS STOCK_ACTION_TYPE,
			ISNULL(OPR.IS_PROM_ASIL_HEDIYE,0) AS IS_PROM_ASIL_HEDIYE,
			OPR.IS_PRODUCT_PROMOTION_NONEFFECT,
			<cfif isdefined("session.pp")>
				(OPR.PRICE_KDV*OPR.QUANTITY*SM.RATEPP2) AS ROW_TOTAL,
				SM.RATEPP2 RATE2
			<cfelseif isdefined("session.ww")>
				(ROUND(OPR.PRICE_KDV,2)*OPR.QUANTITY*SM.RATEWW2) AS ROW_TOTAL,
				SM.RATEWW2 RATE2
			<cfelse>	
				(OPR.PRICE_KDV*OPR.QUANTITY*SM.RATE2) AS ROW_TOTAL ,
				RATE2
			</cfif>,
			0 AS ROW_KONTROL
		FROM
			ORDER_PRE_ROWS OPR,
			STOCKS S,
			#dsn_alias#.SETUP_MONEY SM
		WHERE
			ISNULL(OPR.STOCK_ACTION_TYPE,0) NOT IN (1) AND <!--- bekleyen siparişe alınmaz aşamasındakiler promosyona dahil edilmiyor.--->
			<cfif (isdefined("attributes.demand_product_type") and attributes.demand_product_type eq 0) or not isdefined("attributes.demand_product_type")>
				ISNULL(OPR.STOCK_ACTION_TYPE,0) NOT IN (2,3) AND<!--- promosyondan gelen parametreye göre bekleyen siparişe alınan ürünler de dahil edilmiyor --->
			</cfif>
				ISNULL(OPR.IS_PRODUCT_PROMOTION_NONEFFECT,0) = 0 AND <!--- promosyonları etkilemeyen satırlar dahil edilmiyor --->
			<cfif (isdefined("attributes.demand_order_product_type") and attributes.demand_order_product_type eq 0)>
				OPR.DEMAND_ID IS NULL AND
			<cfelse>
				ISNULL(OPR.STOCK_ACTION_TYPE,0) <> -2 AND<!--- bekleyen siparişten eklenen ürünler parametreye göre promosyona ekleniyor stock_action_type -2 olanlar faiz olduğu için onlar alınmıyor--->
				<cfif isdefined("attributes.demand_control_date") and len(attributes.demand_control_date)><!--- Bekleyen siparişler için kontrol tarihi girildiyse ona göre kontrol yapıyor, yoksa hepsini alıyor --->
					<!--- ((OPR.DEMAND_ID IS NOT NULL AND OPR.DEMAND_ID IN(SELECT OD.DEMAND_ID FROM ORDER_DEMANDS OD WHERE OD.RECORD_DATE >= #createodbcdatetime(DATEADD('d',-1,attributes.demand_control_date))#)) OR OPR.DEMAND_ID IS NULL) AND --->
					((OPR.DEMAND_ID IS NOT NULL AND OPR.DEMAND_ID IN(SELECT OD.DEMAND_ID FROM ORDER_DEMANDS OD WHERE OD.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(dateadd('d',-1,attributes.demand_control_date))#">)) OR OPR.DEMAND_ID IS NULL) AND
				</cfif>
			</cfif>
			ISNULL(OPR.PRE_STOCK_ID,OPR.STOCK_ID) = S.STOCK_ID AND
			SM.MONEY = OPR.PRICE_MONEY AND
			<cfif isdefined("session.pp")>
				OPR.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
				SM.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#"> AND
			<cfelseif isdefined("session.ww.userid")>
				OPR.RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
				SM.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#"> AND
			<cfelseif isdefined("session.ep.userid")>
				OPR.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
				SM.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
			<cfelse>
				1=2 AND
			</cfif>
			ISNULL(OPR.PRE_STOCK_ID,OPR.STOCK_ID) IS NOT NULL
	</cfif>
	<cfif isdefined('attributes.prom_type_') and attributes.prom_type_ eq 2>
		UNION ALL
			SELECT 
				ORD_R.STOCK_ID,
				ORD_R.PRODUCT_ID,
				ORD_R.QUANTITY,
				ORD_R.PROM_ID,
				ORD_R.IS_GENERAL_PROM,
				S.IS_INVENTORY,
				0 AS STOCK_ACTION_TYPE,
				ISNULL(ORD_R.IS_PROMOTION,0) AS IS_PROM_ASIL_HEDIYE,
				ORD_R.IS_PRODUCT_PROMOTION_NONEFFECT,
				CASE WHEN (ORR.NETTOTAL-ORR.TAXTOTAL+ORR.SA_DISCOUNT)<=0 THEN (ORD_R.NETTOTAL+((ORD_R.NETTOTAL*ORD_R.TAX)/100)+ORD_R.OTVTOTAL) ELSE ((1-(ORR.SA_DISCOUNT/(ORR.NETTOTAL-ORR.TAXTOTAL+ISNULL(ORR.SA_DISCOUNT,0) ) ))*(ORD_R.NETTOTAL+((ORD_R.NETTOTAL*ORD_R.TAX)/100)+OTVTOTAL)) END AS ROW_TOTAL,
				1 AS RATE2,
				1 AS ROW_KONTROL
			FROM
				ORDERS ORR,
				ORDER_ROW ORD_R,
				STOCKS S
			WHERE
				ORR.ORDER_ID = ORD_R.ORDER_ID AND
				ORD_R.STOCK_ID = S.STOCK_ID AND
				ISNULL(ORD_R.IS_PRODUCT_PROMOTION_NONEFFECT,0) = 0 <!--- promosyonları etkilemeyen satırlar dahil edilmiyor --->
				AND 
				(
					(ORR.PURCHASE_SALES = 1 AND ORR.ORDER_ZONE = 0) OR
					(ORR.PURCHASE_SALES = 0 AND ORR.ORDER_ZONE = 1)
				)
				<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
					AND ORR.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
				<cfelseif isdefined('attributes.company_id') and len(attributes.company_id)>
					AND ORR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
					AND ORR.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#"> 
				</cfif>
				<cfif isdefined('get_prom_info.startdate') and len(get_prom_info.startdate)>
					AND ORR.ORDER_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(get_prom_info.startdate)#">
				</cfif>
				<cfif isdefined('get_prom_info.finishdate') and len(get_prom_info.finishdate)>
					AND ORR.ORDER_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(get_prom_info.finishdate)#">
				</cfif>
				AND ORR.ORDER_STATUS = 1 
	</cfif>
	<cfif isdefined("control_return_type") and control_return_type eq 1><!--- Iadeler dusuleecek --->
		UNION ALL
			SELECT 
				ORD_R.STOCK_ID,
				ORD_R.PRODUCT_ID,
				-1*ORD_R.AMOUNT QUANTITY,
				0 VPROM_ID,
				0 IS_GENERAL_PROM,
				S.IS_INVENTORY,
				0 AS STOCK_ACTION_TYPE,
				0 AS IS_PROM_ASIL_HEDIYE,
				0 IS_PRODUCT_PROMOTION_NONEFFECT,
				CASE WHEN (ORR.NETTOTAL-ORR.TAXTOTAL+ORR.SA_DISCOUNT)<=0 THEN -1*(ORD_R.NETTOTAL+((ORD_R.NETTOTAL*ORD_R.TAX)/100)+ORD_R.OTVTOTAL) ELSE -1*((1-(ORR.SA_DISCOUNT/(ORR.NETTOTAL-ORR.TAXTOTAL+ISNULL(ORR.SA_DISCOUNT,0) ) ))*(ORD_R.NETTOTAL+((ORD_R.NETTOTAL*ORD_R.TAX)/100)+OTVTOTAL)) END AS ROW_TOTAL,
				1 AS RATE2,
				1 AS ROW_KONTROL
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
</cfquery>
