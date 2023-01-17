<!--- order_pre_rows kayıtları cekilerek bu ürünlerin detaylı promosyonları incelenir OZDEN20081106--->
<cfset useable_promotion_list=''>
<cfset required_prom_id_list=''>
<cfset action_type_required_prom_list=''>
<cfinclude template="../query/get_basket_express_member_detail.cfm">
<cfif get_all_pre_order_rows.recordcount>
	<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
		<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
			SELECT CONSUMER_CAT_ID,MEMBER_ADD_OPTION_ID FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
		</cfquery>	
		<cfquery name="GET_FIRST_ORDER" datasource="#DSN3#" maxrows="1">
			SELECT ORDER_DATE FROM ORDERS WHERE ORDER_STATUS = 1 AND CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> ORDER BY ORDER_DATE
		</cfquery>
		<cfif get_first_order.recordcount>
			<cfset new_record_date = createodbcdatetime(get_first_order.order_date)>
			<cfquery name="GET_CAMP_COUNT" datasource="#DSN3#">
				SELECT CAMP_ID FROM CAMPAIGNS WHERE CAMP_STATUS = 1 AND CAMP_FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_record_date#"> AND CAMP_STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			</cfquery>
		<cfelse>
			<cfset get_camp_count.recordcount = 1>
		</cfif>
	</cfif>
	<cfset used_promotion_list = listsort(valuelist(get_all_pre_order_rows.prom_id),"numeric","asc")>
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
			0 AS PROM_KONTROL,
			MEMBER_ORDER_COUNT,
			MEMBER_RECORD_LINE,
			IS_CONS_REF_PROM,
			IS_DEMAND_PRODUCTS,
			IS_DEMAND_ORDER_PRODUCTS,
			STARTDATE,
			FINISHDATE,
			DEMAND_CONTROL_DATE,
			DRP_RTR_FROM_PROM
		FROM
			PROMOTIONS 
		WHERE 
			<cfif isdefined('attributes.price_catid') and len(attributes.price_catid)>
				PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
			<cfelse>
				PRICE_CATID = -2 AND
			</cfif>
			IS_DETAIL = 1 AND
			LIST_WORK_TYPE = 0 AND <!--- kazanclar çalışma şekli 'veya' olan promosyonlar --->
			PROM_STATUS = 1 AND
			PROM_TYPE IN (0,2) AND <!---PROM_TYPE 2:dönemsel, 1:sipariş bazlı promosyon  --->
			STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#"> AND
			FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#"> AND
			DETAIL_PROM_TYPE = 1<!--- Katalog promosyonları --->
			<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
				AND ','+CONSUMERCAT_ID+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_consumer_cat.consumer_cat_id#,%">
				AND (','+WORK_CAMP_TYPE+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_camp_count.recordcount#,%"> OR WORK_CAMP_TYPE IS NULL)
				AND (','+MEMBER_ADD_OPTION_ID+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_consumer_cat.member_add_option_id#,%"> OR MEMBER_ADD_OPTION_ID IS NULL)
			</cfif>
	<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
		UNION ALL		
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
			0 AS PROM_KONTROL,
			MEMBER_ORDER_COUNT,
			MEMBER_RECORD_LINE,
			IS_CONS_REF_PROM,
			IS_DEMAND_PRODUCTS,
			IS_DEMAND_ORDER_PRODUCTS,
			STARTDATE,FINISHDATE,
			DEMAND_CONTROL_DATE,
			DRP_RTR_FROM_PROM
		FROM 
			PROMOTIONS 
		WHERE 
			<cfif isdefined('attributes.price_catid') and len(attributes.price_catid)>
				PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
			<cfelse>
				PRICE_CATID = -2 AND
			</cfif>
			IS_DETAIL = 1 AND
			LIST_WORK_TYPE = 0 AND <!--- kazanclar çalışma şekli 've' olan promosyonlar --->
			PROM_STATUS = 1 AND
			PROM_TYPE IN (0,2) AND
			STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#"> AND
			FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#"> AND
			WORK_CAMP_TYPE IS NOT NULL AND
			IS_CONS_REF_PROM = 0 AND
			','+WORK_CAMP_TYPE+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_camp_count.recordcount#,%"> AND
			DETAIL_PROM_TYPE = 2 AND<!--- Temsilci Programları --->
			','+CONSUMERCAT_ID+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_consumer_cat.consumer_cat_id#,%"> AND 
			(','+MEMBER_ADD_OPTION_ID+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_consumer_cat.member_add_option_id#,%"> OR MEMBER_ADD_OPTION_ID IS NULL)
		
		UNION ALL
		
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
			0 AS PROM_KONTROL,
			MEMBER_ORDER_COUNT,
			MEMBER_RECORD_LINE,
			IS_CONS_REF_PROM,
			IS_DEMAND_PRODUCTS,
			IS_DEMAND_ORDER_PRODUCTS,
			STARTDATE,
			FINISHDATE,
			DEMAND_CONTROL_DATE,
			DRP_RTR_FROM_PROM
		FROM 
			PROMOTIONS 
		WHERE 
			<cfif isdefined('attributes.price_catid') and len(attributes.price_catid)>
				PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
			<cfelse>
				PRICE_CATID = -2 AND
			</cfif>
			IS_DETAIL=1 AND
			LIST_WORK_TYPE = 0 AND <!--- kazanclar calisma sekli 've' olan promosyonlar --->
			PROM_STATUS = 1 AND
			PROM_TYPE IN (0,2) AND
			STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#"> AND
			FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#"> AND
			WORK_CAMP_TYPE IS NULL AND
			IS_CONS_REF_PROM = 1 AND<!--- Temsilci Oner programı --->
			DETAIL_PROM_TYPE = 2 AND<!--- Temsilci Programları --->
			','+CONSUMERCAT_ID+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_consumer_cat.consumer_cat_id#,%"> AND 
			(','+MEMBER_ADD_OPTION_ID+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_consumer_cat.member_add_option_id#,%"> OR MEMBER_ADD_OPTION_ID IS NULL)
	</cfif>
		ORDER BY 
			PROM_HIERARCHY,
			PROM_ID
	</cfquery>
	<cfif get_prom_info.recordcount>
		<cfset all_prom_list=valuelist(get_prom_info.prom_id)>
		<cfloop query="get_prom_info">
			<!--- <cfif currentrow eq 1 or get_prom_info.prom_type eq 2> ---> <!--- sadece donemsel promda siparisler yeniden alınıyor --->
			<cfset control_return_type =get_prom_info.drp_rtr_from_prom>
			<cfset attributes.prom_type_=get_prom_info.prom_type>
			<cfset attributes.demand_product_type = get_prom_info.is_demand_products>
			<cfset attributes.demand_order_product_type = get_prom_info.is_demand_order_products>
			<cfset attributes.demand_control_date = get_prom_info.demand_control_date>
			<cfinclude template="../query/get_basket_rows_for_promotion.cfm">
			<!--- </cfif> --->
			<cfset used_prom_work_count=0>
			<cfset control_prom_id=get_prom_info.prom_id>
			<cfset control_prom_count_value=get_prom_info.prom_kontrol>
			<cfset control_member_record_line = get_prom_info.member_record_line>
			<cfset control_member_order_count = get_prom_info.member_order_count>
			<cfset use_promotion=0>
			<cfset is_prom_flag =1>
			<cfset prom_prod_multiplier=0>
			<cfset prom_member_bakiye = 0>
			<cfif get_prom_info.is_cons_ref_prom eq 1> <!--- promosyon temsilci öner parametresine gore calısıyorsa --->
				<cfset is_prom_flag=0><!--- temsilci öner parametresine gore calısan promosyonlarda kosul bulunmaz, bu yüzden kontrole gerek yok --->
				<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
					<cfset ref_consumer_count = 0>
					<cfloop query="get_ref_cons">
						<cfif get_ref_cons.currentrow eq control_member_record_line or (control_member_record_line neq 3 and (get_ref_cons.currentrow mod 3) eq control_member_record_line) or (control_member_record_line eq 3 and (get_ref_cons.currentrow mod 3) eq 0)>
							<cfquery name="GET_ORDER_COUNT" datasource="#DSN3#">
								SELECT 
									ISNULL(COUNT(OO.ORDER_ID),0) CONS_ORDER_COUNT 
								FROM 
									ORDERS OO 
								WHERE 
									OO.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_ref_cons.consumer_id#"> AND
									OO. ORDER_STATUS = 1 AND
									OO.IS_INSTALMENT IS NULL AND 
									((OO.PURCHASE_SALES = 1 AND OO.ORDER_ZONE = 0) OR (OO.PURCHASE_SALES = 0 AND OO.ORDER_ZONE = 1))
							</cfquery>
							<cfif get_order_count.cons_order_count gte control_member_order_count>
								<cfset prom_member_bakiye = prom_member_bakiye + 1> <!--- onerdigim temsilci sayısına gore promosyondan faydalanma sayısı tesbit ediliyor --->
							</cfif>
						</cfif>
					</cfloop>
					<cfif prom_member_bakiye gt 0>
						<cfquery name="GET_PROM_ORDER_COUNT" datasource="#DSN3#">
							SELECT
								ISNULL(SUM(ORR.QUANTITY),0) AS TOTAL_PRODUCT
							FROM
								ORDERS O,
								ORDER_ROW ORR,
								PROMOTIONS P
							WHERE
								O.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
								O.ORDER_STATUS = 1 AND
								O.ORDER_ID = ORR.ORDER_ID AND
								ORR.PROM_ID = P.PROM_ID AND
								ORR.IS_PROMOTION = 1 AND
								P.IS_CONS_REF_PROM = 1 AND
								P.PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_prom_id#">
						</cfquery>						
						<cfquery name="GET_TOTAL_PROM_PRODUCTS" datasource="#DSN3#">
							SELECT ISNULL(TOTAL_DISCOUNT_AMOUNT,0) AS ROW_PROM_COUNT FROM PROMOTIONS WHERE PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_prom_id#">
						</cfquery>
						<cfif prom_member_bakiye gt (get_prom_order_count.total_product/get_total_prom_products.row_prom_count)>
							<cfset prom_member_bakiye = prom_member_bakiye -(get_prom_order_count.total_product/get_total_prom_products.row_prom_count)>
							<cfset use_promotion=1>
						</cfif>
					</cfif>
				</cfif>
			<cfelseif len(get_prom_info.is_only_first_order) and get_prom_info.is_only_first_order eq 1>
				<cfquery name="CONTROL_ORDERS" datasource="#DSN3#">
					SELECT 
						ORDER_ID
					FROM
						ORDERS
					WHERE
						ORDER_STATUS = 1 AND 
						((PURCHASE_SALES = 1 AND ORDER_ZONE = 0) OR (PURCHASE_SALES = 0 AND ORDER_ZONE = 1))
						<cfif len(attributes.consumer_id)>
							AND CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
						<cfelse>
							AND PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
						</cfif>
				</cfquery>
				<cfif control_orders.recordcount>
					<cfset is_prom_flag =0>
				<cfelse>
					<cfset 'is_only_first_order_#control_prom_id#'=1>
				</cfif>
			<cfelseif get_prom_info.prom_type eq 2> <!--- promosyon calısma sayısı belirtilmisse veya donemsel promosyonsa kazandıgı promlardan daha önce aldıkları cıkarılır --->
			<!--- promosyon calısma sayısı,donemsel promosyonlarda kayıtlı siparişler uzerinden, sipariş bazlı promosyonlarda ise sepetteki prom sayısından  kontrol edilir--->
				<cfquery name="CONTROL_PROM_COUNT" datasource="#DSN3#">
					SELECT
						SUM(PROM_COUNT_1+PROM_COUNT_2) AS PROM_COUNT
					FROM
					(
						SELECT 
							COUNT(PROM_ID) AS PROM_COUNT_1,
							0 PROM_COUNT_2
						FROM
							ORDERS ORD,
							ORDER_ROW ORDR
						WHERE
							ORD.ORDER_ID = ORDR.ORDER_ID AND
							ORDR.PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_prom_id#"> AND
							ORD.ORDER_STATUS = 1 AND 
							((ORD.PURCHASE_SALES = 1 AND ORD.ORDER_ZONE = 0) OR (ORD.PURCHASE_SALES = 0 AND ORD.ORDER_ZONE = 1))
							<cfif len(attributes.consumer_id)>
								AND ORD.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
							<cfelse>
								AND ORD.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
							</cfif>
							<cfif attributes.prom_type_ eq 2>
								<cfif isdefined('get_prom_info.startdate') and len(get_prom_info.startdate)>
									AND ORD.ORDER_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(get_prom_info.startdate)#">
								</cfif>
								<cfif isdefined('get_prom_info.finishdate') and len(get_prom_info.finishdate)>
									AND ORD.ORDER_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(get_prom_info.finishdate)#">
								</cfif>								
							</cfif>
						UNION ALL	
							SELECT 
								0 PROM_COUNT_1,
								COUNT(PROMOTION_ID) PROM_COUNT_2
							FROM
								ORDER_DEMANDS
							WHERE
								PROMOTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_prom_id#"> AND 
								DEMAND_STATUS = 1
								<cfif len(attributes.consumer_id)>
									AND RECORD_CON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
								<cfelse>
									AND RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
								</cfif>
								<cfif attributes.prom_type_ eq 2>
									<cfif isdefined('get_prom_info.startdate') and len(get_prom_info.startdate)>
										AND RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(get_prom_info.startdate)#">
									</cfif>
									<cfif isdefined('get_prom_info.finishdate') and len(get_prom_info.finishdate)>
										AND RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDate(get_prom_info.finishdate)#">
									</cfif>								
								</cfif>
						)T1
				</cfquery>
				<cfif len(control_prom_count.prom_count) and len(get_prom_info.prom_work_count) and control_prom_count.prom_count gte get_prom_info.prom_work_count> <!--- uye icin verilen siparislerde calısma sayısından fazla kullanılmıs --->
					<cfset is_prom_flag =0>
					<cfset used_prom_work_count=control_prom_count.prom_count>
				<cfelseif len(control_prom_count.prom_count)> <!--- donemsel promosyonsa, promosyon calısma sayısı bos bırakılsa bile daha once kazandıgı promosyonlar hesaba katılır --->
					<cfset used_prom_work_count=control_prom_count.prom_count>
				</cfif>
			</cfif>
			<cfset is_prom_stock_list=''>
			<cfif is_prom_flag><!--- promosyon calısma sayısı asılmamıssa --->
				<cfquery name="GET_PROM_CONDITIONS" datasource="#DSN3#">
					SELECT 
						PROM_C.TOTAL_PRODUCT_AMOUNT,
						PROM_C.TOTAL_PRODUCT_PRICE,
						PROM_C.PROM_CONDITION_ID,
						PROM_CP.STOCK_ID,
						PROM_C.LIST_WORK_TYPE,
						PROM_CP.PRODUCT_AMOUNT,
						PROM_C.TOTAL_PRODUCT_PRICE_LAST,
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
						PROM_C.PROM_CONDITION_ID,
						'' AS STOCK_ID,
						PROM_C.LIST_WORK_TYPE,
						'' AS  PRODUCT_AMOUNT,
						PROM_C.TOTAL_PRODUCT_PRICE_LAST,
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
			<cfelseif isdefined('is_only_first_order_#control_prom_id#') and evaluate('is_only_first_order_#control_prom_id#') eq 1>
				<cfset use_promotion=1>
			</cfif>
			<cfif use_promotion><!--- promosyon kazanılmıssa --->
				<cfif get_prom_info.is_cons_ref_prom eq 1 and isdefined('prom_member_bakiye') and len(prom_member_bakiye)>
					<cfset 'prom_multiplier_#get_prom_info.prom_id#'=prom_member_bakiye>
				<cfelseif get_prom_info.prom_type eq 0 and len(get_prom_info.prom_work_count) and prom_prod_multiplier gt get_prom_info.prom_work_count>
				<!--- siparis bazlı promosyon ise ve kazanılan katsayı promosyon calısma sayısından fazla ise  katsayı değiştiriliyor --->
					<cfset 'prom_multiplier_#get_prom_info.prom_id#'=get_prom_info.prom_work_count>
				<cfelseif get_prom_info.prom_type eq 2 and len(used_prom_work_count)>
					<cfset 'prom_multiplier_#get_prom_info.prom_id#'=prom_prod_multiplier> <!----(prom_prod_multiplier-used_prom_work_count)--->
				<cfelse>
					<cfset 'prom_multiplier_#get_prom_info.prom_id#'=prom_prod_multiplier>
				</cfif>
				<cfset 'prom_related_stock_list_#get_prom_info.prom_id#'=is_prom_stock_list>
				<cfset useable_promotion_list=listappend(useable_promotion_list,get_prom_info.prom_id)><!--- promosyon kazanılmıssa --->

			</cfif>
		</cfloop>
	</cfif>
	<cfif listlen(useable_promotion_list) neq 0>
		<cfquery name="GET_ALL_USEABLE_PROM_PRODUCTS" datasource="#DSN3#">
			SELECT 
				PROM_P.PROMOTION_ID,
				PROM_P.STOCK_ID,
                PROM_P.PRODUCT_AMOUNT,
                PROM_P.PRODUCT_PRICE,
				S.IS_ZERO_STOCK,
				S.IS_INVENTORY,
				S.STOCK_CODE_2,				
				S.PROPERTY,
				S.PRODUCT_NAME,
				S.PRODUCT_UNIT_ID,
				P.TOTAL_DISCOUNT_AMOUNT,
				P.PROM_HEAD,
				P.PROM_NO,
				P.PRODUCT_PROMOTION_NONEFFECT
			FROM
				PROMOTIONS P,
				PROMOTION_PRODUCTS PROM_P,
				STOCKS S
			WHERE
				P.PROM_ID = PROM_P.PROMOTION_ID AND 
				PROM_P.STOCK_ID = S.STOCK_ID
			ORDER BY 
				PROM_P.PROMOTION_ID,
				S.STOCK_CODE_2				
		</cfquery>
		<cfquery name="GET_ALL_USED_PROM_PRODS" datasource="#DSN3#">
			SELECT
				ISNULL(PRE_STOCK_ID,STOCK_ID) AS STOCK_ID,
				ISNULL(PRE_PRODUCT_ID,PRODUCT_ID) AS PRODUCT_ID,
				ISNULL(PRE_STOCK_AMOUNT,QUANTITY) AS QUANTITY,
				PROM_ID,
				IS_GENERAL_PROM,
				ISNULL(IS_PROM_ASIL_HEDIYE,0) AS IS_PROM_ASIL_HEDIYE
			FROM
				ORDER_PRE_ROWS
			WHERE
				<cfif isdefined("session.pp")>
					RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
				<cfelseif isdefined("session.ww.userid")>
					RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
				<cfelseif isdefined("session.ep.userid")>
					RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
				<cfelse>
					1=2 AND
				</cfif>
				ISNULL(IS_PROM_ASIL_HEDIYE,0) = 1
		</cfquery>
		<cfif get_all_useable_prom_products.recordcount>
			<table cellspacing="1" cellpadding="1" align="center" class="color-border" style="width:100%">
				<tr class="color-row">
					<td colspan="5">
						<img src="../objects2/image/special_prom.gif">
					</td>
				</tr>
				<tr class="color-header" style="height:22px;">
					<td class="form-title" style="width:80px;"><cf_get_lang no ='389.Promosyon'></td>
					<cfif isdefined('attributes.is_prom_product_detail') and attributes.is_prom_product_detail eq 1> 
						<td class="form-title" style="width:200px;"><cf_get_lang_main no='217.Açıklama'></td>
					</cfif>
					<td>
						<table cellspacing="0" cellpadding="1" border="0" align="center" class="color-border" style="width:100%">
							<tr class="color-header" style="height:22px;">
								<cfif isdefined('attributes.is_prom_special_code') and attributes.is_prom_special_code eq 1> 
									<td class="form-title" style="width:90px;"><cf_get_lang_main no='1388.Ürün Kodu'></td>
								</cfif>
								<td class="form-title"><cf_get_lang_main no='809.Ürün Adı'></td>
								<td align="right" class="form-title" style="text-align:right; width:50px;"><cf_get_lang_main no ='223.Adet'></td>
								<td align="right" class="form-title" style="text-align:right; width:70px;"><cf_get_lang_main no ='672.Fiyat'></td>
							</tr>
						</table>
					</td>
                  	<td class="form-title"></td>
				</tr>
				<cfloop list="#useable_promotion_list#" index="useable_prom_id">
					<cfif get_prom_info.is_required_prom[listfind(all_prom_list,useable_prom_id)] eq 1> <!--- zorunlu promosyonlar listesi olusturuluyor --->
						<cfset required_prom_id_list=listappend(required_prom_id_list,useable_prom_id)>
					</cfif>
					<cfset show_prom=0>
					<cfif get_prom_info.prom_type[listfind(all_prom_list,useable_prom_id)] eq 2 ><!--- donemsel sipariste bu promosyondan kazanılmıs hediye satırları alınıyor --->
						<cfquery name="CONTROL_PROM_USED" datasource="#DSN3#">
							SELECT 
								SUM(TOTAL_QUANTITY) AS TOTAL_PROM_STOCK
								<cfif not (len(get_prom_info.TOTAL_DISCOUNT_AMOUNT[listfind(all_prom_list,useable_prom_id)]) and get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)] gt 0)>
									,STOCK_ID
								</cfif>
							FROM 
								(
									SELECT
										SUM(ISNULL(OPR.PRE_STOCK_AMOUNT,QUANTITY)) AS TOTAL_QUANTITY
										<cfif not (len(get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)]) and get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)] gt 0) >
											,ISNULL(OPR.PRE_STOCK_ID,OPR.STOCK_ID) AS STOCK_ID
										</cfif>
									FROM
										ORDER_PRE_ROWS OPR
									WHERE
										OPR.PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#useable_prom_id#"> AND
										<cfif isdefined("session.pp")>
											OPR.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
										<cfelseif isdefined("session.ww.userid")>
											OPR.RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
										<cfelseif isdefined("session.ep.userid")>
											OPR.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
										<cfelse>
											1=2 AND
										</cfif>
										ISNULL(OPR.IS_PROM_ASIL_HEDIYE,0)=1
										<cfif not (len(get_prom_info.TOTAL_DISCOUNT_AMOUNT[listfind(all_prom_list,useable_prom_id)]) and get_prom_info.TOTAL_DISCOUNT_AMOUNT[listfind(all_prom_list,useable_prom_id)] gt 0) >
											GROUP BY ISNULL(OPR.PRE_STOCK_ID,OPR.STOCK_ID)
										</cfif>
								UNION ALL								
									SELECT 
										SUM(ORD_R.QUANTITY) AS TOTAL_QUANTITY
										<cfif not (len(get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)]) and get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)] gt 0) >
											,ORD_R.STOCK_ID
										</cfif>
									FROM
										ORDERS ORR,
										ORDER_ROW ORD_R
									WHERE
										ORR.ORDER_ID = ORD_R.ORDER_ID AND
										(
											(ORR.PURCHASE_SALES = 1 AND ORR.ORDER_ZONE = 0) OR
											(ORR.PURCHASE_SALES = 0 AND ORR.ORDER_ZONE = 1)
										)
										AND ORD_R.PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#useable_prom_id#">
										AND ISNULL(ORD_R.IS_PROMOTION,0) = 1
										<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
											AND ORR.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
										<cfelseif isdefined('attributes.company_id') and len(attributes.company_id)>
											AND ORR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
											AND ORR.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.partner_id#">
										<cfelse>
											AND 1 = 2
										</cfif>
										<cfif len(get_prom_info.startdate[listfind(all_prom_list,useable_prom_id)])>
											AND ORR.ORDER_DATE >= #CreateODBCDate(get_prom_info.startdate[listfind(all_prom_list,useable_prom_id)])#
										</cfif>
										<cfif len(get_prom_info.finishdate[listfind(all_prom_list,useable_prom_id)])>
											AND ORR.ORDER_DATE <= #CreateODBCDate(get_prom_info.finishdate[listfind(all_prom_list,useable_prom_id)])#
										</cfif>
										AND ORR.ORDER_STATUS = 1
										<cfif not (len(get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)]) and get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)] gt 0) >
											GROUP BY ORD_R.STOCK_ID
										</cfif>
								) AS A1 
								<cfif not (len(get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)]) and get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)] gt 0)>
									GROUP BY 
										STOCK_ID
								</cfif>
							</cfquery>
						<cfelse>
							<cfquery name="CONTROL_PROM_USED" dbtype="query"> <!--- sipariste bu promosyondan kazanılmıs hediye satırları alınıyor --->
								SELECT 
									SUM(QUANTITY) AS TOTAL_PROM_STOCK,PROM_ID
									<cfif not (len(get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)]) and get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)] gt 0) >
										,STOCK_ID
									</cfif>
								FROM 
									GET_ALL_USED_PROM_PRODS 
								WHERE 
									PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#useable_prom_id#"> AND
									IS_PROM_ASIL_HEDIYE = 1 
								GROUP BY 
									PROM_ID
									<cfif not (len(get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)]) and get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)] gt 0) >
										,STOCK_ID
									</cfif>
							</cfquery>
						</cfif>
						<cfquery name="GET_USEABLE_PROM_" dbtype="query"><!--- sıfır stokla calısan veya envantere dahil olmayan veya satılabilir stogu pormosyon miktarını karsılayabilen kazan urunleri cekiliyor --->
							SELECT 
								* 
							FROM 
								GET_ALL_USEABLE_PROM_PRODUCTS 
							WHERE 
								PROMOTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#useable_prom_id#">
								<!---  AND (IS_INVENTORY=0 OR IS_ZERO_STOCK=1 OR SALEABLE_STOCK >= PRODUCT_AMOUNT) --->
						</cfquery>
						<cfset useable_prom_prod_list=valuelist(get_useable_prom_.stock_id)>
						<cfif len(control_prom_used.total_prom_stock)><!--- promosyon hareket tipi değiştir veya ekledegiştir ise promosyon urunu sepette varsa tekrar gosterilmez tek seferde secim yapılmalı--->
							<!--- <cfif not listfind('2,3',get_prom_info.PROM_ACTION_TYPE[listfind(all_prom_list,useable_prom_id)])> --->
								<cfif not len(get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)]) and control_prom_used.total_prom_stock lt (get_useable_prom_.product_amount[listfind(useable_prom_prod_list,control_prom_used.STOCK_ID)]*evaluate('prom_multiplier_#useable_prom_id#'))>
									<cfset 'used_stock_id_for_prom_#useable_prom_id#'=control_prom_used.stock_id>
									<cfset show_prom=1>
								<cfelseif len(get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)]) and get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)] gt 0 and control_prom_used.total_prom_stock lt get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)]*evaluate('prom_multiplier_#useable_prom_id#')>
									<cfset show_prom=1>
								</cfif>
							<!--- </cfif> --->
						<cfelse>
							<cfset show_prom=1>
						</cfif>
						<cfif isdefined('show_prom') and show_prom eq 1>
						<cfif len(useable_prom_prod_list) and len(get_prom_info.prom_action_type[listfind(all_prom_list,useable_prom_id)]) and listfind('2,3',get_prom_info.prom_action_type[listfind(all_prom_list,useable_prom_id)])>
							<cfquery name="CONTROL_REQUIRED_PROM_ROWS" datasource="#DSN3#">
								SELECT
									STOCK_ID,
									QUANTITY
								FROM
									ORDER_PRE_ROWS
								WHERE
									<cfif isdefined("session.pp")>
										RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
									<cfelseif isdefined("session.ww.userid")>
										RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
									<cfelseif isdefined("session.ep.userid")>
										RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND
									<cfelse>
										1 = 2 AND
									</cfif>
   									STOCK_ID IN (#useable_prom_prod_list#) AND
									(DEMAND_ID IS NULL AND PRICE <> 0)<!--- BK 20131001 Bekleyenden gelen urunlerin promosyonu calistirmamasi icin eklendi.--->
							</cfquery>
							<cfif control_required_prom_rows.recordcount>
								<cfif not listfind(required_prom_id_list,useable_prom_id)><!--- zorunlu promosyonlar arasında yoksa ekleniyor, promosyon zorunlu olmasa da basketteki urunleri degistir olarak set edildiginden böyle--->
									<cfset required_prom_id_list=listappend(required_prom_id_list,useable_prom_id)> 
								</cfif>
							</cfif>
						</cfif>
						<form name="add_last_proms_<cfoutput>#useable_prom_id#</cfoutput>" action="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_ajax_add_basket_prom_row" method="post">
							<cfoutput>
							<input type="hidden" name="add_prom_id_" id="add_prom_id_" value="#useable_prom_id#">
							<input type="hidden" name="add_prom_prod_count_" id="add_prom_prod_count_" value="#get_useable_prom_.recordcount#">
							<input type="hidden" name="add_prom_prod_noneffect_" id="add_prom_prod_noneffect_" value="#get_prom_info.product_promotion_noneffect[listfind(all_prom_list,useable_prom_id)]#">
							<input type="hidden" name="prom_action_type_" id="prom_action_type_" value="<cfif len(get_prom_info.prom_action_type[listfind(all_prom_list,useable_prom_id)])>#get_prom_info.prom_action_type[listfind(all_prom_list,useable_prom_id)]#<cfelse>1</cfif>"> 
							<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined('attributes.company_id') and len(attributes.company_id)></cfif>">
							<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)></cfif>">
							<input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)></cfif>">  
							</cfoutput>
							<tr class="color-row">
								<cfoutput>
								<td class="tableyazi">#get_prom_info.prom_head[listfind(all_prom_list,useable_prom_id)]#</td>
								</cfoutput>
								<cfif isdefined('attributes.is_prom_product_detail') and attributes.is_prom_product_detail eq 1> 
									<td class="tableyazi" style="width:200px;">
										<cfif len(control_prom_used.total_prom_stock)>
											Bu promosyondan <cfoutput>#control_prom_used.total_prom_stock#</cfoutput> adet ürün seçtiniz. <br>
											<cfif len(get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)])>
												Yandaki ürünlerden toplam <cfoutput>#((get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)]*evaluate('prom_multiplier_#useable_prom_id#'))-control_prom_used.total_prom_stock)#</cfoutput> adet daha seçim yapabilirsiniz.
												<cfset 'prom_stock_choice_amount_#useable_prom_id#'=((get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)]*evaluate('prom_multiplier_#useable_prom_id#'))-control_prom_used.total_prom_stock)>
											</cfif>
										<cfelseif len(get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)])>
											Yandaki ürünlerden toplam <cfoutput>#(get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)]*evaluate('prom_multiplier_#useable_prom_id#'))#</cfoutput> adet seçim yapabilirsiniz.
											<cfset 'prom_stock_choice_amount_#useable_prom_id#'=(get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)]*evaluate('prom_multiplier_#useable_prom_id#'))>
										</cfif>
									</td>
								<cfelse>
									<cfif len(control_prom_used.total_prom_stock)>
										<cfif len(get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)])>
											<cfset 'prom_stock_choice_amount_#useable_prom_id#'=((get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)]*evaluate('prom_multiplier_#useable_prom_id#'))-control_prom_used.total_prom_stock)>
										</cfif>
									<cfelseif len(get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)])>
										<cfset 'prom_stock_choice_amount_#useable_prom_id#'=(get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)]*evaluate('prom_multiplier_#useable_prom_id#'))>
									</cfif>
								</cfif>
								<td>
									<table style="width:100%">
										<cfoutput query="get_useable_prom_">
											<tr class="color-row">
												<input type="hidden" name="add_prom_stock_id_#currentrow#" id="add_prom_stock_id_#currentrow#" value="#get_useable_prom_.stock_id#">
												<cfif isdefined('attributes.is_prom_special_code') and attributes.is_prom_special_code eq 1> 
													<td class="tableyazi" style="width:90px;">#stock_code_2#</td>
												</cfif>
												<td class="tableyazi">#product_name# <cfif len(property)>-#property#</cfif></td>
												<td align="right" class="tableyazi" style="width:50px;text-align:right;" >
												<cfif not (len(get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)]) and get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)] gt 0)>
													<cfif isdefined('prom_multiplier_#get_prom_info.prom_id[listfind(all_prom_list,useable_prom_id)]#') and len(evaluate('prom_multiplier_#get_prom_info.prom_id[listfind(all_prom_list,useable_prom_id)]#'))>
														<cfset p_stock_amount=evaluate('prom_multiplier_#get_prom_info.prom_id[listfind(all_prom_list,useable_prom_id)]#')*product_amount>
													<cfelse>
														<cfset p_stock_amount=product_amount>
													</cfif>
													<cfif len(control_prom_used.total_prom_stock)>
														<cfif control_prom_used.stock_id eq get_useable_prom_.stock_id>
															<cfset p_stock_amount=p_stock_amount-control_prom_used.total_prom_stock>
														<cfelse>
															<cfset p_stock_amount=''>
														</cfif>
													</cfif>
													<input type="hidden" name="control_stock_amount_#currentrow#" id="control_stock_amount_#currentrow#" value="#p_stock_amount#">
													<input type="text" name="add_prom_amount_#currentrow#" id="add_prom_amount_#currentrow#" value="#p_stock_amount#" onkeyup="isNumber(this);" style="width:30px;" class="box2" validate="integer" onkeypress="if(event.keyCode==13) {add_prom_row_new('#useable_prom_id#',<cfif isdefined('prom_stock_choice_amount_#useable_prom_id#')>#evaluate('prom_stock_choice_amount_#useable_prom_id#')#<cfelse>''</cfif>,<cfif len(get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)])>1<cfelse>0</cfif>,'<cfif isdefined('used_stock_id_for_prom_#useable_prom_id#')>#evaluate('used_stock_id_for_prom_#useable_prom_id#')#</cfif>');return false;}">
												<cfelse>
													<input type="text" name="add_prom_amount_#currentrow#" id="add_prom_amount_#currentrow#" value="" onkeyup="isNumber(this);" style="width:30px;" class="box2" validate="integer" onkeypress="if(event.keyCode==13) {add_prom_row_new('#useable_prom_id#',<cfif isdefined('prom_stock_choice_amount_#useable_prom_id#')>#evaluate('prom_stock_choice_amount_#useable_prom_id#')#<cfelse>''</cfif>,<cfif len(get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)])>1<cfelse>0</cfif>,'<cfif isdefined('used_stock_id_for_prom_#useable_prom_id#')>#evaluate('used_stock_id_for_prom_#useable_prom_id#')#</cfif>');return false;}">
												</cfif>
												</td>
												<td align="right" class="tableyazi" style="width:70px;text-align:right;">#TLFormat(product_price)#</td>
											</tr>
										</cfoutput>
									</table>
								</td>
								<td>
									<cfoutput>
										<a href="##" name="add_prom_#useable_prom_id#" class="promSepet" title="Promosyonu Sepete At" onclick="add_prom_row_new('#useable_prom_id#',<cfif isdefined('prom_stock_choice_amount_#useable_prom_id#')>#evaluate('prom_stock_choice_amount_#useable_prom_id#')#<cfelse>''</cfif>,<cfif len(get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)])>1<cfelse>0</cfif>,'<cfif isdefined('used_stock_id_for_prom_#useable_prom_id#')>#evaluate('used_stock_id_for_prom_#useable_prom_id#')#</cfif>');"></a>
									</cfoutput>
								</td>
							</tr>				
							<!---<tr class="color-row">
								<td colspan="5" align="right" style="text-align:right;">
									<cfoutput>
                                		<a href="##" name="add_prom_#useable_prom_id#" class="promSepet" title="Promosyonu Sepete At" onClick="add_prom_row_new('#useable_prom_id#',<cfif isdefined('prom_stock_choice_amount_#useable_prom_id#')>#evaluate('prom_stock_choice_amount_#useable_prom_id#')#<cfelse>''</cfif>,<cfif len(get_prom_info.total_discount_amount[listfind(all_prom_list,useable_prom_id)])>1<cfelse>0</cfif>,'<cfif isdefined('used_stock_id_for_prom_#useable_prom_id#')>#evaluate('used_stock_id_for_prom_#useable_prom_id#')#</cfif>');"></a>
                                    </cfoutput>
								</td>
							</tr>--->
						</form>
					<cfelse>
						<cfif listfind(required_prom_id_list,useable_prom_id)><!--- zorunlu promosyonlar urunleri sepete eklenmisse, listeden siliniyor. sipariş kaydedilirken zorunlu promosyon listesi kontrol ediliyor--->
							<cfset required_prom_id_list=ListDeleteAt(required_prom_id_list,listfind(required_prom_id_list,useable_prom_id))> 
						</cfif>
					</cfif>
				</cfloop>
			</table>
		</cfif>
	</cfif>
</cfif>
<div id="_show_list_page_"></div>
<script type="text/javascript">
is_prom_run_detail_ = 0;//Promosyonlar tekrar tekrar çalışmasın diye eklendi
function add_prom_row_new(prom_id,useable_total_prom,multi_prod,required_stock_id)
{
	if(is_prom_run_detail_ == 0)
	{
		//is_prom_run_detail_ = 1;
		var _form_name_ = eval('document.add_last_proms_'+prom_id).name;
		_prod_total_amount_=0;
		var add_prom=1;
		for(var dd=1;dd <= eval('document.'+_form_name_+'.add_prom_prod_count_.value');dd=dd+1)
		{
			if(eval('document.'+_form_name_+'.add_prom_amount_'+dd)!= undefined && eval('document.'+_form_name_+'.add_prom_amount_'+dd).value!='')
			{
				if(eval('document.'+_form_name_+'.add_prom_amount_'+dd).value == 0)
					eval('document.'+_form_name_+'.add_prom_amount_'+dd).value='';
				else
				{
					if(required_stock_id!=undefined && required_stock_id!='' && required_stock_id != eval('document.'+_form_name_+'.add_prom_stock_id_'+dd).value)
					{
						alert('Farklı Bir Ürün Promosyon Olarak Eklenmiş. Sadece Aynı Üründen Ekleme Yapabilirsiniz!');
						add_prom=0;return false;
					}
					if( (multi_prod!=undefined && multi_prod==1) || _prod_total_amount_==0) //sadece toplam adet varsa farklı urun secebilir
						_prod_total_amount_=_prod_total_amount_+parseFloat(filterNum(eval('document.'+_form_name_+'.add_prom_amount_'+dd).value,0,0));
					else
					{
						alert('Bu Promosyon İçin Tek Çeşit Ürün Seçebilirsiniz! Seçimlerinizi Kontrol Ediniz.');
						add_prom=0;return false;
					}
					if(multi_prod!=undefined && multi_prod==0 && (wrk_round(eval('document.'+_form_name_+'.add_prom_amount_'+dd).value) > wrk_round(eval('document.'+_form_name_+'.control_stock_amount_'+dd).value)) )
					{
						alert('Bu Üründen En Fazla ' + eval('document.'+_form_name_+'.control_stock_amount_'+dd).value + ' Adet Seçebilirsiniz. Ürün Miktarını Kontrol Ediniz!');
						add_prom=0;return false;
					}
				}
			}
		}
		//promosyonu calıstırmadan once zorunlu ve oncelikli baska promosyon var mı kontrol ediliyor 
		if(_prod_total_amount_==0)
		{
			alert('Promosyon Ürün Seçiniz!');
			return false;
		}
		else if(useable_total_prom !='' && useable_total_prom < _prod_total_amount_)
		{
			alert('Toplam ' + useable_total_prom + ' Adet Promosyon Ürünü Seçebilirsiniz. Promosyon Ürün Miktarlarını Kontrol Ediniz!');
			return false;
		}
		else if(add_prom)
		{
			is_prom_run_detail_ = 1;
			eval('document.add_last_proms_'+prom_id).consumer_id.value = form_basket_list_base.consumer_id.value;
			eval('document.add_last_proms_'+prom_id).submit();
		}
	}
}
</script>

