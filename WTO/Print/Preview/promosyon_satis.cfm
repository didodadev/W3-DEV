<cfif isDefined("attributes.woc_list") and listLen(attributes.woc_list)>
    <cf_woc_header>
    <cfset sorted_woc_list = listSort(attributes.woc_list,"numeric","ASC",",")>
    <cfloop list="#sorted_woc_list#" index="i">
        <cfquery name="GET_DET_PROMOTION" datasource="#dsn3#">
            SELECT * FROM PROMOTIONS WHERE PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
        </cfquery>
        <cfif len(GET_DET_PROMOTION.BRAND_ID)>
            <cfquery name="get_brand_name" datasource="#dsn3#">
                SELECT 
                    BRAND_NAME,
                    BRAND_ID	
                FROM
                    PRODUCT_BRANDS
                WHERE
                BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_DET_PROMOTION.BRAND_ID#">

            </cfquery>
        </cfif>
        <cfif len(GET_DET_PROMOTION.FREE_STOCK_ID)>
            <cfquery name="GET_FREE_PRODUCT" datasource="#dsn3#">
                SELECT 	
                    STOCKS.STOCK_ID,
                    STOCKS.STOCK_CODE,
                    STOCKS.PROPERTY,
                    STOCKS.PRODUCT_ID,
                    PRODUCT.PRODUCT_ID,
                    PRODUCT.PRODUCT_NAME 
                FROM 
                    STOCKS,
                    PRODUCT
                WHERE 
                    STOCKS.STOCK_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_DET_PROMOTION.FREE_STOCK_ID#"> 
                AND 
                    STOCKS.PRODUCT_ID=PRODUCT.PRODUCT_ID
            </cfquery>
        </cfif> 
        <cfif len(get_det_promotion.company_id)>
            <cfquery name="GET_COMPANY" datasource="#DSN#">
                SELECT NICKNAME FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_det_promotion.company_id#"> 
            </cfquery>
        </cfif>
        <cfif len(get_det_promotion.camp_id)>
            <cfquery name="GET_CAMP_NAME" datasource="#dsn3#">
                SELECT 	
                    CAMP_HEAD,
                    CAMP_STARTDATE,
                    CAMP_FINISHDATE 
                FROM 
                    CAMPAIGNS
                WHERE 
                    CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_DET_PROMOTION.CAMP_ID#"> 
            </cfquery>
        </cfif>
        <cfquery name="GET_Coupon" datasource="#DSN3#">
            SELECT COUPON_NO,COUPON_NAME FROM COUPONS
                <cfif len(get_det_promotion.coupon_id)>WHERE COUPON_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_det_promotion.coupon_id#"></cfif> 
        </cfquery>
        <cfquery name="GET_EMP" datasource="#dsn#">
            SELECT 
                EMPLOYEE_NAME,
                EMPLOYEE_SURNAME
            FROM 
                EMPLOYEES
            WHERE 
                EMPLOYEE_ID=#GET_DET_PROMOTION.RECORD_EMP#
        </cfquery>
        <cfoutput>
            <cf_woc_elements>
                <cf_wuxi id="item-prom_no_#i#" data="#iif(len(get_det_promotion.prom_no),'get_det_promotion.prom_no',DE(""))#" label="32803" type="cell"> <!--- Promosyon No--->
                <cfsavecontent variable="limit_type">
                    <cfif get_det_promotion.limit_type is 1 or get_det_promotion.limit_type is 3>
                        #get_det_promotion.limit_value#
                        <cf_get_lang dictionary_id='58082.Adet'>
                    <cfelseif get_det_promotion.LIMIT_TYPE is 2>
                        #TLFormat(get_det_promotion.LIMIT_VALUE)#
                        <cf_get_lang dictionary_id='57673.Tutar'>
                    </cfif>
                </cfsavecontent>
                <cf_wuxi id="item-limit_type_#i#" data="#limit_type#" label="58775" type="cell"><!--- Alışveriş Miktarı --->
                <cf_wuxi id="item-product_name_#i#" data="#iif(len(GET_DET_PROMOTION.FREE_STOCK_ID),'get_free_product.product_name',DE(""))#" label="57657" type="cell"><!--- Üründ --->
                <cfsavecontent variable="price_list">
                    <cfif get_det_promotion.price_catid is '-2'>
                        <cf_get_lang dictionary_id='58721.Standart Satış'>
                    <cfelseif get_det_promotion.price_catid is '-1'>
                        <cf_get_lang dictionary_id='58722.Standart Alış'>
                    <cfelse>
                        <cfif len(get_det_promotion.price_catid)>
                            <cfquery name="PRICE_CATS" datasource="#dsn3#">
                                SELECT
                                    PRICE_CAT
                                FROM
                                    PRICE_CAT
                                WHERE
                                    PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_det_promotion.price_catid#">
                                ORDER BY
                                    PRICE_CAT
                            </cfquery>
                            #price_cats.PRICE_CAT#
                            </cfif>
                    </cfif>
                </cfsavecontent>
                <cf_wuxi id="item-limit_type_#i#" data="#price_list#" label="58964" type="cell"><!--- Fiyat Listesi --->
                <cf_wuxi id="item-brand_name_#i#" data="#iif(len(get_det_promotion.brand_id),'get_brand_name.brand_name',DE(""))#" label="58847" type="cell"><!--- Marka --->
                <cfsavecontent variable="prom_discount">
                    <cfif len(get_det_promotion.discount)>% #get_det_promotion.discount#</cfif>
                </cfsavecontent>
                <cf_wuxi id="item-discount_#i#" data="#prom_discount#" label="33252" type="cell"><!---Anında İndirim  --->
                <cf_wuxi id="item-free_stock_id_#i#" data="#iif(len(get_det_promotion.free_stock_id),'get_free_product.product_name',DE(""))#" label="32453" type="cell"><!---Bedava Ürün  --->
                <cf_wuxi id="item-camp_id_#i#" data="#iif(len(get_det_promotion.camp_id),'get_camp_name.camp_head',DE(""))#" label="57446" type="cell"><!--- Kampanya --->
                <cf_wuxi id="item-gift_head_#i#" data="#iif(len(get_det_promotion.gift_head),'get_det_promotion.gift_head',DE(""))#" label="32454" type="cell"><!--- Armağan --->
                <cf_wuxi id="item-coupon_id_#i#" data="#iif(len(get_det_promotion.coupon_id),'get_coupon.coupon_name',DE(""))#" label="32491" type="cell"><!--- Şans Kuponu--->
                <cf_wuxi id="item-limit_type_#i#" data="#iif(len(get_det_promotion.company_id),'get_company.nickname',DE(""))#" label="57457" type="cell"><!---Müşteri --->
                <cfsavecontent variable="prom_prim_percent">
                    <cfif len(get_det_promotion.prim_percent)>% #get_det_promotion.prim_percent#</cfif>
                </cfsavecontent>
                <cf_wuxi id="item-prim_percent_#i#" data="#prom_prim_percent#" label="32495" type="cell"><!--- Dönem Primi --->
                <cf_wuxi id="item-prom_detail_#i#" data="#get_det_promotion.prom_detail#" label="57629" type="cell"><!--- Açıklama --->
                <cfsavecontent variable="prom_cost">
                    <cfif len(get_det_promotion.total_promotion_cost)>#TLFormat(get_det_promotion.total_promotion_cost)#&nbsp;#session.ep.money#</cfif>
                </cfsavecontent>
                <cf_wuxi id="item-prom_cost_#i#" data="#prom_cost#" label="32501" type="cell"><!--- Toplam Maliyet --->
            </cf_woc_elements>
            <cf_woc_elements>
                <cf_woc_list id="prom_list_#i#">
                    <thead>
                        <tr>
                            <cf_wuxi label="57655" type="cell" is_row="0" id="wuxi_57655_#i#"> <!---Başlangıç Tarihi  --->
                            <cf_wuxi label="57700" type="cell" is_row="0" id="wuxi_57700_#i#"> <!---Bitiş Tarihi  --->
                            <cf_wuxi label="57627" type="cell" is_row="0" id="wuxi_57627_#i#"> <!---Kayıt Tarihi  --->
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <cf_wuxi data="#dateformat(get_det_promotion.startdate,dateformat_style)#-#timeformat(get_det_promotion.record_date,'HH:MM:SS')#" type="cell" is_row="0"> 
                            <cf_wuxi data="#dateformat(get_det_promotion.finishdate,dateformat_style)#-#timeformat(get_det_promotion.record_date,'HH:MM:SS')#" type="cell" is_row="0"> 
                            <cf_wuxi data="#dateformat(get_det_promotion.record_date,dateformat_style)#-#timeformat(get_det_promotion.record_date,'HH:MM:SS')#" type="cell" is_row="0"> 
                        </tr>
                    </tbody>
                </cf_woc_list> 
            </cf_woc_elements>
        </cfoutput>
        <cfif i neq listLast(sorted_woc_list)>
            <tr class="bottom_border print_header"></tr>
        </cfif>
    </cfloop>
    <cf_woc_footer>
<cfelse>
    <script>
        alert("<cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'>!");
        window.close();
    </script>
</cfif>