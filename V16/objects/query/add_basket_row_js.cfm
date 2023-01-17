<!---search_process_date : Bu degisken anlasmalarin bu tarihe uygunlugunu kontrol icindir.. 16082004 abt --->
<script language="javascript" type="text/javascript" src="/JS/js_functions.js"></script>
<cfif isdefined("attributes.search_process_date") and isdate(attributes.search_process_date)>
	<cf_date tarih='attributes.search_process_date'>
</cfif>
<cfif isdefined("session_base")>
	<cfset money_currency = session_base.MONEY>
<cfelse>
	<cfset money_currency = "">
</cfif>
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department_name" default="">
<cfparam name="attributes.is_basket_zero_stock" default="0">
<cfparam name="flt_price" default="0">
<cfparam name="attributes.str_money_currency" default="#money_currency#">
<cfparam name="attributes.is_cost" default="0"> <!--- maliyet secili degil --->
<cfset is_multiple_price_flag = 0>
<cfset kontrol_discount = 0>
<cfif not (isdefined('attributes.amount_multiplier') and len(attributes.amount_multiplier))>
	<cfset attributes.amount_multiplier=1>
</cfif>
<cfif not isdefined('attributes.flt_price_other_amount') or not len(attributes.flt_price_other_amount)><!--- Attributes den gelen değer boş olduğunda param dakini görmüyordu ve çakıyordu. Biz de bu kontrolü ekledik. AE - SM 20070731 --->
	<cfset flt_price_other_amount = 0>
</cfif>
<cfif session_base.period_year gte 2009 and attributes.str_money_currency is 'YTL'>
	<cfset attributes.YTL = 1>
<cfelseif session_base.period_year lt 2009 and attributes.str_money_currency is 'TL'>
	<cfset attributes.TL = 1>
</cfif>
<cfset use_other_discounts=1> <!--- use_other_discounts eq 1 ise proje baglantıları haricindeki iskontolar kullanılır--->
<cfquery name="get_product_all_multip" datasource="#dsn3#">
	SELECT
		PRODUCT_UNIT.MULTIPLIER,PRODUCT_UNIT.ADD_UNIT,PRODUCT_UNIT.PRODUCT_UNIT_ID,
		PRODUCT.IS_COST,
		PRODUCT.IS_ZERO_STOCK,
		PRODUCT.IS_KARMA,
		PRODUCT.IS_KARMA_SEVK,
		PRODUCT.PRODUCT_CODE_2
	FROM
		PRODUCT_UNIT,PRODUCT
	WHERE
		PRODUCT_UNIT.PRODUCT_ID=PRODUCT.PRODUCT_ID AND
		PRODUCT_UNIT.PRODUCT_ID=#attributes.product_id#
</cfquery>
<cfif isdefined("attributes.basket_id") and len(attributes.basket_id)><!--- 80422 ID'lin işte düzenleme yapılacak. Şimdilik kontrol eklendi. EY20140804  --->
	<cfquery name="get_amount_status" datasource="#dsn3#">
		SELECT IS_SELECTED FROM SETUP_BASKET_ROWS WHERE TITLE='is_use_add_unit' AND BASKET_ID = #attributes.basket_id#
	</cfquery>
	<cfquery name="get_amount_rnd" datasource="#dsn3#">
		SELECT AMOUNT_ROUND FROM SETUP_BASKET WHERE BASKET_ID = #attributes.basket_id#
	</cfquery>
	<cfif not (isdefined("attributes.unit_other") and len(attributes.unit_other))>
		<cfquery name="get_product_unit_2" datasource="#dsn3#">
			SELECT ADD_UNIT,MULTIPLIER FROM PRODUCT_UNIT WHERE PRODUCT_UNIT.PRODUCT_ID=#attributes.product_id# AND IS_ADD_UNIT = 1
		</cfquery>
		<cfif get_product_unit_2.recordcount>
			<cfset attributes.unit_other = get_product_unit_2.add_unit>
			<cfif isdefined("attributes.amount_multiplier") and len(attributes.amount_multiplier) and isnumeric(replace(attributes.amount_multiplier,",","."))>
				<cfif isdefined("attributes.multi_row") and len(attributes.multi_row)>
					<cfset attributes.amount_other = 1>
				<cfelseif isdefined("attributes.number") and attributes.number eq 3>
					<cfset attributes.amount_other = 1>
				<cfelse>
					<cfset attributes.amount_other = attributes.amount*replace(attributes.amount_multiplier,",",".")/get_product_unit_2.multiplier>
				</cfif>
			<cfelse>
				<cfif isdefined("attributes.number") and attributes.number eq 3>
					<cfset attributes.amount_other = 1>
				<cfelse>
					<cfset attributes.amount_other = attributes.amount/get_product_unit_2.multiplier>
				</cfif>
			</cfif> 
			<cfset attributes.amount_other ="#filterNum(tlformat(attributes.amount_other,get_amount_rnd.AMOUNT_ROUND,false),get_amount_rnd.AMOUNT_ROUND)#">
		</cfif>
	</cfif>
</cfif>
<cfquery name="get_stock_info" datasource="#dsn3#">
	SELECT
		STOCK_CODE_2
	FROM
		STOCKS
	WHERE
		STOCK_ID=#attributes.stock_id#
</cfquery>
<cfset stock_code_2_ = Replace(get_stock_info.STOCK_CODE_2,"'","")>
<cfif not isdefined("attributes.satir") or (isdefined("attributes.satir") and not len(attributes.satir))>
	<cfset attributes.satir = -1>
</cfif>
<cfif get_product_all_multip.IS_KARMA eq 1 and get_product_all_multip.IS_KARMA_SEVK eq 1> <!--- urun karmakoli ise --->
	<cfinclude template="add_basket_karma_product_row_js.cfm">
	<script><cfif isdefined("attributes.from_product_config")>
		<cfset specer_return_value_list = isdefined("attributes.specer_return_value_list") ? attributes.specer_return_value_list : specer_return_value_list><cfoutput>
		spec_last_row=window.basket.items.length-1;
		updateBasketItemFromPopup(spec_last_row, 
		{ 
			SPECT_ID: '#listgetat(specer_return_value_list,2,',')#', 
			SPECT_NAME: '#new_spect_var_name#' 
			<cfif isdefined("attributes.is_price_change") and attributes.is_price_change eq 1>
				,PRICE: <cfif listgetat(specer_return_value_list,4,',') gt 0>#listgetat(specer_return_value_list,4,',')#<cfelse>0</cfif>
				,PRICE_OTHER: <cfif listgetat(specer_return_value_list,5,',') gt 0>#listgetat(specer_return_value_list,5,',')#<cfelse>0</cfif>
				,OTHER_MONEY: '<cfif len(listgetat(specer_return_value_list,6,','))>#listgetat(specer_return_value_list,6,',')#<cfelse>#session.ep.money#</cfif>'
				,NET_MALIYET: #listgetat(specer_return_value_list,9,',')#
			</cfif>  
		}); </cfoutput>
		closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');</cfif>
	<cfabort>
<cfelse>
	<cfif get_product_all_multip.IS_KARMA eq 1 and get_product_all_multip.IS_KARMA_SEVK neq 1>
        <cfquery name="GET_KARMA_PRODUCT" datasource="#dsn1#">
            SELECT 
                KP.SPEC_MAIN_ID,
                <cfif is_sale_product eq 1>	KP.TAX	<cfelse>KP.TAX_PURCHASE AS TAX</cfif>,
                KP.KARMA_PRODUCT_ID,
                KP.STOCK_ID,
                KP.PRODUCT_ID,
                KP.PRODUCT_UNIT_ID,
                KP.PRODUCT_AMOUNT,
                KP.SALES_PRICE,
                KP.OTHER_LIST_PRICE,
                KP.ENTRY_ID,
                <cfif session.ep.period_year lt 2009>
                    CASE WHEN KP.MONEY ='TL' THEN '<cfoutput>#session.ep.money#</cfoutput>' ELSE KP.MONEY END AS MONEY
                <cfelseif session.ep.period_year gte 2009>
                    CASE WHEN KP.MONEY ='YTL' THEN '<cfoutput>#session.ep.money#</cfoutput>' ELSE KP.MONEY END AS MONEY
                <cfelse>
                    KARMA_PRODUCTS.MONEY
                </cfif> 
            FROM 
                KARMA_PRODUCTS KP
            WHERE 
                KP.KARMA_PRODUCT_ID = #attributes.product_id#
            ORDER BY 
                ENTRY_ID
        </cfquery>
        <cfif not GET_KARMA_PRODUCT.recordcount>
            <script type="text/javascript">
                alert("Karma Koli İçeriğine Ürün Tanımlamalısınız!");
                window.close();
            </script>
        </cfif>
    </cfif>
	<cfif attributes.is_basket_zero_stock neq 1 and get_product_all_multip.IS_ZERO_STOCK eq 0 and attributes.is_sale_product eq 1 and ( (isdefined('attributes.is_chck_dept_based_stock') and attributes.is_chck_dept_based_stock eq 1) or (session_base.our_company_info.workcube_sector is 'it' and ( (isdefined("attributes.sepet_process_type") and listfind('52,53,62,81,85,86,111,112,113',attributes.sepet_process_type)) or (isdefined("attributes.int_basket_id") and listfind('10,21,48',attributes.int_basket_id)) ) ) )>
	<!--- // it sektoru icin urunun seçilen çıkış depodaki stogu kontrol ediliyor, lokasyondaki stogu 0 veya negatif ise ve urune sıfır stok ile çalıs secilmemişse baskete eklenmez. --->
		<cfif isdefined("attributes.amount_multiplier") and len(attributes.amount_multiplier) and isnumeric(replace(attributes.amount_multiplier,",","."))>
			<cfset urun_miktar= attributes.amount* replace(attributes.amount_multiplier,",",".")>
		<cfelse>
			<cfset urun_miktar = attributes.amount>
		</cfif>
		<cfif (isdefined('attributes.department_out') and len(attributes.department_out) and isdefined('attributes.location_out') and len(attributes.location_out)) or (isdefined('attributes.departmen_location_info') and len(attributes.departmen_location_info)) >
			<cfquery name="STOCK_LOCATION_AMOUNT" datasource="#dsn2#">
				SELECT
					SUM(SR.STOCK_IN - SR.STOCK_OUT) AS TOTAL_STOCK
				FROM
					#dsn_alias#.STOCKS_LOCATION SL,
					STOCKS_ROW SR
				WHERE
					SR.STORE =SL.DEPARTMENT_ID
					AND SR.STORE_LOCATION=SL.LOCATION_ID
					<cfif isdefined('attributes.departmen_location_info') and len(attributes.departmen_location_info)>
						AND SL.DEPARTMENT_ID = #listfirst(attributes.departmen_location_info,'-')#
						AND SL.LOCATION_ID = #listlast(attributes.departmen_location_info,'-')#
					<cfelse>
						AND SL.DEPARTMENT_ID = #listfirst(attributes.department_out,',')#
						AND SL.LOCATION_ID = #listfirst(attributes.location_out,',')# 
					</cfif>
					AND SR.STOCK_ID=#attributes.stock_id#
					<cfif isdefined('attributes.spec_id') and len(attributes.spec_id)>
					AND SR.SPECT_VAR_ID=#attributes.spec_id#
					</cfif>
                    <cfif attributes.is_basket_zero_stock_control_date eq 1 and len(attributes.search_process_date)>
                    	AND SR.PROCESS_DATE <= #attributes.search_process_date#
                    </cfif>
			</cfquery>
			<cfif STOCK_LOCATION_AMOUNT.TOTAL_STOCK lte 0 or STOCK_LOCATION_AMOUNT.TOTAL_STOCK lt urun_miktar>
				<script type="text/javascript">
					alert("Bu Ürün Seçtiğiniz Çıkış Lokasyonunda Yeterli Miktarda Bulunmadığı için Baskete Eklenmeyecektir.");
					<cfif not (isdefined('attributes.from_add_barcod') and attributes.from_add_barcod eq 1)>
						history.back();
					</cfif>
				</script>
				<cfabort>
			</cfif>
		</cfif>
	</cfif>
	<cfif isdefined('attributes.xml_use_other_dept_info_ss') and listlen(attributes.xml_use_other_dept_info_ss,'-') eq 2><!--XML'e bağlı Satılabilir Stok Miktarı Listelenecek Depo-Lokasyon ERU-->
		<cfif isdefined("attributes.amount_multiplier") and len(attributes.amount_multiplier) and isnumeric(replace(attributes.amount_multiplier,",","."))>
			<cfset urun_miktar= attributes.amount* replace(attributes.amount_multiplier,",",".")>
		<cfelse>
			<cfset urun_miktar = attributes.amount>
		</cfif>
		<cfset getComponent = createObject('component','V16.objects.cfc.get_stock_detail')><!--- siparisler stoktan dusulecek veya eklenecekse toplamını alalım--->
		<cfset GET_STOCK_RESERVED = getComponent.GET_STOCK_RESERVED(xml_use_other_dept_info_ss : xml_use_other_dept_info_ss, product_id_list : product_id)>
		<cfset SCRAP_LOCATION_TOTAL_STOCK = getComponent.SCRAP_LOCATION_TOTAL_STOCK(xml_use_other_dept_info_ss : xml_use_other_dept_info_ss, product_id_list : product_id)>
		<cfset PRODUCT_TOTAL_STOCK = getComponent.PRODUCT_TOTAL_STOCK(xml_use_other_dept_info_ss : xml_use_other_dept_info_ss, product_id_list : product_id)>
		<cfset GET_PROD_RESERVED_ = getComponent.GET_PROD_RESERVED_(xml_use_other_dept_info_ss : xml_use_other_dept_info_ss, product_id_list : product_id)>
		<cfset location_based_total_stock = getComponent.location_based_total_stock(xml_use_other_dept_info_ss : xml_use_other_dept_info_ss, product_id_list : product_id)>
		<cfif product_total_stock.recordcount and len(product_total_stock.product_total_stock)>
			<cfset product_stocks = product_total_stock.product_total_stock>
		<cfelse>
			<cfset product_stocks = 0>
		</cfif>
		<cfif scrap_location_total_stock.recordcount and len(scrap_location_total_stock.total_scrap_stock) and scrap_location_total_stock.total_scrap_stock gt 0>
			<cfset product_stocks = product_stocks - scrap_location_total_stock.total_scrap_stock><cfset a = "#scrap_location_total_stock.total_scrap_stock#">
		</cfif>
		<cfif get_stock_reserved.recordcount and len(get_stock_reserved.artan)>
			<cfset product_stocks = product_stocks + get_stock_reserved.artan><cfset b = "#get_stock_reserved.artan#">
		</cfif>
		<cfif get_stock_reserved.recordcount and len(get_stock_reserved.azalan)>
			<cfset product_stocks = product_stocks - get_stock_reserved.azalan><cfset c= "#get_stock_reserved.azalan#">
		</cfif>
		<cfif get_prod_reserved_.recordcount>
			<cfif len(get_prod_reserved_.azalan)>
				<cfset product_stocks = product_stocks - get_prod_reserved_.azalan><cfset d= "#get_prod_reserved_.azalan#">
			</cfif>
			<cfif len(get_prod_reserved_.artan)>
				<cfset product_stocks = product_stocks + get_prod_reserved_.artan><cfset e= "#get_prod_reserved_.artan#">
			</cfif>
		</cfif>
		<cfif location_based_total_stock.recordcount and len(location_based_total_stock.total_location_stock)>
			<cfset product_stocks = product_stocks - location_based_total_stock.total_location_stock><cfset f= "#location_based_total_stock.total_location_stock#">
		</cfif>
		<cfif isdefined("product_stocks") and len(product_stocks)>
			<cfif (product_stocks lte 0 or product_stocks lt urun_miktar) and (attributes.is_basket_zero_stock eq 0 and get_product_all_multip.IS_ZERO_STOCK eq 0)>
				<script type="text/javascript">
					alert("Bu Ürün Seçtiğiniz Çıkış Lokasyonunda Yeterli Miktarda Bulunmadığı için Baskete Eklenmeyecektir.");
					<cfif not (isdefined('attributes.from_add_barcod') and attributes.from_add_barcod eq 1)>
						history.back();
					</cfif>
				</script>
				<cfabort>
			</cfif>
		</cfif>
	</cfif>	
	<!--- Eger Urun UNIT bos gelmis ise..  --->
	<cfif not len(attributes.unit_multiplier)>
		<cfquery name="get_multip" dbtype="query">
			SELECT MULTIPLIER,ADD_UNIT FROM get_product_all_multip WHERE PRODUCT_UNIT_ID=#attributes.UNIT_ID#
		</cfquery>
		<cfset page_unit = get_multip.ADD_UNIT>
		<cfset page_unit_multiplier = get_multip.MULTIPLIER>
	<cfelse>
		<cfset page_unit = attributes.unit>
		<cfset page_unit_multiplier = attributes.unit_multiplier>
	</cfif>
	<cfif len(attributes.unit_id)>
		<cfquery name="get_weight" datasource="#DSN3#">
			SELECT VOLUME,WEIGHT FROM PRODUCT_UNIT WHERE PRODUCT_UNIT_ID=#attributes.UNIT_ID#
		</cfquery>
	</cfif>
	<!--- /// Eger Urun UNIT bos gelmis ise..  --->
	<cfif isdefined("attributes.from_price_page") and attributes.from_price_page eq 1>
		<cfif len(attributes.flt_price_other_amount) and isnumeric(attributes.flt_price_other_amount)>
			<cfset flt_price_other_amount = attributes.flt_price_other_amount>
			<cfif attributes.str_money_currency eq money_currency>
				<cfset flt_price = attributes.flt_price_other_amount>
			<cfelse>
				<cfif isdefined("attributes.#attributes.str_money_currency#")>
					<cfset flt_price = attributes.flt_price_other_amount * evaluate("attributes.#attributes.str_money_currency#")>
				<cfelse>
					<script type="text/javascript">
						//alert('<cfoutput>#attributes.str_money_currency#</cfoutput>');
						alert("Ürün İçin Seçtiğiniz Fiyatın Para Birimi Tanımlı Değil.Para Birimi Tanımlarınızı Kontrol Ediniz!");
						history.back();
					</script>
					<cfabort>
				</cfif>
			</cfif>
		</cfif>
	<cfelse>
		<!--- urun standart fiyati--->
		<cfquery name="get_price" datasource="#dsn3#" maxrows="1">
			SELECT
				PRICE,MONEY
			FROM
				PRICE_STANDART
			WHERE
				PRODUCT_ID = #attributes.product_id# AND
				UNIT_ID = #attributes.unit_id#
			<cfif is_sale_product eq 1>
				AND PURCHASESALES = 1
			<cfelse>
				AND PURCHASESALES = 0
			</cfif>
			<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
				AND START_DATE < #DATEADD('d',1,attributes.search_process_date)#
			<cfelse>
				AND PRICESTANDART_STATUS = 1
			</cfif>
			ORDER BY
				START_DATE DESC,
				RECORD_DATE DESC
		</cfquery>
		<cfif not get_price.recordcount>
			<cfquery name="get_price" datasource="#dsn3#" maxrows="1">
				SELECT
					PS.PRICE,
					PS.MONEY
				FROM
					PRICE_STANDART AS PS,
					PRODUCT_UNIT AS PU
				WHERE
					PS.PRODUCT_ID = #attributes.product_id# AND
					PU.PRODUCT_ID = #attributes.product_id# AND
					PU.IS_MAIN = 1
				<cfif is_sale_product eq 1>
					AND PS.PURCHASESALES = 1
				<cfelse>
					AND PS.PURCHASESALES = 0
				</cfif>
				<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
					AND PS.START_DATE < #DATEADD('d',1,attributes.search_process_date)#
				<cfelse>
					AND PS.PRICESTANDART_STATUS = 1
				</cfif>
					AND PS.UNIT_ID = PU.PRODUCT_UNIT_ID
				ORDER BY
					PS.START_DATE DESC,
					PS.RECORD_DATE DESC
			</cfquery>
			<cfset is_multiple_price_flag = 1>
		</cfif>
		<cfif len(get_price.PRICE) and isnumeric(get_price.PRICE)>
			<cfset attributes.str_money_currency = get_price.MONEY>
			<cfif session_base.period_year gte 2009 and attributes.str_money_currency is 'YTL'>
				<cfset attributes.YTL = 1>
			<cfelseif session_base.period_year lt 2009 and attributes.str_money_currency is 'TL'>
				<cfset attributes.TL = 1>
			</cfif>
			<cfset flt_price_other_amount = get_price.PRICE>
			<cfif attributes.str_money_currency eq money_currency>
				<cfset flt_price = get_price.PRICE>
			<cfelseif isdefined("attributes.#attributes.str_money_currency#")>
				<cfset flt_price = get_price.PRICE * evaluate("attributes.#attributes.str_money_currency#")>
			<cfelse>
				<cfset flt_price = get_price.PRICE>
			</cfif>
		</cfif>
	</cfif>
	<!--- minimum stok hesaplanmasi  SİPARİS SAYFASİNDA YAPMAK GEREKİYOR SADECE ABT 24032004--->
	<cfif (isdefined("attributes.basket_id") and attributes.basket_id eq 6) or (isdefined("attributes.int_basket_id") and attributes.int_basket_id eq 6)>
		<cfquery name="get_minimum_order" datasource="#dsn3#">
			SELECT MINIMUM_ORDER_UNIT_ID,MINIMUM_ORDER_STOCK_VALUE FROM STOCK_STRATEGY WHERE STOCK_ID =#attributes.stock_id# AND ISNULL(DEPARTMENT_ID,0)=0
		</cfquery>
		<cfif len(get_minimum_order.MINIMUM_ORDER_UNIT_ID) and len(get_minimum_order.MINIMUM_ORDER_STOCK_VALUE)>
			<cfif (attributes.unit_id eq get_minimum_order.MINIMUM_ORDER_UNIT_ID)>
				<cfif attributes.amount_multiplier gte get_minimum_order.MINIMUM_ORDER_STOCK_VALUE>
					<cfset flt_miktar = attributes.amount_multiplier>
				<cfelse>
					<cfset flt_miktar = get_minimum_order.MINIMUM_ORDER_STOCK_VALUE>
				</cfif>
			<cfelse>
				<cfquery name="get_strategy_unit" dbtype="query">
					SELECT MULTIPLIER,ADD_UNIT FROM get_product_all_multip WHERE PRODUCT_UNIT_ID=#get_minimum_order.MINIMUM_ORDER_UNIT_ID#
				</cfquery>
				<cfif len(get_strategy_unit.MULTIPLIER) and len(get_minimum_order.MINIMUM_ORDER_STOCK_VALUE)>
					<cfif (attributes.amount_multiplier * attributes.amount) gte (get_strategy_unit.MULTIPLIER * get_minimum_order.MINIMUM_ORDER_STOCK_VALUE)>
						<cfset flt_miktar = attributes.amount_multiplier>
					<cfelse>
						<cfset flt_miktar =(get_strategy_unit.MULTIPLIER * get_minimum_order.MINIMUM_ORDER_STOCK_VALUE)/attributes.amount>
					</cfif>
				<cfelse>
					<cfset flt_miktar = attributes.amount_multiplier>
				</cfif>
			</cfif>
		<cfelse>
			<cfset flt_miktar = attributes.amount_multiplier>
		</cfif>
	<cfelse>
		<cfset flt_miktar = 1>
	</cfif><!--- // minimum stok hesaplamasi --->
	<cfif is_multiple_price_flag>
		<cfset flt_price = flt_price * page_unit_multiplier>
		<cfset flt_price_other_amount = flt_price_other_amount * page_unit_multiplier>
	</cfif>
	<!--- //urun standart fiyati --->
	
	<!--- indirimler ayarlanır --->
	<cfscript>
		// indirimler default 0
		if(not isdefined("d1"))
			d1 = 0;
		if(not isdefined("d2"))
			d2 = 0;
		if(not isdefined("d3"))
			d3 = 0;
		if(not isdefined("d4"))
			d4 = 0;
		if(not isdefined("d5"))
			d5 = 0;
		if(not isdefined("d6"))
			d6 = 0;
		d7 = 0;
		d8 = 0;
		d9 = 0;
		d10= 0;
		disc_amount = 0;
	</cfscript>
	<cfif is_sale_product eq 0><!--- sadece alis islemleri icin gelmeli --->
	  <cfif not(isdefined("attributes.sepet_process_type") and attributes.sepet_process_type eq 62)><!--- Alim iade faturasindaki aksiyon ozel durumu icin BK 20050725--->
		<cfquery name="get_aksiyons" datasource="#dsn3#" maxrows="1">
			SELECT
				CPP.DISCOUNT1,
				CPP.DISCOUNT2,
				CPP.DISCOUNT3,
				CPP.DISCOUNT4,
				CPP.DISCOUNT5,
				CPP.DISCOUNT6,
				CPP.DISCOUNT7,
				CPP.DISCOUNT8,
				CPP.DISCOUNT9,
				CPP.DISCOUNT10,
				CPP.PURCHASE_PRICE,
				CPP.MONEY
			FROM
				CATALOG_PROMOTION AS CP,
				CATALOG_PROMOTION_PRODUCTS AS CPP
				<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				,CATALOG_PRICE_LISTS CPL
				,PRICE_CAT PCAT
				</cfif>
			WHERE
				CP.CATALOG_STATUS = 1 AND 
				CPP.PRODUCT_ID = #attributes.product_id# AND
				(CP.IS_APPLIED = 1 <cfif (isdefined("attributes.basket_id") and attributes.basket_id eq 6) or (isdefined("attributes.int_basket_id") and attributes.int_basket_id eq 6)> OR CP.STAGE_ID = -2</cfif>) AND
			<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
				CP.KONDUSYON_DATE <= #attributes.search_process_date# AND
				CP.KONDUSYON_FINISH_DATE > #attributes.search_process_date# AND
			<cfelse>
				CP.KONDUSYON_DATE <= #now()# AND
				CP.KONDUSYON_FINISH_DATE > #now()# AND
			</cfif>
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
				CPL.CATALOG_PROMOTION_ID = CP.CATALOG_ID AND
				CPL.PRICE_LIST_ID = PCAT.PRICE_CATID AND
				PCAT.BRANCH LIKE '%,#attributes.branch_id#,%' AND
			</cfif>
				<!--- CP.BRANCH LIKE ',#attributes.branch_id#,' AND --->
				CPP.CATALOG_ID = CP.CATALOG_ID
			ORDER BY
				CP.CATALOG_ID DESC
		</cfquery>
		<cfscript>// indirimler aksiyon varsa 
			if(get_aksiyons.recordcount){
				flt_price = get_aksiyons.PURCHASE_PRICE;
				flt_price_other_amount = get_aksiyons.PURCHASE_PRICE;
				d1 = get_aksiyons.discount1;
				d2 = get_aksiyons.discount2;
				d3 = get_aksiyons.discount3;
				d4 = get_aksiyons.discount4;
				d5 = get_aksiyons.discount5;
				d6 = get_aksiyons.discount6;
				d7 = get_aksiyons.discount7;
				d8 = get_aksiyons.discount8;
				d9 = get_aksiyons.discount9;
				d10 = get_aksiyons.discount10;
				if (get_aksiyons.MONEY neq money_currency)
					flt_price = flt_price * evaluate("attributes.#attributes.str_money_currency#");
				flt_price = flt_price * page_unit_multiplier;
				
				flt_price_other_amount = flt_price_other_amount * page_unit_multiplier;
			}
		</cfscript>
		<cfelse>
			<cfset get_aksiyons.recordcount =0>
		</cfif>
		<cfif (not get_aksiyons.recordcount) and ( (isdefined("attributes.company_id") and len(attributes.company_id)) or (isdefined("attributes.basket_id") and (attributes.basket_id eq 31 or attributes.basket_id eq 32) ) )>
			<cfif isdefined('attributes.use_general_price_cat_exceptions') and attributes.use_general_price_cat_exceptions eq 1><!--- XMLE BAglı calısıyor , genel iskontolar--->
				<cfquery name="get_general_discounts" datasource="#dsn3#" maxrows="1">
					SELECT
						*
					FROM 
						PRICE_CAT_EXCEPTIONS
					WHERE
						((ISNULL(IS_GENERAL,0)=1 AND ACT_TYPE = 3) OR (ISNULL(IS_GENERAL,0)=0 AND ACT_TYPE = 1))
						AND CONTRACT_ID IS NULL
						AND (SUPPLIER_ID IS NULL OR SUPPLIER_ID = (SELECT COMPANY_ID FROM STOCKS WHERE STOCK_ID=#attributes.stock_id#))
						AND (PRODUCT_ID IS NULL OR PRODUCT_ID=#attributes.product_id#)
						AND (BRAND_ID IS NULL OR BRAND_ID=(SELECT BRAND_ID FROM STOCKS WHERE STOCK_ID=#attributes.stock_id#))
						AND (PRODUCT_CATID IS NULL OR PRODUCT_CATID=(SELECT PRODUCT_CATID FROM STOCKS WHERE STOCK_ID=#attributes.stock_id#))
						AND (SHORT_CODE_ID IS NULL OR SHORT_CODE_ID=(SELECT SHORT_CODE_ID FROM STOCKS WHERE STOCK_ID=#attributes.stock_id#))
						<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
							AND (COMPANYCAT_ID IS NULL OR COMPANYCAT_ID = (SELECT COMPANYCAT_ID FROM #dsn_alias#.COMPANY WHERE COMPANY_ID=#attributes.company_id#))
						</cfif>
						<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
							AND	(COMPANY_ID=#attributes.company_id# OR (CONSUMER_ID IS NULL AND COMPANY_ID IS NULL))
						<cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
							AND (CONSUMER_ID=#attributes.consumer_id# OR (CONSUMER_ID IS NULL AND COMPANY_ID IS NULL))
						</cfif>
						<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)> <!--- fiyat listesi secilmemisse standart alıs fiyatından kontrol eder --->
							AND PRICE_CATID=#attributes.price_catid#
						<cfelse>
							AND PRICE_CATID=-1
						</cfif>
					ORDER BY PRODUCT_ID DESC,BRAND_ID DESC,PRODUCT_CATID DESC,SUPPLIER_ID DESC,COMPANYCAT_ID DESC,SHORT_CODE_ID DESC
				</cfquery>
				<cfif get_general_discounts.recordcount neq 0 and len(get_general_discounts.DISCOUNT_RATE)>
					<cfset kontrol_discount = 1>
					<cfset d1 = get_general_discounts.DISCOUNT_RATE>
				</cfif>
				<cfif get_general_discounts.recordcount neq 0 and len(get_general_discounts.DISCOUNT_RATE_2)>
					<cfset kontrol_discount = 1>
					<cfset d2 = get_general_discounts.DISCOUNT_RATE_2>
				</cfif>
				<cfif get_general_discounts.recordcount neq 0 and len(get_general_discounts.DISCOUNT_RATE_3)>
					<cfset kontrol_discount = 1>
					<cfset d3 = get_general_discounts.DISCOUNT_RATE_3>
				</cfif>
				<cfif get_general_discounts.recordcount neq 0 and len(get_general_discounts.DISCOUNT_RATE_4)>
					<cfset kontrol_discount = 1>
					<cfset d4 = get_general_discounts.DISCOUNT_RATE_4>
				</cfif>
				<cfif get_general_discounts.recordcount neq 0 and len(get_general_discounts.DISCOUNT_RATE_5)>
					<cfset kontrol_discount = 1>
					<cfset d5 = get_general_discounts.DISCOUNT_RATE_5>
				</cfif>
			<cfelse>
				<cfset get_general_discounts.recordcount=0>
			</cfif>
			<cfif get_general_discounts.recordcount eq 0 and isdefined('attributes.use_project_discounts') and attributes.use_project_discounts eq 1  and isdefined('attributes.project_id') and len(attributes.project_id)><!--- XMLE BAglı calısıyor , proje iskontoları--->
				<cfquery name="get_project_discounts" datasource="#dsn3#">
					SELECT
						PD.DISCOUNT_1,PD.DISCOUNT_2,PD.DISCOUNT_3,PD.DISCOUNT_4,PD.DISCOUNT_5,ISNULL(PD.IS_CHECK_PRJ_PRODUCT,0) IS_CHECK_PRJ_PRODUCT,PD.PRO_DISCOUNT_ID,
						PDC.BRAND_ID,PDC.PRODUCT_CATID,PDC.PRODUCT_ID
					FROM 
						PROJECT_DISCOUNTS PD,
						PROJECT_DISCOUNT_CONDITIONS PDC
					WHERE
						PD.PRO_DISCOUNT_ID=PDC.PRO_DISCOUNT_ID
						AND PD.PROJECT_ID=#attributes.project_id#
						<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
							AND (PD.IS_CHECK_PRJ_MEMBER=0 OR PD.COMPANY_ID=#attributes.company_id#)
						<cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
							AND (PD.IS_CHECK_PRJ_MEMBER=0 OR PD.CONSUMER_ID=#attributes.consumer_id#)
						</cfif>
						<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
							AND PD.START_DATE <= #attributes.search_process_date#
							AND PD.FINISH_DATE >= #attributes.search_process_date#
						<cfelse>
							AND PD.START_DATE <= #now()#
							AND PD.FINISH_DATE >= #now()#
						</cfif>
						<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)> <!--- fiyat listesi secilmemisse standart alıs fiyatından kontrol eder --->
							AND (PD.IS_CHECK_PRJ_PRICE_CAT=0 OR PD.PRICE_CATID=#attributes.price_catid#)
						<cfelse>
							AND (PD.IS_CHECK_PRJ_PRICE_CAT=0 OR PD.PRICE_CATID=-1)
						</cfif>
					ORDER BY PRODUCT_ID DESC,BRAND_ID DESC,PRODUCT_CATID DESC
				</cfquery>
				<cfif get_project_discounts.recordcount and get_project_discounts.IS_CHECK_PRJ_PRODUCT eq 1>
					<cfset prj_prod_list_=listsort(valuelist(get_project_discounts.PRODUCT_ID),'numeric','asc')>
					<cfset prj_brand_list_=listsort(valuelist(get_project_discounts.BRAND_ID),'numeric','asc')>
					<cfset prj_prod_cat_list=listsort(valuelist(get_project_discounts.PRODUCT_CATID),'numeric','asc')>
					<cfquery name="get_project_prods" datasource="#dsn3#">
						SELECT
							PRODUCT_ID,PRODUCT_NAME
						FROM
							PRODUCT
						WHERE
							PRODUCT_ID=#attributes.product_id#
							<cfif len(prj_brand_list_)>
							AND ISNULL(BRAND_ID,0) IN (#prj_brand_list_#)
							</cfif>
							<cfif len(prj_prod_cat_list)>
							AND ISNULL(PRODUCT_CATID,0) IN (#prj_prod_cat_list#) 
							</cfif>
							<cfif len(prj_prod_list_)>
							AND PRODUCT_ID IN (#prj_prod_list_#) 
							</cfif>
					</cfquery>
				</cfif>
				<cfif get_project_discounts.recordcount neq 0 and ( (get_project_discounts.IS_CHECK_PRJ_PRODUCT eq 0) or (get_project_discounts.IS_CHECK_PRJ_PRODUCT eq 1 and get_project_prods.recordcount neq 0) )>
					<cfset use_other_discounts=0> <!--- proje iskontoları kullanılacak --->
					<cfscript>
						d1 = get_project_discounts.DISCOUNT_1;
						d2 = get_project_discounts.DISCOUNT_2;
						d3 = get_project_discounts.DISCOUNT_3;
						d4 = get_project_discounts.DISCOUNT_4;
						d5 = get_project_discounts.DISCOUNT_5;
					</cfscript>
					<cfset use_other_discounts=0>
				<cfelse>
					<script type="text/javascript">
						alert('Ürün Proje Bağlantısı Kapsamında Olmadığından Sepete Eklenmeyecektir!');
						<cfif not (isdefined('attributes.from_add_barcod') and attributes.from_add_barcod eq 1) and not (isdefined("multi") and multi neq 0)>
							if (<cfoutput>#update_product_row_id#</cfoutput> == 0)
								window.history.back();
							else
								window.close();
						</cfif>
					</script>
					<cfabort>
				</cfif>
			<cfelse>
				<cfset get_project_discounts.recordcount=0>
			</cfif>
			<cfif use_other_discounts eq 1><!--- genel iskonto kosulu yoksa (istisnai fiyat listlerinden tanımlanan) --->
				<cfquery name="get_contracts" datasource="#dsn3#" maxrows="1">
					SELECT
						DISCOUNT1,
						DISCOUNT2,
						DISCOUNT3,
						DISCOUNT4,
						DISCOUNT5,
						DISCOUNT_CASH,
						DISCOUNT_CASH_MONEY
					FROM
						CONTRACT_PURCHASE_PROD_DISCOUNT
					WHERE
						PRODUCT_ID = #attributes.product_id# AND
					<cfif isdefined('attributes.use_paymethod_for_prod_conditions') and attributes.use_paymethod_for_prod_conditions eq 1><!--- xmlde urun kosulları odeme yontemine gore calısır secilmisse --->
						<cfif isdefined('attributes.paymethod_id') and len(attributes.paymethod_id)><!--- xmlde urun kosulları odeme yontemine gore calısır secilmisse ve islem detayda odeme yontemi secilmisse --->
							PAYMETHOD_ID=#attributes.paymethod_id# AND
						<cfelse>
							1=2 AND
						</cfif>
					</cfif>
					<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
						COMPANY_ID = #attributes.COMPANY_ID# AND
					</cfif>
					<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
						(
							START_DATE <= #attributes.search_process_date# AND
							( FINISH_DATE >= #attributes.search_process_date# OR FINISH_DATE IS NULL )
						)
					<cfelse>
						START_DATE <= #now()# AND
						FINISH_DATE >= #now()#
					</cfif>
					ORDER BY
						START_DATE DESC,
						RECORD_DATE DESC
				</cfquery>
				<cfif not get_contracts.recordcount>
					<cfquery name="get_contracts" datasource="#dsn3#" maxrows="1">
						SELECT
							DISCOUNT1,
							DISCOUNT2,
							DISCOUNT3,
							DISCOUNT4,
							DISCOUNT5,
							DISCOUNT_CASH,
							DISCOUNT_CASH_MONEY
						FROM
							CONTRACT_PURCHASE_PROD_DISCOUNT
						WHERE
							PRODUCT_ID = #attributes.product_id# AND
						<cfif isdefined('attributes.use_paymethod_for_prod_conditions') and attributes.use_paymethod_for_prod_conditions eq 1><!--- xmlde urun kosulları odeme yontemine gore calısır secilmisse --->
							<cfif isdefined('attributes.paymethod_id') and len(attributes.paymethod_id)><!--- xmlde urun kosulları odeme yontemine gore calısır secilmisse ve islem detayda odeme yontemi secilmisse --->
								PAYMETHOD_ID=#attributes.paymethod_id# AND
							<cfelse>
								1=2 AND
							</cfif>
						</cfif>
							COMPANY_ID IS NULL AND
						<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
							(
								START_DATE <= #attributes.search_process_date# AND
								(FINISH_DATE >= #attributes.search_process_date# OR FINISH_DATE IS NULL)			
							)
						<cfelse>
							START_DATE <= #now()# AND
							FINISH_DATE >= #now()#
						</cfif>
						ORDER BY
							START_DATE DESC,
							RECORD_DATE DESC
					</cfquery>
				</cfif>
				<cfscript>// indirimler anlaşma varsa
					if(get_contracts.recordcount)
					{
						d1 = get_contracts.discount1;
						d2 = get_contracts.discount2;
						d3 = get_contracts.discount3;
						d4 = get_contracts.discount4;
						d5 = get_contracts.discount5;
						if(len(get_contracts.discount_cash))
						{
							if( attributes.str_money_currency is get_contracts.discount_cash_money) //urunun para birimi ile retabe para birimi aynı ise tutar aynen alınır yoksa urun para birimine cevirilir
								disc_amount = get_contracts.discount_cash;
							else
								disc_amount = wrk_round( ( (get_contracts.discount_cash * evaluate("attributes.#get_contracts.discount_cash_money#"))/evaluate("attributes.#attributes.str_money_currency#") ),4);
						}
					}
				</cfscript>
				<cfif IsDefined("attributes.branch_id") and isnumeric(attributes.branch_id)><!--- // indirimler anlaşmada genel indirimler tanımlı ise --->
					<cfquery name="get_c_general_discounts" datasource="#dsn3#" maxrows="5">
						SELECT
							DISCOUNT
						FROM
							CONTRACT_PURCHASE_GENERAL_DISCOUNT AS CPGD,
							CONTRACT_PURCHASE_GENERAL_DISCOUNT_BRANCHES CPGD_B
						WHERE
							CPGD.GENERAL_DISCOUNT_ID = CPGD_B.GENERAL_DISCOUNT_ID
							AND CPGD_B.BRANCH_ID = #attributes.branch_id#
							AND CPGD.COMPANY_ID=#attributes.company_id#
						<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
							AND CPGD.START_DATE <= #attributes.search_process_date#
							AND CPGD.FINISH_DATE >= #attributes.search_process_date#
						<cfelse>
							AND CPGD.START_DATE <= #now()#
							AND CPGD.FINISH_DATE >= #now()#
						</cfif>
						ORDER BY
							CPGD.GENERAL_DISCOUNT_ID
					</cfquery>
					<cfif get_c_general_discounts.recordcount>
						<cfloop query="get_c_general_discounts">
							<cfset 'd#currentrow+5#' = get_c_general_discounts.DISCOUNT>
						</cfloop>
					</cfif>
				</cfif>
			</cfif>
		</cfif>
	<cfelseif is_sale_product eq 1 and isdefined('attributes.int_basket_id') and attributes.int_basket_id neq 51 and attributes.int_basket_id neq 52><!--- Taksitli ürün basketi dışındaki satış basketlerinde gelmeli--->
		<cfif isdefined('attributes.use_general_price_cat_exceptions') and attributes.use_general_price_cat_exceptions eq 1> <!--- genel iskontolar calıssın --->
			<cfquery name="get_general_discounts" datasource="#dsn3#" maxrows="1">
				SELECT
					*
				FROM 
					PRICE_CAT_EXCEPTIONS
					LEFT JOIN PRODUCT_CAT ON PRODUCT_CAT.PRODUCT_CATID = PRICE_CAT_EXCEPTIONS.PRODUCT_CATID
				WHERE
					((ISNULL(IS_GENERAL,0)=1 AND ACT_TYPE = 3) OR (ISNULL(IS_GENERAL,0)=0 AND ACT_TYPE = 1))
					AND CONTRACT_ID IS NULL
					AND (SUPPLIER_ID IS NULL OR SUPPLIER_ID = (SELECT COMPANY_ID FROM STOCKS WHERE STOCK_ID=#attributes.stock_id#))
					AND (PRODUCT_ID IS NULL OR PRODUCT_ID=#attributes.product_id#)
					AND (BRAND_ID IS NULL OR BRAND_ID=(SELECT BRAND_ID FROM STOCKS WHERE STOCK_ID=#attributes.stock_id#))
					AND (
							PRICE_CAT_EXCEPTIONS.PRODUCT_CATID IS NULL OR 
							PRICE_CAT_EXCEPTIONS.PRODUCT_CATID = ( SELECT PRODUCT_CATID FROM STOCKS WHERE STOCK_ID = #attributes.stock_id# ) OR
							(
								SELECT HIERARCHY FROM STOCKS LEFT JOIN PRODUCT_CAT ON STOCKS.PRODUCT_CATID = PRODUCT_CAT.PRODUCT_CATID WHERE STOCK_ID = #attributes.stock_id# 
							) LIKE CONCAT( PRODUCT_CAT.HIERARCHY, '.%' )
						)
					AND (SHORT_CODE_ID IS NULL OR SHORT_CODE_ID=(SELECT SHORT_CODE_ID FROM STOCKS WHERE STOCK_ID=#attributes.stock_id#))
					<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
						AND (COMPANYCAT_ID IS NULL OR COMPANYCAT_ID = (SELECT COMPANYCAT_ID FROM #dsn_alias#.COMPANY WHERE COMPANY_ID=#attributes.company_id#))
					</cfif>
					<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
						AND	(COMPANY_ID=#attributes.company_id# OR (CONSUMER_ID IS NULL AND COMPANY_ID IS NULL))
					<cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
						AND (CONSUMER_ID=#attributes.consumer_id# OR (CONSUMER_ID IS NULL AND COMPANY_ID IS NULL))
					</cfif>
					<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)> <!--- fiyat listesi secilmemisse standart alıs fiyatından kontrol eder --->
						AND PRICE_CATID=#attributes.price_catid#
					<cfelse>
						AND PRICE_CATID=-2
					</cfif>
				ORDER BY PRODUCT_ID DESC,BRAND_ID DESC,PRICE_CAT_EXCEPTIONS.PRODUCT_CATID DESC,SUPPLIER_ID DESC,COMPANYCAT_ID DESC,SHORT_CODE_ID DESC
			</cfquery>
			<cfif get_general_discounts.recordcount neq 0 and len(get_general_discounts.PAYMENT_TYPE_ID)>
				<cfset attributes.row_paymethod_id = get_general_discounts.PAYMENT_TYPE_ID>
			</cfif>
			<cfif get_general_discounts.recordcount neq 0 and len(get_general_discounts.DISCOUNT_RATE)>
				<cfset d1 = get_general_discounts.DISCOUNT_RATE>
				<cfset kontrol_discount = 1>
			</cfif>
			<cfif get_general_discounts.recordcount neq 0 and len(get_general_discounts.DISCOUNT_RATE_2)>
				<cfset d2 = get_general_discounts.DISCOUNT_RATE_2>
				<cfset kontrol_discount = 1>
			</cfif>
			<cfif get_general_discounts.recordcount neq 0 and len(get_general_discounts.DISCOUNT_RATE_3)>
				<cfset d3 = get_general_discounts.DISCOUNT_RATE_3>
				<cfset kontrol_discount = 1>
			</cfif>
			<cfif get_general_discounts.recordcount neq 0 and len(get_general_discounts.DISCOUNT_RATE_4)>
				<cfset d4 = get_general_discounts.DISCOUNT_RATE_4>
				<cfset kontrol_discount = 1>
			</cfif>
			<cfif get_general_discounts.recordcount neq 0 and len(get_general_discounts.DISCOUNT_RATE_5)>
				<cfset d5 = get_general_discounts.DISCOUNT_RATE_5>
				<cfset kontrol_discount = 1>
			</cfif>
		<cfelse>
			<cfset get_general_discounts.recordcount=0>
		</cfif>
		<!--- Sözleşme İndirimleri --->
		<cfquery name="get_contract_discounts" datasource="#dsn3#" maxrows="1">
			SELECT
				ISNULL(PC.DISCOUNT_RATE,0) DISCOUNT_RATE,
				ISNULL(PC.DISCOUNT_RATE_2,0) DISCOUNT_RATE_2,
				ISNULL(PC.DISCOUNT_RATE_3,0) DISCOUNT_RATE_3,
				ISNULL(PC.DISCOUNT_RATE_4,0) DISCOUNT_RATE_4,
				ISNULL(PC.DISCOUNT_RATE_5,0) DISCOUNT_RATE_5,
				PC.PAYMENT_TYPE_ID
			FROM 
				PRICE_CAT_EXCEPTIONS PC,
				RELATED_CONTRACT RC
			WHERE
				PC.CONTRACT_ID = RC.CONTRACT_ID
				AND (PC.SUPPLIER_ID IS NULL OR PC.SUPPLIER_ID = (SELECT COMPANY_ID FROM STOCKS WHERE STOCK_ID=#attributes.stock_id#))
				AND (PC.PRODUCT_ID IS NULL OR PC.PRODUCT_ID=#attributes.product_id#)
				AND (PC.BRAND_ID IS NULL OR PC.BRAND_ID=(SELECT BRAND_ID FROM STOCKS WHERE STOCK_ID=#attributes.stock_id#))
				AND (PC.PRODUCT_CATID IS NULL OR PC.PRODUCT_CATID=(SELECT PRODUCT_CATID FROM STOCKS WHERE STOCK_ID=#attributes.stock_id#) OR (SELECT STOCK_CODE FROM STOCKS WHERE STOCK_ID=#attributes.stock_id#) LIKE (SELECT PCC.HIERARCHY FROM PRODUCT_CAT PCC WHERE PCC.PRODUCT_CATID = PC.PRODUCT_CATID)+'.%')
				AND (PC.SHORT_CODE_ID IS NULL OR PC.SHORT_CODE_ID=(SELECT SHORT_CODE_ID FROM STOCKS WHERE STOCK_ID=#attributes.stock_id#))
				<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
					AND RC.STARTDATE <= #attributes.search_process_date#
					AND RC.FINISHDATE >= #attributes.search_process_date#
				<cfelse>
					AND RC.STARTDATE <= #now()#
					AND RC.FINISHDATE >= #now()#
				</cfif>
				<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
					AND	RC.COMPANY LIKE '%,#attributes.company_id#,%'
				<cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
					AND	RC.CONSUMERS LIKE '%,#attributes.consumer_id#,%'
				</cfif>
				<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)> <!--- fiyat listesi secilmemisse standart alıs fiyatından kontrol eder --->
					AND PC.PRICE_CATID=#attributes.price_catid#
				<cfelse>
					AND PC.PRICE_CATID=-2
				</cfif>
			ORDER BY PC.PRODUCT_ID DESC,PC.BRAND_ID DESC,(SELECT PCC.HIERARCHY FROM PRODUCT_CAT PCC WHERE PCC.PRODUCT_CATID = PC.PRODUCT_CATID) DESC,PC.PRODUCT_CATID DESC,PC.SUPPLIER_ID DESC,PC.COMPANYCAT_ID DESC,PC.SHORT_CODE_ID DESC
		</cfquery>
		<cfif get_contract_discounts.recordcount>
			<cfset d1 = get_contract_discounts.DISCOUNT_RATE>
			<cfset d2 = get_contract_discounts.DISCOUNT_RATE_2>
			<cfset d3 = get_contract_discounts.DISCOUNT_RATE_3>
			<cfset d4 = get_contract_discounts.DISCOUNT_RATE_4>
			<cfset d5 = get_contract_discounts.DISCOUNT_RATE_5>
			<cfset attributes.row_paymethod_id = get_contract_discounts.PAYMENT_TYPE_ID>
			<cfset use_other_discounts = 0>
		</cfif>
		<cfif get_general_discounts.recordcount eq 0 and isdefined('attributes.use_project_discounts') and attributes.use_project_discounts eq 1 and isdefined('attributes.project_id') and len(attributes.project_id)> <!--- XMLE BAglı calısıyor , proje iskontoları--->
			<cfquery name="get_project_discounts" datasource="#dsn3#">
				SELECT
					PD.DISCOUNT_1,PD.DISCOUNT_2,PD.DISCOUNT_3,PD.DISCOUNT_4,PD.DISCOUNT_5,ISNULL(PD.IS_CHECK_PRJ_PRODUCT,0) IS_CHECK_PRJ_PRODUCT,PD.PRO_DISCOUNT_ID,
					PDC.BRAND_ID,PDC.PRODUCT_CATID,PDC.PRODUCT_ID
				FROM 
					PROJECT_DISCOUNTS PD,
					PROJECT_DISCOUNT_CONDITIONS PDC
				WHERE
					PD.PRO_DISCOUNT_ID=PDC.PRO_DISCOUNT_ID
					AND PD.PROJECT_ID=#attributes.project_id#
					<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
						AND (PD.IS_CHECK_PRJ_MEMBER=0 OR PD.COMPANY_ID=#attributes.company_id#)
					<cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
						AND (PD.IS_CHECK_PRJ_MEMBER=0 OR PD.CONSUMER_ID=#attributes.consumer_id#)
					</cfif>
					<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
						AND PD.START_DATE <= #attributes.search_process_date#
						AND PD.FINISH_DATE >= #attributes.search_process_date#
					<cfelse>
						AND PD.START_DATE <= #now()#
						AND PD.FINISH_DATE >= #now()#
					</cfif>
					<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)> <!--- fiyat listesi secilmemisse standart fiyatından kontrol eder --->
						AND (PD.IS_CHECK_PRJ_PRICE_CAT=0 OR PD.PRICE_CATID=#attributes.price_catid#)
					<cfelse>
						AND (PD.IS_CHECK_PRJ_PRICE_CAT=0 OR PD.PRICE_CATID=-2)
					</cfif>
				ORDER BY PRODUCT_ID DESC,BRAND_ID DESC,PRODUCT_CATID DESC
			</cfquery>
			<cfif get_project_discounts.recordcount and get_project_discounts.IS_CHECK_PRJ_PRODUCT eq 1>
				<cfset prj_prod_list_=listsort(valuelist(get_project_discounts.PRODUCT_ID),'numeric','asc')>
				<cfset prj_brand_list_=listsort(valuelist(get_project_discounts.BRAND_ID),'numeric','asc')>
				<cfset prj_prod_cat_list=listsort(valuelist(get_project_discounts.PRODUCT_CATID),'numeric','asc')>
				<cfquery name="get_project_prods" datasource="#dsn3#">
					SELECT
						PRODUCT_ID,
						PRODUCT_NAME
					FROM
						PRODUCT
					WHERE
						PRODUCT_ID=#attributes.product_id#
						<cfif len(prj_brand_list_)>
						AND ISNULL(BRAND_ID,0) IN (#prj_brand_list_#)
						</cfif>
						<cfif len(prj_prod_cat_list)>
						AND ISNULL(PRODUCT_CATID,0) IN (#prj_prod_cat_list#) 
						</cfif>
						<cfif len(prj_prod_list_)>
						AND PRODUCT_ID IN (#prj_prod_list_#) 
						</cfif>
				</cfquery>
			</cfif>
			<cfif get_project_discounts.recordcount neq 0 and ( (get_project_discounts.IS_CHECK_PRJ_PRODUCT eq 0) or (get_project_discounts.IS_CHECK_PRJ_PRODUCT eq 1 and get_project_prods.recordcount neq 0) )>
				<cfset use_other_discounts=0> <!--- proje iskontoları kullanılacak --->
				<cfscript>
					d1 = get_project_discounts.DISCOUNT_1;
					d2 = get_project_discounts.DISCOUNT_2;
					d3 = get_project_discounts.DISCOUNT_3;
					d4 = get_project_discounts.DISCOUNT_4;
					d5 = get_project_discounts.DISCOUNT_5;
				</cfscript>
				<cfset use_other_discounts=0>
			<cfelse>
				<script type="text/javascript">
					alert('Ürün Proje Bağlantısı Kapsamında Olmadığından Sepete Eklenmeyecektir!');
					<cfif not (isdefined('attributes.from_add_barcod') and attributes.from_add_barcod eq 1) and not (isdefined("multi") and multi neq 0)>
						if (<cfoutput>#update_product_row_id#</cfoutput> == 0)
							window.history.back();
						else
							window.close();
					</cfif>
				</script>
				<cfabort>
			</cfif>
		<cfelse>
			<cfset get_project_discounts.recordcount=0>
		</cfif>
		<cfif use_other_discounts eq 1><!--- proje baglantıları haricinde iskonto kullanılacaksa --->
			<cfquery name="get_contracts" datasource="#dsn3#" maxrows="1">
				SELECT
					DISCOUNT1,
					DISCOUNT2,
					DISCOUNT3,
					DISCOUNT4,
					DISCOUNT5,
					DISCOUNT_CASH,
					DISCOUNT_CASH_MONEY
				FROM
					CONTRACT_SALES_PROD_DISCOUNT
				WHERE
					PRODUCT_ID = #attributes.product_id#
				<cfif isdefined('attributes.use_paymethod_for_prod_conditions') and attributes.use_paymethod_for_prod_conditions eq 1><!--- xmlde urun kosulları odeme yontemine gore calısır secilmisse --->
					<cfif isdefined('attributes.paymethod_id') and len(attributes.paymethod_id)><!--- xmlde urun kosulları odeme yontemine gore calısır secilmisse ve islem detayda odeme yontemi secilmisse --->
						AND PAYMETHOD_ID=#attributes.paymethod_id# 
					<cfelse>
						AND 1=2 
					</cfif>
				</cfif>
				<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.price_catid") and len(attributes.price_catid)>
					AND (COMPANY_ID = #attributes.COMPANY_ID#
					OR (COMPANY_ID IS NULL AND C_S_PROD_DISCOUNT_ID IN (SELECT C_S_PROD_DISCOUNT_ID FROM CONTRACT_SALES_PROD_PRICE_LIST CSPPL WHERE CSPPL.C_S_PROD_DISCOUNT_ID = CONTRACT_SALES_PROD_DISCOUNT.C_S_PROD_DISCOUNT_ID AND PRICE_CAT_ID IN (#attributes.price_catid#))) )
				<cfelseif isdefined("attributes.price_catid") and len(attributes.price_catid)>
					AND COMPANY_ID IS NULL AND C_S_PROD_DISCOUNT_ID IN (SELECT C_S_PROD_DISCOUNT_ID FROM CONTRACT_SALES_PROD_PRICE_LIST CSPPL WHERE CSPPL.C_S_PROD_DISCOUNT_ID = CONTRACT_SALES_PROD_DISCOUNT.C_S_PROD_DISCOUNT_ID AND PRICE_CAT_ID IN (#attributes.price_catid#))
				<cfelseif isdefined("attributes.company_id") and len(attributes.company_id)>
					AND COMPANY_ID = #attributes.COMPANY_ID#
				</cfif>
				<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
					AND (
							START_DATE <= #attributes.search_process_date#
							AND ( FINISH_DATE >= #attributes.search_process_date# OR FINISH_DATE IS NULL )
						)
				<cfelse>
					AND START_DATE <= #now()#
					AND FINISH_DATE >= #now()#
				</cfif>
				ORDER BY
					START_DATE DESC,
					RECORD_DATE DESC
			</cfquery>
			<cfif not get_contracts.recordcount>
				<cfquery name="get_contracts" datasource="#dsn3#" maxrows="1">
					SELECT
						DISCOUNT1,
						DISCOUNT2,
						DISCOUNT3,
						DISCOUNT4,
						DISCOUNT5,
						DISCOUNT_CASH,
						DISCOUNT_CASH_MONEY
					FROM
						CONTRACT_SALES_PROD_DISCOUNT
					WHERE
						PRODUCT_ID = #attributes.product_id# AND
						COMPANY_ID IS NULL AND
					<cfif isdefined('attributes.use_paymethod_for_prod_conditions') and attributes.use_paymethod_for_prod_conditions eq 1><!--- xmlde urun kosulları odeme yontemine gore calısır secilmisse --->
						<cfif isdefined('attributes.paymethod_id') and len(attributes.paymethod_id)><!--- xmlde urun kosulları odeme yontemine gore calısır secilmisse ve islem detayda odeme yontemi secilmisse --->
							PAYMETHOD_ID=#attributes.paymethod_id# AND
						<cfelse>
							1=2 AND
						</cfif>
					</cfif>
						C_S_PROD_DISCOUNT_ID NOT IN (SELECT C_S_PROD_DISCOUNT_ID FROM CONTRACT_SALES_PROD_PRICE_LIST )  AND
					<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
						(
							START_DATE <= #attributes.search_process_date# AND
							(FINISH_DATE >= #attributes.search_process_date# OR FINISH_DATE IS NULL)			
						)
					<cfelse>
						START_DATE <= #now()# AND
						FINISH_DATE >= #now()#
					</cfif>
					ORDER BY
						START_DATE DESC,
						RECORD_DATE DESC
				</cfquery>
			</cfif>
			<cfscript>// indirimler anlaşma varsa
				if(get_contracts.recordcount)
				{
					d1 = get_contracts.discount1;
					d2 = get_contracts.discount2;
					d3 = get_contracts.discount3;
					d4 = get_contracts.discount4;
					d5 = get_contracts.discount5;
					if(len(get_contracts.discount_cash))
					{
						if( attributes.str_money_currency is get_contracts.discount_cash_money) //urunun para birimi ile retabe para birimi aynı ise tutar aynen alınır yoksa urun para birimine cevirilir
							disc_amount = get_contracts.discount_cash;
						else
							disc_amount = wrk_round( ( (get_contracts.discount_cash * evaluate("attributes.#get_contracts.discount_cash_money#"))/evaluate("attributes.#attributes.str_money_currency#") ),4);
					}
				}
			</cfscript>
			<cfif isdefined('attributes.company_id') and len(attributes.company_id) and ((isdefined("attributes.branch_id") and isnumeric(attributes.branch_id) ) or (not (isdefined('attributes.branch_id') and len(attributes.branch_id)) and isdefined('attributes.int_basket_id') and listfind('3,4',attributes.int_basket_id) and len(listlast(session.ep.user_location,'-')) )) ><!--- // indirimler anlaşmada genel indirimler tanımlı ise --->
				<cfquery name="get_sales_general_discounts" datasource="#dsn3#" maxrows="5">
					SELECT
						DISCOUNT
					FROM
						CONTRACT_SALES_GENERAL_DISCOUNT AS CS_GD,
						CONTRACT_SALES_GENERAL_DISCOUNT_BRANCHES CS_GDB
					WHERE
						CS_GD.GENERAL_DISCOUNT_ID = CS_GDB.GENERAL_DISCOUNT_ID
						<cfif not (isdefined('attributes.branch_id') and len(attributes.branch_id)) and isdefined('attributes.int_basket_id') and listfind('3,4',attributes.int_basket_id) and len(listlast(session.ep.user_location,'-')) >
							AND CS_GDB.BRANCH_ID = #listlast(session.ep.user_location,'-')#
						<cfelse>
							AND CS_GDB.BRANCH_ID = #attributes.branch_id#
						</cfif>
						AND CS_GD.COMPANY_ID = #attributes.company_id#
					<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
						AND CS_GD.START_DATE <= #attributes.search_process_date#
						AND CS_GD.FINISH_DATE >= #attributes.search_process_date#
					<cfelse>
						AND CS_GD.START_DATE <= #now()#
						AND CS_GD.FINISH_DATE >= #now()#
					</cfif>
					ORDER BY
						CS_GD.GENERAL_DISCOUNT_ID
				</cfquery>
				<cfif get_sales_general_discounts.recordcount and not(isdefined("get_general_discounts") and get_general_discounts.recordcount gt 0 and kontrol_discount eq 1)>
					<cfloop query="get_sales_general_discounts">
						<cfset 'd#currentrow+5#' = get_sales_general_discounts.DISCOUNT>
					</cfloop>
				</cfif>
			</cfif>
		</cfif>
		<cfif isdefined('attributes.row_promotion_id') and len(attributes.row_promotion_id)> <!--- promosyonlu satırdan geliyorsa --->
		<cfquery name="get_promotion_discount" datasource="#dsn3#" maxrows="1"><!---list_product sayfasındaki form_productta iskonto tutar, % iskonto set edilirse bu query silinebilir --->
			SELECT
				DISCOUNT,AMOUNT_DISCOUNT,AMOUNT_DISCOUNT_MONEY_1,PROM_ID,DUE_DAY,TARGET_DUE_DATE
			FROM
				PROMOTIONS
			WHERE
				PROM_STATUS = 1
				AND PROM_ID = #attributes.row_promotion_id#
		</cfquery>
		<cfif get_promotion_discount.recordcount>
			<cfif len(get_promotion_discount.DUE_DAY)>
				<cfset prom_due_date = get_promotion_discount.DUE_DAY>
			<cfelseif len(get_promotion_discount.TARGET_DUE_DATE) and isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
				<cfset prom_due_date = datediff('d',attributes.search_process_date,get_promotion_discount.TARGET_DUE_DATE)>
			<cfelse>
				<cfset prom_due_date = ''>
			</cfif>
			<!--- <cfif len(get_promotion_discount.DISCOUNT) and get_promotion_discount.DISCOUNT neq 0> promosyon yuzde ındırımı PROM_COMISSION alanına yazılıyor
				<cfset d10 = get_promotion_discount.DISCOUNT>
			</cfif> --->
			<cfif len(get_promotion_discount.AMOUNT_DISCOUNT) and  get_promotion_discount.AMOUNT_DISCOUNT neq 0>
				{
					<cfif not len(get_promotion_discount.AMOUNT_DISCOUNT_MONEY_1) or (attributes.str_money_currency is get_promotion_discount.AMOUNT_DISCOUNT_MONEY_1)><!---  urunun para birimi ile promosyon iskonto tutarı para birimi aynı ise tutar aynen alınır yoksa urun para birimine cevirilir --->
						<cfset disc_amount = disc_amount + get_promotion_discount.AMOUNT_DISCOUNT>
					<cfelse>
						<cfset disc_amount = disc_amount + wrk_round( ( (get_promotion_discount.AMOUNT_DISCOUNT * evaluate("attributes.#get_promotion_discount.AMOUNT_DISCOUNT_MONEY_1#"))/evaluate("attributes.#attributes.str_money_currency#") ),4)>
					</cfif>
				}

			</cfif>
		</cfif>
		</cfif>
	</cfif>
	<!--- // indirimler ayarlanır --->
	<cfif not isdefined("update_product_row_id")>
		<cfset update_product_row_id = 0 >
	</cfif>	
	<cfif get_product_all_multip.IS_KARMA eq 1 and get_product_all_multip.IS_KARMA_SEVK neq 1 and is_sale_product eq 1>
		<cfset net_maliyet_karma = 0>
		<cfset extra_maliyet_karma = 0>
		<cfloop query="GET_KARMA_PRODUCT">
			<cfquery name="GET_PRODUCT_COST" datasource="#dsn3#" maxrows="1">
				SELECT
					PC.PRODUCT_COST_ID,
					<cfif session.ep.our_company_info.is_cost_location eq 2>
						PC.PURCHASE_NET_DEPARTMENT_ALL * (SM.RATE2 / SM.RATE1) PURCHASE_NET,
						PC.PURCHASE_EXTRA_COST_DEPARTMENT * (SM.RATE2 / SM.RATE1) PURCHASE_EXTRA_COST
					<cfelseif session.ep.our_company_info.is_cost_location eq 1>
						PC.PURCHASE_NET_LOCATION_ALL * (SM.RATE2 / SM.RATE1) PURCHASE_NET,
						PC.PURCHASE_EXTRA_COST_LOCATION * (SM.RATE2 / SM.RATE1) PURCHASE_EXTRA_COST
					<cfelse>
						PC.PURCHASE_NET_ALL * (SM.RATE2 / SM.RATE1) PURCHASE_NET,
						PC.PURCHASE_EXTRA_COST * (SM.RATE2 / SM.RATE1) PURCHASE_EXTRA_COST
					</cfif>
				FROM
					PRODUCT_COST PC,
					#dsn2_alias#.SETUP_MONEY SM
				WHERE 
					SM.MONEY = PC.PURCHASE_NET_MONEY AND
					PC.PRODUCT_COST IS NOT NULL AND
					<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
						PC.START_DATE < #DATEADD('d',1,attributes.search_process_date)# AND 
					<cfelse>
						PC.START_DATE < #now()# AND
					</cfif>
					PC.PRODUCT_ID = #GET_KARMA_PRODUCT.product_id#
					<cfif session.ep.our_company_info.is_cost_location neq 0>
						<cfif isdefined("attributes.department_out") and len(attributes.department_out)>
							AND PC.DEPARTMENT_ID = #listfirst(attributes.department_out)#	
						</cfif>
						<cfif session.ep.our_company_info.is_cost_location eq 1>
							<cfif isdefined("attributes.location_out") and len(attributes.location_out)>
								AND PC.LOCATION_ID = #attributes.location_out#	
							</cfif>
						</cfif>
					</cfif>
				ORDER BY 
					PC.START_DATE DESC
					--,PC.RECORD_DATE DESC
					,PC.PRODUCT_COST_ID DESC
			</cfquery>
			<cfset net_maliyet_karma = net_maliyet_karma + isnumeric(GET_PRODUCT_COST.PURCHASE_NET)>
			<cfset extra_maliyet_karma = extra_maliyet_karma + isnumeric(GET_PRODUCT_COST.PURCHASE_EXTRA_COST)>
		</cfloop>
	<cfelse>
		<cfif session.ep.our_company_info.is_cost_location eq 1 and listfind("53,52,62,70,71,72,78,79,88,111,112,113,116,119,141,531,532",attributes.sepet_process_type) and len(get_product_all_multip.IS_COST) and get_product_all_multip.IS_COST>
			<cfquery name="GET_PRODUCT_COST" datasource="#dsn3#" maxrows="1">
				SELECT
					PC.PRODUCT_COST_ID,
					PC.PURCHASE_NET_LOCATION_ALL * (SM.RATE2 / SM.RATE1) PURCHASE_NET,
					PC.PURCHASE_EXTRA_COST_LOCATION * (SM.RATE2 / SM.RATE1) PURCHASE_EXTRA_COST
				FROM
					PRODUCT_COST PC,
					#dsn2_alias#.SETUP_MONEY SM
				WHERE 
					SM.MONEY = PC.PURCHASE_NET_MONEY AND
					PC.PRODUCT_COST IS NOT NULL AND
					<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
						PC.START_DATE < #DATEADD('d',1,attributes.search_process_date)# AND 
					<cfelse>
						PC.START_DATE < #now()# AND
					</cfif>
					PC.PRODUCT_ID = #attributes.product_id#
					<cfif isdefined("attributes.department_out") and len(attributes.department_out)>
						AND PC.DEPARTMENT_ID = #listfirst(attributes.department_out)#	
					</cfif>
					<cfif isdefined("attributes.location_out") and len(attributes.location_out)>
						AND PC.LOCATION_ID = #attributes.location_out#	
					</cfif>
				ORDER BY 
					PC.START_DATE DESC
					--,PC.RECORD_DATE DESC
					,PC.PRODUCT_COST_ID DESC
			</cfquery>
		<cfelseif session.ep.our_company_info.is_cost_location eq 2 and listfind("53,52,62,70,71,72,78,79,88,111,112,113,116,119,141,531,532",attributes.sepet_process_type) and len(get_product_all_multip.IS_COST) and get_product_all_multip.IS_COST>
			<cfquery name="GET_PRODUCT_COST" datasource="#dsn3#" maxrows="1">
				SELECT
					PC.PRODUCT_COST_ID,
					PC.PURCHASE_NET_DEPARTMENT_ALL * (SM.RATE2 / SM.RATE1) PURCHASE_NET,
					PC.PURCHASE_EXTRA_COST_DEPARTMENT * (SM.RATE2 / SM.RATE1) PURCHASE_EXTRA_COST
				FROM
					PRODUCT_COST PC,
					#dsn2_alias#.SETUP_MONEY SM
				WHERE 
					SM.MONEY = PC.PURCHASE_NET_MONEY AND
					PC.PRODUCT_COST IS NOT NULL AND
					<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
						PC.START_DATE < #DATEADD('d',1,attributes.search_process_date)# AND 
					<cfelse>
						PC.START_DATE < #now()# AND
					</cfif>
					PC.PRODUCT_ID = #attributes.product_id#
					<cfif isdefined("attributes.department_out") and len(attributes.department_out)>
						AND PC.DEPARTMENT_ID = #listfirst(attributes.department_out)#	
					</cfif>
				ORDER BY 
					PC.START_DATE DESC
					--,PC.RECORD_DATE DESC
					,PC.PRODUCT_COST_ID DESC
			</cfquery>
		<cfelseif (is_sale_product eq 1 or (isdefined("attributes.sepet_process_type") and listfind("110,111,112,113,114,115,119",attributes.sepet_process_type)) or (isdefined('attributes.int_basket_id') and listfind("50",attributes.int_basket_id))) and len(get_product_all_multip.IS_COST) and get_product_all_multip.IS_COST>
			<cfquery name="GET_PRODUCT_COST" datasource="#dsn3#" maxrows="1">
				SELECT
					PC.PRODUCT_COST_ID,
					PC.PURCHASE_NET_ALL * (SM.RATE2 / SM.RATE1) PURCHASE_NET,
					PC.PURCHASE_EXTRA_COST * (SM.RATE2 / SM.RATE1) PURCHASE_EXTRA_COST
				FROM
					PRODUCT_COST PC,
					#dsn2_alias#.SETUP_MONEY SM
				WHERE 
					SM.MONEY = PC.PURCHASE_NET_MONEY AND
					PC.PRODUCT_COST IS NOT NULL AND
				<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
					PC.START_DATE < #DATEADD('d',1,attributes.search_process_date)# AND 
				<cfelse>
					PC.START_DATE < #now()# AND
				</cfif>
					PC.PRODUCT_ID = #attributes.product_id#
				ORDER BY 
					PC.START_DATE DESC
					--,PC.RECORD_DATE DESC
					,PC.PRODUCT_COST_ID DESC
			</cfquery>
		<cfelseif isdefined("attributes.sepet_process_type") and listfind('81',attributes.sepet_process_type) and len(get_product_all_multip.IS_COST) and get_product_all_multip.IS_COST>
			<cfquery name="GET_PRODUCT_COST" datasource="#dsn3#" maxrows="1">
				SELECT
					PC.PRODUCT_COST_ID,
					<cfif session.ep.our_company_info.is_cost_location eq 2>
						PC.PURCHASE_NET_DEPARTMENT_ALL * (SM.RATE2 / SM.RATE1) PURCHASE_NET,
						PC.PURCHASE_EXTRA_COST_DEPARTMENT * (SM.RATE2 / SM.RATE1) PURCHASE_EXTRA_COST
					<cfelseif session.ep.our_company_info.is_cost_location eq 1>
						PC.PURCHASE_NET_LOCATION_ALL * (SM.RATE2 / SM.RATE1) PURCHASE_NET,
						PC.PURCHASE_EXTRA_COST_LOCATION * (SM.RATE2 / SM.RATE1) PURCHASE_EXTRA_COST
					<cfelse>
						PC.PURCHASE_NET_ALL * (SM.RATE2 / SM.RATE1) PURCHASE_NET,
						PC.PURCHASE_EXTRA_COST * (SM.RATE2 / SM.RATE1) PURCHASE_EXTRA_COST
					</cfif>
				FROM
					PRODUCT_COST PC,
					#dsn2_alias#.SETUP_MONEY SM
				WHERE 
					SM.MONEY = PC.PURCHASE_NET_MONEY AND
					PC.PRODUCT_COST IS NOT NULL AND
					<cfif isdefined("attributes.search_process_date") and len(attributes.search_process_date)>
						PC.START_DATE < #DATEADD('d',1,attributes.search_process_date)# AND 
					<cfelse>
						PC.START_DATE < #now()# AND
					</cfif>
					PC.PRODUCT_ID = #attributes.product_id#
					<cfif session.ep.our_company_info.is_cost_location neq 0>
						<cfif isdefined("attributes.department_out") and len(attributes.department_out)>
							AND PC.DEPARTMENT_ID = #listfirst(attributes.department_out)#	
						</cfif>
						<cfif session.ep.our_company_info.is_cost_location eq 1>
							<cfif isdefined("attributes.location_out") and len(attributes.location_out)>
								AND PC.LOCATION_ID = #attributes.location_out#	
							</cfif>
						</cfif>
					</cfif>
				ORDER BY 
					PC.START_DATE DESC
					--,PC.RECORD_DATE DESC
					,PC.PRODUCT_COST_ID DESC
			</cfquery>
		</cfif>
	</cfif>
	<cfoutput>
	<cfscript>
		if(isdefined("attributes.spec_id") and len(attributes.spec_id))
		{
			if(isdefined('attributes.company_id') and len(attributes.company_id))
			{
				spec_fonk=specer(
									dsn_type:dsn3,
									main_spec_id=attributes.spec_id,
									add_to_main_spec=1,
									company_id=attributes.company_id
								);
			}
			else if(isdefined('attributes.consumer_id') and len(attributes.consumer_id)){
				spec_fonk=specer(
									dsn_type:dsn3,
									main_spec_id=attributes.spec_id,
									add_to_main_spec=1,
									consumer_id=attributes.consumer_id
								);
			}
			else{
				spec_fonk=specer(
									dsn_type:dsn3,
									main_spec_id=attributes.spec_id,
									add_to_main_spec=1
								);
			}
			attributes.spec_name=listgetat(spec_fonk,3,',');
			attributes.spec_id=listgetat(spec_fonk,2,',');
		}else
		{
			attributes.spec_name='';
			attributes.spec_id='';
		}
		if(isdefined("attributes.satir") and not len(attributes.satir))
		attributes.satir = -1;
	</cfscript>
	<script type="text/javascript">
		product_id = '#attributes.product_id#';
		stock_id = '#attributes.stock_id#';
		stock_code  = '#attributes.stock_code#';
		barcod  = '#attributes.barcod#';
		manufact_code  = '#attributes.manufact_code#';
		product_name  = '#attributes.product_name#';
		unit_id_  = '#attributes.unit_id#';
		specific_weight = <cfif isdefined("get_weight.weight") and len(get_weight.weight) and isdefined("get_weight.volume") and len(get_weight.volume)><cfset deger=get_weight.weight/(get_weight.volume/1000)>'#deger#'<cfelse>0</cfif>;
		unit_  = '#page_unit#';
		spect_id  = '#attributes.spec_id#';
		spect_name  = '#attributes.spec_name#';
		price_other_calc = '';
		karma_product_id = <cfif isdefined('get_product_all_multip.IS_KARMA') and get_product_all_multip.IS_KARMA eq 1>'#attributes.product_id#'<cfelse>''</cfif>;
		gtip_number = <cfif isdefined("attributes.gtip_number") and len(attributes.gtip_number)>'#attributes.gtip_number#'<cfelse>''</cfif>;
		ek_tutar='';
		ek_tutar_price=<cfif isdefined("attributes.ek_tutar")>'#attributes.ek_tutar#'<cfelse>''</cfif>; //ek_tutar artık iscilik birim ucretine atanıyor, iscilik birim miktarı gozonunda bulundurularak bu deger uzerinden ek tutar hesaplanıyor
		get_units = wrk_safe_query('get_units','dsn3',0,<cfoutput>#attributes.product_id#</cfoutput>);
		product_unit_list = '';
		for(kk_unit=0;kk_unit<get_units.recordcount;kk_unit++)
		{	
			if(product_unit_list != '')
				product_unit_list+=','+get_units.ADD_UNIT[kk_unit];
			else
				product_unit_list+=get_units.ADD_UNIT[kk_unit];
		}
		unit_other=<cfif isdefined("attributes.unit_other")>'#attributes.unit_other#'<cfelse>''</cfif>;
		amount_other=<cfif isdefined("attributes.amount_other")>'#attributes.amount_other#'<cfelse>''</cfif>;	//işçilikli urun listelerinde, işcilik urunun miktarını baskete tasir	
		row_promotion_id = '';
		<cfif isdefined("attributes.row_promotion_id")>row_promotion_id = '#attributes.row_promotion_id#';</cfif>
		row_paymethod_id = '';
		<cfif isdefined("attributes.row_paymethod_id")>row_paymethod_id = '#attributes.row_paymethod_id#';</cfif>
		lot_no = '';
		<cfif isdefined("attributes.lot_no")>lot_no = '#attributes.lot_no#';</cfif>
		promosyon_yuzde = '';
		<cfif isdefined("attributes.promosyon_yuzde")>promosyon_yuzde = '#attributes.promosyon_yuzde#';</cfif>
		promosyon_maliyet = '';
		<cfif isdefined("attributes.promosyon_maliyet")>promosyon_maliyet = '#attributes.promosyon_maliyet#';</cfif>
		is_promotion = 0;
		<cfif isdefined("attributes.is_promotion") and len(attributes.is_promotion)>is_promotion = '#attributes.is_promotion#';</cfif>
		prom_stock_id = '';
		<cfif isdefined("attributes.prom_stock_id") and len(attributes.prom_stock_id)>prom_stock_id = '#attributes.prom_stock_id#';</cfif>
		<cfif isdefined("disc_amount") and len(disc_amount) and disc_amount lte flt_price> /*tutar iskontosu birim fiyattan daha fazla olamaz*/
			iskonto_tutar='#disc_amount#';
		<cfelse>
			iskonto_tutar=0;
		</cfif>
		/*satır bazlı urune urun promosyonlarında 2 satır arasındaki baglantıyı tutar, boylece baskete aynı promosyondan birden fazla dusuruldugunde karısıklık olmaz*/
		<cfif isdefined('prom_relation_info') and isdefined("attributes.row_promotion_id")>
			prom_relation_id = '#prom_relation_info#';
		<cfelse>
			prom_relation_id = '';
		</cfif>
		price  = '#flt_price#';
		price_other  = '#flt_price_other_amount#';
		tax  = '#attributes.tax#';
		<cfif isdefined("attributes.otv")>
			otv = '#attributes.otv#';
		<cfelse>
			otv = 0;
		</cfif>
		duedate  = '';
		<cfif isdefined("attributes.due_day_value")>duedate = '#attributes.due_day_value#';</cfif>
		<cfif isdefined('prom_due_date') and len(prom_due_date) and prom_due_date gte 0>duedate = '#prom_due_date#';</cfif> /*promosyondan gelen vade*/
		<cfif len(d1) >d1 = '#d1#';<cfelse>d1 = 0;</cfif>
		<cfif len(d2) >d2 = '#d2#';<cfelse>d2 = 0;</cfif>
		<cfif len(d3) >d3 = '#d3#';<cfelse>d3 = 0;</cfif>
		<cfif len(d4) >d4 = '#d4#';<cfelse>d4 = 0;</cfif>
		<cfif len(d5) >d5 = '#d5#';<cfelse>d5 = 0;</cfif>
		<cfif len(d6) >d6 = '#d6#';<cfelse>d6 = 0;</cfif>
		<cfif len(d7) >d7 = '#d7#';<cfelse>d7 = 0;</cfif>
		<cfif len(d8) >d8 = '#d8#';<cfelse>d8 = 0;</cfif>
		<cfif len(d9) >d9 = '#d9#';<cfelse>d9 = 0;</cfif>
		<cfif len(d10) >d10 = '#d10#';<cfelse>d10 = 0;</cfif>
		<cfif isdefined("attributes.is_inventory")>
			is_inventory = #attributes.is_inventory#;
		<cfelse>
			is_inventory='';
		</cfif>
		<cfif isdefined("attributes.is_production") and attributes.is_production eq 1>
			is_production = 1;
		<cfelse>
			is_production = 0;
		</cfif>
		<cfif session.ep.our_company_info.is_cost_location eq 1 and isdefined("GET_PRODUCT_COST") and len(GET_PRODUCT_COST.PURCHASE_NET) and listfind("53,52,62,70,71,72,78,79,88,111,112,113,116,119,141,531,532",attributes.sepet_process_type) and len(get_product_all_multip.IS_COST) and get_product_all_multip.IS_COST>
			net_maliyet = <cfif isdefined("net_maliyet_karma") and len(net_maliyet_karma)>#wrk_round(net_maliyet_karma,4)#;<cfelse>#wrk_round(GET_PRODUCT_COST.PURCHASE_NET,4)#;</cfif>
			extra_cost = <cfif isdefined("extra_maliyet_karma") and len(extra_maliyet_karma)>#wrk_round(extra_maliyet_karma,4)#;<cfelse>#wrk_round(GET_PRODUCT_COST.PURCHASE_EXTRA_COST,4)#;</cfif>
			<cfif isdefined("attributes.sepet_process_type") and listfind("110,111,112,113,114,115,119",attributes.sepet_process_type)>
				price  = #wrk_round(GET_PRODUCT_COST.PURCHASE_NET,4)#;
				price_other_calc = 1;
			</cfif>
		<cfelseif session.ep.our_company_info.is_cost_location eq 2 and isdefined("GET_PRODUCT_COST") and len(GET_PRODUCT_COST.PURCHASE_NET) and listfind("53,52,62,70,71,72,78,79,88,111,112,113,116,119,141,531,532",attributes.sepet_process_type) and len(get_product_all_multip.IS_COST) and get_product_all_multip.IS_COST>
			net_maliyet = <cfif isdefined("net_maliyet_karma") and len(net_maliyet_karma)>#wrk_round(net_maliyet_karma,4)#;<cfelse>#wrk_round(GET_PRODUCT_COST.PURCHASE_NET,4)#;</cfif>
			extra_cost = <cfif isdefined("extra_maliyet_karma") and len(extra_maliyet_karma)>#wrk_round(extra_maliyet_karma,4)#;<cfelse>#wrk_round(GET_PRODUCT_COST.PURCHASE_EXTRA_COST,4)#;</cfif>
			<cfif isdefined("attributes.sepet_process_type") and listfind("110,111,112,113,114,115,119",attributes.sepet_process_type)>
				price  = #wrk_round(GET_PRODUCT_COST.PURCHASE_NET,4)#;
				price_other_calc = 1;
			</cfif>
		<cfelseif isdefined("GET_PRODUCT_COST") and len(GET_PRODUCT_COST.PURCHASE_NET) and (is_sale_product eq 1 or (isdefined("attributes.sepet_process_type") and listfind("110,111,112,113,114,115,119",attributes.sepet_process_type)) or (isdefined('attributes.int_basket_id') and listfind("50",attributes.int_basket_id))) and len(get_product_all_multip.IS_COST) and get_product_all_multip.IS_COST and len(GET_PRODUCT_COST.PRODUCT_COST_ID)>
			net_maliyet = <cfif isdefined("net_maliyet_karma") and len(net_maliyet_karma)>#wrk_round(net_maliyet_karma,4)#;<cfelse>#wrk_round(GET_PRODUCT_COST.PURCHASE_NET,4)#;</cfif>
			extra_cost = <cfif isdefined("extra_maliyet_karma") and len(extra_maliyet_karma)>#wrk_round(extra_maliyet_karma,4)#;<cfelse>#wrk_round(GET_PRODUCT_COST.PURCHASE_EXTRA_COST,4)#;</cfif>
			<cfif isdefined("attributes.sepet_process_type") and listfind("110,111,112,113,114,115,119",attributes.sepet_process_type)>
				price  = #wrk_round(GET_PRODUCT_COST.PURCHASE_NET,4)#;
				price_other_calc = 1;
			</cfif>
		<cfelseif isdefined("GET_PRODUCT_COST") and len(GET_PRODUCT_COST.PURCHASE_NET) and isdefined("attributes.sepet_process_type") and listfind('81',attributes.sepet_process_type) and len(get_product_all_multip.IS_COST) and len(GET_PRODUCT_COST.PURCHASE_NET) and get_product_all_multip.IS_COST and len(GET_PRODUCT_COST.PRODUCT_COST_ID)>
			net_maliyet = <cfif isdefined("net_maliyet_karma") and len(net_maliyet_karma)>#wrk_round(net_maliyet_karma,4)#;<cfelse>#wrk_round(GET_PRODUCT_COST.PURCHASE_NET,4)#;</cfif>
			extra_cost = <cfif isdefined("extra_maliyet_karma") and len(extra_maliyet_karma)>#wrk_round(extra_maliyet_karma,4)#;<cfelse>#wrk_round(GET_PRODUCT_COST.PURCHASE_EXTRA_COST,4)#;</cfif>
			price  = #wrk_round(GET_PRODUCT_COST.PURCHASE_NET,4)#;
			price_other_calc = 1;
		<cfelse>
			net_maliyet = '';
			extra_cost = 0;
		</cfif>
		marj = <cfif isdefined("attributes.marj") and len(attributes.marj)>#attributes.marj#;<cfelse>'';</cfif>
		deliver_date = <cfif isdefined('attributes.deliver_date') and len(attributes.deliver_date)>'#attributes.deliver_date#';<cfelse>'';</cfif>
		/*herhalukarda listgetat(session.ep.user_location,1,'-') gonderildigi icin kapatıldı, farklı şirkette siparis kaydederken o sirkete ait olmayan depo bilgisi satıra yazılıyordu
		deliver_dept = '#attributes.department_id#';
		department_head = '#attributes.department_name#';*/
		deliver_dept ='';
		department_head ='';
		<cfif len(attributes.str_money_currency)>
			money  = '#attributes.str_money_currency#';
		<cfelse>
			money  = '#money_currency#';
		</cfif>
		row_ship_id  = 0; /*böyle olmalı sadece faturaya irsaliye seçme durumunda satirin irsaliye ID si 0 dan farklı olur 20050208*/
		is_commission = 0; /*kredi karti odeme yontemine bagli komisyon urunu elle secilemeyecegi icin default 0 ataniyor*/
		<cfif (isdefined("attributes.basket_id") and attributes.basket_id eq 6) or (isdefined("attributes.int_basket_id") and attributes.int_basket_id eq 6)>			
			amount_ = #flt_miktar# * #attributes.amount#;
			// amount_other = #flt_miktar# / #attributes.amount_multiplier#;
		<cfelse>	
			<cfif isdefined("attributes.amount_multiplier") and len(attributes.amount_multiplier) and isnumeric(replace(attributes.amount_multiplier,",","."))>		
				amount_ = #attributes.amount# * #(attributes.amount_multiplier)#;
			<cfelseif isdefined("attributes.amount_multiplier") and len(attributes.amount_multiplier) and isnumeric(attributes.amount_multiplier)>
				amount_ = #attributes.amount# * #attributes.amount_multiplier#;
			<cfelse>
				amount_ = #attributes.amount#
			</cfif>
		</cfif>
		//isdefined("attributes.amount_multiplier") and len(attributes.amount_multiplier) and isnumeric(replace(attributes.amount_multiplier,",",".")) and isdefined("get_minimum_order") and (page_unit neq get_minimum_order.MINIMUM_ORDER_UNIT_ID)>
		<cfif is_sale_product eq 1>
			product_account_code = '#get_product_account(prod_id:attributes.product_id).ACCOUNT_CODE#';
		<cfelse>
			product_account_code = '#get_product_account(prod_id:attributes.product_id).ACCOUNT_CODE_PUR#';
		</cfif>
		shelf_number = <cfif isdefined("attributes.shelf_number") and len(attributes.shelf_number)>#attributes.shelf_number#;<cfelse>'';</cfif>
		list_price_=<cfif isdefined("attributes.list_price") and len(attributes.list_price) and attributes.str_money_currency is session.ep.money>'#attributes.list_price#';<cfelse>'';</cfif>
		price_cat_=<cfif isdefined("attributes.price_catid") and len(attributes.price_catid)>'#attributes.price_catid#';<cfelse>'';</cfif>
		number_of_installment_ = <cfif isdefined("attributes.number_of_installment") and len(attributes.number_of_installment)>#attributes.number_of_installment#;<cfelse>'';</cfif>
		catalog_id=<cfif isdefined("attributes.catalog_id") and len(attributes.catalog_id)>#attributes.catalog_id#<cfelse>'';</cfif>
		unit_other=<cfif isdefined("attributes.unit_other")>'#attributes.unit_other#'<cfelse>unit_</cfif>;
		expense_center_id = <cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id)>#attributes.expense_center_id#;<cfelse>'';</cfif>
		expense_center_name = <cfif isdefined("attributes.expense_center_name") and len(attributes.expense_center_name)>'#attributes.expense_center_name#';<cfelse>'';</cfif>
		expense_item_id = <cfif isdefined("attributes.expense_item_id") and len(attributes.expense_item_id)>#attributes.expense_item_id#;<cfelse>'';</cfif>
		expense_item_name = <cfif isdefined("attributes.expense_item_name") and len(attributes.expense_item_name)>'#attributes.expense_item_name#';<cfelse>'';</cfif>
		activity_type_id = <cfif isdefined("attributes.activity_type_id") and len(attributes.activity_type_id)>#attributes.activity_type_id#;<cfelse>'';</cfif>
		bsmv_ = <cfif isdefined("attributes.bsmv_") and len(attributes.bsmv_)>#attributes.bsmv_#;<cfelse>'';</cfif>
		oiv_ = <cfif isdefined("attributes.oiv_") and len(attributes.oiv_)>#attributes.oiv_#;<cfelse>'';</cfif>
		product_detail2 = <cfif isdefined("attributes.product_detail2") and len(attributes.product_detail2)>'#attributes.product_detail2#';<cfelse>'';</cfif>
		reason_code = <cfif isdefined("attributes.reason_code") and len(attributes.reason_code)>'#attributes.reason_code#';<cfelse>'';</cfif>
		reserve_date = <cfif isdefined('attributes.reserve_date') and len(attributes.reserve_date)>'#attributes.reserve_date#';<cfelse>'';</cfif>

		<cfif isdefined('attributes.from_add_barcod') and attributes.from_add_barcod eq 1>//barkoddan seri urun ekleniyorsa
			parent.add_basket_row(product_id, stock_id, stock_code, barcod, manufact_code, product_name, unit_id_, unit_, spect_id, spect_name, price, price_other, tax, duedate, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, deliver_date, deliver_dept, department_head, lot_no, money, row_ship_id, amount_, product_account_code,is_inventory,is_production,net_maliyet,marj,extra_cost,row_promotion_id,promosyon_yuzde,promosyon_maliyet,iskonto_tutar,is_promotion,prom_stock_id,otv,product_detail2,amount_other,unit_other,ek_tutar,shelf_number,'',catalog_id,1,is_commission,'',prom_relation_id, reserve_date,list_price_,number_of_installment_,price_cat_,karma_product_id,'',ek_tutar_price,'','','','','','','','','','','','',price_other_calc,'','','','',expense_center_id,expense_center_name,expense_item_id,expense_item_name,'',price_other_calc,'',gtip_number,activity_type_id,'','','','',bsmv_,'','',oiv_,'','','',reason_code,'',specific_weight);
		<cfelse>
			if(<cfoutput>#attributes.satir#</cfoutput> == -1)
//			if (#update_product_row_id# == 0)
				{
				<cfif isdefined("attributes.config_tree")>tree_mark='_';<cfelse>tree_mark='';</cfif>
				<cfif not isdefined("attributes.from_product_config")>window.opener.</cfif>window['add_basket_row' +tree_mark](product_id, stock_id, stock_code, barcod, manufact_code, product_name, unit_id_, unit_, spect_id, spect_name, price, price_other, tax, duedate, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, deliver_date, deliver_dept, department_head, lot_no, money, row_ship_id, amount_, product_account_code,is_inventory,is_production,net_maliyet,marj,extra_cost,row_promotion_id,promosyon_yuzde,promosyon_maliyet,iskonto_tutar,is_promotion,prom_stock_id,otv,product_detail2,amount_other,unit_other,ek_tutar,shelf_number,'',catalog_id,1,is_commission,'',prom_relation_id,'',list_price_,number_of_installment_,price_cat_,karma_product_id,'',ek_tutar_price,'','','','','','','','','','',window.name,row_paymethod_id,'#stock_code_2_#','','','','',expense_center_id,expense_center_name,expense_item_id,expense_item_name,'',price_other_calc,'',gtip_number,activity_type_id,'','','','',bsmv_,'','',oiv_,'','','',reason_code,'',specific_weight);
				}
			else
				{
					window.opener.upd_row(product_id, stock_id, stock_code, barcod, manufact_code, product_name, unit_id_, unit_, spect_id, spect_name, price, price_other, tax, duedate, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, deliver_date, deliver_dept, department_head, lot_no, money, row_ship_id, amount_, product_account_code,is_inventory,is_production,net_maliyet,marj,extra_cost,row_promotion_id,promosyon_yuzde,promosyon_maliyet,iskonto_tutar,is_promotion,prom_stock_id,otv,product_detail2,'#update_product_row_id#',is_commission,catalog_id,'',amount_other,unit_other,ek_tutar,shelf_number,'',prom_relation_id,'','',1,'',list_price_,number_of_installment_,price_cat_,karma_product_id,'',ek_tutar_price,'','','','','','',window.name,row_paymethod_id,'','','#stock_code_2_#','','','','','','','','','','','',price_other_calc,gtip_number,activity_type_id,'','','','',bsmv_,'','',oiv_,'','','',reason_code,'',specific_weight);
				}
			<cfif (not isdefined("multi") or multi is 0) and not isdefined("attributes.from_product_config")>
				if(<cfoutput>#attributes.satir#</cfoutput> == -1)
				{
					/*
					Uğur Hamurpet - 05/05/2020
					Ürün seçimi yaptıktan sonra history.back işlemlerinde tarayıcı tarafınan post parametreleri yeniden isteniyor.
					Bunun için ürün filtresindeki parametreler localstorage da depolanıyor ve history.back işleminde yeniden gönderilmesi sağlanıyor 
					*/
					if (typeof(Storage) !== "undefined" && localStorage.getItem("list_product") != null) {
						var newUrl = "<cfoutput>#fusebox.server_machine_list#/#request.self#</cfoutput>?fuseaction=objects.popup_products&";
						var list_product_object = JSON.parse(localStorage.getItem("list_product"));
						
						var list_product = [];
						for(var i in list_product_object) list_product.push([i, list_product_object[i]]);
						
						list_product.forEach((el, index) => {
							newUrl += (( el[0] != 'fuseaction' ) ? (el[0] + "=" + el[1] + (( index != list_product.length ) ? "&" : "")) : '');
						});

						document.location.href = newUrl;
					}
				}else window.close();
			</cfif>
			
			<cfif isdefined("attributes.from_product_config")>
			<cfset specer_return_value_list = isdefined('attributes.specer_return_value_list') ? attributes.specer_return_value_list : specer_return_value_list>
			<cfset new_spect_var_name = isdefined('attributes.specer_return_value_list') ? listgetat(specer_return_value_list,3,',') : new_spect_var_name>
						<cfoutput>
			if(window.basket.items != undefined)
				spec_last_row=window.basket.items.length-1;
			else
				spec_last_row=basketManagerObject.basketItems().length-1;

		updateBasketItemFromPopup(spec_last_row, 
		{ 
			SPECT_ID: '#listgetat(specer_return_value_list,2,',')#', 
			SPECT_NAME: '#new_spect_var_name#' 
			<cfif isdefined("attributes.is_price_change") and attributes.is_price_change eq 1>
				,PRICE: <cfif listgetat(specer_return_value_list,4,',') gt 0>#listgetat(specer_return_value_list,4,',')#<cfelse>0</cfif>
				,PRICE_OTHER: <cfif listgetat(specer_return_value_list,5,',') gt 0>#listgetat(specer_return_value_list,5,',')#<cfelse>0</cfif>
				,OTHER_MONEY: '<cfif len(listgetat(specer_return_value_list,6,','))>#listgetat(specer_return_value_list,6,',')#<cfelse>#session.ep.money#</cfif>'
				,NET_MALIYET: #listgetat(specer_return_value_list,9,',')#
			</cfif>  
		}); </cfoutput>
						closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');
					</cfif>
		</cfif>
	 </script>
	</cfoutput>
</cfif> 