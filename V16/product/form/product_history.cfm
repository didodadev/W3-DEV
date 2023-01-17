<cfquery name="GET_PRODUCT_HISTORY" datasource="#DSN1#">
    SELECT
        PH.PRODUCT_STATUS,
        PH.PRODUCT_NAME,
        PH.USER_FRIENDLY_URL,
        PH.PRODUCT_CODE,
        PH.PRODUCT_CODE_2,
        PH.BARCOD,
        PH.IS_COST,
        PH.IS_KARMA,
        PH.IS_PRODUCTION,
        PH.IS_SERIAL_NO,
        PH.IS_SALES,PH.
        IS_PURCHASE,
        PH.IS_PROTOTYPE,
        PH.IS_INVENTORY,
        PH.PACKAGE_CONTROL_TYPE,
        PH.IS_INTERNET,
        PH.IS_EXTRANET,
        PH.IS_LIMITED_STOCK,
        PH.IS_TERAZI,
        PH.IS_ZERO_STOCK,
        PH.IS_COMMISSION, 
        PH.UPDATE_DATE,
        PH.RECORD_DATE,
        PH.PRODUCT_DETAIL2,
       	(SELECT BRAND_NAME FROM PRODUCT_BRANDS PB WHERE PB.BRAND_ID=PH.BRAND_ID) BRAND_NAME,
        (SELECT MODEL_NAME FROM PRODUCT_BRANDS_MODEL PBM WHERE PBM.MODEL_ID=PH.SHORT_CODE_ID) MODEL_NAME,
        (SELECT FULLNAME FROM #dsn_alias#.COMPANY C WHERE C.COMPANY_ID =PH.COMPANY_ID) AS FULLNAME, 
        (SELECT TAX FROM #dsn2_alias#.SETUP_TAX ST WHERE ST.TAX=PH.TAX_PURCHASE) AS ALIS_TAX,
        (SELECT TAX FROM #dsn2_alias#.SETUP_TAX ST WHERE ST.TAX=PH.TAX) AS SATIS_TAX,
        (SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME FROM #DSN_ALIAS#.EMPLOYEES E WHERE E.EMPLOYEE_ID=PH.RECORD_MEMBER) AS RECORD_NAME,
        (SELECT EMPLOYEE_NAME +' '+EMPLOYEE_SURNAME FROM #DSN_ALIAS#.EMPLOYEES E WHERE  E.EMPLOYEE_ID=PH.UPDATE_EMP) AS UPDATE_NAME,
        (SELECT HIERARCHY+' '+PRODUCT_CAT FROM PRODUCT_CAT PC WHERE PC.PRODUCT_CATID=PH.PRODUCT_CATID) AS HIERARCHY
    FROM
        PRODUCT_HISTORY PH
    WHERE
        PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer"  value="#attributes.product_id#">
    ORDER BY 
        PH.PRODUCT_HISTORY_ID DESC
</cfquery>

<cf_box title="#getLang('','Tarihçe',57473)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfif get_product_history.recordcount>
        <cfset temp_ = 0>
        <cfoutput query="get_product_history">
            <cfset temp_ = temp_ +1>
            <cf_seperator id="history_#temp_#" header="#dateformat(update_date,dateformat_style)# (#timeformat(update_date,timeformat_style)#) - #UPDATE_NAME#" is_closed="1">
            <cf_box_elements id="history_#temp_#" style="display:none;">
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-product_name">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57657.Product'></label>
                        <div class="col col-8 col-sm-12">
                            #product_name#
                        </div>                
                    </div> 
                    <div class="form-group" id="item-hierarchy">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                        <div class="col col-8 col-sm-12">
                            #hierarchy#
                        </div>                
                    </div> 
                    <div class="form-group" id="item-brand_name">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58847.Marka'></label>
                        <div class="col col-8 col-sm-12">
                            #brand_name#
                        </div>                
                    </div> 
                    <div class="form-group" id="item-product_code_2">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57789.özel Kodu'></label>
                        <div class="col col-8 col-sm-12">
                            #product_code_2#
                        </div>                
                    </div> 
                    <div class="form-group" id="item-model_name">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58225.Model'></label>
                        <div class="col col-8 col-sm-12">
                            #model_name#
                        </div>                
                    </div>
                    <div class="form-group" id="item-barcod">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57633.Barkod'></label>
                        <div class="col col-8 col-sm-12">
                            #barcod#
                        </div>                
                    </div>
                    <div class="form-group" id="item-product_code">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58800.Ürün Kodu'></label>
                        <div class="col col-8 col-sm-12">
                            #product_code#
                        </div>                
                    </div>
                    <div class="form-group" id="item-fullname">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
                        <div class="col col-8 col-sm-12">
                            #fullname#
                        </div>                
                    </div>
                    <div class="form-group" id="item-alis_tax">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='42993.Alış_KDV'></label>
                        <div class="col col-8 col-sm-12">
                            #alis_tax#
                        </div>                
                    </div>
                    <div class="form-group" id="item-satis_tax">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='37916.Satış KDV'></label>
                        <div class="col col-8 col-sm-12">
                            #satis_tax#
                        </div>                
                    </div>
                    <div class="form-group" id="item-follow">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58258.Maliyet'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif is_cost eq 1><cf_get_lang dictionary_id='37175.Takip Ediliyor'><cfelse><cf_get_lang dictionary_id='38009.Takip Edilmiyor'></cfif>
                        </div>                
                    </div>
                    <div class="form-group" id="item-is_karma">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='37467.Karma Koli'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif is_karma><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif>
                        </div>                
                    </div>
                    <div class="form-group" id="item-is_production">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57456.Üretim'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif is_production><cf_get_lang dictionary_id='37057.Üretiliyor'><cfelse><cf_get_lang dictionary_id='37991.Üretilmiyor'></cfif>
                        </div>                
                    </div>
                    <div class="form-group" id="item-package_control_type">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='37768.Paket Kontrol Tipi'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif package_control_type eq 1><cf_get_lang dictionary_id ='40429.Kendisi'></cfif>
                            <cfif package_control_type eq 2><cf_get_lang dictionary_id ='37770.Bileşenleri'></cfif>
                        </div>                
                    </div>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-is_serial_no">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57637.Seri No'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif is_serial_no><cf_get_lang dictionary_id='37349.Takibi Yapılıyor'><cfelse><cf_get_lang dictionary_id='38000.Takibi Yapılmıyor'></cfif>
                        </div>                
                    </div>
                    <div class="form-group" id="item-is_internet">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='37064.İnternet'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif is_internet><cf_get_lang dictionary_id='37065.Satılıyor'><cfelse><cf_get_lang dictionary_id='38020.Satılamaz'></cfif>
                        </div>                
                    </div>
                    <div class="form-group" id="item-is_extranet">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58019.Extranet'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif is_extranet eq 1><cf_get_lang dictionary_id='37065.Satılıyor'><cfelse><cf_get_lang dictionary_id='38020.Satılamaz'></cfif>
                        </div>                
                    </div>
                    <div class="form-group" id="item-is_limited_stock">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='37922.Stoklarla Sınırlı'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif len(is_limited_stock) and is_limited_stock eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif>
                        </div>                
                    </div>
                    <div class="form-group" id="item-is_terazi">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='37066.Terazi'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif is_terazi><cf_get_lang dictionary_id='37067.Teraziye Gidiyor'><cfelse><cf_get_lang dictionary_id='37066.Terazi'></cfif>
                        </div>                
                    </div>
                    <div class="form-group" id="item-is_zero_stock">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='37351.Sıfır Stok'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif is_zero_stock><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif>
                        </div>                
                    </div>
                    <div class="form-group" id="item-is_commission">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='37957.Pos Komisyonu Hesapla'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif is_commission eq 1><cf_get_lang dictionary_id='58998.Hesapla'><cfelse><cf_get_lang dictionary_id='29440.Hesaplama'></cfif>
                        </div>                
                    </div>
                    <div class="form-group" id="item-is_prototype">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='37062.Prototip'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif is_prototype><cf_get_lang dictionary_id='37063.Ozellestirilebilir'><cfelse><cf_get_lang dictionary_id='38013.Ozellestirilemez'></cfif>
                        </div>                
                    </div>
                    <div class="form-group" id="item-is_inventory">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='37054.Envanter'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif is_inventory><cf_get_lang dictionary_id='38021.Dahil'><cfelse><cf_get_lang dictionary_id='38022.Dahil Değil'></cfif>
                        </div>                
                    </div>
                    <div class="form-group" id="item-is_sales">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57448.Satış'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif is_sales><cf_get_lang dictionary_id='37059.satışta'><cfelse><cf_get_lang dictionary_id='37980.Satışta Değil'></cfif>
                        </div>                
                    </div>
                    <div class="form-group" id="item-is_purchase">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='29745.Tedarik'></label>
                        <div class="col col-8 col-sm-12">
                            <cfif is_purchase><cf_get_lang dictionary_id='37061.Tedarik Ediliyor'><cfelse><cf_get_lang dictionary_id='37170.Tedarik Edilmiyor'></cfif>
                        </div>                
                    </div>
                    <div class="form-group" id="item-user_friendly_url">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='50659.Kullanıcı Dostu Url'></label>
                        <div class="col col-8 col-sm-12">
                            #user_friendly_url#
                        </div>                
                    </div>
                    <div class="form-group" id="item-product_detail2">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57629.Açıklama'> 2</label>
                        <div class="col col-8 col-sm-12">
                            #product_detail2#
                        </div>                
                    </div>
                </div>
            </cf_box_elements>	
        </cfoutput>
    </cfif>
 </cf_box>
 
