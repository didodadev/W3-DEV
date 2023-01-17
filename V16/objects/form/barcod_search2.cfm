<cf_get_lang_set module_name="product">
<cfparam name="attributes.barcod" default="">
<cfparam name="attributes.category_name" default="">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.cat_id" default="">
<cfparam name="attributes.short_code_id" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.status" default="1">
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.product_name" default="">
<cfif isdefined("attributes.is_form_submitted")>
    <cfquery name="GET_STOCKS" datasource="#DSN3#">
    	SELECT
            T1.BARCODE,
            T1.STOCK_ID,
            T1.PRODUCT_ID,
            T1.PRODUCT_NAME,
            T1.PROPERTY,
            T1.STOCK_CODE,
            T1.KARMA_PRODUCT_ID,
            T1.BRAND_NAME,
            T1.MODEL_NAME
        FROM
        (
            SELECT
                GET_STOCK_BARCODES.BARCODE,
                GET_STOCK_BARCODES.STOCK_ID,
                S.PRODUCT_ID,
                S.PRODUCT_NAME,
                S.PROPERTY,
                S.STOCK_CODE,
                '' KARMA_PRODUCT_ID,
                BRAND_NAME,
                MODEL_NAME
            FROM
                GET_STOCK_BARCODES,
                STOCKS AS S
                    LEFT JOIN #dsn1_alias#.PRODUCT_BRANDS ON S.BRAND_ID = PRODUCT_BRANDS.BRAND_ID
                    LEFT JOIN #dsn1_alias#.PRODUCT_BRANDS_MODEL ON S.SHORT_CODE_ID = PRODUCT_BRANDS_MODEL.MODEL_ID
            WHERE
                <cfif listlen(attributes.barcod,"+") gt 1>
                    <cfloop from="1" to="#listlen(attributes.barcod,'+')#" index="pro_index">
                        S.PRODUCT_NAME LIKE '%#ListGetAt(attributes.barcod,pro_index,"+")#%' 
                        <cfif pro_index neq listlen(attributes.barcod,'+')>AND</cfif>
                    </cfloop>
                <cfelse>
                    (S.PRODUCT_NAME LIKE '#attributes.barcod#%' OR GET_STOCK_BARCODES.BARCODE LIKE '#attributes.barcod#%' OR S.STOCK_CODE LIKE '%#attributes.barcod#%')
                </cfif>
                AND S.PRODUCT_ID = GET_STOCK_BARCODES.PRODUCT_ID 
                AND S.STOCK_ID = GET_STOCK_BARCODES.STOCK_ID
                <!--- marka --->
                <cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and len(attributes.brand_name)>
                    AND S.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
                </cfif>
                <!--- model --->
                <cfif isdefined("attributes.short_code_id") and len(attributes.short_code_id) and len(attributes.short_code_name)>
                    AND S.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.short_code_id#">
                </cfif>		
                <!--- kategori --->	
                <cfif isdefined("attributes.cat") and len(attributes.cat) and len(attributes.category_name)>
                    AND S.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cat#.%">
                </cfif>
                <!--- sorumlu --->
                <cfif isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_manager)>
                    AND S.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#">
                </cfif>
                <!--- urun ozellikleri --->
                <cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
                    AND S.IS_PURCHASE = 1
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
                    AND S.IS_INVENTORY = 0
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
                    AND S.IS_INVENTORY = 1 AND S.IS_PRODUCTION = 0
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
                    AND S.IS_TERAZI = 1
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
                    AND S.IS_PURCHASE = 0
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
                    AND S.IS_PRODUCTION = 1
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
                    AND S.IS_SERIAL_NO = 1
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
                    AND S.IS_KARMA = 1 
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
                    AND S.IS_INTERNET = 1
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
                    AND S.IS_PROTOTYPE = 1
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
                    AND S.IS_ZERO_STOCK = 1
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
                    AND S.IS_EXTRANET = 1
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
                    AND S.IS_COST = 1 
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
                    AND S.IS_SALES = 1
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
                    AND S.IS_QUALITY = 1
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
                    AND S.IS_INVENTORY = 1
                <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 17)>
                    AND S.IS_LOT_NO = 1
                </cfif>
                <!--- sktif/pasif --->
                <cfif len(attributes.status)>
                    AND S.STOCK_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.status#">
                </cfif>
            <!--- karma koli icerigi gelsin --->
            <cfif isdefined('attributes.product_types') and (attributes.product_types eq 8) and isdefined("attributes.karma_koli_icerik")>
                UNION ALL
                
                SELECT
                    SKP.BARCOD,
                    GET_STOCK_BARCODES.STOCK_ID,
                    SKP.PRODUCT_ID,
                    SKP.PRODUCT_NAME,
                    SKP.PROPERTY,
                    SKP.STOCK_CODE,
                    KP.KARMA_PRODUCT_ID,
                    BRAND_NAME,
                    MODEL_NAME
                FROM
                    #dsn1_alias#.KARMA_PRODUCTS KP,  
                    GET_STOCK_BARCODES, 
                    STOCKS AS S,
                    STOCKS AS SKP
                        LEFT JOIN #dsn1_alias#.PRODUCT_BRANDS ON SKP.BRAND_ID = PRODUCT_BRANDS.BRAND_ID
                        LEFT JOIN #dsn1_alias#.PRODUCT_BRANDS_MODEL ON SKP.SHORT_CODE_ID = PRODUCT_BRANDS_MODEL.MODEL_ID
                WHERE
                    <cfif listlen(attributes.barcod,"+") gt 1>
                        <cfloop from="1" to="#listlen(attributes.barcod,'+')#" index="pro_index">
                            S.PRODUCT_NAME LIKE '%#ListGetAt(attributes.barcod,pro_index,"+")#%' 
                            <cfif pro_index neq listlen(attributes.barcod,'+')>AND</cfif>
                        </cfloop>
                    <cfelse>
                        (S.PRODUCT_NAME LIKE '#attributes.barcod#%' OR GET_STOCK_BARCODES.BARCODE LIKE '#attributes.barcod#%' OR S.STOCK_CODE LIKE '%#attributes.barcod#%')
                    </cfif>
                    AND S.PRODUCT_ID = GET_STOCK_BARCODES.PRODUCT_ID 
                    AND S.STOCK_ID = GET_STOCK_BARCODES.STOCK_ID
                    AND KP.KARMA_PRODUCT_ID = S.PRODUCT_ID 
                    AND KP.STOCK_ID = SKP.STOCK_ID
                    <!--- marka --->
                    <cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and len(attributes.brand_name)>
                        AND S.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
                    </cfif>
                    <!--- model --->
                    <cfif isdefined("attributes.short_code_id") and len(attributes.short_code_id) and len(attributes.short_code_name)>
                        AND S.SHORT_CODE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.short_code_id#">
                    </cfif>		
                    <!--- kategori --->	
                    <cfif isdefined("attributes.cat") and len(attributes.cat) and len(attributes.category_name)>
                        AND S.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cat#.%">
                    </cfif>
                    <!--- sorumlu --->
                    <cfif isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_manager)>
                        AND S.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#">
                    </cfif>
                    <!--- urun ozellikleri --->
                    <cfif isdefined('attributes.product_types') and (attributes.product_types eq 1)>
                        AND S.IS_PURCHASE = 1
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 2)>
                        AND S.IS_INVENTORY = 0
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 3)>
                        AND S.IS_INVENTORY = 1 AND S.IS_PRODUCTION = 0
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 4)>
                        AND S.IS_TERAZI = 1
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 5)>
                        AND S.IS_PURCHASE = 0
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 6)>
                        AND S.IS_PRODUCTION = 1
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 7)>
                        AND S.IS_SERIAL_NO = 1
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 8)>
                        AND S.IS_KARMA = 1 
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 9)>
                        AND S.IS_INTERNET = 1
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 10)>
                        AND S.IS_PROTOTYPE = 1
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 11)>
                        AND S.IS_ZERO_STOCK = 1
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 12)>
                        AND S.IS_EXTRANET = 1
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 13)>
                        AND S.IS_COST = 1 
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 14)>
                        AND S.IS_SALES = 1
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 15)>
                        AND S.IS_QUALITY = 1
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 16)>
                        AND S.IS_INVENTORY = 1
                    <cfelseif isdefined('attributes.product_types') and (attributes.product_types eq 17)>
                        AND S.IS_LOT_NO = 1
                    </cfif>
                    <!--- sktif/pasif --->
					<cfif len(attributes.status)>
                        AND S.STOCK_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.status#">
                    </cfif>
            </cfif>
        ) T1
        ORDER BY
            T1.STOCK_ID,
            T1.KARMA_PRODUCT_ID      
    </cfquery>
    <cfset GET_STOCKS.product_name=attributes.product_name>
<cfelse>
	<cfset GET_STOCKS.RecordCount = 0>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','ürün','57657')# - #getLang('','Barkod Ara','37699')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="add_property" action="#request.self#?fuseaction=objects.popup_barcod_search2" method="post">
            <cf_box_search>
                <cfinput type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
                <cfinput type="hidden" name="PRODUCT_NAME" id="PRODUCT_NAME" value="#decodeForHTML(attributes.product_name)#">
                <div class="form-group" >
                    <select name="status" id="status" >
                        <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                        <option value="1"<cfif isDefined("attributes.status") and (attributes.status eq 1)>selected</cfif>>Aktif</option>
                        <option value="0"<cfif isDefined("attributes.status") and (attributes.status eq 0)>selected</cfif>>Pasif</option>
                    </select>	
                </div>
                <div class="form-group" >
                    <cfinput type="text" name="barcod" maxlength="13" value="#attributes.barcod#">
                </div>
                <div class="form-group" >
                    <cf_wrkproductbrand
                        width="100"
                        compenent_name="getProductBrand"               
                        boxwidth="240"
                        boxheight="150"
                        brand_id="#attributes.brand_id#">
                </div>
                <div class="form-group" >
                    <cf_wrkproductmodel
                        returninputvalue="short_code_id,short_code_name"
                        returnqueryvalue="MODEL_ID,MODEL_NAME"
                        width="100"
                        fieldname="short_code_name"
                        fieldid="short_code_id"
                        control_field_id="brand_id"
                        control_field_name="brand_name"
                        compenent_name="getProductModel"            
                        boxwidth="240"
                        boxheight="150"                        
                        model_id="#attributes.short_code_id#">
                </div>
                <div class="form-group" >
                    <input type="checkbox" name="karma_koli_icerik" id="karma_koli_icerik" <cfif isdefined("attributes.karma_koli_icerik")>checked</cfif>>
                    <cf_get_lang dictionary_id='60248.Karma Koli İçeriği Gelsin'>
                </div>
                <div class="form-group" ><cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_property' , #attributes.modal_id#)"),DE(""))#"></div>
                </cf_box_search>
            <cf_box_search_detail search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_property' , #attributes.modal_id#)"),DE(""))#">
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">  
                    <div class="form-group" >
                        <select name="product_types" id="product_types">
                            <option value=""><cf_get_lang dictionary_id='57734.Seciniz'></option>
                            <option value="5"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 5)> selected</cfif>><cf_get_lang dictionary_id='37170.Tedarik Edilmiyor'></option>
                            <option value="1"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 1)> selected</cfif>><cf_get_lang dictionary_id='37061.Tedarik Ediliyor'></option>
                            <option value="2"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 2)> selected</cfif>><cf_get_lang dictionary_id='37090.Hizmetler'></option>
                            <option value="16"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 16)> selected</cfif>><cf_get_lang dictionary_id='37055.Envantere Dahil'></option>
                            <option value="3"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 3)> selected</cfif>><cf_get_lang dictionary_id='37423.Mallar'></option>
                            <option value="4"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 4)> selected</cfif>><cf_get_lang dictionary_id='37066.Terazi'></option>
                            <option value="6"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 6)> selected</cfif>><cf_get_lang dictionary_id='37057.Üretiliyor'></option>
                            <option value="13"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 13)> selected</cfif>><cf_get_lang dictionary_id='37556.Maliyet Takip Ediliyor'></option>
                            <option value="15"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 15)> selected</cfif>><cf_get_lang dictionary_id="37254.Kalite"> <cf_get_lang dictionary_id="37175.Takip Ediliyor"></option>
                            <option value="7"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 7)> selected</cfif>><cf_get_lang dictionary_id='37557.Seri No Takip'></option>
                            <option value="8"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 8)> selected</cfif>><cf_get_lang dictionary_id='37467.Karma Koli'></option>
                            <option value="9"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 9)> selected</cfif>><cf_get_lang dictionary_id='58079.İnternet'></option>
                            <option value="12"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 12)> selected</cfif>><cf_get_lang dictionary_id='58019.Extranet'></option>
                            <option value="10"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 10)> selected</cfif>><cf_get_lang dictionary_id='37063.Özelleştirilebilir'></option>
                            <option value="11"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 11)> selected</cfif>><cf_get_lang dictionary_id='37558.Sıfır Stok İle Çalış'></option>
                            <option value="14"<cfif isDefined("attributes.product_types") and (attributes.product_types eq 14)> selected</cfif>><cf_get_lang dictionary_id='37059.Satışta'></option>
                        </select>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">  
                    <div class="form-group" >
                        <div class="input-group">
                            <input type="hidden" name="cat_id" id="cat_id" value="<cfif len(attributes.cat_id) and len(attributes.category_name)><cfoutput>#attributes.cat_id#</cfoutput></cfif>">
                            <input type="hidden" name="cat" id="cat" value="<cfif len(attributes.cat) and len(attributes.category_name)><cfoutput>#attributes.cat#</cfoutput></cfif>">
                            <input type="text" name="category_name" id="category_name" onfocus="AutoComplete_Create('category_name','PRODUCT_CATID,PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID,HIERARCHY','cat_id,cat','','3','200','','1');" value="<cfif len(attributes.category_name)><cfoutput>#attributes.category_name#</cfoutput></cfif>" autocomplete="off" placeholder="<cfoutput>#getLang('','kategori','57486')#</cfoutput>">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_id=add_property.cat_id&field_code=add_property.cat&field_name=add_property.category_name</cfoutput>');"><span>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="3" sort="true">  
                    <div class="form-group" >
                        <div class="input-group">
                            <input type="hidden" name="pos_code" id="pos_code" value="<cfif isdefined("attributes.pos_code")><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
                            <input type="text" name="pos_manager" id="pos_manager" onfocus="AutoComplete_Create('pos_manager','FULLNAME','FULLNAME','get_emp_pos','','POSITION_CODE','pos_code','','3','130');" value="<cfif isdefined("attributes.pos_code") and len(attributes.pos_code)><cfoutput>#attributes.pos_manager#</cfoutput></cfif>" maxlength="255" autocomplete="off" placeholder="<cfoutput>#getLang('','sorumlu','57544')#</cfoutput>">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_property.pos_code&field_name=add_property.pos_manager<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.add_property.pos_manager.value),'list','popup_list_positions');"></span>
                        </div>
                    </div>
                </div>
            </cf_box_search_detail> 
  
        <cf_grid_list>	
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='57487.No'></th>
                    <th><cf_get_lang dictionary_id='57633.Barkod'></th>
                    <th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                    <th><cf_get_lang dictionary_id='57452.Stok'></th>
                    <th><cf_get_lang dictionary_id='58847.Marka'></th>
                    <th><cf_get_lang dictionary_id='58225.Model'></th>	
                    <th width="20"><input type="checkbox" name="allcheck" id="allcheck" onClick="wrk_select_all('allcheck','is_sec');"></th>
                </tr>
            </thead>
            <tbody>
                <cfif GET_STOCKS.RecordCount>
                    <cfoutput query="GET_STOCKS">
                        <tr>
                            <td>#currentrow#</td>
                            <td>
                                <cfif karma_product_id neq 0>
                                    <a href="javascript://" onClick="<cfif not isdefined("attributes.draggable")>opener.</cfif>add_row('#BARCODE#','1','#attributes.product_name#');" class="tableyazi">#BARCODE#</a>
                                <cfelse>
                                    #BARCODE#	
                                </cfif>
                            </td>
                            <td>
                                <cfif karma_product_id neq 0>
                                    <a href="javascript://" onClick="<cfif not isdefined("attributes.draggable")>opener.</cfif>add_row('#STOCK_CODE#','1','#attributes.product_name#');" class="tableyazi">#STOCK_CODE#</a>
                                <cfelse>
                                    #STOCK_CODE#	
                                </cfif>
                            </td>
                            <td <cfif karma_product_id eq 0>class="txtbold"</cfif>>#attributes.product_name# <cfif len(PROPERTY) and trim(PROPERTY) neq "-">-#PROPERTY#</cfif></td>
                            <td>#brand_name#</td>
                            <td>#model_name#</td>
                            <td>
                                <input type="checkbox" name="is_sec" id="is_sec" value="" <cfif karma_product_id eq 0>disabled="disabled"</cfif>>
                                
                            </td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr><td colspan="7" height="20"><cfif not isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayit Yok'>!</cfif></td></tr>
                </cfif>   
            </tbody>
            
        </cf_grid_list>
        <cfif GET_STOCKS.RecordCount>
            <div class="ui-info-bottom  flex-end">
                <div><a class="ui-btn ui-btn-success" href="javascript://" onclick="get_all_records();"><cf_get_lang dictionary_id='57461.Kaydet'></a></div>
            </div>
        </cfif> 
    </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('barcod').focus();
	function get_all_records()
	{
		<cfif GET_STOCKS.RecordCount>
			<cfoutput query="GET_STOCKS">
				if(document.getElementsByName("is_sec")[#currentrow#-1].checked == true)
                <cfif not isdefined("attributes.draggable")>opener.</cfif>add_row('#BARCODE#','1','#attributes.product_name#');
			</cfoutput>	
		</cfif>	
	}
</script>

<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
