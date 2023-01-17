<cf_box_elements>
    <cfoutput>
	<input type="hidden" name="new_price" id="new_price" value="">
	<input type="hidden" name="order_id" id="order_id" value="">
	<input type="hidden" name="ship_id" id="ship_id" value="">
	<input type="hidden" name="is_change" id="is_change" value="0">
	<input type="hidden" name="is_add_same_name_spect" id="is_add_same_name_spect" value="<cfif isdefined("is_add_same_name_spect")>#is_add_same_name_spect#<cfelse>0</cfif>">
	<input type="hidden" name="reference_amount" id="reference_amount" value="0">
	<cfif isdefined("attributes.field_id") and isdefined("attributes.field_name")>
		<input type="hidden" name="field_name" id="field_name" value="#attributes.field_name#">
		<input type="hidden" name="field_id" id="field_id" value="#attributes.field_id#">
	</cfif>
    <cfif isdefined("attributes.field_main_id") and isdefined("attributes.field_main_id")><input type="hidden" name="field_main_id" id="field_main_id" value="#attributes.field_main_id#"></cfif>
    <cfset spec_name = get_product.product_name>
    <cfif IsDefined("get_product.property") and len(get_product.property)><cfset spec_name="#spec_name# #get_product.property#"></cfif>
    <input type="hidden" name="product_name" id="product_name" value="#get_product.product_name#">
    <input type="hidden" name="value_product_id" id="value_product_id" value="#get_product.product_id#">
    <input type="hidden" name="value_stock_id" id="value_stock_id" value="#get_product.stock_id#">
    
    <cfif IsDefined("get_price_main_prod")>
        <input type="hidden" name="main_prod_price" id="main_prod_price" value="#get_price_main_prod.price#"><!--- add_configurator_spect_new.cfm dosyasından gelir --->
        <input type="hidden" name="main_prod_price_kdv" id="main_prod_price_kdv" value="<cfif len(get_price_main_prod.price_kdv)>#get_price_main_prod.price_kdv#<cfelse>0</cfif>">
        <input type="hidden" name="main_product_money" id="main_product_money" value="#get_price_main_prod.money#">
        <input type="hidden" name="main_prod_price_currency" id="main_prod_price_currency" value="#get_price_main_prod.money#">
        <input type="hidden" name="main_std_money" id="main_std_money" value="#get_price_main_prod.PRICE_STDMONEY#">
    <cfelse>
        <input type="hidden" name="main_prod_price" id="main_prod_price" value="<cfif len(get_price.price)>#get_price.price#<cfelse>0</cfif>">
        <input type="hidden" name="main_prod_price_kdv" id="main_prod_price_kdv" value="<cfif len(get_price.price_kdv)>#get_price.price_kdv#<cfelse>0</cfif>">
        <input type="hidden" name="main_product_money" id="main_product_money" value="#get_price.money#">
        <input type="hidden" name="main_prod_price_currency" id="main_prod_price_currency" value="#get_price.money#">
        <input type="hidden" name="main_std_money" id="main_std_money" value="#get_price.PRICE_STDMONEY#">
    </cfif>
    
    <cfif isdefined('attributes.is_partner')><input type="hidden" name="is_partner" id="is_partner" value="1"></cfif>
    <cfif isdefined('attributes.is_from_prod_order')><!--- üretim emrinden geldiğini ifade ediyor. --->
        <input type="hidden" name="is_from_prod_order" id="is_from_prod_order" value="#attributes.is_from_prod_order#">
    </cfif>
    <cfif isDefined('attributes.upd_main_spect') and len(attributes.upd_main_spect)>
        <input type="hidden" name="upd_main_spect" id="upd_main_spect" value="#attributes.upd_main_spect#">
    </cfif>
    <input type="hidden" name="_deep_level_main_stock_id_0" id="_deep_level_main_stock_id_0" value="#_deep_level_main_stock_id_0#">
    <input type="hidden" name="_deep_level_main_product_id_0" id="_deep_level_main_product_id_0" value="#_deep_level_main_product_id_0#">
    <input type="hidden" name="_deep_level_main_product_name_0" id="_deep_level_main_product_name_0" value="#_deep_level_main_product_name_0#">
    <input type="hidden" name="main_spec_id_0" id="main_spec_id_0" value="#main_spec_id_0#">
    </cfoutput>
    <div class="row">
        <div class="col col-6">
            <div class="form-group">
                <label class="col col-4"><cf_get_lang dictionary_id='57647.Spect'></label>
                <div class="col col-8">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='32755.spec girmelisiniz'></cfsavecontent>
                    <cfif isdefined("attributes.product_id")>
                        <cfinput type="text" name="spect_name" id="spect_name"  style="width:250;" value="#spec_name#" maxlength="500">
                    <cfelse>
                        <cfinput type="text" name="spect_name" id="spect_name"  style="width:250;" value="" maxlength="500">
                    </cfif>
                </div>
            </div>
            <!--- <div class="form-group">
                <label class="col col-4"><cf_get_lang dictionary_id ='57515.Dosya Ekle'></label>
                <div class="col col-8">
                    <input type="file" name="spect_file_name" id="spect_file_name">
                </div>
            </div> --->
            <cfif is_show_special_code_1 eq 1>
                <div class="form-group">
                    <label class="col col-4"><cf_get_lang dictionary_id ='57789.Özel Kod'> 1</label>
                    <div class="col col-8">
                        <input type="text" name="special_code_1" id="special_code_1" onblur="if(!special_code_control('1',this.value))this.value='';">
                    </div>
                </div>
            <cfelse>
                <input type="hidden" name="special_code_1" id="special_code_1" value="">
            </cfif>
            <cfif is_show_special_code_2 eq 1>
                <div class="form-group">
                    <label class="col col-4"><cf_get_lang dictionary_id ='57789.Özel Kod'> 2 </label>
                    <div class="col col-8">
                        <input type="text" name="special_code_2" id="special_code_2" onblur="if(!special_code_control('2',this.value))this.value='';">
                    </div>
                </div>
            <cfelse>
                <input type="hidden" name="special_code_2" id="special_code_2" value="">
            </cfif>
            <cfif is_show_special_code_3 eq 1>
                <div class="form-group">
                    <label class="col col-4"><cf_get_lang dictionary_id ='57789.Özel Kod'> 3 </label>
                    <div class="col col-8">
                        <input type="text" name="special_code_3" id="special_code_3">
                    </div>
                </div>
            <cfelse>
                <input type="hidden" name="special_code_3" id="special_code_3" value="">
            </cfif>	
            <cfif is_show_special_code_4 eq 1>
                <div class="form-group">
                    <label class="col col-4"><cf_get_lang dictionary_id ='57789.Özel Kod'> 4 </label>
                    <div class="col col-8">
                        <input type="text" name="special_code_4" id="special_code_4">
                    </div>
                </div>
            <cfelse>
                <input type="hidden" name="special_code_4" id="special_code_4" value="">
            </cfif>
            <cfif isdefined('is_show_detail') and is_show_detail eq 1>
                <div class="form-group">
                    <label class="col col-4"><cf_get_lang dictionary_id='57771.Detay'>/<cf_get_lang dictionary_id ='33923.Talimat'></label>
                    <div class="col col-8">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='32755.spec girmelisiniz'></cfsavecontent>
                        <textarea name="spect_detail" id="spect_detail"></textarea>
                    </div>
                </div>
            </cfif>
            <div class="form-group">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                <div class="col col-8 col-sm-12">
                    <cf_workcube_process is_upd='0' process_cat_width='125' is_detail='0'>
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='62511.Özelleştiren'></label>
                <div class="col col-8 col-sm-12">
                    <div class="input-group">
                        <input type="hidden" name="employee_id" id="employee_id" value="">
                        <input type="text" name="employee_name" id="employee_name" value="" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','125');" autocomplete="off">
                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_spect_variations.employee_id&field_name=add_spect_variations.employee_name&select_list=1','list');"></span>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></label>
                <div class="col col-8 col-sm-12">
                    <div class="input-group">
                        <cfinput type="text" name="save_date" id="save_date" value="" validate="#validate_style#" maxlength="10">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="save_date"></span>
                    </div>
                </div>
            </div>
            <cfquery name="get_image" datasource="#DSN3#">
                SELECT FILE_NAME,FILE_SERVER_ID,DETAIL
                FROM SPECTS
                WHERE SPECT_VAR_ID = <cfqueryparam cfsqltype = "cf_sql_integer" value = "#attributes.id?:0#">                
            </cfquery>
            <div class="form-group">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='57515.Dosya Ekle'></label>
                <div class="col col-8 col-sm-12">
                    <cfif get_image.recordcount and len(get_image.FILE_NAME)>
                    <div class="input-group">
                    </cfif>
                        <input type="hidden" value="<cfoutput>#get_image.recordcount ? get_image.FILE_NAME : ''#</cfoutput>" name="old_files" id="old_files">
                        <input type="hidden" value="<cfoutput>#get_image.recordcount ? get_image.FILE_SERVER_ID : ''#</cfoutput>" name="old_server_id" id="old_server_id">
                        <input type="file" name="spect_file_name" id="spect_file_name">
                        <cfif get_image.recordcount and len(get_image.FILE_NAME)>
                            <cf_get_server_file output_file="objects/#get_image.file_name#" output_server="#get_image.file_server_id#" output_type="2" small_image="/images/photo.gif" image_link="1">
                            <span class="input-group-addon"><input type="checkbox" value="1" name="del_attach" id="del_attach"><cf_get_lang dictionary_id ='33887.Dosya Sil'></span>
                        </cfif>
                    <cfif get_image.recordcount and len(get_image.FILE_NAME)>
                    </div>
                    </cfif>
                </div>
            </div>
        </div>
        <div class="col col-6">
            <div class="form-group">
                <label>
                    <input type="checkbox" name="is_price_change" id="is_price_change" value="1">
                    <cf_get_lang dictionary_id ='33922.Fiyatı Güncelle'>
                </label>
            </div>
            <div class="form-group">
                <label>
                    <input type="checkbox" name="is_limited_stock" id="is_limited_stock" value="1">
                    <cf_get_lang dictionary_id='40169.Stoklarla Sınırlı'>
                </label>
            </div>
        </div>
    </div>
</cf_box_elements>