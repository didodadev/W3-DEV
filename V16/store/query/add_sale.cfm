<cfif isdefined('ship_number')>
	<cfset list1=",">
	<cfset list2="">
	<cfset ship_number = Replace(ship_number,list1,list2,"ALL")> 
</cfif>
<cfset product_id_list = "">
<cfset stock_id_list = "">
<cfif attributes.rows_ eq 0 >
	<script type="text/javascript">
		alert("<cf_get_lang_main no ='313.Ürün Seçmediniz'>!");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
		//history.back();
	</script>
	<cfabort>	
</cfif>
<!---
<cfif  not len(company_id) and not len(consumer_id)>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='373.Uye Secmelisiniz'>");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
		//history.back();
	</script>
	<cfabort>	
</cfif>
--->

<cfquery name="GET_PURCHASE" datasource="#DSN2#">
	SELECT 
		SHIP_NUMBER,
		PURCHASE_SALES
	FROM 
		SHIP
	WHERE 
		PURCHASE_SALES = 1 AND 
		SHIP_NUMBER='#SHIP_NUMBER#'
</cfquery>
<cfif get_purchase.recordcount >
	<script type="text/javascript">
		alert("<cf_get_lang no='47.Bu Numara ile Kayıtlı İrsaliye Bulunmakta'> !");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
		//history.back();
	</script>
	<cfabort>	
</cfif>

<cfinclude template="get_process_cat.cfm">

<cfif not len(attributes.location_id) >
	<cfset attributes.location_id = "NULL" >
</cfif>
<cf_date tarih = 'attributes.deliver_date_frm'>
<cf_date tarih = 'attributes.ship_date'>
<cfif isdefined("attributes.basket_due_value") and len(attributes.basket_due_value)>
	<cfset ship_due_date = date_add("d",attributes.basket_due_value,attributes.ship_date)>
<cfelse>
	<cfset ship_due_date = "">
</cfif>
<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
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
					DUE_DATE,
					PAYMETHOD_ID,
					SHIP_METHOD,
					SHIP_DATE,
					SHIP_DETAIL,
				<cfif len(attributes.company_id)>
					COMPANY_ID,
					PARTNER_ID,
				<cfelseif len(attributes.consumer_id)>
					CONSUMER_ID,
				</cfif>
					DELIVER_DATE,
					DELIVER_EMP,
					DISCOUNTTOTAL,
					NETTOTAL,
					GROSSTOTAL,
					TAXTOTAL,
					OTHER_MONEY,
					OTHER_MONEY_VALUE,
					DELIVER_STORE_ID,
					LOCATION,
					ADDRESS,
					CITY_ID,
					COUNTY_ID,
					IS_WITH_SHIP,
					REF_NO,
					COMMETHOD_ID,
					PROJECT_ID,
					SA_DISCOUNT,
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
					RECORD_DATE,
					RECORD_EMP
				)
			VALUES
				(
					'#wrk_id#',
					1,
					'#SHIP_NUMBER#',
					#get_process_type.PROCESS_TYPE#,
					#form.process_cat#,					
					<cfif isdefined("ship_due_date") and len(ship_due_date)>#ship_due_date#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.paymethod_id") and len(attributes.paymethod_id)>#attributes.paymethod_id#<cfelse>NULL</cfif>,
					<cfif isDefined('attributes.SHIP_METHOD') and len(attributes.SHIP_METHOD)>#SHIP_METHOD#<cfelse>NULL</cfif>,
					#attributes.ship_date#,
					<cfif isdefined('attributes.detail') and len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
					<cfif len(attributes.company_id)>
						#attributes.company_id#,
						<cfif len(attributes.partner_id)>#attributes.partner_id#,<cfelse>NULL,</cfif>
					<cfelseif len(attributes.consumer_id)>
						#attributes.consumer_id#,
					</cfif>
					<cfif isdate(attributes.deliver_date_frm)>#attributes.deliver_date_frm#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.deliver_get') and len(attributes.deliver_get)>'#LEFT(TRIM(attributes.deliver_get),50)#',<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.BASKET_DISCOUNT_TOTAL")>#attributes.BASKET_DISCOUNT_TOTAL#,<cfelse>0,</cfif>
					<cfif isdefined("attributes.basket_net_total")>#attributes.basket_net_total#,<cfelse>0,</cfif>
					<cfif isdefined("attributes.basket_gross_total")>#attributes.basket_gross_total#,<cfelse>0,</cfif>
					<cfif isdefined("attributes.basket_tax_total")>#attributes.basket_tax_total#,<cfelse>0,</cfif>
					'#form.basket_money#',
					#((form.BASKET_NET_TOTAL*form.BASKET_RATE1)/form.BASKET_RATE2)#,
					#attributes.department_id#,
					#attributes.location_id#,
					<cfif isdefined('DELIVER_GET') or (isdefined("attributes.adres") and len(attributes.adres))>'#ADRES#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.city_id") and len(attributes.city_id)>#attributes.city_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.county_id") and len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
					0,
					<cfif isdefined("attributes.ref_no") and len(attributes.ref_no)>'#attributes.ref_no#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.commethod_id") and len(attributes.commethod_id)>#attributes.commethod_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
					#form.genel_indirim#,
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
					#now()#,
					#session.ep.userid#
				)
		</cfquery>
		<cfloop from="1" to="#attributes.rows_#" index="i">
			<cfif session.ep.our_company_info.spect_type and isdefined('attributes.is_production#i#') and evaluate('attributes.is_production#i#') eq 1 and not isdefined('attributes.spect_id#i#') or not len(evaluate('attributes.spect_id#i#'))>
				<cfset dsn_type=dsn2>
				<cfinclude template="../../objects/query/add_basket_spec.cfm">
			</cfif>
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
					<cfif len(evaluate("attributes.price#i#"))>
						PRICE,
					</cfif>
						PURCHASE_SALES,
						DISCOUNT,
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
						MARGIN,
						ROW_ORDER_ID,
						PROM_COMISSION,
						PROM_COST,
						DISCOUNT_COST,
						PROM_ID,
						IS_PROMOTION,
						PROM_STOCK_ID,
						IS_COMMISSION,
						UNIQUE_RELATION_ID,
						PRODUCT_NAME2,
						AMOUNT2,
						UNIT2,
						EXTRA_PRICE,
						EXTRA_PRICE_TOTAL,
						SHELF_NUMBER,
						PRODUCT_MANUFACT_CODE,
						BASKET_EXTRA_INFO_ID,
						SELECT_INFO_EXTRA,
						DETAIL_INFO_EXTRA,
						OTV_ORAN,
						OTVTOTAL,
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
					<cfif len(evaluate("attributes.price#i#"))>#evaluate("attributes.price#i#")#,</cfif>
						1,
						#indirim1#,
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
						#attributes.department_id#,
						#attributes.location_id#,
					<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
						#evaluate('attributes.spect_id#i#')#,
						'#wrk_eval('attributes.spect_name#i#')#',
					</cfif>
					<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))>#evaluate('attributes.lot_no#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.other_money_#i#')>'#wrk_eval('attributes.other_money_#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.other_money_value_#i#") and len(evaluate("attributes.other_money_value_#i#"))>#evaluate("attributes.other_money_value_#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.price_other#i#') and len(evaluate('attributes.price_other#i#'))>#evaluate("attributes.price_other#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.other_money_gross_total#i#") and len(evaluate("attributes.other_money_gross_total#i#"))>#evaluate("attributes.other_money_gross_total#i#")#,<cfelse>0,</cfif>
					<cfif isdefined('attributes.net_maliyet#i#') and len(evaluate('attributes.net_maliyet#i#'))>#evaluate('attributes.net_maliyet#i#')#<cfelse>0</cfif>,
					<cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
					<cfif isdefined('attributes.marj#i#') and len(evaluate('attributes.marj#i#'))>#evaluate('attributes.marj#i#')#<cfelse>NULL</cfif>,
						#order_id#,
					<cfif isdefined('attributes.promosyon_yuzde#i#') and len(evaluate('attributes.promosyon_yuzde#i#'))>#evaluate('attributes.promosyon_yuzde#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.promosyon_maliyet#i#') and len(evaluate('attributes.promosyon_maliyet#i#'))>#evaluate('attributes.promosyon_maliyet#i#')#<cfelse>0</cfif>,
					<cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>#evaluate('attributes.iskonto_tutar#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_promotion_id#i#') and len(evaluate('attributes.row_promotion_id#i#'))>#evaluate('attributes.row_promotion_id#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.is_promotion#i#') and len(evaluate('attributes.is_promotion#i#'))>#evaluate('attributes.is_promotion#i#')#<cfelse>0</cfif>,
					<cfif isdefined('attributes.prom_stock_id#i#') and len(evaluate('attributes.prom_stock_id#i#'))>#evaluate('attributes.prom_stock_id#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.is_commission#i#') and len(evaluate('attributes.is_commission#i#'))>#evaluate('attributes.is_commission#i#')#<cfelse>0</cfif>,
					<cfif isdefined('attributes.row_unique_relation_id#i#') and len(evaluate('attributes.row_unique_relation_id#i#'))>'#wrk_eval('attributes.row_unique_relation_id#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.product_name_other#i#') and len(evaluate('attributes.product_name_other#i#'))>'#wrk_eval('attributes.product_name_other#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.amount_other#i#') and len(evaluate('attributes.amount_other#i#'))>#evaluate('attributes.amount_other#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.unit_other#i#') and len(evaluate('attributes.unit_other#i#'))>'#wrk_eval('attributes.unit_other#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.ek_tutar#i#') and len(evaluate('attributes.ek_tutar#i#'))>#evaluate('attributes.ek_tutar#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.ek_tutar_total#i#') and len(evaluate('attributes.ek_tutar_total#i#'))>#evaluate('attributes.ek_tutar_total#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))>'#wrk_eval('attributes.manufact_code#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.select_info_extra#i#') and len(evaluate('attributes.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.select_info_extra#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.detail_info_extra#i#') and len(evaluate('attributes.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.otv_oran#i#') and len(evaluate('attributes.otv_oran#i#'))>'#wrk_eval('attributes.otv_oran#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_otvtotal#i#') and len(evaluate('attributes.row_otvtotal#i#'))>#evaluate('attributes.row_otvtotal#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))>'#wrk_eval('attributes.wrk_row_id#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))>'#wrk_eval('attributes.wrk_row_relation_id#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_width#i#') and len(evaluate('attributes.row_width#i#'))>#evaluate('attributes.row_width#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_depth#i#') and len(evaluate('attributes.row_depth#i#'))>#evaluate('attributes.row_depth#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_height#i#') and len(evaluate('attributes.row_height#i#'))>#evaluate('attributes.row_height#i#')#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.row_project_id#i#') and len(evaluate('attributes.row_project_id#i#')) and isdefined('attributes.row_project_name#i#') and len(evaluate('attributes.row_project_name#i#'))>#evaluate('attributes.row_project_id#i#')#<cfelse>NULL</cfif>
					)
			</cfquery>
			<cfset product_id_list=listappend(product_id_list,evaluate("attributes.product_id#i#"))>
			<cfset stock_id_list=listappend(stock_id_list,evaluate("attributes.stock_id#i#"))>
		</cfloop>
		
		<cfif get_process_type.IS_STOCK_ACTION eq 1><!--- Stok hareketi yapılsın --->
			<cfif not ListFind("78,79",get_process_type.PROCESS_TYPE)><!--- alım iadelerde spec-karma-ağaç çözümü yapmasın --->
				<cfquery name="GET_KARMA_PRODUCTS" datasource="#dsn2#"><!--- karma koli olan ürünler --->
					SELECT PRODUCT_ID FROM #dsn3_alias#.PRODUCT WHERE PRODUCT_ID IN (#product_id_list#) AND IS_KARMA=1
				</cfquery>
				<cfquery name="GET_PROD_PRODUCTS" datasource="#dsn2#"><!--- üretilen ürünler --->
					SELECT STOCK_ID FROM #dsn3_alias#.STOCKS WHERE STOCK_ID IN (#stock_id_list#) AND IS_PRODUCTION=1
				</cfquery>
				<cfset karma_product_list = valuelist(GET_KARMA_PRODUCTS.PRODUCT_ID)>
				<cfset prod_product_list = valuelist(GET_PROD_PRODUCTS.STOCK_ID)>
			</cfif>
			
			<cfloop from="1" to="#attributes.rows_#" index="i">
				<cfinclude template="get_unit_add_fis.cfm">
				<cfif get_unit.recordcount  and len(get_unit.multiplier) >
					<cfset multi=get_unit.multiplier*evaluate("attributes.amount#i#")>
				<cfelse>
					<cfset multi=evaluate("attributes.amount#i#")>
				</cfif>
				<cfif not (isdefined("karma_product_list") and ListFind(karma_product_list,evaluate("attributes.product_id#i#")))>
				<!--- satırdaki ürün karma koli olmadığı sürece kendisine hareket yapar,
				bir ürün hem karma koli olup hem spect seçilme gibi durumlarda yanlış çalıştıgı düşünülmesin,business gereği olamaz,
				ürüne bağlı spec,karma koli,ürün ağacı tanımlamalarından sadece biri yapılmalıdır...AE20060621--->
					<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))>
						<cfquery name="GET_SPEC_MAIN" datasource="#dsn2#">
							SELECT SPECT_MAIN_ID FROM #dsn3_alias#.SPECTS WHERE SPECT_VAR_ID = #evaluate("attributes.spect_id#i#")#
						</cfquery>
					</cfif>
					<cfquery name="ADD_STOCK_ROW" datasource="#DSN2#"><!--- satırlardaki ana ürünler için stok hareketleri--->
						INSERT INTO 
							STOCKS_ROW
							(
								UPD_ID,
								PRODUCT_ID,
								STOCK_ID,
								PROCESS_TYPE,
								STOCK_OUT,
								STORE,
								STORE_LOCATION,
								PROCESS_DATE,
								SPECT_VAR_ID,
								LOT_NO,
								SHELF_NUMBER,
								PRODUCT_MANUFACT_CODE
							)
							VALUES
							(
								#MAX_ID.IDENTITYCOL#,
								#evaluate("attributes.product_id#i#")#,
								#evaluate("attributes.stock_id#i#")#,
								#get_process_type.PROCESS_TYPE#,
								#multi#,
								#attributes.department_id#,
								#attributes.location_id#,
							<cfif isdate(attributes.deliver_date_frm)>#attributes.deliver_date_frm#,<cfelse>#attributes.ship_date#,</cfif>
							<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#')) and len(GET_SPEC_MAIN.SPECT_MAIN_ID)>#GET_SPEC_MAIN.SPECT_MAIN_ID#,<cfelse>NULL,</cfif>
							<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))>#evaluate('attributes.lot_no#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
							<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))>'#wrk_eval('attributes.manufact_code#i#')#'<cfelse>NULL</cfif>
							)
					</cfquery>
				</cfif>
				<cfif not ListFind("78,79",get_process_type.PROCESS_TYPE)><!--- alım iadelerde spec-karma-ağaç çözümü yapmasın --->
				<!--- satırdaki ürünlerin spec-ürünağacı-karmakoli çözümleri --->
					<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#'))><!--- spectse --->
						<cfquery name="GET_SPEC_PRODUCT" datasource="#dsn2#">
							SELECT 
								PRODUCT_ID,
								STOCK_ID,
								AMOUNT_VALUE
							FROM
								#dsn3_alias#.SPECTS_ROW
							WHERE
								IS_SEVK = 1 AND<!--- sevkte birleştir--->
								STOCK_ID IS NOT NULL AND
								PRODUCT_ID IS NOT NULL AND 
								SPECT_ID = #evaluate("attributes.spect_id#i#")#
						</cfquery>
						<cfif GET_SPEC_PRODUCT.recordcount>
							<cfloop query="GET_SPEC_PRODUCT">
								<cfquery name="ADD_STOCK_ROW" datasource="#DSN2#">
									INSERT INTO
										STOCKS_ROW
									(
										UPD_ID,
										PRODUCT_ID,
										STOCK_ID,
										PROCESS_TYPE,
										STOCK_OUT,
										STORE,
										STORE_LOCATION,
										PROCESS_DATE
									)
									VALUES
									(
										#MAX_ID.IDENTITYCOL#,
										#GET_SPEC_PRODUCT.product_id#,
										#GET_SPEC_PRODUCT.stock_id#,
										#get_process_type.PROCESS_TYPE#,
										#multi*GET_SPEC_PRODUCT.AMOUNT_VALUE#,
										#attributes.department_id#,
										#attributes.location_id#,
										<cfif isdate(attributes.deliver_date_frm)>#attributes.deliver_date_frm#<cfelse>#attributes.ship_date#</cfif>
									)
								</cfquery>
							</cfloop>
						</cfif>
					<cfelseif len(karma_product_list) and ListFind(karma_product_list,evaluate("attributes.product_id#i#"))><!--- karma koliyse --->
						<cfquery name="GET_KARMA_PRODUCT" datasource="#dsn2#">
							SELECT PRODUCT_ID,STOCK_ID,PRODUCT_AMOUNT FROM #dsn1_alias#.KARMA_PRODUCTS WHERE KARMA_PRODUCT_ID = #evaluate("attributes.product_id#i#")#
						</cfquery>
						<cfif GET_KARMA_PRODUCT.recordcount>
							<cfloop query="GET_KARMA_PRODUCT">
								<cfquery name="ADD_STOCK_ROW" datasource="#DSN2#">
									INSERT INTO
										STOCKS_ROW
									(
										UPD_ID,
										PRODUCT_ID,
										STOCK_ID,
										PROCESS_TYPE,
										STOCK_OUT,
										STORE,
										STORE_LOCATION,
										PROCESS_DATE,
										SHELF_NUMBER,
										PRODUCT_MANUFACT_CODE
									)
									VALUES
									(
										#MAX_ID.IDENTITYCOL#,
										#GET_KARMA_PRODUCT.product_id#,
										#GET_KARMA_PRODUCT.stock_id#,
										#get_process_type.PROCESS_TYPE#,
										#multi*GET_KARMA_PRODUCT.product_amount#,
										#attributes.department_id#,
										#attributes.location_id#,
									<cfif isdate(attributes.deliver_date_frm)>#attributes.deliver_date_frm#<cfelse>#attributes.ship_date#</cfif>,
									<cfif isdefined('attributes.shelf_number#i#') and len(evaluate('attributes.shelf_number#i#'))>#evaluate('attributes.shelf_number#i#')#<cfelse>NULL</cfif>,
									<cfif isdefined('attributes.manufact_code#i#') and len(evaluate('attributes.manufact_code#i#'))>'#wrk_eval('attributes.manufact_code#i#')#'<cfelse>NULL</cfif>
									)
								</cfquery>
							</cfloop>
						</cfif>
					<cfelseif len(prod_product_list) and ListFind(prod_product_list,evaluate("attributes.stock_id#i#"))><!--- üretilen ürünse --->
						<cfquery name="GET_PROD_PRODUCT" datasource="#dsn2#">
							SELECT
								S.STOCK_ID,
								S.PRODUCT_ID,
								PT.AMOUNT
							FROM
								#dsn3_alias#.PRODUCT_TREE PT,
								#dsn3_alias#.STOCKS S
							WHERE
								PT.RELATED_ID = S.STOCK_ID AND
								PT.IS_SEVK = 1 AND<!--- sevkte birleştir--->
								PT.STOCK_ID = #evaluate("attributes.stock_id#i#")#
						</cfquery>
						<cfif GET_PROD_PRODUCT.recordcount>
							<cfloop query="GET_PROD_PRODUCT">
								<cfquery name="ADD_STOCK_ROW" datasource="#DSN2#">
									INSERT INTO
										STOCKS_ROW
									(
										UPD_ID,
										PRODUCT_ID,
										STOCK_ID,
										PROCESS_TYPE,
										STOCK_OUT,
										STORE,
										STORE_LOCATION,
										PROCESS_DATE
									)
									VALUES
									(
										#MAX_ID.IDENTITYCOL#,
										#GET_PROD_PRODUCT.PRODUCT_ID#,
										#GET_PROD_PRODUCT.STOCK_ID#,
										#get_process_type.PROCESS_TYPE#,
										#multi*GET_PROD_PRODUCT.AMOUNT#,
										#attributes.department_id#,
										#attributes.location_id#,
										<cfif isdate(attributes.deliver_date_frm)>#attributes.deliver_date_frm#<cfelse>#attributes.ship_date#</cfif>
									)
								</cfquery>
							</cfloop>
						</cfif>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
			
		<cfif isdefined("attributes.order_id_listesi") and len(attributes.order_id_listesi)>
			<cfloop list="#attributes.order_id_listesi#" index="k">
				<cfquery name="add_orders_ship" datasource="#dsn2#">
					INSERT INTO
						#dsn3_alias#.ORDERS_SHIP
						(
							ORDER_ID,
							SHIP_ID,
							PERIOD_ID
						)
					VALUES
						(
							#k#,
							#MAX_ID.IDENTITYCOL#,
							#session.ep.period_id#
						)
				</cfquery>
				<cfset attributes.order_id = k >
				<cfinclude template="get_order_rate.cfm">
			</cfloop>
		</cfif> <!--- coklu siparis ekleme ---> 
		<cfscript>basket_kur_ekle(action_id:MAX_ID.IDENTITYCOL,table_type_id:2,process_type:0);</cfscript>	
	</cftransaction>
</cflock>

<cfinclude template="../../objects/functions/add_serial_no.cfm">
<cfloop from="1" to="#attributes.rows_#" index="i">
	<cfif isdefined("attributes.is_serial_no#i#")>
		<cfif len(evaluate('attributes.guaranty_purchasesales#i#')) and (evaluate('attributes.is_serial_no#i#') eq 1)>  
			<cfscript>
				add_serial_no(
					session_row : i,
					is_insert : true,
					process_id :MAX_ID.IDENTITYCOL,
					process_type : get_process_type.PROCESS_TYPE,
					process_number :'#LEFT(SHIP_NUMBER,50)#',
					dpt_id : attributes.department_id,
					loc_id : attributes.location_id,
					is_sale : 1,
					is_purchase : 0,
					par_id : attributes.partner_id,
					con_id : attributes.consumer_id,
					comp_id : attributes.company_id
				);
			</cfscript>
		</cfif>
	</cfif>
</cfloop>
 
<cfif len(attributes.paper_number)>
	<cfquery name="UPD_PAPER" datasource="#dsn3#">
		UPDATE 
			PAPERS_NO 
		SET 
			SHIP_NUMBER=#attributes.paper_number# 
		WHERE 
		<cfif isdefined('attributes.paper_printer_id') and len(attributes.paper_printer_id)>
			PRINTER_ID = #attributes.paper_printer_id#
		<cfelse>
			EMPLOYEE_ID = #SESSION.EP.USERID#
		</cfif>
	</cfquery>
</cfif>
<cflocation url="#request.self#?fuseaction=store.form_add_sale&event=upd&ship_id=#MAX_ID.IDENTITYCOL#" addtoken="no">
