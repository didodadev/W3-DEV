<cfinclude template="../query/get_shipment_method.cfm">
<cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
<cf_papers paper_type="stock_fis">
<cfset system_paper_no=paper_code & '-' & paper_number>
<cfset system_paper_no_add=paper_number>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
        <div id="basket_main_div">
            <cfform name="form_basket" method="post" action="#request.self#?fuseaction=stock.emptypopup_add_ship_open_fis_process">	
                <cf_basket_form id="add_ship_open_fis">
                    <cf_box_elements vertical="0">
                        <input type="hidden" name="search_process_date" id="search_process_date" value="deliver_date_frm">    
                        <input type="hidden" name="active_period" id="active_period" value="<cfoutput>#session.ep.period_id#</cfoutput>">
                        <input type="hidden" name="form_action_address" id="form_action_address" value="stock.emptypopup_add_ship_open_fis_process">
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-process_cat">
                                <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cf_get_lang_main no='388.İşlem Tipi'>*</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <cfif isdefined("attributes.from_where") and attributes.from_where eq 6>
                                        <cf_workcube_process_cat process_cat="#attributes.process_cat#">
                                    <cfelse>
                                        <cf_workcube_process_cat>
                                    </cfif>
                                </div>
                            </div>
                            <div class="form-group" id="item-location_in">
                                <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cf_get_lang_main no='1351.depo'>*</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <cfif isdefined("attributes.from_where") and attributes.from_where eq 6>
                                        <cfif isdefined("attributes.department_id") and isdefined("attributes.location_id") and isdefined("attributes.txt_departman_")  >
                                            <cf_wrkdepartmentlocation 
                                                returnInputValue="location_id,txt_departman_,department_id,branch_id"
                                                returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                                fieldId="location_id"
                                                fieldName="txt_departman_"
                                                department_fldId="department_id"
                                                branch_fldId="branch_id"
                                                department_id="#attributes.department_id#"
                                                location_id="#attributes.location_id#"
                                                location_name="#attributes.txt_departman_#"
                                                user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                                width="150">
                                        </cfif>
                                    <cfelse>
                                        <!---<input type="hidden" name="location_in" id="location_in">
                                        <input type="hidden" name="department_in" id="department_in">
                                        <input name="txt_departman_in" type="text" id="txt_departman_in" style="width:150px;" onFocus="AutoComplete_Create('txt_departman_in','COMMENT,DEPARTMENT_HEAD','DEPARTMENT_NAME','get_department_location','','LOCATION_ID,DEPARTMENT_ID','location_in,department_in','','3','225');" autocomplete="off">
                                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_stores_locations&form_name=form_basket&field_name=txt_departman_in&field_id=department_in&&fis_type=114&field_location_id=location_in</cfoutput>','list')" ><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>  --->
                                        <cf_wrkdepartmentlocation 
                                            returnInputValue="location_id,txt_departman_,department_id,branch_id"
                                            returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
                                            fieldId="location_id"
                                            fieldName="txt_departman_"
                                            department_fldId="department_id"
                                            branch_fldId="branch_id"
                                            user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                            width="150">
                                    </cfif>
                                </div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                            <div class="form-group" id="item-fis_no_">
                                <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cf_get_lang_main no='534.Fis No'>*</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <input type="text" name="fis_no_" id="fis_no_" value="<cfoutput>#system_paper_no#</cfoutput>" readonly style="width:65px;">
                                </div>
                            </div>
                            <div class="form-group" id="item-deliver_date_frm">
                                <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cf_get_lang_main no='330.Tarih'>*</label>
                                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                    <div class="input-group">
                                        <cfif isdefined("attributes.ship_date")>
                                            <cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'></cfsavecontent> 
                                            <cfinput type="text" name="deliver_date_frm" value="#attributes.ship_date#" required="yes" message="#message#" validate="#validate_style#" style="width:65px;">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="deliver_date_frm" call_function="change_money_info"></span>
                                            <cfinclude template="../query/get_department.cfm">
                                        <cfelse>
                                            <cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'></cfsavecontent> 
                                            <cfinput type="text" name="deliver_date_frm" value="" required="yes" message="#message#" validate="#validate_style#" style="width:65px;">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="deliver_date_frm" call_function="change_money_info"></span>
                                            <cfinclude template="../query/get_department.cfm">
                                        </cfif>
                                    </div>
                                </div>
                                <cfoutput>
                                    <cfset value_start_h = hour(dateadd('h',session.ep.time_zone,now()))>
                                    <cfset value_start_m = minute(now())>
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
						<cf_workcube_buttons is_upd='0' add_function='kontrol_kayit()'>
					</cf_box_footer>
                </cf_basket_form>
                <cfset attributes.basket_id = 13>
                <cfif not isdefined('attributes.type') and not (isdefined("attributes.upd_id") and len(attributes.upd_id))>
                    <cfif not isdefined("attributes.file_format")>
                        <cfset attributes.form_add = 1>
                    <cfelse>
                        <cfset attributes.basket_sub_id = 13>
                    </cfif>	
                </cfif>
                <cfinclude template="../../objects/display/basket.cfm">
            </cfform>
        </div>
    </cf_box>
</div>
<script type="text/javascript">
function kontrol_kayit()
{
	if(!chk_process_cat('form_basket')) return false;
	if(!check_display_files('form_basket')) return false;
	if(!chk_period(form_basket.deliver_date_frm,"İşlem")) return false;
	if(form_basket.department_id.value == "" || form_basket.txt_departman_.value=="")
	{
		alert("<cf_get_lang dictionary_id='45372.Lütfen Depo Seçiniz'>");
		return false;
	}
	saveForm();
	return false;
}
</script>
<!--- <cfsetting showdebugoutput="yes">  --->