<cfsavecontent variable="message"><cf_get_lang dictionary_id="56355.Hedef Yetkinlik Değerlendirme Formu Girişi"></cfsavecontent>
<cf_box title="#message#">
    <cfform name="add_perf_emp_info" method="post" action="#request.self#?fuseaction=hr.emptypopup_target_plan_forms_info">
        <cf_box_elements>
            <div class="col col-8">
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='57576.Çalışan'></label>
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
                                <input type="hidden" name="position_code" id="position_code" value="<cfoutput>#session.ep.position_code#</cfoutput>">
                                <input type="hidden" name="position_name" id="position_name" value="<cfoutput>#session.ep.position_name#</cfoutput>">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='29498.Çalışan seçiniz'></cfsavecontent>
                                <cfinput type="text" name="emp_name" value="#session.ep.name# #session.ep.surname#" required="yes" message="#message#">
                                <cfif session.ep.ehesap>
                                    <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_perf_emp_info.employee_id&field_name=add_perf_emp_info.emp_name&field_code=add_perf_emp_info.position_code&field_pos_name=add_perf_emp_info.position_name&select_list=1&keyword='+encodeURIComponent(document.add_perf_emp_info.emp_name.value)</cfoutput>,'list')"></span>
                                </cfif>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col col-8">
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='58472.Dönem'></label>
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                             <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57655.Başlangıç Tarihi'></cfsavecontent>
                                <cfinput required="Yes" message="#message#" type="text" name="start_date" validate="#validate_style#" value="01/01/#session.ep.period_year#">
                                <span class="input-group-addon">
                                    <cf_wrk_date_image date_field="start_date">
                                </span>
                            </div>
                        </div>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                             <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                                <cfinput required="Yes" message="#message#" type="text" name="finish_date" validate="#validate_style#" value="31/12/#session.ep.period_year#">
                                <span class="input-group-addon">
                                    <cf_wrk_date_image date_field="finish_date">
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col col-8">
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id ='58859.Süreç'></label>
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <cf_workcube_process is_upd='0' process_cat_width='170' is_detail='0'>
                        </div>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' insert_alert='' add_function='kontrol()'>
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
	function kontrol()
	{
		if(document.add_perf_emp_info.employee_id.value.length==0)
		{
			alert("<cf_get_lang dictionary_id='29498.Çalışan seçiniz'>");
			return false;
		}
		return true;
	}
</script>