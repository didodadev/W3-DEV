<cfset product_id_list = "">
<cfset stock_id_list = "">
<cfinclude template="check_our_period.cfm"> 
<cfquery name="GET_NUMBER" datasource="#DSN2#">
	SELECT SHIP_ID FROM SHIP WHERE SHIP_ID = #attributes.upd_id#
</cfquery>
<cfif not get_number.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='336.Böyle Bir İrsaliye Kaydı Bulunamadı'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=stock.list_purchase</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfif isDefined("form.del") and (form.del eq 1)>
	<cfinclude template="upd_del_purchase.cfm">
	<cfabort>
</cfif>

<cfif isdefined('SHIP_NUMBER')>
	<cfset list1=",">
	<cfset list2="">
	<cfset SHIP_NUMBER = Replace(SHIP_NUMBER,list1,list2,"ALL")> 
</cfif>
<cfif attributes.rows_ eq 0>
	<script type="text/javascript">
		alert("<cf_get_lang_main no ='313.Ürün Seçmelisiniz'>!!");
		history.back();
	</script>
	<cfabort>	
</cfif>
<cfquery name="GET_UNIQUE" datasource="#dsn2#">
	SELECT 
		SHIP_NUMBER,
		PURCHASE_SALES,
		SHIP_ID
	FROM 
		SHIP
	WHERE 
		SHIP_NUMBER='#SHIP_NUMBER#' AND 
		PURCHASE_SALES=0 AND
		SHIP_ID <> #attributes.upd_id#
</cfquery>
<cfif GET_UNIQUE.recordcount><!--- get_ship_number --->
	<script type="text/javascript">
		alert("<cf_get_lang no='249.Bu Numara ile Kayıtlı İrsaliye Bulunmakta !'>");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfinclude template="get_process_cat.cfm">

<cfif not len(attributes.location_id) >
	<cfset attributes.location_id = "NULL" >
</cfif>
<cf_date tarih = 'attributes.deliver_date_frm'>
<cf_date tarih = 'attributes.ship_date'>

<cfquery name="get_seriler" datasource="#dsn3#">
	SELECT
		SERIAL_NO,
		STOCK_ID
	FROM
		SERVICE_GUARANTY_NEW SG
	WHERE
		SERIAL_NO IN 
		(SELECT SERIAL_NO FROM SERVICE_GUARANTY_NEW WHERE STOCK_ID = SG.STOCK_ID AND PERIOD_ID = #session.ep.period_id# AND IS_SALE = 1) AND
		SERIAL_NO IN (SELECT SERIAL_NO FROM SERVICE_GUARANTY_NEW WHERE PROCESS_ID = #attributes.upd_id# AND PERIOD_ID = #session.ep.period_id#)
</cfquery>
<cfif get_seriler.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='337.İşlem Görmüş Seri Nolar Var! Güncelleme Yapamazsınız'>!");
		history.back();
	</script>
	<cfabort>
</cfif>

<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="UPD_PURCHASE" datasource="#dsn2#">
			UPDATE
				SHIP
			SET
				SHIP_NUMBER = '#SHIP_NUMBER#',
				SHIP_TYPE = #get_process_type.PROCESS_TYPE#,
				PROCESS_CAT=#form.process_cat#,
			<cfif isDefined('attributes.SHIP_METHOD') and len(SHIP_METHOD) >
				SHIP_METHOD = #SHIP_METHOD#,
			</cfif>
				SHIP_DATE = #attributes.ship_date#,
			<cfif len(attributes.company_id) and attributes.company_id neq 0>
				COMPANY_ID = #attributes.company_id#,
				PARTNER_ID = <cfif len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
				CONSUMER_ID= NULL,
			<cfelse>
				COMPANY_ID = NULL,
				PARTNER_ID = NULL,
				CONSUMER_ID=#attributes.consumer_id#,
			</cfif>
			<cfif isdate(attributes.deliver_date_frm)>
				DELIVER_DATE = #attributes.deliver_date_frm#,
			</cfif>
				DELIVER_EMP = '#LEFT(TRIM(DELIVER_GET_ID),50)#',
			<cfif isDefined("PAYMETHOD_ID")>
				PAYMETHOD_ID = #PAYMETHOD_ID#,
			</cfif>
				DISCOUNTTOTAL =<cfif isdefined("attributes.BASKET_DISCOUNT_TOTAL")>#attributes.BASKET_DISCOUNT_TOTAL#,<cfelse>0,</cfif>
				NETTOTAL = <cfif isdefined("attributes.basket_net_total")>0#attributes.basket_net_total#,<cfelse>0,</cfif>
				GROSSTOTAL =<cfif isdefined("attributes.basket_gross_total")>0#attributes.basket_gross_total#,<cfelse>0,</cfif>
				TAXTOTAL =<cfif isdefined("attributes.basket_tax_total")>0#attributes.basket_tax_total#,<cfelse>0,</cfif>
				<!---MONEY = '#session.ep.money#',
				 RATE1 = #attributes.basket_rate1#,
				RATE2 = #attributes.basket_rate2#, --->
				OTHER_MONEY ='#form.basket_money#',
				OTHER_MONEY_VALUE =#((form.BASKET_NET_TOTAL*form.BASKET_RATE1)/form.BASKET_RATE2)#,
				DEPARTMENT_IN = #attributes.department_id#,
				LOCATION_IN=#attributes.location_id#,
				UPDATE_DATE = #now()#,
				UPDATE_EMP =#session.ep.userid#
			WHERE
				SHIP_ID = #attributes.UPD_ID#
		</cfquery>
		<cfquery name="DEL_SHIP_ROWS" datasource="#dsn2#">
			DELETE FROM SHIP_ROW WHERE SHIP_ID=#attributes.UPD_ID#
		</cfquery>
		<cfquery name="DEL_STOCKS_ROW" datasource="#dsn2#">
			DELETE FROM STOCKS_ROW WHERE UPD_ID=#attributes.UPD_ID# AND PROCESS_TYPE=#attributes.old_process_type#
		</cfquery>
		<cfloop from="1" to="#attributes.rows_#" index="i">
			<cfinclude template="get_dis_amount.cfm">
			<cfquery name="ADD_SHIP_ROW" datasource="#dsn2#">
				INSERT INTO
					SHIP_ROW
					(
					NAME_PRODUCT,
					PURCHASE_SALES,
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
					EXTRA_COST,
					BASKET_EXTRA_INFO_ID,
					SELECT_INFO_EXTRA,
                    DETAIL_INFO_EXTRA,
					SERVICE_ID,
					ROW_ORDER_ID,
					WRK_ROW_ID,
					WRK_ROW_RELATION_ID,
					IS_PROMOTION,
					WIDTH_VALUE,
					DEPTH_VALUE,
					HEIGHT_VALUE,
					ROW_PROJECT_ID
					)
				VALUES
					(
					'#left(evaluate("attributes.product_name#i#"),250)#',
					0,
					#attributes.UPD_ID#,
					#evaluate("attributes.stock_id#i#")#,
					#evaluate("attributes.product_id#i#")#,
					#evaluate("attributes.amount#i#")#,
					'#wrk_eval("attributes.unit#i#")#',
					#evaluate("attributes.unit_id#i#")#,
					#evaluate("attributes.tax#i#")#,
				<cfif len(evaluate("attributes.price#i#"))>
					#evaluate("attributes.price#i#")#,
				</cfif>
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
				<cfif isdefined("attributes.other_money_gross_total#i#") and len(evaluate("attributes.other_money_gross_total#i#"))>#evaluate("attributes.other_money_gross_total#i#")#<cfelse>0</cfif>,
				<cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
				<cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.select_info_extra#i#') and len(evaluate('attributes.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.select_info_extra#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.detail_info_extra#i#') and len(evaluate('attributes.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.row_service_id#i#') and len(evaluate('attributes.row_service_id#i#'))>'#wrk_eval('attributes.row_service_id#i#')#'<cfelse>NULL</cfif>,
					0,
				<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))>'#wrk_eval('attributes.wrk_row_id#i#')#'<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))>'#wrk_eval('attributes.wrk_row_relation_id#i#')#'<cfelse>NULL</cfif>,
					0,
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
			<cfquery name="GET_KARMA_PRODUCTS" datasource="#dsn2#"><!--- karma koli olan ürünler --->
				SELECT PRODUCT_ID FROM #dsn3_alias#.PRODUCT WHERE PRODUCT_ID IN (#product_id_list#) AND IS_KARMA=1
			</cfquery>
			<cfquery name="GET_PROD_PRODUCTS" datasource="#dsn2#"><!--- üretilen ürünler --->
				SELECT STOCK_ID FROM #dsn3_alias#.STOCKS WHERE STOCK_ID IN (#stock_id_list#) AND IS_PRODUCTION=1
			</cfquery>
			<cfset karma_product_list = valuelist(GET_KARMA_PRODUCTS.PRODUCT_ID)>
			<cfset prod_product_list = valuelist(GET_PROD_PRODUCTS.STOCK_ID)>

			<cfloop from="1" to="#attributes.rows_#" index="i">
				<cfinclude template="../../stock/query/get_unit_add_fis.cfm">
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
								STOCK_IN,
								STORE,
								STORE_LOCATION,
								PROCESS_DATE,
								SPECT_VAR_ID,			
								LOT_NO
							)
							VALUES
							(
								#attributes.UPD_ID#,
								#evaluate("attributes.product_id#i#")#,
								#evaluate("attributes.stock_id#i#")#,
								#get_process_type.PROCESS_TYPE#,
								#multi#,
								#attributes.department_id#,
								#attributes.location_id#,
								<cfif isdate(attributes.deliver_date_frm)>#attributes.deliver_date_frm#,<cfelse>#attributes.ship_date#,</cfif>
								<cfif isdefined('attributes.spect_id#i#') and len(evaluate('attributes.spect_id#i#')) and len(GET_SPEC_MAIN.SPECT_MAIN_ID)>#GET_SPEC_MAIN.SPECT_MAIN_ID#,<cfelse>NULL,</cfif>
								<cfif isdefined('attributes.lot_no#i#') and len(evaluate('attributes.lot_no#i#'))>#evaluate('attributes.lot_no#i#')#<cfelse>NULL</cfif>
							)
					</cfquery>
				</cfif>
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
									STOCK_IN,
									STORE,
									STORE_LOCATION,
									PROCESS_DATE
								)
								VALUES
								(
									#attributes.UPD_ID#,
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
									STOCK_IN,
									STORE,
									STORE_LOCATION,
									PROCESS_DATE
								)
								VALUES
								(
									#attributes.UPD_ID#,
									#GET_KARMA_PRODUCT.product_id#,
									#GET_KARMA_PRODUCT.stock_id#,
									#get_process_type.PROCESS_TYPE#,
									#multi*GET_KARMA_PRODUCT.product_amount#,
									#attributes.department_id#,
									#attributes.location_id#,
									<cfif isdate(attributes.deliver_date_frm)>#attributes.deliver_date_frm#<cfelse>#attributes.ship_date#</cfif>
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
									STOCK_IN,
									STORE,
									STORE_LOCATION,
									PROCESS_DATE
								)
								VALUES
								(
									#attributes.UPD_ID#,
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
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>
<cfscript>
	basket_kur_ekle(action_id:attributes.UPD_ID,table_type_id:2,process_type:1);
</cfscript>
<cflocation url="#request.self#?fuseaction=service.popup_upd_purchase_ship&ship_id=#attributes.UPD_ID#&service_id=#attributes.service_id#" addtoken="No">
