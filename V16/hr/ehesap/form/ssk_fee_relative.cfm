<cfparam name="attributes.employee_id" default="">
<cf_get_lang_set module_name="ehesap">
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
    <cf_box>    
        <cfform name="ssk_fee"  method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_add_ssk_fee_relative">
            <cf_box_elements>
                <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-emp_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57576.Çalışan'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="employee_id" id="employee_id" value="">
                                <input type="hidden" name="in_out_id" id="in_out_id" value="">
                                <input type="text" name="emp_name" id="emp_name" style="width:148px;" value="" readonly onChange="kontrol();">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=ssk_fee.in_out_id&field_emp_name=ssk_fee.emp_name&field_emp_id=ssk_fee.employee_id','list');"></span>
                                <span class="input-group-addon  icon-pluss" onclick="javascript:if(document.ssk_fee.employee_id.value !=''){windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.employee_relative_ssk&event=add&field_name=ssk_fee.ill_name&field_surname=ssk_fee.ill_surname&field_relative=ssk_fee.ill_relative&field_birth_date=ssk_fee.BIRTH_DATE&field_birth_place=ssk_fee.BIRTH_PLACE&field_tc_identy_no=ssk_fee.TC_IDENTY_NO&employee_id='+document.ssk_fee.employee_id.value,'list');}else {alert('<cf_get_lang no ='679.Çalışan Seçiniz'>');return false}" title="<cf_get_lang no ='499.Vizite Alacak Kişinin'>"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-ill_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57897.Adı'>*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="ill_name" id="ill_name" style="width:150px;" value="">
                        </div>
                    </div>
                    <div class="form-group" id="item-ill_surname">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58550.Soyadı'>*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="ill_surname" id="ill_surname" style="width:150px;" value="">
                        </div>
                    </div>
                    <div class="form-group" id="item-ill_relative">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='53143.Yakınlığı'>*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="ill_relative" id="ill_relative" style="width:150px;" value="">
                        </div>
                    </div>
                    <div class="form-group" id="item-ill_sex">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
                        <div class="col col-4 col-xs-12">
                            <label><input type="radio" name="ill_sex" id="ill_sex" value="1" checked><cf_get_lang dictionary_id='58959.Erkek'></label>
                        </div>
                        <div class="col col-4 col-xs-12">
                            <label><input type="radio" name="ill_sex" id="ill_sex" value="0"><cf_get_lang dictionary_id='58958.Kadın'></label>
                        </div>
                    </div>
                    <div class="form-group" id="item-BIRTH_DATE">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58727.Doğum Tarihi'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='58727.Doğum Tarihi'></cfsavecontent>
                                <cfinput validate="#validate_style#" type="text" name="BIRTH_DATE" id="BIRTH_DATE" value="" style="width:150px;" required="yes" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="BIRTH_DATE"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-BIRTH_PLACE">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57790.Doğum Yeri'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='57790.Doğum Yeri'></cfsavecontent>
                            <cfinput type="text" name="BIRTH_PLACE" id="BIRTH_PLACE" style="width:150px;" value="" required="yes" message="#message#">
                        </div>
                    </div>
                    <div class="form-group" id="item-TC_IDENTY_NO">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58025.TC Kimlik No'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='58025.TC Kimlik No'></cfsavecontent>
                            <cfinput type="text" name="TC_IDENTY_NO"  id="TC_IDENTY_NO" style="width:150px;" validate="integer" value="" onkeyup="isNumber(this);" onblur='isNumber(this);' required="yes" message="#message#" maxlength="11">
                        </div>
                    </div>
                    <div class="form-group" id="item-DATE">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='53144.Vizite Tarih'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="col col-8 col-xs-8">
                                <div class="input-group">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id ='53144.Vizite Tarih'></cfsavecontent>
                                    <cfinput validate="#validate_style#" type="text" name="DATE" id="DATE" value="" style="width:70px;" required="yes" message="#message#">
                                    <span class="input-group-addon"><cf_wrk_date_image date_field="DATE"></span>
                                </div>
                            </div>
                            <div class="col col-4 col-xs-4">
                                <cfoutput>
                                        <cf_wrkTimeFormat name="HOUR" value="0">
                                </cfoutput>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-valid_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57500.Onay'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="validator_pos_code" id="validator_pos_code" value="">
                                <cfinput type="text" name="valid_name" id="valid_name" value="" readonly="yes" style="width:150px;">
                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=ssk_fee.validator_pos_code&field_emp_name=ssk_fee.valid_name','list');return false"></span>
                            </div>
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
	if (document.getElementById('emp_name').value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id ='57576.Çalışan'>");
		return false;
	}
	if (document.getElementById('ill_name').value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id ='54341.Vizite Alacak Kişinin Adı'>");
		return false;
	}
	if (document.getElementById('ill_surname').value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id ='54342.Vizite Alacak Kişinin Soyadı'>");
		return false;
	}
	if (document.getElementById('ill_relative').value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id ='54343.Vizite Alacak Kişinin Yakınlığı'>");
		return false;
	}
	if (document.getElementById('TC_IDENTY_NO').value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id ='54344.Vizite Alacak Kişinin TC Kimlik Numarası'>");
		return false;
	}
	return true;
}
</script>
