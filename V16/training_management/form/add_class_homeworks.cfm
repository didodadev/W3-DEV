<cfset cfc = createObject('component','V16.training_management.cfc.training_management')>

<cf_box title="#getLang('','Ödev',63657)# #getLang('','Ekle',44630)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="add_homework_trainer" method="post">
	<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#class_id#</cfoutput>"> <!--- lesson_id --->
        <cf_box_elements>
            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id='63657.Ödev'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <cfinput type="text" name="homework" id="homework">
                </div>
            </div>
            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id='63657.Ödev'> <cf_get_lang dictionary_id='57771.Detay'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <textarea name="homework_detail" id="homework_detail" cols="30" rows="3"></textarea>
                </div>
            </div>
            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id='57645.Teslim Tarihi'></label>
                </div>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                    <div class="input-group">
                        <cfinput type="text" name="delivery_date" validate="#validate_style#" value="">
                        <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="delivery_date"></span>
                    </div>
                </div>
            </div>
            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id='57491.Saat'> / <cf_get_lang dictionary_id='58827.Dk'></label>
                </div>
                <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                    <div class="col col-2 col-sm-2 col-xs-6">
                        <cf_wrkTimeFormat name="event_start_clock" value="0">
                    </div>
                    <div class="col col-2 col-sm-2 col-xs-6">
                        <select name="event_start_minute" id="event_start_minute">
                            <option value="00" selected>00</option>
                            <option value="05">05</option>
                            <option value="10">10</option>
                            <option value="15">15</option>
                            <option value="20">20</option>
                            <option value="25">25</option>
                            <option value="30">30</option>
                            <option value="35">35</option>
                            <option value="40">40</option>
                            <option value="45">45</option>
                            <option value="50">50</option>
                            <option value="55">55</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                    <label><cf_get_lang dictionary_id='63658.Ödevi Veren'></label>
                </div>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                    <div class="input-group">
                        <input type="hidden" name="emp_id" id="emp_id" value="">
                        <input type="hidden" name="par_id" id="par_id" value="">
                        <input type="hidden" name="cons_id" id="cons_id" value="">
                        <input type="hidden" name="member_type" id="member_type" value="">
                        
                        <cfinput type="text" name="emp_par_name" id="emp_par_name" value="" onFocus="AutoComplete_Create('emp_par_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2,3\',0,0,0','EMPLOYEE_ID,PARTNER_ID,CONSUMER_ID','emp_id,par_id,cons_id','add_homework_trainer','3','110');" autocomplete="off">
                        <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_homework_trainer.emp_id&field_name=add_homework_trainer.emp_par_name&field_type=add_homework_trainer.member_type&field_partner=add_homework_trainer.par_id&field_consumer=add_homework_trainer.cons_id&select_list=1<cfif get_module_user(4)>,2,8</cfif></cfoutput>','list');"></span>
                    </div>
                </div>
            </div>
        </cf_box_elements>
		<cf_box_footer>
            <cf_workcube_buttons
                is_upd='0'
                add_function="kontrol()"
                data_action = "/V16/training_management/cfc/training_management:add_homework"
                next_page="#request.self#?fuseaction=training_management.list_class&event=upd&class_id=#attributes.class_id#"
            >
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
	function kontrol()
	{
		if ($("#emp_id").val() == '' && $("#par_id").val() == '' && $("#cons_id").val() == '')
		{
			alert('Listeden eğitimci seçiniz!');
			return false;
		}
		return true;
	}
</script>
