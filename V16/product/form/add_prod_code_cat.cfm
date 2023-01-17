<cfquery name="GET_EXPENSE_ITEM_AMRT" datasource="#dsn2#">
	SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 ORDER BY EXPENSE_ITEM_NAME
</cfquery> 
<cfquery name="GET_EXPENSE_CENTER_AMRT" datasource="#dsn2#">
	SELECT EXPENSE_ID, EXPENSE FROM EXPENSE_CENTER ORDER BY  EXPENSE
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
    <cfif isDefined('attributes.cat_id') and len(attributes.cat_id)>
        <cfquery name="GET_CAT_DETAIL" datasource="#dsn3#">
            SELECT * FROM SETUP_PRODUCT_PERIOD_CAT WHERE PRO_CODE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cat_id#">
        </cfquery>
    </cfif>
     <cfform name="pro_period_cat" method="post" action="#request.self#?fuseaction=product.add_prod_code_cat">
        <cf_box_elements>
            <cfoutput>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="1" type="column" sort="true">
                    <div class="form-group" id="item-is_active">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
                        <div class="col col-7 col-xs-12">
                            <input type="checkbox" name="is_active" id="is_active" value="1" checked>
                        </div>
                    </div>
                    <div class="form-group" id="item-PRO_CODE_CAT_NAME">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='58969.Grup Adı'> *</label>
                        <div class="col col-7 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='37447.Grup Adı Girmelisiniz'></cfsavecontent>
                            <cfif isdefined("get_cat_detail")><cfset group_name = get_cat_detail.PRO_CODE_CAT_NAME><cfelse><cfset group_name = ''></cfif>
                            <cfinput type="Text" name="PRO_CODE_CAT_NAME" value="#group_name#" maxlength="100" required="Yes" message="#message#">	
                        </div>
                    </div>
                    <div class="form-group" id="item-account_code_sale">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37368.Satış Hesabı'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset account_code_sale = get_cat_detail.ACCOUNT_CODE><cfelse><cfset account_code_sale = ''></cfif>
                                <input type="text" name="account_code_sale" id="account_code_sale" value="#account_code_sale#" onfocus="AutoComplete_Create('account_code_sale','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off" />
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('account_code_sale');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-account_code_purchase">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37369.Alış Hesabı'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset account_code_purchase = get_cat_detail.account_code_pur><cfelse><cfset account_code_purchase = ''></cfif>
                                <input type="text" name="account_code_purchase" id="account_code_purchase" value="#account_code_purchase#" onfocus="AutoComplete_Create('account_code_purchase','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('account_code_purchase');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-INCOMING_STOCK">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='60299.Gelen Yoldaki Stok(Alış)'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset incoming_stock = get_cat_detail.INCOMING_STOCK><cfelse><cfset incoming_stock = ''></cfif>
                                <input type="text" name="incoming_stock" id="incoming_stock" value="#incoming_stock#" onfocus="AutoComplete_Create('incoming_stock','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off" />
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('incoming_stock');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-OUTGOING_STOCK">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='60300.Giden Yoldaki Stok(Satış)'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset outgoing_stock = get_cat_detail.OUTGOING_STOCK><cfelse><cfset outgoing_stock = ''></cfif>
                                <input type="text" name="outgoing_stock" id="outgoing_stock" value="#outgoing_stock#" onfocus="AutoComplete_Create('outgoing_stock','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off" />
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('outgoing_stock');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-account_discount">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37459.Satış İskonto'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset account_discount = get_cat_detail.ACCOUNT_DISCOUNT><cfelse><cfset account_discount = ''></cfif>
                                <input type="text" name="account_discount" id="account_discount" value="#account_discount#" onfocus="AutoComplete_Create('account_discount','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('account_discount');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-account_discount_pur">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37464.Alış İskonto'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset account_discount_pur = get_cat_detail.ACCOUNT_DISCOUNT_PUR><cfelse><cfset account_discount_pur = ''></cfif>
                                <input type="text" name="account_discount_pur" id="account_discount_pur" value="#account_discount_pur#"onfocus="AutoComplete_Create('account_discount_pur','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('account_discount_pur');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-account_iade">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37462.Satış İade'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset account_iade = get_cat_detail.ACCOUNT_IADE><cfelse><cfset account_iade = ''></cfif>
                                <input type="text" name="account_iade"  id="account_iade" value="#account_iade#" onfocus="AutoComplete_Create('account_iade','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('account_iade');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-account_pur_iade">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37461.Alış İade'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset account_pur_iade = get_cat_detail.ACCOUNT_PUR_IADE><cfelse><cfset account_pur_iade = ''></cfif>
                                <input type="text" name="account_pur_iade" id="account_pur_iade" value="#account_pur_iade#"onfocus="AutoComplete_Create('account_pur_iade','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('account_pur_iade');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-account_price">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37749.Satış Fiyat Farkı'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset account_price = get_cat_detail.ACCOUNT_PRICE><cfelse><cfset account_price = ''></cfif>
                                <input type="text" name="account_price" id="account_price" value="#account_price#"onfocus="AutoComplete_Create('account_price','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('account_price');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-ACCOUNT_PRICE_PUR">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id ='37750.Alış Fiyat Farkı'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset ACCOUNT_PRICE_PUR = get_cat_detail.ACCOUNT_PRICE_PUR><cfelse><cfset ACCOUNT_PRICE_PUR = ''></cfif>
                                <input type="text" name="ACCOUNT_PRICE_PUR" id="ACCOUNT_PRICE_PUR" value="#ACCOUNT_PRICE_PUR#"onfocus="AutoComplete_Create('ACCOUNT_PRICE_PUR','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('ACCOUNT_PRICE_PUR');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-account_exportregistered">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='60998.İhraç Kayıtlı Satış'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset account_exportregistered = get_cat_detail.ACCOUNT_EXPORTREGISTERED><cfelse><cfset account_exportregistered = ''></cfif>
                                <input type="text" name="account_exportregistered" id="account_exportregistered" value="#account_exportregistered#"onfocus="AutoComplete_Create('account_exportregistered','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off" />
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('account_exportregistered');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-account_yurtdisi">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37463.Yurtdışı Satış'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset account_yurtdisi = get_cat_detail.ACCOUNT_YURTDISI><cfelse><cfset account_yurtdisi = ''></cfif>
                                <input type="text" name="account_yurtdisi" id="account_yurtdisi" value="#account_yurtdisi#"onfocus="AutoComplete_Create('account_yurtdisi','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off" />
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('account_yurtdisi');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-account_yurtdisi_pur">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37465.Yurtdışı Alış'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset account_yurtdisi_pur = get_cat_detail.ACCOUNT_YURTDISI_PUR><cfelse><cfset account_yurtdisi_pur = ''></cfif>
                                <input type="text" name="account_yurtdisi_pur" id="account_yurtdisi_pur" value="#account_yurtdisi_pur#"onfocus="AutoComplete_Create('account_yurtdisi_pur','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('account_yurtdisi_pur');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-material_code_sale">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37498.Hammadde'><cf_get_lang dictionary_id='57448.Satis'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset material_code_sale = get_cat_detail.MATERIAL_CODE_SALE><cfelse><cfset material_code_sale = ''></cfif>
                                <input type="text"  name="material_code_sale" id="material_code_sale" value="#material_code_sale#"onfocus="AutoComplete_Create('material_code_sale','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('material_code_sale');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-material_code">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37498.Hammadde'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset material_code = get_cat_detail.MATERIAL_CODE><cfelse><cfset material_code = ''></cfif>
                                <input type="text"  name="material_code" id="material_code" value="#material_code#"onfocus="AutoComplete_Create('material_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('material_code');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-account_loss">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37483.Fireler'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset account_loss = get_cat_detail.ACCOUNT_LOSS><cfelse><cfset account_loss = ''></cfif>
                                <input type="text" name="account_loss" id="account_loss" value="#account_loss#"onfocus="AutoComplete_Create('account_loss','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('account_loss');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-account_expenditure">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='30009.Sarflar'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset account_expenditure = get_cat_detail.ACCOUNT_EXPENDITURE><cfelse><cfset account_expenditure = ''></cfif>
                                <input type="text" name="account_expenditure" id="account_expenditure" value="#account_expenditure#"onfocus="AutoComplete_Create('account_expenditure','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('account_expenditure');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-over_count">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='57753.Sayım Fazlası'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset over_count = get_cat_detail.OVER_COUNT><cfelse><cfset over_count = ''></cfif>
                                <input type="text" name="over_count" id="over_count" value="#over_count#"onfocus="AutoComplete_Create('over_count','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('over_count');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-under_count">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='57754.Sayım Eksiği'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset under_count = get_cat_detail.UNDER_COUNT><cfelse><cfset under_count = ''></cfif>
                                <input type="text" name="under_count" id="under_count" value="#under_count#"onfocus="AutoComplete_Create('under_count','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('under_count');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-production_cost_sale">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37458.Mamül'><cf_get_lang dictionary_id='57448.Satis'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset production_cost_sale = get_cat_detail.PRODUCTION_COST_SALE><cfelse><cfset production_cost_sale = ''></cfif>
                                <input type="text" id="production_cost_sale" name="production_cost_sale" value="#production_cost_sale#" onfocus="AutoComplete_Create('production_cost_sale','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('production_cost_sale');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-production_cost">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='57456.Üretim'>/<cf_get_lang dictionary_id='37458.Mamül'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset production_cost = get_cat_detail.PRODUCTION_COST><cfelse><cfset production_cost = ''></cfif>
                                <input type="text" id="production_cost" name="production_cost" value="#production_cost#" onfocus="AutoComplete_Create('production_cost','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('production_cost');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-half_production_cost">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='57456.Üretim'>/<cf_get_lang dictionary_id='37473.Yarı Mamül'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset half_production_cost = get_cat_detail.half_production_cost><cfelse><cfset half_production_cost = ''></cfif>
                                <input type="text" name="half_production_cost" id="half_production_cost" value="#half_production_cost#" onfocus="AutoComplete_Create('half_production_cost','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('half_production_cost');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-sale_product_cost">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37474.Satılan Malın Maliyeti'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset sale_product_cost = get_cat_detail.SALE_PRODUCT_COST><cfelse><cfset sale_product_cost = ''></cfif>
                                <input type="text" name="sale_product_cost" id="sale_product_cost" value="#sale_product_cost#"onfocus="AutoComplete_Create('sale_product_cost','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('sale_product_cost');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-sale_manufactured_cost">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="59119.Satılan Mamülün Maliyeti"></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset sale_manufactured_cost = get_cat_detail.SALE_MANUFACTURED_COST><cfelse><cfset sale_manufactured_cost = ''></cfif>
                                <input type="text" name="sale_manufactured_cost" id="sale_manufactured_cost" value="#sale_manufactured_cost#"onfocus="AutoComplete_Create('sale_manufactured_cost','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('sale_manufactured_cost');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-konsinye_pur_code">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37505.Konsinye Alış Hesabı'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset konsinye_pur_code = get_cat_detail.KONSINYE_PUR_CODE><cfelse><cfset konsinye_pur_code = ''></cfif>
                                <input type="text" name="konsinye_pur_code" id="konsinye_pur_code" value="#konsinye_pur_code#"onfocus="AutoComplete_Create('konsinye_pur_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('konsinye_pur_code');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-konsinye_sale_code">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37506.Diger Satış Hesabı'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset konsinye_sale_code = get_cat_detail.KONSINYE_SALE_CODE><cfelse><cfset konsinye_sale_code = ''></cfif>
                                <input type="text" name="konsinye_sale_code" id="konsinye_sale_code" value="#konsinye_sale_code#"onfocus="AutoComplete_Create('konsinye_sale_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('konsinye_sale_code');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-konsinye_sale_naz_code">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37508.Diger Satış Nazım Hesabı'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset konsinye_sale_naz_code = get_cat_detail.KONSINYE_SALE_NAZ_CODE><cfelse><cfset konsinye_sale_naz_code = ''></cfif>
                                <input type="text" name="konsinye_sale_naz_code" id="konsinye_sale_naz_code" value="#konsinye_sale_naz_code#" onfocus="AutoComplete_Create('konsinye_sale_naz_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('konsinye_sale_naz_code');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-get_progress_code">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="37034.Alınan Hakediş Muhasebe Kodu"></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset get_progress_code = get_cat_detail.RECEIVED_PROGRESS_CODE><cfelse><cfset get_progress_code = ''></cfif>
                                <input type="text" name="get_progress_code" id="get_progress_code" value="#get_progress_code#" onfocus="AutoComplete_Create('get_progress_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('get_progress_code');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-submitted_progress_code">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="37036.Verilen Hakediş Muhasebe Kodu"></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset submitted_progress_code = get_cat_detail.PROVIDED_PROGRESS_CODE><cfelse><cfset submitted_progress_code = ''></cfif>
                                <input type="text" name="submitted_progress_code" id="submitted_progress_code" value="#submitted_progress_code#" onfocus="AutoComplete_Create('submitted_progress_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('submitted_progress_code');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-scrap_code_sale">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="37093.Hurda Hesabı"><cf_get_lang dictionary_id='57448.Satis'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset scrap_code_sale = get_cat_detail.SCRAP_CODE_SALE><cfelse><cfset scrap_code_sale = ''></cfif>
                                <input type="text" name="scrap_code_sale" id="scrap_code_sale" value="#scrap_code_sale#" onfocus="AutoComplete_Create('scrap_code_sale','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('scrap_code_sale');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-scrap_code">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="37093.Hurda Hesabı"></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset scrap_code = get_cat_detail.SCRAP_CODE><cfelse><cfset scrap_code = ''></cfif>
                                <input type="text" name="scrap_code" id="scrap_code" value="#scrap_code#" onfocus="AutoComplete_Create('scrap_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('scrap_code');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-dimm_code">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id ='37751.D İ Mad Malz Hesabı'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset dimm_code = get_cat_detail.DIMM_CODE><cfelse><cfset dimm_code = ''></cfif>
                                <input type="text" name="dimm_code" id="dimm_code" value="#dimm_code#"onfocus="AutoComplete_Create('dimm_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('dimm_code');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-dimm_yans_code">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id ='37752.D İ Mad Malz Yans Hesabı'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset dimm_yans_code = get_cat_detail.DIMM_YANS_CODE><cfelse><cfset dimm_yans_code = ''></cfif>
                                <input type="text" name="dimm_yans_code" id="dimm_yans_code" value="#dimm_yans_code#"onfocus="AutoComplete_Create('dimm_yans_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('dimm_yans_code');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-promotion_code">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37559.Promosyon Hesabı'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset promotion_code = get_cat_detail.PROMOTION_CODE><cfelse><cfset promotion_code = ''></cfif>
                                <input type="text" name="promotion_code" id="promotion_code" value="#promotion_code#" onfocus="AutoComplete_Create('promotion_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('promotion_code');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-prod_general_code">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="37019.Genel Üretim Giderleri Yansıtma Hesabı"></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset prod_general_code = get_cat_detail.PROD_GENERAL_CODE><cfelse><cfset prod_general_code = ''></cfif>
                                <input type="text" name="prod_general_code" id="prod_general_code" value="#prod_general_code#" onfocus="AutoComplete_Create('prod_general_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('prod_general_code');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-prod_labor_cost_code">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="37033.Üretim İşçilik Yansıtma Hesabı"></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset prod_labor_cost_code = get_cat_detail.PROD_LABOR_COST_CODE><cfelse><cfset prod_labor_cost_code = ''></cfif>
                                <input type="text" name="prod_labor_cost_code" id="prod_labor_cost_code" value="#prod_labor_cost_code#" onfocus="AutoComplete_Create('prod_labor_cost_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('prod_labor_cost_code');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-7 col-xs-12">
                            <cfif isdefined("get_cat_detail")><cfset detail = get_cat_detail.DETAIL><cfelse><cfset detail = ''></cfif>
                            <textarea name="detail" id="detail">#detail#</textarea>	
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" index="2" type="column" sort="true">
                    <div class="form-group" id="item-gider">
                        <label class="headbold font-red-sunglo col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='37047.Gider Dağılım'></label>
                    </div>
                    <cfif isDefined("get_cat_detail.exp_center_id") and len(get_cat_detail.exp_center_id)>
                        <cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
                            SELECT EXPENSE_ID, EXPENSE FROM EXPENSE_CENTER where EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_cat_detail.exp_center_id#">
                        </cfquery>
                        <cfset expcntr_id  = GET_EXPENSE_CENTER.EXPENSE_ID>
                        <cfset expcntr_name  = GET_EXPENSE_CENTER.EXPENSE>
                    <cfelse>
                        <cfset expcntr_id  = ''>
                        <cfset expcntr_name  = ''>
                    </cfif>    
                    <div class="form-group" id="item-exp_center_id">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37112.Gider Merkezi'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="exp_center_id" id="exp_center_id" value="#expcntr_id#" >
                                <input type="text"  name="expense" id="expense"  value="#expcntr_name#">
                                <span class="input-group-addon icon-ellipsis btnPointer"  onclick="pencere_ac_exp_center('satir');"></span>
                            </div>                                    	
                        </div>
                    </div>     
                    <cfif isDefined("get_cat_detail.exp_item_id") and len(get_cat_detail.exp_item_id)>
                        <cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
                            SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 AND EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_cat_detail.exp_item_id#">
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
                            <cfif isdefined("get_cat_detail")><cfset exp_item_id = get_cat_detail.exp_item_id><cfelse><cfset exp_item_id = ''></cfif>
                                <div class="input-group">
                                    <input type="hidden" name="exp_item_id" id="exp_item_id" value="#exp_id#">
                                    <input type="text" name="expense_item_name" id="expense_item_name" value="<cfif len(exp_name)>#exp_name#</cfif>">
                                    <span class="input-group-addon icon-ellipsis btnPointer"  onclick="pencere_ac_expence_center('satir');"></span>
                                </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-EXPENSE_PROGRESS_CODE">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="37297.Gider Muhasebe Kodu"></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset EXPENSE_PROGRESS_CODE = get_cat_detail.EXPENSE_PROGRESS_CODE><cfelse><cfset EXPENSE_PROGRESS_CODE = ''></cfif>
                                <input type="text"  name="EXPENSE_PROGRESS_CODE" id="EXPENSE_PROGRESS_CODE" value="#EXPENSE_PROGRESS_CODE#" onfocus="AutoComplete_Create('EXPENSE_PROGRESS_CODE','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
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
                                    <option value="#activity_id#" title="#activity_name#"<cfif activity_id eq exp_activity_type_id>selected</cfif>>#activity_name#</option>
                                </cfloop>
                            </select>	
                        </div>
                    </div>
                    <div class="form-group" id="item-exp_template_id">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='58822.Masraf Şablonu'></label>
                        <div class="col col-7 col-xs-12">
                            <cfif isdefined("get_cat_detail")><cfset exp_template_id = get_cat_detail.exp_template_id><cfelse><cfset exp_template_id = ''></cfif>
                            <select name="exp_template_id" id="exp_template_id" onchange="kontrol(2);">
                                <option value=""></option>
                                <cfloop query="get_expense_template_expense">
                                    <option value="#template_id#" title="#template_name#"<cfif template_id eq exp_template_id>selected</cfif>>#template_name#</option>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-gelir">
                        <label class="headbold font-red-sunglo col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang dictionary_id='37236.Gelir Dağılım'></label>
                    </div>
                    <cfif isDefined("get_cat_detail.inc_center_id") and len(get_cat_detail.inc_center_id)>
                        <cfquery name="GET_INC_CENTER" datasource="#dsn2#">
                            SELECT EXPENSE_ID, EXPENSE FROM EXPENSE_CENTER where EXPENSE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_cat_detail.inc_center_id#"> 
                        </cfquery>
                        <cfset inc_id  = GET_INC_CENTER.EXPENSE_ID>
                        <cfset inc_name  = GET_INC_CENTER.EXPENSE>
                    <cfelse>
                        <cfset inc_id  = ''>
                        <cfset inc_name  = ''>
                    </cfif>
                    <div class="form-group" id="item-inc_center_id">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='58172.Gelir Merkezi'></label>
                        <div class="col col-7 col-xs-12">
                            <cfif isdefined("get_cat_detail")><cfset inc_center_id = get_cat_detail.inc_center_id><cfelse><cfset inc_center_id = ''></cfif>
                            <div class="input-group">
                                <input type="hidden" name="inc_center_id" id="inc_center_id" value="#inc_id#" >
                                <input type="text"  name="expense1" id="expense1"  value="#inc_name#">
                                <span class="input-group-addon icon-ellipsis btnPointer"  onclick="pencere_ac_exp('satir');"></span>
                            </div>
                        </div>
                    </div>
                    <cfif isDefined("get_cat_detail.inc_item_id") and len(get_cat_detail.inc_item_id)>
                        <cfquery name="GET_EXPENSE_INCOME" datasource="#dsn2#">
                            SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE INCOME_EXPENSE = 1 AND EXPENSE_ITEM_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#get_cat_detail.inc_item_id#">
                        </cfquery>
                        <cfset inc_id  = GET_EXPENSE_INCOME.expense_item_id>
                        <cfset inc_name  = GET_EXPENSE_INCOME.expense_item_name>
                    <cfelse>
                        <cfset inc_id  = ''>
                        <cfset inc_name  = ''>
                    </cfif>
                    <div class="form-group" id="item-inc_item_id">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='58173.Gelir Kalemi'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="inc_item_id" id="inc_item_id" value="#inc_id#" >
                                <input type="text"  name="expense_item_name1" id="expense_item_name1"  value="#inc_name#">
                                <span class="input-group-addon icon-ellipsis btnPointer"  onclick="pencere_ac_inc_exp('satir');"></span>
                            </div>                                    
                        </div>
                    </div>
                    <div class="form-group" id="item-INCOME_PROGRESS_CODE">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="37298.Gelir Muhasebe Kodu"></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset INCOME_PROGRESS_CODE = get_cat_detail.INCOME_PROGRESS_CODE><cfelse><cfset INCOME_PROGRESS_CODE = ''></cfif>
                                <input type="text"  name="INCOME_PROGRESS_CODE" id="INCOME_PROGRESS_CODE" value="#INCOME_PROGRESS_CODE#" onfocus="AutoComplete_Create('INCOME_PROGRESS_CODE','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('INCOME_PROGRESS_CODE');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-inc_activity_type_id">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='37218.Aktivite Tipi'></label>
                        <div class="col col-7 col-xs-12">
                            <cfif isdefined("get_cat_detail")><cfset inc_activity_type_id = get_cat_detail.inc_activity_type_id><cfelse><cfset inc_activity_type_id = ''></cfif>
                            <select name="inc_activity_type_id" id="inc_activity_type_id" onchange="kontrol2(1);" onfocus="AutoComplete_Create('account_discount_pur','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <option value=""></option>
                                <cfloop query="get_activity_types">
                                    <option value="#activity_id#" title="#activity_name#"<cfif activity_id eq inc_activity_type_id>selected</cfif>>#activity_name#</option>
                                </cfloop>
                            </select>	
                        </div>
                    </div>
                    <div class="form-group" id="item-inc_template_id">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='58823.Gelir Şablonu'></label>
                        <div class="col col-7 col-xs-12">
                            <cfif isdefined("get_cat_detail")><cfset inc_template_id = get_cat_detail.inc_template_id><cfelse><cfset inc_template_id = ''></cfif>
                            <select name="inc_template_id" id="inc_template_id" onchange="kontrol2(2);">
                                <option value=""></option>
                                <cfloop query="get_expense_template_income">
                                    <option value="#template_id#" title="template_name"<cfif template_id eq inc_template_id>selected</cfif>>#template_name#</option>
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
                                <cfif isdefined("get_cat_detail")><cfset inventory_cat_id = get_cat_detail.INVENTORY_CAT_ID><cfelse><cfset inventory_cat_id = ''></cfif>
                                <cfif len(inventory_cat_id)>
                                    <cfquery name="GET_INV_CAT" datasource="#dsn3#">
                                        SELECT INVENTORY_CAT FROM SETUP_INVENTORY_CAT WHERE INVENTORY_CAT_ID = #inventory_cat_id#
                                    </cfquery>
                                    <cfset inv_cat = GET_INV_CAT.INVENTORY_CAT>
                                <cfelse>
                                    <cfset inv_cat = "">
                                </cfif>
                                <input type="hidden" name="inventory_cat_id" id="inventory_cat_id" value="#inventory_cat_id#">
                                <input type="text" name="inventory_cat" id="inventory_cat" value="<cfif len(inv_cat)>#inv_cat#</cfif>">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_inventory_cat&field_id=pro_period_cat.inventory_cat_id&field_name=pro_period_cat.inventory_cat','list');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-INVENTORY_CODE">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset INVENTORY_CODE = get_cat_detail.INVENTORY_CODE><cfelse><cfset INVENTORY_CODE = ''></cfif>
                                <input type="text"  name="INVENTORY_CODE" id="INVENTORY_CODE" value="#INVENTORY_CODE#" onfocus="AutoComplete_Create('INVENTORY_CODE','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('INVENTORY_CODE');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-amortization_method_id">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='29420.Amortisman Yöntemi'></label>
                        <div class="col col-7 col-xs-12">
                            <cfif isdefined("get_cat_detail")><cfset amortization_method_id = get_cat_detail.amortization_method_id><cfelse><cfset amortization_method_id = ''></cfif>
                            <select name="amortization_method_id" id="amortization_method_id">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="0" <cfif amortization_method_id eq 0>selected</cfif>><cf_get_lang dictionary_id='29421.Azalan Bakiye Üzerinden'></option>
                                <option value="1" <cfif amortization_method_id eq 1>selected</cfif><cf_get_lang dictionary_id='29422.Sabit Miktar Üzerinden'></option>
                                <option value="2" <cfif amortization_method_id eq 2>selected</cfif>><cf_get_lang dictionary_id='29423.Hızlandırılmış Azalan Bakiye'></option>
                                <option value="3" <cfif amortization_method_id eq 3>selected</cfif>><cf_get_lang dictionary_id='29424.Hızlandırılmış Sabit Değer'></option>
                            </select>	
                        </div>
                    </div>
                    <div class="form-group" id="item-amortization_type_id">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='29425.Amortisman Türü'></label>
                        <div class="col col-7 col-xs-12">
                            <cfif isdefined("get_cat_detail")><cfset amortization_type_id = get_cat_detail.amortization_type_id><cfelse><cfset amortization_type_id = ''></cfif>
                            <select name="amortization_type_id" id="amortization_type_id">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <option value="1" <cfif amortization_type_id eq 1>selected</cfif>><cf_get_lang dictionary_id='29426.Kıst Amortismana Tabi'></option>
                                <option value="2" <cfif amortization_type_id eq 2>selected</cfif>><cf_get_lang dictionary_id='29427.Kıst Amortismana Tabi Değil'></option>
                            </select>	
                        </div>
                    </div>
                    <div class="form-group" id="item-amortization_exp_center_id">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></label>
                        <div class="col col-7 col-xs-12">
                            <cfif isdefined("get_cat_detail")><cfset amortization_exp_center_id = get_cat_detail.AMORTIZATION_EXP_CENTER_ID><cfelse><cfset amortization_exp_center_id = ''></cfif>
                            <select name="amortization_exp_center_id" id="amortization_exp_center_id">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfloop query="get_expense_center_amrt">
                                <option value="#expense_id#" title="#expense#" <cfif get_expense_center_amrt.expense_id eq amortization_exp_center_id>selected</cfif>>#expense#</option>
                            </cfloop>
                            </select>	
                        </div>
                    </div>
                    <div class="form-group" id="item-amortization_exp_item_id">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='58551.Gider Kalemi'></label>
                        <div class="col col-7 col-xs-12">
                            <cfif isdefined("get_cat_detail")><cfset amortization_exp_item_id = get_cat_detail.amortization_exp_item_id><cfelse><cfset amortization_exp_item_id = ''></cfif>
                            <select name="amortization_exp_item_id" id="amortization_exp_item_id">
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfloop query="get_expense_item_amrt">
                                <option value="#expense_item_id#" title="#expense_item_name#" <cfif get_expense_item_amrt.expense_item_id eq amortization_exp_item_id>selected</cfif>>#expense_item_name#</option>
                            </cfloop>
                            </select>	
                        </div>
                    </div>
                    <div class="form-group" id="item-amortization_code">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='58298.Birikmiş Amortisman'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset amortization_code = get_cat_detail.amortization_code><cfelse><cfset amortization_code = ''></cfif>
                                <input type="text"  name="amortization_code" value="#amortization_code#" id="amortization_code" onfocus="AutoComplete_Create('amortization_code','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac('amortization_code');"></span>
                            </div>	
                        </div>
                    </div>
                    <div class="form-group" id="item-exe_vat_sale_invoice">
                        <label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='49548.KDV den Muaf Satış Faturası'></label>
                        <div class="col col-7 col-xs-12">
                            <div class="input-group">
                                <cfif isdefined("get_cat_detail")><cfset exe_vat_sale_invoice = get_cat_detail.exe_vat_sale_invoice><cfelse><cfset exe_vat_sale_invoice = ''></cfif>
                                <input type="text"  name="exe_vat_sale_invoice" id="exe_vat_sale_invoice" value="#exe_vat_sale_invoice#" onfocus="AutoComplete_Create('exe_vat_sale_invoice','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','','','pro_period_cat','3','150');" autocomplete="off">
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
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfloop list="#reason_code_list#" index="info_list" delimiters="*">
                                    <option value="#info_list#">#info_list#</option>
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
            <cf_workcube_buttons is_upd='0'>
        </div>
              
    </cfform>
</cf_box>
</div>				  
<script type="text/javascript">
	function pencere_ac(isim)
	{
		temp_account_code = eval('document.pro_period_cat.'+isim);
		if (temp_account_code.value.length >= 3)
			windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_id=pro_period_cat.'+isim+'&account_code=' + temp_account_code.value +'&is_title=1'</cfoutput>, 'list');
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
			document.pro_period_cat.exp_center_id.selectedIndex = 0;
			document.pro_period_cat.exp_item_id.selectedIndex = 0;
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
			document.pro_period_cat.inc_center_id.selectedIndex = 0;
			document.pro_period_cat.inc_item_id.selectedIndex = 0;
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
