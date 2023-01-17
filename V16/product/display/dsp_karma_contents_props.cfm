<cf_xml_page_edit default_value="0" fuseact="product.popup_dsp_karma_contents">
    <cfscript>
        if (isnumeric(attributes.pid))
        {
            get_product_list_action = createObject("component", "V16.product.cfc.get_product");
            get_product_list_action.dsn1 = dsn1;
            get_product_list_action.dsn_alias = dsn_alias;
            GET_PRODUCT = get_product_list_action.get_product_
            (
                pid : attributes.pid
            );
        }
        else
        {
            get_product.recordcount = 0;
        }
    </cfscript>
    <cfset comp = createObject("component","V16.product.cfc.product_sample") />
    
    <cfparam name="attributes.property_collar_id" default="">
    <cfparam name="attributes.price_catid" default="">
    
    <cfparam name="attributes.price_catid_karma" default="">
    <cfsetting showdebugoutput="no">
    <cfinclude template="../../../JS/div_function.cfm">
    <cfquery name="get_product_is_karma" datasource="#dsn1#">
        SELECT IS_KARMA_SEVK FROM PRODUCT WHERE PRODUCT_ID = #attributes.pid#
    </cfquery>
    <cfquery name="get_money_product" datasource="#DSN1#">
        SELECT * FROM PRICE_STANDART WHERE PRICE_STANDART.PURCHASESALES = 1 AND PRICE_STANDART.PRICESTANDART_STATUS = 1 AND PRICE_STANDART.PRODUCT_ID = #attributes.pid# 
    </cfquery>
    <cfset recordnumber = 0>
    <cfset liste_para_birimi = get_money_product.money>
    <cfquery name="get_record_info" datasource="#DSN3#">
        SELECT 	
            TOP 1 RECORD_DATE, RECORD_EMP
        FROM
            KARMA_PRODUCTS_PRICE
        WHERE
            KARMA_PRODUCT_ID = #attributes.pid# AND RECORD_EMP IS NOT NULL
    </cfquery>
    <cfquery name="get_product_price_lists" datasource="#DSN3#">
        SELECT 	
            SUM(TOTAL_PRODUCT_PRICE) AS TOTAL_PRODUCT_PRICE,COUNT(TOTAL_PRODUCT_PRICE) AS TOPLAM_URUN,PRICE_CATID,START_DATE,FINISH_DATE,LIST_MONEY,PRICE_ID,PROCESS_STAGE
        FROM
            KARMA_PRODUCTS_PRICE
        WHERE
            KARMA_PRODUCT_ID = #attributes.pid# 
        GROUP BY
            PRICE_CATID,START_DATE,FINISH_DATE,LIST_MONEY,PRICE_ID,PROCESS_STAGE
        ORDER BY
            TOPLAM_URUN DESC
    </cfquery>
    <cfset module_name="product">
    <cfset var_="upd_purchase_basket">
    <cfinclude template="../../contract/query/get_moneys.cfm">
    <cfinclude template="../../contract/query/get_units.cfm">
    <cfinclude template="../query/get_unit.cfm">
    <cfquery name="get_price_cat" datasource="#DSN3#">
        SELECT PRICE_CAT,PRICE_CATID FROM PRICE_CAT
    </cfquery>
    <cfif isdefined('attributes.price_catid') and len(attributes.price_catid)>
    <cfquery name="get_price_cat_list_one" datasource="#DSN3#">
        SELECT PRICE_CAT,PRICE_CATID FROM PRICE_CAT  WHERE PRICE_CATID =#attributes.price_catid# ORDER BY PRICE_CATID
    </cfquery>
    </cfif>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cfform name="form_basket" method="post" action="#request.self#?fuseaction=product.emptypopup_upd_karma_contents&isCreateProduct=1">
            <input type="hidden" name="pid" id="pid" value="<cfoutput>#attributes.pid#</cfoutput>">
            <input type="hidden" name="price_row_count" id="price_row_count" value="4">
                <cfset attributes.karma_product_id = attributes.pid>
                <cfset attributes.karma_product_barcod = get_product.barcod>
                <cfset reference_catid = attributes.price_catid>
                <cfset attributes.price_catid = ''>
                <cfinclude template="../query/get_stocks_purchase.cfm">
                <cfset attributes.price_catid = reference_catid>
                <cf_box>
                    <cfif products.recordcount eq 0>
                        <p>
                            <strong><cf_get_lang dictionary_id='57425.Uyarı'>!</strong> <cf_get_lang dictionary_id='65389.Bu ürünün varyasyonları olmadığı için farklı ürünler seçerek karma koli oluşturabilirsiniz.'>
                        </p>
                        <cfinput type="hidden" name="price_catid" id="price_catid" value="-1">
                    <cfelse>
                        <cf_box_elements vertical="1">
                            <div class="form-group col col-3 col-md-3 col-sm-4 col-xs-12">
                                <label><cf_get_lang dictionary_id='112.Master Ürün'></label>
                                <div class="input-group">
                                    <input type="hidden" name="master_product_id" id="master_product_id" value="<cfoutput>#attributes.pid#</cfoutput>">
                                    <input type="text" name="master_product_name" id="master_product_name" value="<cfoutput>#get_product_name(attributes.pid)#</cfoutput>" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','','3','200');">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=form_basket.master_product_id&field_name=form_basket.master_product_name');"></span>
                                </div>
                            </div>
                            <div class="form-group col col-2 col-md-3 col-sm-3 col-xs-12" id="item-price_cat">							
                                <label><cf_get_lang dictionary_id='30108.Reference Price'></label>
                                <select name="price_catid" id="price_catid" onChange="change_price_cat(this.value)">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="-1"><cf_get_lang dictionary_id='37600.Standard Sales Price'></option> <!--- Ürünün standartından gelir --->
                                    <cfoutput query="get_price_cat">
                                        <option value="#PRICE_CATID#"<cfif attributes.price_catid eq PRICE_CATID> selected</cfif>>#PRICE_CAT#</option>
                                    </cfoutput>
                                </select>						
                            </div>
                            <div class="form-group col col-1 col-md-1 col-sm-1 col-xs-12" id="item-price_cat">	
                                <cfquery name="get_property" datasource="#dsn1#">
                                    SELECT 
                                        PRODUCT_PROPERTY.PROPERTY_ID,
                                        PRODUCT_PROPERTY.PROPERTY,
                                        PRODUCT_PROPERTY.PROPERTY_SIZE,
                                        PRODUCT_PROPERTY.PROPERTY_COLOR,
                                        PRODUCT_PROPERTY.PROPERTY_LEN,
                                        PRODUCT_PROPERTY.PROPERTY_COLLAR,
                                        PRODUCT_PROPERTY.PROPERTY_BODY_SIZE	
                        
                                    FROM 
                                        PRODUCT_CAT_PROPERTY,
                                        PRODUCT_PROPERTY,
                                        PRODUCT AS PRODUCT
                                    WHERE 
                                        PRODUCT_PROPERTY.PROPERTY_ID = PRODUCT_CAT_PROPERTY.PROPERTY_ID AND
                                        PRODUCT_CAT_PROPERTY.PRODUCT_CAT_ID = PRODUCT.PRODUCT_CATID AND
                                        PRODUCT.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
                                    <cfif isDefined("attributes.pcatid") and len(attributes.pcatid) >
                                        UNION
                                            SELECT 
                                                PRODUCT_PROPERTY.PROPERTY_ID,
                                                PRODUCT_PROPERTY.PROPERTY,
                                                PRODUCT_PROPERTY.PROPERTY_SIZE,
                                                PRODUCT_PROPERTY.PROPERTY_COLOR,
                                                PRODUCT_PROPERTY.PROPERTY_LEN,
                                                PRODUCT_PROPERTY.PROPERTY_COLLAR,
                                                PRODUCT_PROPERTY.PROPERTY_BODY_SIZE	
                            
                                            FROM 
                                                PRODUCT_CAT_PROPERTY 
                                                LEFT JOIN PRODUCT_PROPERTY ON PRODUCT_PROPERTY.PROPERTY_ID = PRODUCT_CAT_PROPERTY.PROPERTY_ID
                                                LEFT JOIN PRODUCT AS PRODUCT ON PRODUCT_CAT_PROPERTY.PRODUCT_CAT_ID = PRODUCT.PRODUCT_CATID
                                            WHERE 
                                                PRODUCT_CAT_PROPERTY.PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pcatid#">
                                    </cfif>
                                    UNION
                                        SELECT 
                                            PRODUCT_DT_PROPERTIES.PROPERTY_ID,
                                            PRODUCT_PROPERTY.PROPERTY,
                                            PRODUCT_PROPERTY.PROPERTY_SIZE,
                                            PRODUCT_PROPERTY.PROPERTY_COLOR,
                                            PRODUCT_PROPERTY.PROPERTY_LEN,
                                            PRODUCT_PROPERTY.PROPERTY_COLLAR,
                                            PRODUCT_PROPERTY.PROPERTY_BODY_SIZE	
                                        FROM 
                                            PRODUCT_DT_PROPERTIES,
                                            PRODUCT_PROPERTY
                                        WHERE
                                            PRODUCT_DT_PROPERTIES.PROPERTY_ID = PRODUCT_PROPERTY.PROPERTY_ID AND
                                            PRODUCT_DT_PROPERTIES.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
                                </cfquery>
                                <cfquery dbtype="query" name="get_collar_property">
                                    SELECT PROPERTY_ID,PROPERTY,PROPERTY_COLLAR FROM get_property  WHERE 1=1<cfif isdefined("xml_size_color")>and  PROPERTY_COLLAR = 1 </cfif>  <cfif isdefined("xml_is_color") and xml_is_color eq 1> AND PROPERTY_COLOR = 1</cfif>
                                </cfquery>
                                 <cfquery dbtype="query" name="get_size_property">
                                    SELECT PROPERTY_ID,PROPERTY,PROPERTY_COLLAR FROM get_property  WHERE 1=1<cfif isdefined("xml_size_color")>and  PROPERTY_COLLAR = 1 </cfif>  <cfif isdefined("xml_is_size") and xml_is_size eq 1> AND PROPERTY_SIZE = 1 OR PROPERTY_LEN = 1</cfif>
                                </cfquery>
                                <label><cfif isdefined("xml_is_color") and xml_is_color eq 1><cf_get_lang dictionary_id='48128.Renk'><cfelse><cf_get_lang dictionary_id='59107.Özellik'></cfif></label>
                                <select name="property_collar_id" id="property_collar_id" onchange="LoadVarition(this.value)">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_collar_property">	
                                        <option value="#property_id#" <cfif property_id eq attributes.property_collar_id>selected</cfif>>#property#</option>
                                    </cfoutput>
                                </select>
                            </div>
                            
                            <div class="form-group col col-2 col-md-3 col-sm-3 col-xs-12">
                                <label><cfif isdefined("xml_is_color") and xml_is_color eq 1><cf_get_lang dictionary_id='45854.Renk Seçeneği'><cfelse><cf_get_lang dictionary_id='37249.Varyasyon'></cfif></label>	
                                <select name="property_collar_det" id="property_collar_det">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                </select>
                            </div>  
                            <div class="form-group col col-1 col-md-1 col-sm-1 col-xs-12" id="item-property_size_id" >
                                <label><cfif isdefined("xml_is_size") and xml_is_size eq 1><cf_get_lang dictionary_id='37324.Beden'>-<cf_get_lang dictionary_id='99.Boy'><cfelse><cf_get_lang dictionary_id='59107.Özellik'>2</cfif></label>
                                <select name="property_size_id" id="property_size_id" onchange="Varition_(this.value)">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_size_property">	
                                        <option value="#property_id#" <cfif property_id eq attributes.property_collar_id>selected</cfif>>#property#</option>
                                    </cfoutput>
                                </select>	
                            </div> 
                            <div class="form-group col col-1 col-md-1 col-sm-1 col-xs-12" id="item-property_size_det" style="display:none" >    
                                <select name="property_size_det" id="property_size_det">
                                   
                                </select>
                            </div> 
                            <div class="form-group col col-2 col-md-3 col-sm-4 col-xs-12">
                                <label> &nbsp;</label>
                                <input type="button" id="target" class="ui-wrk-btn ui-wrk-btn-success" value="<cf_get_lang dictionary_id='65390.Yeni Ürün ve Karma Koli Oluştur'>" onclick="addMasterStocks()">
                            </div>
                        </cf_box_elements>
                    </cfif>                
                </cf_box>
               
                <cfoutput>
            <input type="hidden" name="selected_money" id="selected_money" value="#get_money_product.MONEY#">
            <input type="Hidden" name="var_" id="var_" value="#var_#">
            <input type="Hidden" name="module_name" id="module_name" value="#module_name#">
            <input type="Hidden" name="karma_product_id" id="karma_product_id" value="#attributes.pid#">
            <input type="Hidden" name="record_num" id="record_num" value="#recordnumber#">
            </cfoutput>
            
            <cfsavecontent variable="message"><cfoutput>#get_product_name(attributes.pid)#</cfoutput></cfsavecontent>
            <cf_box title="#message#" uidrop="1" hide_table_column="1">
                <cfsavecontent variable="head"><cf_get_lang dictionary_id='37707.Mixed Parcel Content'></cfsavecontent>
                <cf_seperator title="#head#" id="koli_content">
                <div id="koli_content">
                    <cf_grid_list>
                        <thead>
                            <tr>
                               
                                <!-- sil -->
                                <th width="20">
                                    <a href="javascript:openProducts();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
                                </th>
                                <!-- sil -->
                                <th width="20"><cf_get_lang dictionary_id='57487.No'></th>
                                <th width="100"><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                                <th ><cf_get_lang dictionary_id='57657.Ürün'><cf_get_lang dictionary_id='57629.Açıklama'></th>
                                <th width="130"><cf_get_lang dictionary_id='57647.Spec'></th>
                                <th width="70"  style="display:none" id="size_head"></th>
                                <th  width="70" style="display:none" id="collar_head"></th>
                                <th class="text-right" width="30"><cf_get_lang dictionary_id='57635.Miktar'></th>
                                <th width="50"><cf_get_lang dictionary_id='57636.Birim'></th>
                                <th class="text-right"  width="30"><cf_get_lang dictionary_id='58176.alış'> <cf_get_lang dictionary_id='57639.KDV'></th>
                                <th class="text-right"  width="30"><cf_get_lang dictionary_id='57448.satış'> <cf_get_lang dictionary_id='57639.KDV'></th>
                                <th class="text-right" width="70"><cf_get_lang dictionary_id='57636.Birim'> <cf_get_lang dictionary_id='58258.Maliyet'></th>
                                <th class="text-right" width="70"><cf_get_lang dictionary_id='37183.Ek Maliyet'></th>
                                <th class="text-right" width="70"><cf_get_lang dictionary_id='37419.Liste Fiyatı'></th>
                                <th class="text-right" width="70"><cf_get_lang dictionary_id='37248.Döviz Fiyat'></th>
                                <th  width="40"><cf_get_lang dictionary_id='57489.Para birimi'></th>
                                <th class="text-right"  width="70"><cf_get_lang dictionary_id='37042.Satış Fiyatı'></th>
                                <th class="text-center"  width="70"><cf_get_lang dictionary_id='37497.Toplam Maliyet'></th>
                                <th class="text-center" width="70"><cf_get_lang dictionary_id='57492.Toplam'> <cf_get_lang dictionary_id='37042.Satış Fiyatı'></th>
                            </tr>
                        </thead>
                        <tbody name="table1" id="table1">
                        </tbody>
                    </cf_grid_list>
                    <br>
                    <cf_box_elements>
                        <div class="ui-row">
                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                                <div class="form-group margin-bottom-10" id="item-is_karma_sevk">
                                    <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                                        <b><cf_get_lang dictionary_id='37605.Karma Koli İçeriğindeki Ürünler Hareket Etsin'>!</b>
                                        <input type="checkbox" name="is_karma_sevk" id="is_karma_sevk" value="1"<cfif get_product_is_karma.IS_KARMA_SEVK EQ 1>checked="checked"</cfif>>
                                        <label class="col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='51646.Bu seçeneğe tıkladığınızda basketli işlemlerde karma koli bileşenleri stokları işlem kategorisine göre hareket eder.'></label>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </cf_box_elements>
                    <cfsavecontent variable="head"><cf_get_lang dictionary_id='50453.Fiyat ve Maliyet'></cfsavecontent>
                    <cf_seperator title="#head#" id="price_body">
                    <div id="price_body">
                        <cf_box_elements vertical="1">
                            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="2" sort="true">
                                <div class="form-group col col-2 col-md-2 col-sm-2 col-xs-12" id="item-grosstotal_cost">
                                    <label><cf_get_lang dictionary_id='58258.Maliyet'></label>							
                                    <input type="text" name="grosstotal_cost" id="grosstotal_cost" class="text-right" value="<cfoutput><cfif isdefined('grosstotal_cost')>#TLFormat(grosstotal_cost,session.ep.our_company_info.sales_price_round_num)#<cfelse>0</cfif></cfoutput>" readonly>				            
                                </div> 
                                <div class="form-group col col-2 col-md-2 col-sm-2 col-xs-12" id="item-grosstotal_price">
                                    <label><cf_get_lang dictionary_id='48183.Satış Fiyatı'></label>
                                    <div class="input-group">
                                        <input type="text" name="grosstotal_price" id="grosstotal_price" class="text-right" value="<cfoutput><cfif isdefined('grosstotal_price') and grosstotal_price gt 0>#TLFormat(filterNum(grosstotal_price,session.ep.our_company_info.sales_price_round_num),session.ep.our_company_info.sales_price_round_num)#<cfelse>0</cfif></cfoutput>" readonly>
                                        <span class="input-group-addon width">
                                            <select name="price_money" id="price_money" onChange="calculate_grosstotal(this.value);">
                                                <cfloop query="GET_MONEYS">
                                                    <cfoutput><option value="#MONEY#" <cfif get_money_product.money eq MONEY>selected</cfif>>#MONEY#</option></cfoutput>
                                                </cfloop>
                                            </select>
                                        </span>
                                    </div>			
                                </div>						
                                <div class="form-group col col-2 col-md-3 col-sm-3 col-xs-12" id="item-price_cats">							
                                    <label><cf_get_lang dictionary_id='61708.Price Category'></label>
                                    <select name="price_catid_karma" id="price_catid_karma">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <option value="-1" ><cf_get_lang dictionary_id='37600.Standard Sales Price'></option> <!--- Ürünün standartından gelir --->
                                        <cfoutput query="get_price_cat">
                                            <option value="#PRICE_CATID#">#PRICE_CAT#</option>
                                        </cfoutput>
                                    </select>						
                                </div>
                                <div class="form-group col col-2 col-md-2 col-sm-2 col-xs-12" id="item-start_date">
                                    <label><cf_get_lang dictionary_id='58053.Baslangic Tarihi'>*</label>
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58745.Başlama Tarihi Girmelisiniz '>!</cfsavecontent>
                                            <input required="Yes" message="<cfoutput>#message#</cfoutput>" type="text" name="start_date" id="start_date" style="width:65px;" value="">
                                            <span class="input-group-addon btn_Pointer"><cf_wrk_date_image date_field="start_date"></span>
                                        </div>
                                    </div>
                                    <cfoutput>
                                        <div class="col col-3 col-md-3 col-sm-3 col-xs-6">
                                            <select name="start_h" id="start_h">
                                                <cfloop from="0" to="23" index="i">
                                                    <option value="#i#"><cfif i lt 10>0</cfif><cfoutput>#i#</cfoutput></option>
                                                </cfloop>
                                            </select>
                                        </div>
                                        <div class="col col-3 col-md-3 col-sm-3 col-xs-6">
                                            <select name="start_m" id="start_m">
                                                <cfloop from="0" to="59" index="i">
                                                    <option value="#i#"><cfif i lt 10>0</cfif><cfoutput>#i#</cfoutput></option>
                                                </cfloop>
                                            </select>
                                        </div>
                                    </cfoutput>					
                                </div>
                                <div class="form-group col col-2 col-md-2 col-sm-2 col-xs-12" id="item-finish_date">
                                    <label>	<cf_get_lang dictionary_id='57700.Bitis Tarihi'></label>
                                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                        <div class="input-group">
                                            <cfoutput>
                                                <input  type="text" name="finish_date" id="finish_date" value="" validate="#validate_style#" style="width:65px;">
                                            </cfoutput>
                                            <span class="input-group-addon btn_Pointer"><cf_wrk_date_image date_field="finish_date"></span>
                                        </div>
                                    </div>
                                    <cfoutput>
                                        <div class="col col-3 col-md-3 col-sm-3 col-xs-6">
                                            <select name="finish_h" id="finish_h">
                                                <cfloop from="0" to="23" index="i">
                                                    <option value="#i#"><cfif i lt 10>0</cfif>#i#</option>
                                                </cfloop>
                                            </select>
                                        </div>
                                        <div class="col col-3 col-md-3 col-sm-3 col-xs-6">
                                            <select name="finish_m" id="finish_m">
                                                <cfloop from="0" to="59" index="i">
                                                    <option value="#i#"><cfif i lt 10>0</cfif>#i#</option>
                                                </cfloop>
                                            </select>
                                        </div>
                                    </cfoutput>			
                                </div>
                                <div class="form-group col col-2 col-md-2 col-sm-2 col-xs-12" id="item-process_stage">
                                    <label><cf_get_lang dictionary_id="58859.Süreç"></label>
                                    <cf_workcube_process 
                                        is_upd='0' 
                                        process_cat_width='140' 
                                        is_detail='0'>
                                </div>
                                
                            </div>
                        </cf_box_elements>
                    </div>
                </div>
                <cfsavecontent variable="head"><cf_get_lang dictionary_id='48312.Koli'> - <cf_get_lang dictionary_id='57636.Birim'> - <cf_get_lang dictionary_id='36590.Paket Bilgisi'></cfsavecontent>
                <cf_seperator title="#head#" id="unit_body">
                <div id="unit_body">
                    <cfquery name="GET_PRODUCT_UNIT" datasource="#DSN3#">
                        SELECT 
                            PRODUCT_UNIT_ID, 
                            CASE
                                WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
                                ELSE ADD_UNIT
                            END AS ADD_UNIT,
                            IS_MAIN,
                            UNIT_ID,
                            MULTIPLIER,
                            QUANTITY,
                            DIMENTION, 
                            VOLUME, 
                            WEIGHT,
                            UNIT_MULTIPLIER, 
                            UNIT_MULTIPLIER_STATIC, 
                            IS_SHIP_UNIT, 
                            IS_ADD_UNIT,
                            CASE
                                WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
                                ELSE MAIN_UNIT
                            END AS MAIN_UNIT, 
                            MAIN_UNIT_ID,
                            PACKAGES,
                            PATH,
                            PACKAGE_CONTROL_TYPE,
                            INSTRUCTION 
                        FROM 
                            PRODUCT_UNIT 
                                LEFT JOIN #DSN#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = PRODUCT_UNIT.UNIT_ID
                                AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="UNIT">
                                AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_UNIT">
                                AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
                        WHERE 
                            PRODUCT_UNIT_ID = (SELECT TOP(1) PRODUCT_UNIT_ID FROM PRODUCT_UNIT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND PRODUCT_UNIT_STATUS = 1)
                        ORDER BY 
                            ADD_UNIT
                    </cfquery>
                    <cf_box_elements>                    
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">                
                            <input type="hidden" name="product_unit_id" id="product_unit_id" value="<cfoutput>#get_product_unit.product_unit_id#</cfoutput>">
                            <input type="hidden" name="main_unit" id="main_unit" value="<cfoutput>#get_product_unit.main_unit#</cfoutput>">
                            <input type="hidden" name="main_unit_id" id="main_unit_id" value="<cfoutput>#get_product_unit.main_unit_id#</cfoutput>">
                            <input type="hidden" name="product_id" id="product_id" value="<cfoutput>#get_product.product_id#</cfoutput>">
                            <input type="hidden" name="unit_id_" id="unit_id_" value="<cfoutput>#get_product_unit.unit_id#</cfoutput>">
                            <!--- <div class="form-group">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                                <label class="col col-8 col-md-8 col-sm-8 col-xs-12 txtbold"><cfoutput>#get_product.product_name#</cfoutput></label>
                            </div> --->
                            <div class="form-group">
                                <label class="col col-4"><cf_get_lang dictionary_id='57657.Ürün'> - <cf_get_lang dictionary_id='65421.Koli Açıklama'>*</label>
                                <div class="col col-8">
                                    <div class="input-group">
                                        <cfinput type="text" name="karma_product_name" id="karma_product_name" value="" required="yes">
                                        <span class="input-group-addon btnPointer" onclick="createName()"><i class="fa fa-plus"></i></span>
                                    </div>
                                </div>                        
                            </div>
                            <cfif get_product_unit.is_main neq 1>
                                <div class="form-group">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37166.Ana Birim'></label>
                                    <label class="col col-8 col-md-8 col-sm-8 col-xs-12 txtbold"><cfoutput>#get_product_unit.main_unit#</cfoutput></label>
                                </div>
                            <cfelse>
                                <div class="form-group">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37166.Ana Birim'></label>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                        <select name="main_unit" id="main_unit" onchange="mess();">
                                            <cfoutput query="get_unit">
                                                <option value="#unit_id#,#unit#" <cfif get_product_unit.main_unit is unit> selected</cfif>>#unit#</option>
                                            </cfoutput>
                                        </select>
                                        <input type="hidden" name="old_main_unit" id="old_main_unit" value="<cfoutput>#get_product_unit.main_unit#</cfoutput>">
                                    </div>
                                </div>
                            </cfif>                
                            <cfif get_product_unit.is_main neq 1>
                                <div class="form-group">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37186.Ek Birim'></label>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                        <select name="add_unit" id="add_unit">
                                            <cfoutput query="get_unit">
                                                <cfif get_product_unit.main_unit_id neq get_unit.unit_id>
                                                    <option value="#unit_id#,#unit#" <cfif get_product_unit.add_unit is unit> selected</cfif>>#unit#</option>
                                                </cfif>
                                            </cfoutput>
                                        </select>
                                    </div>
                                </div>
                            </cfif>
                            <cfif get_product_unit.is_main neq 1>
                                <cfif xml_select_amount eq 1>
                                    <div class="form-group">
                                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57635.Miktar'></label>
                                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                            <cfif len(get_product_unit.quantity)>
                                                <cfset amount_new_ = wrk_round(get_product_unit.quantity,8,1)>
                                            <cfelse>
                                                <cfset amount_new_ = wrk_round(get_product_unit.multiplier,8,1)>
                                            </cfif>
                                            <cfinput type="text" name="quantity" id="quantity" value="#tlformat(amount_new_,xml_quantity_round)#" onBlur="hesapla_amount();" required="Yes" onkeyup="FormatCurrency(this,event,#xml_quantity_round#)" class="moneybox">
                                        </div>
                                    </div>
                                </cfif>
                                <div class="form-group">
                                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58865.Çarpan'></label>
                                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='37433.Çarpan girmelisiniz'></cfsavecontent>
                                            <cfset amount_new = wrk_round(get_product_unit.multiplier,8,1)>
                                            <cfinput type="text" name="multiplier" id="multiplier" required="Yes" onkeyup="FormatCurrency(this,event,4)" message="#message#" value="#tlformat(amount_new,4)#" class="moneybox">
                                            <span class="input-group-addon bold">*<cfoutput>#get_product_unit.main_unit#</cfoutput></span>
                                        </div>
                                    </div>
                                </div>
                            </cfif>
                                <div class="form-group">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57713.Boyut'> (<cf_get_lang dictionary_id='29703.cm'>)</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <div class="input-group">
                                        <cfinput type="text" name="dimention" id="dimention" value="#get_product_unit.dimention#" onBlur="return volume_calculate();">
                                        <span class="input-group-addon bold">a*b*h</span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="30114.Hacim"></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <div class="input-group">
                                        <cfinput type="text" name="volume" id="volume" value="#get_product_unit.volume#">
                                        <span class="input-group-addon bold"><cf_get_lang dictionary_id='37318.cm3'></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29784.Ağırlık'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <div class="input-group">
                                        <cfinput type="text" name="weight" id="weight" value="#tlformat(get_product_unit.weight,8)#" onkeyup="FormatCurrency(this,event,8)" class="moneybox">
                                        <span class="input-group-addon bold"><cf_get_lang dictionary_id='37188.kg'></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37612.Birim Çarpanı'></label>
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <cfinput type="text" name="unit_multiplier" id="unit_multiplier" value="#tlformat(get_product_unit.unit_multiplier,4)#" onkeyup="FormatCurrency(this,event,4)" class="moneybox">
                                </div><!--- maxlength="6" kaldirildi, ondalik hane degisebilir --->
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12"> 
                                    <select name="multiplier_static" id="multiplier_static">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <option value="1"<cfif get_product_unit.unit_multiplier_static eq 1> selected</cfif>><cf_get_lang dictionary_id='37613.Litre'></option>
                                        <option value="2"<cfif get_product_unit.unit_multiplier_static eq 2> selected</cfif>><cf_get_lang dictionary_id='37188.kg'></option>
                                        <option value="3"<cfif get_product_unit.unit_multiplier_static eq 3> selected</cfif>><cf_get_lang dictionary_id='58082.Adet'></option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-6 col-md-6 col-sm-6 col-xs-12"> 2.<cf_get_lang dictionary_id="57636.Birim"><input type="checkbox" name="is_add_unit" id="is_add_unit" <cfif get_product_unit.is_add_unit eq 1> checked</cfif> value="1"></label>
                                <label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='37859.Bu Birim İle Sevk Edilir'><input type="checkbox" name="is_ship_unit" id="is_ship_unit" <cfif get_product_unit.is_ship_unit eq 1> checked</cfif>></label>						
                            </div>
                        </div>
                        <div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="2" sort="true">
                            <div class="form-group">
                                <label class="col col-5"><cf_get_lang dictionary_id='57633.Barkod'> <cfif isdefined('is_barcode_required') and is_barcode_required eq 1>*</cfif></label>
                                <div class="col col-7">
                                    <div class="input-group">
                                        <cfinput type="text" name="barcod" id="barcod" value="" onKeyUp="barcod_control()">
                                        <span class="input-group-addon btnPointer" onclick="javascript:document.form_basket.barcod.value='<cfoutput>#get_barcode_no(1)#</cfoutput>'" title="<cf_get_lang dictionary_id='37940.Otomatik barkod'> !"><i class="fa fa-plus"></i></span>
                                    </div>
                                </div>                        
                            </div>
                            <div class="form-group" id="item-package">
                                <label class="col col-5 col-md-5 col-sm-5 col-xs-12"><cf_get_lang dictionary_id='34799.Paket Tipi'></label>  
                                <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                    <cfquery name="PACKAGES" datasource="#dsn#">
                                        SELECT 
                                            PACKAGE_TYPE_ID, 
                                            PACKAGE_TYPE
                                        FROM 
                                            SETUP_PACKAGE_TYPE
                                    </cfquery>
                                    <select name="packages" id="packages" >
                                        <option value=""><cf_get_lang dictionary_id="57734.seçiniz"></option>
                                        <cfoutput query="PACKAGES">
                                            <option value="#PACKAGE_TYPE_ID#" <cfif get_product_unit.PACKAGES eq package_type_id>selected</cfif>>#PACKAGE_TYPE#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div> 
                        <input type="hidden" name="master_code" id="master_code" value="<cfif isdefined('is_change_code') and is_change_code eq 1 and len(get_product_unit.PACKAGES)><cfoutput>#get_product.product_code#-#get_product_unit.PACKAGES#</cfoutput></cfif>">
                            <div class="form-group" id="item-package_control_type">
                                <label class="col col-5 col-md-5 col-sm-5 col-xs-12"><cf_get_lang dictionary_id ='37768.Paket Kontrol Tipi'></label>
                                <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                    <select name="package_control_type" id="package_control_type">
                                        <option value="1" <cfif get_product_unit.package_control_type eq 1> selected</cfif>><cf_get_lang dictionary_id ='40429.Kendisi'></option>
                                        <option value="2" <cfif get_product_unit.package_control_type eq 2> selected</cfif>><cf_get_lang dictionary_id ='37770.Bileşenleri'></option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-instruction">
                                <label class="col col-5 col-md-5 col-sm-5 col-xs-12"><cf_get_lang dictionary_id='45222.Paketleme ve Taşıma Talimatı'></label>  
                                <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                    <input type="text" name="instruction" id="instruction" value="<cfoutput>#get_product_unit.INSTRUCTION#</cfoutput>" >
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-5 col-md-5 col-sm-5 col-xs-12"><cf_get_lang dictionary_id='42647.Etiket Şablonu'></label>
                                <div class="col col-7 col-md-7 col-sm-7 col-xs-12"><input type="File" name="image_file" id="image_file"/></div>
                            </div>
                            <div class="form-group">
                                <label class="col col-5 col-md-5 col-sm-5 col-xs-12"></label>
                                <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
                                    <input type="hidden" name="old_image_file" id="old_image_file" value="<cfoutput>#get_product_unit.path#</cfoutput>">
                                    <cfoutput>#get_product_unit.path#</cfoutput></div>
                            </div>
                        </div>
                    </cf_box_elements>
                </div>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <cf_box_footer>
                        <cf_record_info query_name="get_record_info" record_emp="RECORD_EMP">
                        <cf_workcube_buttons type_format='1' is_upd='0' is_cancel='0' add_function='controlForm()'>
                    </cf_box_footer>
                </div>
            </cf_box>
        </cfform>
    </div>
    <cfsavecontent variable="delete_alert"><cf_get_lang dictionary_id='57533.Silmek Istediginizden Emin Misiniz'></cfsavecontent>
    <script type="text/javascript">
        function LoadVarition(id) {
            $.ajax({
              url: '/V16/product/cfc/product_sample.cfc?method=getCollarProperty&prop_id=' + id,
              success: function(data) {
                if(data)
                {
                    $('#property_collar_det'+" option[value!='']").remove();
                    data = $.parseJSON( data );
                    for(i=0;i<data.DATA.length;i++)
                    {
                        var option = $('<option/>');
                        option.attr({ 'value': data.DATA[i][0] + '-' + data.DATA[i][1]}).text(data.DATA[i][1]);
                        $('#property_collar_det').append(option);
                    }
                }
              }
           });
        }
        function Varition_(id) {
            $.ajax({
              url: '/V16/product/cfc/product_sample.cfc?method=getCollarProperty&prop_id=' + id,
              success: function(data) {
                if(data)
                {
                    $('#property_size_det'+" option[value!='']").remove();
                    data = $.parseJSON( data );
                    var size_=[];
                    for(i=0;i<data.DATA.length;i++)
                    {
                        var option = $('<option/>');
                        option.attr({ 'value':    data.DATA[i][1]}).text(data.DATA[i][1]);
                        $('#property_size_det').append(option);
                        size_.push(data.DATA[i][1] );
                    }
                }
              }
           });
        }
        function test()
        {
            
            sql = "SELECT PDP.PROPERTY_ID,PP.PROPERTY FROM PRODUCT_DT_PROPERTIES PDP,PRODUCT_PROPERTY PP WHERE PDP.PROPERTY_ID = PP.PROPERTY_ID AND PDP.PRODUCT_ID=" + $('#product_id').val() ;
            get_product = wrk_query(sql,'DSN1');
            $('#prod_detail').empty();
            
            $('#prod_detail').append('<option value="">Seçiniz</option>');
            for ( var i = 0; i < get_product.recordcount; i++ ) {
                $("#prod_detail").append('<option value='+get_product.PROPERTY_ID[i]+'>'+get_product.PROPERTY[i]+'</option>');
            }
        }
        function warningCost(){
            $("input[id*=p_price_hidden]").each(function(){
                if($(this).val() <= 0)
                    $(this).parent().parent().find("input").css("color","#ff0000");
                else
                    $(this).parent().parent().find("input").css("color","#008000");
    
            });
            $("input[id*=s_price]").each(function(){
                if($(this).val() == "" || $(this).val() == 0)
                    $(this).css("color","#ff0000");
            });
            $("input[id*=total_product_cost]").each(function(){
                if($(this).val() == "" || $(this).val() == 0)
                    $(this).css("color","#ff0000");
            });
        }
        $(document).ready(function(){
            $("#prod_detail").change(function(){
                sql = "SELECT PPD.PROPERTY_DETAIL_ID,PPD.PROPERTY_DETAIL FROM PRODUCT_PROPERTY PP,PRODUCT_PROPERTY_DETAIL PPD,PRODUCT_DT_PROPERTIES PDTP WHERE PP.PROPERTY_ID = PPD.PRPT_ID AND PDTP.PROPERTY_ID = PP.PROPERTY_ID AND PDTP.PRODUCT_ID="+  $('#product_id').val() +"AND PP.PROPERTY_ID =  " + document.getElementById('prod_detail').value +"AND PPD.PROPERTY_DETAIL_ID IN (SELECT PROPERTY_DETAIL_ID FROM STOCKS_PROPERTY WHERE STOCK_ID IN (SELECT STOCK_ID  FROM STOCKS WHERE PRODUCT_ID="+$('#product_id').val()+"))" ;
                get_varyasyon = wrk_query(sql,'DSN1');
                $('#prod_varyasyon').empty();
                $('#prod_varyasyon').append('<option value="">Seçiniz</option>');
                for ( var i = 0; i < get_varyasyon.recordcount; i++ ) {
                    $("#prod_varyasyon").append('<option value='+get_varyasyon.PROPERTY_DETAIL_ID[i]+'>'+get_varyasyon.PROPERTY_DETAIL[i]+'</option>');
                }
        
            });
            warningCost();
            $("#prod_varyasyon").change(function(){
                pricelist($('#product_id').val());
                });
            
            });		
            
        
        
        function open_spec_page(row)
        {
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_main_id=form_basket.spec_main_id'+row+'&field_name=form_basket.spec_name'+row+'&is_display=1&stock_id='+document.getElementById('stock_id'+row).value,'list');
        }
        row_count=<cfoutput>#recordnumber#</cfoutput>;
        satir_count = 0;
        if('<cfoutput>#liste_para_birimi#</cfoutput>' != undefined)calculate_grosstotal(<cfoutput>'#liste_para_birimi#'</cfoutput>);
        function sil(sy)
        {
            if(confirm('<cfoutput>#delete_alert#</cfoutput>')){
                var is_liste_fiyat = 0;
                if (is_liste_fiyat == "" || is_liste_fiyat == 0)
                {
                    var my_element=eval("form_basket.row_kontrol"+sy);
                    my_element.value=0;
                    var my_element=eval("frm_row"+sy);
                    my_element.style.display="none";
                    calculate_grosstotal(document.form_basket.selected_money.value);
                    
                    //$(my_element).parents('input').remove();
                    $("#product_id" + sy).remove();//#79263 işi için kullanılıyor.Silme
                    $("#property_id" + sy).remove();//#79263 işi için kullanılıyor.Silme
                    $("#property_detail_id" + sy).remove();//#79263 işi için kullanılıyor.Silme
                    
                    
                }
                else
                alert("<cf_get_lang dictionary_id ='37785.Ürün Silmek İçin Öncelikle Liste Fiyatlarını Siliniz'>.");
            }	
        }
        function clearSpecM(row){
            if(document.getElementById('spec_name'+row).value =="")
                document.getElementById('spec_main_id'+row).value ="";
        }
    
        function add_row(stockid,stockprop,sirano,product_id,product_name,stock_code,property,manufact_code,tax,tax_purchase,add_unit,product_unit_id,money,is_serial_no,discount1,discount2,discount3,discount4,discount5,discount6,discount7,discount8,discount9,discount10,del_date_no,p_price,s_price,product_cost,extra_product_cost,is_production,list_price,other_list_price,spec_main_id,spec_main_name,assortment_default_amount)
        {
            if($('#property_collar_det').val() != ''  &&  $('#property_collar_id').val() != ''&& $('#property_size_id').val() != ''){
                var property_size = $('#property_collar_det').val().split('-')[1]  == property.split('.')[0] ?  property.split('.')[1] : property.split('.')[0]
                var property_collar = $('#property_collar_det').val().split('-')[1] 
                var property_=[]
                property_.push(property);
                var size_=[];
                $('#property_size_det option').each(function() {
                    size_.push($(this).val())
                    });
                if(size_.includes(property.split('.')[0]) == true ){
                    if($('#property_collar_det').val() != ''  &&  $('#property_collar_id').val() != ''){
                        var collar_option = document.getElementById('property_collar_id');
                        $('#collar_head').html(collar_option.options[collar_option.selectedIndex].text);
                        $('#collar_head').show();
                        }
                        if($('#property_size_id').val() != ''  ){
                            var size_option = document.getElementById('property_size_id');
                            $('#size_head').html(size_option.options[size_option.selectedIndex].text);
                            $('#size_head').show();
                            
                        }
                                
                    row_count++;
                    var newRow;
                    var newCell;
                    newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
                    newRow.className = 'color-row';
                    newRow.setAttribute("name","frm_row" + row_count);
                    newRow.setAttribute("id","frm_row" + row_count);
                    newRow.setAttribute("NAME","frm_row" + row_count);
                    newRow.setAttribute("ID","frm_row" + row_count);
                    document.form_basket.record_num.value=row_count;
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.setAttribute('nowrap','nowrap');
                    newCell.innerHTML='<a style="cursor:pointer" onclick="sil('+row_count+');"><i class="fa fa-minus"></i></a>';
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.setAttribute('nowrap','nowrap');
                    newCell.innerHTML=row_count;
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.setAttribute('nowrap','nowrap');
                    newCell.innerHTML='<div class="form-group"><input type="text" name="stock_code_'+row_count+'" id="stock_code_'+row_count+'" value="'+stock_code+'"  readonly> </div>';
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.setAttribute('nowrap','nowrap');
                    newCell.innerHTML = '<input type="hidden" value="1" id="row_kontrol'+row_count+'" name="row_kontrol'+row_count+'">';
                    newCell.innerHTML = newCell.innerHTML + '<input type="Hidden" id="stock_id'+row_count+'" name="stock_id'+row_count+'" value="' + stockid + '">';
                    newCell.innerHTML = newCell.innerHTML + '<input type="hidden" id="product_id'+row_count+'" name="product_id'+row_count+'" value="'+product_id+'">';
                    newCell.innerHTML = newCell.innerHTML + '<input type="hidden" id="unit_id'+row_count+'" name="unit_id'+row_count+'" value="'+product_unit_id+'">';
                    newCell.innerHTML = newCell.innerHTML + '<div class="form-group"><div class="input-group"><input type="text" name="product_name' + row_count + '" id="product_name' + row_count + '" style="width:150px;"  value="'+product_name+' - '+property+'"><span class="input-group-addon icon-ellipsis btnPointer" onClick="pencere_ac('+product_id+');"></span></div></div>';
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.setAttribute('nowrap','nowrap');
                    newCell.innerHTML = '<div class="form-group"><div class="col col-3"><input type="text" id="spec_main_id'+row_count+'" name="spec_main_id'+row_count+'" title="Spec Main ID" value="'+spec_main_id+'" style="width:35px;" readonly></div><div class="col col-9"><div class="input-group"> <input type="text" style="width:100px;" id="spec_name'+row_count+'" name="spec_name'+row_count+'" value="'+spec_main_name+'" onChange="clearSpecM('+row_count+')"> <span class="input-group-addon icon-ellipsis btnPointer" onClick="open_spec_page('+row_count+');"></span></div></div></div>';
                    newCell = newRow.insertCell(newRow.cells.length);//Özellik 1
                    newCell.setAttribute('nowrap','nowrap');
                    newCell.innerHTML = '<div class="form-group"><input type="text"  id="property_1_'+row_count+'" name="property_1_'+row_count+'" value="'+property_size+'"></div>';
                    newCell = newRow.insertCell(newRow.cells.length);//Özellik 2
                    newCell.setAttribute('nowrap','nowrap');
                    newCell.innerHTML = '<div class="form-group"><input type="text"  id="property_2_'+row_count+'" name="property_2_'+row_count+'" value="'+property_collar+'"></div>';
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.innerHTML = '<div class="form-group"><input type="text" class="moneybox" name="row_amount' + row_count + '" id="row_amount' + row_count + '" value="'+assortment_default_amount+'" onBlur="calculate_amount(' + row_count + ');"></div>';
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.setAttribute('nowrap','nowrap');
                    newCell.innerHTML = '<input type="hidden" style="display:none" name="manufact_code' + row_count + '" value="'+manufact_code+'">';
                    newCell.innerHTML = newCell.innerHTML + '<div class="form-group"><input type="text" id="unit' + row_count + '" name="unit' + row_count + '"  readonly value="' + add_unit + '"></div>';
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.setAttribute('nowrap','nowrap');
                    newCell.innerHTML = '<div class="form-group"><input class="moneybox" type="text" id="tax_purchase' + row_count + '" name="tax_purchase' + row_count + '" value="' + commaSplit(tax_purchase,0) + '"style="width:100%;" readonly="yes"></div>';
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.setAttribute('nowrap','nowrap');
                    newCell.innerHTML = '<div class="form-group"><input class="moneybox" type="text" name="tax' + row_count + '" id="tax' + row_count + '"  value="' + commaSplit(tax,0) + '" readonly="yes" ></div>';
                    newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="action_profit_margin' + row_count + '" id="action_profit_margin' + row_count + '"  value="0">';
                    /*newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="action_price' + row_count + '" >';*/
                    newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="duedate' + row_count + '" id="duedate' + row_count + '"  value="0">';
                    newCell.innerHTML = newCell.innerHTML + '<input type="hidden"  name="shelf_id' + row_count + '"><input type="hidden" name="shelf_name' + row_count + '" value="">';
                    newCell = newRow.insertCell(newRow.cells.length);//birim maliyet
                    newCell.innerHTML = newCell.innerHTML + '<div class="form-group"><input class="moneybox" type="text" readonly="readonly" id="products_cost'+row_count+'" name="products_cost'+row_count+'" value="' + commaSplit(product_cost,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>) + '"></div>';
                    newCell = newRow.insertCell(newRow.cells.length);//Ek maliyet
                    newCell.innerHTML = newCell.innerHTML + '<div class="form-group"><input class="moneybox" type="text" readonly="readonly" id="extra_product_cost'+row_count+'" name="extra_product_cost'+row_count+'" value="' + commaSplit(extra_product_cost,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>) + '"></div>';//ek maliyet
                    newCell = newRow.insertCell(newRow.cells.length);//Liste Fiyatı
                    newCell.innerHTML = newCell.innerHTML + '<div class="form-group"><input class="moneybox" type="text" readonly="readonly" id="list_price'+row_count+'" name="list_price'+row_count+'" value="' + commaSplit(list_price,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>) + '"></div>';
                    newCell = newRow.insertCell(newRow.cells.length);//Döviz Liste Fiyatı
                    newCell.innerHTML = newCell.innerHTML + '<div class="form-group"><input class="moneybox" type="text" onKeyUp="hesapla_row(1,'+row_count+');" id="other_list_price'+row_count+'" name="other_list_price'+row_count+'" value="' + commaSplit(other_list_price,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>) + '"></div>';
                    newCell = newRow.insertCell(newRow.cells.length);//Para birimi
                    c = '<div class="form-group"><select name="money' + row_count  +'" id="money' + row_count  +'" onChange="hesapla_row(1,'+row_count+');">';
                        <cfoutput query="get_moneys">
                        if('#money#' == money)
                            c += '<option value="#money#;#rate2#" selected>#money#</option>';
                        else
                            c += '<option value="#money#;#rate2#">#money#</option>';
                        </cfoutput>
                        newCell.innerHTML =c+ '</select></div>';
                    newCell = newRow.insertCell(newRow.cells.length);//Satış Fiyatı
                    newCell.setAttribute('nowrap','nowrap');
                    newCell.innerHTML = '<div class="form-group"><div class="input-group"><input class="moneybox" type="text" id="s_price' + row_count + '" name="s_price' + row_count + '" onKeyUp="hesapla_row(3,'+row_count+');"  value="' + commaSplit(s_price,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>) + '"  style="width:80px;" onBlur="if(this.value==\'\')this.value=0;calculate_amount(' + row_count + ');"><span class="input-group-addon icon-ellipsis btnPointer" onclick="open_price(' + row_count + ');"></span><input type="hidden" name="p_price' + row_count + '" value="' + commaSplit(p_price,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>) + '"><input type="hidden" name="profit_margin' + row_count + '" value="0"></div></div>';
                    
                    newCell = newRow.insertCell(newRow.cells.length);//Toplam Maliyet
                    newCell.innerHTML = '<div class="form-group"><input  class="moneybox" type="text" name="total_product_cost' + row_count + '" id="total_product_cost' + row_count + '" readonly value="1" onBlur="calculate_amount(' + row_count + ');"></div><input type="hidden" value="" name="p_price_hidden' + row_count + '" id="p_price_hidden' + row_count + '">';
                    newCell = newRow.insertCell(newRow.cells.length);//Toplam satış fiyatı
                    newCell.innerHTML = '<div class="form-group"><input  class="moneybox" type="text" name="total_product_price' + row_count + '" id="total_product_price' + row_count + '"readonly value="1" onBlur="calculate_amount(' + row_count + ');"></div>';
                    
                    calculate_amount(row_count);
                    $("#p_price_hidden"+row_count).val(parseFloat($("#s_price"+row_count).val())-parseFloat($("#total_product_cost"+row_count).val()));
                    warningCost();
                }
            }
            else if($('#property_collar_det').val() == ''  &&  $('#property_collar_id').val() == ''&& $('#property_size_id').val() == ''){
                row_count++;
                    var newRow;
                    var newCell;
                    newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
                    newRow.className = 'color-row';
                    newRow.setAttribute("name","frm_row" + row_count);
                    newRow.setAttribute("id","frm_row" + row_count);
                    newRow.setAttribute("NAME","frm_row" + row_count);
                    newRow.setAttribute("ID","frm_row" + row_count);
                    document.form_basket.record_num.value=row_count;
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.setAttribute('nowrap','nowrap');
                    newCell.innerHTML='<a style="cursor:pointer" onclick="sil('+row_count+');"><i class="fa fa-minus"></i></a>';
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.setAttribute('nowrap','nowrap');
                    newCell.innerHTML=row_count;
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.setAttribute('nowrap','nowrap');
                    newCell.innerHTML='<div class="form-group"><input type="text" name="stock_code_'+row_count+'" id="stock_code_'+row_count+'" value="'+stock_code+'"  readonly> </div>';
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.setAttribute('nowrap','nowrap');
                    newCell.innerHTML = '<input type="hidden" value="1" id="row_kontrol'+row_count+'" name="row_kontrol'+row_count+'">';
                    newCell.innerHTML = newCell.innerHTML + '<input type="Hidden" id="stock_id'+row_count+'" name="stock_id'+row_count+'" value="' + stockid + '">';
                    newCell.innerHTML = newCell.innerHTML + '<input type="hidden" id="product_id'+row_count+'" name="product_id'+row_count+'" value="'+product_id+'">';
                    newCell.innerHTML = newCell.innerHTML + '<input type="hidden" id="unit_id'+row_count+'" name="unit_id'+row_count+'" value="'+product_unit_id+'">';
                    newCell.innerHTML = newCell.innerHTML + '<div class="form-group"><div class="input-group"><input type="text" name="product_name' + row_count + '" id="product_name' + row_count + '" style="width:150px;"  value="'+product_name+' - '+property+'"><span class="input-group-addon icon-ellipsis btnPointer" onClick="pencere_ac('+product_id+');"></span></div></div>';
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.setAttribute('nowrap','nowrap');
                    newCell.innerHTML = '<div class="form-group"><div class="col col-3"><input type="text" id="spec_main_id'+row_count+'" name="spec_main_id'+row_count+'" title="Spec Main ID" value="'+spec_main_id+'" style="width:35px;" readonly></div><div class="col col-9"><div class="input-group"> <input type="text" style="width:100px;" id="spec_name'+row_count+'" name="spec_name'+row_count+'" value="'+spec_main_name+'" onChange="clearSpecM('+row_count+')"> <span class="input-group-addon icon-ellipsis btnPointer" onClick="open_spec_page('+row_count+');"></span></div></div></div>';
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.innerHTML = '<div class="form-group"><input type="text" class="moneybox" name="row_amount' + row_count + '" id="row_amount' + row_count + '" value="'+assortment_default_amount+'" onBlur="calculate_amount(' + row_count + ');"></div>';
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.setAttribute('nowrap','nowrap');
                    newCell.innerHTML = '<input type="hidden" style="display:none" name="manufact_code' + row_count + '" value="'+manufact_code+'">';
                    newCell.innerHTML = newCell.innerHTML + '<div class="form-group"><input type="text" id="unit' + row_count + '" name="unit' + row_count + '"  readonly value="' + add_unit + '"></div>';
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.setAttribute('nowrap','nowrap');
                    newCell.innerHTML = '<div class="form-group"><input class="moneybox" type="text" id="tax_purchase' + row_count + '" name="tax_purchase' + row_count + '" value="' + commaSplit(tax_purchase,0) + '"style="width:100%;" readonly="yes"></div>';
                    newCell = newRow.insertCell(newRow.cells.length);
                    newCell.setAttribute('nowrap','nowrap');
                    newCell.innerHTML = '<div class="form-group"><input class="moneybox" type="text" name="tax' + row_count + '" id="tax' + row_count + '"  value="' + commaSplit(tax,0) + '" readonly="yes" ></div>';
                    newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="action_profit_margin' + row_count + '" id="action_profit_margin' + row_count + '"  value="0">';
                    /*newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="action_price' + row_count + '" >';*/
                    newCell.innerHTML = newCell.innerHTML + '<input type="hidden" name="duedate' + row_count + '" id="duedate' + row_count + '"  value="0">';
                    newCell.innerHTML = newCell.innerHTML + '<input type="hidden"  name="shelf_id' + row_count + '"><input type="hidden" name="shelf_name' + row_count + '" value="">';
                    newCell = newRow.insertCell(newRow.cells.length);//birim maliyet
                    newCell.innerHTML = newCell.innerHTML + '<div class="form-group"><input class="moneybox" type="text" readonly="readonly" id="products_cost'+row_count+'" name="products_cost'+row_count+'" value="' + commaSplit(product_cost,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>) + '"></div>';
                    newCell = newRow.insertCell(newRow.cells.length);//Ek maliyet
                    newCell.innerHTML = newCell.innerHTML + '<div class="form-group"><input class="moneybox" type="text" readonly="readonly" id="extra_product_cost'+row_count+'" name="extra_product_cost'+row_count+'" value="' + commaSplit(extra_product_cost,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>) + '"></div>';//ek maliyet
                    newCell = newRow.insertCell(newRow.cells.length);//Liste Fiyatı
                    newCell.innerHTML = newCell.innerHTML + '<div class="form-group"><input class="moneybox" type="text" readonly="readonly" id="list_price'+row_count+'" name="list_price'+row_count+'" value="' + commaSplit(list_price,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>) + '"></div>';
                    newCell = newRow.insertCell(newRow.cells.length);//Döviz Liste Fiyatı
                    newCell.innerHTML = newCell.innerHTML + '<div class="form-group"><input class="moneybox" type="text" onKeyUp="hesapla_row(1,'+row_count+');" id="other_list_price'+row_count+'" name="other_list_price'+row_count+'" value="' + commaSplit(other_list_price,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>) + '"></div>';
                    newCell = newRow.insertCell(newRow.cells.length);//Para birimi
                    c = '<div class="form-group"><select name="money' + row_count  +'" id="money' + row_count  +'" onChange="hesapla_row(1,'+row_count+');">';
                        <cfoutput query="get_moneys">
                        if('#money#' == money)
                            c += '<option value="#money#;#rate2#" selected>#money#</option>';
                        else
                            c += '<option value="#money#;#rate2#">#money#</option>';
                        </cfoutput>
                        newCell.innerHTML =c+ '</select></div>';
                    newCell = newRow.insertCell(newRow.cells.length);//Satış Fiyatı
                    newCell.setAttribute('nowrap','nowrap');
                    newCell.innerHTML = '<div class="form-group"><div class="input-group"><input class="moneybox" type="text" id="s_price' + row_count + '" name="s_price' + row_count + '" onKeyUp="hesapla_row(3,'+row_count+');"  value="' + commaSplit(s_price,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>) + '"  style="width:80px;" onBlur="if(this.value==\'\')this.value=0;calculate_amount(' + row_count + ');"><span class="input-group-addon icon-ellipsis btnPointer" onclick="open_price(' + row_count + ');"></span><input type="hidden" name="p_price' + row_count + '" value="' + commaSplit(p_price,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>) + '"><input type="hidden" name="profit_margin' + row_count + '" value="0"></div></div>';
                    
                    newCell = newRow.insertCell(newRow.cells.length);//Toplam Maliyet
                    newCell.innerHTML = '<div class="form-group"><input  class="moneybox" type="text" name="total_product_cost' + row_count + '" id="total_product_cost' + row_count + '" readonly value="1" onBlur="calculate_amount(' + row_count + ');"></div><input type="hidden" value="" name="p_price_hidden' + row_count + '" id="p_price_hidden' + row_count + '">';
                    newCell = newRow.insertCell(newRow.cells.length);//Toplam satış fiyatı
                    newCell.innerHTML = '<div class="form-group"><input  class="moneybox" type="text" name="total_product_price' + row_count + '" id="total_product_price' + row_count + '"readonly value="1" onBlur="calculate_amount(' + row_count + ');"></div>';
                    
                    calculate_amount(row_count);
                    $("#p_price_hidden"+row_count).val(parseFloat($("#s_price"+row_count).val())-parseFloat($("#total_product_cost"+row_count).val()));
                    warningCost();
                }
            
                
    
        }		
        function pencere_ac(no)
        {
            openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_product&is_sub_category=1&pid='+no);
        }
        function getShelf(no)
        {
            windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_list_shelf&shelf_id=form_basket.shelf_id'+no+'&shelf_name=form_basket.shelf_name'+no,'medium');
        }
        function openProducts()
        {
            if($('#property_collar_det').val() != ''  &&  $('#property_collar_id').val() != ''&& $('#property_size_id').val() != ''){
                alert('<cf_get_lang dictionary_id='65478.Özellik ve varyasyon seçimini yaptıktan sonra Karma Koli  ekleme işlemini buton ile yapınız'>')
                return false;
            }
            else
            openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.popup_stocks<cfif isdefined("attributes.compid")>&compid=#attributes.compid#</cfif>&add_product_cost=1&is_filter=1&module_name=product&var_=#var_#&is_action=1&startdate=&price_lists=</cfoutput>');
        
        }
        function addMasterStocks(){
            var barcod = $('#master_product_id').val()==<cfoutput>#attributes.pid#</cfoutput>?"<cfoutput>&karma_product_barcod=#get_product.barcod#</cfoutput>":"";
            var property_collar_det =  $('#property_collar_det').val() != ''?'&property_collar_det='+$('#property_collar_det').val().split('-')[1]:'';
           
            openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.popup_stocks<cfif isdefined("attributes.compid")>&compid=#attributes.compid#</cfif>&add_product_cost=1&module_name=product&var_=#var_#&is_action=1&startdate=&price_lists=&is_filter=1</cfoutput>&price_catid_ref='+$('#price_catid').val()+'&karma_product_id='+$('#master_product_id').val()+ property_collar_det+barcod);
        }
        function controlForm()
        {
            <cfif isdefined("is_zero_price") and is_zero_price eq 1>            
                if(confirm("<cf_get_lang dictionary_id='65415.Sıfır fiyatlı ürünler silinecek'>!"))
                {
                    $("input[id*=total_product_price]").each(function(){
                        if($(this).val() == "" || $(this).val() ==  commaSplit(0,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>))
                            $("input[id=row_kontrol"+$(this).attr("id").split("total_product_price")[1]+"]").val(0);                     
                    });
                }
                else return false;
            </cfif>
            if(row_count>0 &&  document.form_basket.start_date != undefined && document.form_basket.finish_date != undefined && document.form_basket.finish_date.value.length != 0 && document.form_basket.price_catid.value != "")
            {
            if  (time_check(document.form_basket.start_date,document.form_basket.start_h,document.form_basket.start_m,document.form_basket.finish_date,document.form_basket.finish_h,document.form_basket.finish_m,'Başlangıç Ve Bitiş Tarihlerini Kontrol Ediniz !')==false)
                return false;
            }
            for(var i=1; i<=row_count; i++)
            {
                var str_me=eval("form_basket.p_price"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
                var str_me=eval("form_basket.s_price"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
                var str_me=eval("form_basket.profit_margin"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
                var str_me=eval("form_basket.extra_product_cost"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
                var str_me=eval("form_basket.products_cost"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
                var str_me=document.getElementById('total_product_cost'+i);
                if(str_me!= null)
                    str_me.value=filterNum(str_me.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
                    
                var str_me=eval("form_basket.total_product_price"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
                var str_me=eval("form_basket.tax_purchase"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
                var str_me=eval("form_basket.row_lasttotal"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
                var str_me=eval("form_basket.row_amount"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
                var str_me=eval("form_basket.tax"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
                var str_me=eval("form_basket.list_price"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
                var str_me=eval("form_basket.other_list_price"+i);if(str_me!= null)str_me.value=filterNum(str_me.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
            }
            var str_me=form_basket.grosstotal_price;if(str_me!= null)str_me.value=filterNum(str_me.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
            <cfif get_product_unit.is_main neq 1>
                document.getElementById('multiplier').value = filterNum(document.getElementById('multiplier').value,4);    
                if(document.getElementById('multiplier').value == 0)
                {
                    alert("<cf_get_lang dictionary_id='37109.Çarpan alanına sıfır değerini giremezsiniz!'>");
                    return false;	
                }      
            </cfif>
            if(!form_basket.karma_product_name.value || !form_basket.start_date.value ){
                alert("<cf_get_lang dictionary_id='29722.Please fill in the mandatory fields.'>");
                return false;
            }
            <cfif isdefined('is_barcode_required') and is_barcode_required eq 1>
                if(!form_basket.barcod.value){
                    alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57633.Barkod'>!");
                    return false;
                }
            </cfif>
            if(form_basket.barcod.value != '' )
            {
                var get_barcod_info = wrk_safe_query('prod_control_barcode','dsn1',0,form_basket.barcod.value);
                if(get_barcod_info.recordcount)
                {
                    alert("<cf_get_lang dictionary_id ='37894.Girdiğiniz Barkod Başka Bir Ürün Tarafından Kullanılmakta'> !");
                    return false;
                }	
            }
            var product_name_ = document.form_basket.karma_product_name.value;
            var product_name_ = ReplaceAll(product_name_,"'"," ");
            var new_sql = "SELECT P.PRODUCT_ID FROM PRODUCT P WHERE P.PRODUCT_NAME = '"+product_name_+"' AND P.PRODUCT_ID <> <cfoutput>#attributes.pid#</cfoutput>";
            
            var get_prod_info = wrk_query(new_sql,'dsn1');
            if(get_prod_info.recordcount)
            {
                    alert("<cf_get_lang dictionary_id ='37892.Aynı İsimli Bir Ürün Daha Var Lütfen Başka Bir Ürün İsmi Giriniz'>!");
                    return false;
            }
            var collar_option_ = document.getElementById('property_collar_id');
            var property_hidden_collar = collar_option_.options[collar_option_.selectedIndex].text ;
            var size_option_ = document.getElementById('property_size_id');
            var property_hidden_size =size_option_.options[size_option_.selectedIndex].text;
            document.getElementById('weight').value = filterNum(document.getElementById('weight').value,8);
            document.getElementById('unit_multiplier').value = filterNum(document.getElementById('unit_multiplier').value,4);
            $('#price_catid').val($('#price_catid_karma option:selected').val());
            return true;
        }
        function calculate_amount(rowno)
        {
            var money_count = <cfoutput>#GET_MONEYS.RECORDCOUNT#</cfoutput>;
            var temp_products_cost = parseFloat(filterNum(document.getElementById('products_cost'+rowno).value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>'));
            var temp_extra_product_cost = parseFloat(filterNum(document.getElementById('extra_product_cost'+rowno).value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>'));
            var temp_row_amount = parseFloat(filterNum(document.getElementById('row_amount'+rowno).value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>'));
            document.getElementById('total_product_cost'+rowno).value = commaSplit( ( (temp_products_cost + temp_extra_product_cost)* temp_row_amount ),'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');//Burada birim maliyet ve ek maliyeti toplayarak miktar ile çarpıyoruz.
            
            <cfloop query=GET_MONEYS>
                if(list_getat(document.getElementById('money'+rowno).value,1,';') == '<cfoutput>#money#</cfoutput>')
            {
                //KDV 'li eval("document.form_basket.total_product_price"+rowno).value = commaSplit(Number((Number(filterNum(eval('document.form_basket.tax'+rowno).value)) + 100) / 100) * Number(filterNum(eval('document.form_basket.s_price'+rowno).value)*(filterNum(eval('document.form_basket.row_amount'+rowno).value))));//Burada liste satış fiyatı kdv oranı ve miktarı ile çarpılıyor.
                document.getElementById('total_product_price'+rowno).value = commaSplit(Number(filterNum(document.getElementById('s_price'+rowno).value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>')*(filterNum(document.getElementById('row_amount'+rowno).value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>'))),'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');//Burada liste satış fiyatı kdv oranı ve miktarı ile çarpılıyor.
                //eval("document.form_basket.total_product_price"+rowno).value = commaSplit((<cfoutput>#GET_MONEYS.RATE2#</cfoutput>)*filterNum(eval("document.form_basket.total_product_price"+rowno).value));//Burada 1 üst satırda oluşturulan toplam liste satış fiyatı döviz kuru rate2 ile çarpılarak genel toplam sistem para birimi cinsinden yazılıyor.
                calculate_grosstotal(document.form_basket.selected_money.value);
                
            }	
            </cfloop>
            
        }
        function calculate_grosstotal(type)
        {
    
            document.form_basket.grosstotal_cost.value = 0;
            document.form_basket.grosstotal_price.value = 0;
            for(ix=1;ix<row_count+1;ix++){
                if(document.getElementById('row_kontrol'+ix).value==1){
                    document.form_basket.grosstotal_cost.value = commaSplit(Number(filterNum(document.form_basket.grosstotal_cost.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>')) + Number(filterNum(eval("document.form_basket.total_product_cost"+ix).value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>')),'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
                    <cfloop query=GET_MONEYS>
                        if(type =='<cfoutput>#GET_MONEYS.MONEY#</cfoutput>')
                        {
                        document.form_basket.grosstotal_price.value = commaSplit(Number(filterNum(document.form_basket.grosstotal_price.value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>')) + Number(filterNum(eval("document.form_basket.total_product_price"+ix).value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>'))/<cfoutput>#GET_MONEYS.RATE2[currentrow]#</cfoutput>,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
                        }
                    </cfloop>
                    document.form_basket.selected_money.value=type;
                }
            }
        }
        function change_price_cat(id)
        {
            document.form_basket.action = '<cfoutput>#request.self#?fuseaction=product.dsp_karma_props&pid=#attributes.pid#&price_catid='+id+'</cfoutput>';
            document.form_basket.submit();
        }
        function uyar(type)
        {
            if (type==1)
            alert("<cf_get_lang dictionary_id ='37783.Bir Liste Fiyatı Varken ya da Seçili İken, Miktar Üzerinde Değişiklik Yapamazsınız Liste Fiyatlarını Silerek Standart Ürün Listesini Tekrar Düzenleyiniz'>.");
            if (type==2)
            alert("<cf_get_lang dictionary_id ='37784.Bir Liste Fiyatı Varken ya da Seçili İken, Ürün Listesine Ekleme Yada Çıkarma Yapamazsınız Liste Fiyatlarını Silerek Standart Ürün Listesini Tekrar Düzenleyiniz'>.");
        }
        function open_price(satir)
        {
            url_str = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_price_history_js&is_from_product&row_no='+satir+'';
            product_id = eval("document.form_basket.product_id"+satir).value;
            stock_id = eval("document.form_basket.stock_id"+satir).value;
            product_name = '';
            unit_ = eval("document.form_basket.unit_id"+satir).value;
            url_str = url_str + '&sepet_process_type=-1';
            url_str = url_str + '&product_id=' + product_id + '&stock_id=' + stock_id + '&pid=' + product_id + '&product_name=' + product_name + '&unit=' + unit_ + '&row_id=' + satir;
            <cfloop query="get_moneys">
                url_str = url_str + '&<cfoutput>#money#=#rate2/rate1#</cfoutput>';
            </cfloop>
            if(product_id != "")
                windowopen(url_str,'medium');
        }
        function hesapla_row(type,row_info)
        {
            
            form_value_rate_satir = list_getat(eval("document.getElementById('money" + row_info + "')").value,2,';');
            if(type != 3)
            {
                eval("document.form_basket.s_price"+row_info).value = commaSplit(filterNum(eval("document.form_basket.other_list_price"+row_info).value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>')*form_value_rate_satir,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
            }
            else
            {
                eval("document.form_basket.other_list_price"+row_info).value = commaSplit(filterNum(eval("document.form_basket.s_price"+row_info).value,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>')/form_value_rate_satir,'<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>');
            }
            
            calculate_amount(row_info);
        }
        moneyArray = new Array(<cfoutput>#get_moneys.recordcount#</cfoutput>);
        rate1Array = new Array(<cfoutput>#get_moneys.recordcount#</cfoutput>);
        rate2Array = new Array(<cfoutput>#get_moneys.recordcount#</cfoutput>);
        <cfoutput query="get_moneys">
            /*javascript array doldurulur*/
            <cfif session.ep.period_year gte 2009 and get_moneys.MONEY is 'YTL'>
                moneyArray[#currentrow-1#] = '#session.ep.money#';
            <cfelse>
                moneyArray[#currentrow-1#] = '#MONEY#';
            </cfif>
            rate1Array[#currentrow-1#] = #rate1#;
            rate2Array[#currentrow-1#] = #rate2#;
            /*javascript array doldurulur*/
        </cfoutput>
        
        function add_prod_row(){
            // $("#table1").empty();
            
        for(h=1;h<row_count+1;h++){
        if($('#product_id'+h).val()!=$('#product_id').val() &&  typeof $('#product_id'+h).val() !== 'undefined')//Koliye Farklı Bir Ürün Eklenemez.
            {
                alert("<cf_get_lang dictionary_id='60379.Koliye Farklı Ürün Eklenemez'>");
                return false;
        }
            }	
            
        url_ = "/V16/product/cfc/GetPrice.cfc?method=getPrice&product_id="+$('#product_id').val()+"&prod_detail="+$('#prod_detail').val()+"&prod_varyasyon="+$('#prod_varyasyon').val()+"&price_id="+$('#price_list').val();
        $.ajax({
        url: url_,
        dataType: "text",
        success: function(read_data) {
            read_data = read_data.substring(2, read_data.length);
        data_ = jQuery.parseJSON(read_data);
        if(data_.DATA.length !=0)
        {
            
            $.each(data_.DATA,function(i){
            $.each(data_.COLUMNS,function(k){
            var PROPERTY_DETAIL_ID = data_.DATA[i][0];
            var PROPERTY_DETAIL = data_.DATA[i][1];
            var STOCK_ID = data_.DATA[i][2];
            var PROPERTY_ID = data_.DATA[i][3];
            var PRODUCT_NAME = data_.DATA[i][4];
            var MAIN_UNIT = data_.DATA[i][5];
            var PRODUCT_UNIT_ID = data_.DATA[i][6];
            var TAX = data_.DATA[i][7];
            var TAX_PURCHASE = data_.DATA[i][8];
            var PRODUCT_ID = data_.DATA[i][9];
            var SISTEM_MALIYET = data_.DATA[i][10];
            var EK_MALIYET = data_.DATA[i][11];
            var PRICE = data_.DATA[i][12];
            var MONEY = data_.DATA[i][13];
            if( k == 7 )
            add_modal_orders(PRODUCT_NAME,PRODUCT_UNIT_ID,STOCK_ID,PRODUCT_ID,MAIN_UNIT,TAX_PURCHASE,TAX,SISTEM_MALIYET,EK_MALIYET,PRICE,MONEY,PROPERTY_ID,PROPERTY_DETAIL_ID);
    
        });
        });
    
        }
        }
    });
                    
    
        }
        
        
        function add_modal_orders(PRODUCT_NAME,PRODUCT_UNIT_ID,STOCK_ID,PRODUCT_ID,MAIN_UNIT,TAX_PURCHASE,TAX,SISTEM_MALIYET,EK_MALIYET,PRICE,MONEY,PROPERTY_ID,PROPERTY_DETAIL_ID)// siparis listesi olusturuluyor
        {
            
            var is_error = 0;
        for(h=1;h<row_count+1;h++){
                if($('#stock_id'+h).val()==STOCK_ID)
                    {
                        //alert($('#stock_id'+h).val()+' : aynı stok zaten var : '+STOCK_ID);
                        h++;
                        is_error = 1;
                        return false;
                    }
                if($('#property_detail_id'+h).val()!=PROPERTY_DETAIL_ID &&  typeof $('#property_detail_id'+h).val() !== 'undefined')
                {
                    alert('<cf_get_lang dictionary_id="60380.Koliye Aynı Ürünün Farklı Varyasyonunu Ekleyemezsiniz">.');
                    is_error= 1 ;
                    break;
                    return false;
                }
            }
            if(is_error==0)
            {
                row_count++;
                document.form_basket.record_num.value=row_count;
                var k=$('#table1 tbody').children().length;
                if(row_count == 1)
                {
                    var new_row = new_row+'<tr name="frm_row'+ row_count +'" id="frm_row' + row_count + '">';
                }
                
                else
                {
                    $('#table1').children("tr:last").after("<tr id=frm_row"+row_count+" name=frm_row"+row_count+">");
                }
                var new_row = new_row+'<td><input type="hidden" name="row_kontrol'+ row_count +'" id="row_kontrol' + row_count + '" value="1"><a style="cursor:pointer" onclick="sil('+row_count+');"><i class="fa fa-minus"></i></a></td>';
                var new_row = new_row+'<td>'+ row_count +'</td>';
                var new_row = new_row+'<td><input type="hidden" name="stock_id'+row_count+'" id="stock_id'+row_count+'" value="'+STOCK_ID+'">';
                var new_row = new_row+'<input type="hidden" name="product_id'+row_count+'" id="product_id'+row_count+'" value="'+PRODUCT_ID+'">';
                var new_row = new_row+'<input type="hidden" name="unit_id'+row_count+'" id="unit_id'+row_count+'" value="'+PRODUCT_UNIT_ID+'">';
                var new_row = new_row+'<input type="Hidden" name="property_id'+row_count+'" id="property_id'+row_count+'" value="'+PROPERTY_ID+'">';
                var new_row = new_row+'<input type="Hidden" name="property_detail_id'+row_count+'" id="property_detail_id'+row_count+'" value="'+PROPERTY_DETAIL_ID+'">';
                var new_row = new_row+'<input type="hidden" name="product_name'+row_count+'" value="'+PRODUCT_NAME+'" style="width:155px;" >'+ PRODUCT_NAME;
                var new_row = new_row+'<a href="javascript://" onClick="pencere_ac('+PRODUCT_ID+');"><img border="0" src="/images/plus_thin.gif" align="absmiddle" alt="<cf_get_lang dictionary_id ="37786.Ürün Seç">"></a></td>'; 
                var new_row = new_row+'<td><input type="text" style="width:35px;" name="spec_main_id'+row_count+'" id="spec_main_id'+row_count+'" value="" readonly>';
                var new_row = new_row+'<input type="text" name="spec_name'+row_count+'" id="spec_name'+row_count+'" style="width:100px;" onChange="clearSpecM('+row_count+')" value=""><a href="javascript://" onClick="open_spec_page('+row_count+');"><img src="/images/plus_thin.gif"></a></td>';
                var new_row = new_row+'<td><div class="form-group"><input type="text" name="unit'+row_count+'" id="unit'+row_count+'" value="'+MAIN_UNIT+'"  readonly></div></td>';
                var new_row = new_row+'<td><div class="form-group"><input type="text" name="tax_purchase'+row_count+'" readonly="yes" id="tax_purchase'+row_count+'" value="'+TAX_PURCHASE+'"></div></td>';
                var new_row = new_row+'<td><div class="form-group"><input type="text" name="tax'+row_count+'" readonly="yes" id="tax'+row_count+'" value="'+TAX+'"></div></td>';
                var new_row = new_row+'<td><div class="form-group"><input type="text" name="products_cost'+row_count+'" readonly id="products_cost'+row_count+'" value="'+commaSplit(SISTEM_MALIYET,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>)+'"></div></td>';
                var new_row = new_row+'<td><div class="form-group"><input type="text" style="width:100%"; name="extra_product_cost'+row_count+'" readonly="yes" id="extra_product_cost'+row_count+'" value="'+commaSplit(EK_MALIYET,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>)+'"></div></td>';
                var new_row = new_row+'<td><div class="form-group"><input type="text" style="width:100%"; name="list_price'+row_count+'" readonly="yes" id="list_price'+row_count+'" value="'+commaSplit(PRICE,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>)+'"><</div>/td>';
                var new_row = new_row+'<td><div class="form-group"><input type="text"  name="other_list_price'+row_count+'"  id="other_list_price'+row_count+'" value="" onKeyUp="hesapla_row(1,'+row_count+');"></div></td>';
                c = '<select name="money' + row_count  +'" id="money' + row_count  +'" onChange="hesapla_row(1,'+row_count+');">';
                    <cfoutput query="get_moneys">
                    if('#money#' == MONEY)
                        c += '<option value="#money#;#rate2#" selected>#money#</option>';
                    else
                        c += '<option value="#money#;#rate2#">#money#</option>';
                    </cfoutput>
                var new_row = new_row+'<td>'+c+ '</select></td>';
                
                var new_row = new_row+'<td><div class="form-group"><div class="input-group"><input type="text" name="s_price' + row_count + '" id="s_price' + row_count + '" onKeyUp="hesapla_row(3,'+row_count+');"   value="'+commaSplit(PRICE,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>)+'"  style="width:80px;" onBlur="if(this.value==\'\')this.value=0;calculate_amount(' + row_count + ');"><span class="input-group-addon icon-ellipsis btnPointer" onclick="open_price(' + row_count + ');"></span></div></div></td>';
                var new_row = new_row+'<td><div class="form-group"><input type="text" name="row_amount' + row_count + '" id="row_amount' + row_count + '" value="1" onBlur="calculate_amount(' + row_count + ');"></div></td>';
                
                var new_row = new_row+'<td><div class="form-group"><input type="text" name="total_product_cost'  + row_count + '" id="total_product_cost'  + row_count + '" readonly value="1" onBlur="calculate_amount(' + row_count + ');"></div></td>';
                var new_row = new_row+'<td><div class="form-group"><input type="text" name="total_product_price' + row_count + '" id="total_product_price' + row_count + '"readonly value="1" onBlur="calculate_amount(' + row_count + ');"></div></td></tr>';
                //var new_row = new_row+'<td>'+  +'</td></tr>';
                
                if(row_count==1)
                {
                    $("#table1").append(new_row);
                }
                else
                {
                $('#table1').find('tr:last').append(new_row);
                }
                calculate_amount(row_count);
            }
        }
        
        function pricelist(product_id)
        {
            url_ = "/V16/product/cfc/GetPrice.cfc?method=getPriceList&product_id="+product_id;
            $.ajax({
                url: url_,
                dataType: "text",
                success: function(read_data) {
                    read_data = read_data.substring(2, read_data.length);
                    data_ = jQuery.parseJSON(read_data);
                    if(data_.DATA.length !=0)
                    {
                        $('#price_list').empty();
                        $('#price_list').append('<option value="">Seçiniz</option>');
                        $.each(data_.DATA,function(i){
                            $.each(data_.COLUMNS,function(k){
                                var PRICE_ID = data_.DATA[i][0];
                                var PRICE_CAT = data_.DATA[i][1];
                                if( k == 1 )
                                $("#price_list").append('<option value='+PRICE_ID+'>'+PRICE_CAT+'</option>');
                    
                            });
                        });
    
                    }
                }
            });
        }
        function barcod_control()
        {
            var prohibited_asci='32,33,34,35,36,37,38,39,40,41,42,43,44,59,60,61,62,63,64,91,92,93,94,96,123,124,125,156,171,187,163,126';
            barcode = document.getElementById('barcod');
            toplam_ = barcode.value.length;
            deger_ = barcode.value;
            if(toplam_>0)
            {
                for(var this_tus_=0; this_tus_< toplam_; this_tus_++)
                {
                    tus_ = deger_.charAt(this_tus_);
                    cont_ = list_find(prohibited_asci,tus_.charCodeAt());
                    if(cont_>0)
                    {
                        alert("[space],!,\"\,#,$,%,&,',(,),*,+,,;,<,=,>,?,@,[,\,],],`,{,|,},£,~ Karakterlerinden Oluşan Barcod Girilemez!");
                        barcode.value = '';
                        break;
                    }
                }
            }
        }
        function createName() {
            if((!$('#property_collar_det').val())||$('#record_num').val()==0)
            {
                alert("<cf_get_lang dictionary_id='65420.Varsyasyonu seçtikten ve koliyi oluşturduktan sonra isim üretin'>!");
                return false;
            }
            else
            {
                var sum = 0;
                $("input[id*=row_amount]").each(function() {
                    sum += parseFloat($(this).val());
                });
                $('#karma_product_name').val($('#master_product_name').val()+' Karma '+$('#property_collar_det').val() + ' ' +sum );
            }        
        }
    
    </script>
    
    