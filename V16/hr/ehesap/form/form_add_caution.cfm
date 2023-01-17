<cfquery name="get_caution_type" datasource="#dsn#">
	SELECT 
		CAUTION_TYPE_ID, 
		CAUTION_TYPE, 
		DETAIL,
		RECORD_EMP, 
		RECORD_DATE, 
		RECORD_IP, 
		UPDATE_DATE, 
		UPDATE_EMP, 
		UPDATE_IP 	
	FROM 
		SETUP_CAUTION_TYPE 
	WHERE
		IS_ACTIVE = 1
	ORDER BY
		CAUTION_TYPE
</cfquery>
<cfquery name="GET_SPECIAL_DEFINITION" datasource="#dsn#">
    SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 11
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
	<cf_box>
        <cfform action="#request.self#?fuseaction=ehesap.emptypopup_add_caution" name="add_caution" method="post">
            <cf_box_elements>
                <div class="col col-6 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-is_active">
                        <label class="col col-3 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='57493.Aktif'></span></label>
                        <label class="col col-9 col-xs-12">
                            <input type="checkbox" name="is_active" id="is_active" value="1" checked="checked"><cf_get_lang dictionary_id='57493.Aktif'>
                        </label>
                    </div>
                    <div class="form-group" id="item-caution_head">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'></label>
                        <div class="col col-9 col-xs-12">
                            <cfinput type="text" name="caution_head" style="width:150px;" maxlength="50">
                        </div>
                    </div>
                    <div class="form-group" id="item-CAUTION_TYPE">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57630.Tip'></label>
                        <div class="col col-9 col-xs-12">
                            <select name="CAUTION_TYPE" id="CAUTION_TYPE" style="width:150px;">
                            <cfoutput query="get_caution_type">
                                <option value="#CAUTION_TYPE_ID#">#CAUTION_TYPE#</option>
                            </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-DATE">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfinput validate="#validate_style#" type="text" name="DATE" value="" style="width:150px;">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="DATE"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='58859.Süreç'></label>
                        <div class="col col-9 col-xs-12">
                            <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
                        </div>
                    </div>
                    <div class="form-group" id="item-DECISION_NO">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58772.İşlem No'></label>
                        <div class="col col-9 col-xs-12">
                            <input  type="text" name="DECISION_NO" id="DECISION_NO" value="" style="width:150px;">
                        </div>
                    </div>
                    <div class="form-group" id="item-warner">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58586.İşlem Yapan'>*</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="warner_id" id="warner_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
                                <cf_wrk_employee_positions form_name='add_caution' emp_id='warner_id' emp_name='warner'>
                                <input type="text" name="warner" id="warner" style="width:150px;" onkeyup="get_emp_pos_1();" value="<cfoutput>#session.ep.name# #session.ep.surname#</cfoutput>">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_caution.warner_id&field_emp_name=add_caution.warner','list');return false"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-caution_to">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53515.İşlem Yapılan'>*</label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="caution_to_id" id="caution_to_id">
                                <cf_wrk_employee_positions form_name='add_caution' emp_id='caution_to_id' emp_name='caution_to' is_multi_no='2'>
                                <input type="text" name="caution_to" id="caution_to" style="width:150px;" onkeyup="get_emp_pos_2();">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&select_list=1,9&field_emp_id=add_caution.caution_to_id&field_name=add_caution.caution_to','list');return false"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-special_definition">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="59306.Özel Tanım"></label>
                        <div class="col col-9 col-xs-12">
                            <select name="special_definition" id="special_definition" style="width:150px">
                                <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                <cfoutput query="GET_SPECIAL_DEFINITION">
                                    <option value="#special_definition_id#">#special_definition#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53275.Kesinti Türü'></label>
                        <div class="col col-9 col-xs-12">
                            <div class="input-group">
                                <cfoutput>
                                    <input type="hidden" name="interruption_id" id="interruption_id" value="" />
                                    <input type="text" name="interruption_name" id="interruption_name"  value="" readonly >
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.popup_list_kesinti&is_disciplinary_punishment=1');"></span>
                                </cfoutput>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='64060.Disiplin Ceza Kesintisi'></label>
                        <div class="col col-9 col-xs-12">
                            <cfoutput>
                                <div class="col col-5 col-xs-5">
                                    <input type="number" name="interruption_dividend" id="interruption_dividend"  value="" min="1" max="30">
                                </div>
                                <div class="col col-2 col-xs-2" style="text-align : center">
                                    /
                                </div>
                                <div class="col col-5 col-xs-5">
                                    <input type="number" name="interruption_denominator" id="interruption_denominator"  value="" min="1" max="30">
                                </div>
                            </cfoutput>
                        </div>
                    </div>
                    <div class="form-group" id="item-is_discipline_center">
                        <label class="col col-3 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='53339.Merkez Disiplin Kurulu'></span></label>
                        <label class="col col-9 col-xs-12">
                            <input type="checkbox" name="is_discipline_center" id="is_discipline_center"><cf_get_lang dictionary_id='53339.Merkez Disiplin Kurulu'>
                        </label>
                    </div>
                    <div class="form-group" id="item-is_discipline_branch">
                        <label class="col col-3 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='53340.Şube Disiplin Kurulu'></span></label>
                        <label class="col col-9 col-xs-12">
                            <input type="checkbox" name="is_discipline_branch" id="is_discipline_branch"><cf_get_lang dictionary_id='53340.Şube Disiplin Kurulu'>
                        </label>
                    </div>
                    <div class="form-group" id="item-CAUTION_DETAIL">
                        <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='30937.Gerekçe'></label>
                        <div class="col col-9 col-xs-12">
                            <textarea style="width:250px;height:100px;" name="CAUTION_DETAIL" id="CAUTION_DETAIL"></textarea>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>	
                <div class="col col-12">
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{
		if (add_caution.warner.value == "" || add_caution.warner_id.value == "")
			{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='58586.İşlem Yapan'>");
					return false;
			}
			
		if (add_caution.caution_to.value == "" || add_caution.caution_to_id.value == "")
			{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='53515.İşlem Yapılan'>");
					return false;
			}
		return process_cat_control();
	}
    function add_row(from_salary,show,comment_pay,period_pay,method_pay,term,start_sal_mon,end_sal_mon,amount_pay,calc_days,ehesap,row_id_,account_code,company_id,fullname,account_name,consumer_id,money,acc_type_id,tax,odkes_id)
	{
        document.getElementById('interruption_name').value = comment_pay;
        document.getElementById('interruption_id').value = odkes_id;
	}
</script>
