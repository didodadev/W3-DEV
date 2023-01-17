<!--- İstisnai Fiyat Ekleme --->
<cf_xml_page_edit fuseact="product.upd_price_list_for_company">
<cfquery name="GET_PRICE_CATS" datasource="#DSN3#">
	SELECT PRICE_CATID,PRICE_CAT,PRICE_CAT_STATUS FROM PRICE_CAT ORDER BY PRICE_CAT
</cfquery>
<cfquery name="GET_PRICE_CAT_ACTIVE" dbtype="query">
	SELECT * FROM GET_PRICE_CATS WHERE PRICE_CAT_STATUS = 1 
</cfquery>
<cfquery name="GET_COMP_CATS" datasource="#DSN#">
	SELECT DISTINCT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT
</cfquery>
<!--- <cf_catalystHeader> --->
<cf_box title="#getLang('','İstisnai Fiyat Listesi',37476)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfform name="price_company" id="price_company" method="post" action="#request.self#?fuseaction=product.emptypopup_add_price_company" enctype="multipart/form-data">
	<input type="hidden" name="row_kontrol" id="row_kontrol" value="1">
    <cf_box_elements>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-price_cat">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58964.Fiyat Listesi'>*</label>
                            <div class="col col-9 col-xs-12">
                                <select name="price_cat" id="price_cat" style="width:150px;">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_price_cat_active">
                                        <option value="#price_catid#">#price_cat#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <cfif is_supplier eq 1>
                        <div class="form-group" id="item-supplier_name">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58202.Üretici'></label>
                            <div class="col col-9 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="supplier_id" id="supplier_id" value="">
                                    <input type="text" name="supplier_name" id="supplier_name" value="" style="width:150px;"> 
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="pencr_ac_supplier(1);" title="<cf_get_lang dictionary_id='58202.Üretici'> <cf_get_lang dictionary_id ='57734.Seç'>"></span>
                                </div>
                            </div>
                        </div>
                        </cfif>
                        <cfif is_comp_cat eq 1>
                        <div class="form-group" id="item-comp_cat">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58609.Üye Kategorisi'></label>
                            <div class="col col-9 col-xs-12">
                                <select name="comp_cat" id="comp_cat" style="width:150px;">
                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <cfoutput query="GET_COMP_CATS">
                                        <option value="#COMPANYCAT_ID#">#COMPANYCAT#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        </cfif>
                        <cfif xml_is_company eq 1>
                        <div class="form-group" id="item-company">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57658.Üye'></label>
                            <div class="col col-9 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="consumer_id" id="consumer_id">
                                    <input type="hidden" name="company_id" id="company_id">
                                    <input type="text" name="company" id="company" style="width:150px;"> 
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="pencr_ac_supplier(2);" title="<cf_get_lang dictionary_id='58947.Kategori Seç'>"></span>
                                </div>
                            </div>
                        </div>
                        </cfif>
                        <cfif xml_is_product_cat eq 1>
                        <div class="form-group" id="item-product_cat_name">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                            <div class="col col-9 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="product_cat_id" id="product_cat_id">
                                    <input type="text" name="product_cat_name" id="product_cat_name" style="width:150px;" onFocus="AutoComplete_Create('product_cat_name','PRODUCT_CATID,PRODUCT_CAT','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','product_cat_id','','3','200','','1');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=0&field_id=price_company.product_cat_id&field_name=price_company.product_cat_name</cfoutput>');"></span>
                                </div>
                            </div>
                        </div>
                        </cfif>
                        <cfif xml_is_brand_id eq 1>
                        <div class="form-group" id="item-getProductBrand">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'></label>
                            <div class="col col-9 col-xs-12">
                                <cf_wrkProductBrand
                                width="150"
                                compenent_name="getProductBrand"               
                                boxwidth="240"
                                boxheight="150">
                            </div>
                        </div>
                        </cfif>
                        <cfif xml_is_product_id eq 1>
                        <div class="form-group" id="item-product_name">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                            <div class="col col-9 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="product_id" id="product_id">
                                    <input type="text" name="product_name" id="product_name" style="width:150px;">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="pencere_pos();" title="<cf_get_lang dictionary_id='57725.Ürün Seç'>"></span>
                                </div>
                            </div>
                        </div>
                        </cfif>
                        <cfif xml_is_discount_rate eq 1>
                        <div class="form-group" id="item-discount_info">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57641.İskonto'> %</label>
                            <div class="col col-9 col-xs-12">
                                <input type="text" name="discount_info" id="discount_info" value="0"  style="width:150px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">
                            </div>
                        </div>
                        </cfif>
                    </div>
            </cf_box_elements>
               <cf_box_footer>
                        <cf_workcube_buttons is_upd='0' add_function='unformat_fields()'>
                </cf_box_footer>
</cfform>
</cf_box>
<script>
function unformat_fields()
	{
		if(document.price_company.price_cat.value == '')
		{
			window.alert("<cf_get_lang dictionary_id='37884.Fiyat Listesi Seçiniz'>!");
			return false;
		}
	
		return true;
	}
	function pencere_pos()
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_products_only&product_id=price_company.product_id&field_name=price_company.product_name','list'); /*&process=purchase_contract  var_=purchase_contr_cat_premium&*/
	}
		
	function pencr_ac_supplier(type)
	{
		if(type==2) /*üye*/
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=price_company.company&field_comp_id=price_company.company_id&select_list=2,3&field_consumer=price_company.consumer_id&field_member_name=price_company.company&comp_cat=price_company.comp_cat','list');
		else /*üretici*/
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&select_list=2&field_comp_id=price_company.supplier_id&field_comp_name=price_company.supplier_name','list');
	}
</script>
