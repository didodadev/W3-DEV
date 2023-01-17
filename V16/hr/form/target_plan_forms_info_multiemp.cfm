<cfform name="add_perf_emp_info" method="post" onclick="return false;">
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="56355.Hedef Yetkinlik Değerlendirme Formu Girişi"></cfsavecontent>
    <cf_box title="#message#">
        <cf_box_elements>
            <div class="col col-6">
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='58472.Dönem'></label>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57655.Başlangıç Tarihi'></cfsavecontent>
                            <cfinput required="Yes" message="#message#" type="text" name="start_date" validate="#validate_style#" value="01/01/#session.ep.period_year#" style="width:65px;">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                        </div>
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                            <cfinput required="Yes" message="#message#" type="text" name="finish_date" validate="#validate_style#" value="31/12/#session.ep.period_year#" style="width:65px;">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id="58859.Süreç"></label>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <cf_workcube_process is_upd='0' process_cat_width='170' is_detail='0'>
                    </div>
                </div>
            </div>
            <div class="col col-4">
                <div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <cfsavecontent variable="txt_2"><cf_get_lang dictionary_id='58875.Çalışanlar'></cfsavecontent>
                        <cf_workcube_to_cc is_update="0" to_dsp_name="#txt_2#" form_name="add_perf_emp_info" str_list_param="1" data_type="1">
                    </div>
                </div>
            </div>
            <div id="ekliKullanicilar"></div>
        </cf_box_elements>
        <cf_box_footer><cf_workcube_buttons is_upd='0' insert_alert='' add_function="kontrol()"></cf_box_footer>
    </cf_box>
</cfform>
<script type="text/javascript">
	function kontrol()
	{
        var to_emps = new Array();
        var to_pos = new Array();
        var length = document.add_perf_emp_info.to_emp_ids.length;
        for (let i = 0; i < length; i++) {
            to_emps.push(document.add_perf_emp_info.to_emp_ids[i].defaultValue);
            to_pos.push(document.add_perf_emp_info.to_pos_codes[i].defaultValue);
        }
        
        AjaxPageLoad('<cfoutput>#request.self#?fuseaction=hr.emptypopup_target_plan_forms_info_multiemp&to_emp_ids=</cfoutput>'+to_emps+'&start_date='+document.add_perf_emp_info.start_date.value+'&finish_date='+document.add_perf_emp_info.finish_date.value+'&to_pos_codes='+to_pos+'&process_stage='+document.add_perf_emp_info.process_stage.value,'ekliKullanicilar');
	}
</script>