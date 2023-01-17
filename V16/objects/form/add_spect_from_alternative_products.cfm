<cfif isDefined('session.ep.userid')>
	<cfif isdefined("fusebox.use_spect_company") and len(fusebox.use_spect_company) and isdefined("fusebox.spect_company_list") and listfind(fusebox.spect_company_list,session_base.company_id)>
		<cfset new_dsn3 = "#dsn#_#fusebox.use_spect_company#">
	<cfelse>
		<cfset new_dsn3 = dsn3>
	</cfif>
<cfelseif isDefined('session.pp.userid')>
	<cfif isdefined("fusebox.use_spect_company") and len(fusebox.use_spect_company) and isdefined("fusebox.spect_company_list") and listfind(fusebox.spect_company_list,session.pp.our_company_id)>
		<cfset new_dsn3 = "#dsn#_#fusebox.use_spect_company#">
	<cfelse>
		<cfset new_dsn3 = dsn3>
	</cfif>
<cfelse>
	<cfif isdefined("fusebox.use_spect_company") and len(fusebox.use_spect_company) and isdefined("fusebox.spect_company_list") and listfind(fusebox.spect_company_list,session.ww.our_company_id)>
		<cfset new_dsn3 = "#dsn#_#fusebox.use_spect_company#">
	<cfelse>
		<cfset new_dsn3 = dsn3>
	</cfif>
</cfif>
<cfquery name="GET_PRODUCT_INFO" datasource="#new_dsn3#">
	SELECT PRODUCT_NAME,PRODUCT_ID,IS_PROTOTYPE FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
</cfquery>
<cfif not GET_PRODUCT_INFO.recordcount>
	<cfset hata = 11>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'> <cf_get_lang dictionary_id='58642.Urun Kaydı Bulunamadı'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
    <cfquery name="GET_PRODUCT_IMAGE" datasource="#new_dsn3#" maxrows="1">
        SELECT PATH,PRODUCT_ID,PATH_SERVER_ID,DETAIL FROM PRODUCT_IMAGES WHERE IMAGE_SIZE = 2 AND PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_info.product_id#"> ORDER BY PRODUCT_ID
    </cfquery>
    
    <cfset counter = 0>
    <cfset _deep_level_main_stock_id_0 = attributes.stock_id>
    <cfset _deep_level_main_product_id_0 = get_product_info.product_id>
    <cfset _deep_level_main_product_name_0 = get_product_info.product_name>
    <cfparam name="main_spec_id_0" default="">
    <cfparam name="is_limited_stock" default="">
    <cfparam name="special_code_1" default="">
    <cfparam name="special_code_2" default="">
    <cfparam name="special_code_3" default="">
    <cfparam name="special_code_4" default="">
    <cfparam name="attributes.modal_id" default="">
    <cfparam name="sel_box_status" default="enabled">
    <cfset url_str = "">
    <cfif isdefined('attributes.price_catid') and len(attributes.price_catid)>
        <cfset url_str = "#url_str#&price_catid=#attributes.price_catid#">
    </cfif>
    <cfif isdefined("attributes.spect_main_id")>
        <cfset url_str = "#url_str#&spect_main_id=#attributes.spect_main_id#">
    </cfif>
    <cfif isdefined("attributes.field_main_id")>
        <cfset url_str = "#url_str#&field_main_id=#attributes.field_main_id#">
    </cfif>
    <cfif isdefined("attributes.create_main_spect_and_add_new_spect_id")>
        <cfset url_str = "#url_str#&create_main_spect_and_add_new_spect_id=#attributes.create_main_spect_and_add_new_spect_id#">
    </cfif>
    <cfif isdefined("attributes.stock_id")>
        <cfset url_str = "#url_str#&stock_id=#attributes.stock_id#">
    </cfif>
    <cfif isdefined("attributes.product_id")>
        <cfset url_str = "#url_str#&product_id=#attributes.product_id#">
    </cfif>
    <cfif isdefined("attributes.row_id")>
        <cfset url_str = "#url_str#&row_id=#attributes.row_id#">
    </cfif>
    <cfif isdefined("attributes.field_id")>
        <cfset url_str = "#url_str#&field_id=#attributes.field_id#">
    </cfif>
    <cfif isdefined("attributes.field_name")>
        <cfset url_str = "#url_str#&field_name=#attributes.field_name#">
    </cfif>
    <cfif isdefined("attributes.basket_id") and len(attributes.basket_id)>
        <cfset url_str = "#url_str#&basket_id=#attributes.basket_id#">
    <cfelse>
        <cfset attributes.basket_id=2>
        <cfset url_str = "#url_str#&basket_id=2">
    </cfif>
    <cfif isdefined("attributes.is_refresh")>
        <cfset url_str = "#url_str#&is_refresh=#attributes.is_refresh#">
    </cfif>
    <cfif isdefined("attributes.form_name")>
        <cfset url_str = "#url_str#&form_name=#attributes.form_name#">
    </cfif>
    <cfif isdefined("attributes.company_id")>
        <cfset url_str = "#url_str#&company_id=#attributes.company_id#">
    </cfif>
    <cfif isdefined("attributes.consumer_id")>
        <cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#">
    </cfif>
    <cfquery name="GET_MONEY" datasource="#DSN#">
        SELECT	
            PERIOD_ID,
            MONEY,
            RATE1,
            RATE2 
        FROM
            #dsn2_alias#.SETUP_MONEY
    </cfquery>
    <cfloop query="get_money">
        <cfif isdefined("attributes.#money#") >
            <cfset url_str = "#url_str#&#money#=#evaluate("attributes.#money#")#">
        </cfif>
    </cfloop>
    <cfif isdefined("attributes.search_process_date")>
        <cfset url_str = "#url_str#&search_process_date=#attributes.search_process_date#">
    </cfif>
    
    <cfif isdefined("attributes.main_stock_amount")>
        <cfset url_str = "#url_str#&main_stock_amount=#attributes.main_stock_amount#">
    </cfif> 
    <cfif isdefined("attributes.paper_location")>
        <cfset url_str = "#url_str#&paper_location=#attributes.paper_location#">
    </cfif>
    <cfif isdefined("attributes.paper_department")>
        <cfset url_str = "#url_str#&paper_department=#attributes.paper_department#">
    </cfif>
    
    <cfif isdefined("attributes.ship_id") and attributes.ship_id gt 0>
        <cfset url_str = "#url_str#&ship_id=#attributes.ship_id#">
    </cfif>
    <cfif isdefined("attributes.order_id") and attributes.order_id gt 0>
        <cfset url_str = "#url_str#&order_id=#attributes.order_id#">
    </cfif>
    <cfif isdefined("attributes.sepet_process_type") and attributes.sepet_process_type gt 0>
        <cfset url_str = "#url_str#&sepet_process_type=#attributes.sepet_process_type#">
    </cfif>
    <cfif isdefined("attributes.is_from_prod_order")>
        <cfset url_str = "#url_str#&is_from_prod_order=#attributes.is_from_prod_order#">
    </cfif>
    <cfif isdefined("is_spect_name_to_property")>
        <cfset url_str = "#url_str#&is_spect_name_to_property=#is_spect_name_to_property#">
    </cfif>
    <cfif isdefined('attributes.id') and len(attributes.id)><!--- spect_var_id --->
        <cfquery name="GET_PROD_MAIN_SPEC" datasource="#new_dsn3#">
            SELECT TOP 1 SPECT_VAR_NAME as SPEC_NAME,* FROM SPECTS S WHERE S.SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
        </cfquery>
        <cfset _spec_status_ = 1>
    <cfelse>
        <cfquery name="GET_PROD_MAIN_SPEC" datasource="#new_dsn3#">
            SELECT TOP 1 SPECT_MAIN_NAME as SPEC_NAME,* FROM SPECT_MAIN SM WHERE 
            <cfif isdefined("attributes.spect_main_id") and len(attributes.spect_main_id)>
                SM.SPECT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spect_main_id#">
            <cfelse>
                SM.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> AND SM.IS_TREE = 1 
            </cfif>
            ORDER BY SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC
        </cfquery>
    </cfif>
    <cfscript>
        is_limited_stock =get_prod_main_spec.is_limited_stock;
        special_code_1 = get_prod_main_spec.special_code_1;
        special_code_2 = get_prod_main_spec.special_code_2;
        special_code_3 = get_prod_main_spec.special_code_3;
        special_code_4 = get_prod_main_spec.special_code_4;
        spec_name = get_prod_main_spec.SPEC_NAME;
        spec_name = replace(spec_name,',','','all');
        spec_name = replace(spec_name,'/','','all');
        spec_name = replace(spec_name,':','','all');
        _deep_level_main_product_name_0 = replace(_deep_level_main_product_name_0,',','','all');
        _deep_level_main_product_name_0 = replace(_deep_level_main_product_name_0,'/','','all');
        _deep_level_main_product_name_0 = replace(_deep_level_main_product_name_0,':','','all');
        if(not isdefined('_spec_status_')) _spec_status_ = get_prod_main_spec.spect_status;
    </cfscript>
    <cfset main_spec_id_0 = get_prod_main_spec.spect_main_id>
    <cfif spec_purchasesales eq 1 and not (isdefined("attributes.price_catid") and len(attributes.price_catid))>
        <!--- uyenin fiyat listesini bulmak icin--->
        <cfif isdefined("attributes.company_id") and len(attributes.company_id)>
            <cfquery name="GET_PRICE_CAT_CREDIT" datasource="#DSN#">
                SELECT
                    PRICE_CAT
                FROM
                    COMPANY_CREDIT
                WHERE
                    COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">  AND
                    OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
            </cfquery>
            <cfif get_price_cat_credit.recordcount and len(get_price_cat_credit.price_cat)>
                <cfset attributes.new_price_catid=get_price_cat_credit.price_cat>
            <cfelse>
                <cfquery name="GET_COMP_CAT" datasource="#DSN#">
                    SELECT COMPANYCAT_ID FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                </cfquery>
                <cfquery name="GET_PRICE_CAT_COMP" datasource="#new_dsn3#">
                    SELECT 
                        PRICE_CATID
                    FROM
                        PRICE_CAT
                    WHERE
                        COMPANY_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cat.companycat_id#,%">
                </cfquery>
                <cfset attributes.new_price_catid = get_price_cat_comp.price_catid>
            </cfif>
        </cfif>
        <cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
            <cfquery name="GET_COMP_CAT" datasource="#DSN#">
                SELECT CONSUMER_CAT_ID FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
            </cfquery>
            <cfquery name="GET_PRICE_CAT" datasource="#new_dsn3#">
                SELECT PRICE_CATID FROM PRICE_CAT WHERE CONSUMER_CAT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#get_comp_cat.consumer_cat_id#,%">
            </cfquery>
            <cfset attributes.new_price_catid=get_price_cat.price_catid>
        </cfif>
    </cfif>
    <cfloop query="get_money"><cfif not isdefined('attributes.#money#')><cfset 'attributes.#money#' = rate2></cfif></cfloop>
    <cfif isdefined("attributes.new_price_catid")><cfset attributes.price_catid = attributes.new_price_catid></cfif>
    <cfif isdefined('attributes.price_catid') and len(attributes.price_catid)>
        <cfquery name="GET_PRICE" datasource="#new_dsn3#">
            SELECT
                PRICE_STANDART.PRODUCT_ID,
                SM.MONEY,
                PRICE_STANDART.PRICE,
                PRICE_STANDART.PRICE_KDV,
                PRICE_STANDART.MONEY OTHER_MONEY,
                (PRICE_STANDART.PRICE*(SM.RATE2/SM.RATE1)) AS PRICE_STDMONEY,
                (PRICE_STANDART.PRICE_KDV*(SM.RATE2/SM.RATE1)) AS PRICE_KDV_STDMONEY,
                SM.RATE2,
                SM.RATE1,
                0 AS IS_GIFT_CARD
            FROM
                PRICE PRICE_STANDART,	
                PRODUCT_UNIT,
                #dsn_alias#.SETUP_MONEY AS SM
            WHERE
                PRICE_STANDART.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> AND
                ISNULL(PRICE_STANDART.STOCK_ID,0) = 0 AND
                ISNULL(PRICE_STANDART.SPECT_VAR_ID,0) = 0 AND
                PRICE_STANDART.STARTDATE < #now()# AND 
                (PRICE_STANDART.FINISHDATE >= #now()# OR PRICE_STANDART.FINISHDATE IS NULL) AND
                PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND 
                PRICE_STANDART.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#_deep_level_main_product_id_0#"> AND 
                PRODUCT_UNIT.IS_MAIN = 1 AND
                <cfif session.ep.period_year lt 2009>
                    ((SM.MONEY = PRICE_STANDART.MONEY) OR (SM.MONEY = 'YTL') AND PRICE_STANDART.MONEY = 'TL') AND
                <cfelse>
                    SM.MONEY = PRICE_STANDART.MONEY AND
                </cfif>
                SM.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
        </cfquery>
    </cfif>
    <cfif isdefined('session.ep')>
        <cfset period_year = session.ep.period_year>
        <cfset _period_id_ = session.ep.period_id>
        <cfset _money2_ = session.ep.money2>
    <cfelseif isdefined('session_base')>
        <cfset period_year = session_base.period_year>
        <cfset _period_id_ = session_base.period_id>
        <cfset _money2_ = session_base.money2>
    </cfif>
    <cfif not (isdefined("attributes.price_catid") and len(attributes.price_catid)) or (isdefined("attributes.new_price_catid") and isdefined('attributes.price_catid') and not GET_PRICE.recordcount) ><!--- Özel bir fiyatı yok ise standart fiyattan alsın... --->
        <cfquery name="GET_PRICE" datasource="#new_dsn3#">
            SELECT
                PRICE_STANDART.PRODUCT_ID,
                SM.MONEY,
                PRICE_STANDART.PRICE,
                PRICE_STANDART.PRICE_KDV,
                PRICE_STANDART.MONEY OTHER_MONEY,
                (PRICE_STANDART.PRICE*(SM.RATE2/SM.RATE1)) AS PRICE_STDMONEY,
                (PRICE_STANDART.PRICE_KDV*(SM.RATE2/SM.RATE1)) AS PRICE_KDV_STDMONEY,
                SM.RATE2,
                SM.RATE1,
                PRODUCT.IS_GIFT_CARD
            FROM
                PRODUCT,
                PRICE_STANDART,
                #dsn_alias#.SETUP_MONEY AS SM
            WHERE
                PRODUCT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID AND
                PURCHASESALES = <cfif spec_purchasesales eq 1>1<cfelse>0</cfif> AND
                PRICESTANDART_STATUS = 1 AND
                 <cfif period_year lt 2009>
                    ((SM.MONEY = PRICE_STANDART.MONEY) OR (SM.MONEY = 'YTL') AND PRICE_STANDART.MONEY = 'TL') AND
                <cfelse>
                    SM.MONEY = PRICE_STANDART.MONEY AND
                </cfif>
                SM.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#_period_id_#"> AND
                PRODUCT.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#_deep_level_main_product_id_0#">
        </cfquery>
    </cfif>
    <cfsavecontent variable="img_">
    <cfoutput>
        <cfif isdefined("attributes.stock_id") and len(attributes.stock_id) and isdefined('session.ep')><a href="#request.self#?fuseaction=objects.popup_list_spect_main&main_to_add_spect=1&#url_str#"><img src="/images/cuberelation.gif" align="absmiddle" border="0" title="<cf_get_lang dictionary_id ='33920.Konfigüratör'>"></a></cfif>
    </cfoutput>
    </cfsavecontent>
    <!--- <cf_popup_box title="#message#" right_images="#img_#"> --->
    <cf_box title = "#getLang(dictionary_id:34299)#"  scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#"><!--- Spec --->
        <cfform name="addSpecAll" method="post" action="#request.self#?fuseaction=objects.popup_addSpecFromAlternativeProduct">
            <cfoutput>
                <cfif isdefined('attributes.is_partner')>
                    <input type="hidden" name="is_partner" id="is_partner" value="1">
                </cfif>
                <cfif isdefined("attributes.row_id")><!--- basketen geldi ise basketteki satırı--->
                    <input type="hidden" name="row_id" id="row_id" value="#attributes.row_id#">
                </cfif>
                <cfif isdefined('attributes.id') and len(attributes.id)><!--- Spec Güncelleme Sayfası Olduğunu İfade Eder! --->
                    <input type="hidden" name="is_update" id="is_update" value="1">
                    <input type="hidden" name="spec_id" id="spec_id" value="#attributes.id#">
                </cfif>
                <cfif isdefined('attributes.is_from_prod_order')><!--- üretim emrinden geldiğini ifade ediyor. --->
                    <input type="hidden" name="is_from_prod_order" id="is_from_prod_order" value="#attributes.is_from_prod_order#">
                </cfif> 
                <cfif isDefined('attributes.upd_main_spect') and len(attributes.upd_main_spect)>
                    <input type="hidden" name="upd_main_spect" id="upd_main_spect" value="#attributes.upd_main_spect#">
                </cfif>
                <input type="hidden" name="is_add_same_name_spect" id="is_add_same_name_spect" value="#is_add_same_name_spect#">
                <cfif isdefined('attributes.upd_main_spect') or isdefined("attributes.is_disable")><cfset sel_box_status = 'disabled'></cfif> 
                <input type="hidden" name="main_prod_price" id="main_prod_price" value="<cfif len(get_price.price)>#get_price.price#<cfelse>0</cfif>">
                <input type="hidden" name="main_prod_price_kdv" id="main_prod_price_kdv" value="<cfif len(get_price.price_kdv)>#get_price.price_kdv#<cfelse>0</cfif>">
                <input type="hidden" name="main_product_money" id="main_product_money" value="#get_price.money#">
                <input type="hidden" name="toplam_miktar" id="toplam_miktar" value="<cfif len(get_price.price_kdv)>#get_price.price*evaluate('attributes.#get_price.money#')#<cfelse>0</cfif>">
                <input type="hidden" name="other_toplam" id="other_toplam" value="<cfif len(get_price.price_kdv)>#get_price.price#<cfelse>0</cfif>">
                <input type="hidden" name="other_money" id="other_money" value="<cfif len(get_price.other_money)>#get_price.other_money#<cfelse>#session_base.money#</cfif>">
                <input type="hidden" name="_deep_level_main_stock_id_0" id="_deep_level_main_stock_id_0" value="#_deep_level_main_stock_id_0#">
                <input type="hidden" name="_deep_level_main_product_id_0" id="_deep_level_main_product_id_0" value="#_deep_level_main_product_id_0#">
                <input type="hidden" name="_deep_level_main_product_name_0" id="_deep_level_main_product_name_0" value="#_deep_level_main_product_name_0#">
                <input type="hidden" name="main_spec_id_0" id="main_spec_id_0" value="#main_spec_id_0#">
                <cfif isdefined("attributes.field_id") and isdefined("attributes.field_name")>
                    <input type="hidden" name="field_name" id="field_name" value="#attributes.field_name#">
                    <input type="hidden" name="field_id" id="field_id" value="#attributes.field_id#">
                </cfif>
                <cfif isdefined("attributes.field_main_id") and isdefined("attributes.field_main_id")>
                    <input type="hidden" name="field_main_id" id="field_main_id" value="#attributes.field_main_id#">
                </cfif>
                <div class="row">
                    <div class="ui-info-text">
                        <ul>
                            <li>
                                <b><cf_get_lang dictionary_id ='57657.Ürün'>:</b>
                                <cfif isDefined('session.pp.userid')>
                                    <cfif session_base.language neq 'tr'>
                                        <cfif not isDefined('get_all_for_langs')>
                                            <cfquery name="GET_FOR_PROD" datasource="#DSN#" cachedwithin="#CreateTimeSpan(0,24,0,0)#">
                                                SELECT 
                                                    UNIQUE_COLUMN_ID, 
                                                    TABLE_NAME,
                                                    COLUMN_NAME,
                                                    LANGUAGE,
                                                    ITEM 
                                                FROM 
                                                    SETUP_LANGUAGE_INFO 
                                                WHERE 
                                                    TABLE_NAME = 'PRODUCT' AND 
                                                    COLUMN_NAME = 'PRODUCT_NAME' AND
                                                    ITEM <> '' AND
                                                    UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#_deep_level_main_product_id_0#"> AND
                                                    LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#">
                                            </cfquery>
                                        </cfif>
                                        <cfif get_for_prod.recordcount>
                                            #get_for_prod.item#
                                        <cfelse>
                                            #_deep_level_main_product_name_0#                                
                                        </cfif> 
                                    <cfelse>
                                        #_deep_level_main_product_name_0#                            
                                    </cfif>
                                <cfelse>
                                    #_deep_level_main_product_name_0#                       
                                </cfif>
                            </li>
                            <li><b><cf_get_lang dictionary_id ='57647.Spec'>:</b> #main_spec_id_0#<cfif isdefined('attributes.id') and len(attributes.id)>- #attributes.id#</cfif></li>
                        </ul>
                    </div>
                </div>
            </cfoutput>
            <cfoutput>
            <table style="display:none;"><!--- Dövizler hiç gösterilmesin sadece arka tarafta hesaplanması yapılacak.. --->
                <tr>
                    <td colspan="3" >&nbsp;&nbsp;<cf_get_lang dictionary_id ='33851.Dövizler'></td>
                </tr>
                <input type="hidden" name="rd_money_num" id="rd_money_num" value="#get_money.recordcount#">
                <cfloop query="get_money">
                    <tr>
                        <input type="hidden" name="urun_para_birimi#money#" id="urun_para_birimi#money#" value="#rate2/rate1#">
                        <input type="hidden" name="rd_money_name_#currentrow#" id="rd_money_name_#currentrow#" value="#money#">
                        <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
                        <td><input type="radio" name="rd_money" id="rd_money" value="#money#,#rate1#,#rate2#" <cfif money eq _money2_>checked</cfif>>#money#</td>
                        <td>#TLFormat(rate1,4)#/</td>
                        <td><input type="text" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#rate2#" style="width:50px;" class="box" onkeyup="return(FormatCurrency(this,event,4));"></td>
                    </tr>
                </cfloop>
            </table>
            <cfif isdefined("session.ep")>
                <cf_box_elements>
                    <div class="row">
                        <div class="col col-6">
                            <cfif is_show_spect_name eq 1>
                                <div class="form-group">
                                    <label class="col col-4"><cf_get_lang dictionary_id='34006.Main Spec'></label>
                                    <div class="col col-8">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='32755.spec girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="spec_name" id="spec_name" required="yes" message="#message#" value="#spec_name#" maxlength="500">
                                    </div>
                                </div>
                            <cfelse>
                                <input type="hidden" name="spec_name" id="spec_name" value="#spec_name#">
                            </cfif>
                            <cfif is_show_special_code_1 eq 0><input type="hidden" name="special_code_1" id="special_code_1" value="#special_code_1#"></cfif>
                            <cfif is_show_special_code_2 eq 0><input type="hidden" name="special_code_2" id="special_code_2" value="#special_code_2#"></cfif>
                            <cfif is_show_special_code_3 eq 0><input type="hidden" name="special_code_3" id="special_code_3" value="#special_code_3#"></cfif>
                            <cfif is_show_special_code_4 eq 0><input type="hidden" name="special_code_4" id="special_code_4" value="#special_code_4#"></cfif>
                            
                            <cfif is_show_special_code_1 eq 1 or is_show_special_code_2 eq 1>
                                <cfif is_show_special_code_1 eq 1>
                                    <div class="form-group">
                                        <label class="col col-4"><cf_get_lang dictionary_id ='57789.Özel Kod'> 1</label>
                                        <div class="col col-8">
                                            <input type="text" name="special_code_1" id="special_code_1" value="#special_code_1#" onblur="if(!special_code_control('1',this.value))this.value='';">
                                        </div>
                                    </div>
                                </cfif>
                                <cfif is_show_special_code_2 eq 1>
                                    <div class="form-group">
                                        <label class="col col-4"><cf_get_lang dictionary_id ='57789.Özel Kod'> 2 </label>
                                        <div class="col col-8">
                                            <input type="text" name="special_code_2" id="special_code_2" value="#special_code_2#" onblur="if(!special_code_control('2',this.value))this.value='';">
                                        </div>
                                    </div>
                                </cfif>
                                <script type="text/javascript">
                                    function special_code_control(type,value)
                                    {
                                        if(type==1)
                                            special_code_query_text ="obj_sp_query_result";
                                        else
                                            special_code_query_text ="obj_sp_query_result_2";
                                        var listParam = "<cfoutput>#main_spec_id_0#</cfoutput>" + "*" + value;
                                        var sp_query_result = wrk_safe_query(special_code_query_text,'new_dsn3',0,listParam);
                                        if(sp_query_result.recordcount) {alert(''+sp_query_result.SPECT_MAIN_ID+' nolu Spec Main ve '+sp_query_result.SPECT_VAR_ID+' Spec Var ID de bu özel kodlar kullanılmış.'); return false}
                                        else return true;
                                        
                                    }
                                </script>
                            </cfif>
                            <cfif is_show_special_code_3 eq 1 or is_show_special_code_4 eq 1>
                                <cfif is_show_special_code_3 eq 1>
                                    <div class="form-group">
                                        <label class="col col-4"><cf_get_lang dictionary_id ='57789.Özel Kod'> 3 </label>
                                        <div class="col col-8">
                                            <input type="text" value="#special_code_3#"  name="special_code_3" id="special_code_3">
                                        </div>
                                    </div>
                                </cfif>	
                                <cfif is_show_special_code_4 eq 1>
                                    <div class="form-group">
                                        <label class="col col-4"><cf_get_lang dictionary_id ='57789.Özel Kod'> 4 </label>
                                        <div class="col col-8">
                                            <input type="text" value="#special_code_4#"  name="special_code_4" id="special_code_4">
                                        </div>
                                    </div>
                                </cfif>
                            </cfif>
                        </div>
                        <div class="col col-6">
                            <cfif isdefined('attributes.upd_main_spect')>
                                <div class="form-group">
                                    <label>
                                        <input type="checkbox" name="spect_status" id="spect_status" value="1" <cfif _spec_status_ eq 1>checked</cfif>>
                                        <cf_get_lang dictionary_id ='57493.Aktif'>
                                    </label>
                                </div>
                            </cfif>
                            <cfif is_show_stock_limit_check eq 1>
                                <div class="form-group">
                                    <label>
                                        <input type="checkbox" name="is_limited_stock" id="is_limited_stock" value="1" <cfif is_limited_stock eq 1>checked</cfif>>
                                        <cf_get_lang dictionary_id="33055.Stoklarla Sınırlı">
                                    </label>
                                </div>
                            <cfelse>
                                <cfif is_limited_stock eq 1><input type="hidden" name="is_limited_stock" id="is_limited_stock" value="1"></cfif>
                            </cfif>
                            <cfif is_show_product_price_change eq 1>
                                <div class="form-group">
                                    <label>
                                        <input type="checkbox" name="is_price_change" id="is_price_change" value="1" checked>
                                        <cf_get_lang dictionary_id ='33922.Fiyatı Güncelle'>
                                    </label>
                                </div>
                            <cfelse>
                                <input type="hidden" name="is_price_change" id="is_price_change" value="<cfif (isdefined("attributes.sepet_process_type") and attributes.sepet_process_type gt 0 and attributes.sepet_process_type neq 69) or not isdefined("attributes.sepet_process_type")>1<cfelse>0</cfif>">
                            </cfif>
                        </div>
                    </div>
                </cf_box_elements>
            </cfif>
            </cfoutput>
            <cfif get_product_image.recordcount>
                <cf_area>
                    <cf_get_server_file output_file="product/#get_product_image.path#" title="#get_product_image.detail#" output_server="#get_product_image.path_server_id#" output_type="0" image_height="250" image_link="0">
                </cf_area>
            </cfif>  
            <cfif len(get_price.is_gift_card) and get_price.is_gift_card eq 1 and isDefined('session.pp.userid')>
                <cfquery name="GET_ALTERNATIVE" datasource="#DSN3#">
                    SELECT 
                        SPECT_MAIN_ID, 
                        SPECT_MAIN_NAME, 
                        SPECT_TYPE, 
                        RECORD_EMP, 
                        RECORD_DATE, 
                        (SELECT TOP 1 SP.SPECT_VAR_ID FROM SPECTS SP WHERE SP.SPECT_MAIN_ID = SPECT_MAIN.SPECT_MAIN_ID ORDER BY SP.RECORD_DATE) SPECT_VAR_ID 
                    FROM 
                        SPECT_MAIN 
                    WHERE 
                        1=1 AND 
                        STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">  AND 
                        SPECT_STATUS = 1 
                    ORDER BY 
                        RECORD_DATE DESC 
                </cfquery>
                <cf_seperator id="mainSpect" header="#getLang(dictionary_id: 33259)#"><!--- Main Spect Seçimi --->
                <cf_grid_list id="mainSpect">
                    <thead>
                        <tr><th><cf_get_lang dictionary_id="33259.Main Spect Seçimi"></th></tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <div class="form-group">
                                    <select name="spect_var_id" id="spect_var_id">
                                        <cfoutput query="get_alternative">
                                            <option value="#spect_var_id#">#spect_main_name#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </cf_grid_list>
                <cf_box_footer>
                    <cf_workcube_buttons is_upd='1' is_delete='0' add_function="control()">
                </cf_box_footer>
            <cfelse>
                <cf_seperator id="alternative" header="#getLang(dictionary_id: 32776)#"><!--- Alternatif Ürünler --->
                <cf_grid_list id="alternative">
                    <thead>
                        <tr>
                            <th><cf_get_lang dictionary_id='57487.No'></th>
                            <th><cf_get_lang dictionary_id="34311.Alternatif"></th>
                            <th><cf_get_lang dictionary_id='57564.Ürünler'></th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfif len(main_spec_id_0)>
                            <cfscript>
                                row_number= 0;
                                deep_level = 0;
                                no_count = 0;
                                function get_subs(spect_main_id,next_stock_id,type)
                                {
                                    if((isdefined('attributes.upd_main_spect') and len(attributes.upd_main_spect)) or (isdefined('attributes.id') and len(attributes.id)))
                                    {											
                                        SQLStr = "
                                                SELECT
                                                    ISNULL(SMR.RELATED_MAIN_SPECT_ID,0) AS RELATED_ID,
                                                    ISNULL(SMR.STOCK_ID,0) STOCK_ID,
                                                    SPECT_MAIN_ROW_ID,
                                                    ISNULL(SMR.QUESTION_ID,0) AS QUESTION_ID,
                                                    ISNULL(SMR.PRODUCT_ID,0) AS PRODUCT_ID
                                                FROM 
                                                    SPECT_MAIN_ROW SMR
                                                WHERE
                                                    STOCK_ID IS NOT NULL AND
                                                    SPECT_MAIN_ID = #spect_main_id#
                                                ORDER BY
                                                    RELATED_TREE_ID,
                                                    LINE_NUMBER										
                                                ";
                                        }
                                        else
                                        {											
                                            if(type eq 0) where_parameter = 'PT.STOCK_ID = #next_stock_id#'; else where_parameter = 'RELATED_PRODUCT_TREE_ID = #spect_main_id#';
                                            SQLStr = "
                                                    SELECT
                                                        PRODUCT_TREE_ID RELATED_ID,
                                                        ISNULL(PT.STOCK_ID,0) STOCK_ID,
                                                        ISNULL(PT.SPECT_MAIN_ID,0) SPECT_MAIN_ROW_ID,
                                                        ISNULL(PT.SPECT_MAIN_ID,0) AS SPECT_MAIN_ID,
                                                        ISNULL(PT.QUESTION_ID,0) AS QUESTION_ID,
                                                        ISNULL(PT.PRODUCT_ID,0) AS PRODUCT_ID,
                                                        ISNULL(PT.OPERATION_TYPE_ID,0) OPERATION_TYPE_ID,
                                                        ISNULL(PT.RELATED_ID,0) STOCK_RELATED_ID
                                                    FROM 
                                                        PRODUCT_TREE PT
                                                    WHERE
                                                        #where_parameter#
                                                    ORDER BY
                                                        LINE_NUMBER,
                                                        STOCK_ID DESC
                                                ";
                                        }
                                        query1 = cfquery(SQLString : SQLStr, Datasource : new_dsn3);
                                        stock_id_ary='';
                                        for (str_i=1; str_i lte query1.recordcount; str_i = str_i+1)
                                        {
                                            stock_id_ary=listappend(stock_id_ary,query1.RELATED_ID[str_i],'█');
                                            stock_id_ary=listappend(stock_id_ary,query1.STOCK_ID[str_i],'§');
                                            stock_id_ary=listappend(stock_id_ary,query1.SPECT_MAIN_ROW_ID[str_i],'§');
                                            stock_id_ary=listappend(stock_id_ary,query1.QUESTION_ID[str_i],'§');
                                            stock_id_ary=listappend(stock_id_ary,query1.PRODUCT_ID[str_i],'§');
                                            if(isdefined("query1.OPERATION_TYPE_ID"))
                                            {
                                                stock_id_ary=listappend(stock_id_ary,query1.OPERATION_TYPE_ID[str_i],'§');
                                                stock_id_ary=listappend(stock_id_ary,query1.SPECT_MAIN_ID[str_i],'§');
                                                stock_id_ary=listappend(stock_id_ary,query1.STOCK_RELATED_ID[str_i],'§');
                                            }
                                        }
                                        return stock_id_ary;
                                    }
                                    function GetDeepLevelMaınStockId(_deeplevel)
                                    {
                                        if((isdefined('attributes.upd_main_spect') and len(attributes.upd_main_spect)) or (isdefined('attributes.id') and len(attributes.id)))
                                        {
                                            for (lind_ = _deeplevel-1;lind_ gte 0; lind_ = lind_-1){
                                                if(isdefined('_deep_level_main_stock_id_#lind_#') and len(Evaluate('_deep_level_main_stock_id_#lind_#')) and Evaluate('_deep_level_main_stock_id_#lind_#') gt 0)
                                                    return Evaluate('_deep_level_main_stock_id_#lind_#');
                                            }
                                        }
                                        else
                                        {
                                            for (lind_ = _deeplevel;lind_ gte 0; lind_ = lind_-1){
                                                if(isdefined('_deep_level_main_stock_id_#lind_#') and len(Evaluate('_deep_level_main_stock_id_#lind_#')) and Evaluate('_deep_level_main_stock_id_#lind_#') gt 0)
                                                    return Evaluate('_deep_level_main_stock_id_#lind_#');
                                            }
                                        }
                                        return 1;
                                    }                                        
                                    question_list = '';
                                    get_row = QueryNew("QUESTION_NO,DETAIL","VarChar,VarChar");
                                    row_of_query = 0;
                                    function writeTree(next_spect_main_id,next_stock_id,type)
                                    {
                                        var i = 1;
                                        var sub_products = get_subs(next_spect_main_id,next_stock_id,type);
                                        deep_level = deep_level + 1;
                                        
                                        for (i=1; i lte listlen(sub_products,'█'); i = i+1)
                                        {
                                            _next_spect_main_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),1,'§');//alt+987 = █ --//alt+789 = §
                                            _next_stock_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),2,'§');
                                            _next_spect_main_row_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),3,'§');
                                            _next_question_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),4,'§');
                                            _next_product_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),5,'§');
                                            select_image_div = 'spec_image_#_next_question_id_#';
                                            if((isdefined('attributes.upd_main_spect') and len(attributes.upd_main_spect)) or (isdefined('attributes.id') and len(attributes.id)))
                                            {
                                                _n_operation_id_ = 0;
                                                _n_spec_main_id_= '';
                                                _n_stock_related_id_= '';
                                            }
                                            else
                                            {
                                                _n_operation_id_ = ListGetAt(ListGetAt(sub_products,i,'█'),6,'§');
                                                _n_spec_main_id_= ListGetAt(ListGetAt(sub_products,i,'█'),7,'§');
                                                _n_stock_related_id_= ListGetAt(ListGetAt(sub_products,i,'█'),8,'§');
                                            }
                                            if(not ((isdefined('attributes.upd_main_spect') and len(attributes.upd_main_spect)) or (isdefined('attributes.id') and len(attributes.id))))
                                            {
                                                if(_next_stock_id_ gt 0) '_deep_level_main_stock_id_#deep_level#' = _next_stock_id_; else '_deep_level_main_stock_id_#deep_level#' = '-1';
                                            }
                                            alterNativeProduct='';
                                            alterNativeProduct_hidden='';
                                            question_name ='';
                                            if(_next_question_id_ gt 0 and _n_operation_id_ eq 0)
                                            {
                                                if(listfindnocase(question_list,_next_question_id_))
                                                {
                                                    is_hidden = 1;
                                                }
                                                else
                                                {
                                                    is_hidden = 0;
                                                    question_list = listappend(question_list,_next_question_id_);
                                                }
                                                /*if((isdefined('attributes.upd_main_spect') and len(attributes.upd_main_spect)) or (isdefined('attributes.id') and len(attributes.id)))
                                                {
                                                    queryService = new Query(sql="
                                                        SELECT DISTINCT
                                                            0 AS USAGE_RATE,
                                                            0 AS USAGE_AMOUNT,
                                                            S.STOCK_CODE_2,
                                                            P.PRODUCT_NAME,
                                                            ISNULL(P.PRODUCT_DETAIL2,P.PRODUCT_NAME) PRODUCT_DETAIL2,
                                                            S.STOCK_CODE,
                                                            S.STOCK_ID,
                                                            S.PRODUCT_ID,
                                                            0 SPECT_MAIN_ID,
                                                            '' ALTERNATIVE_PRODUCT_NO
                                                        FROM 
                                                            #dsn1_alias#.STOCKS S,
                                                            #dsn1_alias#.PRODUCT P
                                                        WHERE 
                                                            P.PRODUCT_ID = S.PRODUCT_ID AND
                                                            S.STOCK_ID = :stock_id ", datasource=DSN);
                                                    queryService.addParam(name="stock_id",value="#_next_stock_id_#",cfsqltype="cf_sql_integer");  
                                                    result = queryService.execute(); 
                                                    GetProducts = result.getResult(); 
                                                    union_parameter = result.getPrefix(); 
                                                }
                                                else
                                                {
                                                    union_parameter = '';
                                                }
                                                row_number = row_number+1;*/
                                                
                                                if(isDefined('session.pp.userid') and session_base.language neq 'tr')	
                                                {
                                                    questionNameStr="SELECT SLI.UNIQUE_COLUMN_ID QUESTION_NO, SLI.ITEM QUESTION_NAME FROM SETUP_LANGUAGE_INFO SLI WHERE SLI.UNIQUE_COLUMN_ID = #_next_question_id_# AND SLI.TABLE_NAME = 'SETUP_ALTERNATIVE_QUESTIONS' AND SLI.COLUMN_NAME = 'QUESTION_NAME' AND SLI.LANGUAGE = '#session_base.language#'";																									
                                                    questionNameQuery = cfquery(SQLString : questionNameStr, Datasource : dsn);
                                                    short_question_name = '';
                                                    if(not questionNameQuery.recordcount)
                                                    {
                                                        questionNameStr='SELECT QUESTION_NAME,QUESTION_DETAIL,ISNULL(QUESTION_NO,0) QUESTION_NO FROM SETUP_ALTERNATIVE_QUESTIONS WHERE QUESTION_ID=#_next_question_id_# ORDER BY QUESTION_NO';
                                                        questionNameQuery = cfquery(SQLString : questionNameStr, Datasource : dsn);
                                                        short_question_name = '#questionNameQuery.QUESTION_DETAIL#';
                                                    }
                                                }
                                                if( isDefined('session.ep.userid') or (isDefined('session.pp.userid') and session_base.language eq 'tr') )
                                                {													
                                                    questionNameStr='SELECT QUESTION_NAME,QUESTION_DETAIL,ISNULL(QUESTION_NO,0) QUESTION_NO FROM SETUP_ALTERNATIVE_QUESTIONS WHERE QUESTION_ID=#_next_question_id_# ORDER BY QUESTION_NO';													
                                                    questionNameQuery = cfquery(SQLString : questionNameStr, Datasource : dsn);
                                                    short_question_name = '#questionNameQuery.QUESTION_DETAIL#';
                                                }
                                                question_no ='#questionNameQuery.QUESTION_NO#';
                                                question_name ='#questionNameQuery.QUESTION_NAME#';
                                                if(not len(short_question_name)) short_question_name=' ';
                                                alternativeQuestion="
                                                    WITH CTE AS(
                                                        SELECT DISTINCT
                                                            ISNULL(AP.USAGE_RATE,0) AS USAGE_RATE,
                                                            ISNULL(AP.USEAGE_PRODUCT_AMOUNT,0) AS USAGE_AMOUNT,
                                                            S.STOCK_CODE_2,
                                                            P.PRODUCT_NAME,
                                                            CASE WHEN (S.STOCK_CODE=P.PRODUCT_CODE)
                                                                THEN P.PRODUCT_DETAIL2 
                                                            ELSE
                                                                S.PROPERTY
                                                            END AS PRODUCT_DETAIL2,
                                                            S.STOCK_CODE,
                                                            S.STOCK_ID,
                                                            S.PRODUCT_ID,
                                                            ISNULL(AP.SPECT_MAIN_ID,0) SPECT_MAIN_ID,
                                                            ALTERNATIVE_PRODUCT_NO,
                                                            ISNULL(AP.IS_PHANTOM,0) IS_PHANTOM,
                                                            S2.STOCK_ID MAIN_STOCK_ID,
                                                            S2.PRODUCT_ID MAIN_PRODUCT_ID,
                                                            S2.PRODUCT_NAME MAIN_PRODUCT_NAME
                                                        FROM 
                                                            ALTERNATIVE_PRODUCTS AP, 
                                                            #dsn1_alias#.STOCKS S,
                                                            #dsn1_alias#.PRODUCT P,
                                                            #dsn3_alias#.STOCKS S2
                                                        WHERE 
                                                            AP.QUESTION_ID = #_next_question_id_# AND
                                                            TREE_STOCK_ID = #GetDeepLevelMaınStockId(deep_level)#  AND
                                                            P.PRODUCT_ID =AP.ALTERNATIVE_PRODUCT_ID AND
                                                            S.STOCK_ID = AP.STOCK_ID AND 
                                                            P.PRODUCT_ID =S.PRODUCT_ID AND
                                                            AP.PRODUCT_ID = S2.PRODUCT_ID AND
                                                            (AP.START_DATE <= #createodbcdatetime(now())# OR AP.START_DATE IS NULL) AND
                                                            (AP.FINISH_DATE >= #createodbcdatetime(DATEADD('d',-1,now()))# OR AP.FINISH_DATE IS NULL)
                                                        ),
                                                        CTE2 AS (
                                                        SELECT DISTINCT
                                                            0 AS USAGE_RATE,
                                                            0 AS USAGE_AMOUNT,
                                                            S.STOCK_CODE_2,
                                                            P.PRODUCT_NAME,
                                                            CASE WHEN (S.STOCK_CODE=P.PRODUCT_CODE)
                                                                THEN P.PRODUCT_DETAIL2 
                                                            ELSE
                                                                S.PROPERTY
                                                            END AS PRODUCT_DETAIL2,
                                                            S.STOCK_CODE,
                                                            S.STOCK_ID,
                                                            S.PRODUCT_ID,
                                                            0 SPECT_MAIN_ID,
                                                            '' ALTERNATIVE_PRODUCT_NO,
                                                            0 AS IS_PHANTOM,
                                                            S.STOCK_ID MAIN_STOCK_ID,
                                                            S.PRODUCT_ID MAIN_PRODUCT_ID,
                                                            P.PRODUCT_NAME MAIN_PRODUCT_NAME
                                                        FROM 
                                                            #dsn1_alias#.STOCKS S,
                                                            #dsn1_alias#.PRODUCT P
                                                        WHERE 
                                                            P.PRODUCT_ID =S.PRODUCT_ID AND
                                                            S.STOCK_ID = #_next_stock_id_#AND S.STOCK_ID NOT IN(SELECT STOCK_ID FROM CTE)
                                                            AND STOCK_ID NOT IN (#_deep_level_main_stock_id_0#)
                                                        ),
                                                        CTE1 AS (
                                                        SELECT DISTINCT 
                                                            ISNULL(AP.USAGE_RATE, 0) AS USAGE_RATE, 
                                                            ISNULL(AP.USEAGE_PRODUCT_AMOUNT, 0) AS USAGE_AMOUNT, 
                                                            S.STOCK_CODE_2, 
                                                            S.PRODUCT_NAME, 
                                                            CASE WHEN (S.STOCK_CODE = S.PRODUCT_CODE) 
                                                                THEN S.PRODUCT_DETAIL2 
                                                            ELSE 
                                                                S.PROPERTY 
                                                            END AS PRODUCT_DETAIL2, 
                                                            S.STOCK_CODE, 
                                                            S.STOCK_ID, 
                                                            S.PRODUCT_ID, 
                                                            ISNULL(AP.SPECT_MAIN_ID, 0) AS SPECT_MAIN_ID, 
                                                            AP.ALTERNATIVE_PRODUCT_NO, 
                                                            ISNULL(AP.IS_PHANTOM, 0) AS IS_PHANTOM, 
                                                            S2.STOCK_ID AS MAIN_STOCK_ID, 
                                                            S2.PRODUCT_ID AS MAIN_PRODUCT_ID, 
                                                            S2.PRODUCT_NAME AS MAIN_PRODUCT_NAME
                                                        FROM            
                                                            #dsn3_alias#.PRODUCT_TREE PT,
                                                            #dsn3_alias#.ALTERNATIVE_PRODUCTS AP,
                                                            #dsn3_alias#.STOCKS S,
                                                            #dsn3_alias#.STOCKS S2
                                                        WHERE        
                                                            PT.STOCK_ID = #GetDeepLevelMaınStockId(deep_level)# AND 
                                                            PT.QUESTION_ID = #_next_question_id_# AND 
                                                            ISNULL(AP.TREE_STOCK_ID, 0) = 0	AND
                                                            PT.PRODUCT_ID = AP.PRODUCT_ID AND
                                                            AP.STOCK_ID = S.STOCK_ID AND
                                                            PT.RELATED_ID = S2.STOCK_ID
                                                        )
                                                    SELECT * FROM (		
                                                                    SELECT * FROM CTE
                                                                    UNION 
                                                                    SELECT * FROM CTE1
                                                                    UNION 
                                                                    SELECT * FROM CTE2
                                                                    )
                                                                    CTE3 
                                                    ORDER BY 
                                                        ALTERNATIVE_PRODUCT_NO,PRODUCT_DETAIL2";
                                                    alternativeQuestQuery = cfquery(SQLString : alternativeQuestion, Datasource : new_dsn3);
                                                    if(alternativeQuestQuery.recordcount)
                                                    {
                                                            if(is_hidden eq 1)
                                                            {
                                                                hidden_value = '';
                                                                for (ap_indx=1; ap_indx lte alternativeQuestQuery.recordcount; ap_indx = ap_indx+1)
                                                                {
                                                                        if(len(alternativeQuestQuery.PRODUCT_DETAIL2[ap_indx]))
                                                                    {
                                                                        alter_product_name_hidden = alternativeQuestQuery.PRODUCT_NAME[ap_indx];
                                                                        alter_special_code_hidden = alternativeQuestQuery.PRODUCT_DETAIL2[ap_indx];
                                                                    }
                                                                    else
                                                                    {
                                                                        alter_product_name_hidden = alternativeQuestQuery.PRODUCT_NAME[ap_indx];
                                                                        alter_special_code_hidden = alternativeQuestQuery.PRODUCT_NAME[ap_indx];
                                                                    }
                                                                    alter_product_name_hidden = replace(alter_product_name_hidden,',','','all');
                                                                    alter_product_name_hidden = replace(alter_product_name_hidden,'/','','all');
                                                                    alter_product_name_hidden = replace(alter_product_name_hidden,':','','all');
                                                                    alter_special_code_hidden = replace(alter_special_code_hidden,',','','all');
                                                                    alter_special_code_hidden = replace(alter_special_code_hidden,'/','','all');
                                                                    alter_special_code_hidden = replace(alter_special_code_hidden,':','','all');
                                                                    if(not len(alternativeQuestQuery.USAGE_RATE[ap_indx]))
                                                                        usage_rate_ = 0;
                                                                    else
                                                                        usage_rate_ = alternativeQuestQuery.USAGE_RATE[ap_indx];
                                                                        
                                                                    if((isdefined('attributes.id') and len(attributes.id) or isdefined('attributes.upd_main_spect')) and _next_stock_id_ eq alternativeQuestQuery.STOCK_ID[ap_indx])//güncelleme sayfası ise ve satırdaki ürün ile alternatif ürün eşit ise...
                                                                    {
                                                                        hidden_value='#alternativeQuestQuery.STOCK_ID[ap_indx]#█#alter_product_name_hidden#█#alter_special_code_hidden#█#usage_rate_#█#alternativeQuestQuery.PRODUCT_ID[ap_indx]#█#question_name#█#alternativeQuestQuery.SPECT_MAIN_ID[ap_indx]#█#alternativeQuestQuery.USAGE_AMOUNT[ap_indx]#█#alternativeQuestQuery.IS_PHANTOM[ap_indx]#█#alternativeQuestQuery.MAIN_STOCK_ID[ap_indx]#█#alternativeQuestQuery.MAIN_PRODUCT_ID[ap_indx]#█#alternativeQuestQuery.MAIN_PRODUCT_NAME[ap_indx]#';
                                                                    }
                                                                }													
                                                                alterNativeProduct_hidden='<input type="hidden" #sel_box_status# title="#_next_question_id_#" id="altertive_selectbox" name="alternative_products_#GetDeepLevelMaınStockId(deep_level)#_#_next_question_id_#" value="#hidden_value#">';
                                                            }
                                                            else
                                                            {
                                                                /*if(isDefined('session.pp.userid'))
                                                                {*/
                                                                if(session_base.language eq 'tr')
                                                                    alterNativeProduct='<div class="form-group"><select title="#_next_question_id_#" onchange="add_hidden_value(this);" #sel_box_status# id="altertive_selectbox#counter#" name="alternative_products_#GetDeepLevelMaınStockId(deep_level)#_#_next_question_id_#" style="width:245px;"><option value="">Seçiniz</option></div>';
                                                                else
                                                                    alterNativeProduct='<div class="form-group"><select title="#_next_question_id_#" onchange="add_hidden_value(this);" #sel_box_status# id="altertive_selectbox#counter#" name="alternative_products_#GetDeepLevelMaınStockId(deep_level)#_#_next_question_id_#" style="width:245px;"><option value="">Please Select</option></div>';
                                                                counter = counter + 1;
                                                                /*}
                                                                else
                                                                    alterNativeProduct='<div class="form-group"><select title="#_next_question_id_#" onchange="add_hidden_value(this);" #sel_box_status# id="altertive_selectbox" name="alternative_products_#GetDeepLevelMaınStockId(deep_level)#_#_next_question_id_#" style="width:245px;"><option value="">Seçiniz</option></div>';*/
                                                            
                                                            for (ap_in=1; ap_in lte alternativeQuestQuery.recordcount; ap_in = ap_in+1)
                                                            {
                                                                if(len(alternativeQuestQuery.PRODUCT_DETAIL2[ap_in]))
                                                                {
                                                                    alter_product_name = alternativeQuestQuery.PRODUCT_NAME[ap_in];
                                                                    if(isDefined('session.pp') and session_base.language neq 'tr')
                                                                    {
                                                                        alternativeRespQuery_ = cfquery(SQLString:"SELECT UNIQUE_COLUMN_ID, TABLE_NAME, COLUMN_NAME, LANGUAGE, ITEM FROM SETUP_LANGUAGE_INFO WHERE TABLE_NAME = 'PRODUCT' AND COLUMN_NAME = 'PRODUCT_DETAIL2' AND ITEM <> '' AND LANGUAGE = '#session_base.language#' AND UNIQUE_COLUMN_ID = #alternativeQuestQuery.PRODUCT_ID[ap_in]#",Datasource:dsn);
                                                                        if(alternativeRespQuery_.recordcount)
                                                                            alter_special_code = alternativeRespQuery_.item;
                                                                        else																																					
                                                                            alter_special_code = alternativeQuestQuery.PRODUCT_DETAIL2[ap_in];
                                                                    }
                                                                    else																																					
                                                                        alter_special_code = alternativeQuestQuery.PRODUCT_DETAIL2[ap_in];
                                                                }
                                                                else
                                                                {
                                                                    alter_product_name = alternativeQuestQuery.PRODUCT_NAME[ap_in];
                                                                    alter_special_code = alternativeQuestQuery.PRODUCT_NAME[ap_in];
                                                                }
                                                                alter_product_name = replace(alter_product_name,',','','all');
                                                                alter_product_name = replace(alter_product_name,'/','','all');
                                                                alter_product_name = replace(alter_product_name,':','','all');
                                                                alter_special_code = replace(alter_special_code,',','','all');
                                                                alter_special_code = replace(alter_special_code,'/','','all');
                                                                alter_special_code = replace(alter_special_code,':','','all');
                                                                if(not len(alternativeQuestQuery.USAGE_RATE[ap_in]))
                                                                    usage_rate_ = 0;
                                                                else
                                                                    usage_rate_ = alternativeQuestQuery.USAGE_RATE[ap_in];
                                                                if((isdefined('attributes.id') and len(attributes.id) or isdefined('attributes.upd_main_spect')) and _next_stock_id_ eq alternativeQuestQuery.STOCK_ID[ap_in])//güncelleme sayfası ise ve satırdaki ürün ile alternatif ürün eşit ise...
                                                                    is_selected='selected';
                                                                else
                                                                    is_selected='';	
                                                                // writeoutput('#_next_stock_id_#-#alternativeQuestQuery.STOCK_ID[ap_in]#_#alter_product_name#<br/>');	
                                                                if(isdefined("is_alternative_stock_name") and is_alternative_stock_name eq 1)
                                                                {
                                                                    if(usage_rate_ gt 0)
                                                                        alterNativeProduct='#alterNativeProduct#<option #is_selected# value="#alternativeQuestQuery.STOCK_ID[ap_in]#█#alter_product_name#█#alter_special_code#█#usage_rate_#█#alternativeQuestQuery.PRODUCT_ID[ap_in]#█#question_name#█#alternativeQuestQuery.SPECT_MAIN_ID[ap_in]#█#alternativeQuestQuery.USAGE_AMOUNT[ap_in]#█#alternativeQuestQuery.IS_PHANTOM[ap_in]#█#alternativeQuestQuery.MAIN_STOCK_ID[ap_in]#█#alternativeQuestQuery.MAIN_PRODUCT_ID[ap_in]#█#alternativeQuestQuery.MAIN_PRODUCT_NAME[ap_in]#">#alternativeQuestQuery.PRODUCT_NAME[ap_in]# #alternativeQuestQuery.PRODUCT_DETAIL2[ap_in]# - (% #usage_rate_#)</option>';
                                                                    else
                                                                        alterNativeProduct='#alterNativeProduct#<option #is_selected# value="#alternativeQuestQuery.STOCK_ID[ap_in]#█#alter_product_name#█#alter_special_code#█#usage_rate_#█#alternativeQuestQuery.PRODUCT_ID[ap_in]#█#question_name#█#alternativeQuestQuery.SPECT_MAIN_ID[ap_in]#█#alternativeQuestQuery.USAGE_AMOUNT[ap_in]#█#alternativeQuestQuery.IS_PHANTOM[ap_in]#█#alternativeQuestQuery.MAIN_STOCK_ID[ap_in]#█#alternativeQuestQuery.MAIN_PRODUCT_ID[ap_in]#█#alternativeQuestQuery.MAIN_PRODUCT_NAME[ap_in]#">#alternativeQuestQuery.PRODUCT_NAME[ap_in]# #alternativeQuestQuery.PRODUCT_DETAIL2[ap_in]# </option>';
                                                                }
                                                                else
                                                                {
                                                                    if(usage_rate_ gt 0)
                                                                        alterNativeProduct='#alterNativeProduct#<option #is_selected# value="#alternativeQuestQuery.STOCK_ID[ap_in]#█#alter_product_name#█#alter_special_code#█#usage_rate_#█#alternativeQuestQuery.PRODUCT_ID[ap_in]#█#question_name#█#alternativeQuestQuery.SPECT_MAIN_ID[ap_in]#█#alternativeQuestQuery.USAGE_AMOUNT[ap_in]#█#alternativeQuestQuery.IS_PHANTOM[ap_in]#█#alternativeQuestQuery.MAIN_STOCK_ID[ap_in]#█#alternativeQuestQuery.MAIN_PRODUCT_ID[ap_in]#█#alternativeQuestQuery.MAIN_PRODUCT_NAME[ap_in]#">#alternativeQuestQuery.PRODUCT_DETAIL2[ap_in]# - (% #usage_rate_#)</option>';
                                                                    else
                                                                        if(isDefined('session.pp') and session_base.language neq 'tr')
                                                                        {
                                                                            alternativeRespQuery_ = cfquery(SQLString:"SELECT UNIQUE_COLUMN_ID, TABLE_NAME, COLUMN_NAME, LANGUAGE, ITEM FROM SETUP_LANGUAGE_INFO WHERE TABLE_NAME = 'PRODUCT' AND COLUMN_NAME = 'PRODUCT_DETAIL2' AND ITEM <> '' AND LANGUAGE = '#session_base.language#' AND UNIQUE_COLUMN_ID = #alternativeQuestQuery.PRODUCT_ID[ap_in]#",Datasource:dsn);
                                                                            if(alternativeRespQuery_.recordcount)
                                                                                alterNativeProduct='#alterNativeProduct#<option #is_selected# value="#alternativeQuestQuery.STOCK_ID[ap_in]#█#alter_product_name#█#alter_special_code#█#usage_rate_#█#alternativeQuestQuery.PRODUCT_ID[ap_in]#█#question_name#█#alternativeQuestQuery.SPECT_MAIN_ID[ap_in]#█#alternativeQuestQuery.USAGE_AMOUNT[ap_in]#█#alternativeQuestQuery.IS_PHANTOM[ap_in]#█#alternativeQuestQuery.MAIN_STOCK_ID[ap_in]#█#alternativeQuestQuery.MAIN_PRODUCT_ID[ap_in]#█#alternativeQuestQuery.MAIN_PRODUCT_NAME[ap_in]#">#alternativeRespQuery_.item#</option>';
                                                                            else
                                                                                alterNativeProduct='#alterNativeProduct#<option #is_selected# value="#alternativeQuestQuery.STOCK_ID[ap_in]#█#alter_product_name#█#alter_special_code#█#usage_rate_#█#alternativeQuestQuery.PRODUCT_ID[ap_in]#█#question_name#█#alternativeQuestQuery.SPECT_MAIN_ID[ap_in]#█#alternativeQuestQuery.USAGE_AMOUNT[ap_in]#█#alternativeQuestQuery.IS_PHANTOM[ap_in]#█#alternativeQuestQuery.MAIN_STOCK_ID[ap_in]#█#alternativeQuestQuery.MAIN_PRODUCT_ID[ap_in]#█#alternativeQuestQuery.MAIN_PRODUCT_NAME[ap_in]#">#alternativeQuestQuery.PRODUCT_DETAIL2[ap_in]#</option>';
                                                                        }
                                                                        else
                                                                            alterNativeProduct='#alterNativeProduct#<option #is_selected# value="#alternativeQuestQuery.STOCK_ID[ap_in]#█#alter_product_name#█#alter_special_code#█#usage_rate_#█#alternativeQuestQuery.PRODUCT_ID[ap_in]#█#question_name#█#alternativeQuestQuery.SPECT_MAIN_ID[ap_in]#█#alternativeQuestQuery.USAGE_AMOUNT[ap_in]#█#alternativeQuestQuery.IS_PHANTOM[ap_in]#█#alternativeQuestQuery.MAIN_STOCK_ID[ap_in]#█#alternativeQuestQuery.MAIN_PRODUCT_ID[ap_in]#█#alternativeQuestQuery.MAIN_PRODUCT_NAME[ap_in]#">#alternativeQuestQuery.PRODUCT_DETAIL2[ap_in]#</option>';
                                                                }
                                                                if(len(_next_product_id_))
                                                                {
                                                                    questionProductImage='SELECT PATH,PRODUCT_ID,PATH_SERVER_ID,DETAIL FROM PRODUCT_IMAGES WHERE IMAGE_SIZE = 0 AND PRODUCT_ID = #_next_product_id_#';
                                                                    questionProductImageQuery = cfquery(SQLString : questionProductImage, Datasource : new_dsn3);
                                                                    if(questionProductImageQuery.recordcount)
                                                                        specAlternativeProductImage = '<img src="documents/product/#questionProductImageQuery.PATH#" title="#questionProductImageQuery.DETAIL#" width="150" height="150" border="0" align="absmiddle" />';
                                                                    else
                                                                        specAlternativeProductImage = '';
                                                                }
                                                                else
                                                                        specAlternativeProductImage = '';
                                                            }
                                                            alterNativeProduct='#alterNativeProduct#</select>';
                                                        }
                                                }
                                                else
                                                {
                                                        specAlternativeProductImage = '';
                                                        no_count = no_count + 1;
                                                }
                                                if(is_hidden neq 1)
                                                {
                                                    row_of_query = row_of_query + 1;
                                                    QueryAddRow(get_row,1);
                                                    zero = '';
                                                    for(kk=1;kk<=3-len(question_no);kk++)
                                                        zero = "#zero#0";
                                                    QuerySetCell(get_row,"QUESTION_NO","#zero##question_no#",row_of_query);
                                                    alterNativeProduct = replace(alterNativeProduct,',','.','all');
                                                    QuerySetCell(get_row,"DETAIL","#question_no#~#question_name#~#alterNativeProduct#~#specAlternativeProductImage#",row_of_query);
                                                    /*writeoutput('
                                                    <tr height="20" class="color-row"> 
                                                        <td valign="top">#row_number#</td>
                                                        <td valign="top">#question_name#</td>
                                                        <td valign="top">#alterNativeProduct#</td>
                                                        <td><div id="#select_image_div#">#specAlternativeProductImage#</div></td>
                                                    </tr>');*/
                                                }
                                                else
                                                {
                                                    writeoutput('#alterNativeProduct_hidden#');
                                                }
                                            }
                                            if((isdefined('attributes.upd_main_spect') and len(attributes.upd_main_spect)) or (isdefined('attributes.id') and len(attributes.id)))
                                            {
                                                '_deep_level_main_stock_id_#deep_level#' = _next_stock_id_;
                                                if(_next_spect_main_id_ gt 0)
                                                {
                                                    writeTree(_next_spect_main_id_,_n_stock_related_id_,0);
                                                }
                                            }
                                            else								
                                            {
                                                /* if(_n_operation_id_ gt 0) */ type_=3;  /*else type_=0; */
                                                writeTree(_next_spect_main_id_,_n_stock_related_id_,type_);
                                            }                              
                                            }
                                            deep_level = deep_level-1;
                                    }
                                    writeTree(main_spec_id_0,_deep_level_main_stock_id_0,0);
                            </cfscript>
                            <cfquery name="GET_ROW" dbtype="query">
                                SELECT * FROM GET_ROW ORDER BY QUESTION_NO
                            </cfquery>
                            <cfoutput query="get_row">
                                <cfscript>	 							
                                    new_row = detail;
                                    question_name = listgetat(new_row,2,'~');
                                    if(listlen(new_row,';') gte 3)
                                        alterNativeProduct = listgetat(new_row,3,'~');
                                    else
                                        alterNativeProduct = '';
                                    if(listlen(new_row,'~') gte 4)
                                        specAlternativeProductImage = listgetat(new_row,4,'~');
                                    else
                                        specAlternativeProductImage = '';
                                    writeoutput('
                                    <tr> 
                                        <td valign="top">#currentrow#</td>
                                        <td valign="top">#question_name#</td>
                                        <td valign="top">#alterNativeProduct#</td>
                                    </tr>');
                                </cfscript>
                            </cfoutput>
                        <cfelse>
                            <tr><td colspan="3"><cf_get_lang dictionary_id="34603.Ürüne Ait Bir Spec Kaydedilmemiş!"></td></tr>
                        </cfif>
                    </tbody>
                </cf_grid_list>
                <cf_box_footer>
                    <cfif get_product_info.is_prototype eq 1>
                        <cfif isdefined("no_count") and no_count neq 1>
                            <cfif ((isdefined('attributes.upd_main_spect') and len(attributes.upd_main_spect)) or (isdefined('attributes.id') and len(attributes.id)))>
                                <cf_workcube_buttons is_upd='1' is_delete='0' add_function="control()">
                            <cfelse>
                                <cf_workcube_buttons is_upd='0' is_delete='0' add_function="control()">
                            </cfif>
                        <cfelse>
                            <font color="FF0000"><cf_get_lang dictionary_id='60232.Eksik Alternatif Tanımları Olduğu için Spec Kaydedemezsiniz'> !</font>
                        </cfif>
                    <cfelse>
                        <font color="FF0000"><cf_get_lang dictionary_id="33260.Ürün Özelleştirilebilir Olmadığı İçin Spec Kaydedemezsiniz"> !</font>
                    </cfif>
                </cf_box_footer>
            </cfif>
        </cfform>
    </cf_box>
    <script type="text/javascript">
        function add_hidden_value(object_)
        {
            var deger_ = object_.value;
            var deger_title_ = object_.title;
            var select_box_leng = document.getElementsByName('altertive_selectbox').length;
            for(var cl_ind=0; cl_ind < select_box_leng; cl_ind++)
                {
                    if(document.getElementsByName('altertive_selectbox')[cl_ind].title == deger_title_ && document.getElementsByName('altertive_selectbox')[cl_ind] != object_)
                    {
                        old_rate = list_getat(document.getElementsByName('altertive_selectbox')[cl_ind].value,4,'█');
                        if(old_rate == '') old_rate = 0;
    
                        deger_new = list_setat(deger_,4,old_rate,'█');
                        deger_new = ReplaceAll(deger_new,',','█');
                        document.getElementsByName('altertive_selectbox')[cl_ind].value = deger_new;
                    }
                }
        }
        function selectImage(object_,curr)
        {
            var deger_ = object_.value;
            var productId_ = list_getat(object_.value,5,'█');
            div_id = 'spec_image_'+curr;
            /*document.getElementById('spec_image_'+curr).style.display='';
            var send_address = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_spec_alternative_product_image&product_id='+productId_;
            AjaxPageLoad(send_address,div_id,0);*/
        }
        function control()
        {
            <cfif not isdefined('attributes.upd_main_spect')>
                <cfif isdefined('alternativeQuestQuery')>
                    var select_box_leng = '<cfoutput>#counter#</cfoutput>';
                <cfelse>
                    var select_box_leng = 0;
                </cfif>
                //select_box_leng = select_box_leng + 2;
                if(select_box_leng > 0)
                {
                    for(var cl_ind=0; cl_ind < select_box_leng; cl_ind++)
                    {
                        if(document.getElementById("altertive_selectbox" + cl_ind ) != undefined)
                        {
                            if(document.getElementById("altertive_selectbox" + cl_ind).value=="")
                            {
                                alert("<cf_get_lang dictionary_id='33106.Alternatif Ürün Seçiniz'>"); 
                                document.getElementById("altertive_selectbox" + cl_ind ).focus(); 
                                return false;
                            }
                        }
                    }
                }
                else
                {
                    alert("<cf_get_lang dictionary_id='33261.Lütfen Ürüne Soru ve Alternatif Ürün Tanımlayınız'> !");
                    return false
                }
            </cfif>
            <cfif isdefined("attributes.draggable")>
				loadPopupBox('addSpecAll' , <cfoutput>#attributes.modal_id#</cfoutput>);
                return false;
            <cfelse>
                return true;
            </cfif>
        }
        <cfif isDefined('session.pp.userid') and not isDefined('alternativeQuestQuery')>
            alert("<cf_get_lang dictionary_id='33261.Lütfen Ürüne Soru ve Alternatif Ürün Tanımlayınız'> !");
            window.close();	
        </cfif>
    </script>
</cfif>