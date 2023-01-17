<cf_catalystHeader>
<cfform name="add_perf_emp_info" method="post" action="#request.self#?fuseaction=hr.list_total_performances&event=add">
    <div class="row">
        <div class="col col-12">
            <div class="row" id="basket_main_div">
                <cf_box id="form_add_assetp">
                    <cf_box_search more="0">
                        <div class="row" type="row">
                            <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                                <div class="form-group" id="item-employee_id">
                                    <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'>*</label>
                                    <div class="col col-8 col-md-4 col-sm-6 col-xs-12">
                                        <div class="input-group">
                                            <input type="hidden" name="employee_id" id="employee_id" value="">
                                            <cf_wrk_employee_positions form_name='add_perf_emp_info' emp_id='employee_id' emp_name='emp_name'>
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='29498.Çalışan girmelisiniz'></cfsavecontent>
                                            <cfinput type="text" name="emp_name" value="" required="yes" message="#message#" onKeyUp="get_emp_pos_1();">
                                            <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_perf_emp_info.employee_id&field_name=add_perf_emp_info.emp_name&select_list=1</cfoutput>','list')"></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group" id="item-employee_id">
                                    <label class="col col-4 col-md-4 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='58472.Dönem'>*</label>
                                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57655.Başlangıç Tarihi'></cfsavecontent>
                                            <cfinput required="Yes" message="#message#" type="text" name="start_date" validate="#validate_style#" value="">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                                        </div>
                                    </div>
                                    <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                                        <div class="input-group">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                                            <cfinput required="Yes" message="#message#" type="text" name="finish_date" validate="#validate_style#" value="">
                                            <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </cf_box_search>
                    <cf_box_footer>
                        <cf_wrk_search_button button_type="0">
                    </cf_box_footer>
                </cf_box>
            </div>
        </div>
    </div>
</cfform>