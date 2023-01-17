<cfset attributes.ship_id = attributes.upd_id>
<cfscript>session_basket_kur_ekle(action_id=attributes.upd_id,table_type_id:6,process_type:1);</cfscript>
<cfinclude template="../query/get_fis_det.cfm">
<cfif not get_fis_det.recordcount>
  <br/><font class="txtbold"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
  <cfexit method="exittemplate">
</cfif>
<cfinclude template="../query/get_shipment_method.cfm">
<cfset fis_type = get_fis_det.fis_type>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
        <div id="basket_main_div">
            <cfform name="form_basket" method="post" action="#request.self#?fuseaction=stock.emptypopup_upd_open_fis_process">
                <cf_basket_form id="stock_open_fis">
                    <cf_box_elements vertical="0">
                        <input type="hidden" name="search_process_date" id="search_process_date" value="deliver_date_frm">
                        <input type="hidden" name="upd_id" id="upd_id" value="<cfoutput>#get_fis_det.FIS_ID#</cfoutput>">
                        <input type="hidden" name="fis_type" id="fis_type" value="<cfoutput>#fis_type#</cfoutput>"> 
                        <input type="hidden" name="FIS_DATE" id="FIS_DATE" value="<cfoutput>#dateformat(get_fis_det.FIS_DATE,dateformat_style)#</cfoutput>">
                        <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
                        <input type="hidden" name="DEL_ID" id="DEL_ID" value="0">
                        <input type="hidden" name="fis_number_" id="fis_number_" value="<cfoutput>#get_fis_det.fis_number#</cfoutput>">  
                        <input type="hidden" name="form_action_address" id="form_action_address" value="stock.emptypopup_upd_open_fis_process">
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-process_cat">
                                <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cf_get_lang_main no='388.İşlem Tipi'>*</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <cf_workcube_process_cat process_cat="#get_fis_det.process_cat#">
                                </div>
                            </div>
                            <div class="form-group" id="item-location_in">
                                <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cf_get_lang_main no='1351.depo'>*</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cf_wrkdepartmentlocation
                                    returnInputValue="location_in,txt_department_in,department_in,branch_id"
                                    returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                    fieldName="txt_department_in"
                                    fieldid="location_in"
                                    department_fldId="department_in"
                                    department_id="#get_fis_det.department_in#"
                                    location_id="#get_fis_det.location_in#"
                                    location_name="#get_location_info(get_fis_det.department_in,get_fis_det.location_in)#"
                                    user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                    width="150">
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                            <div class="form-group" id="item-fis_no_">
                                <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cf_get_lang_main no='534.Fis No'>*</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <cfsavecontent variable="message"><cf_get_lang no='135.fis no girmelisiniz'></cfsavecontent>
                                    <cfinput type="text" name="FIS_NO" required="yes" message="#message#" value="#get_fis_det.fis_number#" style="width:65px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-deliver_date_frm">
                                <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cf_get_lang_main no='330.Tarih'>*</label>
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'></cfsavecontent>
                                        <cfinput type="text" name="deliver_date_frm" required="yes" message="#message#" value="#dateformat(get_fis_det.fis_date,dateformat_style)#" validate="#validate_style#" style="width:65px;">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="deliver_date_frm"></span>
                                    </div>
                                </div>
                                <cfoutput>
                                    <cfif len(get_fis_det.deliver_date)>
                                        <cfset value_start_h = hour(get_fis_det.deliver_date)>
                                        <cfset value_start_m = minute(get_fis_det.deliver_date)>
                                    <cfelse>
                                        <cfset value_start_h = hour(dateadd('h',session.ep.time_zone,now()))>
                                        <cfset value_start_m = minute(now())>
                                    </cfif>                                   
                                    <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                        <cf_wrkTimeFormat name="deliver_date_h" value="#value_start_h#">
                                    </div>
                                    <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                        <select name="deliver_date_m" id="deliver_date_m">
                                            <cfloop from="0" to="59" index="i">
                                                <option value="#NumberFormat(i)#" <cfif value_start_m eq i>selected</cfif>><cfif i lt 10>0</cfif>#NumberFormat(i)# </option>
                                            </cfloop>
                                        </select>														
                                    </div>
                                </cfoutput>
                            </div>
                        </div>
                    </cf_box_elements>
                        <cf_box_footer>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <cf_record_info query_name='get_fis_det'>
                            </div>
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <input type="hidden" name="deliver_get_id" id="deliver_get_id" value="<cfoutput>#get_fis_det.employee_id#</cfoutput>">
                                <cf_workcube_buttons 
                                is_upd='1' 
                                is_delete=1 
                                add_function='kontrol_firma()'
                                del_function='kontrol2()'>
                            </div>
                        </cf_box_footer>
                    
                </cf_basket_form>  
                <cfset attributes.basket_id = 13>
                <cfinclude template="../../objects/display/basket.cfm">
            </cfform>
        </div>
    </cf_box>
</div>
<script type="text/javascript">
function kontrol_firma()
{
	if(!chck_zero_stock()) return false;
	if(!chk_process_cat('form_basket')) return false;
	if(!check_display_files('form_basket')) return false;
	if(!chk_period(form_basket.deliver_date_frm,"İşlem")) return false;
	saveForm();
	return false;
}

function kontrol2()
{
	if(!chck_zero_stock(1)) return false; //sadece silme işleminden cagrılırken 1 gönderiliyor
	form_basket.DEL_ID.value = <cfoutput>#attributes.upd_id#</cfoutput>;
	if(!check_display_files('form_basket')) return false;
	return true;	
}
function chck_zero_stock(is_del)
{ 
	if(check_stock_action('form_basket'))
	{
		var basket_zero_stock_status = wrk_safe_query('inv_basket_zero_stock_status','dsn3',0,<cfoutput>#attributes.basket_id#</cfoutput>);
		if(basket_zero_stock_status.IS_SELECTED != 1)//<!--- basket sablonunda sıfır stok ile calıs secilmemisse zero_stock kontrolu yapılır --->
		{
			var temp_process_cat = document.form_basket.process_cat.options[document.form_basket.process_cat.selectedIndex].value;
			var temp_process_type = eval("document.form_basket.ct_process_type_" + temp_process_cat);
			if(!zero_stock_control(form_basket.department_in.value,form_basket.location_in.value,form_basket.upd_id.value,temp_process_type.value,0,is_del)) return false;
		}
	}
	return true;
}
</script>
