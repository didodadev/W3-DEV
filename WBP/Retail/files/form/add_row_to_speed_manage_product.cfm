<cfparam name="attributes.price_catid" default="#genel_fiyat_listesi#">
<cfparam name="attributes.category_name" default="">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.cat_id" default="">
<cfparam name="attributes.hierarchy1" default="">
<cfparam name="attributes.hierarchy2" default="">
<cfparam name="attributes.hierarchy3" default="">
<cfparam name="attributes.short_code_id" default="">
<cfparam name="attributes.product_stages" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.add_info_keyword" default="">
<cfparam name="attributes.sort_type" default="0">
<cfparam name="attributes.list_variation_id" default="">
<cfparam name="attributes.list_property_value" default="">
<cfparam name="attributes.list_property_id" default="">
<cfparam name="attributes.search_list_id" default="">
<cfparam name="attributes.search_department_id" default="">
<cfparam name="attributes.new_page" default="0">
<cfparam name="attributes.add_stock_gun" default="15">
<cfparam name="attributes.table_code" default="">
<cfparam name="attributes.koli_type" default="2">
<cfparam name="attributes.layout_id" default="">
<cfparam name="attributes.tedarikci_kodu" default="">

<cfif isdefined("attributes.search_startdate") and isdate(attributes.search_startdate)>
	<cf_date tarih = "attributes.search_startdate">
<cfelse>
	<cfset attributes.search_startdate = dateadd("m",-3,now())>
</cfif>
<cfif isdefined("attributes.search_finishdate") and isdate(attributes.search_finishdate)>
	<cf_date tarih = "attributes.search_finishdate">
<cfelse>
	<cfset attributes.search_finishdate = now()>
</cfif>

<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
    SELECT 
        PRODUCT_CAT.PRODUCT_CATID, 
        PRODUCT_CAT.HIERARCHY, 
        PRODUCT_CAT.HIERARCHY + ' - ' + PRODUCT_CAT.PRODUCT_CAT AS PRODUCT_CAT_NEW
    FROM 
        PRODUCT_CAT,
        PRODUCT_CAT_OUR_COMPANY PCO
    WHERE 
        PRODUCT_CAT.PRODUCT_CATID = PCO.PRODUCT_CATID AND
        PCO.OUR_COMPANY_ID = #session.ep.company_id# 
    ORDER BY 
        HIERARCHY ASC
</cfquery>

<cfquery name="GET_PRODUCT_CAT1" dbtype="query">
	SELECT 
        *
    FROM 
        GET_PRODUCT_CAT
    WHERE 
        HIERARCHY NOT LIKE '%.%'
    ORDER BY 
        HIERARCHY ASC
</cfquery>

<cfquery name="GET_PRODUCT_CAT2" dbtype="query">
	SELECT 
        *
    FROM 
        GET_PRODUCT_CAT
    WHERE 
        HIERARCHY LIKE '%.%' AND
        HIERARCHY NOT LIKE '%.%.%'
    ORDER BY 
        HIERARCHY ASC
</cfquery>

<cfquery name="GET_PRODUCT_CAT3" dbtype="query">
	SELECT 
        *
    FROM 
        GET_PRODUCT_CAT
    WHERE 
        HIERARCHY LIKE '%.%.%'
    ORDER BY 
        HIERARCHY ASC
</cfquery>

<cfquery name="get_product_brands" datasource="#dsn1#">
	SELECT BRAND_ID,BRAND_NAME FROM PRODUCT_BRANDS ORDER BY BRAND_NAME ASC
</cfquery>

<cfquery name="get_partners" datasource="#dsn#">
    SELECT
        TEDARIKCI_KOD,
        TEDARIKCI_ADI
    FROM
    (
        SELECT
            '0-' + CAST(C.COMPANY_ID AS VARCHAR) AS TEDARIKCI_KOD,
            NULL AS PROJECT_ID,
            C.COMPANY_ID,
            C.NICKNAME AS TEDARIKCI_ADI,
            '' AS PROJE_ADI,
            C.MEMBER_CODE,
            C.CITY,
            CC.COMPANYCAT
        FROM
            COMPANY C,
            COMPANY_CAT CC
        WHERE
            C.COMPANY_ID IN (SELECT P.COMPANY_ID FROM #dsn1_alias#.PRODUCT P WHERE P.COMPANY_ID IS NOT NULL) AND
            C.COMPANYCAT_ID = CC.COMPANYCAT_ID AND
            C.COMPANY_ID NOT IN (SELECT PP.COMPANY_ID FROM PRO_PROJECTS PP WHERE PP.COMPANY_ID IS NOT NULL)
    UNION ALL
        SELECT
            CAST(PP.PROJECT_ID AS VARCHAR) + '-' + CAST(C.COMPANY_ID AS VARCHAR) AS TEDARIKCI_KOD,
            PP.PROJECT_ID,
            C.COMPANY_ID,
            C.NICKNAME + ' - ' + PP.PROJECT_HEAD AS TEDARIKCI_ADI,
            PP.PROJECT_HEAD AS PROJE_ADI,
            C.MEMBER_CODE,
            C.CITY,
            CC.COMPANYCAT
        FROM
            COMPANY C,
            COMPANY_CAT CC,
            PRO_PROJECTS PP
        WHERE
            C.COMPANY_ID IN (SELECT P.COMPANY_ID FROM #dsn1_alias#.PRODUCT P WHERE P.COMPANY_ID IS NOT NULL) AND
            C.COMPANYCAT_ID = CC.COMPANYCAT_ID AND
            C.COMPANY_ID = PP.COMPANY_ID
    ) 
        T1
    ORDER BY
        T1.TEDARIKCI_ADI
</cfquery>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','Ürün Ekle',29410)#">
        <cfform name="search_product" method="post" action="#request.self#?fuseaction=#url.fuseaction#">
            <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
            <cfinput type="hidden" name="search_startdate" value="#dateformat(attributes.search_startdate,'dd/mm/yyyy')#">
            <cfinput type="hidden" name="search_finishdate" value="#dateformat(attributes.search_finishdate,'dd/mm/yyyy')#">
            <cfinput name="layout_id" id="layout_id" type="hidden" value="#attributes.layout_id#">
            <cfinput name="new_page" id="new_page" type="hidden" value="#attributes.new_page#">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-hierarchy1">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61641.Ana Grup'></label>
                        <div class="col col-8 col-sm-12">
                            <cf_multiselect_check 
                                query_name="GET_PRODUCT_CAT1"
                                selected_text="" 
                                name="hierarchy1"
                                option_text="#getLang('','Ana Grup',61641)#" 
                                width="100"
                                height="250"
                                option_name="PRODUCT_CAT_NEW" 
                                option_value="hierarchy"
                                value="#attributes.hierarchy1#">
                                <br />
                                <input type="checkbox" name="cat_in_out1" value="1" <cfif isdefined("attributes.cat_in_out1") or not isdefined("attributes.is_form_submitted")>checked</cfif>/>
                                <cf_get_lang dictionary_id='61653.İçeren Kayıtlar'>
                        </div>
                    </div>
                    <div class="form-group" id="item-hierarchy2">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61642.Alt Grup'> 1</label>
                        <div class="col col-8 col-sm-12">
                            <cf_multiselect_check 
                                query_name="GET_PRODUCT_CAT2"
                                selected_text="" 
                                name="hierarchy2"
                                option_text="#getLang('','Alt Grup',61642)# 1" 
                                width="100"
                                height="250"
                                option_name="PRODUCT_CAT_NEW" 
                                option_value="hierarchy"
                                value="#attributes.hierarchy2#">
                                <br />
                                <input type="checkbox" name="cat_in_out2" value="1" <cfif isdefined("attributes.cat_in_out2") or not isdefined("attributes.is_form_submitted")>checked</cfif>/>
                                <cf_get_lang dictionary_id='61653.İçeren Kayıtlar'>
                        </div>
                    </div>
                    <div class="form-group" id="item-hierarchy3">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61642.Alt Grup'> 2</label>
                        <div class="col col-8 col-sm-12">
                            <cf_multiselect_check 
                                query_name="GET_PRODUCT_CAT3"
                                selected_text=""  
                                name="hierarchy3"
                                option_text="#getLang('','Alt Grup',61642)# 2" 
                                width="100"
                                height="250"
                                option_name="PRODUCT_CAT_NEW" 
                                option_value="hierarchy"
                                value="#attributes.hierarchy3#">
                                <br />
                                <input type="checkbox" name="cat_in_out3" value="1" <cfif isdefined("attributes.cat_in_out3") or not isdefined("attributes.is_form_submitted")>checked</cfif>/>
                                <cf_get_lang dictionary_id='61653.İçeren Kayıtlar'>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-tedarikci_kodu">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
                        <div class="col col-8 col-sm-12">
                            <cf_multiselect_check 
                                query_name="get_partners"
                                selected_text=""  
                                name="tedarikci_kodu"
                                option_text="#getLang('','Tedarikçi',29533)#" 
                                width="100"
                                height="250"
                                option_name="TEDARIKCI_ADI" 
                                option_value="TEDARIKCI_KOD"
                                value="#attributes.tedarikci_kodu#">
                                <br />
                                <input type="checkbox" name="tedarikci_in_out" value="1" <cfif isdefined("attributes.tedarikci_in_out") or not isdefined("attributes.is_form_submitted")>checked</cfif>/>
                                <cf_get_lang dictionary_id='61653.İçeren Kayıtlar'>
                        </div>
                    </div>
                    <div class="form-group" id="item-brand_id">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58847.Marka'></label>
                        <div class="col col-8 col-sm-12">
                            <cf_multiselect_check 
                                query_name="get_product_brands"
                                selected_text=""  
                                name="brand_id"
                                option_text="#getLang('','Marka',58847)#" 
                                width="100"
                                height="250"
                                option_name="brand_name" 
                                option_value="brand_id"
                                value="#attributes.brand_id#">
                                <br />
                                <input type="checkbox" name="brand_in_out" value="1" <cfif isdefined("attributes.brand_in_out") or not isdefined("attributes.is_form_submitted")>checked</cfif>/>
                                <cf_get_lang dictionary_id='61653.İçeren Kayıtlar'>
                        </div>
                    </div>
                </div>
                <cfparam name="attributes.mode" default="7">
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-keyword">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57460.Filtre'></label>
                        <div class="col col-8 col-sm-12">
                            <cfinput type="text" name="keyword" id="keyword"  value="#attributes.keyword#" maxlength="500">
                        </div>
                    </div>
                    <div class="form-group" id="item-product_types">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='537.Ürün Tipi'></label>
                        <div class="col col-8 col-sm-12">
                            <select name="product_types" id="product_types">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="5"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 5)> selected</cfif>><cf_get_lang dictionary_id='37170.Tedarik Edilmiyor'></option>
                                <option value="1"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 1)> selected</cfif>><cf_get_lang dictionary_id='32579.Tedarik ediliyor'></option>
                                <option value="2"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 2)> selected</cfif>><cf_get_lang dictionary_id='37090.Hizmetler'></option>
                                <option value="16"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 16)> selected</cfif>><cf_get_lang dictionary_id='32513.Envantere dahil'></option>
                                <option value="3"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 3)> selected</cfif>><cf_get_lang dictionary_id='37423.Mallar'></option>
                                <option value="4"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 4)> selected</cfif>><cf_get_lang dictionary_id='36028.Terazi'></option>
                                <option value="6"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 6)> selected</cfif>><cf_get_lang dictionary_id='32517.Üretiliyor'></option>
                                <option value="13"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 13)> selected</cfif>><cf_get_lang dictionary_id='37556.Maliyet Takip Ediliyor'></option>
                                <option value="15"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 15)> selected</cfif>><cf_get_lang dictionary_id='63574.Kalite Takip Ediliyor'></option>
                                <option value="7"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 7)> selected</cfif>><cf_get_lang dictionary_id='37557.Seri No Takip'></option>
                                <option value="8"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 8)> selected</cfif>><cf_get_lang dictionary_id='37467.Karma Koli'></option>
                                <option value="9"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 9)> selected</cfif>><cf_get_lang dictionary_id='58079.İnternet'></option>
                                <option value="12"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 12)> selected</cfif>><cf_get_lang dictionary_id='58019.Extranet'></option>
                                <option value="10"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 10)> selected</cfif>><cf_get_lang dictionary_id='37063.Özelleştirilebilir'></option>
                                <option value="11"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 11)> selected</cfif>><cf_get_lang dictionary_id='37558.Sıfır Stok İle Çalış'></option>
                                <option value="14"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 14)> selected</cfif>><cf_get_lang dictionary_id='32520.Satışta'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-add_stock_gun">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='63007.İlave Gün'></label>
                        <div class="col col-8 col-sm-12">
                            <cfinput type="text" name="add_stock_gun" id="add_stock_gun" value="#attributes.add_stock_gun#" maxlength="500">
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_wrk_search_button search_function='input_control()' button_type="1" is_excel="0">
            </cf_box_footer>
        </cfform>
    </cf_box>
<script>
document.getElementById('keyword').select();
function input_control()
{
	if(search_product.keyword.value.length < 1 && 
		search_product.tedarikci_kodu.value == '' && 
		search_product.brand_id.value == '' && 
		search_product.hierarchy1.value == '' &&
		search_product.hierarchy2.value == '' &&
		search_product.hierarchy3.value == ''		
		)
	{
		alert('<cf_get_lang dictionary_id='63575.Tedarikçi, Kategori, Marka Seçiniz veya Filtreye Kelime Giriniz'>!');
		return false;
	}
	return true;
}
</script>
<cfif isdefined("attributes.is_form_submitted")>

<cfset b_stock_list = "">
<cfif len(attributes.keyword)>
	<cfquery name="get_barcode_stocks" datasource="#dsn1#">
    	SELECT
        	BARCODE ,
            STOCK_ID
        FROM 
        	STOCKS_BARCODES 
        WHERE 
        	<cfloop from="1" to="#listlen(attributes.keyword,' ')#" index="ccc">
				<cfset kelime_ = listgetat(attributes.keyword,ccc,' ')>
                <cfif ccc neq 1>OR</cfif>
                BARCODE = '#kelime_#'                               
            </cfloop>
    </cfquery>
    <cfif get_barcode_stocks.recordcount>
    	<cfset b_stock_list = valuelist(get_barcode_stocks.STOCK_ID)>
    </cfif>
</cfif>

	<cfset bugun_ = createodbcdatetime(createdate(year(now()),month(now()),day(now())))>
    <cfquery name="get_products" datasource="#dsn3#" result="query_result">
        SELECT
            S.*,
            PCC.HIERARCHY,
            PCC.PRODUCT_CAT,            
            PRICE_STANDART.PRICE PRICE_STANDART,
            PRICE_STANDART.PRICE_KDV PRICE_STANDART_KDV,
            (SELECT NICKNAME FROM #dsn_alias#.COMPANY C WHERE C.COMPANY_ID = P.COMPANY_ID) NICKNAME,
        	'' PROJECT
        FROM 
        	#dsn1_alias#.PRODUCT P,
            STOCKS S
                LEFT JOIN PRODUCT_CAT PCC ON S.PRODUCT_CATID = PCC.PRODUCT_CATID
                LEFT JOIN PRODUCT_UNIT ON S.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID
                LEFT JOIN PRICE_STANDART ON PRODUCT_UNIT.PRODUCT_ID = PRICE_STANDART.PRODUCT_ID
        WHERE
            P.PRODUCT_ID = S.PRODUCT_ID AND
            S.STOCK_STATUS = 1 AND
            PRICE_STANDART.PURCHASESALES = 0 AND
            PRODUCT_UNIT.IS_MAIN = 1 AND 
            PRICE_STANDART.PRICESTANDART_STATUS = 1 AND
            PRODUCT_UNIT.PRODUCT_UNIT_ID = PRICE_STANDART.UNIT_ID AND
			  <cfif isdefined("attributes.add_product_id") and len(attributes.add_product_id)>
                    P.PRODUCT_ID = #attributes.add_product_id# AND
                </cfif>	
                <cfif isdefined("attributes.all_product_list") and len(attributes.all_product_list)>
                    P.PRODUCT_ID IN (#attributes.all_product_list#) AND
                </cfif>
                <cfif isdefined("attributes.HIERARCHY1") and len(attributes.HIERARCHY1)>
                    <cfif isdefined("attributes.cat_in_out1")>
                    (
                        <cfset count_ = 0>
                        <cfloop list="#attributes.HIERARCHY1#" index="ccc">
                            <cfset count_ = count_ + 1>
                            P.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#.%">
                            <cfif count_ Neq listlen(attributes.HIERARCHY1)>
                                OR
                            </cfif>
                        </cfloop>
                    )
                    AND
                    <cfelse>
                    (
                        <cfset count_ = 0>
                        <cfloop list="#attributes.HIERARCHY1#" index="ccc">
                            <cfset count_ = count_ + 1>
                            P.PRODUCT_CODE NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#.%">
                            <cfif count_ Neq listlen(attributes.HIERARCHY1)>
                                AND
                            </cfif>
                        </cfloop>
                    )
                    AND
                    </cfif>
                </cfif>
                
                <cfif isdefined("attributes.HIERARCHY2") and len(attributes.HIERARCHY2)>
                    <cfif isdefined("attributes.cat_in_out2")>
                    (
                        <cfset count_ = 0>
                        <cfloop list="#attributes.HIERARCHY2#" index="ccc">
                            <cfset count_ = count_ + 1>
                            P.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#.%">
                            <cfif count_ Neq listlen(attributes.HIERARCHY2)>
                                OR
                            </cfif>
                        </cfloop>
                    )
                    AND
                    <cfelse>
                    (
                        <cfset count_ = 0>
                        <cfloop list="#attributes.HIERARCHY2#" index="ccc">
                            <cfset count_ = count_ + 1>
                            P.PRODUCT_CODE NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#.%">
                            <cfif count_ Neq listlen(attributes.HIERARCHY2)>
                                AND
                            </cfif>
                        </cfloop>
                    )
                    AND
                    </cfif>
                </cfif>
                
                <cfif isdefined("attributes.HIERARCHY3") and len(attributes.HIERARCHY3)>
                    <cfif isdefined("attributes.cat_in_out3")>
                    (
                        <cfset count_ = 0>
                        <cfloop list="#attributes.HIERARCHY3#" index="ccc">
                            <cfset count_ = count_ + 1>
                            P.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#.%">
                            <cfif count_ Neq listlen(attributes.HIERARCHY3)>
                                OR
                            </cfif>
                        </cfloop>
                    )
                    AND
                    <cfelse>
                    (
                        <cfset count_ = 0>
                        <cfloop list="#attributes.HIERARCHY3#" index="ccc">
                            <cfset count_ = count_ + 1>
                            P.PRODUCT_CODE NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#ccc#.%">
                            <cfif count_ Neq listlen(attributes.HIERARCHY3)>
                                AND
                            </cfif>
                        </cfloop>
                    )
                    AND
                    </cfif>
                </cfif>
                
                <cfif isdefined("attributes.tedarikci_kodu") and len(attributes.tedarikci_kodu)>
                    CAST(ISNULL(P.PROJECT_ID,0) AS VARCHAR) + '-' + CAST(P.COMPANY_ID AS VARCHAR) <cfif not isdefined("attributes.tedarikci_in_out")>NOT</cfif> IN ('#replace(attributes.tedarikci_kodu,",","','","all")#') AND
                </cfif>
                <cfif isdefined("attributes.brand_id") and len(attributes.brand_id)>
                    P.BRAND_ID <cfif not isdefined("attributes.brand_in_out")>NOT</cfif> IN (#attributes.brand_id#) AND
                </cfif>
                <cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
                    P.IS_PURCHASE = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
                    P.IS_INVENTORY = 0 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
                    P.IS_INVENTORY = 1 AND P.IS_PRODUCTION = 0 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
                    P.IS_TERAZI = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
                    P.IS_PURCHASE = 0 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
                    P.IS_PRODUCTION = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
                    P.IS_SERIAL_NO = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
                    P.IS_KARMA = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
                    P.IS_INTERNET = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
                    P.IS_PROTOTYPE = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
                    P.IS_ZERO_STOCK = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
                    P.IS_EXTRANET = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
                    P.IS_COST = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
                    P.IS_SALES = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
                    P.IS_QUALITY = 1 AND
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
                    P.IS_INVENTORY = 1 AND
                <cfelse>
                    P.IS_INVENTORY = 1 AND
                </cfif>
                <cfif len(attributes.keyword)>
                    (
                    (
                        P.PRODUCT_ID IS NOT NULL
                        <cfloop from="1" to="#listlen(attributes.keyword,' ')#" index="ccc">
                            <cfset kelime_ = listgetat(attributes.keyword,ccc,' ')>
                            AND
                            (
                            P.PRODUCT_NAME + ' ' + S.PROPERTY + ' ' + P.PRODUCT_CODE LIKE '%#kelime_#%' OR
                            P.PRODUCT_CODE_2 = '#kelime_#' OR
                            S.BARCOD = '#kelime_#' OR    
                            S.STOCK_CODE = '#kelime_#' OR
                            S.STOCK_CODE_2 = '#kelime_#'                                
                            )
                       </cfloop>
                    )
                    <cfif listlen(b_stock_list)>
                    OR S.STOCK_ID IN (#b_stock_list#)
                    </cfif>
                   )
                <cfelse>
                    P.PRODUCT_NAME LIKE '%#attributes.keyword#%'
                </cfif>
        ORDER BY
            P.PRODUCT_CODE ASC,
            P.PRODUCT_NAME,
            S.PROPERTY
    </cfquery>
    
    <div id="action_div"></div>
    <cf_box>
        <cf_grid_list id="manage_table">
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='57633.Barkod'></th>
                    <cfif get_products.recordcount gt 1>
                    <th width="15">
                        <ul class="ui-icon-list">
                            <li>
                                <input type="checkbox" name="all_product_id" id="all_product_id" value="1" onclick="check_all_row('<cfoutput>#get_products.recordcount#</cfoutput>');"/>
                            </li>
                            <li>
                                <a href="javascript://" onclick="send_to_add_row();"><img src="/images/plus_small.gif" /></a>
                            </li>
                        </ul>
                    </th>
                    </cfif>
                    <th><cf_get_lang dictionary_id='58221.Ürün Adı'></th>
                    <th><cf_get_lang dictionary_id='58585.Kod'></th>
                    <th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
                    <th><cf_get_lang dictionary_id='58084.Fiyat'></th>
                    <th><cf_get_lang dictionary_id='29533.Tedarikçi'></th>
                    
                </tr>
            </thead>
            <tbody>
                <cfset sira_ = 0>
                <cfset last_hier_ = "">
                <cfoutput query="get_products">
                <cfif currentrow eq 1 or product_id neq product_id[currentrow - 1]>
                    <cfset sira_ = sira_ + 1>
                    <cfset product_name_ = replace(product_name,'"','','all')>
                    <cfset product_name_ = replace(product_name_,"'","","all")>
                    <cfif last_hier_ is not HIERARCHY>
                        <cfset last_hier_ = HIERARCHY>
                        <tr>
                            <td colspan="9">
                                #PRODUCT_CAT#
                            </td>
                        </tr>
                    </cfif>
                    <cfset product_name_ = ucase(product_name)>
                    <cfif len(attributes.keyword)>
                        <cfset product_name_ = replace(product_name_,"#ucase(attributes.keyword)#","<font color='orange'><b>#ucase(attributes.keyword)#</b></font>","all")>
                    </cfif>
                    
                    <cfset property_ = ucase(property)>
                    <cfif len(attributes.keyword)>
                        <cfset property_ = replace(property_,"#ucase(attributes.keyword)#","<font color='orange'><b>#ucase(attributes.keyword)#</b></font>","all")>
                    </cfif>
                    
                    <tr id="product_row_#product_id#">
                        <td>#sira_#</td>
                        <td><a href="javascript://" onclick="show_hide_alts('#product_id#');" class="tableyazi">#BARCOD#</a></td>
                        <cfif get_products.recordcount gt 1>
                            <td><input type="checkbox" name="product_id_#sira_#" id="product_id_#sira_#" value="#product_id#"/></td>
                        </cfif>
                        <td><a href="javascript://" onclick="add_product('#product_id#');" class="tableyazi">#product_name_#</a></td>
                        <td>#product_code#</td>
                        <td>#product_code_2#</td>
                        <td style="text-align:right;">#TLFORMAT(PRICE_STANDART_KDV)#</td>
                        <td>#NICKNAME# #project#</td>
                        
                    </tr>
                    <tr row_code="in_product_row_#product_id#" style="display:none;">
                        <td></td>
                        <td>#BARCOD#</td>
                        <cfif get_products.recordcount gt 1>
                            <td>&nbsp;</td>
                        </cfif>
                        <td>#property_#</td>
                        <td>#product_code#</td>
                        <td>#stock_code_2#</td>
                        <td style="text-align:right;"></td>
                        <td></td>
                        
                    </tr>
                <cfelse>
                    <cfset property_ = ucase(property)>
                    <cfif len(attributes.keyword)>
                        <cfset property_ = replace(property_,"#ucase(attributes.keyword)#","<font color='orange'><b>#ucase(attributes.keyword)#</b></font>","all")>
                    </cfif>
                    <tr row_code="in_product_row_#product_id#" style="display:none;">
                        <td></td>
                        <td>#BARCOD#</td>
                        <cfif get_products.recordcount gt 1>
                            <td>&nbsp;</td>
                        </cfif>
                        <td>#property_#</td>
                        <td>#product_code#</td>
                        <td>#stock_code_2#</td>
                        <td style="text-align:right;"></td>
                        <td></td>
                    </tr>
                </cfif>
                </cfoutput>
            </tbody>
        </cf_grid_list>
    </cf_box>
</div>
<script>
function send_to_add_row()
{
	product_list_ = '0';
	for (var c=1; c <= <cfoutput>#sira_#</cfoutput>; c++)
	{
		if(document.getElementById('product_id_' + c).checked == true)
		{
			if(list_find(window.opener.document.getElementById('all_product_list').value,document.getElementById('product_id_' + c).value) > 0)
			{
				//	
			}
			else
			{
				product_list_ = product_list_ + ',' + document.getElementById('product_id_' + c).value;
			}
			//add_product(document.getElementById('product_id_' + m).value);
		}
	}
	
	if(product_list_ == '0')
	{
		alert('<cf_get_lang dictionary_id='63576.Ekleyebileceğiniz Ürün Seçmediniz'>!');
		return false;
	}
	
	/*
    var mainDiv = $('#messageDiv');
    var mainDivClass='messageDiv' ;
    var mainDivHeader = $ ('#messageDivHeader');
    var mainHeaderInfo = $ ('#messageDivHeaderInfo');
    var mainDivBody = $('.messageDivBody');
    myPopup(mainDivClass);
    gizle(working_div_main);
    mainHeaderInfo.text('İşlem Durumu');
	
	mainDivBody.text('Ürünler Ekleniyor! Lütfen Bekleyiniz!');*/
	
	
	<cfoutput>
	adres_ = '#request.self#?fuseaction=retail.popup_add_row_to_speed_manage_product_in';
	adres_ += '&product_id=' + product_list_;
	adres_ += '&search_startdate=#dateformat(attributes.search_startdate,"dd/mm/yyyy")#';
	adres_ += '&search_finishdate=#dateformat(attributes.search_finishdate,"dd/mm/yyyy")#';
	adres_ += '&search_department_id=' + window.opener.document.getElementById('department_id_list').value;
	adres_ += '&table_code=';
	adres_ += '&layout_id=#attributes.layout_id#';
	adres_ += '&add_stock_gun=#attributes.add_stock_gun#';
	adres_ += '&dept_count_=' + list_len(window.opener.document.getElementById('department_id_list').value);
	adres_ += '&is_purchase_type=' + window.opener.document.getElementById('is_purchase_type').value;
	adres_ += '&add_action=1';
	adres_ += '&new_page=#attributes.new_page#';
	window.location.href = adres_;
	</cfoutput>	
}

function add_product(product_id)
{
	liste1_ = window.opener.document.getElementById('all_product_list').value;
	if(list_find(liste1_,product_id) > 0)
	{
		alert('<cf_get_lang dictionary_id='63578.Bu Ürün Zaten Listenizde'>!');
		return false;
	}
	
	<cfoutput>
	adres_ = '#request.self#?fuseaction=retail.popup_add_row_to_speed_manage_product_in';
	adres_ += '&product_id=' + product_id;
	adres_ += '&search_startdate=#dateformat(attributes.search_startdate,"dd/mm/yyyy")#';
	adres_ += '&search_finishdate=#dateformat(attributes.search_finishdate,"dd/mm/yyyy")#';
	adres_ += '&search_department_id=' + window.opener.document.getElementById('department_id_list').value;
	adres_ += '&table_code=';
	adres_ += '&layout_id=#attributes.layout_id#';
	adres_ += '&add_stock_gun=#attributes.add_stock_gun#';
	adres_ += '&dept_count_=' + list_len(window.opener.document.getElementById('department_id_list').value);
	adres_ += '&is_purchase_type=' + window.opener.document.getElementById('is_purchase_type').value;
	adres_ += '&add_action=1';
	adres_ += '&new_page=#attributes.new_page#';
	window.location.href = adres_;
	</cfoutput>	
}

function show_hide_alts(product_id)
{
	rel_ = "row_code='in_product_row_" + product_id + "'";
	col1 = $("#manage_table tr[" + rel_ + "]");	
	col1.toggle();
}

function check_all_row(eleman_sayisi)
{
	if(document.getElementById('all_product_id').checked == true)
	{
		for (var m=1; m <= eleman_sayisi; m++)
		{
			document.getElementById('product_id_' + m).checked = true;
		}
	}
	else
	{
		for (var m=1; m <= eleman_sayisi; m++)
		{
			document.getElementById('product_id_' + m).checked = false;
		}
	}
}
</script>
</cfif>