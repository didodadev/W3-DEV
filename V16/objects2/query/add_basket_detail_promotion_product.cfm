<!--- order_pre_rows kayıtları cekilerek bu ürünlerin detaylı promosyonları eklenir OZDEN20081106--->

<cfif get_all_pre_order_rows.recordcount>
	<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
		<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
			SELECT 
            	CONSUMER_CAT_ID,
                MEMBER_ADD_OPTION_ID 
            FROM 
            	CONSUMER 
            WHERE 
            	CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
		</cfquery>	
		<cfquery name="GET_FIRST_ORDER" datasource="#DSN3#" maxrows="1">
			SELECT 
            	ORDER_DATE 
            FROM 
            	ORDERS 
            WHERE 
            	ORDER_STATUS = 1 AND 
                CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> 
            ORDER BY 
            	ORDER_DATE
		</cfquery>
		<cfif get_first_order.recordcount>
			<cfset new_record_date = createodbcdatetime(get_first_order.order_date)>
			<cfquery name="GET_CAMP_COUNT" datasource="#DSN3#">
				SELECT 
                	CAMP_ID 
                FROM 
                	CAMPAIGNS WHERE CAMP_STATUS = 1 AND 
                    CAMP_FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#new_record_date#"> AND 
                    CAMP_STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			</cfquery>
		<cfelse>
			<cfset get_camp_count.recordcount = 1>
		</cfif>
	</cfif>
	<cfset ord_row_list=''>
	<cfset used_prom_id_list=''>
	<cfquery name="DEL_PROM_ROWS_" datasource="#DSN3#"> <!--- daha once eklenmis ve li promosyonlar siliniyor --->
		DELETE FROM 
			ORDER_PRE_ROWS
		WHERE
			PROM_WORK_TYPE = 0 AND
			ISNULL(PROD_PROM_ACTION_TYPE,0) = 0 AND <!--- yeni eklenmiş promosyon kazanc urunleri siliniyor --->
			ISNULL(IS_PROM_ASIL_HEDIYE,0) = 1 AND 
			<cfif isdefined("session.pp")>
				RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
			<cfelseif isdefined("session.ww.userid")>
				RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
			<cfelseif isdefined("session.ep.userid")>
				RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
			<cfelse>
				1=2
			</cfif>
	</cfquery>
	<cfquery name="UPD_PROM_ROWS_" datasource="#DSN3#"> <!--- daha once baskete eklenip sonradan promosyon kazanc urunleriyle degiştirilmiş satırlar geri alınıyor --->
		UPDATE
			ORDER_PRE_ROWS
		SET
			PROD_PROM_ACTION_TYPE = 0,
			IS_PROM_ASIL_HEDIYE = 0,
			QUANTITY = ISNULL(QUANTITY_OLD,QUANTITY),
			PRICE = ISNULL(PRICE_OLD_2,PRICE),
			PRICE_MONEY = ISNULL(PRICE_OLD_MONEY_2,PRICE_MONEY),
			PRICE_KDV = ISNULL(PRICE_KDV_OLD,PRICE_KDV),
			IS_PRODUCT_PROMOTION_NONEFFECT = NULL,
			IS_NONDELETE_PRODUCT = NULL
		WHERE
			ISNULL(PROD_PROM_ACTION_TYPE,0) = 1 AND 
			<cfif isdefined('attributes.is_from_add_prom_prod') and attributes.is_from_add_prom_prod eq 1><!--- veyalı promosyon urunu eklenmisse, ve li promosyon urunleri silinip, yeniden hesaplanır --->
				PROM_WORK_TYPE = 0 AND
			</cfif>
				<!--- ISNULL(IS_PROM_ASIL_HEDIYE,0)=1 AND ---> 
			<cfif isdefined("session.pp")>
				RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
			<cfelseif isdefined("session.ww.userid")>
				RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
			<cfelseif isdefined("session.ep.userid")>
				RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
			<cfelse>
				1=2
			</cfif>
	</cfquery>
	<cfset order_total_money_credit = 0><!--- kazanılan para puan tutarı --->
	<cfset order_money_credit_count = 0><!--- kazanılan para puan sayısı --->
	<cfquery name="GET_PROM_INFO" datasource="#DSN3#"><!--- sipariS bazlİ oncelikli promosyon aliniyor --->
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
			LIST_WORK_TYPE,
			CONDITION_PRICE_CATID,
			PROM_ACTION_TYPE,
			PROM_HIERARCHY,0 AS PROM_KONTROL,
			MEMBER_ORDER_COUNT,MEMBER_RECORD_LINE,
			IS_CONS_REF_PROM,
			IS_DEMAND_PRODUCTS,
			IS_DEMAND_ORDER_PRODUCTS,
			STARTDATE,
			FINISHDATE,
			DEMAND_CONTROL_DATE,
			DRP_RTR_FROM_PROM,
			MONEY_CREDIT,
			VALID_DAY,
			CREDIT_PAY_TYPES,
			DETAIL_PROM_TYPE
		FROM 
			PROMOTIONS 
		WHERE 
			IS_DETAIL = 1 AND
			(LIST_WORK_TYPE = 1 OR (LIST_WORK_TYPE = 0 AND ISNULL(PROM_ACTION_TYPE,0) IN (2,3)) ) AND <!--- kazanclar çalışma şekli 've' olan promosyonlar VE  'değiştir veya ekle-değiştir' yöntemli veyalı promosyonlar --->
			PROM_STATUS = 1 AND
			PROM_TYPE IN (0,2) AND
			STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#"> AND
			FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#"> AND
			DETAIL_PROM_TYPE IN (1,3,4)<!--- Katalog , kredi kartı ve kargo promosyonları --->
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
                    TOTAL_DISCOUNT_AMOUNT,LIST_WORK_TYPE,
                    CONDITION_PRICE_CATID,PROM_ACTION_TYPE,PROM_HIERARCHY,1 AS PROM_KONTROL,MEMBER_ORDER_COUNT,MEMBER_RECORD_LINE,
                    IS_CONS_REF_PROM,IS_DEMAND_PRODUCTS,IS_DEMAND_ORDER_PRODUCTS,STARTDATE,FINISHDATE,DEMAND_CONTROL_DATE,DRP_RTR_FROM_PROM,
                    MONEY_CREDIT,
                    VALID_DAY,
                    CREDIT_PAY_TYPES,
                    DETAIL_PROM_TYPE
                FROM 
                    PROMOTIONS 
                WHERE 
                    <cfif isdefined('attributes.price_catid') and len(attributes.price_catid)>
                        PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
                    <cfelse>
                        PRICE_CATID = -2 AND
                    </cfif>
                    IS_DETAIL = 1 AND
                    (LIST_WORK_TYPE = 1 OR (LIST_WORK_TYPE = 0 AND ISNULL(PROM_ACTION_TYPE,0) IN (2,3)) ) AND <!--- kazanclar çalışma şekli 've' olan promosyonlar VE  'değiştir veya ekle-değiştir' yöntemli veyalı promosyonlar --->
                    PROM_STATUS = 1 AND
                    PROM_TYPE IN (0,2) AND
                    STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#"> AND
                    FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#"> AND
                    WORK_CAMP_TYPE IS NOT NULL AND
                    IS_CONS_REF_PROM = 0 AND
                    ','+WORK_CAMP_TYPE+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_camp_count.recordcount#,%"> AND
                    DETAIL_PROM_TYPE = 2 AND <!--- Temsilci Programları --->
                    ','+CONSUMERCAT_ID+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_consumer_cat.consumer_cat_id#,%"> AND 
                    (','+MEMBER_ADD_OPTION_ID+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_consumer_cat.member_add_option_id#,%"> OR MEMBER_ADD_OPTION_ID IS NULL)
                UNION ALL
                SELECT 
                    PROM_NO,PROM_HEAD,PROM_ID,PROM_TYPE,IS_ONLY_FIRST_ORDER,PROM_WORK_COUNT,ONLY_SAME_PRODUCT,PRICE_CATID,
                    CONDITION_LIST_WORK_TYPE,PRODUCT_PROMOTION_NONEFFECT,TOTAL_DISCOUNT_AMOUNT,LIST_WORK_TYPE,
                    CONDITION_PRICE_CATID,PROM_ACTION_TYPE,PROM_HIERARCHY,0 AS PROM_KONTROL,MEMBER_ORDER_COUNT,MEMBER_RECORD_LINE,
                    IS_CONS_REF_PROM,IS_DEMAND_PRODUCTS,IS_DEMAND_ORDER_PRODUCTS,STARTDATE,FINISHDATE,DEMAND_CONTROL_DATE,DRP_RTR_FROM_PROM,
                    MONEY_CREDIT,
                    VALID_DAY,
                    CREDIT_PAY_TYPES,
                    DETAIL_PROM_TYPE
                FROM 
                    PROMOTIONS 
                WHERE 
					<cfif isdefined('attributes.price_catid') and len(attributes.price_catid)>
                        PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
                    <cfelse>
                        PRICE_CATID = -2 AND
                    </cfif>
                    IS_DETAIL = 1 AND
                    (LIST_WORK_TYPE = 1 OR (LIST_WORK_TYPE = 0 AND ISNULL(PROM_ACTION_TYPE,0) IN (2,3)) ) AND <!--- kazanclar çalışma şekli 've' olan promosyonlar VE  'değiştir veya ekle-değiştir' yöntemli veyalı promosyonlar --->
                    PROM_STATUS = 1 AND
                    PROM_TYPE IN (0,2) AND
                    STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#"> AND
                    FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateODBCDateTime(now())#"> AND
                    WORK_CAMP_TYPE IS NULL AND
                    IS_CONS_REF_PROM = 1 AND<!--- Temsilci öner programı --->
                    DETAIL_PROM_TYPE = 2 AND<!--- Temsilci Programları --->
                    ','+CONSUMERCAT_ID+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_consumer_cat.consumer_cat_id#,%"> AND 
                    (','+MEMBER_ADD_OPTION_ID+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_consumer_cat.member_add_option_id#,%"> OR MEMBER_ADD_OPTION_ID IS NULL)
            </cfif>
		ORDER BY 
			PROM_HIERARCHY
	</cfquery>
	<cfif get_prom_info.recordcount>
		<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
			<cfquery name="GET_REF_CONS" datasource="#DSN#">
				SELECT 
					CONSUMER_ID 
				FROM 
					CONSUMER 
				WHERE 
					PROPOSER_CONS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
					CONSUMER_STATUS = 1 AND
					CONSUMER_ID IN(SELECT O.CONSUMER_ID FROM #dsn3_alias#.ORDERS O WHERE O.CONSUMER_ID IS NOT NULL AND ORDER_STATUS = 1)
				ORDER BY
					RECORD_DATE
			</cfquery>
		</cfif>
		<cfset credit_card_bank_payment_list = ''>
		<cfset cargo_product_id = ''>
		<cfset cargo_product_price = ''>
		<cfset cargo_product_tax = ''>
		<cfloop query="get_prom_info">
			<cfset control_prom_id=get_prom_info.prom_id>
			<cfset control_credit_types=get_prom_info.credit_pay_types>
			<cfset control_money_credit=get_prom_info.money_credit>
			<cfset control_valid_day=get_prom_info.valid_day>
			<cfset attributes.prom_type_=get_prom_info.prom_type>
			<cfset control_detail_prom_type=get_prom_info.detail_prom_type>
			<cfset control_return_type =get_prom_info.drp_rtr_from_prom>
			<cfset attributes.demand_product_type = get_prom_info.is_demand_products>
			<cfset attributes.demand_order_product_type = get_prom_info.is_demand_order_products>
			<cfset attributes.demand_control_date = get_prom_info.demand_control_date>
			<cfinclude template="get_basket_rows_for_promotion.cfm"><!--- yeni eklenen promosyonlarla beraber siparis satırları alınıyor --->
			<cfset prom_work_count = get_prom_info.prom_work_count>
			<cfset used_prom_work_count=0>
			<cfset use_promotion=0>
			<cfset control_prom_count_value = get_prom_info.prom_kontrol>
			<cfset control_member_record_line = get_prom_info.member_record_line>
			<cfset control_member_order_count = get_prom_info.member_order_count>
			<cfset is_prom_flag =1>
			<cfset prom_prod_multiplier=0>
			<cfset prom_member_bakiye = 0>
			<cfif get_prom_info.list_work_type eq 0 and len(get_prom_info.prom_action_type) and listfind('2,3',get_prom_info.prom_action_type)>
			<!--- değiştir, ekle-değiştir formatında veyalı promosyon ise sepette bulunan promosyon kazanç ürünleri için otomatik çalışır --->
				<cfif get_all_pre_order_rows.recordcount neq 0>
					<cfset control_pre_order_stock_for_prom_type=listsort(valuelist(get_all_pre_order_rows.stock_id),'numeric','asc')>
				<cfelse>
					<cfset control_pre_order_stock_for_prom_type=''>
				</cfif>
			</cfif>
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
							SELECT SUM(PRODUCT_AMOUNT) AS ROW_PROM_COUNT FROM PROMOTION_PRODUCTS WHERE PROMOTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_prom_id#">
						</cfquery>
						<cfif prom_member_bakiye gte (get_prom_order_count.total_product/get_total_prom_products.row_prom_count)>
							<cfset prom_member_bakiye = prom_member_bakiye -(get_prom_order_count.total_product/get_total_prom_products.row_prom_count) >
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
			<cfelseif get_prom_info.prom_type eq 2> 
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
									AND ORD.ORDER_DATE >= <cfqueryparam value="#CreateODBCDate(get_prom_info.startdate)#" cfsqltype="cf_sql_timestamp">
								</cfif>
								<cfif isdefined('get_prom_info.finishdate') and len(get_prom_info.finishdate)>
									AND ORD.ORDER_DATE <= <cfqueryparam value="#CreateODBCDate(get_prom_info.finishdate)#" cfsqltype="cf_sql_timestamp">
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
			<cfset add_prom_stock_list=''>
			<cfset order_total_price = 0>
			<cfif is_prom_flag><!--- promosyon calısma sayısı asılmamıssa --->
				<cfquery name="GET_PROM_CONDITIONS" datasource="#DSN3#">
					SELECT 
						PROM_C.TOTAL_PRODUCT_AMOUNT,
						PROM_C.TOTAL_PRODUCT_PRICE,
						ISNULL(PROM_C.TOTAL_PRODUCT_PRICE_LAST,0) TOTAL_PRODUCT_PRICE_LAST,
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
						ISNULL(PROM_C.TOTAL_PRODUCT_PRICE_LAST,0) TOTAL_PRODUCT_PRICE_LAST,
						PROM_C.PROM_CONDITION_ID,
						0 AS STOCK_ID,
						PROM_C.LIST_WORK_TYPE,
						0 AS PRODUCT_AMOUNT,
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
				<cfif len(control_money_credit) and control_money_credit gt 0>
					<cfif isDefined('session.ww.userid')>
                        <cfquery name="GET_MONEY_CREDITS" datasource="#DSN3#">
                            SELECT
                                ISNULL(SUM(MONEY_CREDIT-ISNULL(USE_CREDIT,0)),0) AS TOTAL_MONEY_CREDIT
                            FROM
                                ORDER_MONEY_CREDITS
                            WHERE
                                MONEY_CREDIT_STATUS = 1 AND
                                ISNULL(IS_TYPE,0) = 0 AND
                                VALID_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
                                CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
                        </cfquery>
                        <cfif get_money_credits.recordcount and len(get_money_credits.total_money_credit)>
							<cfset order_total_money_credit = order_total_money_credit + (order_total_price - get_money_credits.total_money_credit)*control_money_credit/100>
							<cfset order_money_credit_count = order_money_credit_count + 1>
                            <cfoutput>
                                <cfset "credit_rate_#order_money_credit_count#" = control_money_credit>
                                <cfset "order_total_money_credit_#order_money_credit_count#" = (order_total_price - get_money_credits.total_money_credit) * control_money_credit/100>
                                <cfset "credit_valid_date_#order_money_credit_count#" = dateformat(dateadd('d',control_valid_day,now()),'dd/mm/yyyy')>
                            </cfoutput>
                        <cfelse>	
							<cfset order_total_money_credit = order_total_money_credit + order_total_price*control_money_credit/100>
                            <cfset order_money_credit_count = order_money_credit_count + 1>
                            <cfoutput>
                                <cfset "credit_rate_#order_money_credit_count#" = control_money_credit>
                                <cfset "order_total_money_credit_#order_money_credit_count#" = order_total_price*control_money_credit/100>
                                <cfset "credit_valid_date_#order_money_credit_count#" = dateformat(dateadd('d',control_valid_day,now()),'dd/mm/yyyy')>
                            </cfoutput>
                        </cfif>
                    <cfelse>
                    	<cfset order_total_money_credit = order_total_money_credit + order_total_price*control_money_credit/100>
						<cfset order_money_credit_count = order_money_credit_count + 1>
                        <cfoutput>
                            <cfset "credit_rate_#order_money_credit_count#" = control_money_credit>
                            <cfset "order_total_money_credit_#order_money_credit_count#" = order_total_price*control_money_credit/100>
                            <cfset "credit_valid_date_#order_money_credit_count#" = dateformat(dateadd('d',control_valid_day,now()),'dd/mm/yyyy')>
                        </cfoutput>
                    </cfif>
				<cfelseif control_detail_prom_type eq 3>
					<cfset credit_card_bank_payment_list = listappend(credit_card_bank_payment_list,control_credit_types)>
				<cfelseif control_detail_prom_type eq 4>
					<cfquery name="GET_PROM_PRODUCTS" datasource="#DSN3#">
						SELECT 
							PROM_P.PROM_PRODUCT_ID,
							PROM_P.PROMOTION_ID,
							PROM_P.PRODUCT_ID,
							PROM_P.STOCK_ID,
							PROM_P.PRODUCT_AMOUNT,
							PROM_P.PRODUCT_PRICE,
							PROM_P.PRODUCT_COST,
							PROM_P.PRODUCT_PRICE_OTHER_LIST,
							PROM_P.MARGIN,
							PROM_P.IS_NONDELETE_PRODUCT,
							S.IS_ZERO_STOCK,
							S.IS_INVENTORY,
							S.PROPERTY,
							S.PRODUCT_NAME,
							S.TAX,
							S.PRODUCT_UNIT_ID
						FROM 
							PROMOTION_PRODUCTS PROM_P,
							STOCKS S
						WHERE
							PROM_P.STOCK_ID = S.STOCK_ID AND
							PROM_P.PROMOTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_prom_id#">
							<cfif get_prom_info.list_work_type eq 0 and len(get_prom_info.prom_action_type) and listfind('2,3',get_prom_info.prom_action_type)>
								AND PROM_P.STOCK_ID IN (#control_pre_order_stock_for_prom_type#)
							</cfif>
					</cfquery>
					<cfset cargo_product_id = get_prom_products.product_id>
					<cfset cargo_product_price = get_prom_products.product_price>
					<cfset cargo_product_tax = get_prom_products.tax>
				<cfelse>
					<cfif get_prom_info.is_cons_ref_prom eq 1 and isdefined('prom_member_bakiye') and len(prom_member_bakiye)>
						<cfset prom_prod_multiplier=prom_member_bakiye>
					<cfelseif control_prom_count_value eq 1>
						<cfset prom_prod_multiplier=1>
					<cfelseif get_prom_info.prom_type eq 0 and len(get_prom_info.prom_work_count) and prom_prod_multiplier gt get_prom_info.prom_work_count>
					<!--- siparis bazlı promosyon ise ve kazanılan katsayı promosyon calısma sayısından fazla ise  katsayı değiştiriliyor --->
						<cfset prom_prod_multiplier=get_prom_info.prom_work_count>
					<cfelseif get_prom_info.prom_type eq 2 and len(used_prom_work_count) and len(get_prom_info.prom_work_count)>
						<cfset prom_prod_multiplier=prom_prod_multiplier-used_prom_work_count>
						<cfif prom_prod_multiplier gt get_prom_info.prom_work_count>
							<cfset prom_prod_multiplier = get_prom_info.prom_work_count>
						</cfif>
					</cfif>
					<cfif prom_prod_multiplier gt 0>
						<cfset used_prom_id_list=listappend(used_prom_id_list,control_prom_id)>
						<cfif len(only_same_product) and only_same_product eq 1 and isdefined('add_prom_stock_list') and len(is_prom_stock_list)><!--- sadece aynı urunu ekle secilmisse, kosullardaki urunler kazanc olarak eklenir --->
							<cfquery name="GET_PROM_PRODUCTS" datasource="#DSN3#">
								SELECT 
									S.TAX,
									S.IS_ZERO_STOCK,
									S.IS_INVENTORY,
									S.PROPERTY,
									S.PRODUCT_NAME,
									S.PRODUCT_UNIT_ID,
									S.STOCK_ID,
									S.PRODUCT_ID
								FROM 
									STOCKS S
								WHERE
									S.STOCK_ID IN (#is_prom_stock_list#)
								ORDER BY 
									S.STOCK_ID
							</cfquery>
							<cfset control_stock_list=valuelist(get_prom_products.stock_id)>
							<cfloop list="#add_prom_stock_list#" index="add_stock_id" delimiters=";">
								<cfset add_prom_stock_amount=(listlast(add_stock_id,'-')*prom_prod_multiplier)>
								<!--- <cfif (get_prom_products.SALEABLE_STOCK[listfind(control_stock_list,listfirst(add_stock_id,'-'))] gte add_prom_stock_amount) or get_prom_products.IS_ZERO_STOCK[listfind(control_stock_list,listfirst(add_stock_id,'-'))] eq 1 or get_prom_products.IS_INVENTORY[listfind(control_stock_list,listfirst(add_stock_id,'-'))] eq 0>promosyon kazanılan urunun satılabilir stogu yeterliyse veya sıfır stokla calısabiliyorsa veya envantere dahil degilse  urun baskete eklenir --->
									<cfscript>
										add_pre_order_rows(
											stock_id:get_prom_products.stock_id[listfind(control_stock_list,listfirst(add_stock_id,'-'))],
											stock_amount:wrk_round(add_prom_stock_amount),
											product_unit_id:get_prom_products.product_unit_id[listfind(control_stock_list,listfirst(add_stock_id,'-'))],
											is_promotion:1,
											company_id:iif(len(attributes.company_id),de('#attributes.company_id#'),de('')),
											consumer_id:iif(len(attributes.consumer_id),de('#attributes.consumer_id#'),de('')),
											partner_id:iif(len(attributes.partner_id),de('#attributes.partner_id#'),de('')),
											price_catid:-2,
											prom_work_type:0,
											is_nondelete_product:0,
											is_product_promotion_noneffect:iif(len(get_prom_info.product_promotion_noneffect),de('#get_prom_info.product_promotion_noneffect#'),de('0')),
											is_general_prom:0,
											prom_product_price:0,
											prom_cost:0,
											prom_id:control_prom_id,
											price:0,
											price_kdv:0,
											price_money:session_base.money,
											product_tax:0,
											prom_stock_amount:1,
											prod_prom_action_type:0,
											IS_PROM_ASIL_HEDIYE:1,
											PROM_FREE_STOCK_ID:0,
											PRICE_STANDARD:0,
											PRICE_STANDARD_KDV:0,
											PRICE_STANDARD_MONEY:session_base.money,
											TO_CONS:iif(len(attributes.consumer_id),de('#attributes.consumer_id#'),de('')),
											TO_COMP:iif(len(attributes.company_id),de('#attributes.company_id#'),de('')),
											TO_PAR:iif(len(attributes.partner_id),de('#attributes.partner_id#'),de(''))
										);
									</cfscript>
								<!--- </cfif> --->
							</cfloop>
						<cfelse>
							<cfquery name="GET_PROM_PRODUCTS" datasource="#DSN3#">
								SELECT 
									PROM_P.PROM_PRODUCT_ID,
									PROM_P.PROMOTION_ID,
									PROM_P.PRODUCT_ID,
									PROM_P.STOCK_ID,
									PROM_P.PRODUCT_AMOUNT,
									PROM_P.PRODUCT_PRICE,
									PROM_P.PRODUCT_COST,
									PROM_P.PRODUCT_PRICE_OTHER_LIST,
									PROM_P.MARGIN,
									PROM_P.IS_NONDELETE_PRODUCT,
									S.IS_ZERO_STOCK ,S.IS_INVENTORY,
									S.PROPERTY,S.PRODUCT_NAME,S.TAX,S.PRODUCT_UNIT_ID
								FROM 
									PROMOTION_PRODUCTS PROM_P,
									STOCKS S
								WHERE
									PROM_P.STOCK_ID = S.STOCK_ID AND
									PROM_P.PROMOTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_prom_id#">
									<cfif get_prom_info.list_work_type eq 0 and len(get_prom_info.prom_action_type) and listfind('2,3',get_prom_info.prom_action_type)>
									AND PROM_P.STOCK_ID IN (#control_pre_order_stock_for_prom_type#)
									</cfif>
							</cfquery>
							<cfif get_prom_products.recordcount>
								<cfoutput query="get_prom_products">
								<cfset add_prom_stock_amount= product_amount*prom_prod_multiplier>
								<!---<cfif (SALEABLE_STOCK gte add_prom_stock_amount) or IS_ZERO_STOCK eq 1 or IS_INVENTORY eq 0> promosyon kazanılan urunun satılabilir stogu yeterliyse veya sıfır stokla calısabiliyorsa veya envantere dahil degilse  urun baskete eklenir --->
									<cfif get_prom_info.prom_action_type eq 1> <!--- hareket tipi ekle ise --->
										<cfscript>
											add_pre_order_rows(
												stock_id:get_prom_products.stock_id,
												stock_amount:wrk_round(add_prom_stock_amount),
												product_unit_id:get_prom_products.product_unit_id,
												is_promotion:1,
												company_id:iif(len(attributes.company_id),de('#attributes.company_id#'),de('')),
												consumer_id:iif(len(attributes.consumer_id),de('#attributes.consumer_id#'),de('')),
												partner_id:iif(len(attributes.partner_id),de('#attributes.partner_id#'),de('')),
												price_catid:-2,
												prom_work_type:0,
												prod_prom_action_type:0,
												is_nondelete_product:iif(len(get_prom_products.is_nondelete_product),de('#get_prom_products.is_nondelete_product#'),de('')),
												is_product_promotion_noneffect:iif(len(get_prom_info.product_promotion_noneffect),de('#get_prom_info.product_promotion_noneffect#'),de('0')),
												is_general_prom:iif(len(is_prom_stock_list),de('0'),de('1')),
												prom_product_price:iif(len(get_prom_products.product_price),de('#get_prom_products.product_price#'),de('')),
												prom_cost: iif(len(get_prom_products.product_cost),de('#get_prom_products.product_cost#'),de('0')),
												prom_id:control_prom_id,
												price:iif(len(get_prom_products.product_price),de('#get_prom_products.product_price#'),de('0')),
												price_kdv:iif(len(get_prom_products.product_price),de('#get_prom_products.product_price#'),de('0')),
												price_money:session_base.money,
												product_tax:0,
												prom_stock_amount:1,
												IS_PROM_ASIL_HEDIYE:1,
												PROM_FREE_STOCK_ID:0,
												PRICE_STANDARD:iif(len(get_prom_products.product_price),de('#get_prom_products.product_price#'),de('0')),
												PRICE_STANDARD_KDV:iif(len(get_prom_products.product_price),de('#get_prom_products.product_price#'),de('0')),
												PRICE_STANDARD_MONEY:session_base.money,
												TO_CONS:iif(len(attributes.consumer_id),de('#attributes.consumer_id#'),de('')),
												TO_COMP:iif(len(attributes.company_id),de('#attributes.company_id#'),de('')),
												TO_PAR:iif(len(attributes.partner_id),de('#attributes.partner_id#'),de(''))
											);
										</cfscript>
									<cfelseif listfind('2,3',get_prom_info.prom_action_type)><!--- hareket tipi: değiştir - ekle veya degiştir  --->
										<cfquery name="CONTROL_SAME_PROD_" datasource="#DSN3#">
											SELECT 
												ORDER_ROW_ID,STOCK_ID,QUANTITY,PRE_STOCK_AMOUNT,PRICE,PRICE_KDV,PROM_ID,QUANTITY_OLD,PRICE_MONEY
											FROM
												ORDER_PRE_ROWS
											WHERE
												<!--- 
												Alternatif olarak verilen ürünün fiyatını değiştirirken sorun oluyordu o yüzden kapattık 20090323
												STOCK_ID=#get_prom_products.stock_id#
												AND ISNULL(PRE_STOCK_ID,STOCK_ID)=#get_prom_products.stock_id#
												AND PRODUCT_ID=#get_prom_products.PRODUCT_ID#
												AND PRODUCT_UNIT_ID=#get_prom_products.PRODUCT_UNIT_ID# --->
												<!--- AND ISNULL(IS_PROM_ASIL_HEDIYE,0)=0 --->
												ISNULL(PRE_STOCK_ID,STOCK_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_prom_products.stock_id#"> AND
												ISNULL(PRE_PRODUCT_ID,PRODUCT_ID) = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_prom_products.product_id#"> AND
												ISNULL(IS_COMMISSION,0) = 0
												<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
													AND ISNULL(TO_CONS,RECORD_CONS) = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
												<cfelse>
													AND TO_CONS IS NULL
												</cfif>
												<!---<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
													AND TO_COMP=#attributes.company_id#
												<cfelse>
													AND TO_COMP IS NULL
												</cfif>
												 <cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>
													AND TO_PAR=#attributes.partner_id#
												<cfelse>
													AND TO_PAR IS NULL
												</cfif> --->
													AND RECORD_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.period_id#">
												<cfif isdefined("session.pp")>AND RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"><cfelse>AND RECORD_PAR IS NULL</cfif>
												<cfif isdefined("session.ww.userid")>AND RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"><cfelse> AND RECORD_CONS IS NULL</cfif>
												<cfif isdefined("session.ep.userid")>AND RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"><cfelse> AND RECORD_EMP IS NULL</cfif>
												<!--- <cfif listfind("199,198",control_prom_id)>
													AND (PROM_ID IS NULL OR (PROM_ID IS NOT NULL AND PROM_ID NOT IN (183)))
												</cfif> --->
											ORDER BY 
												QUANTITY DESC
										</cfquery>
										<cfif control_same_prod_.recordcount><!--- urun varsa guncelliyor --->
											<cfif control_same_prod_.quantity lte add_prom_stock_amount>
												<cfif len(get_prom_products.product_price) and get_prom_products.product_price neq 0>
													<cfset temp_price_=wrk_round(((get_prom_products.product_price/(100+get_prom_products.tax))*100),4)>
												<cfelse>
													<cfset temp_price_=0>
												</cfif>
												<cfquery name="ADD_MAIN_PRODUCTS_" datasource="#DSN3#">
													UPDATE
														ORDER_PRE_ROWS
													SET
														<cfif not len(control_same_prod_.prom_id)>
															PROD_PROM_ACTION_TYPE = 1,<!--- promosyonlar silindiginde bu satır standart urun satırı oldugundan  geri alınacaktır, promosyon satır urunuyle update edilmiş --->
															PRICE_OLD_2 = #control_same_prod_.price#,
															PRICE_KDV_OLD = #control_same_prod_.price_kdv#,
															PRICE_OLD_MONEY_2 = '#control_same_prod_.price_money#',
															<cfif not len(control_same_prod_.quantity_old) or not listfind("199,198",control_prom_id) or (listfind("199,198",control_prom_id) and control_same_prod_.quantity_old lte 0)>
															QUANTITY_OLD = #control_same_prod_.quantity#,
															</cfif>
														</cfif>
														PROM_WORK_TYPE = 0,
														IS_NONDELETE_PRODUCT = <cfif len(get_prom_products.is_nondelete_product)>#get_prom_products.is_nondelete_product#<cfelse>NULL</cfif>,
														QUANTITY = #control_same_prod_.quantity#,
														PRE_STOCK_AMOUNT = #control_same_prod_.quantity#,
														PRICE = #temp_price_#,
														PRICE_KDV = <cfif len(get_prom_products.product_price)>#get_prom_products.product_price#<cfelse>0</cfif>,
														PRICE_MONEY = <cfif isdefined('session.pp')>'#session.pp.money#'<cfelseif isdefined('session.ww.money')>'#session.ww.money#'<cfelse>'#session.ep.money#'</cfif>,
														STOCK_ACTION_ID = 0,
														PROM_STOCK_AMOUNT = 1,
														IS_PROM_ASIL_HEDIYE = 1,
														IS_PRODUCT_PROMOTION_NONEFFECT = <cfif len(get_prom_info.product_promotion_noneffect)>#get_prom_info.product_promotion_noneffect#<cfelse>0</cfif>,
														PROM_ID = #control_prom_id#,
														PROM_COST = <cfif len(get_prom_products.product_cost)>#get_prom_products.product_cost#<cfelse>0</cfif>,
														PROM_PRODUCT_PRICE = <cfif len(get_prom_products.product_price)>#get_prom_products.product_price#<cfelse>NULL</cfif>,
														IS_GENERAL_PROM = <cfif not len(is_prom_stock_list)>1<cfelse>0</cfif>, <!--- promosyon genel tutar veya genel toplama uygulanmıssa --->
														PRICE_STANDARD = #get_prom_products.product_price#,
														PRICE_STANDARD_KDV = #get_prom_products.product_price#,
														PRICE_STANDARD_MONEY = <cfif isdefined('session.pp')>'#session.pp.money#'<cfelseif isdefined('session.ww.money')>'#session.ww.money#'<cfelse>'#session.ep.money#'</cfif>
													WHERE
														ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_same_prod_.order_row_id#"> AND
														STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_same_prod_.stock_id#">
												</cfquery>
												<cfif (add_prom_stock_amount-control_same_prod_.quantity) gt 0 and get_prom_info.prom_action_type eq 3 and get_prom_info.list_work_type neq 0> <!--- promosyon miktarı fazlaysa ekle-degiştir tipinde fazla olan kısım yeni satır olarak eklenir , veyalı promosyon degilse--->
													<cfscript>
														add_pre_order_rows(
															stock_id:get_prom_products.stock_id,
															stock_amount:wrk_round((add_prom_stock_amount-control_same_prod_.quantity)),
															product_unit_id:get_prom_products.product_unit_id,
															is_promotion:1,
															company_id:iif(len(attributes.company_id),de('#attributes.company_id#'),de('')),
															consumer_id:iif(len(attributes.consumer_id),de('#attributes.consumer_id#'),de('')),
															partner_id:iif(len(attributes.partner_id),de('#attributes.partner_id#'),de('')),
															price_catid:-2,
															prom_work_type:0,
															is_nondelete_product:iif(len(get_prom_products.is_nondelete_product),de('#get_prom_products.is_nondelete_product#'),de('')),
															is_product_promotion_noneffect:iif(len(get_prom_info.product_promotion_noneffect),de('#get_prom_info.product_promotion_noneffect#'),de('0')),
															is_general_prom:iif(len(is_prom_stock_list),de('0'),de('1')),
															prom_product_price:iif(len(get_prom_products.product_price),de('#get_prom_products.product_price#'),de('')),
															prom_cost: iif(len(get_prom_products.product_cost),de('#get_prom_products.product_cost#'),de('0')),
															prom_id:control_prom_id,
															price:iif(len(get_prom_products.product_price),de('#get_prom_products.product_price#'),de('0')),
															price_kdv:iif(len(get_prom_products.product_price),de('#get_prom_products.product_price#'),de('0')),
															price_money:session_base.money,
															product_tax:0,
															prom_stock_amount:1,
															IS_PROM_ASIL_HEDIYE:1,
															PROM_FREE_STOCK_ID:0,
															PRICE_STANDARD:iif(len(get_prom_products.product_price),de('#get_prom_products.product_price#'),de('0')),
															PRICE_STANDARD_KDV:iif(len(get_prom_products.product_price),de('#get_prom_products.product_price#'),de('0')),
															PRICE_STANDARD_MONEY:session_base.money,
															TO_CONS:iif(len(attributes.consumer_id),de('#attributes.consumer_id#'),de('')),
															TO_COMP:iif(len(attributes.company_id),de('#attributes.company_id#'),de('')),
															TO_PAR:iif(len(attributes.partner_id),de('#attributes.partner_id#'),de(''))
														);
													</cfscript>
												</cfif>
											<cfelseif control_same_prod_.quantity gt add_prom_stock_amount>
												<cfquery name="ADD_MAIN_PRODUCT_" datasource="#DSN3#"><!--- satır miktarından promosyon olarak ayrılan bolum cıkarılıyor--->
													UPDATE
														ORDER_PRE_ROWS
													SET
														QUANTITY = #control_same_prod_.quantity-add_prom_stock_amount#,
														PRE_STOCK_AMOUNT = #control_same_prod_.quantity#,
													<cfif not len(control_same_prod_.prom_id)>
														<cfif not len(control_same_prod_.quantity_old) or not listfind('199,198',control_prom_id) or (listfind('199,198',control_prom_id) and control_same_prod_.quantity_old lte 0)>
														QUANTITY_OLD = #control_same_prod_.quantity#, <!--- promosyonlar silindiginde bu miktarlar geri alınacak --->
														</cfif>
													</cfif>
														PROD_PROM_ACTION_TYPE = 1
													WHERE
														ORDER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_same_prod_.order_row_id#"> AND
														STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#control_same_prod_.stock_id#">
												</cfquery>
												<cfscript>
													add_pre_order_rows(
														stock_id:get_prom_products.stock_id,
														stock_amount:add_prom_stock_amount,
														product_unit_id:get_prom_products.product_unit_id,
														prod_prom_action_type:0, //standart urun satırı ekle-degistir promosyondan gelen kazanc urunu olarak ekleniyor
														is_promotion:1,
														company_id:iif(len(attributes.company_id),de('#attributes.company_id#'),de('')),
														consumer_id:iif(len(attributes.consumer_id),de('#attributes.consumer_id#'),de('')),
														partner_id:iif(len(attributes.partner_id),de('#attributes.partner_id#'),de('')),
														price_catid:-2,
														prom_work_type:0,
														is_nondelete_product:iif(len(get_prom_products.is_nondelete_product),de('#get_prom_products.is_nondelete_product#'),de('')),
														is_product_promotion_noneffect:iif(len(get_prom_info.product_promotion_noneffect),de('#get_prom_info.product_promotion_noneffect#'),de('0')),
														is_general_prom:iif(len(is_prom_stock_list),de('0'),de('1')),
														prom_product_price:iif(len(get_prom_products.product_price),de('#get_prom_products.product_price#'),de('')),
														prom_cost: iif(len(get_prom_products.product_cost),de('#get_prom_products.product_cost#'),de('0')),
														prom_id:control_prom_id,
														price:iif(len(get_prom_products.product_price),de('#get_prom_products.product_price#'),de('0')),
														price_kdv:iif(len(get_prom_products.product_price),de('#get_prom_products.product_price#'),de('0')),
														price_money:session_base.money,
														product_tax:0,
														prom_stock_amount:1,
														IS_PROM_ASIL_HEDIYE:1,
														PROM_FREE_STOCK_ID:0,
														PRICE_STANDARD:iif(len(get_prom_products.product_price),de('#get_prom_products.product_price#'),de('0')),
														PRICE_STANDARD_KDV:iif(len(get_prom_products.product_price),de('#get_prom_products.product_price#'),de('0')),
														PRICE_STANDARD_MONEY:session_base.money,
														TO_CONS:iif(len(attributes.consumer_id),de('#attributes.consumer_id#'),de('')),
														TO_COMP:iif(len(attributes.company_id),de('#attributes.company_id#'),de('')),
														TO_PAR:iif(len(attributes.partner_id),de('#attributes.partner_id#'),de(''))
													);
												</cfscript>
											</cfif>
										<cfelseif get_prom_info.prom_action_type eq 3 and get_prom_info.LIST_WORK_TYPE neq 0><!--- veyalı promosyon degilse hareket tipi "ekle veya değiştir" ise ve ürün bulunamazsa promosyonu ekliyor --->
											<cfscript>
												add_pre_order_rows(
													stock_id:get_prom_products.stock_id,
													stock_amount:add_prom_stock_amount,
													product_unit_id:get_prom_products.product_unit_id,
													is_promotion:1,
													company_id:iif(len(attributes.company_id),de('#attributes.company_id#'),de('')),
													consumer_id:iif(len(attributes.consumer_id),de('#attributes.consumer_id#'),de('')),
													partner_id:iif(len(attributes.partner_id),de('#attributes.partner_id#'),de('')),
													price_catid:-2,
													prom_work_type:0,
													is_nondelete_product:iif(len(get_prom_products.is_nondelete_product),de('#get_prom_products.is_nondelete_product#'),de('')),
													is_product_promotion_noneffect:iif(len(get_prom_info.product_promotion_noneffect),de('#get_prom_info.product_promotion_noneffect#'),de('0')),
													is_general_prom:iif(len(is_prom_stock_list),de('0'),de('1')),
													prom_product_price:iif(len(get_prom_products.product_price),de('#get_prom_products.product_price#'),de('')),
													prom_cost: iif(len(get_prom_products.product_cost),de('#get_prom_products.product_cost#'),de('0')),
													prom_id:control_prom_id,
													price:iif(len(get_prom_products.product_price),de('#get_prom_products.product_price#'),de('0')),
													price_kdv:iif(len(get_prom_products.product_price),de('#get_prom_products.product_price#'),de('0')),
													price_money:session_base.money,
													product_tax:0,
													prom_stock_amount:1,
													IS_PROM_ASIL_HEDIYE:1,
													PROM_FREE_STOCK_ID:0,
													PRICE_STANDARD:iif(len(get_prom_products.product_price),de('#get_prom_products.product_price#'),de('0')),
													PRICE_STANDARD_KDV:iif(len(get_prom_products.product_price),de('#get_prom_products.product_price#'),de('0')),
													PRICE_STANDARD_MONEY:session_base.money,
													TO_CONS:iif(len(attributes.consumer_id),de('#attributes.consumer_id#'),de('')),
													TO_COMP:iif(len(attributes.company_id),de('#attributes.company_id#'),de('')),
													TO_PAR:iif(len(attributes.partner_id),de('#attributes.partner_id#'),de(''))
												);
											</cfscript>
										</cfif>
									</cfif>
								<!--- </cfif> --->
								</cfoutput>
							</cfif>
						</cfif>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>
	</cfif>
</cfif>

