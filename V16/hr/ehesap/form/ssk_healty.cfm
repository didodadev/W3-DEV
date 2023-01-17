<cf_get_lang_set module_name="ehesap">
<cf_catalystHeader>
<cfform name="ssk_fee" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_emp_relative_healty">
<div class="row">
    <div class="col col-12 uniqueRow">
        <div class="row formContent">
            <div class="row" type="row">
                <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-emp_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57576.Çalışan'>*</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                            	<input type="hidden" name="employee_id" id="employee_id" value="">
                                <input type="hidden" name="in_out_id" id="in_out_id" value="">
                                <input type="text" name="emp_name" id="emp_name" style="width:150px;" value="" autocomplete="off" onFocus="AutoComplete_Create('emp_name','FULLNAME,TC_IDENTY_NO,SOCIALSECURITY_NO,RETIRED_SGDP_NUMBER,BRANCH_NAME','FULLNAME,BRANCH_NAME','get_in_outs_autocomplete','','FULLNAME,EMPLOYEE_ID,IN_OUT_ID','emp_name,employee_id,in_out_id','ssk_fee','3','300');">
                            	<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=ssk_fee.in_out_id&field_emp_name=ssk_fee.emp_name&field_emp_id=ssk_fee.employee_id','list');"></span>
                            	<span class="input-group-addon  icon-pluss" onClick="javascript:if(document.ssk_fee.employee_id.value!=''){windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.employee_relative_ssk&event=add&field_name=ssk_fee.ill_name&field_surname=ssk_fee.ill_surname&field_relative=ssk_fee.ill_relative&field_birth_date=ssk_fee.BIRTH_DATE&field_birth_place=ssk_fee.BIRTH_PLACE&field_tc_identy_no=ssk_fee.TC_IDENTY_NO&field_ill_sex=ssk_fee.ill_sex&employee_id='+document.ssk_fee.employee_id.value,'list');}else {alert('Çalışan seçiniz');return false;}"   title="<cfoutput>#getlang('ehesap',1002)#</cfoutput>"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-ill_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57897.Adı'>*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="ill_name" id="ill_name" style="width:150px;"  value="">
                        </div>
                    </div>
                    <div class="form-group" id="item-ill_surname">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58550.Soyadı'>*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="ill_surname" id="ill_surname" style="width:150px;"  value="">
                        </div>
                    </div>
                    <div class="form-group" id="item-ill_relative">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='53143.Yakınlığı'>*</label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="ill_relative" id="ill_relative" style="width:150px;"  value="">
                        </div>
                    </div>
                    <div class="form-group" id="item-ill_sex">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
                        <div class="col col-8 col-xs-12">
                            <label><input type="radio" name="ill_sex" id="ill_sex" value="1" checked><cf_get_lang dictionary_id='58959.Erkek'></label>
                            <label><input type="radio" name="ill_sex" id="ill_sex" value="0"><cf_get_lang dictionary_id='58958.Kadın'></label>
                        </div>
                    </div>
                    <div class="form-group" id="item-BIRTH_PLACE">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57790.Doğum Yeri'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="BIRTH_PLACE" id="BIRTH_PLACE" style="width:150px;"  value="">
                        </div>
                    </div>
                    <div class="form-group" id="item-BIRTH_DATE">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58727.Doğum Tarihi'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id="57477.Hatalı Veri"> : <cf_get_lang dictionary_id='58727.Doğum Tarihi'></cfsavecontent>
            					<cfinput validate="#validate_style#" type="text" name="BIRTH_DATE" id="BIRTH_DATE" value="" style="width:150px;" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="BIRTH_DATE"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-TC_IDENTY_NO">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58025.TC Kimlik No'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id ='58025.TC Kimlik No'></cfsavecontent>
        					<cfinput type="text" name="TC_IDENTY_NO" id="TC_IDENTY_NO" style="width:150px;" validate="integer" value="" onKeyUp="isNumber(this)" maxlength="11" required="yes" message="#message#">
                        </div>
                    </div>
                    <div class="form-group" id="item-ARRANGEMENT_DATE">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='53947.Düzenleme T'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                            	<cfsavecontent variable="messafe"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id ='53947.Düzenleme Tarihi'></cfsavecontent>
					            <cfinput validate="#validate_style#" type="text" name="ARRANGEMENT_DATE" id="ARRANGEMENT_DATE" value="#dateformat(now(),dateformat_style)#" style="width:150px;" message="#messafe#" required="yes">
                    			<span class="input-group-addon"><cf_wrk_date_image date_field="ARRANGEMENT_DATE"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57771.Detay'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="detail" id="detail" style="width:150px;height:60px;"></textarea>
                        </div>
                    </div>
                    <div class="form-group" id="item-document_no">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="document_no" id="document_no" style="width:150px;" value=""/>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row formContentFooter">
                <div class="col col-12">
                    <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                </div>
            </div>
        </div>
    </div>
</div>
</cfform>
<script type="text/javascript">
function kontrol()
{
	if (document.getElementById('employee_id').value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id ='57576.Çalışan'>");
		return false;
	}
	if (document.getElementById('in_out_id').value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id ='57576.Çalışan'>");
		return false;
	}
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
