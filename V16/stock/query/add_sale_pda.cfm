<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
<cfif isdefined('ship_number')>
	<cfset list1=",">
	<cfset list2="">
	<cfset ship_number = Replace(ship_number,list1,list2,"ALL")> 
</cfif>
<cfif attributes.rows_ eq 0>
	<script type="text/javascript">
		alert("<cf_get_lang no='4.Ürün Seçmediniz !'>");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
	</script>
	<cfabort>	
</cfif>
<cfif not len(attributes.company_id) and not len(attributes.consumer_id)>
	<script type="text/javascript">
		alert("<cf_get_lang no='131.Üye Seçmediniz !'>");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
	</script>
	<cfabort>	
</cfif>
<cfquery name="GET_PURCHASE" datasource="#DSN2#">
	SELECT 
		SHIP_NUMBER,
		PURCHASE_SALES
	FROM 
		SHIP
	WHERE 
		PURCHASE_SALES = 1 AND
		SHIP_NUMBER = '#SHIP_NUMBER#'
</cfquery>
<cfif get_purchase.recordcount >
	<script type="text/javascript">
		alert("<cf_get_lang no='16.Bu Numara ile Kayıtlı İrsaliye Bulunmakta !'>");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
	</script>
	<cfabort>	
</cfif>
<cfinclude template="get_process_cat.cfm">
<cfif not len(attributes.location_id)>
	<cfset attributes.location_id = "NULL">
</cfif>
<cf_date tarih = 'attributes.deliver_date_frm'>
<cf_date tarih = 'attributes.ship_date'>
<cfif isdefined("attributes.basket_due_value") and len(attributes.basket_due_value)>
	<cfset ship_due_date = date_add("d",attributes.basket_due_value,attributes.ship_date)>
<cfelse>
	<cfset ship_due_date = "">
</cfif>
<cfif isDefined("session.ep")><cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)></cfif><!--- pda den gelen işlemler için --->
<cfif isDefined("session.pda")><cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.pda.userid#_'&round(rand()*100)></cfif><!--- pda den gelen işlemler için --->
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_SALE" datasource="#DSN2#" result="MAX_ID">
			INSERT INTO
				SHIP
			(
				WRK_ID,
				PURCHASE_SALES,
				SHIP_NUMBER,
				SHIP_TYPE,
				PROCESS_CAT,
				SHIP_METHOD,
				SHIP_DATE,
				SHIP_DETAIL,
			<cfif len(attributes.company_id)>
				COMPANY_ID,
				PARTNER_ID,
			<cfelse>
				CONSUMER_ID,
			</cfif>
				<cfif isDefined("session.ep") and session.ep.our_company_info.project_followup eq 1>
					PROJECT_ID,
				</cfif>
			<cfif isdate(attributes.deliver_date_frm)>DELIVER_DATE,</cfif>
				DELIVER_EMP,
				DISCOUNTTOTAL,
				NETTOTAL,
				GROSSTOTAL,
				TAXTOTAL,
				OTV_TOTAL,
				OTHER_MONEY,
				OTHER_MONEY_VALUE,
				DELIVER_STORE_ID,
				LOCATION,
				RECORD_DATE,
				RECORD_EMP,
				IS_WITH_SHIP,
				COMMETHOD_ID,
				REF_NO,
				DUE_DATE,
				PAYMETHOD_ID,
				GENERAL_PROM_ID,
				GENERAL_PROM_LIMIT,
				GENERAL_PROM_AMOUNT,
				GENERAL_PROM_DISCOUNT,
				FREE_PROM_ID,
				FREE_PROM_LIMIT,
				FREE_PROM_AMOUNT,
				FREE_PROM_STOCK_ID,
				FREE_STOCK_PRICE,
				FREE_STOCK_MONEY,
				CARD_PAYMETHOD_ID,
				CARD_PAYMETHOD_RATE,
				SA_DISCOUNT,
				<cfif isdefined('attributes.sale_emp') and len(attributes.sale_emp) and isdefined('attributes.sale_emp_name') and len(attributes.sale_emp_name)>SALE_EMP,</cfif>
				CITY_ID,
                COUNTY_ID,
                SHIP_ADDRESS_ID,
                ADDRESS
			)
			VALUES
			(
				'#wrk_id#',
				1,
				'#SHIP_NUMBER#',
				#get_process_type.process_type#,
				#attributes.process_cat#,					
				<cfif isDefined('attributes.SHIP_METHOD') and len(attributes.SHIP_METHOD)>
					#SHIP_METHOD#,
				<cfelse>
					NULL,
				</cfif>
				#attributes.ship_date#,
				<cfif isdefined('attributes.detail') and len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
				<cfif len(attributes.company_id)>
					#attributes.company_id#,
					<cfif len(attributes.partner_id)>#attributes.partner_id#,<cfelse>NULL,</cfif>
				<cfelse>
					#attributes.consumer_id#,
				</cfif>
				<cfif isDefined("session.ep") and session.ep.our_company_info.project_followup eq 1>
					<cfif len(attributes.project_id) and len(attributes.project_head)>#attributes.project_id#,<cfelse>NULL,</cfif>
				</cfif>
				<cfif isdate(attributes.deliver_date_frm)>
					#attributes.deliver_date_frm#,
				</cfif>
				<cfif isdefined("attributes.DELIVER_GET") and len(attributes.DELIVER_GET)>'#LEFT(TRIM(attributes.DELIVER_GET),50)#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.BASKET_DISCOUNT_TOTAL")>#attributes.BASKET_DISCOUNT_TOTAL#,<cfelse>0,</cfif>
				<cfif isdefined("attributes.basket_net_total")>#attributes.basket_net_total#,<cfelse>0,</cfif>
				<cfif isdefined("attributes.basket_gross_total")>#attributes.basket_gross_total#,<cfelse>0,</cfif>
				<cfif isdefined("attributes.basket_tax_total")>#attributes.basket_tax_total#,<cfelse>0,</cfif>
				<cfif isdefined("attributes.basket_otv_total") and len(attributes.basket_otv_total)>#attributes.basket_otv_total#<cfelse>NULL</cfif>,
				'#attributes.basket_money#',
				#((attributes.BASKET_NET_TOTAL*attributes.BASKET_RATE1)/attributes.BASKET_RATE2)#,
				#attributes.department_id#,
				#attributes.location_id#,
				#now()#,
				#session.pda.userid#,
				0,
				<cfif isdefined("attributes.commethod_id") and len(attributes.commethod_id)>#attributes.commethod_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.ref_no") and len(attributes.ref_no)>'#attributes.ref_no#'<cfelse>NULL</cfif>,
				<cfif isdefined("ship_due_date") and len(ship_due_date)>#ship_due_date#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.paymethod_id") and len(attributes.paymethod_id)>#attributes.paymethod_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.general_prom_id") and len(attributes.general_prom_id)>#attributes.general_prom_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.general_prom_limit") and len(attributes.general_prom_limit)>#attributes.general_prom_limit#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.general_prom_amount") and len(attributes.general_prom_amount)>#attributes.general_prom_amount#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.general_prom_discount") and len(attributes.general_prom_discount)>#attributes.general_prom_discount#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.free_prom_id") and len(attributes.free_prom_id)>#attributes.free_prom_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.free_prom_limit") and len(attributes.free_prom_limit)>#attributes.free_prom_limit#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.free_prom_amount") and len(attributes.free_prom_amount)>#attributes.free_prom_amount#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.free_prom_stock_id") and len(attributes.free_prom_stock_id)>#attributes.free_prom_stock_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.free_stock_price") and len(attributes.free_stock_price)>#attributes.free_stock_price#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.free_stock_money") and len(attributes.free_stock_money)>'#attributes.free_stock_money#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
					#attributes.card_paymethod_id#,
					<cfif isdefined("attributes.commission_rate") and len(attributes.commission_rate)>
						#attributes.commission_rate#,
					<cfelse>
						NULL,
					</cfif>
				<cfelse>
					NULL,
					NULL,
				</cfif>
				<cfif isdefined('attributes.genel_indirim') and len(attributes.genel_indirim)>#attributes.genel_indirim#<cfelse>0</cfif>
				<cfif isdefined('attributes.sale_emp') and len(attributes.sale_emp) and isdefined('attributes.sale_emp_name') and len(attributes.sale_emp_name)>,#attributes.sale_emp#</cfif>,
				<cfif isdefined("attributes.ship_address_city_id") and len(attributes.ship_address_city_id)>#attributes.ship_address_city_id#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.ship_address_county_id") and len(attributes.ship_address_county_id)>#attributes.ship_address_county_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.ship_address_id") and len(attributes.ship_address_id)>#attributes.ship_address_id#<cfelse>NULL</cfif>,
                <cfif isdefined("attributes.ship_address") and len(attributes.ship_address)>'#attributes.ship_address#'<cfelse>NULL</cfif>
			)
		</cfquery>
		<cfloop from="1" to="#attributes.rows_#" index="i">
		<cfif evaluate('attributes.row_kontrol#i#')>
			<cfif isDefined("session.ep")>
				<cfif session.ep.our_company_info.spect_type and isdefined('attributes.is_production#i#') and evaluate('attributes.is_production#i#') eq 1 and not isdefined('attributes.spect_id#i#') or not len(evaluate('attributes.spect_id#i#'))>
					<cfset dsn_type=dsn2>
					<cfinclude template="../../objects/query/add_basket_spec.cfm">
				</cfif>
			</cfif>
			<cf_date tarih = 'attributes.deliver_date#i#'> <!--- satırdaki teslim tarihi burada formatlanıyor, fakat stocks_row'a kayıt atılırken de aynı degerler kullanılıyor --->
			<cfinclude template="get_dis_amount.cfm">
			<cfquery name="ADD_SHIP_ROW" datasource="#DSN2#">
				INSERT INTO
					SHIP_ROW
				(
					NAME_PRODUCT,
					PAYMETHOD_ID,
					SHIP_ID,
					STOCK_ID,
					PRODUCT_ID,
					AMOUNT,
					UNIT,
					UNIT_ID,					
					TAX,
				<cfif isdefined("attributes.price#i#") and len(evaluate("attributes.price#i#"))>
					PRICE,
				</cfif>
					DISCOUNT,
					PURCHASE_SALES,
					DISCOUNT2,
					DISCOUNT3,
					DISCOUNT4,
					DISCOUNT5,
					DISCOUNT6,
					DISCOUNT7,
					DISCOUNT8,
					DISCOUNT9,
					DISCOUNT10,
					DISCOUNTTOTAL,
					GROSSTOTAL,
					NETTOTAL,
					TAXTOTAL,
					DELIVER_DATE,						
					DELIVER_DEPT,
					DELIVER_LOC,
				<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>					
					SPECT_VAR_ID,
					SPECT_VAR_NAME,
				</cfif>
					LOT_NO,
					OTHER_MONEY,
					OTHER_MONEY_VALUE,				
					PRICE_OTHER,
					OTHER_MONEY_GROSS_TOTAL,
					COST_PRICE,
					EXTRA_COST,
					DISCOUNT_COST,
					MARGIN,
					ROW_ORDER_ID,
				<cfif listfind('72,79',get_process_type.PROCESS_TYPE) and isdefined("attributes.irsaliye_id_listesi") and len(attributes.irsaliye_id_listesi)>
					RELATED_SHIP_ID,
					RELATED_SHIP_PERIOD,
				</cfif>
					PROM_COMISSION,
					PROM_COST,
					PROM_ID,
					IS_PROMOTION,
					PROM_STOCK_ID,
					IS_COMMISSION,
					DARA,
					DARALI,
					UNIQUE_RELATION_ID,
					PROM_RELATION_ID,
					PRODUCT_NAME2,
					AMOUNT2,
					UNIT2,
					EXTRA_PRICE,
					EK_TUTAR_PRICE,<!--- iscilik birim ücreti --->
					EXTRA_PRICE_TOTAL,
					EXTRA_PRICE_OTHER_TOTAL,
					SHELF_NUMBER,
					PRODUCT_MANUFACT_CODE,
					BASKET_EXTRA_INFO_ID,
					SELECT_INFO_EXTRA,
                	DETAIL_INFO_EXTRA,
					BASKET_EMPLOYEE_ID,
					LIST_PRICE,
					PRICE_CAT,
					CATALOG_ID,
					NUMBER_OF_INSTALLMENT,
					DUE_DATE,
					KARMA_PRODUCT_ID,
					OTV_ORAN,
					OTVTOTAL,
					SERVICE_ID,
                    WRK_ROW_ID,
                    WRK_ROW_RELATION_ID,
					WIDTH_VALUE,
					DEPTH_VALUE,
					HEIGHT_VALUE,
					ROW_PROJECT_ID
				)
				VALUES
				(
					'#left(evaluate("attributes.product_name#i#"),250)#',
					<cfif isdefined("attributes.paymethod_id#i#") and len(evaluate("attributes.paymethod_id#i#"))>#evaluate("attributes.paymethod_id#i#")#,<cfelse>NULL,</cfif>
					#MAX_ID.IDENTITYCOL#,
					#evaluate("attributes.stock_id#i#")#,
					#evaluate("attributes.product_id#i#")#,
					#evaluate("attributes.amount#i#")#,
					'#wrk_eval("attributes.unit#i#")#',
					#evaluate("attributes.unit_id#i#")#,
					#evaluate("attributes.tax#i#")#,
					<cfif isdefined("attributes.price#i#") and  len(evaluate("attributes.price#i#"))>
						#evaluate("attributes.price#i#")#,
					</cfif>
					#indirim1#,
					1,
					#indirim2#,
					#indirim3#,
					#indirim4#,
					#indirim5#,
					#indirim6#,
					#indirim7#,
					#indirim8#,
					#indirim9#,
					#indirim10#,
					#DISCOUNT_AMOUNT#,
					#evaluate("attributes.row_lasttotal#i#")#,
					#evaluate("attributes.row_nettotal#i#")#,
					#evaluate("attributes.row_taxtotal#i#")#,	
					<cfif isdefined("attributes.deliver_date#i#") and len(evaluate('attributes.deliver_date#i#'))>#evaluate('attributes.deliver_date#i#')#<cfelse>NULL</cfif>,				
					#attributes.department_id#,
					#attributes.location_id#,
					<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
						#evaluate('attributes.spect_id#i#')#,
						'#wrk_eval('attributes.spect_name#i#')#',
					</cfif>
					<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))>'#wrk_eval('attributes.lot_no#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.other_money_#i#')>'#wrk_eval('attributes.other_money_#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.other_money_value_#i#") and len(evaluate("attributes.other_money_value_#i#"))>#evaluate("attributes.other_money_value_#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.price_other#i#') and len(evaluate('attributes.price_other#i#'))>#evaluate("attributes.price_other#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.other_money_gross_total#i#") and len(evaluate("attributes.other_money_gross_total#i#"))>#evaluate("attributes.other_money_gross_total#i#")#,<cfelse>0,</cfif>
					<cfif isdefined('attributes.net_maliyet#i#') and len(evaluate('attributes.net_maliyet#i#'))>#evaluate('attributes.net_maliyet#i#')#<cfelse>0</cfif>,
					<cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
					<cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.marj#i#') and len(evaluate('attributes.marj#i#'))>#evaluate('attributes.marj#i#')#<cfelse>NULL</cfif>,
					#order_id#,
				<cfif listfind('72,79',get_process_type.PROCESS_TYPE) and isdefined("attributes.irsaliye_id_listesi") and len(attributes.irsaliye_id_listesi)>
					<cfif listlen(evaluate("attributes.row_ship_id#i#"),';') eq 2>#listfirst(evaluate("attributes.row_ship_id#i#"),';')#,<cfelse>NULL,</cfif>
					<cfif listlen(evaluate("attributes.row_ship_id#i#"),';') eq 2>#listlast(evaluate("attributes.row_ship_id#i#"),';')#,<cfelse>NULL,</cfif>
				</cfif>
					<cfif isdefined('attributes.promosyon_yuzde#i#') and len(evaluate('attributes.promosyon_yuzde#i#'))>#evaluate('attributes.promosyon_yuzde#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.promosyon_maliyet#i#') and len(evaluate('attributes.promosyon_maliyet#i#'))>#evaluate('attributes.promosyon_maliyet#i#')#<cfelse>0</cfif>,
					<cfif isdefined('attributes.row_promotion_id#i#') and len(evaluate('attributes.row_promotion_id#i#'))>#evaluate('attributes.row_promotion_id#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.is_promotion#i#') and len(evaluate('attributes.is_promotion#i#'))>#evaluate('attributes.is_promotion#i#')#<cfelse>0</cfif>,
					<cfif isdefined('attributes.prom_stock_id#i#') and len(evaluate('attributes.prom_stock_id#i#'))>#evaluate('attributes.prom_stock_id#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.is_commission#i#') and len(evaluate('attributes.is_commission#i#'))>#evaluate('attributes.is_commission#i#')#<cfelse>0</cfif>,
					<cfif isdefined('attributes.dara#i#') and len(evaluate('attributes.dara#i#'))>#evaluate('attributes.dara#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.darali#i#') and len(evaluate('attributes.darali#i#'))>#evaluate('attributes.darali#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))>'#wrk_eval('attributes.row_unique_relation_id#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.prom_relation_id#i#') and len(evaluate('attributes.prom_relation_id#i#'))>'#wrk_eval('attributes.prom_relation_id#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))>'#wrk_eval('attributes.product_name_other#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))>'#wrk_eval('attributes.unit_other#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.ek_tutar_price#i#') and len(evaluate('attributes.ek_tutar_price#i#'))>#evaluate('attributes.ek_tutar_price#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.ek_tutar_other_total#i#') and len(evaluate('attributes.ek_tutar_other_total#i#'))>#evaluate('attributes.ek_tutar_other_total#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))>'#wrk_eval('attributes.manufact_code#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.select_info_extra#i#') and len(evaluate('attributes.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.select_info_extra#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.detail_info_extra#i#') and len(evaluate('attributes.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.basket_employee_id#i#') and len(evaluate('attributes.basket_employee_id#i#')) and isdefined('attributes.basket_employee#i#') and len(evaluate('attributes.basket_employee#i#'))>#evaluate('attributes.basket_employee_id#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.list_price#i#') and len(evaluate('attributes.list_price#i#'))>#evaluate('attributes.list_price#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.price_cat#i#') and len(evaluate('attributes.price_cat#i#'))>#evaluate('attributes.price_cat#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_catalog_id#i#') and len(evaluate('attributes.row_catalog_id#i#'))>#evaluate('attributes.row_catalog_id#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.number_of_installment#i#') and len(evaluate('attributes.number_of_installment#i#'))>#evaluate('attributes.number_of_installment#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.duedate#i#") and len(evaluate("attributes.duedate#i#"))>#evaluate("attributes.duedate#i#")#<cfelse>0</cfif>,
					<cfif isdefined('attributes.karma_product_id#i#') and len(evaluate('attributes.karma_product_id#i#'))>#evaluate('attributes.karma_product_id#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))>'#wrk_eval('attributes.otv_oran#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_service_id#i#') and len(evaluate('attributes.row_service_id#i#'))>#evaluate("attributes.row_service_id#i#")#<cfelseif isdefined("attributes.service_id") and listlen(attributes.service_id) eq 1>#attributes.service_id#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))>'#wrk_eval('attributes.wrk_row_id#i#')#'<cfelse>NULL</cfif>,
                    <cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))>'#wrk_eval('attributes.wrk_row_relation_id#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>
				)
			</cfquery>
            <cfif isdefined('attributes.related_action_id#i#') and Evaluate('attributes.related_action_id#i#') gt 0 and isdefined('attributes.wrk_row_relation_id#i#') and Evaluate('attributes.wrk_row_relation_id#i#') gt 0>
				<cfscript>
                    add_relation_rows(
                        action_type:'add',
                        action_dsn : '#dsn2#',
                        to_table:'SHIP',
                        from_table:'#evaluate("attributes.RELATED_ACTION_TABLE#i#")#',
                        to_wrk_row_id : Evaluate("attributes.wrk_row_id#i#"),
                        from_wrk_row_id :Evaluate("attributes.wrk_row_relation_id#i#"),
                        amount : Evaluate("attributes.amount#i#"),
                        to_action_id : MAX_ID.IDENTITYCOL,
                        from_action_id :Evaluate("attributes.related_action_id#i#")
                        );
                </cfscript>
            </cfif>
		</cfif>
		</cfloop>
		<cfscript>
			if(get_process_type.IS_STOCK_ACTION eq 1)//Stok hareketi yapılsın
			{
				sr_product_id_list ="";
				sr_stock_id_list ="";
				sr_unit_list ="";
				sr_amount_list ="";
				sr_spec_id_list ="";
				sr_lot_no_list ="";
				sr_shelf_number_list ="";
				sr_manufact_code_list ="";
				sr_amount_other_list ="";
				sr_unit_other_list ="";
				sr_deliver_date_list ="";
				sr_row_width_list="";
				sr_row_height_list="";
				sr_row_depth_list="";
				if(isdefined('attributes.deliver_date_frm') and isdate(attributes.deliver_date_frm))
					sr_process_date_=attributes.deliver_date_frm;
				else
					sr_process_date_=attributes.ship_date;
				for(_ind_=1;_ind_ lte attributes.rows_;_ind_=_ind_+1)
				{
					if(evaluate('attributes.row_kontrol#_ind_#') and evaluate('attributes.is_inventory#_ind_#') eq 1) //urun envantere dahilse stock hareketi yapar
					{
						sr_product_id_list = ListAppend(sr_product_id_list,Evaluate('attributes.product_id#_ind_#'),',');
						sr_stock_id_list = ListAppend(sr_stock_id_list,Evaluate('attributes.stock_id#_ind_#'),',');
						sr_unit_list = ListAppend(sr_unit_list,Evaluate('attributes.unit#_ind_#'),',');
						sr_amount_list = ListAppend(sr_amount_list,Evaluate('attributes.amount#_ind_#'),',');
						if(isdefined('attributes.spect_id#_ind_#') and len(Evaluate('attributes.spect_id#_ind_#')) )
							sr_spec_id_list = ListAppend(sr_spec_id_list,Evaluate('attributes.spect_id#_ind_#'),',');
						else
							sr_spec_id_list = ListAppend(sr_spec_id_list,0,',');
						if(isdefined('attributes.lot_no#_ind_#') and len(Evaluate('attributes.lot_no#_ind_#')) )
							sr_lot_no_list = ListAppend(sr_lot_no_list,Evaluate('attributes.lot_no#_ind_#'),',');
						else
							sr_lot_no_list = ListAppend(sr_lot_no_list,0,',');
						
						if(isdefined('attributes.shelf_number#_ind_#') and len(Evaluate('attributes.shelf_number#_ind_#')) )
							sr_shelf_number_list = ListAppend(sr_shelf_number_list,Evaluate('attributes.shelf_number#_ind_#'),',');
						else
							sr_shelf_number_list = ListAppend(sr_shelf_number_list,0,',');
						
						if(isdefined('attributes.manufact_code#_ind_#') and len(Evaluate('attributes.manufact_code#_ind_#')) )
							sr_manufact_code_list = ListAppend(sr_manufact_code_list,Evaluate('attributes.manufact_code#_ind_#'),',');
						else
							sr_manufact_code_list = ListAppend(sr_manufact_code_list,0,',');
						
						if(isdefined('attributes.amount_other#_ind_#') and len(Evaluate('attributes.amount_other#_ind_#')) )
							sr_amount_other_list = ListAppend(sr_amount_other_list,Evaluate('attributes.amount_other#_ind_#'),',');
						else
							sr_amount_other_list = ListAppend(sr_amount_other_list,0,',');
						
						if(isdefined('attributes.unit_other#_ind_#') and len(Evaluate('attributes.unit_other#_ind_#')) )
							sr_unit_other_list = ListAppend(sr_unit_other_list,Evaluate('attributes.unit_other#_ind_#'),',');
						else
							sr_unit_other_list = ListAppend(sr_unit_other_list,0,',');
						if(isdefined('attributes.deliver_date#_ind_#') and isdate(Evaluate('attributes.deliver_date#_ind_#')) )
							sr_deliver_date_list = ListAppend(sr_deliver_date_list,Evaluate('attributes.deliver_date#_ind_#'),',');
						else
							sr_deliver_date_list = ListAppend(sr_deliver_date_list,0,',');
						if(isdefined('attributes.row_width#_ind_#') and len(evaluate('attributes.row_width#_ind_#')) )
							sr_row_width_list = ListAppend(sr_row_width_list,evaluate('attributes.row_width#_ind_#'),',');
						else
							sr_row_width_list = ListAppend(sr_row_width_list,0,',');
						
						if(isdefined('attributes.row_height#_ind_#') and len(evaluate('attributes.row_height#_ind_#')) )
							sr_row_height_list = ListAppend(sr_row_height_list,evaluate('attributes.row_height#_ind_#'),',');
						else
							sr_row_height_list = ListAppend(sr_row_height_list,0,',');
					
						if(isdefined('attributes.row_depth#_ind_#') and len(evaluate('attributes.row_depth#_ind_#')) )
							sr_row_depth_list = ListAppend(sr_row_depth_list,Evaluate('attributes.row_depth#_ind_#'),',');
						else
							sr_row_depth_list = ListAppend(sr_row_depth_list,0,',');
							
					}
				}
				if(len(sr_product_id_list) and len(sr_stock_id_list))
				{
					include('add_stock_rows.cfm','\objects\functions');//sayfalar farklı modüllerden çağrıldıgı için buraya include edildi
					add_stock_rows(
						sr_is_purchase_sales : 1,
						sr_stock_row_count : listlen(sr_stock_id_list,','), //attributes.rows_,
						sr_max_id :MAX_ID.IDENTITYCOL,

						sr_department_id : attributes.department_id,
						sr_location_id : attributes.location_id,
						sr_process_date :sr_process_date_,
						sr_document_date : attributes.ship_date,
						sr_process_type : get_process_type.PROCESS_TYPE,
						sr_product_id_list: sr_product_id_list,
						sr_control_process_type : '78,79', // iade process type lar satıs ve alısa gore degisiyor, dikkat plz.
						sr_stock_id_list: sr_stock_id_list,
						sr_unit_list: sr_unit_list,
						sr_amount_list: sr_amount_list,
						sr_spec_id_list: sr_spec_id_list,
						sr_lot_no_list: sr_lot_no_list,
						sr_shelf_number_list:sr_shelf_number_list,
						sr_manufact_code_list:sr_manufact_code_list,
						sr_amount_other_list : sr_amount_other_list,
						sr_unit_other_list : sr_unit_other_list,
						sr_deliver_date_list :sr_deliver_date_list,
						sr_width_list:sr_row_width_list,
						sr_depth_list:sr_row_depth_list,
						sr_height_list:sr_row_height_list
					);
				}
			}
			if(isdefined("attributes.irsaliye_id_listesi") and len(attributes.irsaliye_id_listesi)) //irsaliyeye cekilen konsinye irsaliye varsa
			{
				include('add_ship_row_relation.cfm','\objects\functions'); 
				add_ship_row_relation(
					to_related_process_id : MAX_ID.IDENTITYCOL,
					to_related_process_type : get_process_type.PROCESS_TYPE,
					ship_related_action_type:0,
					is_invoice_ship:1,
					process_db :dsn2
					);
			}
			if(isdefined("attributes.order_id_listesi") and len(attributes.order_id_listesi)) //irsaliyeye cekilen siparis varsa
			{
				
				//if(attributes.fuseaction is 'objects.emptypopupflush_xml_import_ship_query')
					//abort('test');
				include('add_order_row_reserved_stock_pda.cfm','\objects\functions'); //siparis irsaliye iliskisini, siparis satır aşama ve rezerve tipini update ediyor
				add_reserve_row(
					reserve_order_id:attributes.order_id_listesi,
					related_process_id : MAX_ID.IDENTITYCOL,
					reserve_action_type:0,
					is_order_process:1,
					is_purchase_sales:1,
					is_stock_row_action :get_process_type.IS_STOCK_ACTION,
					process_db :dsn2
					);
			}
			basket_kur_ekle(action_id:MAX_ID.IDENTITYCOL,table_type_id:2,process_type:0);	
		</cfscript>	
 	</cftransaction>
</cflock>
<cfif isdefined("attributes.is_popup") and isdefined('attributes.service_id') and listlen(attributes.service_id) eq 1> <!--- tekli servis icin servis modulunden cagrılmıssa --->
	<!--- seriye otomatik kayit atma olayi --->
	<cfquery name="GET_PRO_GUARANTY" datasource="#dsn3#" maxrows="1">
		SELECT
			SGN.PURCHASE_START_DATE,
			SGN.SERIAL_NO,
			SGN.STOCK_ID,
			SGN.PURCHASE_GUARANTY_CATID,
			(SELECT SGT.GUARANTYCAT_TIME FROM #dsn_alias#.SETUP_GUARANTYCAT_TIME SGT WHERE SGT.GUARANTYCAT_TIME_ID = SG.GUARANTYCAT_TIME) GUARANTYCAT_TIME
		FROM
			SERVICE_GUARANTY_NEW SGN,
			#dsn_alias#.SETUP_GUARANTY AS SG,
			#dsn2_alias#.SHIP_ROW S,
			SERVICE SR
		WHERE
			SGN.PURCHASE_GUARANTY_CATID=SG.GUARANTYCAT_ID AND
			SGN.PROCESS_ID = S.SHIP_ID AND
			SGN.PROCESS_CAT = 140 AND
			SGN.STOCK_ID = SR.STOCK_ID AND
			S.SERVICE_ID = SR.SERVICE_ID AND
			SR.SERVICE_ID = #attributes.service_id#
	</cfquery>
	<cfif GET_PRO_GUARANTY.recordcount and len(GET_PRO_GUARANTY.PURCHASE_START_DATE)>
		<cfquery name="get_seri_kontrol_son" datasource="#dsn3#"><!--- servis cikis isleminde alis var mi?--->
			SELECT 
				PROCESS_CAT 
			FROM 
				SERVICE_GUARANTY_NEW 
			WHERE 
				SERIAL_NO = '#GET_PRO_GUARANTY.SERIAL_NO#' AND 
				STOCK_ID = #GET_PRO_GUARANTY.STOCK_ID#
			ORDER BY
				GUARANTY_ID DESC
		</cfquery>
		<cfif get_seri_kontrol_son.PROCESS_CAT eq 141>
			<script type="text/javascript">
				alert("<cf_get_lang no ='520.İrsaliye Kaydedildi Ancak Seri No Çıkış Kayıdı Bulunduğu İçin Seri Kaydı Yapılamadı'>!");
			</script>
			<cfset seri_iptal_ = 1>
		</cfif>
		<cfif not isdefined("seri_iptal_")>
			<cfinclude template="../../objects/functions/add_serial_no.cfm">
			<cfset attributes.serial_no_start_number1 = GET_PRO_GUARANTY.SERIAL_NO>
			<cfset attributes.guaranty_purchasesales1 = 1>
			<cfset attributes.stock_id1 = GET_PRO_GUARANTY.STOCK_ID>
			<cfset attributes.guaranty_cat1 = GET_PRO_GUARANTY.PURCHASE_GUARANTY_CATID>
			<cfset attributes.guaranty_startdate1 = GET_PRO_GUARANTY.PURCHASE_START_DATE>
			<cfset temp_start_date = GET_PRO_GUARANTY.PURCHASE_START_DATE>
			<cfif len(temp_start_date) and isdate(temp_start_date)>
				<cfset temp_date = date_add("m", GET_PRO_GUARANTY.GUARANTYCAT_TIME, temp_start_date)>
				<cf_date tarih="temp_start_date">
			</cfif>
			<cfscript>
				add_serial_no(
				session_row : 1,
				process_type : get_process_type.PROCESS_TYPE, 
				process_number : SHIP_NUMBER,
				process_id : MAX_ID.IDENTITYCOL,
				dpt_id : attributes.department_id,
				loc_id : attributes.location_id,
				par_id : attributes.partner_id,
				con_id : attributes.consumer_id,
				main_stock_id : '',
				comp_id : attributes.company_id
				);
			</cfscript>
		</cfif>
	</cfif>
</cfif>
<cfif len(attributes.paper_number)>
	<cfquery name="UPD_PAPERS" datasource="#DSN3#">
		UPDATE 
			PAPERS_NO 
		SET 
			SHIP_NUMBER = #attributes.paper_number# 
		WHERE 
		<cfif isdefined('attributes.paper_printer_id') and len(attributes.paper_printer_id)>
			PRINTER_ID = #attributes.paper_printer_id#
		<cfelse>
			EMPLOYEE_ID = #SESSION.EP.USERID#
		</cfif>
	</cfquery>
	</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
