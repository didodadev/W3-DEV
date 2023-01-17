<cfparam name="MAXIMUM_STOCK" default="">
<cfparam name="PROVISION_TIME" default="">
<cfparam name="REPEAT_STOCK_VALUE" default="">
<cfparam name="block_stock_value" default="">
<cfparam name="saleable_stock_action_id" default="">
<cfparam name="MINIMUM_STOCK" default="">
<cfparam name="MINIMUM_ORDER_STOCK_VALUE" default="">
<cfparam name="MINIMUM_ORDER_UNIT_ID" default="">
<cfparam name="IS_LIVE_ORDER" default="">
<cfparam name="STRATEGY_TYPE" default="">
<cfparam name="STRATEGY_ORDER_TYPE" default="">
<cfparam name="otv" default="0">
<cfparam name="dimention" default="">
<cfparam name="weight" default="">
<cfparam name="project_id_" default="">
<cfparam name="project_head_" default="">
<cfparam name="main_unit_id" default="0">
<cfparam name="is_ship_unit" default="0">
<cfparam name="tax_purchase" default="0">
<cfparam name="tax_s" default="0">
<cfparam name="max_margin" default="0">
<cfparam name="min_margin" default="0">
<cfparam name="product_detail" default="">
<cfparam name="barcod" default="">
<cfparam name="product_code_2" default="">
<cfparam name="product_manager" default="">
<cfparam name="product_manager_name" default="">
<cfparam name="prod_comp" default="0">
<cfparam name="segment_id" default="0">
<cfparam name="product_name" default="">
<cfparam name="product_catid" default="">
<cfparam name="product_cat" default="">
<cfparam name="hierarchy" default="">
<cfparam name="brand_name" default="">
<cfparam name="brand_id" default="">
<cfparam name="brand_code" default="">
<cfparam name="short_code" default="">
<cfparam name="short_code_name" default="">
<cfparam name="short_code_id" default="">
<cfparam name="MANUFACT_CODE" default="">
<cfparam name="is_prototype" default="0">
<cfparam name="is_inventory" default="1">
<cfparam name="is_production" default="0">
<cfparam name="is_sales" default="1">
<cfparam name="is_purchase" default="1">
<cfparam name="is_internet" default="0">
<cfparam name="is_extranet" default="0">
<cfparam name="is_zero_stock" default="0">
<cfparam name="is_serial_no" default="0">
<cfparam name="is_karma" default="0">
<cfparam name="is_limited_stock" default="0">
<cfparam name="is_cost" default="1">
<cfparam name="is_terazi" default="0">
<cfparam name="gift_valid_day" default="0">
<cfparam name="is_commission" default="1">
<cfparam name="is_gift_card" default="0">
<cfparam name="is_quality" default="0">
<cfparam name="PACKAGE_CONTROL_TYPE" default="0">
<cfparam name="company_id" default="">
<cfparam name="company" default="">
<cfparam name="shelf_life" default="">
<cfparam name="customs_recipe_code" default="">


<cfform action="#request.self#?fuseaction=product.emptypopup_copy_product&pid=#url.pid#" method="post" name="form_copy_product">
    <cf_box_elements>
        <div class="col col-12 col-md-4 col-sm-12" type="column" index="1" sort="true">
            <div class="form-group col col-3 col-md-1 col-sm-6 col-xs-12" id="item-promotion_status">
                <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <input type="radio" name="new_stock" value="0" checked="checked" onclick="hide('stock_screen');"/> <cf_get_lang dictionary_id='62740.Yeni Stok'>
                </label>
            </div>
            <div class="form-group col col-3 col-md-1 col-sm-6 col-xs-12" id="item-promotion_days_m">
                <label class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <input type="radio" name="new_stock" value="1" onclick="show('stock_screen');"/> <cf_get_lang dictionary_id='62741.Stok Taşıma'>
                </label>
            </div>
        </div>
        <div class="col col-12 col-md-4 col-sm-12" type="column" index="2" sort="true">
            <div class="form-group" id="item-promotion_head">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58221.Ürün Adı'> *</label>
                <div class="col col-8 col-sm-12">
                    <cfinput type="Text" name="PRODUCT_NAME" value="" maxlength="50"  required="yes" message="Ürün Adı Girmelisiniz!">
                </div>
            </div>
            <div class="form-group" id="item-promotion_head">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57633.Barkod'> *</label>
                <div class="col col-8 col-sm-12">
                    <cfinput type="Text" name="BARCOD" value="" maxlength="15"  onBlur="look_barcode('BARCOD');">
                </div>
            </div>
            <div class="form-group" id="item-promotion_head">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                <div class="col col-8 col-sm-12">
                    <div class="input-group">
                        <cfinput type="hidden" name="c_product_catid" value="#get_product.product_catid#">
                        <cfsavecontent variable="message"><cf_get_lang no='367.Kategori Girmediniz'></cfsavecontent>                              
                        <cfinput type="text" name="product_cat" id="product_cat" required="yes"  message="#message#" value="#get_product_cat.hierarchy# #get_product_cat.product_cat#" onFocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','1','PRODUCT_CATID','product_catid','','3','455');">
                        <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&field_id=c_product_catid&field_name=form.product_cat&field_min=form.MIN_MARGIN&field_max=form.MAX_MARGIN','list');"></span>
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-promotion_head">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58847.Marka'></label>
                <div class="col col-8 col-sm-12">
                    <cfquery name="BRANDS" datasource="#DSN1#">
                        SELECT BRAND_ID,BRAND_NAME FROM PRODUCT_BRANDS ORDER BY BRAND_NAME
                    </cfquery>                
                    <select name="brand_id" >
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfloop query="brands">
                            <cfoutput>
                            <option value="#brand_id#" <cfif get_product.brand_id eq #brand_id#>selected</cfif>>#brand_name#</option>
                            </cfoutput>
                        </cfloop>
                    </select>	
                </div>
            </div>
            <div class="form-group" id="item-promotion_head">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
                <div class="col col-8 col-sm-12">
                    <div class="input-group">
                    <cfinput type="hidden" name="company_id" id="company_id" value="#get_product.company_id#">
                    <input name="comp" type="text"  id="comp"  onfocus="AutoComplete_Create('comp','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',\'<cfif fusebox.circuit is 'store'>1<cfelse>0</cfif>\',\'0\',\'\',\'2\',\'1\'','COMPANY_ID','company_id','','3','140');" value="<cfif len(get_product.company_id)><cfoutput>#get_comp.member_code#- #get_comp.fullname#</cfoutput></cfif>" autocomplete="off">
                    <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=form_copy_product.company_id&field_comp_name=form_copy_product.comp<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=2</cfoutput>&keyword='+encodeURIComponent(form_copy_product.comp.value),'list','popup_list_pars');"></span>
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-promotion_head">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                <div class="col col-8 col-sm-12">
                    <cfquery name="PROJECT" datasource="#DSN#">
                        SELECT PROJECT_ID,PROJECT_HEAD FROM PRO_PROJECTS ORDER BY PROJECT_HEAD
                    </cfquery>
                    <cfquery name="PROJECT_OLD" datasource="#DSN1#">
                    SELECT PROJECT_ID FROM PRODUCT WHERE PRODUCT_ID = #URL.pid#
                    </cfquery>                
                    <select name="project_id" >
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfloop query="PROJECT">
                            <cfoutput>
                                <option value="#project_id#" <cfif PROJECT_OLD.project_id eq #project_id#>selected</cfif>>#project_head#</option>
                            </cfoutput>
                        </cfloop>
                    </select>	
                </div>
            </div>
            <cfinclude template="../../product/query/get_kdv.cfm">
            <div class="form-group" id="item-tax_purchase">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37631.Alis KDV'>*</label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                    <div class="input-group">
                        <select name="tax_pur" id="tax_pur">
                            <cfoutput query="get_kdv">
                                <option value="#tax#">#tax#</option>
                            </cfoutput>
                        </select>
                        <span class="input-group-addon no-bg"><cf_get_lang dictionary_id='37916.Satış KDV'>*</span>
                        <select name="tax_sat" id="tax_">
                            <cfoutput query="get_kdv">
                                <option value="#tax#">#tax#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
            </div>
            <div class="form-group" id="item-promotion_head">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58722.Standart Alış'></label>
                <div class="col col-8 col-sm-12">
                    <cfinclude template="../../product/query/get_money.cfm">
                    <div class="col col-4 col-sm-12">
                    <cfinput type="text"  name="alis" value="0" class="moneybox"  required="yes" message="Alış fiyatı girin" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));">
                    </div>
                    <div class="col col-4 col-sm-12">
                    <select name="MONEY_ID_AL" id="MONEY_ID_AL">                                
                        <cfoutput query="get_money">
                            <option value="#money#" >#money#</option>
                        </cfoutput>
                    </select>
                    </div>
                    <div class="col col-4 col-sm-12">
                    <select name="is_tax_included_purchas" id="is_tax_included_purchas">
                        <option value="1" ><cf_get_lang dictionary_id='37365.KDV Dahil'></option>
                        <option value="0" selected><cf_get_lang dictionary_id='32998.KDV Hariç'></option>
                    </select>
                    </div>
                </div>
            </div>	
            <div class="form-group" id="item-promotion_head">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58721.Standart Satış'></label>
                <div class="col col-8 col-sm-12">
                    <div class="col col-4 col-sm-12">
                    <cfinput type="text"  name="satis" value="0" class="moneybox"  required="yes" message="Satış fiyatı girin" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));">
                    </div>
                    <div class="col col-4 col-sm-12">
                    <select name="MONEY_ID_SAT" id="MONEY_ID_SAT">                                
                    <cfoutput query="get_money">
                        <option value="#money#" >#money#</option>
                    </cfoutput>
                    </select>
                    </div>
                    <div class="col col-4 col-sm-12">
                    <select name="is_tax_included_sales" id="is_tax_included_sales">
                        <option value="1" selected><cf_get_lang dictionary_id='37365.KDV Dahil'></option>
                        <option value="0"><cf_get_lang dictionary_id='32998.KDV Hariç'></option>
                    </select>
                    </div>
                </div>
            </div>	
            <div class="form-group" id="stock_screen" style="display:none">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57518.Stok Kodu'></label>
                <div class="col col-8 col-sm-12">
                    <cfquery name="get_stocks" datasource="#dsn1#">
                        SELECT * FROM STOCKS WHERE PRODUCT_ID = #attributes.pid#
                    </cfquery>
                    <select name="transfer_stock_id" id="transfer_stock_id">
                        <cfoutput query="get_stocks"><option value="#stock_id#">#stock_code# #property#</option></cfoutput>
                    </select>
                </div>
            </div>
        </div>
    </cf_box_elements>
    <cf_box_footer>
        <cf_workcube_buttons add_function="barcode_control()">	
    </cf_box_footer>
</cfform>
    
		
<script>
is_must_save = 0;
function barcode_control()
{
	
	
	if(document.getElementById('is_production').checked == false && document.getElementById('is_inventory').checked == true)
	{
		if(document.getElementById('p_profit').value == '')	
		{
			is_must_save = 1;
			alert('<cf_get_lang dictionary_id='62742.Kopyalanacak Ürün İçin Alış Kar Giriniz'>!');
			return false;	
		}
		
		if(document.getElementById('s_profit').value == '')	
		{
			is_must_save = 1;
			alert('<cf_get_lang dictionary_id='62743.Kopyalanacak Ürün İçin Satış Kar Giriniz'>!');
			return false;	
		}
		
		if(document.getElementById('dueday').value == '')	
		{
			is_must_save = 1;
			alert('<cf_get_lang dictionary_id='62744.Kopyalanacak Ürün İçin Vade Giriniz'>!');
			return false;	
		}
		<!---<cfloop list="#type_control_list#" index="ccc">
            if(document.getElementById('<cfoutput>sub_id_#ccc#</cfoutput>').value == '' || document.getElementById('sub_name_#ccc#').value == '')
            {
                is_must_save = 1;
                alert('<cfoutput>Kopyalanacak Ürün İçin #evaluate("type_#ccc#")# Seçiniz!</cfoutput>');
                return false;	
            }
		</cfloop>--->
	}
	
	if(is_must_save == 1)
	{
		alert('<cf_get_lang dictionary_id='62745.Önce Ana Formu Kayıt Ediniz'>!');
		return false;	
	}
	
	if(document.form_copy_product.new_stock[0].checked == true)
	{
		if(document.form_copy_product.BARCOD.value == '')
		{
			alert('<cf_get_lang dictionary_id='62746.Barkod Giriniz'>!');
			return false;	
		}
	}
	else
	{
		new_sql = "";
		new_sql += "SELECT PROPERTY FROM STOCKS WHERE STOCK_ID = ";
		new_sql += document.getElementById('transfer_stock_id').value;
		var get_stock_name_ = wrk_query(new_sql,'dsn3');
		document.form_copy_product.PRODUCT_NAME.value =	get_stock_name_.PROPERTY;	
	}
}
</script>