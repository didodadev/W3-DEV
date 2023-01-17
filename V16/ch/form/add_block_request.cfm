<cfquery name="get_block_group" datasource="#dsn#">
	SELECT  BLOCK_GROUP_ID,BLOCK_GROUP_NAME FROM BLOCK_GROUP
</cfquery>
<cf_catalystHeader>
<cf_box>
    <cfform name="add_block_request" method="post" action="#request.self#?fuseaction=ch.emptypopup_add_block_request">
        <cf_box_elements>
            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-process_cat">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'>*</label>
                    <div class="col col-8 col-xs-12">	
                        <cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
                    </div>
                </div>
                <div class="form-group" id="item-block_group">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50057.Bloklama Nedeni'></label>
                    <div class="col col-8 col-xs-12">
                        <select name="block_group" id="block_group" >
                            <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                            <cfoutput query="get_block_group">
                                <option value="#block_group_id#">#block_group_name#</option>
                            </cfoutput>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-member_id">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'>*</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="member_type" id="member_type" value="">
                            <input type="hidden" name="member_id" id="member_id" value="">
                            <input type="text" name="member_name" id="member_name"  readonly value="">
                            <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=add_block_request.member_name&field_comp_id=add_block_request.member_id&field_name=add_block_request.member_name&field_consumer=add_block_request.member_id&field_type=add_block_request.member_type&select_list=2,3','list');"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-blocker_employee_id">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58586.İşlem Yapan'> *</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="blocker_employee_id" id="blocker_employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
                            <input type="text" name="blocker_employee" id="blocker_employee" value="<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>" >
                            <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_block_request.blocker_employee_id&field_name=add_block_request.blocker_employee&select_list=1','list');"></span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group" id="item-block_start_date">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50054.Blok Tarihi'></label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfinput type="text" name="block_start_date" validate="#validate_style#" required="yes" value="#dateformat(now(),dateformat_style)#" maxlength="10" >
                            <span class="input-group-addon"><cf_wrk_date_image date_field="block_start_date"></span>
                            <span class="input-group-addon no-bg"></span>
                            <cfinput type="text" name="block_finish_date" validate="#validate_style#" value="#dateformat(now(),dateformat_style)#" maxlength="10" >
                            <span class="input-group-addon"><cf_wrk_date_image date_field="block_finish_date"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-detail">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
                    <div class="col col-8 col-xs-12">
                        <textarea name="detail" id="detail" style="width:155px;height:70px;"></textarea>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <div class="col col-12">
                <cf_workcube_buttons type_format="1" is_upd='0' add_function="kontrol()">
            </div>
        </cf_box_footer>

    </cfform>
</cf_box>
<script type="text/javascript">
	function kontrol()
	{
		if(document.add_block_request.member_name.value == "" || document.add_block_request.member_id.value == "")
		{
			alert("<cf_get_lang dictionary_id='54489.Lütfen Cari Hesap Seçiniz'>!");
			return false;
		}
		if(document.add_block_request.blocker_employee.value == "" || document.add_block_request.blocker_employee_id.value == "")
		{
			alert("<cf_get_lang dictionary_id='50053.Lütfen İşlem Yapan Seçiniz'>!");
			return false;
		}
		if(document.add_block_request.block_group.value == "")
		{
			alert("<cf_get_lang dictionary_id='65488.Lütfen Bloklama Nedeni Seçini'>!");
			return false;
		}
		if(!$("#block_start_date").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='41039.Lütfen Başlangıç Tarihi Giriniz'> !</cfoutput>"});
			return false;
		}
		return process_cat_control();
	}
</script>