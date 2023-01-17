<link type="text/css" rel="stylesheet" href="/themes/protein_project/assets/css/magicthumb.css"/>
<script type="text/javascript" src="/themes/protein_project/assets/js/magicthumb.js"></script>
<style>
	.mgt-figure div, .mgt-figure span, .MagicThumb div, .MagicThumb span{display:none!important}
    #thumbnails {display: flex;width: 100%;margin:10px 0px;height: auto;flex-direction: row;align-content: center;}
    .margin{margin-top:5px;}
</style>
<cfparam  name="attributes.pid" default="#attributes.param_2#">
<cfparam  name="attributes.sid" default="#attributes.param_3#">

<cfset product_action = createObject("component", "cfc.data")>
<cfinclude template="last_visited_5_products_cookie.cfm">

<cfif isdefined("attributes.pid") and not isdefined("attributes.stock_id")>
	<cfquery name="GET_STOCK_ID" datasource="#DSN3#" maxrows="1">
		SELECT 
			STOCK_ID
		FROM 
			STOCKS 
		WHERE 
			PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
	</cfquery>
	<cfset attributes.sid = get_stock_id.stock_id>
	<cfset attributes.stock_id = get_stock_id.stock_id>
</cfif>

<cfif (isdefined('attributes.is_price') and attributes.is_price eq 1) or (isdefined('attributes.is_basket') and attributes.is_basket eq 1) or (isdefined('attributes.is_basket') and attributes.is_basket eq 2 and isdefined('session_base.userid'))>
	<cfif not isdefined("attributes.price_catid_2") and not isdefined("attributes.price_kdv")>
		<cfset fiyat_product_id = attributes.pid>
		<cfset fiyat_stock_id = attributes.stock_id>
		<cfinclude template="get_product_fiyat.cfm">
		<cfif not get_active_product.recordcount>
			<script type="text/javascript">
				alert('<cf_get_lang dictionary_id='62453.Seçilen ürünle ilgili fiyat tanımlaması yapılmamış'>');
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfquery name="GET_PRICE" dbtype="query">
			SELECT * FROM GET_ACTIVE_PRODUCT
		</cfquery>
	</cfif>
</cfif>

<cfset attributes.catid = get_active_product.product_catid>
<cfquery name="get_product_images" datasource="#DSN3#" maxrows="8">
	SELECT 
    	PATH,
        PRODUCT_ID,
        PATH_SERVER_ID,
        DETAIL 
    FROM 
    	PRODUCT_IMAGES 
    WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> 
    ORDER BY 
    	PRODUCT_IMAGEID DESC
</cfquery>
<cfif isdefined("attributes.prom_id") and len(attributes.prom_id)>
	<cfquery name="GET_PRO" datasource="#DSN3#">
		SELECT 
			P.PROM_ID,
			P.DISCOUNT,
			P.AMOUNT_DISCOUNT,
			P.AMOUNT_DISCOUNT_MONEY_1,
			P.TOTAL_PROMOTION_COST,
			P.FREE_STOCK_ID,
			P.LIMIT_VALUE,
			P.FREE_STOCK_AMOUNT,
			P.FREE_STOCK_PRICE,
			P.AMOUNT_1_MONEY
		FROM 						
			PROMOTIONS P
		WHERE 
			P.PROM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prom_id#">
	</cfquery>
	<cfif get_pro.recordcount>
		<cfscript>
			prom_id = get_pro.prom_id;
			prom_discount = get_pro.discount;
			prom_amount_discount = get_pro.amount_discount;
			if(len(get_pro.amount_discount_money_1))
				prom_amount_discount_money = get_pro.amount_discount_money_1;
			else
				prom_amount_discount_money = attributes.price_money;
			prom_cost = get_pro.total_promotion_cost;
			prom_free_stock_id =  get_pro.free_stock_id;
			if(len(get_pro.limit_value)) prom_stock_amount = get_pro.limit_value;
			if(len(get_pro.free_stock_amount)) prom_free_stock_amount = get_pro.free_stock_amount;
			if(len(get_pro.free_stock_price)) prom_free_stock_price = get_pro.free_stock_price;
			if(len(get_pro.amount_1_money)) 
				prom_free_stock_money = get_pro.amount_1_money;
			else if(len(get_pro.amount_discount_money_1))
				prom_free_stock_money = get_pro.amount_discount_money_1;
		</cfscript>
	</cfif>
</cfif>
<cfif isdefined("attributes.is_last_user_price_list") and attributes.is_last_user_price_list eq 1 and isdefined("attributes.last_user_price_list") and not len(attributes.last_user_price_list)>
    <cfscript>
        get_price_list = DeserializeJson(product_action.GET_CREDIT_LIMIT());
        attributes.last_user_price_list = DeserializeJson(get_price_list.price_catid);
    </cfscript>
</cfif>
<cfset get_product_stocks = product_action.get_product_stocks( product_id: attributes.pid, not_stock_id: attributes.sid, last_user_price_list: attributes.last_user_price_list?:'' ) />

<cfif isdefined('attributes.is_summary_view') and attributes.is_summary_view eq 1>
    <cfif get_active_product.is_karma eq 1>
        <cfset attributes.is_karma = 1>
    </cfif>
    <cfoutput query="get_active_product">
        <cfquery name="GET_LANGUAGE_INFO" datasource="#DSN#">
            SELECT
                ITEM
            FROM
                SETUP_LANGUAGE_INFO
            WHERE
                <cfif isdefined('session.pp')>
                    LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.pp.language#"> AND
                <cfelse>
                    LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ww.language#"> AND
                </cfif>
                COLUMN_NAME = 'PRODUCT_NAME' AND
                TABLE_NAME = 'PRODUCT' AND
                UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
        </cfquery>

        <div class="product_detail">
            <div class="col col-4">
                <cfif get_product_images.recordcount>	
                    <div style="height:230px;width:100%;">
                        <a id="mgt-1" class="MagicThumb" href="/documents/product/#get_product_images.path#" style="display:inline;position:static;">
                            <img src="/documents/product/#get_product_images.path#" style="max-height:230px;width:100%;"/>
                        </a>
                    </div>
                    <div id="thumbnails" class="product_slider">
                        <cfloop query="#get_product_images#">
                            <a data-thumb-id="mgt-1" href="/documents/product/#get_product_images.path#" data-image="/documents/product/#get_product_images.path#">
                                <img src="/documents/product/#get_product_images.path#"/>
                            </a>
                        </cfloop>
                    </div>
                </cfif>
            </div>
            <div class="col col-8">
                <div class="product_detail_text">
                    <h2><cfif get_language_info.recordcount>#get_language_info.item#<cfelse>#product_name#</cfif></h1>
                    <div class="details">
                        <div style="font-size:18px;">#product_detail#</div>
                        <div style="font-size:16px;" class="margin"><small><b>#product_detail2#</b></small></div>
                    </div>
                    <ul class="margin">
                        <cfif attributes.is_brand eq 1>
                            <li>
                                <i class="i_size"><cf_get_lang_main no='1435.Marka'> :</i>
                                <cfif len(brand_id)>
                                    <cfset attributes.brand_id = brand_id>
                                    <cfinclude template="../query/get_product_brand.cfm">
                                    <a href="#request.self#?fuseaction=objects2.view_product_list&brand_id=#brand_id#" class="inner_menu_link" style="color:##2e2f4f;">#get_product_brand.brand_name#</a>
                                </cfif>
                            </li>
                        </cfif>
                            <li class="margin">
                                <i class="i_size">Kategori :</i>
                                #PRODUCT_CAT#
                            </li>
                        <cfif attributes.is_model eq 1>
                            <li class="margin">
                                <i class="i_size"><cf_get_lang_main no='813.Model'> :</i>
                                #short_code#
                            </li>
                        </cfif>
                        <cfif attributes.is_product_code eq 1>
                            <li class="margin">
                                <i class="i_size"><cf_get_lang_main no='1388.ürün Kodu'> :</i>
                                #product_code#
                            </li>
                        </cfif>
                        <cfif isdefined("attributes.is_stock_code") and attributes.is_stock_code eq 1>
                            <li class="margin">
                                <i class="i_size"><cf_get_lang_main no='1388.ürün Kodu'> :</i>
                                #product_code_2#
                            </li>
                        </cfif>
                        <cfif attributes.is_stock_count eq 1>
                            <li class="margin">
                                <i class="i_size"><cf_get_lang dictionary_id='32542.Stok Durumu'> :</i>
                                <cfset product_id = get_active_product.product_id>
                                <cfinclude template="../query/get_product_amount.cfm">
                                <cfif len(product_stock)>
                                    <cfif isnumeric(product_stock)>
                                        <cfif product_stock lt 0>0
                                        <cfelseif product_stock lt 5>
                                            <cfif isnumeric(product_stock)>
                                                #amountformat(product_stock,0)#
                                            <cfelse>
                                                #product_stock#
                                            </cfif>
                                        <cfelseif product_stock lt 10>5+
                                        <cfelseif product_stock lt 20>10+
                                        <cfelseif product_stock lt 50>20+
                                        <cfelseif product_stock lt 100>50+
                                        <cfelse>100+
                                        </cfif>
                                    </cfif>
                                <cfelse>
                                    0
                                </cfif>
                            </li>
                        </cfif>
                        <cfif (attributes.is_price eq 1) or (attributes.is_basket eq 1) or (attributes.is_basket eq 2 and isdefined('session_base.userid'))>
                            <cfquery name="GET_MONEY_INFO" datasource="#DSN2#">
                                SELECT 
                                    (RATE2/RATE1) RATE
                                FROM 
                                    SETUP_MONEY
                                WHERE
                                    MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.price_standard_money#">
                            </cfquery>
                        </cfif>
                        <cfif attributes.is_price_kdvsiz eq 1>
                            <!--- <li> --->
                                <!--- <i class="i_size"><cf_get_lang dictionary_id='32998.VAT Excluded'> :</i> --->
                                <cfif isdefined("attributes.prom_id") and len(attributes.prom_id) and (len(prom_discount) or len(prom_amount_discount)) and get_pro.recordcount>
                                    <strike>
                                        <cfset var_amount = "#TLFormat(get_price.price*get_money_info.rate)#">
                                        <!--- #TLFormat(get_price.price*get_money_info.rate)# --->
                                        <cfif isdefined("session.ww")><cfset var_money = "#session.ww.money#"><!--- #session.ww.money# ---><cfelseif isdefined("session.pp")><cfset var_money = "#session.pp.money#"><!--- #session.pp.money# ---><cfelse><cfset var_money = "#session.ep.money#"><!--- #session.ep.money# ---></cfif>
                                        <cfif get_price.money is not '#session_base.money#'>
                                            (#TLFormat(get_price.price)# #get_price.money#)
                                        </cfif>
                                    </strike>
                                <cfelse>
                                    <cfif isdefined('attributes.is_product_money') and attributes.is_product_money eq 0>
                                        <cfset var_amount = "#TLFormat(get_price.price*get_money_info.rate)#">
                                        <!--- #TLFormat(get_price.price*get_money_info.rate)#  --->
                                        <cfif isdefined("session.ww")><cfset var_money = "#session.ww.money#"><!--- #session.ww.money# ---><cfelseif isdefined("session.pp")><cfset var_money = "#session.pp.money#"><!--- #session.pp.money# ---><cfelse><cfset var_money = "#session.ep.money#"><!--- #session.ep.money# ---></cfif>
                                        <cfif get_price.money is not '#session_base.money#'>(#TLFormat(get_price.price)# #get_price.money#)</cfif>
                                    <cfelse>
                                        <cfset var_amount = "#TLFormat(get_price.price)#">
                                        <cfset var_money = attributes.price_money />
                                        <!--- #TLFormat(get_price.price)# #attributes.price_money# --->
                                    </cfif>
                                </cfif>
                            <!--- </li> --->
                        </cfif>
                        <cfif isDefined('attributes.is_price_kdv') and attributes.is_price_kdv eq 1 and isdefined("session.pp")>
                            <li class="margin">
                                <i class="i_size"><cf_get_lang dictionary_id='34463.KDV li'> :</i>
                                #TLFormat(attributes.price_kdv)# #attributes.price_money#
                                <cfset kdvIncludeAmout = TLFormat(attributes.price_kdv) />
                                <cfset kdvIncludeMoney = attributes.price_money />
                                <cfif attributes.is_price_kdvsiz eq 0>
                                    <cfset var_amount = kdvIncludeAmout>
                                    <cfset var_money = kdvIncludeMoney>
                                </cfif>
                            </li>
                        <cfelseif isDefined('attributes.is_price_kdv') and attributes.is_price_kdv eq 1>
                            <cfif (isdefined('attributes.is_price') and attributes.is_price eq 1) or (isdefined('attributes.is_basket') and attributes.is_basket eq 1) or (isdefined('attributes.is_basket') and attributes.is_basket eq 2 and isdefined('session_base.userid'))>
                                <cfif not isdefined("attributes.campaign_basket")>
                                    <li class="margin">
                                        <!--- <i class="i_size"><cf_get_lang dictionary_id='34463.KDV li'> :</i> --->
                                        <cfif isdefined("attributes.prom_id") and len(attributes.prom_id) and (len(prom_discount) or len(prom_amount_discount)) and get_pro.recordcount>
                                            <strike>
                                                <cfset kdvIncludeAmout = TLFormat(get_price.price_kdv*get_money_info.rate) />
                                                <!--- #TLFormat(get_price.price_kdv*get_money_info.rate)#  --->
                                                <cfif isdefined("session.ww")><cfset kdvIncludeMoney = session.ww.money /> #session.ww.money#<cfelseif isdefined("session.pp")><cfset kdvIncludeMoney = session.pp.money /><!--- #session.pp.money# ---><cfelse><cfset kdvIncludeMoney = session.ep.money /><!--- #session.ep.money# ---></cfif>
                                                <cfif get_price.money is not '#session_base.money#'>(#TLFormat(get_price.price_kdv)# #get_price.money#)</cfif>
                                            </strike>
                                        <cfelse>
                                            <cfif isdefined('attributes.is_product_money') and attributes.is_product_money eq 0>
                                                <cfset kdvIncludeAmout = TLFormat(get_price.price_kdv*get_money_info.rate) />
                                                <!--- #TLFormat(get_price.price_kdv*get_money_info.rate)# --->
                                                <cfif isdefined("session.ww")><cfset kdvIncludeMoney = session.ww.money /> #session.ww.money#<cfelseif isdefined("session.pp")><cfset kdvIncludeMoney = session.pp.money /><!--- #session.pp.money# ---><cfelse><cfset kdvIncludeMoney = session.ep.money /><!--- #session.ep.money# ---></cfif>
                                                <cfif get_price.money is not '#session_base.money#'>(#TLFormat(get_price.price_kdv)# #get_price.money#)</cfif>
                                            <cfelse>
                                                <cfset kdvIncludeAmout = TLFormat(get_price.price_kdv) />
                                                <cfset kdvIncludeMoney = get_price.money />
                                                <!--- #TLFormat(get_price.price_kdv)# #get_price.money# --->
                                            </cfif>
                                        </cfif>
                                        <cfif attributes.is_price_kdvsiz eq 0>
                                            <cfset var_amount = kdvIncludeAmout>
                                            <cfset var_money = kdvIncludeMoney>
                                        </cfif>
                                    </li>
                                </cfif>
                            </cfif>
                        </cfif>
                        <cfif attributes.is_price eq 1>
                            <cfif (isdefined('session.ww.userid') or isdefined('session.pp.userid')) and (isdefined('attributes.is_price_member') and attributes.is_price_member neq 2)>
                                <li class="margin">
                                    <i class="i_size"><cf_get_lang no='412.Size Ozel Fiyat'> :</i>
                                    <cfif isdefined('attributes.is_price_member') and attributes.is_price_member eq 0>
                                        <cfset musteri_flt_other_money_value_kdv = musteri_flt_other_money_value*(1+(tax/100))>
                                        <cfif isdefined('attributes.is_product_money') and attributes.is_product_money eq 0>
                                            #TLFormat(musteri_flt_other_money_value_kdv*get_money_info.RATE)# <cfif isdefined("session.ww")>#session.ww.money#<cfelseif isdefined("session.pp")>#session.pp.money#<cfelse>#session.ep.money#</cfif>
                                            <cfif musteri_str_other_money is not '#session_base.money#'>(#TLFormat(musteri_flt_other_money_value_kdv)# #musteri_str_other_money#)</cfif>
                                        <cfelse>
                                            #TLFormat(musteri_flt_other_money_value_kdv)# #musteri_str_other_money#
                                        </cfif>
                                    <cfelse>
                                        <cfif isdefined('attributes.is_product_money') and attributes.is_product_money eq 0>
                                        #TLFormat(musteri_flt_other_money_value*get_money_info.RATE)# <cfif isdefined("session.ww")>#session.ww.money#<cfelseif isdefined("session.pp")>#session.pp.money#<cfelse>#session.ep.money#</cfif>
                                            <cfif musteri_str_other_money is not '#session_base.money#'>(#TLFormat(musteri_flt_other_money_value)# #musteri_str_other_money#)</cfif> + KDV
                                        <cfelse>
                                            #TLFormat(musteri_flt_other_money_value)# #musteri_str_other_money# + KDV
                                        </cfif>
                                    </cfif>
                                </li>
                                <cfif isdefined('attributes.is_price_profit') and attributes.is_price_profit eq 1>
                                    <li class="margin">
                                        <cfset my_profit = get_price.price_kdv-attributes.price_kdv>
                                        <i class="i_size">Kazancınız :</i>
                                        #TLFormat(my_profit)# #musteri_row_money#
                                    </li>
                                </cfif>
                            </cfif>
                            <cfif isdefined("attributes.campaign_basket")>
                                <li class="margin">
                                    <i class="i_size"><cf_get_lang no='272.Kampanya Fiyati' > :</i>
                                    #tlformat(attributes.price)# #attributes.price_money#
                                </li>
                                <cfif attributes.is_price_kdv eq 1>
                                    <li class="margin">
                                        <i class="i_size"><cf_get_lang no='397.Kampanya KDV li Fiyati'> :</i>
                                        #tlformat(attributes.price_kdv)# #attributes.price_money#
                                    </li>	
                                </cfif>
                            <cfelse>
                                <cfif not isdefined("attributes.is_karma")><!---karma koli ise son fiyat gelmesin  --->
                                    <cfif isdefined("attributes.prom_id") and len(attributes.prom_id) and len(prom_discount) and get_pro.recordcount>
                                        <li class="margin">
                                            <i class="i_size"><cf_get_lang no ='1197.Indirimli'> :</i>
                                            <cfquery name="GET_MONEY_INFO" datasource="#DSN2#">
                                                SELECT 
                                                    (RATE2/RATE1) RATE
                                                FROM 
                                                    SETUP_MONEY
                                                WHERE
                                                    MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_price.money#">
                                            </cfquery>
                                            <cfset kur_price = (attributes.price_kdv*get_money_info.rate)>
                                            <cfset indirim_tutar_ = (kur_price/((100-prom_discount)/100)) - kur_price>						
                                            #TLFormat(kur_price)# #session_base.money# -
                                            <cfif len(prom_discount)>
                                                <strong><cf_get_lang no='132.Yzde Indirim'>:</strong> % #prom_discount#
                                            </cfif>
                                        </li>
                                    </cfif>
                                    <cfif isdefined("attributes.prom_id") and len(attributes.prom_id) and len(prom_amount_discount) and get_pro.recordcount>
                                        <li class="margin">
                                            <i class="i_size"><cf_get_lang no ='1197.Indirimli'> :</i>
                                            <cfquery name="GET_MONEY_INFO" datasource="#DSN2#">
                                                SELECT 
                                                    (RATE2/RATE1) RATE
                                                FROM 
                                                    SETUP_MONEY
                                                WHERE
                                                    MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_price.money#">
                                            </cfquery>
                                            <cfset kur_price = (attributes.price_kdv*get_money_info.rate)>
                                            <cfif len(prom_amount_discount_money) and get_price.money is not prom_amount_discount_money>										
                                                <cfquery name="GET_MONEY_INFO_" datasource="#DSN2#">
                                                SELECT
                                                    (RATE2/RATE1) RATE
                                                FROM 
                                                    SETUP_MONEY
                                                WHERE
                                                    MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#prom_amount_discount_money#">
                                                </cfquery>
                                                <cfset indirim_tutar_ = (prom_amount_discount/get_money_info.rate*get_money_info_.rate)>
                                            <cfelse>
                                                <cfset indirim_tutar_ = prom_amount_discount*get_money_info.rate>
                                            </cfif>
                                            <cfset indirim_tutar_kdvli = indirim_tutar_ + (indirim_tutar_ * get_active_product.tax/100)>
                                            #TLFormat(kur_price-indirim_tutar_)# #session_base.money# -
                                            <cfif len(prom_amount_discount)>
                                                <strong><cf_get_lang no='133.Tutar Indirim'>:</strong> #prom_amount_discount# #prom_amount_discount_money#
                                            </cfif>
                                        </li>
                                    </cfif>
                                </cfif>
                            </cfif>
                            <cfif attributes.price_catid_2 neq -2>
                                <cfif isdefined('session.pp.userid') and isdefined("attributes.campaign_basket")>
                                    <li class="margin">
                                        <i class="i_size"><cf_get_lang no='396.Is Ortagi Fiyati'> :</i>
                                        #TLFormat(attributes.price)# #attributes.price_money#
                                    </li>
                                <cfelseif isdefined('session.pp.userid') or isdefined('session.ww.userid') and (isdefined('attributes.is_price_member') and attributes.is_price_member neq 2)>
                                    <li class="margin">
                                        <i class="i_size"><cf_get_lang no ='1199.Size zel'> :</i>
                                        <cfif isdefined('attributes.is_product_money') and attributes.is_product_money eq 0>
                                            #TLFormat(attributes.price_kdv * get_money_info.RATE)# #session_base.money#
                                        <cfelse>
                                            #TLFormat(attributes.price_kdv)# #get_price.money#
                                        </cfif>
                                    </li>
                                </cfif>
                            </cfif>
                        </cfif>
                        <cfquery name="GET_HAVALE" datasource="#DSN#" maxrows="1"><!--- standart deme yntemlernden uygun havale deme yntemi alinir --->
                            SELECT PAYMETHOD_ID,PAYMETHOD,DUE_DAY,FIRST_INTEREST_RATE FROM SETUP_PAYMETHOD WHERE IN_ADVANCE=100<!--- pesinat orani ---> AND DUE_DAY=0<!--- vade gn ---> AND PAYMENT_VEHICLE=3<!--- deme araci havale --->
                        </cfquery>
                        <cfif isdefined('attributes.price_kdv') and attributes.is_price_kdv eq 1>
                            <cfif get_havale.recordcount and len(get_havale.first_interest_rate)>
                                <li class="margin">
                                    <i class="i_size"><cf_get_lang no ='1200.Havale Ile'></i>
                                    #TLFormat((attributes.price_kdv * get_money_info.rate) - (attributes.price_kdv * get_money_info.rate) * get_havale.first_interest_rate / 100)# #session_base.money# (% #get_havale.first_interest_rate# Indirimli)
                                </li>
                            </cfif>
                        <cfelseif attributes.is_price_kdvsiz eq 1>
                            <cfif get_havale.recordcount and len(get_havale.first_interest_rate)>
                                <li class="margin">
                                    <i class="i_size"><cf_get_lang no ='1200.Havale Ile'> :</i>
                                    #TLFormat((attributes.price * get_money_info.rate) - (attributes.price * get_money_info.rate) * get_havale.first_interest_rate / 100)# #session_base.money# (% #get_havale.first_interest_rate# Indirimli) + KDV
                                </li>
                            </cfif>
                        </cfif>
                        <cfif isdefined('attributes.is_product_stock_strategy') and attributes.is_product_stock_strategy eq 1>
                            <cfquery name="GET_STOCK_STRATEGY" datasource="#DSN3#">
                                SELECT PROVISION_TIME FROM STOCK_STRATEGY WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sid#"> AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
                            </cfquery>
                            <li class="margin">
                                <i class="i_size">Tedarik Süresi :</i>
                                <cfif get_stock_strategy.recordcount>#get_stock_strategy.provision_time# Gn</cfif>
                            </li>
                        </cfif>
                        <cfif isdefined("attributes.is_show_point") and attributes.is_show_point eq 1>
                            <li class="margin">
                                <i class="i_size"><cf_get_lang_main no='1572.Puan'></i>
                                <cfif len(get_active_product.segment_id)>
                                    <cfquery name="GET_SEGMENTS" datasource="#DSN1#">
                                        SELECT PRODUCT_SEGMENT FROM PRODUCT_SEGMENT WHERE PRODUCT_SEGMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_active_product.segment_id#"> 
                                    </cfquery>
                                    #get_segments.product_segment#
                                </cfif>
                            </li>
                        </cfif>
                    </ul>
                    <div class="price_detail">
                        <div class="product_detail_price">
                            #var_amount# #var_money#
                        </div>
                        <div class="amount_detail">
                            <cfif isDefined('attributes.is_price_kdv') and attributes.is_price_kdv eq 1>
                                #kdvIncludeAmout# #kdvIncludeMoney#
                            </cfif>
                            <cfif attributes.is_price_tax_rate eq 1>
                                ( %#tax# KDV Dahil)
                            </cfif>
                        </div>
                        <div class="amount_detail font-weight-bold">#add_unit#</div>
                        <div class="product_detail_basket">
                            <cfif not isdefined("product_stock")>
                                <cfset product_stock = 0>
                            </cfif>
                            <cfif ((is_zero_stock eq 1 or (is_zero_stock neq 1 and product_stock gt 0) or (isdefined('is_production') and is_production eq 1) or (isdefined("attributes.is_stock_kontrol") and attributes.is_stock_kontrol eq 0)) and attributes.price_kdv gt 0) or isdefined("attributes.is_karma")>
                                <cfif not isdefined("attributes.campaign_basket")>
                                    <cfif isdefined('attributes.is_prices_prototype') and attributes.is_prices_prototype eq 1 and is_prototype eq 1>
                                        <input type="hidden" name="spec_var_id_#currentrow#" id="spec_var_id_#currentrow#" value="" />
                                        <input type="hidden" name="spec_var_name_#currentrow#" id="spec_var_name_#currentrow#" value="" />
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_add_spect_list&stock_id=#stock_id#&is_partner=1&row_id=#currentrow#','medium')" class="headersepet" title="<cf_get_lang_main no='1376.Sepete At'>"><i class="fas fa-shopping-bag"></i></a>
                                    <cfelse>
                                        <div class="product_item_basket_top">
                                            <span><i class="fa fa-minus"  onClick="document.getElementById('quantity').value != 1 ? document.getElementById('quantity').value-- : 1;"></i></span>
                                            <input type="text" id="quantity"  min="1" max="999" value="1" readonly/> 
                                            <span><i class="fa fa-plus"  onClick="document.getElementById('quantity').value++;"></i></span>
                                            <div class="product_item_basket_bottom">
                                                <a href="javascript://" onclick="add_product(#attributes.sid#,document.getElementById('quantity').value,#widget.id#);"><cf_get_lang dictionary_id='52116.Sepete Ekle'><i class="fa fa-shopping-cart"></i></a>
                                            </div>
                                        </div>
                                    </cfif>
                                <cfelse>
                                    <div class="product_item_basket_top">
                                        <span><i class="fa fa-minus"  onClick="document.getElementById('quantity').value != 1 ? document.getElementById('quantity').value-- : 1;"></i></span>
                                        <input type="text" id="quantity"  min="1" max="999" value="1" readonly/> 
                                        <span><i class="fa fa-plus"  onClick="document.getElementById('quantity').value++;"></i></span>
                                        <div class="product_item_basket_bottom">
                                            <a href="javascript://" onclick="add_product(#attributes.sid#,document.getElementById('quantity').value,#widget.id#);"><cf_get_lang dictionary_id='52116.Sepete Ekle'><i class="fa fa-shopping-cart"></i></a>
                                        </div>
                                    </div>
                                </cfif> 
                            <cfelse>
                                <a href="##"><cf_get_lang dictionary_id='52116.?'><i class="fas fa-shopping-bag"></i></a> 
                            </cfif>	
                        </div>
                    </div>
                </div>
            </div>
        </div>  
        <cfif get_product_stocks.recordcount>
            <!--- Ürünün tüm aktif stokları --->
            <div class="product_table_detail">
                <table class="table table_product_detail">
                    <thead>
                        <tr>
                            <th width="40"><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                            <th width="120"><cf_get_lang dictionary_id='36199.Açıklama'></th>
                            <th width="50"><cf_get_lang dictionary_id='57789.Özel Kod'></th>
                            <th width="50"><cf_get_lang dictionary_id='57636.Birim'></th>
                            <th width="50" class="text-right"><cf_get_lang dictionary_id='58084.Fiyat'></th>
                            <th width="140" class="text-center"></th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfloop query="#get_product_stocks#">
                            <tr>
                                <td>#STOCK_CODE#</td>
                                <td>#PROPERTY#</td>
                                <td>#STOCK_CODE_2#</td>
                                <td>#MAIN_UNIT#</td>
                                <td class="text-right">#PRICE_KDV# #MONEY#</td>
                                <td>
                                    <div class="product_item_basket">
                                        <div class="product_item_basket_top">
                                            <span><i class="fa fa-minus"  onClick="document.getElementById('quantity_#currentrow#').value != 1 ? document.getElementById('quantity_#currentrow#').value-- : 1;"></i></span>
                                            <input type="text" id="quantity_#currentrow#"  min="1" max="999" value="1" readonly/> 
                                            <span><i class="fa fa-plus"  onClick="document.getElementById('quantity_#currentrow#').value++;"></i></span>
                                            <div class="product_item_basket_bottom">
                                                <a href="javascript://" onclick="add_product(#stock_id#,document.getElementById('quantity_#currentrow#').value,#widget.id#);"><cf_get_lang dictionary_id='52116.Sepete Ekle'><i class="fa fa-shopping-cart"></i></a>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </cfloop>
                    </tbody>
                </table>
            </div>
        </cfif>
    </cfoutput>
    <div class="accordion">
        <ul>
            <li class="active">
                <a class="acc1" href="javascript://"><i class="fas fa-dice-four"></i><cf_get_lang dictionary_id='58131.Basic Details'></a>                        
            </li>
            <li>
                <a class="acc2" href="javascript://"><i class="fas fa-dice-four"></i><cf_get_lang dictionary_id='60320.?'></a>
            </li>   
            <li>                        
                <a class="acc3" href="javascript://"><i class="fas fa-book"></i><cf_get_lang dictionary_id='61567.?'></a>
            </li>
            <cfif get_active_product.is_karma eq 1>
                <li>                        
                    <a class="acc4" href="javascript://"><i class="fas fa-cube"></i><cf_get_lang dictionary_id='48653.Bileşenler'></a>
                </li>
            </cfif>
        </ul>
        <cfif attributes.is_detail eq 1>
            <cfif attributes.is_detail_from_watalogy eq 1>
                <div class="accordion_item acc1">
                    <div class="accordion_item_text">
                        <p><cfoutput>#get_active_product.PRODUCT_DETAIL_WATALOGY#</cfoutput></p>
                    </div>
                </div>
            <cfelse>
                <div class="accordion_item acc1">
                    <div class="accordion_item_text">
                        <p><cfoutput>#get_active_product.PRODUCT_DETAIL#</cfoutput></p>
                    </div>
                </div>
            </cfif>
        </cfif>
        <div class="accordion_item acc2" style="display:none;">
            <div class="accordion_item_text">
                <cfquery name="GET_PROPERTY" datasource="#DSN#">
                    WITH T1 AS(SELECT 
                        PRODUCT_DT_PROPERTIES.DETAIL,
                        PRODUCT_DT_PROPERTIES.VARIATION_ID,
                        PRODUCT_DT_PROPERTIES.PRODUCT_DT_PROPERTY_ID,
                        PRODUCT_PROPERTY.PROPERTY_ID,
                        PRODUCT_PROPERTY.PROPERTY,
                        PRODUCT_DT_PROPERTIES.LINE_VALUE
                    FROM 
                        #dsn1_alias#.PRODUCT_DT_PROPERTIES,
                        #dsn1_alias#.PRODUCT_PROPERTY,
                        #dsn1_alias#.PRODUCT
                    WHERE 
                        PRODUCT.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND
                        PRODUCT_DT_PROPERTIES.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND
                        PRODUCT_DT_PROPERTIES.PROPERTY_ID = PRODUCT_PROPERTY.PROPERTY_ID AND
                        PRODUCT_DT_PROPERTIES.IS_INTERNET = 1
                    )

                    SELECT
                        COALESCE(SLIPD.ITEM,T.DETAIL) AS DETAIL,
                        T.VARIATION_ID,
                        T.PROPERTY_ID,
                        T.PROPERTY
                    FROM
                    T1 T
                    LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO SLIPD 
                    ON SLIPD.UNIQUE_COLUMN_ID = T.PRODUCT_DT_PROPERTY_ID 
                    AND SLIPD.COLUMN_NAME ='DETAIL'
                    AND SLIPD.TABLE_NAME = 'PRODUCT_DT_PROPERTIES'
                    AND SLIPD.LANGUAGE = '#session_base.language#' 
                    ORDER BY	
                        T.LINE_VALUE,
                        T.PRODUCT_DT_PROPERTY_ID
                </cfquery>
                <cfquery name="GET_LANGUAGE_INFOS" datasource="#DSN#">
                    SELECT
                        ITEM,
                        UNIQUE_COLUMN_ID
                    FROM
                        SETUP_LANGUAGE_INFO
                    WHERE
                        <cfif isdefined('session.pp')>
                            LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#"> AND
                        <cfelse>
                            LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#"> AND
                        </cfif>
                        COLUMN_NAME = 'PROPERTY' AND
                        TABLE_NAME = 'PRODUCT_PROPERTY'
                </cfquery>
                <cfquery name="GET_LANGUAGE_INFOS2" datasource="#DSN#">
                    SELECT
                        ITEM,
                        UNIQUE_COLUMN_ID
                    FROM
                        SETUP_LANGUAGE_INFO
                    WHERE
                        <cfif isdefined('session.pp')>
                            LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#"> AND
                        <cfelse>
                            LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#"> AND
                        </cfif>
                        COLUMN_NAME = 'PROPERTY_DETAIL' AND
                        TABLE_NAME = 'PRODUCT_PROPERTY_DETAIL'
                </cfquery>
                <cfset varyasyon_list= listsort(valuelist(get_property.variation_id,','),"numeric","asc",",")>
                <cfif get_property.recordcount>
                    <div class="list_properties">
                        <cfoutput query="get_property">
                            <cfquery name="GET_LANGUAGE_INFO" dbtype="query">
                                SELECT
                                    *
                                FROM
                                    GET_LANGUAGE_INFOS
                                WHERE
                                    UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#property_id#">
                            </cfquery>
                            <cfif len(variation_id)>
                                <cfquery name="GET_LANGUAGE_INFO2" dbtype="query">
                                    SELECT
                                        *
                                    FROM
                                        GET_LANGUAGE_INFOS2
                                    WHERE
                                        UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#variation_id#">
                                </cfquery>
                            <cfelse>
                                <cfset get_language_info2.recordcount = 0>
                            </cfif>
                            <cfif len(property)>
                                <div>
                                    <cfif get_language_info.recordcount>
                                        #get_language_info.item#
                                    <cfelse>
                                        <cfif isDefined("attributes.property_icon") and attributes.property_icon eq 1>
                                            <span class="fa fa-cube" style="color:##FF9800;"></span>
                                        <cfelseif isDefined("attributes.property_icon") and attributes.property_icon eq 2>
                                            <img src="themes/protein_business/assets/img/right_arrow_3.svg">                                        
                                        <cfelseif isDefined("attributes.property_icon") and attributes.property_icon eq 3>
                                            <div class="right-arrow"></div>
                                        <cfelseif isDefined("attributes.property_icon") and attributes.property_icon eq 4>
                                            <span class="ctl-cogwheels"></span>
                                        </cfif>
                                        <i class="fa fa-square" style="color:##ffab3c;" aria-hidden="true"></i> #detail#
                                    </cfif>
                                </div>
                            </cfif>
                        </cfoutput>
                    </div> 
                </cfif>	
            </div>
        </div>
        <div class="accordion_item acc3" style="display:none;">
            <div class="accordion_item_text">
                <cfscript>attributes.asset_cat_id="-3"; attributes.module_id='5' attributes.action_section='PRODUCT_ID'; attributes.action_id='#attributes.pid#'; </cfscript>
                <cfquery name="GET_ASSET" datasource="#DSN#">
                    SELECT
                        A.ASSET_FILE_NAME,
                        A.ASSET_FILE_PATH_NAME,
                        A.MODULE_NAME,
                        A.ASSET_ID,
                        A.ASSETCAT_ID,
                        A.ASSET_NAME,
                        A.IMAGE_SIZE,
                        A.ASSET_FILE_SERVER_ID,
                        A.RELATED_COMPANY_ID,
                        A.RELATED_CONSUMER_ID,
                        A.RELATED_ASSET_ID,
                        A.RECORD_EMP,
                        A.RECORD_DATE,
                        A.EMBEDCODE_URL,
                        ASSET_CAT.ASSETCAT,
                        ASSET_CAT.ASSETCAT_PATH,
                        CP.NAME,
                        ASSET_DESCRIPTION,
                        E.EMPLOYEE_NAME +' '+ E.EMPLOYEE_SURNAME AS EMP_NAME,
                        A.ACTION_ID
                    FROM
                        ASSET A
                        LEFT JOIN EMPLOYEES AS E ON E.EMPLOYEE_ID = A.RECORD_EMP,
                        CONTENT_PROPERTY CP,
                        ASSET_CAT
                    WHERE
                        A.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID AND
                        A.ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(attributes.action_section)#"> AND
                        A.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#"> AND
                        A.PROPERTY_ID = CP.CONTENT_PROPERTY_ID AND 
                        (
                            A.IS_SPECIAL = 0 OR
                            A.IS_SPECIAL IS NULL 
                            <cfif isDefined('session.pp')>
                                OR (A.IS_SPECIAL = 1 AND (A.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"> OR A.UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">))
                            </cfif>
                        )
                    ORDER BY 
                        A.RECORD_DATE DESC,
                        CP.NAME,
                        A.ASSET_NAME 
                </cfquery>
                <cfif not isDefined("attributes.mediaplayer_extensions")>
                    <cfset attributes.mediaplayer_extensions = ".asf,.wma,.avi,.mp3,.mp2,.mpa,.mid,.midi,.rmi,.aif,.aifc,aiff,.au,.snd,.wav,.cda,.wmv,.wm,.dvr-ms,.mpe,.mpeg,.mpg,.m1v,.vob" />
                </cfif>
                <cfif not isDefined("attributes.imageplayer_extensions")>
                    <cfset attributes.imageplayer_extensions = ".jpg,.jpeg,.bmp,.gif,.png,.wbmp,.svg"/>
                </cfif>
                <cfif get_asset.recordcount>
                    <div class="list_properties">
                        <cfoutput query="get_asset">
                            <cfif not len(ASSET_FILE_PATH_NAME)>
                                <cfif assetcat_id gte 0>
                                    <cfset path_ = "asset/#assetcat_path#">
                                <cfelse>
                                    <cfset path_ = "#assetcat_path#">
                                </cfif>
                            <cfelse>
                                <cfset path_ = "">
                            </cfif>
                            <cfset folder_ = path_>
                            <div>
                                <i class="fa fa-file-pdf-o" style="color:##ffab3c;" aria-hidden="true"></i>
                                <cfset link_name = ''>
                                <cfif len(record_emp)>
                                    <cfset link_name = emp_name>
                                </cfif>
                                <cfset link_name = "#link_name# #DateFormat(record_date,dateformat_style)# #TimeFormat(record_date,timeformat_style)#">
                                <cfset extention = listlast(asset_file_name,'.')>
                                <cfif isdefined("get_asset.EMBEDCODE_URL") and len(get_asset.EMBEDCODE_URL)>
                                    <a href="#get_asset.EMBEDCODE_URL#" target="_blank" title="#link_name#">#asset_name#</a>
                                <cfelse>
                                    <cfif listfindnocase(attributes.imageplayer_extensions, "." & extention)>
                                        <a href="javascript://" class="none-decoration" title="#link_name#"><img src="/documents/#folder_#/#asset_file_name#" width="50px" height="50px" class="mr-2">#asset_name#</a>
                                    <cfelse>
                                        <a href="javascript://" class="none-decoration" title="#link_name#">#asset_name#</a>
                                    </cfif>
                                </cfif>
            
                                <cfif image_size eq 0>(#getLang('main',515)#)		<!---Küçük--->
                                <cfelseif image_size eq 1>(#getLang('main',516)#)	<!---Orta--->
                                <cfelseif image_size eq 2>(#getLang('main',517)#)	<!---Büyük--->
                                </cfif>
                                <cfif currentrow is 1>
                                    (#name#)
                                <cfelse>
                                    <cfset old_row = currentrow - 1>
                                    <cfif name neq name[old_row]>(#name#)</cfif>
                                </cfif>
                            </div>
                        </cfoutput>
                    </div>
                </cfif>
            </div>
        </div>
        <cfif get_active_product.is_karma eq 1>
            <div class="accordion_item acc4" style="display:none;">
                <div class="accordion_item_text">
                    <cfset comp = createObject("component","V16.objects2.product.cfc.productOther") />
                    <cfset mixed_product = comp.GET_RELATED_MIXED_PRODUCT(
                        pid : attributes.pid,
                        site: GET_PAGE.PROTEIN_SITE
                    )/>        
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12 pl-2">
                        <table class="table border-0">
                            <thead style="border-bottom: 4px solid #bbbbbb6e;">
                                <tr>
                                    <th class="border-0">Kod</th>
                                    <th class="border-0"><cf_get_lang dictionary_id='57629.Açıklama'></th>
                                    <th class="border-0"><cf_get_lang dictionary_id='57635.Miktar'></th>
                                    <th class="border-0"><cf_get_lang dictionary_id='57636.Birim'></th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfoutput query="mixed_product">   
                                    <tr>   
                                        <td class="product_colon" style="font-weight:bold;color:##ff9100;">#PRODUCT_CODE_2#</td>
                                        <td class="product_colon">
                                            <label class="font-weight-bold">#PRODUCT_NAME#</label><br>
                                            <label>#left(PRODUCT_DETAIL,100)#</label>
                                        </td>
                                        <td class="product_colon text-center">#product_amount#</td>
                                        <td class="product_colon text-capitalize">#UNIT#</td>
                                    </tr>
                                </cfoutput>
                            </tbody>
                        </table>                        
                    </div>
                </div>
            </div>
        </cfif>
    </div>
</cfif>

<script>
    $(function(){
        $('.accordion ul li').click(function(){
            $('.accordion ul li').removeClass("active");
            $(this).addClass("active");
            var cid = $(this).find("> a").attr("class");
            $('.accordion_item').hide();
            $("."+cid).show(); 
        })
    })

    var thumbnails = document.getElementById("thumbnails")
    var imgs = thumbnails.getElementsByTagName("img")
    var main = document.getElementById("main")
    var counter=0;

    for(let i=0;i<imgs.length;i++){
    let img=imgs[i]
    
    
    img.addEventListener("click",function(){
    main.src=this.src
    })
    
    }

    $(function(){
        $('#thumbnails').slick({
            slidesToShow: 2,
            slidesToScroll: 1,
            dots:false,
            speed: 700,
            infinite:false,
            draggable:false,
            responsive: 
            [
                {
                breakpoint: 821, //820px breakpoint for iPad Air tablet
                settings: {
                    slidesToShow: 2
                }
                },
                {
                breakpoint: 480,
                settings: {
                    slidesToShow: 1,
                }
                }
            ]
        });
    })

</script>
<link rel="stylesheet" type="text/css" href="themes/protein_project/assets/css/prettify.min.css">
<script type="text/javascript" src="themes/protein_project/assets/js/prettify.min.js"></script>
<script>try { prettyPrint(); } catch(e) {}</script>