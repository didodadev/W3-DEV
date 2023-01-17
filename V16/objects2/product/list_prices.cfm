<cfset product_action = createObject("component", "cfc.data")>
<cfset dsn = application.systemParam.systemParam().dsn>
<cfset dsn1 = '#dsn#_product'>
<cfif isdefined("session.ep")><cfset session_base.our_company_id = session.ep.company_id></cfif>
<cfset session_base.production_subscription_id = attributes.production_subscription_id?:'' /><!--- Abone detayından uygulamamı genişlet tıklandığında sepette otomatik olarak abonenin seçili gelmesini sağlar --->
<cfif isdefined("attributes.variation_select") and listlen(attributes.variation_select)>
	<cfset attributes.list_variation_id = ''>
	<cfset attributes.list_property_id = ''>
	<cfloop from="1" to="#listlen(attributes.variation_select,',')#" index="ccm">
		<cfset degisken = listgetat(attributes.variation_select,ccm,',')>
		<cfif not listfindnocase(degisken,listgetat(degisken,2,'*'))>
			<cfset attributes.list_variation_id = listappend(attributes.list_variation_id,listgetat(degisken,2,'*'),',')>
		</cfif>
		<cfif not listfindnocase(degisken,listgetat(degisken,1,'*'))>
			<cfset attributes.list_property_id = listappend(attributes.list_property_id,listgetat(degisken,1,'*'),',')>
		</cfif>
	</cfloop>
</cfif>
<cfif isdefined("session.ww")>
	<cfif not isdefined("session.ww.list_type") or not len(session.ww.list_type)>
		<cfparam name="attributes.list_type" default="#attributes.is_list_type#">
	<cfelse>
		<cfparam name="attributes.list_type" default="#session.ww.list_type#">
	</cfif>
<cfelseif isdefined("session.pp")>
	<cfif not isdefined("session.pp.list_type") or not len(session.pp.list_type)>
		<cfparam name="attributes.list_type" default="#attributes.is_list_type#">
	<cfelse>
		<cfparam name="attributes.list_type" default="#session.pp.list_type#">
	</cfif>
</cfif>
<cfif isdefined("attributes.is_stock_search_product_active") and attributes.is_stock_search_product_active eq 1>
	<cfif not isdefined("form.maxrows") and not isdefined("attributes.product_order_element")>
		<cfset attributes.is_saleable_stock = 1>
	</cfif>
</cfif>
<cfif attributes.is_price eq 0 and (not isdefined('attributes.is_basket_standart') or attributes.is_basket_standart eq 1)><!--- puanli urun sepeti degilse ürün fiyatı basilmadan sepet gelmez --->
	<cfset attributes.is_basket = 0>
</cfif>
<cfif isdefined('attributes.is_basket_standart') and attributes.is_basket_standart eq 0><!--- puanli urun basketi kullanilacak ise fiyat kategorisine mutlaka baglanamali --->
	<cfset attributes.is_from_price_cat = 1>
	<cfset attributes.is_promotion = 1>
</cfif>

<cfif (isdefined("attributes.price_first_value") and len(attributes.price_first_value)) or (isdefined("attributes.price_last_value") and len(attributes.price_last_value))>
	<cfquery name="GET_DETAILS_MONEY" datasource="#DSN2#">
		SELECT
			RATE1,
			<cfif isDefined("session.pp")>
				RATEPP2 RATE2
			<cfelse>
				RATEWW2 RATE2
			</cfif>
		FROM
			SETUP_MONEY
		WHERE
			MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail_money_type#">
	</cfquery>
	<cfif isdefined("attributes.price_first_value") and len(attributes.price_first_value)>
		<cfset attributes.price_first_value = attributes.price_first_value / get_details_money.rate1 * get_details_money.rate2>
	</cfif>
	<cfif isdefined("attributes.price_last_value") and len(attributes.price_last_value)>
		<cfset attributes.price_last_value = attributes.price_last_value / get_details_money.rate1 * get_details_money.rate2>
	</cfif>
</cfif>

<cfif isdefined("attributes.anagrup") and len(attributes.anagrup) and (not isdefined("attributes.altgrup") or not len(attributes.altgrup))><cfset attributes.product_catid = attributes.anagrup></cfif>
<cfif isdefined("attributes.altgrup") and len(attributes.altgrup)><cfset attributes.product_catid = attributes.altgrup></cfif>
<cfparam name="attributes.price_catid" default="-2">
<cfparam name="attributes.price_catid_2" default="-2">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.get_company_id" default="">
<cfparam name="attributes.get_company" default="">
<cfif isdefined("attributes.product_catid") and not isdefined("attributes.product_cat")><cfset attributes.product_cat=" "></cfif>
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_catid" default="0">
<cfparam name="attributes.hierarchy" default="">
<cfparam name="attributes.short_code_id" default="">
<cfparam name="attributes.is_promotion" default="0">

<cfquery name="GET_COMPANY" datasource="#DSN#">
	SELECT FULLNAME, COMPANY_ID FROM COMPANY
</cfquery>

<cfif (isdefined("attributes.hierarchy") and len(attributes.hierarchy) and attributes.hierarchy neq 0) or (isdefined("attributes.product_catid") and len(attributes.product_catid) and attributes.product_catid neq 0)>
	
    <!---  Product_Cat --->
    <cfset GET_PRODUCT_HIERARCHY = product_action.GET_PRODUCT_HIERARCHY(
        hierarchy : '#IIf(IsDefined("attributes.hierarchy"),"attributes.hierarchy",DE(''))#',
        product_catid : '#IIf(IsDefined("attributes.product_catid"),"attributes.product_catid",DE(''))#'
    )>
<cfelse>
	<cfset get_product_hierarchy = { recordcount : 0 }>
</cfif>

<cfparam name="attributes.maxrows" default="25">

<cfif attributes.is_price or (isdefined('attributes.is_basket_standart') and attributes.is_basket_standart eq 0)>
	<!--- fiyat istenmemis ise buraya girmesi gerekmez --->
	<cfinclude template="../query/get_price_cats_moneys.cfm">
</cfif>
<cfif isdefined("attributes.is_last_user_price_list") and attributes.is_last_user_price_list eq 1 and isdefined("attributes.last_user_price_list") and not len(attributes.last_user_price_list)>
	<cfscript>
		get_price_list = DeserializeJson(product_action.GET_CREDIT_LIMIT());
		attributes.last_user_price_list = DeserializeJson(get_price_list.price_catid);
	</cfscript>
</cfif>
<!--- Ana Ürün Query --->
<cfif isdefined("attributes.search") and len(attributes.search)>
	<cfsearch
        name = "get_products"
        collection = "w_products"
        criteria = "#attributes.search#"
        contextpassages = "15"
        suggestions="always"
        status="info">
        <cfset GET_HOMEPAGE_PRODUCTS = QueryNew("PRODUCT_ID,PRODUCT_NAME,PRODUCT_DETAIL,PRODUCT_DETAIL2,PRODUCT_DETAIL_WATALOGY,BRAND_ID,PRODUCT_CATID,WATALOGY_CAT_ID,PRICE,PRICE_KDV,MONEY,PRODUCT_CODE,PRODUCT_CODE_2,PRODUCT_UNIT_ID,PROPERTY,RECORD_DATE,SEGMENT_ID,STOCK_CODE,STOCK_ID,TAX,USER_FRIENDLY_URL,ADD_UNIT,BARCOD,COMPANY_ID,IS_KARMA,IS_KDV,IS_PRODUCTION,IS_PROTOTYPE,IS_ZERO_STOCK","Integer,varchar,varchar,varchar,varchar,Integer,Integer,Integer,Double,Double,varchar,varchar,varchar,Integer,varchar,date,integer,varchar,integer,double,varchar,varchar,varchar,integer,bit,bit,bit,bit,bit")>
        <cfoutput query="get_products">
            <cfset custom_1 =listToArray(custom1,",",true)>
            <cfset custom_2 =listToArray(custom2,",",true)>
            <cfset custom_3 =listToArray(custom3,",",true)>
            <cfset custom_4 =listToArray(custom4,",",true)>
            <cfscript>
                columns=StructNew();
                columns={PRODUCT_ID="#key#",PRODUCT_NAME="#custom_1[1]#",PRODUCT_DETAIL="#custom_1[2]#",PRODUCT_DETAIL2="#custom_1[3]#",PRODUCT_DETAIL_WATALOGY="#custom_1[4]#",BRAND_ID="#custom_2[1]#",PRODUCT_CATID="#custom_2[2]#",WATALOGY_CAT_ID="#custom_2[3]#",PRICE="#custom_2[4]#",PRICE_KDV="#custom_2[5]#",MONEY="#custom_3[1]#",PRODUCT_CODE="#custom_3[2]#",PRODUCT_CODE_2="#custom_3[3]#",PRODUCT_UNIT_ID="#custom_3[4]#",PROPERTY="#custom_3[5]#",RECORD_DATE="#custom_3[6]#",SEGMENT_ID="#custom_3[7]#",STOCK_CODE="#custom_3[8]#",STOCK_ID="#custom_3[9]#",TAX="#custom_3[10]#",USER_FRIENDLY_URL="#custom_3[11]#",ADD_UNIT="#custom_4[1]#",BARCOD="#custom_4[2]#",COMPANY_ID="#custom_4[3]#",IS_KARMA="#custom_4[4]#",IS_KDV="#custom_4[5]#",IS_PRODUCTION="#custom_4[6]#",IS_PROTOTYPE="#custom_4[7]#",IS_ZERO_STOCK="#custom_4[8]#"};                
                QueryAddRow(GET_HOMEPAGE_PRODUCTS,columns);                
            </cfscript>
        </cfoutput>
		<cfif isDefined("attributes.list_property_id") and len(attributes.list_property_id)>
			<cfquery name="pro_productids"  datasource="#dsn1#">
 				SELECT
					PRODUCT_ID
				FROM
					PRODUCT_DT_PROPERTIES
				WHERE
				(
					<cfloop from="1" to="#listlen(attributes.list_property_id,',')#" index="pro_ind">
						(PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.list_property_id,pro_ind,",")#"> AND VARIATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.list_variation_id,pro_ind,",")#">)
						<cfif pro_ind lt listlen(attributes.list_property_id,',')>OR</cfif>
					</cfloop>
				)
				GROUP BY
					PRODUCT_ID
				HAVING
					COUNT(PRODUCT_ID)> = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlen(attributes.list_property_id,',')#">
			</cfquery>
			<cfset pro_productid_list = valuelist(pro_productids.PRODUCT_ID)>
		</cfif>
		<cfquery name="GET_HOMEPAGE_PRODUCTS" dbtype="query">
			SELECT
				*   
			FROM
				GET_HOMEPAGE_PRODUCTS 
			WHERE
				1=1
				<cfif isDefined("attributes.brand_id") and len(attributes.brand_id)>
					AND BRAND_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#" list="yes">)
				</cfif>
				<cfif isDefined("attributes.product_cat_list") and len(attributes.product_cat_list)>
					AND PRODUCT_CATID  IN(<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#" list="yes">)
				</cfif>
				<cfif isDefined("pro_productid_list") and len(pro_productid_list)>
                    AND PRODUCT_ID IN( <cfqueryparam cfsqltype="cf_sql_integer" value="#pro_productid_list#" list="yes">)
                </cfif>
		</cfquery>
		
		<p><cfoutput>"#attributes.search#" için #GET_HOMEPAGE_PRODUCTS.recordcount# farklı kayıt listeleniyor.</cfoutput></p>		
<cfelse>
	<cfset GET_HOMEPAGE_PRODUCTS = product_action.GET_HOMEPAGE_PRODUCTS(
		new_products : '#IIf(IsDefined("attributes.new_products"),"attributes.new_products",DE(''))#',
		high_sales : '#IIf(IsDefined("attributes.high_sales"),"attributes.high_sales",DE(''))#',
		is_basket_standart : '#IIf(IsDefined("attributes.is_basket_standart"),"attributes.is_basket_standart",DE(''))#',
		is_prod_company : '#IIf(IsDefined("attributes.is_prod_company"),"attributes.is_prod_company",DE(''))#',
		is_from_price_cat : '#IIf(IsDefined("attributes.is_from_price_cat"),"attributes.is_from_price_cat",DE(''))#',
		last_user_price_list : '#IIf(IsDefined("attributes.last_user_price_list"),"attributes.last_user_price_list",DE(''))#',
		price_first_value : '#IIf(IsDefined("attributes.price_first_value"),"attributes.price_first_value",DE(''))#',
		price_last_value : '#IIf(IsDefined("attributes.price_last_value"),"attributes.price_last_value",DE(''))#',
		price_catid : '#IIf(IsDefined("attributes.price_catid"),"attributes.price_catid",DE(''))#',
		all_product_id : '#IIf(IsDefined("attributes.all_product_id"),"attributes.all_product_id",DE(''))#',
		is_prices_brand : '#IIf(IsDefined("attributes.is_prices_brand"),"attributes.is_prices_brand",DE(''))#',
		is_prices_category : '#IIf(IsDefined("attributes.is_prices_category"),"attributes.is_prices_category",DE(''))#',
		is_saleable_stock : '#IIf(IsDefined("attributes.is_saleable_stock"),"attributes.is_saleable_stock",DE(''))#',
		listing_by_sale : '#IIf(IsDefined("attributes.listing_by_sale"),"attributes.listing_by_sale",DE(''))#',
		price_productid_list : '#IIf(IsDefined("attributes.price_productid_list"),"attributes.price_productid_list",DE(''))#',
		favourities_list : '#IIf(IsDefined("attributes.favourities_list"),"attributes.favourities_list",DE(''))#',
		promotion_stock_list : '#IIf(IsDefined("attributes.promotion_stock_list"),"attributes.promotion_stock_list",DE(''))#',
		segment_id : '#IIf(IsDefined("attributes.segment_id"),"attributes.segment_id",DE(''))#',
		keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(''))#',
		is_detail_keyword_search : '#IIf(IsDefined("attributes.is_detail_keyword_search"),"attributes.is_detail_keyword_search",DE(''))#',
		hierarchy_keyword : '#IIf(IsDefined("attributes.hierarchy_keyword"),"attributes.hierarchy_keyword",DE(''))#',
		brand_id : '#IIf(IsDefined("attributes.brand_id"),"attributes.brand_id",DE(''))#',
		short_code_id : '#IIf(IsDefined("attributes.short_code_id"),"attributes.short_code_id",DE(''))#',
		list_property_id : '#IIf(IsDefined("attributes.list_property_id"),"attributes.list_property_id",DE(''))#',
		list_variation_id : '#IIf(IsDefined("attributes.list_variation_id"),"attributes.list_variation_id",DE(''))#',
		is_detail_search_prototype : '#IIf(IsDefined("attributes.is_detail_search_prototype"),"attributes.is_detail_search_prototype",DE(''))#',
		is_only_sale_product : '#IIf(IsDefined("attributes.is_only_sale_product"),"attributes.is_only_sale_product",DE(''))#',
		product_order_by : '#IIf(IsDefined("attributes.product_order_by"),"attributes.product_order_by",DE(''))#',
		product_order_element : '#IIf(IsDefined("attributes.product_order_element"),"attributes.product_order_element",DE(''))#',
		is_purchase : '#IIf(IsDefined("attributes.is_purchase"),"attributes.is_purchase",DE(''))#',
		hierarchy : '#IIf(IsDefined("attributes.hierarchy"),"attributes.hierarchy",DE(''))#',
		product_catid : '#IIf(IsDefined("attributes.product_catid"),"attributes.product_catid",DE(''))#',
		product_types : '#IIf(IsDefined("attributes.product_types"),"attributes.product_types",DE(''))#',
		detail_search_keyword : '#IIf(IsDefined("attributes.detail_search_keyword"),"attributes.detail_search_keyword",DE(''))#',
		product_order_type : '#IIf(IsDefined("attributes.product_order_type"),"attributes.product_order_type",DE(''))#',
		is_show_all_stock: '#IIf(IsDefined("attributes.is_show_all_stock"),"attributes.is_show_all_stock",DE(''))#',
		stock_mod_ : '#IIf(IsDefined("stock_mod_"),"stock_mod_",DE(''))#'
	)>
</cfif>
	
<cfset adres = "/Product?">
<!--- <cfif fusebox.fuseaction is 'user_friendly'>
	<cfset adres = adres & "&user_friendly_url=#attributes.user_friendly_url#">
</cfif> --->
<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
	<cfset adres = adres & "&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.search") and len(attributes.search)>
	<cfset adres = adres & "&search=#attributes.search#">
</cfif>
<cfif isdefined("attributes.camp_id") and len(attributes.camp_id)>
	<cfset adres = adres & "&camp_id=#attributes.camp_id#">
</cfif>
<cfif isdefined("attributes.product_catid") and len(attributes.product_catid) and len(attributes.product_cat)>
	<cfset adres = adres & "&product_catid=#attributes.product_catid#">
	<cfset adres = adres & "&product_cat=#attributes.product_cat#">
</cfif>
<!--- <cfif isdefined("get_product_hierarchy.hierarchy") and len(get_product_hierarchy.hierarchy)>
	<cfset adres = adres & "&hierarchy=#get_product_hierarchy.hierarchy#">
</cfif> --->
<cfif isdefined("attributes.brand_id") and len(attributes.brand_id)>
	<cfset adres = adres & "&brand_id=#attributes.brand_id#">
</cfif>
<cfif isdefined("attributes.short_code_id") and len(attributes.short_code_id)>
	<cfset adres = adres & "&short_code_id=#attributes.short_code_id#">
</cfif>
<cfif isdefined("attributes.segment_id") and len(attributes.segment_id)>
	<cfset adres = adres & "&segment_id=#attributes.segment_id#">
</cfif>
<cfif isdefined("attributes.list_property_id") and len(attributes.list_property_id)>
	<cfset adres = adres & "&list_property_id=#attributes.list_property_id#">
</cfif>
<cfif isdefined("attributes.list_variation_id") and len(attributes.list_variation_id)>
	<cfset adres = adres & "&list_variation_id=#attributes.list_variation_id#">
</cfif>
<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
	<cfset adres = adres & "&company_id=#attributes.company_id#">
</cfif>
<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
	<cfset adres = adres & "&consumer_id=#attributes.consumer_id#">
</cfif>
<cfif isdefined('attributes.is_saleable_stock')>
	<cfset adres = "&is_saleable_stock=#attributes.is_saleable_stock#">
</cfif>
<cfif isdefined("attributes.price_first_value") and len(attributes.price_first_value)>
	<cfset adres = adres & "&price_first_value=#attributes.price_first_value#">
</cfif>
<cfif isdefined("attributes.price_last_value") and len(attributes.price_last_value)>
	<cfset adres = adres & "&price_last_value=#attributes.price_last_value#">
</cfif>
<cfif isdefined("attributes.detail_money_type") and len(attributes.detail_money_type)>
	<cfset adres = adres & "&detail_money_type=#attributes.detail_money_type#">
</cfif>
<cfif isdefined("attributes.detail_search_keyword") and len(attributes.detail_search_keyword)>
	<cfset adres = adres & "&detail_search_keyword=#attributes.detail_search_keyword#">
</cfif>
<cfif isdefined("attributes.hierarchy_keyword") and len(attributes.hierarchy_keyword)>
	<cfset adres = adres & "&hierarchy_keyword=#attributes.hierarchy_keyword#">
</cfif>
<cfif isdefined("attributes.main_category") and len(attributes.main_category)>
	<cfset adres = adres & "&main_category=#attributes.main_category#">
</cfif>
<cfif isdefined("attributes.main_category2") and len(attributes.main_category2)>
	<cfset adres = adres & "&main_category2=#attributes.main_category2#">
</cfif>
<cfif isdefined("attributes.main_category3") and len(attributes.main_category3)>
	<cfset adres = adres & "&main_category3=#attributes.main_category3#">
</cfif>
<cfif isdefined("attributes.main_category4") and len(attributes.main_category4)>
	<cfset adres = adres & "&main_category4=#attributes.main_category4#">
</cfif>
<cfif isdefined("attributes.hierarchy") and len(attributes.hierarchy)>
	<cfset adres = adres & "&hierarchy=#attributes.hierarchy#">
</cfif>
<cfif isdefined("attributes.all_product_id") and len(attributes.all_product_id)>
	<cfset adres = adres & "&all_product_id=#attributes.all_product_id#"><!--- ürünle iliskili ürünlerin tümünü getirmek icin --->
</cfif>
<cfif isdefined("attributes.product_order_by") and len(attributes.product_order_by)>
	<cfset adres = adres & "&product_order_by=#attributes.product_order_by#">
</cfif>
<cfif isdefined("attributes.view_mode") and len(attributes.view_mode)>
	<cfset adres = adres & "&view_mode=#attributes.view_mode#">
</cfif>
<cfif isdefined("attributes.view_mode_col") and len(attributes.view_mode_col)>
	<cfset adres = adres & "&view_mode_col=#attributes.view_mode_col#">
</cfif>
<cfif isdefined("attributes.product_types") and len(attributes.product_types)>
	<cfset adres = adres & "&product_types=#attributes.product_types#">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default='#get_homepage_products.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfset stock_list=''>
<cfset brand_list = ''>
<cfset add_basket_express_prod_id_list = ''>
<cfset segment_list = ''>
<cfif get_homepage_products.recordcount>
	<cfoutput query="get_homepage_products" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<cfset add_basket_express_prod_id_list = listappend(add_basket_express_prod_id_list,product_id)>
		<cfset stock_list = listappend(stock_list,stock_id)>
		<cfif attributes.is_brand>
			<cfif not listfindnocase(brand_list,get_homepage_products.brand_id)>
				<cfset brand_list = listappend(brand_list,get_homepage_products.brand_id,',')>
			</cfif>
		</cfif>
	</cfoutput> 
</cfif>

<cfif ((attributes.is_stock_count eq 1) or (attributes.is_basket eq 1) or (attributes.is_basket eq 2 and isdefined('session_base.userid'))) and len(stock_list)>
	<cfquery name="GET_STOCK_LAST" datasource="#DSN2#">
		<cfif isdefined("attributes.is_stock_count_dept") and len(attributes.is_stock_count_dept) and listlen(attributes.is_stock_count_dept,'-') eq 2>
            get_stock_last_location_function '#stock_list#'
		<cfelseif isdefined("session.ww.department_ids") and len(session.ww.department_ids)>
			get_stock_last_location_function '#stock_list#'
        <cfelseif isdefined("session.pp.department_ids") and len(session.pp.department_ids)>
			get_stock_last_location_function '#stock_list#'
		<cfelse>
			get_stock_last_function '#stock_list#'
		</cfif>
	</cfquery>
	<cfquery name="GET_LAST_STOCKS" dbtype="query">
		SELECT
			SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
            SUM(SALEABLE_STOCK) AS SALEABLE_STOCK,
            SUM(PURCHASE_ORDER_STOCK) AS PURCHASE_ORDER_STOCK,
            STOCK_ID
		FROM
			GET_STOCK_LAST
		<cfif isdefined("attributes.is_stock_count_dept") and len(attributes.is_stock_count_dept) and listlen(attributes.is_stock_count_dept,'-') eq 2>
            WHERE
                DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.is_stock_count_dept,1,'-')#"> AND 
                LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.is_stock_count_dept,2,'-')#">
		<cfelseif isdefined("session.ww.department_ids") and len(session.ww.department_ids)>
            WHERE
                DEPARTMENT_ID IN (#session.ww.department_ids#)
        <cfelseif isdefined("session.pp.department_ids") and len(session.pp.department_ids)>
        	WHERE
                DEPARTMENT_ID IN (#session.pp.department_ids#)
        </cfif>
       	GROUP BY 
	        STOCK_ID
		ORDER BY 
			STOCK_ID
	</cfquery>
	<cfset stock_count_stock_list = listsort(valuelist(get_last_stocks.stock_id),'numeric','ASC')>
</cfif>

<cfif len(stock_list)>
    <!--- ? promosyon query --->
    <cfset GET_PROM_ALL = product_action.GET_PROM_ALL( stock_list : #stock_list# )>

	<cfif get_prom_all.recordcount>
		<cfset promotion_stock_list = valuelist(get_prom_all.stock_id)>
		<cfquery name="GET_STOCK_LAST" datasource="#DSN2#">
			<cfif isdefined("session.ww.department_ids") and len(session.ww.department_ids)>
                get_stock_last_location_function '#promotion_stock_list#'
            <cfelseif isdefined("session.pp.department_ids") and len(session.pp.department_ids)>
                get_stock_last_location_function '#promotion_stock_list#'
            <cfelse>
	            get_stock_last_function '#promotion_stock_list#'
            </cfif>
		</cfquery>
		<cfquery name="GET_LAST_STOCKS_PROMOTIONS" dbtype="query">
			SELECT 
				SUM(PRODUCT_STOCK) AS PRODUCT_STOCK,
                SUM(SALEABLE_STOCK) AS SALEABLE_STOCK,
                SUM(PURCHASE_ORDER_STOCK) AS PURCHASE_ORDER_STOCK,
                STOCK_ID
			FROM
				GET_STOCK_LAST
				<cfif isdefined("session.ww.department_ids") and len(session.ww.department_ids)>
                    WHERE
                        DEPARTMENT_ID IN (#session.ww.department_ids#)
                <cfelseif isdefined("session.pp.department_ids") and len(session.pp.department_ids)>
                    WHERE
                        DEPARTMENT_ID IN (#session.pp.department_ids#)
                </cfif>
            GROUP BY STOCK_ID
			ORDER BY STOCK_ID
		</cfquery>
		<cfset promotion_stock_list = listsort(valuelist(get_last_stocks_promotions.stock_id),'numeric','ASC')>
	</cfif>
</cfif>

<cfif attributes.is_price>
    <cfset product_action.price_catid = attributes.price_catid>
    <cfset GET_PRICE_ALL = product_action.GET_PRICE_ALL(
                                                            company_id : '#IIf(IsDefined("attributes.company_id"),"attributes.company_id",DE(''))#',
                                                            consumer_id : '#IIf(IsDefined("attributes.consumer_id"),"attributes.consumer_id",DE(''))#',
                                                            price_catid : '#IIf(IsDefined("attributes.price_catid"),"attributes.price_catid",DE(''))#',
                                                            employee : '#IIf(IsDefined("attributes.employee"),"attributes.employee",DE(''))#',
                                                            pos_code : '#IIf(IsDefined("attributes.pos_code"),"attributes.pos_code",DE(''))#', 
                                                            get_company : '#IIf(IsDefined("attributes.get_company"),"attributes.get_company",DE(''))#', 
                                                            get_company_id : '#IIf(IsDefined("attributes.get_company_id"),"attributes.get_company_id",DE(''))#', 
                                                            brand_id : '#IIf(IsDefined("attributes.brand_id"),"attributes.brand_id",DE(''))#',
                                                            keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(''))#',
                                                            sepet_process_type : '#IIf(IsDefined("attributes.sepet_process_type"),"attributes.sepet_process_type",DE(''))#'
                                                        )>

	<!--- <cfinclude template="../query/get_price_all.cfm"> --->
    
	<cfset add_basket_express_prod_id_list = ''><!--- kesinlikle silinmesin yo29122008 --->

    <cfset catalog_list = listsort(listdeleteduplicates(valuelist(get_price_all.catalog_id,',')),'numeric','ASC',',')>
	<cfif listlen(catalog_list)>
		<cfquery name="GET_CATALOGS" datasource="#DSN3#">
			SELECT CATALOG_ID,CATALOG_HEAD FROM CATALOG_PROMOTION WHERE CATALOG_ID IN (#catalog_list#)
		</cfquery>
	</cfif>
</cfif>
<cfset product_all_list = "">          

<div id="product_bar" class="<cfoutput>#attributes.view_mode?:'product_list'#</cfoutput>">
	<cfif isdefined("session.ww")>
		<cfset session.ww.list_type = 1>
	<cfelseif  isdefined("session.pp")>
		<cfset session.pp.list_type = 1>
	</cfif> 
	<cfif isDefined("attributes.view_mode") and attributes.view_mode eq 'product_table'><!--- Görüntüleme modu product_table olarak seçildiyse --->
		<table class="table table-hover">
			<thead>
				<tr>
					<th width="20">#</th>
					<th width="40">SKU</th>
					<th width="340"><cf_get_lang dictionary_id='36199.Açıklama'></th>
					<th width="100">Watalogy ID</th>
					<th width="80"><cf_get_lang dictionary_id='57633.Barkod'></th>
					<th width="50"><cf_get_lang dictionary_id='57636.Birim'></th>
					<th width="120" class="text-right"><cf_get_lang dictionary_id='58084.Fiyat'></th>
					<th width="100"><cf_get_lang dictionary_id='57635.Miktar'></th>
					<th width="20" class="text-center"></th>
				</tr>
			</thead>
			<tbody>
	</cfif>
	<cfinclude template="list_prices2.cfm">
	<cfif isDefined("attributes.view_mode") and attributes.view_mode eq 'product_table'><!--- Görüntüleme modu product_table olarak seçildiyse --->
			</tbody>
		</table>
	</cfif>
</div>

<cfif attributes.totalrecords gt attributes.maxrows>
	<cf_pages page="#attributes.page#" 
				page_type="2" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				button_type="1" 
				startrow="#attributes.startrow#" 
				adres="#adres#">
</cfif>

<script type="text/javascript">		
	<cfif attributes.product_compare eq 1>
		function karsilastir()
		{  
			secilenler = '';
			kontrol = 0;
			ek_ = 0;
			
			if(isDefined('product_id'))
			{
				if(document.getElementsByName('product_id') != undefined)
				{
					for (i=0; i < document.getElementsByName('product_id').length; i++)
					{
						if(document.getElementsByName('product_id')[i].checked == true)
						{
							kontrol = kontrol + 1;
							if(secilenler.length==0)
								secilenler = document.getElementsByName('product_id')[i].value;
							else
								secilenler = secilenler + ',' + document.getElementsByName('product_id')[i].value;
						}
					}
				}
				else
				{
					if(document.getElementsByName('product_id').checked == true)
					{
						kontrol = kontrol + 1;
						if(secilenler.length==0)
							secilenler = document.getElementsByName('product_id').value;
						else
							secilenler = secilenler + ',' + document.getElementsByName('product_id').value;
					}
				}
			}
			
			if(isDefined('prom_product_id'))
			{
				if(document.getElementsByName('prom_product_id') != undefined)
				{
					for (i=0; i < document.getElementsByName('prom_product_id').length; i++)
					{
						if(document.getElementsByName('prom_product_id')[i].checked == true)
						{
							kontrol = kontrol + 1;
							if(secilenler.length==0)
								secilenler = document.getElementsByName('prom_product_id')[i].value;
							else
								secilenler = secilenler + ',' + document.getElementsByName('prom_product_id')[i].value;
						}
					}
				}
				else
				{
					if(document.getElementsByName('prom_product_id').checked == true)
					{
						kontrol = kontrol + 1;
						if(secilenler.length==0)
							secilenler = document.getElementById('prom_product_id').value;
						else
							secilenler = secilenler + ',' + document.getElementById('prom_product_id').value;
					}
				}
			}
			if(kontrol > 4)
			{
				alert('<cf_get_lang no="1148.Dörtten Fazla Ürünle Karşılaştırma Yapılamaz!">');
				return false;
			}
			if(kontrol >= 2)
				windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.product_compare&product_id='+secilenler+'','wide2');
				/*window.location.href='<cfoutput>#request.self#?fuseaction=objects2.product_compare&product_id=</cfoutput>'+secilenler;*/
			else
			{
				alert('<cf_get_lang_main no="815.Ürün seçmelisiniz !">');
				return false;
			}
		}
	</cfif>
</script>
