<!--- İstisnai Fiyat Guncelleme --->
<cf_xml_page_edit fuseact="product.upd_price_list_for_company">
<cfquery name="GET_PRICE_CAT_EXCEPTIONS" datasource="#DSN3#">
	SELECT
		ISNULL(COMPANYCAT_ID,(SELECT COMPANYCAT_ID FROM #dsn_alias#.COMPANY WHERE COMPANY_ID = PRICE_CAT_EXCEPTIONS.COMPANY_ID)) COMPANY_CAT,
		(SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME FROM #DSN_ALIAS#.EMPLOYEES E WHERE E.EMPLOYEE_ID=PRICE_CAT_EXCEPTIONS.RECORD_EMP) AS RECORD_NAME,
        (SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME FROM #DSN_ALIAS#.EMPLOYEES E WHERE E.EMPLOYEE_ID=PRICE_CAT_EXCEPTIONS.UPDATE_EMP) AS UPDATE_NAME,
		*
	FROM
		PRICE_CAT_EXCEPTIONS
	WHERE
		PRICE_CAT_EXCEPTION_ID = #attributes.pid#
</cfquery>
<cfsavecontent variable="txt">
    <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_add_price_for_company"><img src="/images/plus1.gif" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></a>
</cfsavecontent>
<!--- <cf_catalystHeader> --->
<cf_box title="#getLang('','İstisnai Fiyat Listesi',37476)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfform name="price_company" id="price_company" method="post" action="#request.self#?fuseaction=product.emptypopup_upd_price_company" enctype="multipart/form-data">
	<cfoutput>
    <input type="hidden" name="pid" id="pid" value="#get_price_cat_exceptions.price_cat_exception_id#" />
	<cf_box_elements>
                    <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                        <div class="form-group" id="item-price_cat">
                        	<cfquery name="GET_PRICE_CATS" datasource="#DSN3#">
                                SELECT PRICE_CATID,PRICE_CAT FROM PRICE_CAT ORDER BY PRICE_CAT
                            </cfquery>
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58964.Fiyat Listesi'></label>
                            <div class="col col-9 col-xs-12">
                                <select name="price_cat" id="price_cat" style="width:150px;">
								<cfif get_price_cats.recordcount>
                                    <cfloop query="GET_PRICE_CATS">
                                        <option value="#price_catid#" <cfif len(price_catid) and price_catid eq get_price_cat_exceptions.price_catid>selected</cfif>>#price_cat#</option>
                                    </cfloop>
                                </cfif>
                                </select>
                            </div>
                        </div>
                        <cfif is_supplier eq 1>
                        <div class="form-group" id="item-supplier_name">
                        	<cfif len(get_price_cat_exceptions.supplier_id)>
                                <cfquery name="GET_SUP_NAME" datasource="#DSN#">
                                    SELECT COMPANY_ID, NICKNAME FROM COMPANY WHERE COMPANY_ID = #get_price_cat_exceptions.supplier_id#
                                </cfquery>
                            </cfif>
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58202.Üretici'></label>
                            <div class="col col-9 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="supplier_id" id="supplier_id" value="<cfif len(get_price_cat_exceptions.supplier_id)>#get_price_cat_exceptions.supplier_id#</cfif>">
                                    <input type="text" name="supplier_name" id="supplier_name" value="<cfif len(get_price_cat_exceptions.supplier_id)>#get_sup_name.nickname#</cfif>" style="width:150px;"> 
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="pencr_ac_supplier(1);" title="Üretici Seç"></span>
                                </div>
                            </div>
                        </div>
                        </cfif>
                        <cfif is_comp_cat eq 1>
                        <div class="form-group" id="item-comp_cat">
                        	<cfquery name="GET_COMP_CATS" datasource="#DSN#">
                                SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
                            </cfquery>
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58609.Üye Kategorisi'></label>
                            <div class="col col-9 col-xs-12">
                                <select name="comp_cat" id="comp_cat" style="width:150px;">
                                    <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                    <cfif get_comp_cats.recordcount>
                                        <cfloop query="GET_COMP_CATS">
                                            <option value="#companycat_id#" <cfif len(companycat_id) and companycat_id eq get_price_cat_exceptions.companycat_id>selected</cfif>>#COMPANYCAT#</option>
                                        </cfloop>
                                    </cfif>
                                </select>
                            </div>
                        </div>
                        </cfif>
                        <cfif xml_is_company eq 1>
                        <div class="form-group" id="item-company">
                        	<cfif len(get_price_cat_exceptions.company_id)>
                                <cfquery name="get_member" datasource="#DSN#">
                                    SELECT FULLNAME MEMBER_NAME, COMPANY_ID FROM COMPANY WHERE COMPANY_ID = #get_price_cat_exceptions.company_id#
                                </cfquery>
                            <cfelseif len(get_price_cat_exceptions.consumer_id)>
                                <cfquery name="get_member" datasource="#DSN#">
                                    SELECT (CONSUMER_NAME+' '+CONSUMER_SURNAME) MEMBER_NAME, CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID = #get_price_cat_exceptions.consumer_id#
                                </cfquery>
                            </cfif>
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57658.Üye'></label>
                            <div class="col col-9 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif len(get_price_cat_exceptions.consumer_id)>#get_price_cat_exceptions.consumer_id#</cfif>">
                                    <input type="hidden" name="company_id" id="company_id" value="<cfif len(get_price_cat_exceptions.company_id)>#get_price_cat_exceptions.company_id#</cfif>">
                                    <cfif len(get_price_cat_exceptions.company_id) or len(get_price_cat_exceptions.consumer_id)>
                                        <cfset member = get_member.member_name>
                                    </cfif>
                                    <input type="text" name="company" id="company" value="<cfif isdefined("member") and len(member)>#member#</cfif>" style="width:150px;"> 
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="pencr_ac_supplier(2);" title="Kategori Seç"></span>
                                </div>
                            </div>
                        </div>
                        </cfif>
                        <cfif xml_is_product_cat eq 1>
                        <div class="form-group" id="item-product_cat_name">
                        	<cfif len(get_price_cat_exceptions.product_catid)>
                                <cfquery name="GET_PRODUCT_CAT" datasource="#DSN3#">
                                    SELECT PRODUCT_CATID, HIERARCHY, PRODUCT_CAT FROM PRODUCT_CAT WHERE PRODUCT_CATID = #get_price_cat_exceptions.product_catid#
                                </cfquery>
                            </cfif>
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                            <div class="col col-9 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="product_cat_id" id="product_cat_id" value="<cfif len(get_price_cat_exceptions.product_catid)>#get_price_cat_exceptions.product_catid#</cfif>">
                                    <input type="text" name="product_cat_name" id="product_cat_name" value="<cfif len(get_price_cat_exceptions.product_catid)>#get_product_cat.hierarchy# #get_product_cat.product_cat#</cfif>" style="width:150px;" onFocus="AutoComplete_Create('product_cat_name','PRODUCT_CATID,PRODUCT_CAT','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','product_cat_id','','3','200','','1');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=0&field_id=price_company.product_cat_id&field_name=price_company.product_cat_name');"></span>
                                </div>
                            </div>
                        </div>
                        </cfif>
                        <cfif xml_is_brand_id eq 1>
                        <div class="form-group" id="item-getProductBrand">
                        	<cfif len(get_price_cat_exceptions.brand_id)>
                                <cfquery name="GET_BRAND_NAME" datasource="#DSN3#">
                                    SELECT BRAND_NAME, BRAND_ID	FROM PRODUCT_BRANDS WHERE BRAND_ID = #get_price_cat_exceptions.brand_id#
                                </cfquery>
                            </cfif>
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'></label>
                            <div class="col col-9 col-xs-12">
                                <cf_wrkProductBrand
                                    width="150"
                                    compenent_name="getProductBrand"               
                                    boxwidth="240"
                                    boxheight="150"
                                    brand_ID="#get_price_cat_exceptions.brand_id#">
                            </div>
                        </div>
                        </cfif>
                        <cfif xml_is_product_id eq 1>
                        <div class="form-group" id="item-product_name">
                        	<cfif len(get_price_cat_exceptions.product_id)>
                                <cfquery name="GET_PRODUCT_NAME" datasource="#DSN3#">
                                    SELECT PRODUCT_ID, PRODUCT_NAME, PROD_COMPETITIVE FROM  PRODUCT WHERE PRODUCT_ID = #get_price_cat_exceptions.product_id#
                                </cfquery>
                            </cfif>
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                            <div class="col col-9 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="product_id" id="product_id" value="<cfif len(get_price_cat_exceptions.product_id)>#get_price_cat_exceptions.product_id#</cfif>">
                                    <input type="text" name="product_name" id="product_name" style="width:150px;" value="<cfif len(get_price_cat_exceptions.product_id)>#get_product_name.product_name#</cfif>">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="pencere_pos();" title="Ürün Seç"></span>
                                </div>
                            </div>
                        </div>
                        </cfif>
                        <cfif xml_is_discount_rate eq 1>
                        <div class="form-group" id="item-discount_info">
                            <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57641.İskonto'>%</label>
                            <div class="col col-9 col-xs-12">
                                <input type="text" name="discount_info" id="discount_info" value="#TLFormat(get_price_cat_exceptions.discount_rate)#"  style="width:150px;" class="moneybox" onkeyup="return(FormatCurrency(this,event));">
                            </div>
                        </div>
                        </cfif>
                    </div>
                </cf_box_elements>
                <cf_box_footer>
                        <!---
						 <cfif len(record_name)>
									<tr>
										<td colspan="2"><strong><cf_get_lang_main no='487.Kaydeden'></strong>   :<cfoutput>#record_name#</cfoutput>
										<cfset temp_update = date_add('h',session.ep.time_zone,record_date)>
										<cfoutput>#dateformat(temp_update,dateformat_style)# (#timeformat(temp_update,timeformat_style)#)</cfoutput></td>
									</tr>
								</cfif>
								<cfif len(update_name)>
									<tr>    
										<td colspan="2"><strong><cf_get_lang_main no='479.Güncelleyen'></strong>:<cfoutput>#update_name#</cfoutput>
										<cfset temp_update = date_add('h',session.ep.time_zone,update_date)>
										<cfoutput>#dateformat(temp_update,dateformat_style)# (#timeformat(temp_update,timeformat_style)#)</cfoutput></td>
									</tr>
								</cfif>
						--->
							<cf_record_info query_name="GET_PRICE_CAT_EXCEPTIONS">
                 
                        <cf_workcube_buttons is_upd='1' 
                        delete_page_url='#request.self#?fuseaction=product.emptypopup_upd_price_company&is_del=1&pid=#get_price_cat_exceptions.price_cat_exception_id#'>
                    </cf_box_footer>
        </cfoutput>
</cfform>
</cf_box>
<script>	
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
