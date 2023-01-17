<cfset product_id_list = "">
<cfset stock_id_list = "">
<cfinclude template="check_our_period.cfm">
<cfif isdefined('ship_number')>
	<cfset list1=",">
	<cfset list2="">
	<cfset ship_number = Replace(ship_number,list1,list2,"ALL")> 
</cfif>
<cfif attributes.rows_ eq 0>
	<script type="text/javascript">
		alert("<cf_get_lang_main no ='313.Ürün Seçmelisiniz'>!");
		history.back();
	</script>
	<cfabort>	
</cfif>
<cfif not len(company_id) and not len(consumer_id)>
	<script type="text/javascript">
		alert("<cf_get_lang_main no ='373.Üye Seçmediniz '>!");
		history.back();
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
		SHIP_NUMBER='#SHIP_NUMBER#'
</cfquery>
<cfif get_purchase.recordcount >
	<script type="text/javascript">
		alert("<cf_get_lang no ='249.Bu Numara ile Kayıtlı İrsaliye Bulunmakta'> !");
		history.back();
	</script>
	<cfabort>	
</cfif>
<cfinclude template="get_process_cat.cfm">
<cfif not len(attributes.location_id)>
	<cfset attributes.location_id = "NULL">
</cfif>
<cf_date tarih = 'attributes.deliver_date_frm'>
<cf_date tarih = 'attributes.ship_date'>


<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
<cfset karma_product_list="">
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
			<cfif len(attributes.company_id)>
				COMPANY_ID,
				PARTNER_ID,
			<cfelse>
				CONSUMER_ID,
			</cfif>
				<cfif isdate(attributes.deliver_date_frm)>DELIVER_DATE,</cfif>
				DELIVER_EMP,
				DISCOUNTTOTAL,
				NETTOTAL,
				GROSSTOTAL,
				TAXTOTAL,
				OTHER_MONEY,
				OTHER_MONEY_VALUE,
				DELIVER_STORE_ID,
				LOCATION,
				RECORD_DATE,
				ADDRESS,
				CITY_ID,
				COUNTY_ID,
				RECORD_EMP,
				IS_WITH_SHIP
			)
			VALUES
			(
				'#wrk_id#',
				1,
				'#SHIP_NUMBER#',
				#get_process_type.PROCESS_TYPE#,
				#form.process_cat#,					
				<cfif isDefined('attributes.SHIP_METHOD') and len(attributes.SHIP_METHOD)>
					#SHIP_METHOD#,
				<cfelse>
					NULL,
				</cfif>
				#attributes.ship_date#,
				<cfif len(attributes.company_id) >
					#attributes.company_id#,
					<cfif len(attributes.partner_id)>#attributes.partner_id#,<cfelse>NULL,</cfif>
				<cfelse>
					#attributes.consumer_id#,
				</cfif>
				<cfif isdate(attributes.deliver_date_frm)>
					#attributes.deliver_date_frm#,
				</cfif>
				'#LEFT(TRIM(DELIVER_GET),50)#',
				<cfif isdefined("attributes.BASKET_DISCOUNT_TOTAL")>#attributes.BASKET_DISCOUNT_TOTAL#,<cfelse>0,</cfif>
				<cfif isdefined("attributes.basket_net_total")>#attributes.basket_net_total#,<cfelse>0,</cfif>
				<cfif isdefined("attributes.basket_gross_total")>#attributes.basket_gross_total#,<cfelse>0,</cfif>
				<cfif isdefined("attributes.basket_tax_total")>#attributes.basket_tax_total#,<cfelse>0,</cfif>
				'#form.basket_money#',
				#((form.BASKET_NET_TOTAL*form.BASKET_RATE1)/form.BASKET_RATE2)#,
				#attributes.department_id#,
				#attributes.location_id#,
				#now()#,
				'#ADRES#',
				<cfif isdefined("attributes.city_id") and len(attributes.city_id)>#attributes.city_id#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.county_id") and len(attributes.county_id)>#attributes.county_id#<cfelse>NULL</cfif>,
				#session.ep.userid#,
				0
			)
		</cfquery>
		<cfloop from="1" to="#attributes.rows_#" index="i">
			<cfinclude template="../../stock/query/get_dis_amount.cfm">
			<cfquery name="ADD_SHIP_ROW" datasource="#DSN2#">
				INSERT INTO
					SHIP_ROW
				(
					SERVICE_ID,
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
					<!--- COST_ID, --->
					COST_PRICE,
					EXTRA_COST,
					MARGIN,
					ROW_ORDER_ID,
					<!--- Yeni Eklenen Alanlar --->
					PROM_COMISSION,
					PROM_COST,
					DISCOUNT_COST,
					PROM_ID,
					IS_PROMOTION,
					BASKET_EXTRA_INFO_ID,
					SELECT_INFO_EXTRA,
                    DETAIL_INFO_EXTRA,
					WRK_ROW_ID,
					WRK_ROW_RELATION_ID,
					PROM_STOCK_ID,
					WIDTH_VALUE,
					DEPTH_VALUE,
					HEIGHT_VALUE,
					ROW_PROJECT_ID
				)
				VALUES
				(
					<cfif isdefined('attributes.row_service_id#i#') and len(evaluate('attributes.row_service_id#i#'))>#evaluate("attributes.row_service_id#i#")#,<cfelseif isdefined("attributes.service_id")>#attributes.service_id#,<cfelse>NULL,</cfif>
					'#left(evaluate("attributes.product_name#i#"),250)#',
					<cfif isdefined("attributes.paymethod_id#i#") and len(evaluate("attributes.paymethod_id#i#"))>#evaluate("attributes.paymethod_id#i#")#,<cfelse>NULL,</cfif>
					#MAX_ID.IDENTITYCOL#,
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
					<!--- <cfif isdefined('attributes.cost_id#i#') and len(evaluate('attributes.cost_id#i#'))>#evaluate('attributes.cost_id#i#')#<cfelse>NULL</cfif>, --->
					<cfif isdefined('attributes.net_maliyet#i#') and len(evaluate('attributes.net_maliyet#i#'))>#evaluate('attributes.net_maliyet#i#')#<cfelse>0</cfif>,
					<cfif isdefined('attributes.extra_cost#i#') and len(evaluate('attributes.extra_cost#i#'))>#evaluate('attributes.extra_cost#i#')#<cfelse>0</cfif>,
					<cfif isdefined('attributes.marj#i#') and len(evaluate('attributes.marj#i#'))>#evaluate('attributes.marj#i#')#<cfelse>NULL</cfif>,
					0,
					<cfif isdefined('attributes.promosyon_yuzde#i#') and len(evaluate('attributes.promosyon_yuzde#i#'))>
						#evaluate('attributes.promosyon_yuzde#i#')#,
					<cfelse>
						NULL,
					</cfif>
					<cfif isdefined('attributes.promosyon_maliyet#i#') and len(evaluate('attributes.promosyon_maliyet#i#'))>
						#evaluate('attributes.promosyon_maliyet#i#')#,
					<cfelse>
						0,
					</cfif>
					<cfif isdefined('attributes.iskonto_tutar#i#') and len(evaluate('attributes.iskonto_tutar#i#'))>
						#evaluate('attributes.iskonto_tutar#i#')#,
					<cfelse>
						NULL,
					</cfif>
					<cfif isdefined('attributes.row_promotion_id#i#') and len(evaluate('attributes.row_promotion_id#i#'))>
						#evaluate('attributes.row_promotion_id#i#')#,
					<cfelse>
						NULL,
					</cfif>
					<cfif isdefined('attributes.is_promotion#i#') and len(evaluate('attributes.is_promotion#i#'))>
						#evaluate('attributes.is_promotion#i#')#,
					<cfelse>
						0,
					</cfif>
					<cfif isdefined('attributes.basket_extra_info#i#') and len(evaluate('attributes.basket_extra_info#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.basket_extra_info#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.select_info_extra#i#') and len(evaluate('attributes.select_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.select_info_extra#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.detail_info_extra#i#') and len(evaluate('attributes.detail_info_extra#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail_info_extra#i#')#"><cfelse>NULL</cfif>,
					<cfif isdefined('attributes.wrk_row_id#i#') and len(evaluate('attributes.wrk_row_id#i#'))>'#wrk_eval('attributes.wrk_row_id#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.wrk_row_relation_id#i#') and len(evaluate('attributes.wrk_row_relation_id#i#'))>'#wrk_eval('attributes.wrk_row_relation_id#i#')#'<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.prom_stock_id#i#') and len(evaluate('attributes.prom_stock_id#i#'))>
						#evaluate('attributes.prom_stock_id#i#')#
					<cfelse>
						NULL
					</cfif>,
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
								STOCK_OUT,
								STORE,
								STORE_LOCATION,
								PROCESS_DATE,
								SPECT_VAR_ID,			
								LOT_NO
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
									PROCESS_DATE
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
			</cfloop>
		</cfif>
		<cfscript>
			basket_kur_ekle(action_id:MAX_ID.IDENTITYCOL,table_type_id:2,process_type:0);
		</cfscript>	
		<cfif len(get_process_type.action_file_name)> <!--- secilen islem kategorisine bir action file eklenmisse --->
			<cf_workcube_process_cat 
				process_cat="#form.process_cat#"
				action_id = #MAX_ID.IDENTITYCOL#
				is_action_file = 1
				action_file_name='#get_process_type.action_file_name#'
				action_db_type = '#dsn2#'
				is_template_action_file = '#get_process_type.action_file_from_template#'>
		</cfif>
	</cftransaction>
</cflock>
<cfif isdefined("attributes.is_popup")>
<!--- tekli serviste buraya girer --->
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
				alert("<cf_get_lang no ='332.İrsaliye Kaydedildi! Ancak Seri No Çıkış Kayıdı Bulunduğu İçin Seri Kaydı Yapılamadı'>!");
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
	<!--- seriye otomatik kayit atma olayi --->
</cfif>
<cfif len(attributes.paper_number)>
	<cfquery name="UPD_PAPERS" datasource="#DSN3#">
		UPDATE PAPERS_NO SET SHIP_NUMBER = #attributes.paper_number# WHERE EMPLOYEE_ID = #session.ep.userid#
	</cfquery>
</cfif>

<script type="text/javascript">
	<cfif isdefined("attributes.is_popup")>
		document.location.href = '<cfoutput>#request.self#?fuseaction=service.popup_upd_sale_ship&ship_id=#MAX_ID.IDENTITYCOL#&service_id=#attributes.service_id#</cfoutput>';
	<cfelse>
		<cfif get_module_user(13)>
			document.location.href = '<cfoutput>#request.self#?fuseaction=stock.form_add_sale&event=upd&ship_id=#MAX_ID.IDENTITYCOL#</cfoutput>';
		<cfelse>
			alert("<cf_get_lang no ='333.İrsaliye Başarıyla Oluşturuldu'>!");
			document.location.href = '<cfoutput>#request.self#?fuseaction=service.service_ship</cfoutput>';
		</cfif>
	</cfif>
</script>
