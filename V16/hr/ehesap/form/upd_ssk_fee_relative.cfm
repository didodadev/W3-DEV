<cf_get_lang_set module_name="ehesap">
<cfinclude template="../query/get_fee_relative.cfm">
<cfif len(GET_FEE_RELATIVE.BRANCH_ID)>
	<cfquery name="get_ssk_offices" datasource="#dsn#">
		SELECT
			BRANCH_NAME,		
			SSK_OFFICE,
			SSK_NO
		FROM
			BRANCH
		WHERE
			BRANCH_ID = #GET_FEE_RELATIVE.BRANCH_ID#
	</cfquery>
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
    <cf_box>
        <cfform name="ssk_fee"  method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_upd_ssk_fee_relative">
            <cfoutput query="get_fee_relative">
                            <input type="hidden" name="FEE_ID" id="FEE_ID" value="#FEE_ID#">	
                            <cf_box_elements>
                                <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                                    <div class="form-group" id="item-emp_name">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57576.Çalışan'>*</label>
                                        <div class="col col-8 col-xs-12">
                                            <div class="input-group">
                                                <input type="hidden" name="employee_id" id="employee_id" value="#employee_id#">
                                                <input type="hidden" name="in_out_id" id="in_out_id" value="#in_out_id#">
                                                <input type="text" name="emp_name" id="emp_name" style="width:148px;" value="#employee_name# #employee_surname#" readonly>
                                                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=ssk_fee.in_out_id&field_emp_name=ssk_fee.emp_name&field_emp_id=ssk_fee.employee_id','list');"></span>
                                                <span class="input-group-addon  icon-pluss" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.employee_relative_ssk&event=add&field_name=ssk_fee.ill_name&field_surname=ssk_fee.ill_surname&field_relative=ssk_fee.ill_relative&field_birth_date=ssk_fee.BIRTH_DATE&field_birth_place=ssk_fee.BIRTH_PLACE&field_tc_identy_no=ssk_fee.TC_IDENTY_NO&employee_id='+document.ssk_fee.employee_id.value,'list');return false" title="<cf_get_lang dictionary_id ='53445.Vizite Alacak Kişinin'>"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <cfif len(GET_FEE_RELATIVE.BRANCH_ID)>
                                        <div class="form-group" id="item-BRANCH_NAME">
                                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                                            <div class="col col-8 col-xs-12">
                                                #get_ssk_offices.BRANCH_NAME#-#get_ssk_offices.SSK_OFFICE#-#get_ssk_offices.SSK_NO#
                                            </div>
                                        </div>
                                    </cfif>
                                    <div class="form-group" id="item-ill_name">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57897.Adı'>*</label>
                                        <div class="col col-8 col-xs-12">
                                            <input type="text" name="ill_name" id="ill_name" value="#ILL_NAME#">
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-ill_surname">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58550.Soyadı'>*</label>
                                        <div class="col col-8 col-xs-12">
                                            <input type="text" name="ill_surname" id="ill_surname" value="#ILL_SURNAME#">
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-ill_relative">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='53143.Yakınlığı'>*</label>
                                        <div class="col col-8 col-xs-12">
                                            <input type="text" name="ill_relative"  id="ill_relative" value="#ILL_RELATIVE#">
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-ill_sex">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57764.Cinsiyet'></label>
                                        <div class="col col-4 col-xs-12">
                                            <label><input type="radio" name="ill_sex" id="ill_sex" value="1" <cfif get_fee_relative.ill_sex eq 1>checked</cfif>><cf_get_lang dictionary_id='58959.Erkek'></label>
                                        </div>
                                        <div class="col col-4 col-xs-12">
                                            <label><input type="radio" name="ill_sex" id="ill_sex" value="0" <cfif get_fee_relative.ill_sex neq 1>checked</cfif>><cf_get_lang dictionary_id='58958.Kadın'></label>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-BIRTH_DATE">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58727.Doğum Tarihi'>*</label>
                                        <div class="col col-8 col-xs-12">
                                            <div class="input-group">
                                                <cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu alan"> : <cf_get_lang dictionary_id='58727.Doğum Tarihi'></cfsavecontent>
                                                <cfinput validate="#validate_style#" type="text" name="BIRTH_DATE" id="BIRTH_DATE" value="#DateFormat(BIRTH_DATE,dateformat_style)#"  required="yes" message="#message#">
                                                <span class="input-group-addon"><cf_wrk_date_image date_field="BIRTH_DATE"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-BIRTH_PLACE">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57790.Doğum Yeri'>*</label>
                                        <div class="col col-8 col-xs-12">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu alan"> : <cf_get_lang dictionary_id='57790.Doğum Yeri'></cfsavecontent>
                                            <cfinput type="text" name="BIRTH_PLACE" id="BIRTH_PLACE"  value="#BIRTH_PLACE#" required="yes" message="#message#">
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-TC_IDENTY_NO">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='58025.TC Kimlik No'>*</label>
                                        <div class="col col-8 col-xs-12">
                                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu alan"> : <cf_get_lang dictionary_id ='58025.TC Kimlik No'></cfsavecontent>
                                            <cf_duxi type="text" name="TC_IDENTY_NO" id="TC_IDENTY_NO" value="#TC_IDENTY_NO#" hint="TC Kimlik No" gdpr="2"  required="yes" maxlength="11" data_control="isnumber">
                                        </div>
                                    </div>
                                    <div class="form-group" id="item-DATE">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='53144.Vizite Tarih'>*</label>
                                        <div class="col col-8 col-xs-12">
                                            <div class="col col-8 col-xs-8">
                                                <div class="input-group">
                                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu alan"> : <cf_get_lang dictionary_id='53144.Vizite Tarihi'></cfsavecontent>
                                                    <cfinput validate="#validate_style#" type="text" name="DATE" id="DATE" value="#dateformat(FEE_DATE,dateformat_style)#" style="width:70px;" required="yes" message="#message#">
                                                    <span class="input-group-addon"><cf_wrk_date_image date_field="DATE"></span>
                                                </div>
                                            </div>
                                                <div class="col col-4 col-xs-4">
                                                    <cfoutput>
                                                        <cf_wrkTimeFormat name="HOUR" value="#FEE_HOUR#">                                                
                                                    </cfoutput>
                                                </div>
                                        </div>
                                    </div>
                                    <cfif len(validator_pos_code_1) and not len(valid_1)>
                                    <div class="form-group" id="item-valid_name">
                                        <label class="col col-4 col-xs-12">1.<cf_get_lang dictionary_id ='53938.Amir Onay'></label>
                                        <label class="col col-8 col-xs-12"><cfoutput>#get_emp_info(validator_pos_code_1,1,0)#</cfoutput>
                                            <cf_get_lang dictionary_id ='57615.Onay Bekliyor'> !</label>
                                    </div>
                                    <cfelseif len(validator_pos_code_1) and len(valid_1)>
                                    <div class="form-group" id="item-valid_name">
                                        <label class="col col-4 col-xs-12">1.<cf_get_lang dictionary_id ='53938.Amir Onay'></label>
                                        <label class="col col-8 col-xs-12">
                                            <cfoutput>#get_emp_info(validator_pos_code_1,1,0)#</cfoutput>&nbsp;&nbsp;
                                            <cfif valid_1 eq 1>
                                                <cf_get_lang dictionary_id='58699.Onayladı'>
                                            <cfelseif valid_1 eq 0>
                                                <cf_get_lang dictionary_id='57617.Reddetti'>
                                            </cfif>
                                        </label>
                                    </div>
                                    </cfif>
                                    <cfif len(validator_pos_code_2) and not len(valid_2)>
                                    <div class="form-group" id="item-valid_name">
                                        <label class="col col-4 col-xs-12">2.<cf_get_lang dictionary_id ='53938.Amir Onay'></label>
                                        <label class="col col-8 col-xs-12">
                                            <cfoutput>#get_emp_info(validator_pos_code_2,1,0)#</cfoutput>&nbsp;&nbsp;
                                            <cf_get_lang dictionary_id ='57615.Onay Bekliyor'>!
                                        </label>
                                    </div>
                                    <cfelseif len(validator_pos_code_2) and len(valid_2)>
                                    <div class="form-group" id="item-valid_name">
                                        <label class="col col-4 col-xs-12">2.<cf_get_lang dictionary_id ='53938.Amir Onay'></label>
                                        <label class="col col-8 col-xs-12">
                                            <cfoutput>#get_emp_info(validator_pos_code_2,1,0)#</cfoutput>&nbsp;&nbsp;
                                            <cfif valid_2 eq 1>
                                                <cf_get_lang dictionary_id='58699.Onayladı'>
                                            <cfelseif valid_2 eq 0>
                                                <cf_get_lang dictionary_id='57617.Reddetti'>
                                            </cfif>
                                        </label>
                                    </div>
                                    </cfif>
                                    <div class="form-group" id="item-valid_name">
                                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57500.Onay'>*</label>
                                        <div class="col col-8 col-xs-12">
                                                <cfif LEN(VALID_EMP)>
                                                    #get_emp_info(VALID_EMP, 0, 0)#
                                                    <cfif valid eq 1>
                                                        <cf_get_lang dictionary_id='58699.Onayladı'>
                                                    <cfelseif valid eq 0>
                                                        <cf_get_lang dictionary_id='57617.Reddetti'>
                                                    <cfelse>
                                                        !!! <cf_get_lang dictionary_id='53523.Belirsiz'> !!!
                                                    </cfif>
                                                <cfelse>
                                                    <cfif session.ep.position_code eq validator_pos_code>
                                                        <input type="hidden" name="valid" id="valid" value="">
                                                        <div class="col col-4 col-xs-12">
                                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='53999.Onaylamakta Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir Onaylamak istediğinizden emin misiniz '></cfsavecontent>
                                                            <input class=" ui-wrk-btn ui-wrk-btn-success" type="button" value="<cfoutput>#getLang('','Onayla',58475)#</cfoutput>" name="vazgec" onclick="if(confirm('#message#')) approve_fee(); else return false;" />
                                                        </div>
                                                        <div class="col col-4 col-xs-12">
                                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='54000.Reddetmekte Olduğunuz belge şirketinizi ve sizi bağlayacak konular içerebilir. Reddetmek istediğinizden emin misiniz'></cfsavecontent>
                                                            <input class=" ui-wrk-btn ui-wrk-btn-red" type="button" value="<cfoutput>#getLang('','Reddet',58461)#</cfoutput>" name="vazgec" onclick="if(confirm('#message#')) refusal_fee(); else return false;" />
                                                        </div>
                                                    <cfelse>
                                                        <input type="hidden" name="validator_pos_code" id="validator_pos_code" value="<cfoutput>#validator_pos_code#</cfoutput>">
                                                        <cfinput type="text" name="valid_name" id="valid_name" value="#get_emp_info(validator_pos_code, 1, 0)#" readonly="yes" >
                                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('#request.self#?fuseaction=hr.popup_list_positions&field_code=ssk_fee.validator_pos_code&field_emp_name=ssk_fee.valid_name','list');return false"></span>
                                                    </cfif>
                                            </cfif>
                                        </div>
                                    </div>
                                </div>
                            </cf_box_elements>
                        <cf_box_footer>
                                <div class="col col-6">
                                    <cf_record_info query_name="GET_FEE_RELATIVE">
                                </div>
                                <div class="col col-6">
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id ='54001.Kayıtlı Viziteyi Siliyorsunuz Emin misiniz'></cfsavecontent>
                                    <cf_workcube_buttons is_upd='1' add_function='kontrol()'delete_page_url='#request.self#?fuseaction=#fusebox.circuit#.emptypopup_del_ssk_fee_relative&fee_id=#attributes.fee_id#' delete_alert='#message#'>
                                </div>
                            </cf_box_footer>
                    
            </cfoutput>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
function approve_fee() {
    ssk_fee.valid.value='1';
    window.location ="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_upd_ssk_fee_relative</cfoutput>";
    ssk_fee.submit();
}
function refusal_fee() {
    ssk_fee.valid.value='0';
    window.location ="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_upd_ssk_fee_relative</cfoutput>";
    ssk_fee.submit();
}
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
	if (document.getElementById('validator_pos_code').value == "" || document.getElementById('valid_name').value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id ='53995.Onaylayacak'>");
		return false;
	}
	return true;
}
</script>
