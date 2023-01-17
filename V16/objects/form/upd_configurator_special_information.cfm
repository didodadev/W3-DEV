<cf_box_elements>
    <cfoutput>
    <input type="hidden" name="spec_id" id="spec_id" value="#attributes.id#">
    <input type="hidden" name="is_update" id="is_update" value="1">
    <input type="hidden" name="reference_amount" id="reference_amount" value="0">
    <input type="hidden" name="new_price" id="new_price" value="">
    <input type="hidden" name="order_id" id="order_id" value=""><!---spectin acildigi saydadaki order idnin alinacagı alan--->
    <input type="hidden" name="ship_id" id="ship_id" value=""><!---spectin acildigi saydadaki ship idnin alinacagı alan--->
    <input type="hidden" name="spect_id" id="spect_id" value="<cfif isdefined('attributes.id')>#attributes.id#</cfif>">
    <input type="hidden" name="spect_main_id" id="spect_main_id" value="<cfif isdefined('GET_SPECT') and GET_SPECT.RECORDCOUNT>#GET_SPECT.SPECT_MAIN_ID#</cfif>">
    <input type="hidden" name="is_change" id="is_change" value="0">	
    <input type="hidden" name="value_product_id" id="value_product_id" value="#get_product.product_id#">
    <input type="hidden" name="product_name" id="product_name" value="#get_product.product_name#">
    <input type="hidden" name="value_stock_id" id="value_stock_id" value="#get_product.stock_id#">
    
    <input type="hidden" name="main_prod_price" id="main_prod_price" value="#GET_SPECT.PRODUCT_AMOUNT#">
    <input type="hidden" name="main_prod_price_kdv" id="main_prod_price_kdv" value="<cfif len(get_price.price_kdv)>#get_price.price_kdv#<cfelse>0</cfif>">
    <input type="hidden" name="main_product_money" id="main_product_money" value="#get_price.money#">
    <input type="hidden" name="main_prod_price_currency" id="main_prod_price_currency" value="#GET_SPECT.PRODUCT_AMOUNT_CURRENCY#">
    <input type="hidden" name="main_std_money" id="main_std_money" value="#GET_SPECT.PRODUCT_AMOUNT * (GET_MAIN_PRICE.RATE2 / GET_MAIN_PRICE.RATE1)#">
    
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
                    <cfinput type="text" name="spect_name" required="yes" message="#message#" style="width:250;" value="#get_spect.spect_var_name#" maxlength="500">
                </div>
            </div>
            <cfif is_show_special_code_1 eq 1>
                <div class="form-group">
                    <label class="col col-4"><cf_get_lang dictionary_id ='57789.Özel Kod'> 1</label>
                    <div class="col col-8">
                        <cfinput type="text" name="special_code_1" id="special_code_1" value="#get_spect.special_code_1#" onblur="if(!special_code_control('1',this.value))this.value='';">
                    </div>
                </div>
            <cfelse>
                <cfinput type="hidden" name="special_code_1" id="special_code_1" value="#get_spect.special_code_1#">
            </cfif>
            <cfif is_show_special_code_2 eq 1>
                <div class="form-group">
                    <label class="col col-4"><cf_get_lang dictionary_id ='57789.Özel Kod'> 2 </label>
                    <div class="col col-8">
                        <cfinput type="text" name="special_code_2" id="special_code_2" value="#get_spect.special_code_2#" onblur="if(!special_code_control('2',this.value))this.value='';">
                    </div>
                </div>
            <cfelse>
                <cfinput type="hidden" name="special_code_2" id="special_code_2" value="#get_spect.special_code_2#">
            </cfif>
            <cfif is_show_special_code_3 eq 1>
                <div class="form-group">
                    <label class="col col-4"><cf_get_lang dictionary_id ='57789.Özel Kod'> 3 </label>
                    <div class="col col-8">
                        <cfinput type="text" name="special_code_3" id="special_code_3" value="#get_spect.special_code_3#">
                    </div>
                </div>
            <cfelse>
                <cfinput type="hidden" name="special_code_3" id="special_code_3" value="#get_spect.special_code_3#">
            </cfif>	
            <cfif is_show_special_code_4 eq 1>
                <div class="form-group">
                    <label class="col col-4"><cf_get_lang dictionary_id ='57789.Özel Kod'> 4 </label>
                    <div class="col col-8">
                        <cfinput type="text" name="special_code_4" id="special_code_4" value="#get_spect.special_code_4#">
                    </div>
                </div>
            <cfelse>
                <cfinput type="hidden" name="special_code_4" id="special_code_4" value="#get_spect.special_code_4#">
            </cfif>
            <cfif isdefined('is_show_detail') and is_show_detail eq 1>
                <div class="form-group">
                    <label class="col col-4"><cf_get_lang dictionary_id='57771.Detay'>/<cf_get_lang dictionary_id ='33923.Talimat'></label>
                    <div class="col col-8">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='32755.spec girmelisiniz'></cfsavecontent>
                        <textarea name="spect_detail" id="spect_detail" style="width:250px; height:65px;"><cfoutput>#get_spect.DETAIL#</cfoutput></textarea>
                    </div>
                </div>
            </cfif>
            <div class="form-group">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
                <div class="col col-8 col-sm-12">
                    <cf_workcube_process is_upd='0' select_value='#get_spect.stage#' process_cat_width='125' is_detail='1'>
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='62511.Özelleştiren'></label>
                <div class="col col-8 col-sm-12">
                    <div class="input-group">
                        <cfinput type="hidden" name="employee_id" id="employee_id" value="#get_spect.EMPLOYEE_ID#">
                        <cfinput type="text" name="employee_name" id="employee_name" value="#get_emp_info(get_spect.EMPLOYEE_ID,0,0)#" onFocus="AutoComplete_Create('employee_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','125');" autocomplete="off">
                        <span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_spect_variations.employee_id&field_name=add_spect_variations.employee_name&select_list=1','list');"></span>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></label>
                <div class="col col-8 col-sm-12">
                    <div class="input-group">
                        <cfinput type="text" name="save_date" id="save_date" value="#dateformat(get_spect.save_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
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