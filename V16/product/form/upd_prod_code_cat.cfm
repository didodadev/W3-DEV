<cfquery name="GET_EXPENSE_ITEM_AMRT" datasource="#dsn2#">
	SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 ORDER BY EXPENSE_ITEM_NAME
</cfquery> 
 <cfquery name="GET_EXPENSE_CENTER_AMRT" datasource="#dsn2#">
	SELECT EXPENSE_ID, EXPENSE FROM EXPENSE_CENTER ORDER BY EXPENSE
</cfquery> 
<cfquery name="GET_EXPENSE_TEMPLATE" datasource="#dsn2#">
	SELECT TEMPLATE_ID, TEMPLATE_NAME,IS_INCOME FROM EXPENSE_PLANS_TEMPLATES ORDER BY TEMPLATE_NAME
</cfquery>
<cfquery name="GET_EXPENSE_TEMPLATE_EXPENSE" dbtype="query">
	SELECT TEMPLATE_ID, TEMPLATE_NAME FROM GET_EXPENSE_TEMPLATE WHERE IS_INCOME<>1 ORDER BY TEMPLATE_NAME
</cfquery>
<cfquery name="GET_EXPENSE_TEMPLATE_INCOME" dbtype="query">
	SELECT TEMPLATE_ID, TEMPLATE_NAME FROM GET_EXPENSE_TEMPLATE WHERE IS_INCOME=1 ORDER BY TEMPLATE_NAME
</cfquery>
<cfquery name="GET_ACTIVITY_TYPES" datasource="#dsn#">
	SELECT ACTIVITY_ID, ACTIVITY_NAME FROM SETUP_ACTIVITY ORDER BY ACTIVITY_NAME
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="pro_period_cat" method="post" action="#request.self#?fuseaction=product.upd_prod_code_cat">
            <input type="hidden" value="<cfoutput>#attributes.cat_id#</cfoutput>" name="cat_id" id="cat_id">
            <cf_box_elements>
                <cfif isDefined('attributes.cat_id') and len(attributes.cat_id)>
                    <cfquery name="get_cat_detail" datasource="#dsn3#">
                        SELECT 
                            #dsn#.Get_Dynamic_Language(PRO_CODE_CATID,'#session.ep.language#','SETUP_PRODUCT_PERIOD_CAT','PRO_CODE_CAT_NAME',NULL,NULL,PRO_CODE_CAT_NAME) AS PRO_CODE_CAT_NAME,
                            * 
                        FROM 
                            SETUP_PRODUCT_PERIOD_CAT
                        WHERE PRO_CODE_CATID = #attributes.cat_id#
                    </cfquery>
                    <cfinclude template="../query/get_product_account_function.cfm">
                </cfif>
                <cfoutput>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                        <div class="form-group" id="item-is_active">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                            <div class="col col-7 col-xs-12">
                                <input type="checkbox" name="is_active" id="is_active" value="1" <cfif get_cat_detail.is_active eq 1>checked</cfif>>
                            </div>
                        </div>
                        <div class="form-group" id="item-PRO_CODE_CAT_NAME">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='58969.Grup Adı'> *</label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='37447.Grup Adi Girmelisiniz'></cfsavecontent>
                                    <cfinput type="Text" name="PRO_CODE_CAT_NAME"  value="#get_cat_detail.PRO_CODE_CAT_NAME#" maxlength="100" required="Yes" message="#message#">	
                                    <span class="input-group-addon">
                                    <cf_language_info 
                                    table_name="SETUP_PRODUCT_PERIOD_CAT" 
                                    column_name="PRO_CODE_CAT_NAME" 
                                    column_id_value="#attributes.cat_id#" 
                                    maxlength="255" 
                                    datasource="#dsn3#" 
                                    column_id="PRO_CODE_CATID" 
                                    control_type="1">
                                </span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-account_code_sale">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37368.Satış Hesabı'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.ACCOUNT_CODE)>
                                    <input type="text" name="account_code_sale" id="account_code_sale" value="#get_cat_detail.ACCOUNT_CODE#" title="#acc_name#"  onfocus="AutoComplete_Create('account_code_sale','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off" >
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('account_code_sale');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-account_code_purchase">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37369.Alış Hesabı'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.ACCOUNT_CODE_PUR)>
                                    <input type="text" name="account_code_purchase" id="account_code_purchase" value="#get_cat_detail.ACCOUNT_CODE_PUR#" title="#acc_name#"  onfocus="AutoComplete_Create('account_code_purchase','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off" >
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('account_code_purchase');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-INCOMING_STOCK">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='60299.Gelen Yoldaki Stok(Alış)'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.INCOMING_STOCK)>
                                    <cfif isdefined("get_cat_detail")><cfset incoming_stock = get_cat_detail.INCOMING_STOCK><cfelse><cfset incoming_stock = ''></cfif>
                                    <input type="text" name="incoming_stock" id="incoming_stock" value="#incoming_stock#" title="#acc_name#"  onfocus="AutoComplete_Create('incoming_stock','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off" />
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('incoming_stock');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-OUTGOING_STOCK">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='60300.Giden Yoldaki Stok(Satış)'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.OUTGOING_STOCK)>
                                    <cfif isdefined("get_cat_detail")><cfset outgoing_stock = get_cat_detail.OUTGOING_STOCK><cfelse><cfset outgoing_stock = ''></cfif>
                                    <input type="text" name="outgoing_stock" id="outgoing_stock" value="#outgoing_stock#" title="#acc_name#"  onfocus="AutoComplete_Create('outgoing_stock','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off" />
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('outgoing_stock');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-account_discount">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37459.Satış İskonto'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.ACCOUNT_DISCOUNT)>
                                    <input type="text" name="account_discount" id="account_discount" value="#get_cat_detail.ACCOUNT_DISCOUNT#" title="#acc_name#"  onfocus="AutoComplete_Create('account_discount','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('account_discount');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-account_discount_pur">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37464.Alış İskonto'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.ACCOUNT_DISCOUNT_PUR)>
                                    <input type="text" name="account_discount_pur" id="account_discount_pur" value="#get_cat_detail.ACCOUNT_DISCOUNT_PUR#" title="#acc_name#"  onfocus="AutoComplete_Create('account_discount_pur','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('account_discount_pur');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-account_iade">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37462.Satış İade'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.ACCOUNT_IADE)>
                                    <input type="text" name="account_iade" id="account_iade" value="#get_cat_detail.ACCOUNT_IADE#" title="#acc_name#"  onfocus="AutoComplete_Create('account_iade','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('account_iade');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-account_pur_iade">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37461.Alış İade'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.ACCOUNT_PUR_IADE)>
                                    <input type="text" name="account_pur_iade" id="account_pur_iade" value="#get_cat_detail.ACCOUNT_PUR_IADE#" title="#acc_name#"  onfocus="AutoComplete_Create('account_pur_iade','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('account_pur_iade');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-account_price">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37749.Satış Fiyat Farkı'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.ACCOUNT_PRICE)>
                                    <input type="text" name="account_price" id="account_price" value="#get_cat_detail.ACCOUNT_PRICE#" title="#acc_name#"  onfocus="AutoComplete_Create('account_price','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off" >
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('account_price');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-ACCOUNT_PRICE_PUR">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id ='37750.Alış Fiyat Farkı'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.ACCOUNT_PRICE_PUR)>
                                    <input type="text" name="ACCOUNT_PRICE_PUR" id="ACCOUNT_PRICE_PUR" value="#get_cat_detail.ACCOUNT_PRICE_PUR#" title="#acc_name#"  onfocus="AutoComplete_Create('ACCOUNT_PRICE_PUR','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('ACCOUNT_PRICE_PUR');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-account_exportregistered">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='60998.İhraç Kayıtlı Satış'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.ACCOUNT_EXPORTREGISTERED)>
                                    <input type="text" name="account_exportregistered" id="account_exportregistered" value="#get_cat_detail.ACCOUNT_EXPORTREGISTERED#" title="#acc_name#"  onfocus="AutoComplete_Create('account_exportregistered','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('account_exportregistered');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-account_yurtdisi">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37463.Yurtdışı Satış'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.ACCOUNT_YURTDISI)>
                                    <input type="text" name="account_yurtdisi" id="account_yurtdisi" value="#get_cat_detail.ACCOUNT_YURTDISI#" title="#acc_name#"  onfocus="AutoComplete_Create('account_yurtdisi','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('account_yurtdisi');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-account_yurtdisi_pur">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37465.Yurtdışı Alış'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.ACCOUNT_YURTDISI_PUR)>
                                    <input type="text" name="account_yurtdisi_pur" id="account_yurtdisi_pur" value="#get_cat_detail.ACCOUNT_YURTDISI_PUR#" title="#acc_name#"  onfocus="AutoComplete_Create('account_yurtdisi_pur','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('account_yurtdisi_pur');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-material_code_sale">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37498.Hammadde'><cf_get_lang dictionary_id='57448.Satis'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.MATERIAL_CODE_SALE)>
                                    <input type="text"  name="material_code_sale" id="material_code_sale" value="#get_cat_detail.MATERIAL_CODE_SALE#" title="#acc_name#"  onfocus="AutoComplete_Create('material_code_sale','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('material_code_sale');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-material_code">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37498.Hammadde'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.MATERIAL_CODE)>
                                    <input type="text"  name="material_code" id="material_code" value="#get_cat_detail.MATERIAL_CODE#" title="#acc_name#"  onfocus="AutoComplete_Create('material_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('material_code');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-account_loss">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37483.Fireler'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.ACCOUNT_LOSS)>
                                    <input type="text" name="account_loss" id="account_loss" value="#get_cat_detail.ACCOUNT_LOSS#" title="#acc_name#"  onfocus="AutoComplete_Create('account_loss','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('account_loss');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-account_expenditure">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='30009.Sarflar'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.ACCOUNT_EXPENDITURE)>
                                    <input type="text" name="account_expenditure" id="account_expenditure" value="#get_cat_detail.ACCOUNT_EXPENDITURE#" title="#acc_name#"  onfocus="AutoComplete_Create('account_expenditure','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('account_expenditure');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-over_count">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='57753.Sayım Fazlası'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.OVER_COUNT)>
                                    <input type="text" name="over_count" id="over_count" value="#get_cat_detail.OVER_COUNT#" title="#acc_name#"  onfocus="AutoComplete_Create('over_count','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off" />
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('over_count');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-under_count">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='57754.Sayım Eksiği'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.UNDER_COUNT)>
                                    <input type="text" name="under_count" id="under_count" value="#get_cat_detail.UNDER_COUNT#" title="#acc_name#"  onfocus="AutoComplete_Create('under_count','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('under_count');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-production_cost_sale">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37458.Mamül'><cf_get_lang dictionary_id='57448.Satis'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.PRODUCTION_COST_SALE)>
                                    <input type="text" name="production_cost_sale" id="production_cost_sale" value="#get_cat_detail.PRODUCTION_COST_SALE#" title="#acc_name#"  onfocus="AutoComplete_Create('production_cost_sale','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('production_cost_sale');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-production_cost">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='57456.Üretim'>/<cf_get_lang dictionary_id='37458.Mamül'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.PRODUCTION_COST)>
                                    <input type="text" name="production_cost" id="production_cost" value="#get_cat_detail.PRODUCTION_COST#" title="#acc_name#"  onfocus="AutoComplete_Create('production_cost','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('production_cost');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-half_production_cost">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='57456.Üretim'>/<cf_get_lang dictionary_id='37473.Yarı Mamül'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.HALF_PRODUCTION_COST)>
                                    <input type="text" name="half_production_cost" id="half_production_cost" value="#get_cat_detail.HALF_PRODUCTION_COST#" title="#acc_name#" onfocus="AutoComplete_Create('half_production_cost','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off" />
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('half_production_cost');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-sale_product_cost">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37474.Satılan Malın Maliyeti'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.SALE_PRODUCT_COST)>
                                    <input type="text" id="sale_product_cost" name="sale_product_cost" value="#get_cat_detail.SALE_PRODUCT_COST#" title="#acc_name#"  onfocus="AutoComplete_Create('sale_product_cost','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('sale_product_cost');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-sale_manufactured_cost">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="59119.Satılan Mamülün Maliyeti"></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.SALE_MANUFACTURED_COST)>
                                    <input type="text" id="sale_manufactured_cost" name="sale_manufactured_cost" value="#get_cat_detail.SALE_MANUFACTURED_COST#" title="#acc_name#"  onfocus="AutoComplete_Create('sale_manufactured_cost','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('sale_manufactured_cost');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-konsinye_pur_code">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37505.Konsinye Alış Hesabı'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.KONSINYE_PUR_CODE)>
                                    <input type="text" name="konsinye_pur_code" id="konsinye_pur_code" value="#get_cat_detail.KONSINYE_PUR_CODE#" title="#acc_name#"  onfocus="AutoComplete_Create('konsinye_pur_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('konsinye_pur_code');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-konsinye_sale_code">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37506.Diger Satış Hesabı'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.KONSINYE_SALE_CODE)>
                                    <input type="text" name="konsinye_sale_code" id="konsinye_sale_code" value="#get_cat_detail.KONSINYE_SALE_CODE#" title="#acc_name#" onfocus="AutoComplete_Create('konsinye_sale_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off" />
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('konsinye_sale_code');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-konsinye_sale_naz_code">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37508.Diger Satış Nazım Hesabı'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.KONSINYE_SALE_NAZ_CODE)>
                                    <input type="text" id="konsinye_sale_naz_code" name="konsinye_sale_naz_code" value="#get_cat_detail.KONSINYE_SALE_NAZ_CODE#" title="#acc_name#"  onfocus="AutoComplete_Create('konsinye_sale_naz_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('konsinye_sale_naz_code');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-get_progress_code">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="37034.Alınan Hakediş Muhasebe Kodu"></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.RECEIVED_PROGRESS_CODE)>
                                    <cfif isdefined("get_cat_detail")><cfset get_progress_code = get_cat_detail.RECEIVED_PROGRESS_CODE><cfelse><cfset get_progress_code = ''></cfif>
                                    <input type="text" name="get_progress_code" id="get_progress_code" value="#get_progress_code#" title="#acc_name#"  onfocus="AutoComplete_Create('get_progress_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('get_progress_code');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-submitted_progress_code">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="37036.Verilen Hakediş Muhasebe Kodu"></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.PROVIDED_PROGRESS_CODE)>
                                    <cfif isdefined("get_cat_detail")><cfset submit_progress_code = get_cat_detail.PROVIDED_PROGRESS_CODE><cfelse><cfset submit_progress_code = ''></cfif>
                                    <input type="text" name="submitted_progress_code" id="submitted_progress_code" value="#submit_progress_code#" title="#acc_name#"  onfocus="AutoComplete_Create('submitted_progress_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('submitted_progress_code');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-scrap_code_sale">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="37093.Hurda Hesabı"><cf_get_lang dictionary_id='57448.Satis'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.SCRAP_CODE_SALE)>
                                    <cfif isdefined("get_cat_detail")><cfset scrap_code_sale = get_cat_detail.SCRAP_CODE_SALE><cfelse><cfset scrap_code_sale = ''></cfif>
                                    <input type="text" name="scrap_code_sale" id="scrap_code_sale" value="#scrap_code_sale#" title="#acc_name#"  onfocus="AutoComplete_Create('scrap_code_sale','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('scrap_code_sale');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-scrap_code">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="37093.Hurda Hesabı"></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.SCRAP_CODE)>
                                    <cfif isdefined("get_cat_detail")><cfset scrap_code = get_cat_detail.SCRAP_CODE><cfelse><cfset scrap_code = ''></cfif>
                                    <input type="text" name="scrap_code" id="scrap_code" value="#scrap_code#" title="#acc_name#"  onfocus="AutoComplete_Create('scrap_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('scrap_code');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-dimm_code">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id ='37751.D İ Mad Malz Hesabı'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.DIMM_CODE)>
                                    <input type="text" name="dimm_code" id="dimm_code" value="#get_cat_detail.DIMM_CODE#" title="#acc_name#"  onfocus="AutoComplete_Create('dimm_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('dimm_code');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-dimm_yans_code">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id ='37752.D İ Mad Malz Yans Hesabı'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.DIMM_YANS_CODE)>
                                    <input type="text" name="dimm_yans_code" id="dimm_yans_code" value="#get_cat_detail.DIMM_YANS_CODE#" title="#acc_name#"  onfocus="AutoComplete_Create('dimm_yans_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('dimm_yans_code');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-promotion_code">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37559.Promosyon Hesabı'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.PROMOTION_CODE)>
                                    <input type="text" name="promotion_code" id="promotion_code" value="#get_cat_detail.PROMOTION_CODE#" title="#acc_name#" onfocus="AutoComplete_Create('promotion_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('promotion_code');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-prod_general_code">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="37019.Genel Üretim Giderleri Yansıtma Hesabı"></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.PROD_LABOR_COST_CODE)>
                                    <cfif isdefined("get_cat_detail")><cfset prod_general_code = get_cat_detail.PROD_GENERAL_CODE><cfelse><cfset prod_general_code = ''></cfif>
                                    <input type="text" name="prod_general_code" id="prod_general_code" value="#prod_general_code#" title="#acc_name#"  onfocus="AutoComplete_Create('prod_general_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('prod_general_code');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-prod_labor_cost_code">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="37033.Üretim İşçilik Yansıtma Hesabı"></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.PROD_LABOR_COST_CODE)>
                                    <cfif isdefined("get_cat_detail")><cfset prod_labor_cost_code = get_cat_detail.PROD_LABOR_COST_CODE><cfelse><cfset prod_labor_cost_code = ''></cfif>
                                    <input type="text" name="prod_labor_cost_code" id="prod_labor_cost_code" value="#prod_labor_cost_code#" title="#acc_name#"  onfocus="AutoComplete_Create('prod_labor_cost_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('prod_labor_cost_code');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-detail">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                            <div class="col col-7 col-xs-12">
                                <textarea name="detail" id="detail">#get_cat_detail.DETAIL#</textarea>
                            </div>
                        </div>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="2" type="column" sort="true">
                        <div class="form-group" id="item-gider">
                            <label class="headbold font-red-sunglo col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='37047.Gider Dağılım'></label>
                        </div>
                        <cfif isDefined("get_cat_detail.exp_center_id") and len(get_cat_detail.exp_center_id)>
                            <cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
                                SELECT EXPENSE_ID, EXPENSE FROM EXPENSE_CENTER where EXPENSE_ID = #get_cat_detail.exp_center_id# 
                            </cfquery>
                            <cfset gdr_id  = GET_EXPENSE_CENTER.EXPENSE_ID>
                            <cfset gdr_name  = GET_EXPENSE_CENTER.EXPENSE>
                        <cfelse>
                            <cfset gdr_id  = ''>
                            <cfset gdr_name  = ''>
                        </cfif>  
                        <div class="form-group" id="item-exp_center_id">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37112.Gider Merkezi'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="exp_center_id" id="exp_center_id" value="#gdr_id#">
                                    <input type="text" name="expense" id="expense"  value="<cfif len(gdr_name)>#gdr_name#</cfif>" >
                                    <span class="input-group-addon icon-ellipsis btnPointer"  onclick="pencere_ac_exp_center('satir'); kontrol(1);"></span>
                                </div>		
                            </div>
                        </div>                          
                        <cfif isDefined("get_cat_detail.exp_item_id") and len(get_cat_detail.exp_item_id)>
                            <cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
                                SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 AND EXPENSE_ITEM_ID =  #get_cat_detail.exp_item_id#
                            </cfquery>
                            <cfset exp_id  = GET_EXPENSE_ITEM.expense_item_id>
                            <cfset exp_name  = GET_EXPENSE_ITEM.expense_item_name>
                        <cfelse>
                            <cfset exp_id  = ''>
                            <cfset exp_name  = ''>
                        </cfif> 
                        <div class="form-group" id="item-exp_item_id">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='58551.Gider Kalemi'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="exp_item_id" id="exp_item_id" value="#exp_id#">
                                    <input type="text"  name="expense_item_name" id="expense_item_name" value="<cfif len(exp_name)>#exp_name#</cfif>">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac_expence_center('satir'); kontrol(1);"></span>
                                </div>
                            </div>
                        </div> 
                        <div class="form-group" id="item-EXPENSE_PROGRESS_CODE">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="37297.Gider Muhasebe Kodu"></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.EXPENSE_PROGRESS_CODE)>
                                    <input type="text"  name="EXPENSE_PROGRESS_CODE" id="EXPENSE_PROGRESS_CODE" value="#get_cat_detail.EXPENSE_PROGRESS_CODE#" title="#acc_name#" onfocus="AutoComplete_Create('EXPENSE_PROGRESS_CODE','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer"  onclick="pencere_ac('EXPENSE_PROGRESS_CODE');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-exp_activity_type_id">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37218.Aktivite Tipi'></label>
                            <div class="col col-7 col-xs-12">
                                <cfif isdefined("get_cat_detail")><cfset exp_activity_type_id = get_cat_detail.exp_activity_type_id><cfelse><cfset exp_activity_type_id = ''></cfif>
                                <select name="exp_activity_type_id" id="exp_activity_type_id" onchange="kontrol(1);">
                                    <option value=""></option>
                                    <cfloop query="get_activity_types">
                                        <option value="#activity_id#" title="#activity_name#"<cfif activity_id eq get_cat_detail.exp_activity_type_id>selected</cfif>>#activity_name#</option>
                                    </cfloop>
                                </select>	
                            </div>
                        </div>
                        <div class="form-group" id="item-exp_template_id">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='58822.Masraf Şablonu'></label>
                            <div class="col col-7 col-xs-12">
                                <select name="exp_template_id" id="exp_template_id" onchange="kontrol(2);">
                                    <option value=""></option>
                                    <cfloop query="get_expense_template_expense">
                                        <option value="#template_id#" title="#template_name#"<cfif template_id eq get_cat_detail.exp_template_id>selected</cfif>>#template_name#</option>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-gelir">
                            <label class="headbold font-red-sunglo col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='37236.Gelir Dağılım'></label>
                        </div>
                        <cfif isDefined("get_cat_detail.inc_center_id") and len(get_cat_detail.inc_center_id)>
                            <cfquery name="GET_INC_CENTER" datasource="#dsn2#">
                                SELECT EXPENSE_ID, EXPENSE FROM EXPENSE_CENTER where EXPENSE_ID = #get_cat_detail.inc_center_id# 
                            </cfquery>
                                <cfset glr_id  = GET_INC_CENTER.expense_id>
                            <cfset glr_name  = GET_INC_CENTER.expense>
                        <cfelse>
                            <cfset glr_id  = ''>
                            <cfset glr_name  = ''>
                        </cfif>    
                        <div class="form-group" id="item-inc_center_id">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='58172.Gelir Merkezi'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="inc_center_id" id="inc_center_id" value="#glr_id#" >
                                    <input type="text" name="expense1" id="expense1"  value="<cfif len(glr_name)>#glr_name#</cfif>" >
                                    <span class="input-group-addon icon-ellipsis btnPointer"  onclick="pencere_ac_exp('satir'); kontrol2(1);"></span>
                                </div>		
                            </div>
                        </div>
                        <cfif isDefined("get_cat_detail.inc_item_id") and len(get_cat_detail.inc_item_id)>
                            <cfquery name="GET_EXPENSE_INCOME" datasource="#dsn2#">
                                SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE INCOME_EXPENSE = 1 AND EXPENSE_ITEM_ID=#get_cat_detail.inc_item_id#
                            </cfquery>
                                <cfset klm_id  = GET_EXPENSE_INCOME.expense_item_id>
                            <cfset klm_name  = GET_EXPENSE_INCOME.expense_item_name>
                        <cfelse>
                            <cfset klm_id  = ''>
                            <cfset klm_name  = ''>
                        </cfif>    
                        <div class="form-group" id="item-inc_item_id">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='58173.Gelir Kalemi'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="inc_item_id" id="inc_item_id" value="#klm_id#" >
                                    <input type="text" name="expense_item_name1" id="expense_item_name1"  value="<cfif len(klm_name)>#klm_name#</cfif>">
                                    <span class="input-group-addon icon-ellipsis btnPointer"  onclick="pencere_ac_inc_exp('satir'); kontrol2(1);"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-INCOME_PROGRESS_CODE">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="37298.Gelir Muhasebe Kodu"></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.INCOME_PROGRESS_CODE)>
                                    <input type="text"  name="INCOME_PROGRESS_CODE" id="INCOME_PROGRESS_CODE" value="#get_cat_detail.INCOME_PROGRESS_CODE#" title="#acc_name#" onfocus="AutoComplete_Create('INCOME_PROGRESS_CODE','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('INCOME_PROGRESS_CODE');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-inc_activity_type_id">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37218.Aktivite Tipi'></label>
                            <div class="col col-7 col-xs-12">
                                <select name="inc_activity_type_id" id="inc_activity_type_id" onchange="kontrol2(1);">
                                    <option value=""></option>
                                    <cfloop query="get_activity_types">
                                        <option value="#activity_id#" title="#activity_name#"<cfif activity_id eq get_cat_detail.inc_activity_type_id>selected</cfif>>#activity_name#</option>
                                    </cfloop>
                                </select>	
                            </div>
                        </div>
                        <div class="form-group" id="item-inc_template_id">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id ='58823.Gelir Şablonu'></label>
                            <div class="col col-7 col-xs-12">
                                <select name="inc_template_id" id="inc_template_id" onchange="kontrol2(2);">
                                    <option value=""></option>
                                    <cfloop query="get_expense_template_income">
                                        <option value="#template_id#" title="template_name"<cfif template_id eq get_cat_detail.inc_template_id>selected</cfif>>#template_name#</option>
                                    </cfloop>
                                </select>	
                            </div>
                        </div>
                        <div class="form-group" id="item-sabit_kiymet">
                            <label class="headbold font-red-sunglo col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='58478.Sabit Kıymet'></label>
                        </div>
                        <div class="form-group" id="item-inventory_cat_id">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfif len(get_cat_detail.INVENTORY_CAT_ID)>
                                        <cfquery name="GET_INV_CAT" datasource="#dsn3#">
                                            SELECT INVENTORY_CAT FROM SETUP_INVENTORY_CAT WHERE INVENTORY_CAT_ID = #get_cat_detail.INVENTORY_CAT_ID#
                                        </cfquery>
                                        <cfset inv_cat = GET_INV_CAT.INVENTORY_CAT>
                                    <cfelse>
                                        <cfset inv_cat = "">
                                    </cfif>
                                    <input type="hidden" name="inventory_cat_id" id="inventory_cat_id" value="#get_cat_detail.INVENTORY_CAT_ID#">
                                    <input type="text" name="inventory_cat" id="inventory_cat" value="<cfif len(inv_cat)>#inv_cat#</cfif>">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_inventory_cat&field_id=pro_period_cat.inventory_cat_id&field_name=pro_period_cat.inventory_cat','list');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-INVENTORY_CODE">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.INVENTORY_CODE)>
                                    <input type="text"  name="INVENTORY_CODE" id="INVENTORY_CODE" value="#get_cat_detail.INVENTORY_CODE#" title="#acc_name#" onfocus="AutoComplete_Create('INVENTORY_CODE','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('INVENTORY_CODE');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-amortization_method_id">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='29420.Amortisman Yöntemi'></label>
                            <div class="col col-7 col-xs-12">
                                <select name="amortization_method_id" id="amortization_method_id">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="0" <cfif get_cat_detail.amortization_method_id eq 0>selected</cfif>><cf_get_lang dictionary_id='29421.Azalan Bakiye �zerinden'></option>
                                    <option value="1" <cfif get_cat_detail.amortization_method_id eq 1>selected</cfif>><cf_get_lang dictionary_id='29422.Sabit Miktar �zerinden'></option>
                                    <option value="2" <cfif get_cat_detail.amortization_method_id eq 2>selected</cfif>><cf_get_lang dictionary_id='29423.Hizlandirilmis Azalan Bakiye'></option>
                                    <option value="3" <cfif get_cat_detail.amortization_method_id eq 3>selected</cfif>><cf_get_lang dictionary_id='29424.Hizlandirilmis Sabit Deger'></option>
                                </select>	
                            </div>
                        </div>
                        <div class="form-group" id="item-amortization_type_id">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='29425.Amortisman Türü'></label>
                            <div class="col col-7 col-xs-12">
                                <select name="amortization_type_id" id="amortization_type_id">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <option value="1" <cfif get_cat_detail.amortization_type_id eq 1>selected</cfif>><cf_get_lang dictionary_id='29426.Kist Amortismana Tabi'></option>
                                    <option value="2" <cfif get_cat_detail.amortization_type_id eq 2>selected</cfif>><cf_get_lang dictionary_id='29427.Kist Amortismana Tabi Degil'></option>
                                </select>	
                            </div>
                        </div>
                        <div class="form-group" id="item-amortization_exp_center_id">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></label>
                            <div class="col col-7 col-xs-12">
                                <select name="amortization_exp_center_id" id="amortization_exp_center_id">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfloop query="get_expense_center_amrt">
                                    <option value="#expense_id#" title="#expense#" <cfif get_expense_center_amrt.expense_id eq get_cat_detail.AMORTIZATION_EXP_CENTER_ID>selected</cfif>>#expense#</option>
                                    </cfloop>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-amortization_exp_item_id">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='58551.Gider Kalemi'></label>
                            <div class="col col-7 col-xs-12">
                                <select name="amortization_exp_item_id" id="amortization_exp_item_id">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfloop query="get_expense_item_amrt">
                                        <option value="#expense_item_id#" title="#expense_item_name#" <cfif get_expense_item_amrt.expense_item_id eq get_cat_detail.amortization_exp_item_id>selected</cfif>>#expense_item_name#</option>
                                    </cfloop>
                                </select>	
                            </div>
                        </div>
                        <div class="form-group" id="item-amortization_code">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='58298.Birikmiş Amortisman'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.amortization_code)>
                                    <input type="text"  name="amortization_code" id="amortization_code" value="#get_cat_detail.amortization_code#" title="#acc_name#" onfocus="AutoComplete_Create('amortization_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('amortization_code');"></span>
                                </div>	
                            </div>
                        </div>
                        <div class="form-group" id="item-exe_vat_sale_invoice">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='49548.KDV den Muaf Satış Faturası'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <cfset acc_name = get_account_name(get_cat_detail.exe_vat_sale_invoice)>
                                    <input type="text"  name="exe_vat_sale_invoice" id="exe_vat_sale_invoice" value="#get_cat_detail.exe_vat_sale_invoice#" title="#acc_name#" onfocus="AutoComplete_Create('exe_vat_sale_invoice','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('exe_vat_sale_invoice');"></span>
                                </div>	
                            </div>
                        </div>
                            <!--- İstisna --->
                            <cffile action="read" file="#index_folder#admin_tools#dir_seperator#xml#dir_seperator#reason_codes.xml" variable="xmldosyam" charset = "UTF-8">
                            <cfset dosyam = XmlParse(xmldosyam)>
                            <cfset xml_dizi = dosyam.REASON_CODES.XmlChildren>
                            <cfset d_boyut = ArrayLen(xml_dizi)>
                            <cfset reason_code_list = "">
                            <cfloop index="abc" from="1" to="#d_boyut#">    	
                                <cfset reason_code_list = listappend(reason_code_list,'#dosyam.REASON_CODES.REASONS[abc].REASONS_CODE.XmlText#--#dosyam.REASON_CODES.REASONS[abc].REASONS_NAME.XmlText#','*')>
                            </cfloop>
                            <div class="form-group" id="item-reason_code">
                                <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='43458.İstisna Kodu'></label>
                                <div class="col col-7 col-xs-12">
                                    <select name="reason_code" id="reason_code">
                                        <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                        <cfloop list="#reason_code_list#" index="info_list" delimiters="*">
                                            <option value="#info_list#" <cfif get_cat_detail.reason_code eq info_list>selected</cfif>>#info_list#</option>
                                        </cfloop>
                                    </select>
                                </div>
                            </div>   
                        <!--- İstisna --->     
                        <div class="form-group" id="item-iskonto">
                            <label class="headbold font-red-sunglo col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='57641.İskonto'><cf_get_lang dictionary_id='54118.Gider Dağılım'></label>
                        </div> 
                        <cfif isDefined("get_cat_detail.discount_expense_center_id") and  len(get_cat_detail.discount_expense_center_id)>	
                            <cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
                                SELECT EXPENSE_ID, EXPENSE, EXPENSE_CODE FROM EXPENSE_CENTER WHERE EXPENSE_ID = #get_cat_detail.discount_expense_center_id#
                            </cfquery>
                            <cfset exp_id = get_expense_center.expense_id>
                            <cfset exp_name = get_expense_center.expense>
                        <cfelse>
                            <cfset exp_id = ''>
                            <cfset exp_name = ''>	
                        </cfif> 
                        <div class="form-group" id="item-discount_expense_center_id">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37112.Gider Merkezi'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="discount_expense_center_id" id="discount_expense_center_id" value="#exp_id#" />
                                    <input type="text" onChange="kontrol(1);" name="discount_expense_center_name" id="discount_expense_center_name"  value="<cfif isdefined("exp_name") and len(exp_name)>#exp_name#</cfif>" />
                                    <span class="input-group-addon icon-ellipsis btnPointer"  onclick="pencere_ac_discount_exp('satir');"></span>
                                </div>    
                            </div> 
                        </div>    
                        <cfif isdefined("get_cat_detail.discount_expense_item_id") and len(get_cat_detail.discount_expense_item_id)>
                            <cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
                                SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 And EXPENSE_ITEM_ID = #get_cat_detail.discount_expense_item_id#
                            </cfquery>
                            <cfset item_id = get_expense_item.expense_item_id>
                            <cfset item_name  = get_expense_item.expense_item_name>
                        <cfelse>
                            <cfset item_id = ''>
                            <cfset item_name = ''>
                        </cfif>	
                        <div class="form-group" id="item-discount_expense_item_id">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='58551.Gider Kalemi'></label>
                            <div class="col col-7 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="discount_expense_item_id" id="discount_expense_item_id" value="#item_id#" />
                                    <input type="text" onChange="kontrol(1);" name="discount_expense_item_name" id="discount_expense_item_name" value="<cfif isdefined("item_name") and len(item_name)> #item_name# </cfif>"/>
                                    <span class="input-group-addon icon-ellipsis btnPointer"  onclick="pencere_ac_discount_item('satir');"></span>
                                </div>
                            </div>    
                        </div>    
                        <div class="form-group" id="item-discount_activity_type">
                            <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37218.Aktivite Tipi'></label>
                            <div class="col col-7 col-xs-12">
                                <cfif isdefined("get_cat_detail")><cfset discount_activity_type_id = get_cat_detail.discount_activity_type_id><cfelse><cfset discount_activity_type_id = ''></cfif>
                                <select name="discount_activity_type" id="discount_activity_type" onchange="kontrol(1);">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfloop query="get_activity_types">
                                        <option value="#activity_id#" title="#activity_name#"<cfif activity_id eq discount_activity_type_id>selected</cfif>>#activity_name#</option>
                                    </cfloop>
                                </select>
                            </div>
                        </div>    
                    </div>
                </cfoutput>
            </cf_box_elements>
            <div class="ui-form-list-btn">
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <cf_record_info query_name="get_cat_detail">
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <cf_workcube_buttons type_format='1' is_upd='1' delete_page_url='#request.self#?fuseaction=product.emptypopup_del_pro_per_cat&cat_id=#attributes.cat_id#&head=#get_cat_detail.PRO_CODE_CAT_NAME#'>
                </div>
            </div>
    
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	function pencere_ac(isim)
	{
		temp_account_code = eval('document.pro_period_cat.'+isim);
		if (temp_account_code.value.length >= 3)
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_id=pro_period_cat.'+isim+'&account_code=' + temp_account_code.value+'&is_title=1'</cfoutput>, 'list');
		else
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_id=pro_period_cat.'+isim+'&is_title=1'</cfoutput>, 'list');
	}
	function kontrol(degerid)
	{
		if(degerid == 1)
		{
			document.pro_period_cat.exp_template_id.selectedIndex = 0;
		}
		else
		{
			document.pro_period_cat.expense.value = ""; 
            document.pro_period_cat.exp_center_id.value = "";
            document.pro_period_cat.expense_item_name.value=""; 
            document.pro_period_cat.exp_item_id.value = ""; 
			document.pro_period_cat.exp_activity_type_id.selectedIndex = 0;
		}
	}
	function kontrol2(degerid)
	{
		if(degerid == 1)
		{
			document.pro_period_cat.inc_template_id.selectedIndex = 0;
		}
		else
		{
			document.pro_period_cat.inc_center_id.value = "";
            document.pro_period_cat.expense1.value = "";
			document.pro_period_cat.inc_item_id.value = "";
            document.pro_period_cat.expense_item_name1.value="";
			document.pro_period_cat.inc_activity_type_id.selectedIndex = 0;
		}
    }
    function pencere_ac_exp_center(satir)
    {
        windowopen('index.cfm?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=pro_period_cat.exp_center_id&field_name=pro_period_cat.expense&is_invoice=1','list');
    }
    function pencere_ac_expence_center(satir)
    {
        windowopen('index.cfm?fuseaction=objects.popup_list_exp_item&field_id=pro_period_cat.exp_item_id&field_name=pro_period_cat.expense_item_name&is_expence=1','list');
    } 
    function pencere_ac_exp(satir)
    {
        windowopen('index.cfm?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=pro_period_cat.inc_center_id&field_name=pro_period_cat.expense1&is_invoice=1','list');
    }
    function pencere_ac_inc_exp(satir)
    {
        windowopen('index.cfm?fuseaction=objects.popup_list_exp_item&field_id=pro_period_cat.inc_item_id&field_name=pro_period_cat.expense_item_name1&is_income=1','list');
    } 
       function pencere_ac_discount_exp(satir)
    {
        windowopen('index.cfm?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=pro_period_cat.discount_expense_center_id&field_name=pro_period_cat.discount_expense_center_name&is_invoice=1','list');
    }
    function pencere_ac_discount_item(satir)
    {
        windowopen('index.cfm?fuseaction=objects.popup_list_exp_item&field_id=pro_period_cat.discount_expense_item_id&field_name=pro_period_cat.discount_expense_item_name&is_expence=1','list');
    } 
</script>
<br/>
