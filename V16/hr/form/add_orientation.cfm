
<cfsavecontent  variable="message"><cf_get_lang dictionary_id='32210.oryantasyon eğitimleri'><cf_get_lang dictionary_id='57582.ekle'>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12" >
    <cf_box title="#message#"popup_box="1">
        <cfform name="add_orientation" method="post" action="#request.self#?fuseaction=hr.emptypopup_add_orientation">
            <input type="hidden" name="counter" id="counter">
            <cf_box_elements>
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-ORIENTATION_HEAD">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58820.Başlık'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58820.Başlık'></cfsavecontent>
                            <cfinput type="text" name="ORIENTATION_HEAD" id="ORIENTATION_HEAD" style="width:175px" required="Yes" message="#message#" value="">
                        </div>
                    </div>
                    <div class="form-group" id="item-emp_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29780.Katılımcı'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="emp_id" id="emp_id" value="">
                                <input type="text" name="emp_name" id="emp_name" value="" style="width:175px;">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_positions&field_emp_id=add_orientation.emp_id&field_emp_name=add_orientation.emp_name</cfoutput>','list');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-trainer_emp_name">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="trainer_emp_id" id="trainer_emp_id" value="">
                                <input type="text" name="trainer_emp_name" id="trainer_emp_name" value="" style="width:175px;">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_positions&field_emp_id=add_orientation.trainer_emp_id&field_emp_name=add_orientation.trainer_emp_name</cfoutput>','list');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-start_date">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç tarihi'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.başlangıç tarihi girmelisiniz'></cfsavecontent>
                                <cfinput  validate="#validate_style#" message="#message#" type="text" name="start_date" id="start_date" style="width:175px;" maxlength="10" required="yes">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-finish_date">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş tarihi'>*</label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.bitis tarihi girmelisiniz'></cfsavecontent>
                                <cfinput validate="#validate_style#" message="#message#" type="text" name="finish_date" id="finish_date" style="width:175px;" maxlength="10" required="yes">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='29484.Fazla karakter sayısı'></cfsavecontent>
                            <textarea name="detail" id="detail" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>" style="width:175px;height:90px;"></textarea>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <div class="row formContentFooter">
                <div class="col col-12">
                    <cf_workcube_buttons is_upd='0' add_function="kontrol()">
                </div>
            </div>
        </cfform>
    </cf_box>
</div>
<script language="javascript">
	function kontrol()
	{
		if(document.getElementById('emp_id').value == "" || document.getElementById('emp_name').value == "")
		{
			alert("<cf_get_lang dictionary_id='29780.Katılımcı'>");
			return false;
		}
	}
</script>
