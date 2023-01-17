<cfquery name="get_payment_request" datasource="#DSN#">
	SELECT 
		*
	FROM 
		SALARYPARAM_GET_REQUESTS 
	WHERE
	    SPGR_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cfset val_degeri=get_payment_request.IS_VALID>
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
    <cf_box>
        <cfform action="#request.self#?fuseaction=ehesap.emptypopup_upd_other_payment_request" name="form_upd_payment_request" method="POST" onsubmit="UnformatFields();">
            <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
            <cf_box_elements>
                <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-process_stage">
                        <label class="col col-4 col-xs-12 txtbold"><cf_get_lang dictionary_id='58859.Süreç'></label>
                        <div class="col col-8 col-xs-12">
                            <cf_workcube_process is_upd='0' select_value='#get_payment_request.process_stage#' process_cat_width='150' is_detail='1'>	
                        </div>
                    </div>
                    <div class="form-group" id="item-employee_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_payment_request.EMPLOYEE_ID#</cfoutput>">
                            <input type="text" name="employee_name" id="employee_name" style="width:170px;" value="<cfoutput>#get_emp_info(get_payment_request.EMPLOYEE_ID,0,0)#</cfoutput>" readonly>
                        </div>
                    </div>
                    <div class="form-group" id="item-employee_in_out_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='54066.Giriş Çıkış Kaydı'></label>
                        <div class="col col-8 col-xs-12">
                            <cfquery name="GET_IN_OUTS" datasource="#DSN#">
                                SELECT 
                                    EIO.IN_OUT_ID,E.EMPLOYEE_NAME,E.EMPLOYEE_SURNAME,B.BRANCH_NAME 
                                FROM 
                                    EMPLOYEES_IN_OUT EIO,
                                    EMPLOYEES E,
                                    BRANCH B
                                WHERE 
                                    E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
                                    B.BRANCH_ID = EIO.BRANCH_ID AND
                                    EIO.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_payment_request.employee_id#"> AND 
                                    (EIO.FINISH_DATE IS NULL OR EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(now())#">)
                            </cfquery>
                            <cfif GET_IN_OUTS.recordcount eq 1>
                                <cfoutput query="GET_IN_OUTS"><input type="text" readonly value="#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - #BRANCH_NAME#" style="width:170px;"></cfoutput>
                                <input type="hidden" id="employee_in_out_id" value="<cfoutput>#GET_IN_OUTS.in_out_id#</cfoutput>" name="employee_in_out_id">
                            <cfelse>
                                <select name="employee_in_out_id" id="employee_in_out_id" style="width:170px;">
                                    <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                    <cfoutput query="GET_IN_OUTS">
                                        <option value="#in_out_id#">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME# - #BRANCH_NAME#</option>
                                    </cfoutput>
                                </select>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-AMOUNT_GET">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" name="AMOUNT_GET" id="AMOUNT_GET" style="width:170px;" value="#TLFormat(get_payment_request.AMOUNT_GET)#"  onkeyup="return(FormatCurrency(this,event));" class="moneybox">
                        </div>
                    </div>
                    <div class="form-group" id="item-taksit">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='54064.Taksit Sayısı'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="taksit" id="taksit" style="width:170px;">
                                <cfloop from="1" to="36" index="i">
                                    <cfoutput>
                                        <option value="#i#" <cfif get_payment_request.TAKSIT_NUMBER eq i>selected</cfif>>#i#</option>
                                    </cfoutput>
                                    </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="detail" id="detail"  style="width:170px;height:40px;"  ><cfoutput>#get_payment_request.DETAIL#</cfoutput></textarea>
                        </div>
                    </div>
                    <cfif len(get_payment_request.validator_position_code_1) and not len(get_payment_request.valid_1)>
                        <div class="form-group" id="item-validator_position_code_1">
                            <label class="col col-4 col-xs-12">1. <cf_get_lang dictionary_id ='53938.Amir Onay'></label>
                            <label class="col col-8 col-xs-12">
                                <cfoutput>#get_emp_info(get_payment_request.validator_position_code_1,1,0)#</cfoutput><cf_get_lang dictionary_id ='57615.Onay Bekliyor '>!
                            </label>
                        </div>
                    <cfelseif len(get_payment_request.validator_position_code_1) and len(get_payment_request.valid_1) and get_payment_request.valid_1 eq 1>
                        <div class="form-group" id="item-validator_position_code_1">
                            <label class="col col-4 col-xs-12">1.<cf_get_lang dictionary_id ='53938.Amir Onay'></label>
                            <label class="col col-8 col-xs-12">
                                <cfoutput>#get_emp_info(get_payment_request.validator_position_code_1,1,0)#</cfoutput><cf_get_lang dictionary_id='58699.Onaylandı'>
                            </label>
                        </div>
                    <cfelseif len(get_payment_request.validator_position_code_1) and len(get_payment_request.valid_1) and get_payment_request.valid_1 eq 0>  
                        <div class="form-group" id="item-validator_position_code_1">
                            <label class="col col-4 col-xs-12">1.<cf_get_lang dictionary_id ='53938.Amir Onay'></label>
                            <label class="col col-8 col-xs-12">
                                <cfoutput>#get_emp_info(get_payment_request.validator_position_code_1,1,0)#</cfoutput><cf_get_lang dictionary_id ='57617.Reddedildi'>
                            </label>
                        </div>
                    </cfif>
                    <cfif len(get_payment_request.validator_position_code_2) and not len(get_payment_request.valid_2)>
                        <div class="form-group" id="item-validator_position_code_2">
                            <label class="col col-4 col-xs-12">2.<cf_get_lang dictionary_id ='53938.Amir Onay'></label>
                            <label class="col col-8 col-xs-12">
                                <cfoutput>#get_emp_info(get_payment_request.validator_position_code_2,1,0)#</cfoutput><cf_get_lang dictionary_id ='57615.Onay Bekliyor '>!
                            </label>
                        </div> 
                    <cfelseif len(get_payment_request.validator_position_code_2) and len(get_payment_request.valid_2) and get_payment_request.valid_2 eq 1>
                            <div class="form-group" id="item-validator_position_code_2">
                            <label class="col col-4 col-xs-12">2.<cf_get_lang dictionary_id ='53938.Amir Onay'></label>
                            <label class="col col-8 col-xs-12">
                                <cfoutput>#get_emp_info(get_payment_request.validator_position_code_2,1,0)#</cfoutput><cf_get_lang dictionary_id='58699.Onaylandı'>
                            </label>
                            </div>  
                    <cfelseif len(get_payment_request.validator_position_code_2) and len(get_payment_request.valid_2) and get_payment_request.valid_2 eq 0>
                            <label class="col col-4 col-xs-12">2.<cf_get_lang dictionary_id ='53938.Amir Onay'></label>
                        <label class="col col-8 col-xs-12">
                            <cfoutput>#get_emp_info(get_payment_request.validator_position_code_2,1,0)#</cfoutput><cf_get_lang dictionary_id ='57617.Reddedildi'>.
                        </label>
                    </cfif>
                    <!--- Sayfada işlevi olmadığı için kaldırıldı.
                        <div class="form-group" id="item-validator_position_code">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='53995.Onaylayacak'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" name="validator_position_code" id="validator_position_code"  style="width:170px;" value="<cfoutput>#get_emp_info(get_payment_request.VALIDATOR_POSITION_CODE,1,0)#</cfoutput>">
                        </div>
                    </div>--->
                    <div class="form-group" id="item-deny_acceptit_btn">
                        <label class="col col-4 col-xs-12"><span class="hide"><cf_get_lang dictionary_id='29537.Red'>/<cf_get_lang dictionary_id='53121.Kabul'></span></label>
                        <div class="col col-4 col-xs-12">
                            <input  type="button"	name="deny" id="deny" value="<cf_get_lang dictionary_id='29537.Red'>" onClick="window.location.href='<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_deny_other_payment_request&request_id=#id#&upd_id=0</cfoutput>';">
                        </div>
                        <div class="col col-4 col-xs-12">
                            <input  type="button"	name="acceptit" id="acceptit" value="<cf_get_lang dictionary_id='53121.Kabul'>" onClick="onay_islemi();">
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-6">
                    <cf_record_info query_name="get_payment_request">
                </div>
                <div class="col col-6">
                    <cf_workcube_buttons is_upd='1' add_function = 'kontrol()' delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_other_payment_request&id=#attributes.id#'>
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
function UnformatFields()
{
	document.getElementById('AMOUNT_GET').value = filterNum(document.getElementById('AMOUNT_GET').value);
}
function kontrol()
{
	if (document.getElementById('AMOUNT_GET').value =='' || document.getElementById('AMOUNT_GET').value ==0)
		{
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57673.Tutar'>");
			return false;		
		}
return true;
}
function onay_islemi()
{
//	x = document.form_upd_payment_request.employee_in_out_id.selectedIndex;
	if (document.getElementById('employee_in_out_id').value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id ='53181.Giriş-Çıkış'>");
		return false;
	}
	else
	{
	my_id = document.getElementById('employee_in_out_id').value;
	window.location.href='<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_deny_other_payment_request&request_id=#attributes.id#&upd_id=1&employee_in_out_id=</cfoutput>'+my_id;
	}
}
</script>
