<cfcomponent>
    <cfif isdefined("session.pp")>
        <cfset session_base = evaluate('session.pp')>
    <cfelseif isdefined("session.ep")>
        <cfset session_base = evaluate('session.ep')>
    <cfelseif isdefined("session.ww")>
        <cfset session_base = evaluate('session.ww')>
    <cfelseif isdefined("session.qq")>
        <cfset session_base = evaluate('session.qq')>
    <cfelse>
        <cfset session_base = structNew()>
    </cfif>
    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = '#dsn#_product'>
    <cfset functions = createObject("component","WMO.functions") />
    <cfset Fafunctions = createObject("component","WMO.faFunctions") />
    <cfset ListDeleteDuplicates = functions.ListDeleteDuplicates>
    <cfset get_company_period = functions.get_company_period>
    <cfset sql_unicode = functions.sql_unicode>
    <cfset date_add = functions.date_add>
    <cfset wrk_round = functions.wrk_round>
    <cfset carici = Fafunctions.carici>
    <cfset muhasebeci = Fafunctions.muhasebeci>
    <cfset workcube_mode = application.systemParam.systemParam().workcube_mode />
    <cfif StructCount(session_base)>
        <cfset dsn2 = '#dsn#_#session_base.period_year#_#session_base.our_company_id#'>
        <cfset dsn3 = '#dsn#_#session_base.our_company_id#'>
        <cfset siteMethods = createObject("component","catalyst/AddOns/Yazilimsa/Protein/cfc/siteMethods") />
        <cfset prodData = createObject("component","V16/objects2/product/cfc/data") />
        <cfset queryJSONConverter = createObject('component','catalyst/AddOns/Yazilimsa/Protein/reactor/cfc/queryJSONConverter') />
    <cfelse>      
        <cfset siteMethods = createObject("component","AddOns/Yazilimsa/Protein/cfc/siteMethods") />
        <cfset prodData = createObject("component","V16/objects2/product/cfc/data") />
        <cfset queryJSONConverter = createObject('component','AddOns/Yazilimsa/Protein/reactor/cfc/queryJSONConverter') />
    </cfif>
    <cfif not isdefined("session.pp") and not isdefined("session.ww") and not IsDefined("Cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>
        <cfcookie name="wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#" value="#createUUID()#" expires="1">
    </cfif>

    <cfset attributes.price_cat_id = 0>
	
	<cfif isdefined("session.pp.userid")>
		<cfquery name="get_comp_credit" datasource="#dsn#">
			SELECT PRICE_CAT FROM COMPANY_CREDIT WHERE COMPANY_ID = #session.pp.company_id#
		</cfquery>
		<cfif get_comp_credit.recordcount and len(get_comp_credit.PRICE_CAT)>
			<cfset attributes.price_cat_id = get_comp_credit.PRICE_CAT>
		</cfif>
	</cfif>

    <cffunction name="get_product_to_basket" access="remote" returntype="any" hint="Sepetteki ürünlerin görüntülenmesi">
        <cfargument name="consumer_id" default="">
        <cfargument name="partner_id" default="">
        <cfargument name="cookie_name" default="">
        <cfargument name="getSaleableStock" default="1">
        
            <cfquery name="get_products" datasource="#DSN#">
                SELECT
                    --(SELECT TOP 1 CM.NICKNAME FROM SHIP_METHOD_PRICE SMP LEFT JOIN SHIP_METHOD_PRICE_ROW SMPR ON SMP.SHIP_METHOD_PRICE_ID = SMPR.SHIP_METHOD_PRICE_ID LEFT JOIN COMPANY CM ON SMP.COMPANY_ID = CM.COMPANY_ID WHERE SMPR.SHIP_METHOD_ID = OPR.SHIPMENT_ID ) AS SHIPMENT_COMP,
                    (SELECT C.CONSUMER_EMAIL FROM CONSUMER C WHERE C.CONSUMER_ID = OPR.RECORD_CONS) AS CONSUMER_EMAIL,
                    OPR.QUANTITY,
                    OPR.PRODUCT_ID,
                    OPR.STOCK_ID,
                    CASE 
                        WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN
                            OPR.QUANTITY * PRC.PRICE_KDV * (SELECT SM.RATE2/SM.RATE1 FROM SETUP_MONEY SM WHERE SM.MONEY_STATUS = 1 AND SM.MONEY = PRC.MONEY AND SM.PERIOD_ID = #session_base.period_id#)
                        ELSE
                            OPR.QUANTITY * PS.PRICE_KDV * (SELECT SM.RATE2/SM.RATE1 FROM SETUP_MONEY SM WHERE SM.MONEY_STATUS = 1 AND SM.MONEY = PS.MONEY AND SM.PERIOD_ID = #session_base.period_id#)
                    END AS PRICE_KDV_TL,
                    CASE 
                        WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN
                            OPR.QUANTITY * PRC.PRICE * (SELECT SM.RATE2/SM.RATE1 FROM SETUP_MONEY SM WHERE SM.MONEY_STATUS = 1 AND SM.MONEY = PRC.MONEY AND SM.PERIOD_ID = #session_base.period_id#)
                        ELSE
                            OPR.QUANTITY * PS.PRICE * (SELECT SM.RATE2/SM.RATE1 FROM SETUP_MONEY SM WHERE SM.MONEY_STATUS = 1 AND SM.MONEY = PS.MONEY AND SM.PERIOD_ID = #session_base.period_id#)
                    END AS PRICE_TL,
                    --OPR.DELIVER_ID,
                    --OPR.INVOICE_DELIVER_ID,
                    --OPR.PAYMENT_ID,
                    --OPR.SHIPMENT_ID,
                    OPR.IS_CARGO,
                    OPR.ORDER_ROW_ID,
                    CASE WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN PRC.PRICE_KDV ELSE PS.PRICE_KDV END AS PRICE_KDV,
                    CASE WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN PRC.PRICE ELSE PS.PRICE END AS PRICE,
                    CASE WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN PRC.MONEY ELSE PS.MONEY END AS MONEY,
                    OPR.PRICE AS PRICE_CARGO,
                    OPR.TAX,					
                    S.PRODUCT_NAME,
                    S.STOCK_CODE_2,
                    S.PROPERTY,
                    PU.MAIN_UNIT,
                    (SELECT TOP 1 PI.PATH FROM #dsn1#.PRODUCT_IMAGES PI WHERE PI.PRODUCT_ID = OPR.PRODUCT_ID AND PI.IMAGE_SIZE = 2 ORDER BY  PI.PRODUCT_IMAGEID ASC) AS URUN_RESMI,
                    <cfif arguments.getSaleableStock>
                        ISNULL((SELECT SALEABLE_STOCK FROM  #dsn2#.GET_STOCK_LAST GSL WHERE OPR.STOCK_ID=GSL.STOCK_ID),0) AS STOK_DURUMU
                    </cfif>
                FROM 
                    #dsn3#.ORDER_PRE_ROWS OPR
                    LEFT JOIN #dsn1#.PRICE_STANDART PS ON PS.PRODUCT_ID=OPR.PRODUCT_ID
                    LEFT JOIN #dsn3#.STOCKS S ON S.STOCK_ID=OPR.STOCK_ID
                    LEFT JOIN #dsn3#.PRICE PRC ON 
                    (
                        PRC.PRODUCT_ID = OPR.PRODUCT_ID AND 
                        PRC.PRICE_CATID = #attributes.price_cat_id# AND
                        (PRC.FINISHDATE IS NULL OR PRC.FINISHDATE > #NOW()#)
                    ) 
                    LEFT JOIN #dsn1#.PRODUCT_UNIT PU ON PU.PRODUCT_ID = S.PRODUCT_ID 
                WHERE
                    PS.PURCHASESALES=1 AND
                    PS.PRICESTANDART_STATUS=1 AND
                    PU.IS_MAIN = 1
                    <cfif len(arguments.consumer_id)>
                        AND RECORD_CONS = #arguments.consumer_id#
                    <cfelseif len(arguments.partner_id)>
                        AND RECORD_PAR = #arguments.partner_id#
                    <cfelse>
                        AND COOKIE_NAME = '#arguments.cookie_name#'
                    </cfif>
            </cfquery>
        <cfreturn get_products>
    </cffunction>

    <cffunction name="add_product_to_basket" access="remote" returnformat="json" hint="Sepete ekleme işlemlerini gerçekleştirir">
        <cfargument name="stock_id">
        <cfargument name="quantity">
        <cfargument name="widget_id">
        <cfif not StructCount(session_base)>
            <cfset dsn2 = '#dsn#_#arguments.period_year#_#arguments.our_company_id#'>
            <cfset dsn3 = '#dsn#_#arguments.our_company_id#'> 
            <cfset session_base.period_id = arguments.period_id> 
            <cfset session_base.period_year = arguments.period_year> 
            <cfset session_base.our_company_id = arguments.our_company_id>
             <cfset session_base.company_id = arguments.our_company_id>
            <cfset session_base.money = arguments.money>
        </cfif>
        <cfset response = structNew()>
        <cftry>
            <cfset getWidget = deserializeJSON(siteMethods.get_widget(id: arguments.widget_id)) />
            <cfif len( getWidget.DATA[1].WIDGET_DATA )><cfset xml_settings = deserializeJSON(getWidget.DATA[1].WIDGET_DATA) ></cfif>
            
            <cfset GET_STOCK = prodData.GET_HOMEPAGE_PRODUCTS(stock_id: arguments.stock_id,session_base:session_base) />
            <cfset MONEYS = prodData.moneys(company_id : session_base.our_company_id, period_id : session_base.period_id,session_base:session_base)>
            <cfset DEFAULT_MONEY = prodData.DEFAULT_MONEY(company_id : session_base.our_company_id, period_id : session_base.period_id,session_base:session_base)>
            <cfset GET_CREDIT_LIMIT = deserializeJSON(prodData.GET_CREDIT_LIMIT(session_base:session_base))>
            <cfset price_catid = GET_CREDIT_LIMIT.PRICE_CATID>
            
            <cfset GET_PRICE_ALL = prodData.GET_PRICE_ALL(
                                                        price_catid : price_catid,
                                                        brand_id : get_stock.brand_id,
                                                        session_base:session_base 
                                                )>

            <cfset catalog_id = ( isDefined("arguments.stock_id") ) ? arguments.stock_id : NULL>
            
            <cfset attributes.money = GET_STOCK.money>
            <cfloop query="moneys">		
                <cfif moneys.money is attributes.money>
                    <cfset row_money = money >
                    <cfset row_money_rate1 = moneys.rate1>
                    <cfset row_money_rate2 = moneys.rate2>
                </cfif>
            </cfloop>
            <cfset pro_price = GET_STOCK.price>
            <cfset pro_price_kdv = GET_STOCK.price_kdv>

        
            <cfif (not isdefined('xml_settings.is_basket_standart') or (isdefined('xml_settings.is_basket_standart') and xml_settings.is_basket_standart eq 1)) and price_catid neq -2>
                <cfquery name="GET_P" dbtype="query">
                    SELECT * FROM GET_PRICE_ALL WHERE UNIT = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_STOCK.product_unit_id#"> AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_STOCK.product_id#">
                </cfquery>
                <cfset catalog_id_ = get_p.catalog_id>
                <cfif (get_p.recordcount and len(get_p.price))>
                    <cfset musteri_pro_price = get_p.price>
                    <cfset musteri_pro_price_kdv = get_p.price_kdv> 
                    <cfset musteri_row_money=get_p.money>
                <cfelse>
                    <cfset musteri_pro_price = pro_price>
                    <cfset musteri_pro_price_kdv = pro_price_kdv>
                    <cfset musteri_row_money=attributes.money>
                </cfif>  <!--- musteriye ozel fiyat yoksa son kullanici gecerli --->
                <cfloop query="moneys">
                    <cfif moneys.money is musteri_row_money>
                        <cfset musteri_row_money_rate1 = moneys.rate1>
                        <cfset musteri_row_money_rate2 = moneys.rate2>
                    </cfif>
                </cfloop>				
                <cfif (musteri_row_money is default_money.money)>
                    <cfset musteri_str_other_money = musteri_row_money>
                    <cfset musteri_flt_other_money_value = musteri_pro_price>
                    <cfset musteri_flt_other_money_value_kdv = musteri_pro_price_kdv>	
                    <cfset musteri_flag_prc_other = 0>
                <cfelse>
                    <cfset musteri_flag_prc_other = 1>
                    <cfset musteri_str_other_money = musteri_row_money>
                    <cfset musteri_flt_other_money_value = musteri_pro_price>
                    <cfset musteri_flt_other_money_value_kdv = musteri_pro_price_kdv>
                    <cfset musteri_pro_price = musteri_pro_price*(musteri_row_money_rate2/musteri_row_money_rate1)>
                </cfif>
            <cfelse>
                <cfset catalog_id_ = '' >
                <cfset musteri_flt_other_money_value = pro_price >
                <cfset musteri_flt_other_money_value_kdv = pro_price_kdv >
                <cfset musteri_str_other_money = row_money >
                <cfset musteri_row_money = row_money>
                <cfset musteri_flag_prc_other = 1>
                <cfset musteri_pro_price = pro_price*(row_money_rate2/row_money_rate1)>
                <cfset musteri_str_other_money = default_money.money>
            </cfif>

            <!--- prom kısımlarına bakılacak --->
            <cfset prom_id = ''>
            <cfset prom_discount = ''>
            <cfset prom_amount_discount = ''>
            <cfset prom_cost = ''>
            <cfset prom_free_stock_id = ''>
            <cfset prom_stock_amount = 1>
            <cfset prom_free_stock_amount = 1>
            <cfset prom_free_stock_price = 0>
            <cfset prom_free_stock_money = ''>
            <cfset is_no_prom = 0>
            <cfset price_old = "">
            <cfset is_prom_asil_hediye = 0>

            <cfquery name="check_" datasource="#DSN#">
                SELECT QUANTITY,ORDER_ROW_ID FROM #dsn3#.ORDER_PRE_ROWS
                WHERE
                    STOCK_ID = #arguments.stock_id#
                    <cfif isdefined("session.ww") >
                        AND RECORD_CONS = #session_base.userid#
                    <cfelseif isdefined("session.pp")>
                        AND RECORD_PAR = #session_base.userid#
                    <cfelseif isDefined("arguments.cookie_name")>
                        AND COOKIE_NAME = '#arguments.cookie_name#'
                    </cfif>
            </cfquery>
            <cfset old_deger_ = check_.recordcount ? check_.QUANTITY : 0 />
            <cfset son_deger_ = old_deger_ + arguments.quantity>
        <cftransaction>
            <cfif check_.recordcount>
                <cfquery name="add_p" datasource="#DSN#">
                UPDATE
                    #dsn3#.ORDER_PRE_ROWS
                SET
                    QUANTITY = QUANTITY + #arguments.quantity#
                WHERE
                    ORDER_ROW_ID = #check_.ORDER_ROW_ID#
                </cfquery>
            <cfelse>
                <cfquery name="ADD_MAIN_PRODUCT_" datasource="#DSN3#">
                    INSERT INTO
                        ORDER_PRE_ROWS
                        (
                            PRODUCT_ID,
                            CATALOG_ID,
                            PRODUCT_NAME,
                            QUANTITY,
                            PRICE,
                            PRICE_KDV,
                            PRICE_MONEY,
                            TAX,
                            STOCK_ID,
                            PRODUCT_UNIT_ID,
                            PROM_ID,
                            PROM_DISCOUNT,
                            PROM_AMOUNT_DISCOUNT,
                            PROM_COST,
                            PROM_MAIN_STOCK_ID,
                            PROM_STOCK_AMOUNT,
                            IS_PROM_ASIL_HEDIYE,
                            PROM_FREE_STOCK_ID,
                            PRICE_OLD,
                            IS_COMMISSION,
                            IS_CARGO,
                            IS_DISCOUNT,
                            PRICE_STANDARD,
                            PRICE_STANDARD_KDV,
                            PRICE_STANDARD_MONEY,
                            <cfif isdefined("attributes.is_from_seri_sonu") and attributes.is_from_seri_sonu eq 1>
                                IS_FROM_SERI_SONU,
                                SERI_SONU_DEPARTMENT_ID,
                                SERI_SONU_LOCATION_ID,
                            <cfelse>
                                IS_FROM_SERI_SONU,
                            </cfif>
                            RECORD_PERIOD_ID,
                            RECORD_PAR,
                            RECORD_CONS,
                            RECORD_GUEST,
                            RECORD_EMP,
                            COOKIE_NAME,
                            TO_CONS,
                            TO_PAR,
                            TO_COMP,
                            IS_PART,
                            SPEC_VAR_NAME,
                            SPEC_VAR_ID,
                            ORDER_ROW_DETAIL,
                            ORDER_INFO_TYPE_ID,
                            LOT_NO,
                            DIFF_RATE_ID,
                            DISCOUNT1,
                            IS_NONDELETE_PRODUCT,
                            RECORD_IP,
                            RECORD_DATE
                        )
                        VALUES
                        (
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#get_stock.product_id#">,
                            <cfif len(catalog_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#catalog_id#"><cfelse>NULL</cfif>,
                            <cfif trim(get_stock.property) is '-'>
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#get_stock.product_name#">
                            <cfelse>
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#get_stock.product_name# #get_stock.property#">
                            </cfif>,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.quantity#">,
                            <cfqueryparam cfsqltype="cf_sql_float" value="#musteri_flt_other_money_value#">,
                            <cfqueryparam cfsqltype="cf_sql_float" value="#musteri_flt_other_money_value_kdv#">,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#musteri_row_money#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#get_stock.tax#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#get_stock.product_unit_id#">,
                            <cfif len(prom_free_stock_id) and is_no_prom eq 1>
                                NULL,
                                NULL,
                                NULL,
                                NULL,
                            <cfelse>
                                <cfif len(prom_id)>#prom_id#<cfelse>NULL</cfif>,
                                <cfif len(prom_discount)>#prom_discount#<cfelse>NULL</cfif>,
                                <cfif len(prom_amount_discount)>#prom_amount_discount#<cfelse>NULL</cfif>,
                                <cfif len(prom_cost)>#prom_cost#<cfelse>NULL</cfif>,
                            </cfif>
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#prom_stock_amount#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#is_prom_asil_hediye#">,
                            <cfif len(prom_free_stock_id) and is_no_prom neq 1>1<cfelse>0</cfif>,
                            <cfif len(price_old)>#price_old#<cfelse>NULL</cfif>,
                            <cfif isDefined("arguments.is_commission") and arguments.is_commission eq 1>1<cfelse>0</cfif>,
                            <cfif isDefined("arguments.is_cargo") and arguments.is_cargo eq 1>1<cfelse>0</cfif>,
                            <cfif isDefined("arguments.is_discount") and len(arguments.is_discount)>#arguments.is_discount#<cfelse>0</cfif>,
                            <cfqueryparam cfsqltype="cf_sql_float" value="#GET_STOCK.PRICE#">,
                            <cfqueryparam cfsqltype="cf_sql_float" value="#GET_STOCK.PRICE_KDV#">,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#GET_STOCK.MONEY#">,
                            <cfif isdefined("arguments.is_from_seri_sonu") and arguments.is_from_seri_sonu eq 1>
                                1,
                                #arguments.seri_sonu_department_id#,
                                #arguments.seri_sonu_location_id#,
                            <cfelse>
                                0,
                            </cfif>
                            #session_base.period_id#,
                            <cfif isdefined("session.pp")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"><cfelseif isdefined("arguments.watalogy_partner") and len(arguments.watalogy_partner)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.watalogy_partner#"><cfelse>NULL</cfif>,
                            <cfif isdefined("session.ww.userid")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"><cfelse>NULL</cfif>,
                            <cfif not isdefined("session_base.userid")>1<cfelse>0</cfif>,
                            <cfif isdefined("session.ep")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"><cfelse>NULL</cfif>,
                            <cfif isdefined("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")>'#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#'<cfelse>NULL</cfif>,
                            <cfif isDefined("arguments.consumer_id") and len(arguments.consumer_id)>#arguments.consumer_id#,<cfelse>NULL,</cfif>
                            <cfif isDefined("arguments.partner_id") and len(arguments.partner_id)>#arguments.partner_id#,<cfelse>NULL,</cfif>
                            <cfif isDefined("arguments.company_id") and len(arguments.company_id)>#arguments.company_id#,<cfelse>NULL,</cfif>
                            <cfif isdefined('arguments.is_part') and arguments.is_part eq 1>1<cfelse>0</cfif>,
                            <cfif isdefined('arguments.spec_var_name') and len(arguments.spec_var_name)>'#arguments.spec_var_name#'<cfelse>NULL</cfif>,
                            <cfif isdefined('arguments.spec_var_id') and len(arguments.spec_var_id)>#arguments.spec_var_id#<cfelse>NULL</cfif>,
                            <cfif isdefined('arguments.basket_row_detail') and len(arguments.basket_row_detail)>'#arguments.basket_row_detail#'<cfelse>NULL</cfif>,
                            <cfif isdefined('arguments.basket_info_id') and len(arguments.basket_info_id)>#arguments.basket_info_id#<cfelse>NULL</cfif>,
                            <cfif isdefined('arguments.basket_lot_no') and len(arguments.basket_lot_no)>'#arguments.basket_lot_no#'<cfelse>NULL</cfif>,
                            <cfif isdefined('arguments.diff_rate_values') and len(arguments.diff_rate_values)>'#arguments.diff_rate_values#'<cfelse>NULL</cfif>,
                            <cfif isdefined('arguments.discount1') and len(arguments.discount1)>#arguments.discount1#<cfelse>NULL</cfif>,
                            0,
                            '#cgi.remote_addr#',
                            #now()#
                        )
                </cfquery>
            </cfif>
        </cftransaction>
            <cfset response.status = 1>
            <cfset response.message = "Ürün sepete eklendi">
        <cfcatch>
            <cfset response.status = 0>
            <cfset response.message = "Ürün sepete eklenemedi">
        </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(response),'//','')>
    </cffunction>

    <cffunction name="del_product_from_basket" access="remote" returntype="any" returnformat="JSON" hint="Ürünün sepetten silinmesi">
		<cfargument name="product_id" default="">
		<cfargument name="stock_id" default="">
		<cfargument name="consumer_id" default="">
		<cfargument name="partner_id" default="">
        
        <cfset result = structNew() >
        <cfset result.sepet_toplam = 0 >
        <cfset result.sepet_adet = 0 >
		<!--- <cftry> --->
            <cfquery name="add_p" datasource="#DSN#">
                DELETE FROM #dsn3#.ORDER_PRE_ROWS
                WHERE
                    PRODUCT_ID = #arguments.product_id# AND
                    STOCK_ID = #arguments.stock_id# AND
                    <cfif len(arguments.consumer_id)>
                        RECORD_CONS = #arguments.consumer_id#
                    <cfelseif len(arguments.partner_id)>
                        RECORD_PAR  = #arguments.partner_id#
                    <cfelse>
                        COOKIE_NAME = '#evaluate("cookie.wrk_basket_#ReplaceList(cgi.http_host,'-,:','_,_')#")#'
                    </cfif>
            </cfquery>
            <cfset result.status = 1>
            <cfset result.message = "Sepetteki ürün silindi" >
            <!--- <cfcatch type="any">
                <cfset result.status = 0>
                <cfset result.message = "Sepetteki ürün silinemedi" >
            </cfcatch>
        </cftry> --->
        <cfreturn Replace(SerializeJson(result),"//","") >

    </cffunction>

    <cffunction name="show_product_on_basket" access="remote" returnformat="JSON" returntype="any">
		<cfargument name="consumer_id" default="">
		<cfargument name="partner_id" default="">
        <cfargument name="cookie_name" default="">
		<cfif not StructCount(session_base)>
            <cfset dsn2 = '#dsn#_#arguments.period_year#_#arguments.our_company_id#'>
            <cfset dsn3 = '#dsn#_#arguments.our_company_id#'> 
            <cfset session_base.period_id = arguments.period_id> 
            <cfset session_base.period_year = arguments.period_year> 
            <cfset session_base.our_company_id = arguments.our_company_id>
             <cfset session_base.company_id = arguments.our_company_id>
            <cfset session_base.money = arguments.money>
        </cfif>
		<cfset result = structNew() >
        <cfset result.sepet_toplam = 0 >
        <cfset result.sepet_adet = 0 >
        
        <cfset get_products = get_product_to_basket( arguments.consumer_id, arguments.partner_id, arguments.cookie_name) >

        <cfif get_products.recordcount>

            <cfset result.products = queryJSONConverter.returnData(serializeJSON(get_products)) />

            <cfquery name="get_total" dbtype="query">
                SELECT SUM(PRICE_KDV_TL) AS T_TL_PRICE,SUM(QUANTITY) AS T_ADET FROM get_products
            </cfquery>

            <cfif get_total.recordcount>
                <cfset result.sepet_toplam = get_total.T_TL_PRICE>
                <cfset result.sepet_adet = get_total.T_ADET>
            </cfif>	

        </cfif>
        <cfreturn Replace(SerializeJson(result),"//","") >
    </cffunction> 

    <cffunction name="add_order_func" access="remote" returntype="any" returnformat="json">		
		<cfargument name="consumer_id" default="">
		<cfargument name="partner_id" default="">
        <cfargument name="subscription_id" default="">
        <cfargument name="pos_id">
        <cfif not StructCount(session_base)>
            <cfset dsn2 = '#dsn#_#arguments.period_year#_#arguments.our_company_id#'>
            <cfset dsn3 = '#dsn#_#arguments.our_company_id#'> 
            <cfset session_base.period_id = arguments.period_id> 
            <cfset session_base.period_year = arguments.period_year> 
            <cfset session_base.our_company_id = arguments.our_company_id>
            <cfset session_base.company_id = arguments.our_company_id>
            <cfset session_base.money = arguments.money>
        </cfif>
        <cfset result = structNew()>
        <cftry>
            <cfinclude template="../../query/add_order_query.cfm">
            <cfif len(arguments.pos_id)>
            <cfinclude template="../../finance/query/add_credit_card_revenue_new.cfm">
            </cfif>
            <cfset result.status = true>
            <cfset result.message = "Siparişiniz Başarıyla Oluşturuldu." >
        <cfcatch type="any">
            <cfset result.status = false>
            <cfset result.message = "Siparişiniz Oluşturulurken Bir Hata Oluştu!" >
        </cfcatch>
        </cftry>
        
        <cfreturn Replace(serializeJSON(result),'//','')>
	</cffunction>

    <cffunction name="add_payment_company" access="remote" returntype="any" returnformat="json">		
		<cfargument name="consumer_id" default="">
		<cfargument name="partner_id" default="">
        <cfargument name="subscription_id" default="">
        <cfargument name="pos_id">
        <cfset net_total_ = arguments.net_total>
        <cfif not StructCount(session_base)>
            <cfset dsn2 = '#dsn#_#arguments.period_year#_#arguments.our_company_id#'>
            <cfset dsn3 = '#dsn#_#arguments.our_company_id#'> 
            <cfset session_base.period_id = arguments.period_id> 
            <cfset session_base.period_year = arguments.period_year> 
            <cfset session_base.our_company_id = arguments.our_company_id>
            <cfset session_base.company_id = arguments.our_company_id>
            <cfset session_base.money = arguments.money>
        </cfif>
        <cfset dsn3_alias = dsn3>
        <cfset dsn2_alias = dsn2>
        <cfset dsn_alias = dsn> 
        <cfset result = structNew()>
        <!--- <cftry> --->
            <cfif len(arguments.pos_id)>
            <cfinclude template="../../finance/query/add_credit_card_revenue_new.cfm">
            </cfif>
            <cfset result.status = true>
            <cfset result.message = "Ödemeniz Başarıyla Gerçekleşti." >
       <!---  <cfcatch type="any">
            <cfset result.status = false>
            <cfset result.message = "Ödemeniz Alınırken Bir Hata Oluştu!" >
        </cfcatch>
        </cftry> --->
        
        <cfreturn Replace(serializeJSON(result),'//','')>
	</cffunction>
    

    <cffunction name="add_pre_order_func" access="remote" returntype="any" returnformat="json">
        <cfargument name="consumer_id" default="">
		<cfargument name="partner_id" default="">
        <cfargument name="subscription_id" default="">
        <cfargument name="ibanNumber" default="">
        <cfargument name="asset_id" default="">
        <cfset result = structNew()>

        <cftry>
            <cfquery name="add_order_pre" datasource="#dsn3#">
                INSERT INTO ORDER_PRE(
                    STATUS,
                    IBAN_NO,
                    DOMAIN,
                    ASSET_ID,
                    RECORD_PAR,
                    RECORD_CONS,
                    RECORD_GUEST,
                    RECORD_DATE,
                    RECORD_IP
                )VALUES(
                    2,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.ibanNumber#">,
                    <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.http_host#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.asset_id#">,
                    <cfif isdefined("session.pp")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"><cfelse>NULL</cfif>,
                    <cfif isdefined("session.ww")><cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"><cfelse>NULL</cfif>,
                    <cfif not isdefined("session_base.userid")>1<cfelse>0</cfif>,
                    #now()#,
                    '#cgi.remote_addr#'
                )
            </cfquery>
            <cfset result.status = true>
            <cfset result.message = "Sipariş Talebiniz Başarıyla Oluşturuldu." >
            <cfcatch type="any">
                <cfset result.status = false>
                <cfset result.message = "Siparişiniz Talebiniz Oluşturulurken Bir Hata Oluştu!" >
            </cfcatch>
        </cftry>
        <cfreturn Replace(serializeJSON(result),'//','')>
    </cffunction>

    <cffunction name="get_pre_order_products" access="remote" returntype="any">
		<cfargument name="consumer_id" default="">
		<cfargument name="partner_id" default="">

        <cfquery name="get_products" datasource="#DSN#">
            SELECT
                --(SELECT TOP 1 CM.NICKNAME FROM SHIP_METHOD_PRICE SMP, SHIP_METHOD_PRICE_ROW SMPR, COMPANY CM WHERE SMP.SHIP_METHOD_PRICE_ID = SMPR.SHIP_METHOD_PRICE_ID AND SMP.COMPANY_ID = CM.COMPANY_ID AND SMPR.SHIP_METHOD_ID = OPR.SHIPMENT_ID ) AS SHIPMENT_COMP,
                (SELECT C.CONSUMER_EMAIL FROM CONSUMER C WHERE C.CONSUMER_ID = OPR.RECORD_CONS) AS CONSUMER_EMAIL,
                OPR.QUANTITY,
                OPR.PRODUCT_ID,
                OPR.STOCK_ID,
                CASE 
                    WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN
                        OPR.QUANTITY * PRC.PRICE_KDV * (SELECT SM.RATE2/SM.RATE1 FROM SETUP_MONEY SM WHERE SM.MONEY_STATUS = 1 AND SM.MONEY = PRC.MONEY AND SM.PERIOD_ID = #session_base.period_id#)
                    ELSE
                        OPR.QUANTITY * PS.PRICE_KDV * (SELECT SM.RATE2/SM.RATE1 FROM SETUP_MONEY SM WHERE SM.MONEY_STATUS = 1 AND SM.MONEY = PS.MONEY AND SM.PERIOD_ID = #session_base.period_id#)
                END AS PRICE_KDV_TL,
                CASE 
                    WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN
                        OPR.QUANTITY * PRC.PRICE * (SELECT SM.RATE2/SM.RATE1 FROM SETUP_MONEY SM WHERE SM.MONEY_STATUS = 1 AND SM.MONEY = PRC.MONEY AND SM.PERIOD_ID = #session_base.period_id#)
                    ELSE
                        OPR.QUANTITY * PS.PRICE * (SELECT SM.RATE2/SM.RATE1 FROM SETUP_MONEY SM WHERE SM.MONEY_STATUS = 1 AND SM.MONEY = PS.MONEY AND SM.PERIOD_ID = #session_base.period_id#)
                END AS PRICE_TL,
                CASE WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN PRC.PRICE_KDV ELSE PS.PRICE_KDV END AS PRICE_KDV,
                CASE WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN PRC.PRICE ELSE PS.PRICE END AS PRICE,
                CASE WHEN (PRC.PRICE_KDV IS NOT NULL AND PRC.PRICE_KDV > 0) THEN PRC.MONEY ELSE PS.MONEY END AS MONEY,
                '' DELIVER_ID,
                '' INVOICE_DELIVER_ID,
                '' PAYMENT_ID,
                '' SHIPMENT_ID,
                '' ACCOUNT_ID,
                OPR.IS_CARGO,
                OPR.ORDER_ROW_ID,
                '' HAVALE_BANKA,
                '' HAVALE_TARIH,
                '' HAVALE_NO,
                '' ORDER_DETAIL,
                OPR.PRICE AS PRICE_CARGO,
                OPR.RECORD_CONS,
                OPR.RECORD_PAR,
                OPR.SPEC_VAR_ID,
                OPR.IS_SPEC,
                OPR.DISCOUNT1,
                OPR.DISCOUNT2,
                OPR.DISCOUNT3,
                OPR.DISCOUNT4,
                OPR.DISCOUNT5,					
                S.PRODUCT_NAME,
                S.PROPERTY,
                S.TAX,
                S.COUNTER_TYPE_ID,
                PU.MAIN_UNIT,
                PU.PRODUCT_UNIT_ID,
                NULL AS SPEC_VAR_ID,
                ISNULL(OPR.PROM_STOCK_AMOUNT,1) AS PROM_STOCK_AMOUNT,
                OPR.PROM_AMOUNT_DISCOUNT,
                OPR.PROM_DISCOUNT,
                0 AS PRICE_OLD,
                0 AS PROM_COST,
                OPR.PROM_ID,
                OPR.IS_PROM_ASIL_HEDIYE,
                OPR.IS_COMMISSION,
                OPR.IS_PRODUCT_PROMOTION_NONEFFECT,
                OPR.IS_GENERAL_PROM,
                OPR.LOT_NO,
                OPR.DEMAND_ID,
                (SELECT TOP 1 PI.PATH FROM #dsn1#.PRODUCT_IMAGES PI WHERE PI.PRODUCT_ID = OPR.PRODUCT_ID AND PI.IMAGE_SIZE = 2 ORDER BY  PI.PRODUCT_IMAGEID ASC) AS URUN_RESMI,
                ISNULL((SELECT SALEABLE_STOCK FROM  #dsn2#.GET_STOCK_LAST GSL WHERE OPR.STOCK_ID=GSL.STOCK_ID),0) AS STOK_DURUMU
                --,(SELECT DIMENTION FROM #dsn3#.PRODUCT_UNIT PU WHERE PU.PRODUCT_ID = OPR.PRODUCT_ID) AS DESI
            FROM 
                #dsn3#.ORDER_PRE_ROWS OPR
                    LEFT JOIN #dsn1#.PRICE_STANDART PS ON PS.PRODUCT_ID=OPR.PRODUCT_ID
                    LEFT JOIN #dsn3#.STOCKS S ON S.PRODUCT_ID=OPR.PRODUCT_ID
                    LEFT JOIN #dsn3#.PRODUCT_UNIT PU ON S.PRODUCT_ID=PU.PRODUCT_ID
                    LEFT JOIN #dsn3#.PRICE PRC ON 
                            (
                            PRC.PRODUCT_ID = OPR.PRODUCT_ID AND 
                            PRC.PRICE_CATID = #attributes.price_cat_id# AND
                            (PRC.FINISHDATE IS NULL OR PRC.FINISHDATE > #NOW()#)
                            ) 
            WHERE
                PU.IS_MAIN = 1 AND
                PS.PURCHASESALES=1 AND
                PS.PRICESTANDART_STATUS=1
                <cfif len(arguments.consumer_id)>
                    AND RECORD_CONS = #arguments.consumer_id#
                <cfelseif len(arguments.partner_id)>
                    AND RECORD_PAR = #arguments.partner_id#
                <cfelseif isDefined("arguments.cookie_name")>
                    AND COOKIE_NAME = '#arguments.cookie_name#'
                </cfif>
            ORDER BY 
                OPR.IS_CARGO ASC
        </cfquery>
		<cfreturn get_products>
	</cffunction>

    <cffunction name="get_consumer_func" access="remote" returntype="query">
		<cfargument name="consumer_id" default="">
		<cfquery name="get_consumer" datasource="#DSN#">
			SELECT 
				C.*,
				HC.COUNTY_NAME AS HOME_COUNTY_NAME,
				HCITY.CITY_NAME AS HOME_CITY_NAME,
				WC.COUNTY_NAME AS WORK_COUNTY_NAME,
				WCITY.CITY_NAME AS WORK_CITY_NAME
			FROM 
				CONSUMER C
					LEFT JOIN SETUP_COUNTY AS HC ON (HC.COUNTY_ID = C.HOME_COUNTY_ID)
					LEFT JOIN SETUP_CITY AS HCITY ON (HCITY.CITY_ID = C.HOME_CITY_ID)
					LEFT JOIN SETUP_COUNTY AS WC ON (WC.COUNTY_ID = C.WORK_COUNTY_ID)
					LEFT JOIN SETUP_CITY AS WCITY ON (WCITY.CITY_ID = C.WORK_CITY_ID)
			WHERE 
				C.CONSUMER_ID = #arguments.consumer_id#
		</cfquery>
		<cfreturn get_consumer>	
	</cffunction>
	
	<cffunction name="get_company_func" access="remote" returntype="query">
		<cfargument name="company_id" default="">
		<cfquery name="get_company" datasource="#DSN#">
			SELECT 
				C.*,
				C.COMPANY_ADDRESS AS WORKADDRESS,
				C.COMPANY_POSTCODE AS WORKPOSTCODE,
				C.CITY AS WORK_CITY_ID ,
				C.COUNTY AS WORK_COUNTY_ID ,
				'' AS HOMEADDRESS,
				'' AS HOME_COUNTY_NAME,
				'' AS HOME_CITY_NAME,
				WC.COUNTY_NAME AS WORK_COUNTY_NAME,
				WCITY.CITY_NAME AS WORK_CITY_NAME,
				C.TAXNO AS TAX_NO,
				C.TAXOFFICE AS TAX_OFFICE,
				C.COMPANY_EMAIL AS CONSUMER_EMAIL
			FROM 
				COMPANY C
					LEFT JOIN SETUP_COUNTY AS WC ON (WC.COUNTY_ID = C.COUNTY)
					LEFT JOIN SETUP_CITY AS WCITY ON (WCITY.CITY_ID = C.CITY)
			WHERE 
				C.COMPANY_ID = #arguments.company_id#
		</cfquery>
		<cfreturn get_company>	
	</cffunction>

    <cffunction name="add_offer_func" access="remote" returntype="any" returnformat="JSON">
        <cfargument name="consumer_id" default="">
		<cfargument name="partner_id" default="">
        <cfargument name="paymethod_id" default="">
        <cfargument name="paymethod" default="">
        <cfargument name="offer_detail" default="">
        <cfset response = structNew()>

        <cftry>
            <cftransaction>
                <cfquery name="GET_OFFER_CODE" datasource="#DSN#">
                    SELECT 
                        OFFER_NO, 
                        OFFER_NUMBER 
                    FROM
                        #DSN3#.GENERAL_PAPERS
                    WHERE 
                        PAPER_TYPE = 0 
                        AND ZONE_TYPE = 0
                </cfquery>
                <cfquery name="UPD_OFFER_CODE" datasource="#DSN#">
                    UPDATE 
                        #DSN3#.GENERAL_PAPERS 
                    SET 
                        OFFER_NUMBER = OFFER_NUMBER + 1
                    WHERE 
                        PAPER_TYPE = 0 AND ZONE_TYPE = 0
                </cfquery>

                <cfquery name="GET_PROCESS" datasource="#DSN#" maxrows="1">
                    SELECT TOP 1
                        PTR.STAGE,
                        PTR.PROCESS_ROW_ID 
                    FROM
                        PROCESS_TYPE_ROWS PTR,
                        PROCESS_TYPE_OUR_COMPANY PTO,
                        PROCESS_TYPE PT
                    WHERE
                        PT.IS_ACTIVE = 1 AND
                        PT.PROCESS_ID = PTR.PROCESS_ID AND
                        PT.PROCESS_ID = PTO.PROCESS_ID AND
                        <cfif isdefined("session.pp")>
                            PTR.IS_PARTNER = 1 AND
                            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
                        <cfelseif isdefined("session.ww")>
                            PTR.IS_CONSUMER = 1 AND
                            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
                        <cfelse>
                            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                        </cfif>
                        PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%sales.list_offer%">
                    ORDER BY 
                        PTR.PROCESS_ROW_ID
                </cfquery>
                <!--- <cfdump var="#GET_PROCESS.recordcount#" abort> --->

                <cfif GET_PROCESS.recordcount eq 0>
                    <cfset response.status = false >
                    <cfset response.message = "Teklif süreç tanımlarınız yapılmamış, lütfen sistem yöneticisiyle iletişime geçiniz" >
                <cfelse>
                    <cfquery name="ADD_OFFER" datasource="#DSN#" result="MAX_ID">
                        INSERT INTO 
                            #DSN3#.OFFER(
                                SALES_PARTNER_ID,
                                CONSUMER_ID,
                                PARTNER_ID,
                                COMPANY_ID,
                                OFFER_ZONE,
                                OFFER_STATUS,
                                OFFER_CURRENCY,
                                OFFER_NUMBER,
                                PAYMETHOD,						
                                OFFER_TO,
                                OFFER_TO_PARTNER,
                                INCLUDED_KDV,
                                DELIVERDATE,
                                DELIVER_PLACE,
                                LOCATION_ID,
                                PURCHASE_SALES,
                                STARTDATE,
                                FINISHDATE,
                                IS_PUBLIC_ZONE,
                                IS_PARTNER_ZONE, 
                                OFFER_HEAD,
                                OFFER_DETAIL,
                                OFFER_STAGE,
                                OFFER_DATE,
                                PRIORITY_ID,
                                PRICE,
                                SHIP_METHOD,
                                CARD_PAYMETHOD_ID,
                                CARD_PAYMETHOD_RATE,
                                SHIP_ADDRESS,
                                DUE_DATE,
                                CITY_ID,
                                COUNTY_ID,
                                RECORD_DATE,
                                RECORD_IP,
                                RECORD_CONS,
                                RECORD_PAR
                            )
                            VALUES(
                                <cfif isDefined("session.pp")>#session.pp.userid#<cfelse>NULL</cfif>,
                                <cfif isdefined("session.ww")>
                                    #session.ww.userid#,
                                    NULL,
                                    NULL,
                                <cfelse>
                                    NULL,
                                    #session.pp.userid#,
                                    #session.pp.company_id#,
                                </cfif>
                                1,
                                1,
                                -2,
                                '#GET_OFFER_CODE.OFFER_NO#-#GET_OFFER_CODE.OFFER_NUMBER#',
                                <cfif len(arguments.paymethod_id) and len(arguments.paymethod)>#arguments.paymethod_id#<cfelse>NULL</cfif>,
                                <cfif isdefined("session.pp")>
                                ',#session.pp.company_id#,',
                                ',#session.pp.userid#,',
                                <cfelse>
                                '',
                                '',
                                </cfif>
                                0,
                                #now()#,
                                0,
                                NULL,	
                                0,
                                NULL,
                                NULL,
                                <cfif isdefined("session.ww")>1,<cfelse>0,</cfif>
                                <cfif isDefined("session.pp")>1,<cfelse>0,</cfif> 
                                '#cgi.server_name# - Teklif Talebi',
                                <cfif isdefined("arguments.offer_detail") and len(arguments.offer_detail)>'#arguments.offer_detail#'<cfelse>NULL</cfif>,
                                #GET_PROCESS.PROCESS_ROW_ID#,
                                #now()#,
                                NULL,
                                0,
                                NULL,
                                NULL,
                                NULL,
                                NULL,
                                #now()#,
                                NULL,
                                NULL,
                                #now()#,
                                '#cgi.remote_addr#',
                                <cfif isdefined("session.ww")>
                                    #session.ww.userid#,
                                    NULL
                                <cfelse>
                                    NULL,
                                    #session.pp.userid#
                                </cfif>
                            )
                    </cfquery>

                    <cfset get_rows = this.get_pre_order_products( consumer_id:'#arguments.consumer_id#', partner_id:'#arguments.partner_id#' )>

                    <cfoutput query="get_rows">
                        <cfquery name="ADD_PRODUCT_TO_OFFER" datasource="#DSN#">
                            INSERT INTO 
                                #DSN3#.OFFER_ROW (
                                    OFFER_ID, 
                                    PRODUCT_ID,
                                    STOCK_ID,
                                    QUANTITY,
                                    UNIT,
                                    UNIT_ID,
                                    PRICE,
                                    TAX,
                                    PRODUCT_NAME,
                                    DELIVER_DATE
                                )
                            VALUES(
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#quantity#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="Adet">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_UNIT_ID#">,					
                                <cfqueryparam cfsqltype="cf_sql_float" value="#price#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#tax#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#PRODUCT_NAME#">,
                                #now()#
                                )
                        </cfquery>
                    </cfoutput>

                    <cfif isdefined("session.pp") or isdefined("session.ww")>
                        <cfmail to="#session_base.email#" from="Workcube Toplulugu<workcube@workcube.com>" subject="Teklif Talebiniz Alınmıştır" type="HTML">
                            Merhaba #session_base.name# #session_base.surname#;<br><br>
                            
                            Teklif talebiniz başarıyla alınmıştır!<br><br>
                            Teklif içeriğiniz aşağıdaki gibidir.<br><br>

                            <table border="1" cellpadding="0" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th style="padding: 8px 15px;">Ürün</th>
                                        <th style="text-align:center; padding: 8px 15px;">Miktar</th>
                                        <th style="padding: 8px 15px;">Birim</th>
                                        <th style="text-align:center;padding: 8px 15px;" colspan="2">Br. Fiyat</th>
                                        <th style="padding: 8px 15px;">KDV</th>
                                        <th style="text-align:right;padding: 8px 15px;">KDV'li Fiyat</th>
                                        <th style="text-align:center;padding: 8px 15px;" colspan="2">KDV'siz Toplam</th>
                                        <th style="text-align:center;padding: 8px 15px;" colspan="2">KDV'li Toplam</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <cfloop query="#get_rows#">
                                        <tr>
                                            <td style="padding: 8px 15px;">#PRODUCT_NAME#</td>
                                            <td style="text-align:center;padding: 8px 15px;">#QUANTITY#</td>
                                            <td style="padding: 8px 15px;">#MAIN_UNIT#</td>
                                            <td style="text-align:right;padding: 8px 15px;">#functions.TLFormat(PRICE)#</td>
                                            <td style="padding: 8px 15px;">#MONEY#</td>
                                            <td style="padding: 8px 15px;">#TAX#</td>
                                            <td style="text-align:right;padding: 8px 15px;">#functions.TLFormat(PRICE_KDV)#</td>
                                            <td style="text-align:right;padding: 8px 15px;">#functions.TLFormat(PRICE_TL)#</td>
                                            <td style="padding: 8px 15px;">#session_base.MONEY#</td>
                                            <td style="text-align:right;padding: 8px 15px;">#functions.TLFormat(PRICE_KDV_TL)#</td>
                                            <td style="padding: 8px 15px;">#session_base.MONEY#</td>
                                        </tr>
                                    </cfloop>
                                </tbody>
                            </table>
                        </cfmail>
                    </cfif>

                    <cfquery name="del_rows" datasource="#dsn#">
                        DELETE FROM
                            #DSN3#.ORDER_PRE_ROWS
                        WHERE
                            <cfif isdefined("session.pp")>
                                RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> AND
                            <cfelseif isdefined("session.ww.userid")>
                                RECORD_CONS = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
                            </cfif>
                            PRODUCT_ID IS NOT NULL
                    </cfquery>

                    <cfset response.status = true >
                    <cfset response.message = "Teklif talebiniz başarıyla alınmıştır. Sizinle en kısa sürede iletişime geçilecektir" >
                </cfif>
            </cftransaction>
            <cfcatch>
                <cfset response.status = false >
                <cfset response.message = "Teklif talebiniz sırasında beklenmedik hata oluştu, lütfen sistem yöneticisiyle iletişime geçiniz" >
            </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(response),'//','')>>
    </cffunction>
    
</cfcomponent>