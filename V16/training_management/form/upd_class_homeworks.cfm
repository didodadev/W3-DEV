<cfset cfc = createObject('component','V16.training_management.cfc.training_management')>
<cfset homework = cfc.get_homework_by_id(homework_id: attributes.homework_id)>
<cfif homework.MEMBER_TYPE eq 'employee'>
    <cfset userid = homework.EMP_ID>
<cfelseif homework.MEMBER_TYPE eq 'partner'>
    <cfset userid = homework.PAR_ID>
<cfelse>
    <cfset userid = homework.CONS_ID>
</cfif>

<cfset employee = cfc.get_employee(userid: userid, member_type: homework.MEMBER_TYPE)>

<cf_box title="#getLang('','Ödev',63657)# #getLang('','Ekle',44630)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="add_homework_trainer" method="post">
	<input type="hidden" name="homework_id" id="homework_id" value="<cfoutput>#homework_id#</cfoutput>"> <!--- lesson_id --->
		 <cf_box_elements>
            <cfoutput>
                <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='63657.Ödev'></label>
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                        <cfinput type="text" name="homework" id="homework" value="#homework.homework#">
                    </div>
                </div>
                <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='63657.Ödev'> <cf_get_lang dictionary_id='57771.Detay'></label>
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                        <textarea name="homework_detail" id="homework_detail" cols="30" rows="3">#homework.detail#</textarea>
                    </div>
                </div>
                <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                    <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='57645.Teslim Tarihi'></label>
                    </div>
                    <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                        <div class="input-group">
                            <cfinput type="text" name="delivery_date" validate="#validate_style#" value="#dateformat(homework.delivery_date, dateformat_style)#">
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="delivery_date"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group col col-8 col-md-8 col-sm-8 col-xs-12">
                     <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                        <label><cf_get_lang dictionary_id='57491.Saat'> / <cf_get_lang dictionary_id='58827.Dk'></label>
                    </div>
                    <div class="col col-9 col-md-9 col-sm-9 col-xs-12">
                        <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                            <cf_wrkTimeFormat  name="event_start_clock" id="event_start_clock" value="#timeformat(homework.delivery_date,'HH')#">
                        </div>
                        <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                            <select name="event_start_minute" id="event_start_minute">
                                <option value="00">00</option>
                                <option value="05"<cfif timeformat(homework.delivery_date,'MM') eq 05> selected</cfif>>05</option>
                                <option value="10"<cfif timeformat(homework.delivery_date,'MM') eq 10> selected</cfif>>10</option>
                                <option value="15"<cfif timeformat(homework.delivery_date,'MM') eq 15> selected</cfif>>15</option>
                                <option value="20"<cfif timeformat(homework.delivery_date,'MM') eq 20> selected</cfif>>20</option>
                                <option value="25"<cfif timeformat(homework.delivery_date,'MM') eq 25> selected</cfif>>25</option>
                                <option value="30"<cfif timeformat(homework.delivery_date,'MM') eq 30> selected</cfif>>30</option>
                                <option value="35"<cfif timeformat(homework.delivery_date,'MM') eq 35> selected</cfif>>35</option>
                                <option value="40"<cfif timeformat(homework.delivery_date,'MM') eq 40> selected</cfif>>40</option>
                                <option value="45"<cfif timeformat(homework.delivery_date,'MM') eq 45> selected</cfif>>45</option>
                                <option value="50"<cfif timeformat(homework.delivery_date,'MM') eq 50> selected</cfif>>50</option>
                                <option value="55"<cfif timeformat(homework.delivery_date,'MM') eq 55> selected</cfif>>55</option>
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
                            <input type="hidden" name="emp_id" id="emp_id" value="#userid#">
                            <input type="hidden" name="par_id" id="par_id" value="#userid#">
                            <input type="hidden" name="cons_id" id="cons_id" value="#userid#">
                            <cfinput type="hidden" name="member_type" id="member_type" value="#homework.member_type#">
                
                            <cfinput type="text" name="emp_par_name" id="emp_par_name" value="#employee.name_surname#" onFocus="AutoComplete_Create('emp_par_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2,3\',0,0,0','EMPLOYEE_ID,PARTNER_ID,CONSUMER_ID','emp_id,par_id,cons_id','add_homework_trainer','3','110');" autocomplete="off">
                            <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_homework_trainer.emp_id&field_name=add_homework_trainer.emp_par_name&field_type=add_homework_trainer.member_type&field_partner=add_homework_trainer.par_id&field_consumer=add_homework_trainer.cons_id&select_list=1<cfif get_module_user(4)>,2,8</cfif></cfoutput>','list');"></span>
                        </div>
                    </div>
                </div>
            </cfoutput>
        </cf_box_elements>
		<cf_box_footer>
            <cf_workcube_buttons
                is_upd='1'
                add_function="kontrol()"
                data_action = "/V16/training_management/cfc/training_management:upd_homework"
                next_page="#request.self#?fuseaction=training_management.list_class&event=upd&class_id=#homework.lesson_id#"
                del_action= '/V16/training_management/cfc/training_management:del_homework:homework_id=#attributes.homework_id#'
                del_next_page = '#request.self#?fuseaction=training_management.list_class&event=upd&class_id=#homework.lesson_id#'
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
