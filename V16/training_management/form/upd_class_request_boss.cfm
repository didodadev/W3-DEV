<cfquery name="get_boss" datasource="#dsn#">
  SELECT 
  	TRAIN_REQUEST_ID, 
    EMPLOYEE_ID, 
    POSITION_CODE, 
    REQUEST_YEAR, 
    FIRST_BOSS_ID, 
    FIRST_BOSS_CODE, 
    FIRST_BOSS_VALID, 
    SECOND_BOSS_ID,
    SECOND_BOSS_CODE, 
    SECOND_BOSS_VALID, 
    THIRD_BOSS_ID, 
    THIRD_BOSS_CODE, 
    THIRD_BOSS_VALID, 
    FOURTH_BOSS_ID, 
    FOURTH_BOSS_CODE, 
    FOURTH_BOSS_VALID, 
    FIFTH_BOSS_ID, 
    FIFTH_BOSS_CODE, 
    FIFTH_BOSS_VALID, 
    FORM_VALID, 
    RECORD_EMP, 
    RECORD_DATE, 
    RECORD_IP, 
    UPDATE_DATE, 
    UPDATE_EMP, 
    UPDATE_IP
  FROM 
  	TRAINING_REQUEST 
  WHERE 
  	TRAIN_REQUEST_ID=#attributes.train_req_id#
</cfquery>
<cfform name="add_request_boss" method="post" action="#request.self#?fuseaction=training_management.emptypopup_upd_class_request_boss">
<input type="hidden" name="train_req_id" id="train_req_id" value="<cfoutput>#attributes.train_req_id#</cfoutput>">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
        <tr class="color-border">
            <td>
                <table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
                    <tr class="color-list">
                        <td height="35" class="headbold">&nbsp;Amir Listesi</td>
                    </tr>
                    <tr class="color-row">
                        <td valign="top">		
                            <table border="0">
                                <tr>
                                    <td>İlk Amir 1</td>
                                    <td>
                                        <input type="hidden" name="amir_id_1" id="amir_id_1" value="<cfoutput>#get_boss.first_boss_id#</cfoutput>">
                                        <input type="hidden" name="amir_code_1" id="amir_code_1" value="<cfoutput>#get_boss.first_boss_code#</cfoutput>">
                                        <cfif get_boss.first_boss_valid eq 1><cfset AMIR_1_NAME=get_emp_info(get_boss.first_boss_id,0,0)><cfelse><cfset AMIR_1_NAME=get_emp_info(get_boss.first_boss_code,1,0)></cfif>
                                        <cfinput type="text" name="amir_name_1" value="#amir_1_name#" style="width:180px;" onBlur="temizle('amir_name_1','amir_id_1','amir_code_1')">
                                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_request_boss.amir_id_1&field_name=add_request_boss.amir_name_1&field_code=add_request_boss.amir_code_1&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0"></a>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Üst Amir 2</td>
                                    <td>
                                        <input type="hidden" name="amir_id_2" id="amir_id_2" value="<cfoutput>#get_boss.second_boss_id#</cfoutput>">
                                        <input type="hidden" name="amir_code_2" id="amir_code_2" value="<cfoutput>#get_boss.second_boss_code#</cfoutput>">
                                        <cfif get_boss.second_boss_valid eq 1><cfset AMIR_2_NAME=get_emp_info(get_boss.second_boss_id,0,0)><cfelse><cfset AMIR_2_NAME=get_emp_info(get_boss.second_boss_code,1,0)></cfif>
                                        <cfinput type="text" name="amir_name_2" value="#amir_2_name#" style="width:180px;" onBlur="temizle('amir_name_2','amir_id_2','amir_code_2')">
                                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_request_boss.amir_id_2&field_name=add_request_boss.amir_name_2&field_code=add_request_boss.amir_code_2&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0"></a>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Üst Amir 3</td>								
                                    <td>
                                        <input type="hidden" name="amir_id_3" id="amir_id_3" value="<cfoutput>#get_boss.third_boss_id#</cfoutput>">
                                        <input type="hidden" name="amir_code_3" id="amir_code_3" value="<cfoutput>#get_boss.third_boss_code#</cfoutput>">
                                        <cfif get_boss.third_boss_valid eq 1><cfset AMIR_3_NAME=get_emp_info(get_boss.third_boss_id,0,0)><cfelse><cfset AMIR_3_NAME=get_emp_info(get_boss.third_boss_code,1,0)></cfif>
                                        <cfinput type="text" name="amir_name_3" value="#amir_3_name#" style="width:180px;" onBlur="temizle('amir_name_3','amir_id_3','amir_code_3')">
                                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_request_boss.amir_id_3&field_name=add_request_boss.amir_name_3&field_code=add_request_boss.amir_code_3&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0"></a>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Üst Amir 4</td>								
                                    <td>
                                        <input type="hidden" name="amir_id_4" id="amir_id_4" value="<cfoutput>#get_boss.fourth_boss_id#</cfoutput>">
                                        <input type="hidden" name="amir_code_4" id="amir_code_4" value="<cfoutput>#get_boss.fourth_boss_code#</cfoutput>">
                                        <cfif get_boss.fourth_boss_valid eq 1><cfset AMIR_4_NAME=get_emp_info(get_boss.fourth_boss_id,0,0)><cfelse><cfset AMIR_4_NAME=get_emp_info(get_boss.fourth_boss_code,1,0)></cfif>
                                        <cfinput type="text" name="amir_name_4" value="#amir_4_name#" style="width:180px;" onBlur="temizle('amir_name_4','amir_id_4','amir_code_4')">
                                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_request_boss.amir_id_4&field_name=add_request_boss.amir_name_4&field_code=add_request_boss.amir_code_4&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0"></a>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Üst Amir 5</td>								
                                    <td>
                                        <input type="hidden" name="amir_id_5" id="amir_id_5" value="<cfoutput>#get_boss.fifth_boss_id#</cfoutput>">
                                        <input type="hidden" name="amir_code_5" id="amir_code_5" value="<cfoutput>#get_boss.fifth_boss_code#</cfoutput>">
                                        <cfif get_boss.fifth_boss_valid eq 1><cfset AMIR_5_NAME=get_emp_info(get_boss.fifth_boss_id,0,0)><cfelse><cfset AMIR_5_NAME=get_emp_info(get_boss.fifth_boss_code,1,0)></cfif>
                                        <cfinput type="text" name="amir_name_5" value="#amir_5_name#" style="width:180px;" onBlur="temizle('amir_name_5','amir_id_5','amir_code_5')">
                                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_request_boss.amir_id_5&field_name=add_request_boss.amir_name_5&field_code=add_request_boss.amir_code_5&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0"></a>
                                    </td>
                                </tr>
                                <tr>
                                	<td height="35" colspan="5" style="text-align:right;"><cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()' insert_alert = 'Formun Onay Sürecleri Başa Alınacaktır. Güncellemek İstediğinizden Emin misiniz?'></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</cfform>
<script type="text/javascript">
function temizle(alan,alan_id,alan_code)
{
	if(trim(eval('document.add_request_boss.'+alan).value).length==0)
	{
		eval('document.add_request_boss.'+alan_id).value='';
		eval('document.add_request_boss.'+alan_code).value='';
	}
}
function kontrol()
{
	if(document.add_request_boss.amir_name_1.value.length==0 || document.add_request_boss.amir_id_1.value.length==0 || document.add_request_boss.amir_code_1.value.length==0)
	{
		alert('İlk Amiri Seçmelisiniz!');
		return false;
	}
	return true;	
}
</script>
