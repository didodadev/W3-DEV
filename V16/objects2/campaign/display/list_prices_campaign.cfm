<cfset attributes.is_get_prom_products = 1><!--- default 0 olarak kalsın --->
<cfparam name="attributes.product_compare" default="1">
<cfparam name="attributes.is_basket" default="1">
<cfparam name="attributes.is_brand" default="1">
<cfparam name="attributes.is_stock_count" default="0">
<cfparam name="attributes.is_image" default="1">
<cfparam name="attributes.is_popup" default="0">
<cfparam name="attributes.is_price" default="1">
<cfparam name="attributes.is_demand" default="1">
<cfif attributes.is_price eq 0 and attributes.is_basket eq 1>
	<cfset attributes.is_basket = 0>
</cfif>
<cfif attributes.is_basket eq 1>
	<cfset attributes.is_stock_count = 1>
</cfif>

<cfparam name="attributes.price_catid" default="-2">
<cfparam name="attributes.price_catid_2" default="-2">
<cfif attributes.is_price eq 1> <!--- fiyat yapilmamis ise bu bloga girmez --->
	<cfinclude template="../../query/get_price_cats_moneys.cfm">
</cfif>	<!--- fiyat yapilmamis ise bu bloga girmez --->

<cfquery name="GET_PAYMETHODS" datasource="#DSN3#">
	SELECT PAYMETHOD_ID FROM CAMPAIGN_PAYMETHODS WHERE CAMPAIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#">
</cfquery>

<cfquery name="GET_HOMEPAGE_PRODUCTS" datasource="#DSN3#" maxrows="10">
	SELECT 
		DISTINCT
			CP.CATALOG_ID,
			CP.CATALOG_HEAD, 
			CPP.ACTION_PRICE_DISCOUNT AS TUTAR_INDIRIMI,
			CPP.ACTION_PRICE AS KAMPANYA_FIYATI,
			CPP.ACTION_PRICE_KDVSIZ AS KAMPANYA_FIYATI_KDVSIZ,
			CPP.MONEY AS KAMPANYA_MONEY,
			STOCKS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			STOCKS.STOCK_CODE,
			GS.PRODUCT_STOCK, 
			PRODUCT.PRODUCT_NAME,
			STOCKS.PROPERTY,
			STOCKS.BARCOD,
			PRODUCT.TAX,
			PRODUCT.BRAND_ID,
			PRODUCT.IS_ZERO_STOCK,
			PRODUCT.PRODUCT_CODE,
			PRODUCT.PRODUCT_DETAIL,
			PRODUCT.PRODUCT_CATID,
			PRODUCT.RECORD_DATE,
			PRODUCT.IS_PRODUCTION,
			STOCKS.PRODUCT_UNIT_ID,
			PRICE_STANDART.PRICE PRICE,
			PRICE_STANDART.MONEY MONEY,
			PRICE_STANDART.IS_KDV IS_KDV,
			PRICE_STANDART.PRICE_KDV PRICE_KDV
		FROM
			PRODUCT,
			PRODUCT_CAT,
			PRICE_STANDART,
			STOCKS,
			#dsn2_alias#.GET_STOCK GS,
			PRODUCT_UNIT,
			CATALOG_PROMOTION_PRODUCTS AS CPP,
			CATALOG_PROMOTION AS CP
		WHERE
			CP.CATALOG_STATUS = 1 AND
			CP.STAGE_ID = -2 AND
			<cfif attributes.price_catid neq -2>
				CP.CATALOG_ID IN (SELECT CPL.CATALOG_PROMOTION_ID FROM CATALOG_PRICE_LISTS AS CPL WHERE CPL.CATALOG_PROMOTION_ID = CP.CATALOG_ID AND PRICE_LIST_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#">) AND
			<cfelse>
				CP.CATALOG_ID IN (SELECT CPL.CATALOG_PROMOTION_ID FROM CATALOG_PRICE_LISTS AS CPL WHERE CPL.CATALOG_PROMOTION_ID = CP.CATALOG_ID AND CP.IS_PUBLIC = 1) AND			
			</cfif>		
			CP.CATALOG_ID = CPP.CATALOG_ID AND 
			PRODUCT.PRODUCT_ID = CPP.PRODUCT_ID AND
			PRICE > 0 AND
			PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
			PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID AND
			PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
			STOCKS.PRODUCT_UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND
			GS.STOCK_ID = STOCKS.STOCK_ID AND
			PRODUCT_UNIT.IS_MAIN = 1 AND			
			<cfif isdefined("session.pp")>PRODUCT.IS_EXTRANET = 1 AND<cfelse>PRODUCT.IS_INTERNET = 1 AND</cfif>
			PRODUCT.PRODUCT_STATUS = 1 AND
			PRICE_STANDART.PRICESTANDART_STATUS = 1	AND
			PRICE_STANDART.PURCHASESALES = 1 AND
			PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
			PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID
			<cfif attributes.is_get_prom_products eq 1>
                UNION ALL
                    SELECT DISTINCT
                        '' AS CATALOG_ID,
                        '' AS CATALOG_HEAD,
                        0 AS TUTAR_INDIRIMI,
                        PRICE.PRICE AS KAMPANYA_FIYATI_KDVSIZ,
                        PRICE.PRICE_KDV AS KAMPANYA_FIYATI,
                        PRICE.MONEY AS KAMPANYA_MONEY,
                        STOCKS.STOCK_ID,
                        STOCKS.PRODUCT_ID,
                        STOCKS.STOCK_CODE,
                        GS.PRODUCT_STOCK, 
                        PRODUCT.PRODUCT_NAME,
                        STOCKS.PROPERTY,
                        STOCKS.BARCOD,
                        PRODUCT.TAX,
                        PRODUCT.BRAND_ID,
                        PRODUCT.IS_ZERO_STOCK,
                        PRODUCT.PRODUCT_CODE,
                        PRODUCT.PRODUCT_DETAIL,
                        PRODUCT.PRODUCT_CATID,
                        PRODUCT.RECORD_DATE,
                        PRODUCT.IS_PRODUCTION,
                        STOCKS.PRODUCT_UNIT_ID,
                        PRICE_STANDART.PRICE PRICE,
                        PRICE_STANDART.MONEY MONEY,
                        PRICE_STANDART.IS_KDV IS_KDV,
                        PRICE_STANDART.PRICE_KDV PRICE_KDV
                    FROM
                        PRODUCT,
                        PRODUCT_CAT,
                        PRICE_STANDART,
                        STOCKS,
                        #dsn2_alias#.GET_STOCK GS,
                        PRODUCT_UNIT,
                        PRICE,
                        PROMOTIONS
                    WHERE
                        PRODUCT.PRODUCT_ID NOT IN (SELECT PRODUCT_ID FROM CATALOG_PROMOTION_PRODUCTS CPP,CATALOG_PROMOTION CP WHERE CP.CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#"> AND CP.CATALOG_ID = CPP.CATALOG_ID) AND
                        PRICE.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
                        <cfif isdefined("attributes.price_catid")>
                            PRICE.PRICE_CATID = <cfqueryparam value="#attributes.price_catid#" cfsqltype="cf_sql_integer"> AND
                        </cfif>
                        PRICE.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND 
                        (PRICE.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> OR PRICE.FINISHDATE IS NULL) AND
                        PROMOTIONS.CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#"> AND
                        STOCKS.STOCK_ID = PROMOTIONS.STOCK_ID AND
                        PRICE.PRICE > 0 AND
                        PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
                        PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID AND
                        PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
                        STOCKS.PRODUCT_UNIT_ID = PRODUCT_UNIT.PRODUCT_UNIT_ID AND
                        GS.STOCK_ID = STOCKS.STOCK_ID AND
                        PRODUCT_UNIT.IS_MAIN = 1 AND			
                        <cfif isdefined("session.pp")>PRODUCT.IS_EXTRANET = 1 AND<cfelse>PRODUCT.IS_INTERNET = 1 AND</cfif>
                        PRODUCT.PRODUCT_STATUS = 1 AND
                        PRICE_STANDART.PRICESTANDART_STATUS = 1	AND
                        PRICE_STANDART.PURCHASESALES = 1 AND
                        PRICE_STANDART.PRODUCT_ID = STOCKS.PRODUCT_ID AND
                        PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID		
			</cfif>
		ORDER BY
			<cfif not isdefined("attributes.order_element")>
				PRODUCT.PRODUCT_NAME
			<cfelseif attributes.order_element is 'PRODUCT_STOCK'>
				GS.PRODUCT_STOCK <cfoutput>#attributes.order_type#</cfoutput>
			<cfelseif attributes.order_element is 'PRODUCT_NAME'>
				PRODUCT.PRODUCT_NAME <cfoutput>#attributes.order_type#</cfoutput>	
			<cfelseif attributes.order_element is 'PRICE'>
				PRICE_STANDART.PRICE <cfoutput>#attributes.order_type#</cfoutput>
			<cfelse>
				PRODUCT.PRODUCT_NAME
			</cfif>
</cfquery>
<cfset adres = "#fusebox.circuit#.#fusebox.fuseaction#">
<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
	<cfset adres = adres & "&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.product_catid") and len(attributes.product_catid) and len(attributes.product_cat)>
	<cfset adres = adres & "&product_catid=#attributes.product_catid#">
	<cfset adres = adres & "&product_cat=#attributes.product_cat#">
</cfif>
<cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and len(attributes.brand_name)>
	<cfset adres = adres & "&brand_id=#attributes.brand_id#">
	<cfset adres = adres & "&brand_name=#attributes.brand_name#">
</cfif>
<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
	<cfset adres = adres & "&company_id=#attributes.company_id#">
</cfif>
<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
	<cfset adres = adres & "&consumer_id=#attributes.consumer_id#">
</cfif>

<cfset stock_list="">
<cfset brand_list = ''>
<cfset product_id_list = ''>
<cfoutput query="get_homepage_products">
	<cfset stock_list = listappend(stock_list,stock_id)>
	<cfif attributes.is_brand>
		<cfset brand_list = listappend(brand_list,get_homepage_products.brand_id,',')>
	</cfif>
	<cfif attributes.is_image>
		<cfif not listfindnocase(product_id_list,get_homepage_products.product_id)>
			<cfset product_id_list = listappend(product_id_list,get_homepage_products.product_id,',')>
		</cfif>	
	</cfif>
</cfoutput>

<cfif listlen(stock_list) and attributes.is_stock_count>
	<cfinclude template="../../product/get_artan_azalan_stock.cfm">
</cfif>

<cfif len(stock_list)>
	<cfquery name="GET_PROM_ALL" datasource="#DSN3#">
		SELECT
			PROMOTIONS.DISCOUNT,
			PROMOTIONS.AMOUNT_DISCOUNT,
			PROMOTIONS.AMOUNT_DISCOUNT_MONEY_1,
			PROMOTIONS.TOTAL_PROMOTION_COST,
			PROMOTIONS.PROM_HEAD,
			PROMOTIONS.FREE_STOCK_ID,
			PROMOTIONS.PROM_ID,
			PROMOTIONS.LIMIT_VALUE,
			PROMOTIONS.FREE_STOCK_AMOUNT,
			PROMOTIONS.COMPANY_ID,
			PROMOTIONS.PROM_POINT,
			PROMOTIONS.FREE_STOCK_PRICE,
			PROMOTIONS.AMOUNT_1_MONEY,
			PROMOTIONS.PRICE_CATID,
			PROMOTIONS.ICON_ID,			
			STOCKS.STOCK_ID
		FROM
			STOCKS,
			PROMOTIONS
		WHERE
			PROMOTIONS.CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.camp_id#"> AND
			PROMOTIONS.PROM_STATUS = 1 AND 	
			PROMOTIONS.PROM_TYPE = 1 AND 	
			PROMOTIONS.LIMIT_TYPE = 1 AND
			STOCKS.STOCK_ID IN (#stock_list#) AND
			(
				STOCKS.STOCK_ID = PROMOTIONS.STOCK_ID OR
				STOCKS.BRAND_ID = PROMOTIONS.BRAND_ID OR
				STOCKS.PRODUCT_CATID = PROMOTIONS.PRODUCT_CATID
			) AND
			PROMOTIONS.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
			PROMOTIONS.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
	</cfquery>
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

<cfset product_all_list = "">
<table cellspacing="0" cellpadding="0" align="center" style="width:100%;">
	<cfif attributes.product_compare eq 1>
		<tr style="height:25px;">
			<td><a href="javascript://" onclick="karsilastir();" class="prod_karsila"></a></td>
		</tr>
	</cfif>
  	<tr>
		<td>
			<table cellpadding="2" cellspacing="1" style="width:100%;">
				<tr class="color-header" style="height:20px;">
                    <cfif attributes.product_compare eq 1><td style="width:20px;"></td></cfif>
					<cfif attributes.is_image eq 1><td style="width:20px;"></td></cfif>
					<cfif attributes.is_brand eq 1><td class="form-title"><cf_get_lang_main no='1435.Marka'></td></cfif>
					<td class="form-title"><cf_get_lang_main no='245.Ürün'></td>
					<cfif attributes.is_price eq 1>
						<cfif isdefined('session.pp.userid')><td  class="form-title" style="text-align:right; width:10%;">Fiyat</td></cfif>
						<td  class="form-title" style="text-align:right; width:10%;"><cf_get_lang no='272.Kampanya Fiyatı'></td>
					</cfif>
					<cfif attributes.is_basket eq 1>
						<td class="form-title" style="width:40px;"><cf_get_lang_main no='223.Miktar'></td>
						<td style="width:25px;"></td>
					</cfif>
					<cfif (isdefined("session.ww.userid") or isdefined("session.pp.userid")) and attributes.is_demand eq 1><td></td></cfif>
				</tr>
		 		<cfif get_homepage_products.recordcount>
					<cfif attributes.is_brand>
						<cfset brand_list=listsort(brand_list,"numeric","ASC",",")>
						<cfif listlen(brand_list)>
							<cfquery name="GET_BRANDS" datasource="#DSN3#">
								SELECT BRAND_NAME,BRAND_ID FROM PRODUCT_BRANDS WHERE BRAND_ID IN (#brand_list#)
							</cfquery>
							<cfset main_brand_list = listsort(listdeleteduplicates(valuelist(get_brands.brand_id,',')),'numeric','ASC',',')>
						</cfif>
					</cfif>
					<cfif attributes.is_image eq 1>
						<cfif listlen(product_id_list)>
							<cfquery name="GET_PRODUCT_IMAGES" datasource="#DSN3#">
								SELECT PATH,PRODUCT_ID,PATH_SERVER_ID FROM PRODUCT_IMAGES WHERE IMAGE_SIZE = 0 AND PRODUCT_ID IN (#product_id_list#)
							</cfquery>
							<cfset product_id_list = listdeleteduplicates(valuelist(get_product_images.product_id,','),'numeric','ASC',',')>
							<cfset product_id_list=listsort(product_id_list,"numeric","ASC",",")>
						</cfif>
					</cfif> 	
		  			<cfoutput query="get_homepage_products">
						<cfif attributes.is_stock_count eq 1 or attributes.is_basket eq 1>
                        <!--- stok durum blogu --->
                            <cfset usable_stock_amount = 0>
                            <cfif len(get_saleable_stocks.saleable_stock[listfind(active_stock_list,stock_id)])>
                                <cfset usable_stock_amount = usable_stock_amount + get_saleable_stocks.saleable_stock[listfind(active_stock_list,stock_id)]>
                            </cfif>
                        <!--- stok durum blogu --->
                        </cfif>
                        <tr <cfif currentrow mod 2> class="color-list" <cfelse>class="color-row" </cfif>>
                            <cfif attributes.product_compare eq 1>
                                <td>
                                    <cfset product_all_list = listappend(product_all_list,product_id)>
                                    <input type="checkbox" name="product_id" id="product_id" value="#product_id#">
                                </td>
                            </cfif>
                            <cfif attributes.is_image eq 1>
                                <td>
                                    <cfif listfindnocase(product_id_list,product_id)>
                                        <a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="tableyazi" title="#product_detail#">
                                            <cf_get_server_file output_file="product/#get_product_images.path[listfind(product_id_list,product_id,',')]#" output_server="#get_product_images.path_server_id[listfind(product_id_list,product_id,',')]#"  output_type="0" image_width="50" image_height="50" image_link=0 alt="#getLang('objects2',207)#" title="#getLang('objects2',207)#">
                                        </a>
                                    </cfif>
                                </td>
                            </cfif>
                            <cfif attributes.is_brand eq 1><td><cfif len(brand_id)>#get_brands.brand_name[listfind(main_brand_list,brand_id,',')]#</cfif></td></cfif>
                            <td>
                                <!---<input type="hidden" name="pid_#currentrow#_#i#" id="pid_#currentrow#_#i#" value="#product_id#">
                                <input type="hidden" name="sid_#currentrow#_#i#" id="sid_#currentrow#_#i#" value="#stock_id#">--->
                                <cfif attributes.is_price>
                                    <a href="##" onclick="camp_urun_gonder2('#currentrow#','0');" class="tableyazi" title="#product_detail#">#product_name#<cfif property is '-'><cfelseif len(property) gt 1>&nbsp;#property#</cfif></a>
                                <cfelse>
                                    <a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="tableyazi" title="#product_detail#">#product_name#<cfif property is '-'><cfelseif len(property) gt 1>&nbsp;#property#</cfif></a>
                                </cfif>
                        
                                <cfscript>
                                    prom_id = '';
                                    prom_discount = '';
                                    prom_amount_discount = '';
                                    prom_cost = '';
                                    prom_free_stock_id = '';
                                    prom_stock_amount = 1;
                                    prom_free_stock_amount = 1;
                                    prom_free_stock_price = 0;
                                    prom_free_stock_money = '';
                                 </cfscript>
                                 
                                <cfquery name="GET_PRO" dbtype="query" maxrows="1">
                                    SELECT * FROM GET_PROM_ALL WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#"> ORDER BY	PROM_ID DESC
                                </cfquery>
                                
                                <cfif get_pro.recordcount>
                                    <cfscript>
                                        prom_id = get_pro.prom_id;
                                        prom_discount = get_pro.discount;
                                        prom_amount_discount = get_pro.amount_discount;
                                        if(len(get_pro.amount_discount_money_1))
                                            prom_amount_discount_money = trim(get_pro.amount_discount_money_1);
                                        else
                                            prom_amount_discount_money = row_money;
                                        prom_cost = get_pro.total_promotion_cost;
                                        prom_free_stock_id =  get_pro.free_stock_id;
                                        prom_stok_id = get_pro.stock_id; //Promosyonu olan urunun stok_id si
                                        if(len(get_pro.limit_value)) prom_stock_amount = get_pro.limit_value;
                                        if(len(get_pro.free_stock_amount)) prom_free_stock_amount = get_pro.free_stock_amount;
                                        if(len(get_pro.free_stock_price)) prom_free_stock_price = get_pro.free_stock_price;
                                        if(len(get_pro.amount_1_money)) 
                                            prom_free_stock_money = get_pro.amount_1_money;
                                        else
                                            prom_free_stock_money = row_money;
                                    </cfscript>
                                    <br/>
                                    <cfif len(get_pro.icon_id) and (get_pro.icon_id gt 0)>
                                        <cfquery name="GET_ICON" datasource="#DSN3#">
                                            SELECT ICON, ICON_SERVER_ID FROM SETUP_PROMO_ICON WHERE ICON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pro.icon_id#">
                                        </cfquery>
                                        <br/>
                                        <!--- <img src="#file_web_path#sales/#get_icon.icon#" align="absmiddle"> --->
                                        <cf_get_server_file output_file="sales/#get_icon.icon#" output_server="#get_icon.icon_server_id#" output_type="0" image_link=1 alt="#getLang('main',617)#" title="#getLang('main',617)#">
                                    </cfif>
                                    <font color="FF0000">
                                        <cfif len(get_pro.free_stock_id)>
                                            <strong><cf_get_lang no='131.Hediye'>:</strong> #get_product_name(stock_id:get_pro.free_stock_id,with_property:1)#
                                        <cfelseif  len(get_pro.discount)>
                                            <strong><cf_get_lang no='132.Yüzde İndirim'>:</strong> % #get_pro.discount#
                                        <cfelseif  len(get_pro.amount_discount)>
                                            <strong><cf_get_lang no='133.Tutar Indirimi'>:</strong> #get_pro.amount_discount# #get_pro.amount_1_money#
                                        </cfif>
                                    </font>
                                </cfif>
                            </td>
                            <cfif attributes.is_stock_count eq 1></cfif>
                            <cfif attributes.is_price eq 1>
                                <cfif isdefined("session.pp")>
                                    <td  style="text-align:right;">
                                        #TLFormat(price)#
                                        #money#
                                    </td>
                                </cfif>
                                <td  style="text-align:right;">
                                    <input type="hidden" name="camp_catalog_id_#currentrow#" id="camp_catalog_id_#currentrow#" value="#catalog_id#"> 
                                    <input type="hidden" name="camp_campaign_id_#currentrow#" id="camp_campaign_id_#currentrow#" value="#attributes.camp_id#">
                                    <input type="hidden" name="camp_pid_#currentrow#" id="camp_pid_#currentrow#" value="#product_id#">
                                    <input type="hidden" name="camp_sid_#currentrow#" id="camp_sid_#currentrow#" value="#stock_id#">
                                    <input type="hidden" name="camp_prom_id_#currentrow#" id="camp_prom_id_#currentrow#" value="#prom_id#">
                                    <input type="hidden" name="camp_prom_discount_#currentrow#" id="camp_prom_discount_#currentrow#" value="#prom_discount#">
                                    <input type="hidden" name="camp_prom_amount_discount_#currentrow#" id="camp_prom_amount_discount_#currentrow#" value="#prom_amount_discount#">
                                    <input type="hidden" name="camp_prom_cost_#currentrow#" id="camp_prom_cost_#currentrow#" value="#prom_cost#">
                                    <input type="hidden" name="camp_prom_free_stock_id_#currentrow#" id="camp_prom_free_stock_id_#currentrow#" value="#prom_free_stock_id#">				
                                    <input type="hidden" name="camp_prom_stock_amount_#currentrow#" id="camp_prom_stock_amount_#currentrow#" value="#prom_stock_amount#">
                                    <input type="hidden" name="camp_prom_free_stock_amount_#currentrow#" id="camp_prom_free_stock_amount_#currentrow#" value="#prom_free_stock_amount#">
                                    <input type="hidden" name="camp_prom_free_stock_price_#currentrow#" id="camp_prom_free_stock_price_#currentrow#" value="#prom_free_stock_price#">
                                    <input type="hidden" name="camp_prom_free_stock_money_#currentrow#" id="camp_prom_free_stock_money_#currentrow#" value="#prom_free_stock_money#">
                                    <input type="hidden" name="camp_price_old_#currentrow#" id="camp_price_old_#currentrow#" value="">
                                    <cfif isdefined("session.pp")>
                                        <input type="hidden" name="camp_price_#currentrow#" id="camp_price_#currentrow#" value="#(kampanya_fiyati_kdvsiz-tutar_indirimi)#">
                                        <input type="hidden" name="camp_price_kdv_#currentrow#" id="camp_price_kdv_#currentrow#" value="#kampanya_fiyati-(tutar_indirimi*(1+(tax/100)))#">
                                    <cfelse>
                                        <input type="hidden" name="camp_price_#currentrow#" id="camp_price_#currentrow#" value="#kampanya_fiyati_kdvsiz#">
                                        <input type="hidden" name="camp_price_kdv_#currentrow#" id="camp_price_kdv_#currentrow#" value="#kampanya_fiyati#">
                                    </cfif>
                                    <input type="hidden" name="camp_price_money_#currentrow#" id="camp_price_money_#currentrow#" value="#kampanya_money#">
                                    <input type="hidden" name="camp_price_standard_#currentrow#" id="camp_price_standard_#currentrow#" value="#kampanya_fiyati_kdvsiz#">
                                    <input type="hidden" name="camp_price_standard_kdv_#currentrow#" id="camp_price_standard_kdv_#currentrow#" value="#kampanya_fiyati#">
                                    <input type="hidden" name="camp_price_standard_money_#currentrow#" id="camp_price_standard_money_#currentrow#" value="#kampanya_money#">
                                    #TLFormat(kampanya_fiyati_kdvsiz)#  #kampanya_money#
                                </td>
                            </cfif>
                            <cfif attributes.is_basket eq 1>
                                <td>
                                    <input type="text" name="camp_miktar_#currentrow#" id="camp_miktar_#currentrow#" value="1" style="width:40px;" class="moneybox" onkeyup="return(FormatCurrency(this,event,0));">
                                </td>
                                <td>
                                    <cfif (is_zero_stock eq 1 or (is_zero_stock neq 1 and usable_stock_amount gt 0)) and kampanya_fiyati gt 0>
                                        <cfif get_paymethods.recordcount>
                                            <a href="##" onClick="camp_urun_gonder('#currentrow#','0');" class="prod_sepet"></a>
                                        <cfelse>
                                            <a href="##" onClick="camp_urun_normal_gonder('#currentrow#','0');" class="prod_sepet"></a>
                                        </cfif>
                                    <cfelse>
                                        &nbsp;
                                    </cfif>
                                </td>
                            </cfif>
                            <cfif (isdefined("session.ww.userid") or isdefined("session.pp.userid")) and attributes.is_demand eq 1>
                                <td nowrap>
                                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_add_order_demand&campaign_id=#attributes.camp_id#&stock_id=#stock_id#&price=#kampanya_fiyati#&price_money=#kampanya_money#&unit_id=#product_unit_id#&demand_type=1','small');" title="<cf_get_lang no ='1144.Fiyat Düşünce Haber Ver'>"><img src="/images/uyar.gif" alt="<cf_get_lang no ='1144.Fiyat Düşünce Haber Ver'>" border="0" /></a>
                                    <cfif is_zero_stock neq 1 and attributes.is_stock_count eq 1 and usable_stock_amount lte 0>
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_add_order_demand&campaign_id=#attributes.camp_id#&price_kdv=#price_kdv#&stock_id=#stock_id#&price=#kampanya_fiyati#&price_money=#kampanya_money#&unit_id=#product_unit_id#&demand_type=2','small');" title="<cf_get_lang no ='1145.Stoklara Gelince Haber Ver'>"><img src="/images/ship.gif" alt="<cf_get_lang no ='1145.Stoklara Gelince Haber Ver'>" border="0" /></a>
                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_add_order_demand&campaign_id=#attributes.camp_id#&price_kdv=#price_kdv#&stock_id=#stock_id#&price=#kampanya_fiyati#&price_money=#kampanya_money#&unit_id=#product_unit_id#&demand_type=3','small');"  title="<cf_get_lang no ='1146.Ön Sipariş Rezerve'>"><img src="/images/target_customer.gif" alt="<cf_get_lang no ='1146.Ön Sipariş Rezerve'>" border="0" /></a>
                                    </cfif>
                                </td>
                            </cfif>
                        </tr>
					</cfoutput>
                <cfelse>
                    <tr class="color-row" style="height:20px;">
                        <td colspan="9"><cf_get_lang no='273.Bu Kategoriye Ait Ürün Bulunamadı'>!</td>
                    </tr>
                </cfif> 
			</table>
		</td>
	</tr>
	<cfif attributes.product_compare eq 1>
		<tr style="height:25px;">
			<td><a href="javascript://" onclick="karsilastir();" class="prod_karsila"></a></td>
		</tr>
	</cfif>
</table>
<form action="" method="post" name="camp_satir_gonder">
	<input type="hidden" name="campaign_basket" id="campaign_basket" value="1">
	<input type="hidden" name="price_catid_2" id="price_catid_2" value="">
	<input type="hidden" name="istenen_miktar" id="istenen_miktar" value="">
	<input type="hidden" name="pid" id="pid" value="">
	<input type="hidden" name="catalog_id" id="catalog_id" value="">
	<input type="hidden" name="product_id" id="product_id" value="">
	<input type="hidden" name="sid" id="sid" value="">
	<input type="hidden" name="price" id="price" value="">
	<input type="hidden" name="price_old" id="price_old" value="">
	<input type="hidden" name="price_kdv" id="price_kdv" value="">
	<input type="hidden" name="price_money" id="price_money" value="">
	<input type="hidden" name="prom_id" id="prom_id" value="">
	<input type="hidden" name="prom_discount" id="prom_discount" value="">
	<input type="hidden" name="prom_amount_discount" id="prom_amount_discount" value="">
	<input type="hidden" name="prom_cost" id="prom_cost" value="">
	<input type="hidden" name="prom_free_stock_id" id="prom_free_stock_id" value="">
	<input type="hidden" name="prom_stock_amount" id="prom_stock_amount" value="1">
	<input type="hidden" name="prom_free_stock_amount" id="prom_free_stock_amount" value="1">
	<input type="hidden" name="prom_free_stock_price" id="prom_free_stock_price" value="0">
	<input type="hidden" name="prom_free_stock_money" id="prom_free_stock_money" value="">	
	<input type="hidden" name="price_standard" id="price_standard" value="">
	<input type="hidden" name="price_standard_kdv" id="price_standard_kdv" value="">
	<input type="hidden" name="price_standard_money" id="price_standard_money" value="">
</form>

<cfif get_paymethods.recordcount>
	<iframe name="form_basket_camp_ww" id="form_basket_camp_ww" src="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_iframe_form_basket" width="0" height="0" scrolling="yes" frameborder="1"></iframe>
<cfelse>
	<iframe name="form_basket_ww" id="form_basket_ww" src="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_iframe_form_basket" width="0" height="0" scrolling="yes" frameborder="1"></iframe>
</cfif>

<script type="text/javascript">
	<cfif attributes.is_basket eq 1>
		function camp_urun_normal_gonder(satir_no,pro_no)
		{   
			if(pro_no>0)satir_no=satir_no+'_'+pro_no;
			istenen_miktar = filterNum(eval("document.getElementById('camp_miktar_"+satir_no+"')").value);
			if(istenen_miktar.length==0 || istenen_miktar =='')
				{
					alert("<cf_get_lang no ='1147.Miktar Giriniz'>!");
					return false;
				}
			window.frames['form_basket_ww'].document.satir_gonder.istenen_miktar.value = istenen_miktar;
			window.frames['form_basket_ww'].document.satir_gonder.price_catid_2.value = '<cfoutput>#attributes.price_catid_2#</cfoutput>';
			window.frames['form_basket_ww'].document.satir_gonder.sid.value = eval("document.getElementById('camp_sid_"+satir_no+"')").value;
			window.frames['form_basket_ww'].document.satir_gonder.catalog_id.value = eval("document.getElementById('camp_catalog_id_"+satir_no+"')").value;
			window.frames['form_basket_ww'].document.satir_gonder.price.value = eval("document.getElementById('camp_price_"+satir_no+"')").value;
			window.frames['form_basket_ww'].document.satir_gonder.price_kdv.value = eval("document.getElementById('camp_price_kdv_"+satir_no+"')").value;
			window.frames['form_basket_ww'].document.satir_gonder.price_money.value = eval("document.getElementById('camp_price_money_"+satir_no+"')").value;
			window.frames['form_basket_ww'].document.satir_gonder.price_standard.value = eval("document.getElementById('camp_price_standard_"+satir_no+"')").value;
			window.frames['form_basket_ww'].document.satir_gonder.price_standard_kdv.value = eval("document.getElementById('camp_price_standard_kdv_"+satir_no+"')").value;
			window.frames['form_basket_ww'].document.satir_gonder.price_standard_money.value = eval("document.getElementById('camp_price_standard_money_"+satir_no+"')").value;
			window.frames['form_basket_ww'].document.satir_gonder.prom_id.value = '';
			window.frames['form_basket_ww'].document.satir_gonder.prom_discount.value = '';
			window.frames['form_basket_ww'].document.satir_gonder.prom_amount_discount.value = '';
			window.frames['form_basket_ww'].document.satir_gonder.prom_cost.value = '';
			window.frames['form_basket_ww'].document.satir_gonder.prom_free_stock_id.value = '';
			window.frames['form_basket_ww'].document.satir_gonder.prom_free_stock_amount.value = '';
			window.frames['form_basket_ww'].document.satir_gonder.prom_free_stock_price.value = '';
			window.frames['form_basket_ww'].document.satir_gonder.prom_free_stock_money.value = '';
			window.frames['form_basket_ww'].document.satir_gonder.price_old.value = '';
			window.frames['form_basket_ww'].document.satir_gonder.action = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_add_basketww_row';
			window.frames['form_basket_ww'].document.satir_gonder.submit();
		}
	
		function camp_urun_gonder(satir_no,pro_no)
		{   
			if(pro_no>0)satir_no=satir_no+'_'+pro_no;
			camp_istenen_miktar = filterNum(eval("document.getElementById('camp_miktar_"+satir_no+"')").value);
			if(camp_istenen_miktar.length==0 || camp_istenen_miktar =='')
				{
					alert("<cf_get_lang no ='1147.Miktar Giriniz'>!");
					return false;
				}
			window.frames['form_basket_camp_ww'].document.satir_gonder.istenen_miktar.value = camp_istenen_miktar;
			window.frames['form_basket_camp_ww'].document.satir_gonder.price_catid_2.value = '<cfoutput>#attributes.price_catid_2#</cfoutput>';
			window.frames['form_basket_camp_ww'].document.satir_gonder.sid.value = eval("document.getElementById('camp_sid_"+satir_no+"')").value;
			window.frames['form_basket_camp_ww'].document.satir_gonder.catalog_id.value = eval("document.getElementById('camp_catalog_id_"+satir_no+"')").value;
			window.frames['form_basket_camp_ww'].document.satir_gonder.campaign_id.value = eval("document.getElementById('camp_campaign_id_"+satir_no+"')").value;
			window.frames['form_basket_camp_ww'].document.satir_gonder.price.value = eval("document.getElementById('camp_price_"+satir_no+"')").value;
			window.frames['form_basket_camp_ww'].document.satir_gonder.price_kdv.value = eval("document.getElementById('camp_price_kdv_"+satir_no+"')").value;
			window.frames['form_basket_camp_ww'].document.satir_gonder.price_money.value = eval("document.getElementById('camp_price_money_"+satir_no+"')").value;
			window.frames['form_basket_camp_ww'].document.satir_gonder.price_standard.value = eval("document.getElementById('camp_price_standard_"+satir_no+"')").value;
			window.frames['form_basket_camp_ww'].document.satir_gonder.price_standard_kdv.value = eval("document.getElementById('camp_price_standard_kdv_"+satir_no+"')").value;
			window.frames['form_basket_camp_ww'].document.satir_gonder.price_standard_money.value = eval("document.getElementById('camp_price_standard_money_"+satir_no+"')").value;			
			window.frames['form_basket_camp_ww'].document.satir_gonder.prom_id.value = eval("document.getElementById('camp_prom_id_"+satir_no+"')").value;
			window.frames['form_basket_camp_ww'].document.satir_gonder.prom_discount.value = eval("document.getElementById('camp_prom_discount_"+satir_no+"')").value;
			window.frames['form_basket_camp_ww'].document.satir_gonder.prom_amount_discount.value = eval("document.getElementById('camp_prom_amount_discount_"+satir_no+"')").value;
			window.frames['form_basket_camp_ww'].document.satir_gonder.prom_cost.value = eval("document.getElementById('camp_prom_cost_"+satir_no+"')").value;
			window.frames['form_basket_camp_ww'].document.satir_gonder.prom_free_stock_id.value = eval("document.getElementById('camp_prom_free_stock_id_"+satir_no+"')").value;
			window.frames['form_basket_camp_ww'].document.satir_gonder.prom_stock_amount.value = eval("document.getElementById('camp_prom_stock_amount_"+satir_no+"')").value;
			window.frames['form_basket_camp_ww'].document.satir_gonder.prom_free_stock_amount.value = eval("document.getElementById('camp_prom_free_stock_amount_"+satir_no+"')").value;
			window.frames['form_basket_camp_ww'].document.satir_gonder.prom_free_stock_price.value = eval("document.getElementById('camp_prom_free_stock_price_"+satir_no+"')").value;
			window.frames['form_basket_camp_ww'].document.satir_gonder.prom_free_stock_money.value = eval("document.getElementById('camp_prom_free_stock_money_"+satir_no+"')").value;
			if ((window.frames['form_basket_camp_ww'].document.satir_gonder.prom_discount.value.length) || (form_basket_camp_ww.satir_gonder.prom_amount_discount.value.length))
				window.frames['form_basket_camp_ww'].document.satir_gonder.price_old.value = eval("document.getElementById('camp_price_old_"+satir_no+"')").value;
			else
				window.frames['form_basket_camp_ww'].document.satir_gonder.price_old.value = '';
			window.frames['form_basket_camp_ww'].document.satir_gonder.action = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_add_basketww_row_camp';
			window.frames['form_basket_camp_ww'].document.satir_gonder.submit();
		}
	</cfif>
	
	function camp_urun_gonder2(satir_no,pro_no)
	{ 
		if(pro_no>0)satir_no=satir_no+'_'+pro_no;
		istenen_miktar = 1;
		document.camp_satir_gonder.istenen_miktar.value = istenen_miktar;
		document.camp_satir_gonder.price_catid_2.value = '<cfoutput>#attributes.price_catid_2#</cfoutput>';
		document.camp_satir_gonder.pid.value = eval("document.getElementById('camp_pid_"+satir_no+"')").value;
		document.camp_satir_gonder.catalog_id.value = eval("document.getElementById('camp_catalog_id_"+satir_no+"')").value;
		document.camp_satir_gonder.product_id.value = eval("document.getElementById('camp_pid_"+satir_no+"')").value;
		document.camp_satir_gonder.sid.value = eval("document.getElementById('camp_sid_"+satir_no+"')").value;
		document.camp_satir_gonder.price.value = eval("document.getElementById('camp_price_"+satir_no+"')").value;
		document.camp_satir_gonder.price_kdv.value = eval("document.getElementById('camp_price_kdv_"+satir_no+"')").value;
		document.camp_satir_gonder.price_money.value = eval("document.getElementById('camp_price_money_"+satir_no+"')").value;
	
		document.camp_satir_gonder.price_standard.value = eval("document.getElementById('camp_price_standard_"+satir_no+"')").value;
		document.camp_satir_gonder.price_standard_kdv.value = eval("document.getElementById('camp_price_standard_kdv_"+satir_no+"')").value;
		document.camp_satir_gonder.price_standard_money.value = eval("document.getElementById('camp_price_standard_money_"+satir_no+"')").value;
	
		document.camp_satir_gonder.prom_id.value = eval("document.getElementById('camp_prom_id_"+satir_no+"')").value;
		document.camp_satir_gonder.prom_discount.value = eval("document.getElementById('camp_prom_discount_"+satir_no+"')").value;
		document.camp_satir_gonder.prom_amount_discount.value = eval("document.getElementById('camp_prom_amount_discount_"+satir_no+"')").value;
		document.camp_satir_gonder.prom_cost.value = eval("document.getElementById('camp_prom_cost_"+satir_no+"')").value;
		document.camp_satir_gonder.prom_free_stock_id.value = eval("document.getElementById('camp_prom_free_stock_id_"+satir_no+"')").value;
		document.camp_satir_gonder.prom_stock_amount.value = eval("document.getElementById('camp_prom_stock_amount_"+satir_no+"')").value;
		document.camp_satir_gonder.prom_free_stock_amount.value = eval("document.getElementById('camp_prom_free_stock_amount_"+satir_no+"')").value;
		document.camp_satir_gonder.prom_free_stock_price.value = eval("document.getElementById('camp_prom_free_stock_price_"+satir_no+"')").value;
		document.camp_satir_gonder.prom_free_stock_money.value = eval("document.getElementById('camp_prom_free_stock_money_"+satir_no+"')").value;
		if ((document.camp_satir_gonder.prom_discount.value.length) || (camp_satir_gonder.prom_amount_discount.value.length))
			document.camp_satir_gonder.price_old.value = eval("document.getElementById('camp_price_old_"+satir_no+"')").value;
	
		document.camp_satir_gonder.action = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.detail_product';
		<cfif attributes.is_popup eq 1>
			windowopen('','list','product_window');
			document.camp_satir_gonder.target = 'product_window';
			document.camp_satir_gonder.action = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_detail_product';
		</cfif>
		document.camp_satir_gonder.submit();
	}
	
	<cfif attributes.product_compare eq 1>
		function karsilastir()
		{  
			secilenler = '';
			kontrol = 0;
			<cfloop from="1" to="#listlen(product_all_list)#" index="pk">
				<cfoutput>
					<cfif listlen(product_all_list) gt 1> 
					if(document.getElementsByName('product_id')[#pk-1#]!=undefined && document.getElementsByName('product_id')[#pk-1#].checked == true)
						{
						kontrol = kontrol + 1;
						if(secilenler.length==0)
							secilenler = document.getElementsByName('product_id')[#pk-1#].value;
						else
							secilenler = secilenler + ',' + document.getElementsByName('product_id')[#pk-1#].value;
						}
					<cfelseif listlen(product_all_list) eq 1>
					if(document.getElementById('product_id').checked == true)
						secilenler = document.getElementById('product_id').value;
						kontrol = 1;
					</cfif>
				</cfoutput>
			</cfloop>
			if(kontrol > 4)
			{
				alert("<cf_get_lang no ='1148.Dörtten Fazla Ürünle Karşılaştırma Yapılamaz'>!");
				return false;
			}
			if(kontrol >= 2)
				window.location.href='<cfoutput>#request.self#?fuseaction=objects2.product_compare&product_id=</cfoutput>'+secilenler;
			else
			{
				alert("<cf_get_lang_main no ='313.Ürün seçmelisiniz'> !");
				return false;
			}
		}
	</cfif>
</script>
