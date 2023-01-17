<cfquery name="get_money" datasource="#dsn2#">
	SELECT * FROM SETUP_MONEY
</cfquery>
<cfoutput query="get_money">
	<cfset "rate2_#money#" = rate2>
</cfoutput>
<cfset is_karma_pro=1>
<cfif isdefined("attributes.record_num") and attributes.record_num neq 0>
	<cfinclude  template="upd_product_unit.cfm">
	<cfif isdefined("attributes.isCreateProduct")>
		<cfquery name="GET_PRICE" datasource="#DSN3#">
			SELECT
				PRICE,
				PRICE_KDV,
				IS_KDV,
				MONEY 
			FROM 
				PRICE_STANDART,
				PRODUCT_UNIT
			WHERE
				PRICE_STANDART.PURCHASESALES = 0 AND
				PRODUCT_UNIT.IS_MAIN = 1 AND 
				PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
				PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
				PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND	
				PRICE_STANDART.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
		</cfquery>
		<cfquery name="GET_UNIT" datasource="#dsn1#">
			SELECT 
				PRODUCT_UNIT_ID,
				MAIN_UNIT,
				MAIN_UNIT_ID
			FROM 
				PRODUCT_UNIT 
			WHERE 
				PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND 
				IS_MAIN = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND 
				PRODUCT_UNIT_STATUS = 1
		</cfquery>
		<cfscript>
			detail = "#get_product_name(attributes.pid)#-"&iif(isdefined("attributes.property_collar_det") and len(attributes.property_collar_det),"listGetAt(attributes.property_collar_det, 2,'-')",DE(""));

				cmp = createObject("component", "V16.product.cfc.get_product");
				cmp.dsn1 = dsn1;
				cmp.dsn_alias = dsn_alias;
				GET_PRODUCT = cmp.get_product_(pid : attributes.pid);
				add_product = cmp.add_product(
					product_name:attributes.karma_product_name,
                    MAXIMUM_STOCK:GET_PRODUCT.MAXIMUM_STOCK,
                    MINIMUM_STOCK:GET_PRODUCT.MINIMUM_STOCK,
                    otv:GET_PRODUCT.otv,
                    otv_type:GET_PRODUCT.otv_type,
                    oiv:GET_PRODUCT.oiv,
                    bsmv:GET_PRODUCT.bsmv,
					unit:'#GET_UNIT.MAIN_UNIT_ID#,#GET_UNIT.MAIN_UNIT#',
                    dimention:GET_PRODUCT.dimention,
                    weight:GET_PRODUCT.weight,
                    is_ship_unit:GET_PRODUCT.is_ship_unit,
                    tax_purchase:GET_PRODUCT.tax_purchase,
                    tax:GET_PRODUCT.tax,
                    max_margin:GET_PRODUCT.max_margin,
                    min_margin:GET_PRODUCT.min_margin,
                    product_detail:detail,
                    product_detail2:GET_PRODUCT.product_detail2,
                    barcod:attributes.barcod,
                    product_code_2:GET_PRODUCT.product_code_2,
                    product_code:get_product_no(action_type:'product_no'),
                    product_manager:GET_PRODUCT.product_manager,
                    product_manager_name:GET_PRODUCT.PRODUCT_MANAGER,
                    prod_comp:GET_PRODUCT.PROD_COMPETITIVE,
                    segment_id:GET_PRODUCT.segment_id,
                    hierarchy:GET_PRODUCT.hierarchy,
                    brand_name:GET_PRODUCT.brand_name,
                    brand_id:GET_PRODUCT.brand_id,
                    brand_code:GET_PRODUCT.brand_code,
                    short_code:GET_PRODUCT.short_code,
                    short_code_id:GET_PRODUCT.short_code_id,
                    MANUFACT_CODE:GET_PRODUCT.MANUFACT_CODE,
                    is_prototype:GET_PRODUCT.is_prototype,
                    is_inventory:GET_PRODUCT.is_inventory,
                    product_status:GET_PRODUCT.product_status,
                    is_production:GET_PRODUCT.is_production,
                    is_sales:GET_PRODUCT.is_sales,
                    is_purchase:GET_PRODUCT.is_purchase,
                    is_internet:GET_PRODUCT.is_internet,
                    is_extranet:GET_PRODUCT.is_extranet,
                    is_zero_stock:GET_PRODUCT.is_zero_stock,
                    is_serial_no:GET_PRODUCT.is_serial_no,
                    is_lot_no:GET_PRODUCT.is_lot_no,
                    is_karma:GET_PRODUCT.is_karma,
                    is_limited_stock:GET_PRODUCT.is_limited_stock,
                    is_cost:GET_PRODUCT.is_cost,
                    is_terazi:GET_PRODUCT.is_terazi,
                    gift_valid_day:GET_PRODUCT.gift_valid_day,
                    is_commission:GET_PRODUCT.is_commission,
                    is_gift_card:GET_PRODUCT.is_gift_card,
                    is_quality:GET_PRODUCT.is_quality,
                    PACKAGE_CONTROL_TYPE:GET_PRODUCT.PACKAGE_CONTROL_TYPE,
                    company_id:GET_PRODUCT.company_id,
                    company:GET_PRODUCT.company,
                    shelf_life:GET_PRODUCT.shelf_life,
                    PRODUCT_CATID:GET_PRODUCT.PRODUCT_CATID,
                    customs_recipe_code:GET_PRODUCT.customs_recipe_code,
                    is_barcode_control:1,
                    process_stage:GET_PRODUCT.PRODUCT_STAGE,
                    barcode_require:1,
                    is_watalogy_integrated:GET_PRODUCT.is_watalogy_integrated,
                    watalogy_cat_id:GET_PRODUCT.watalogy_cat_id,
                    origin:GET_PRODUCT.origin_id,
                    watalogy_cat_name:GET_PRODUCT.watalogy_cat_id,
                    is_add_xml:GET_PRODUCT.is_add_xml,
                    PURCHASE:get_price.PRICE,
                    is_tax_included_purchase:get_price.is_kdv,
                    MONEY_ID_SA:get_price.MONEY,
                    PRICE:get_price.PRICE,
                    is_tax_included_sales:get_price.is_kdv,
                    MONEY_ID_SS:get_price.MONEY,
                    user_friendly_url:GET_PRODUCT.user_friendly_url,
                    fuseaction:'product.list_product',
                    product_description:GET_PRODUCT.product_description,
                    product_keyword:GET_PRODUCT.product_keyword,
                    product_detail_watalogy:GET_PRODUCT.product_detail_watalogy,
					KARMA_FOR_PRODUCT_ID: attributes.pid,
					KARMA_PROPERTY_DETAIL_ID: iif(isdefined("attributes.property_collar_det") and len(attributes.property_collar_det),"listGetAt(attributes.property_collar_det, 1,'-')",DE("")),
					KARMA_PROPERTY_COLLAR_ID:iif(isdefined("attributes.property_collar_id") and len(attributes.property_collar_id),"attributes.property_collar_id",DE("")),
					KARMA_PROPERTY_SIZE_ID:iif(isdefined("attributes.property_size_id") and len(attributes.property_size_id),"attributes.property_size_id",DE(""))
				);
			attributes.karma_product_id = add_product.identity;
			attributes.pid = add_product.identity;
		</cfscript>
		<cfinclude  template="upd_product_unit.cfm">
	</cfif>
    <cfquery name="UPDATE_PRODUCT" datasource="#DSN1#">
        UPDATE
			PRODUCT
        SET 
            IS_KARMA_SEVK = <cfif isdefined('attributes.is_karma_sevk')><cfqueryparam cfsqltype="cf_sql_bit" value="1"><cfelse><cfqueryparam cfsqltype="cf_sql_bit" value="0"></cfif>,
			IS_KARMA = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
			<cfif isdefined('attributes.master_code') and len(attributes.master_code) and listLen(attributes.master_code,'-') eq 2 and not isdefined("attributes.isCreateProduct")>
				,PRODUCT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.master_code#-#attributes.record_num#">
			</cfif>
        WHERE 
            PRODUCT_ID = #attributes.karma_product_id#
    </cfquery>
	<cfquery name="GET_PRODUCT_UNIT" datasource="#DSN3#"><!--- Karma Ürünün birimini alıyoruz. --->
		SELECT PRODUCT_UNIT_ID FROM PRODUCT_UNIT WHERE PRODUCT_ID = #attributes.karma_product_id# AND PRODUCT_UNIT_STATUS = 1 AND IS_MAIN = 1
	</cfquery>
	<cfquery name="GET_KDV" datasource="#DSN1#"><!--- Karma Ürünün satış kdv'sini alıyoruz. --->
		SELECT TAX FROM PRODUCT WHERE PRODUCT_ID = #attributes.karma_product_id#
	</cfquery>
	<cfquery name="get_money" datasource="#DSN1#"><!--- Karma Ürünün Money'ini alıyoruz. --->
		SELECT MONEY,IS_KDV FROM PRICE_STANDART WHERE PRICE_STANDART.PURCHASESALES = 0 AND PRICE_STANDART.PRICESTANDART_STATUS = 1 AND PRICE_STANDART.PRODUCT_ID = #attributes.karma_product_id# 
	</cfquery>	
	<cfset karma_sales_price_kdv = (attributes.GROSSTOTAL_PRICE +(attributes.GROSSTOTAL_PRICE*GET_KDV.TAX)/100)>
	<cfquery name="GET_KARMA_PRODUCTS_STANDART" datasource="#dsn3#">
		SELECT * FROM #dsn1_alias#.KARMA_PRODUCTS WHERE KARMA_PRODUCT_ID = #attributes.karma_product_id# ORDER BY ENTRY_ID
	</cfquery>
	<cfif (not len(attributes.price_catid) or attributes.price_catid eq -1) or GET_KARMA_PRODUCTS_STANDART.recordcount eq 0><!--- İLK DEFA ÜRÜN EKLENİYORSA --->
		<cflock name="#CreateUUID()#" timeout="20">
			<cftransaction>
				<cfquery name="DEL_CATALOG_PROMOTION" datasource="#dsn1#">
					DELETE KARMA_PRODUCTS WHERE KARMA_PRODUCT_ID = #attributes.karma_product_id#
				</cfquery>
				<cfloop from="1" to="#attributes.record_num#" index="kk">
					<cfif evaluate("attributes.row_kontrol#kk#") eq 1>
						<cfset row_money = listfirst(evaluate("attributes.money#kk#"),';')>
						<cfquery name="ADD_KARMA_PRODUCT" datasource="#dsn1#">
							INSERT INTO 
								KARMA_PRODUCTS
								(
								KARMA_PRODUCT_ID,
								PRODUCT_ID,
								STOCK_ID,
                                SPEC_MAIN_ID,
								PRODUCT_NAME,
								TAX,
								TAX_PURCHASE,
								PRODUCT_UNIT_ID,
								UNIT,
								MONEY,
								PURCHASE_PRICE,
								SALES_PRICE,
								TOTAL_PRODUCT_PRICE,<!--- Toplam satış fiyatı --->
								PRODUCT_AMOUNT,
								KARMA_PRODUCT_MONEY,
								LIST_PRICE,
								OTHER_LIST_PRICE,
								PROPERTY_1,
								PROPERTY_2
								)
							VALUES   
								(
								#attributes.karma_product_id#,
								#evaluate('attributes.product_id#kk#')#,
								<cfif evaluate('attributes.stock_id#kk#') neq "">
								#evaluate('attributes.stock_id#kk#')#<cfelse>NULL</cfif>,
                                <cfif len(evaluate('attributes.spec_main_id#kk#'))>#evaluate('attributes.spec_main_id#kk#')#<cfelse>NULL</cfif>,
								'#wrk_eval('attributes.product_name#kk#')#',
								#evaluate('attributes.tax#kk#')#,
								#evaluate('attributes.tax_purchase#kk#')#,
								#evaluate('attributes.unit_id#kk#')#,
								'#wrk_eval('attributes.unit#kk#')#',
								'#row_money#',
								 <cfif len(evaluate('attributes.spec_main_id#kk#'))>#evaluate('attributes.p_price#kk#')#<cfelse>NULL</cfif>,
								#evaluate('attributes.s_price#kk#')#,
								#evaluate('attributes.total_product_price#kk#')#,
								#evaluate('attributes.row_amount#kk#')#,
								'#attributes.price_money#',
								 <cfif len(evaluate('attributes.list_price#kk#'))>#evaluate('attributes.list_price#kk#')#<cfelse>0</cfif>,
								 <cfif len(evaluate('attributes.other_list_price#kk#'))>#evaluate('attributes.other_list_price#kk#')#<cfelse>0</cfif>,
								<cfif isdefined('attributes.PROPERTY_1_#kk#') and  len(evaluate('attributes.PROPERTY_1_#kk#'))>'#evaluate('attributes.PROPERTY_1_#kk#')#'<cfelse>NULL</cfif>,
								<cfif isdefined('attributes.PROPERTY_2_#kk#') and len(evaluate('attributes.PROPERTY_2_#kk#'))>'#evaluate('attributes.PROPERTY_2_#kk#')#'<cfelse>NULL</cfif>
								)
						</cfquery>
					</cfif>	
				</cfloop>
			
				<cfset bugun_00 = DateFormat(now(),dateformat_style)>
				<cf_date tarih='bugun_00'>
				<!---Standart Price'a Fiyat Atılıyor.  --->
				<cfquery name="get_kdv_info" datasource="#DSN1#">
					SELECT IS_KDV FROM PRICE_STANDART WHERE PURCHASESALES = 1 AND PRICESTANDART_STATUS = 1 AND PRODUCT_ID = #attributes.karma_product_id# 
				</cfquery>
				<cfset is_kdv_ = get_kdv_info.is_kdv>
				<cfquery name="DEL_PRODUCT_PRICE_SALES" datasource="#DSN1#">
					DELETE FROM
						PRICE_STANDART
					WHERE
						PRODUCT_ID = #attributes.karma_product_id# AND
						PURCHASESALES = 1 AND
						UNIT_ID = #GET_PRODUCT_UNIT.PRODUCT_UNIT_ID# AND
						START_DATE = #bugun_00#						
				</cfquery>
				<cfquery name="UPD_PRICE_STANDART_SALES_STAT" datasource="#DSN1#">
					UPDATE
						PRICE_STANDART
					SET
						PRICESTANDART_STATUS = 0,
						RECORD_EMP=#SESSION.EP.USERID#
					WHERE
						PRODUCT_ID = #attributes.karma_product_id# AND
						PURCHASESALES = 1 AND
						UNIT_ID = #GET_PRODUCT_UNIT.PRODUCT_UNIT_ID# AND
						PRICESTANDART_STATUS = 1
				</cfquery>
				<cfquery name="ADD_PRODUCT_PRICE_SALES" datasource="#DSN1#">
					INSERT INTO
						PRICE_STANDART
					(
						PRICESTANDART_STATUS,
						PRODUCT_ID,
						PURCHASESALES,
						PRICE,
						PRICE_KDV,
						IS_KDV,
						ROUNDING,
						MONEY,
						UNIT_ID,
						START_DATE,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP					
					)
					VALUES
					(
						1,
						#attributes.karma_product_id#,
						1,
						#attributes.GROSSTOTAL_PRICE#,
						#karma_sales_price_kdv#,
						<cfif Len(is_kdv_)>#is_kdv_#<cfelse>1</cfif>,
						0,
						'#attributes.price_money#',
						#GET_PRODUCT_UNIT.PRODUCT_UNIT_ID#,
						#bugun_00#,
						#NOW()#,
						#SESSION.EP.USERID#,
						'#CGI.REMOTE_ADDR#'
					)
				</cfquery>
				<!---Standart Price'a Fiyat Atıldı.  --->
			</cftransaction>
		</cflock>
	</cfif>
	<cfif len(attributes.price_catid) and attributes.price_catid neq -1>
		<cf_date tarih = "attributes.start_date">
		<cf_date tarih = "attributes.finish_date">
		<cfscript>
			attributes.startdate_fn = date_add("n",attributes.start_m,date_add("h",attributes.start_h,attributes.start_date));
			attributes.finishdate_fn = date_add("n",attributes.finish_m,date_add("h",attributes.finish_h,attributes.finish_date));
		</cfscript>
		<cflock name="#CreateUUID()#" timeout="20">
			<cftransaction>
				<cfquery name="GET_KARMA_PRODUCTS_ENTRY_ID" datasource="#dsn3#">
					SELECT * FROM #dsn1_alias#.KARMA_PRODUCTS WHERE KARMA_PRODUCT_ID = #attributes.karma_product_id# ORDER BY ENTRY_ID
				</cfquery>
				<cfquery name="DEL_CATALOG_PROMOTION" datasource="#dsn3#">
					DELETE FROM KARMA_PRODUCTS_PRICE WHERE KARMA_PRODUCT_ID = #attributes.karma_product_id# AND PRICE_CATID = #attributes.price_catid#
				</cfquery>
				<cfloop from="1" to="#attributes.record_num#" index="kk">			
					<cfif evaluate("attributes.row_kontrol#kk#") is 1>
						<cfset sales_price_kdv = evaluate('attributes.other_list_price#kk#')+((evaluate('attributes.other_list_price#kk#')*evaluate('attributes.tax#kk#'))/100)>
						<cfset row_money = listfirst(evaluate("attributes.money#kk#"),';')>
						<cfquery name="ADD_KARMA_PRODUCT" datasource="#dsn3#">
							INSERT INTO 
								KARMA_PRODUCTS_PRICE
								(
								ENTRY_ID,
								KARMA_PRODUCT_ID,
								PRODUCT_ID,
								STOCK_ID,
                                SPEC_MAIN_ID,
								PRICE_CATID,
								MONEY,
								SALES_PRICE,
								SALES_PRICE_KDV,
								TOTAL_PRODUCT_PRICE,
								START_DATE,
								FINISH_DATE,
								LIST_MONEY,
								PROCESS_STAGE,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP,
								PROPERTY_1,
								PROPERTY_2
								)
							VALUES   
								(
								<cfif len(GET_KARMA_PRODUCTS_ENTRY_ID.ENTRY_ID[kk])><cfqueryparam cfsqltype="cf_sql_integer" value="#GET_KARMA_PRODUCTS_ENTRY_ID.ENTRY_ID[kk]#"><cfelse>NULL</cfif>,
								<cfif len(attributes.karma_product_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.karma_product_id#"><cfelse>NULL</cfif>,
								<cfif len(evaluate('attributes.product_id#kk#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.product_id#kk#')#"><cfelse>NULL</cfif>,
								<cfif len(evaluate('attributes.stock_id#kk#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.stock_id#kk#')#"><cfelse>NULL</cfif>,
								<cfif len(evaluate('attributes.spec_main_id#kk#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.spec_main_id#kk#')#"><cfelse>NULL</cfif>,
								<cfif len(attributes.price_catid)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"><cfelse>NULL</cfif>,
								<cfqueryparam cfsqltype="cf_sql_nvarchar" value='#row_money#'>,
								<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.other_list_price#kk#')#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#wrk_round(sales_price_kdv,4)#">,
								<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.total_product_price#kk#')#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate_fn#">,
								<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate_fn#"><cfelse>NULL</cfif>,
								<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.price_money#">,
								<cfif len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
								<cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
								<cfif isdefined('attributes.PROPERTY_1_#kk#') and  len(evaluate('attributes.PROPERTY_1_#kk#'))>'#evaluate('attributes.PROPERTY_1_#kk#')#'<cfelse>NULL</cfif>,
								<cfif isdefined('attributes.PROPERTY_2_#kk#') and len(evaluate('attributes.PROPERTY_2_#kk#'))>'#evaluate('attributes.PROPERTY_2_#kk#')#'<cfelse>NULL</cfif>
								)
						</cfquery>
					</cfif>
				</cfloop>
				<cfscript>
					ilkgun = attributes.startdate_fn;
					songun = attributes.finishdate_fn;
					add_price(product_id : attributes.karma_product_id,
						product_unit_id : GET_PRODUCT_UNIT.PRODUCT_UNIT_ID,
						price_cat : attributes.price_catid,
						start_date : CreateODBCDateTime(ilkgun),
						price : attributes.GROSSTOTAL_PRICE,
						price_money : attributes.price_money,
						price_with_kdv : karma_sales_price_kdv,
						is_kdv : 0
						);
				</cfscript>
				<cfquery name="GET_MAX_PRICE_ID" datasource="#DSN3#">
					SELECT MAX(PRICE_ID) MAX_ID FROM PRICE
				</cfquery>
				<cfset max_id1 = GET_MAX_PRICE_ID.MAX_ID>
				<cfquery name="DEL_CATALOG_PROMOTION" datasource="#dsn3#">
					DELETE PRICE WHERE PRODUCT_ID = #attributes.karma_product_id# AND PRICE_CATID = #attributes.price_catid# AND STARTDATE > #ilkgun# AND FINISHDATE < #songun#
				</cfquery>
				<cfscript>
					add_price(product_id : attributes.karma_product_id,
						product_unit_id : GET_PRODUCT_UNIT.PRODUCT_UNIT_ID,
						price_cat : attributes.price_catid,
						start_date : CreateODBCDateTime(songun),
						price : 0,
						price_money : attributes.price_money,
						price_with_kdv : 0,
						is_kdv : 0
						);
				</cfscript>
				<cfquery name="GET_MAX_PRICE_ID2" datasource="#DSN3#">
					SELECT MAX(PRICE_ID) MAX_ID2 FROM PRICE
				</cfquery>
				<cfset max_id2 = '#max_id1#,#GET_MAX_PRICE_ID2.MAX_ID2#'>
				<cfquery name="UPD_KARMA_PRODUCT_PRICE_ID" datasource="#dsn3#">
					UPDATE KARMA_PRODUCTS_PRICE SET PRICE_ID = '#max_id2#' WHERE KARMA_PRODUCT_ID = #attributes.karma_product_id# AND PRICE_CATID = #attributes.price_catid#
				</cfquery>
				<cf_workcube_process 
					is_upd='1' 
					data_source="#DSN3#"
					old_process_line='0'
					process_stage='#attributes.process_stage#' 
					record_member='#session.ep.userid#'
					record_date='#now()#'
					action_table='KARMA_PRODUCTS_PRICE'
					action_column='KARMA_PRODUCT_ID'
					action_id='#attributes.pid#' 
					action_page='#request.self#?fuseaction=product.dsp_karma_contents&pid=#attributes.pid#&price_catid=#attributes.price_catid#' 
					warning_description="#getLang('','Karma Koli',34010)# : #attributes.pid#">
			</cftransaction>
		</cflock>
	</cfif>
	<script>
		location.href  = "<cfoutput>#request.self#?fuseaction=product.dsp_karma_contents&pid=#attributes.pid#</cfoutput>";
	</script>
<cfelse>
	<script>
		location.href  = document.referrer;
	</script>
</cfif>