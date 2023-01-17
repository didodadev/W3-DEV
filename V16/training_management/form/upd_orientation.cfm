<cfquery name="get_orientation" datasource="#dsn#">
  SELECT 
  	ORIENTATION_ID, 
    ORIENTATION_HEAD, 
    DETAIL, 
    START_DATE, 
    FINISH_DATE, 
    ATTENDER_EMP, 
    TRAINER_EMP, 
    IS_ABSENT, 
  FROM 
  	TRAINING_ORIENTATION 
  WHERE 
  	ORIENTATION_ID = #attributes.ORIENTATION_ID#
</cfquery>
<cfform name="add_orientation" method="post" action="#request.self#?fuseaction=training_management.emptypopup_upd_orientation">
<input type="hidden" name="counter" id="counter">
<input type="hidden" name="ORIENTATION_ID" id="ORIENTATION_ID" value="<cfoutput>#attributes.ORIENTATION_ID#</cfoutput>">
    <table width="100%" align="center" cellpadding="0" cellspacing="0" border="0" height="100%">
        <tr class="color-border">
            <td>
                <table width="100%" cellpadding="2" cellspacing="1" border="0" height="100%">
                    <tr height="35" class="color-list">
                        <td class="headbold"><cf_get_lang no='58.Oryantasyon'></td>
                    </tr>
                    <tr class="color-row">
                        <td valign="top">
                            <table>
                                <tr>
                                    <td width="3">&nbsp;</td>
                                    <td width="75"><cf_get_lang_main no='68.Başlık'></td>
                                    <td>
                                        <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1408.başlık'></cfsavecontent>
                                        <cfinput type="text" name="ORIENTATION_HEAD" style="width:200px;" required="Yes" message="#message#" value="#get_orientation.ORIENTATION_HEAD#">
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td><cf_get_lang_main no='89.Başlama'></td>
                                    <td>
                                        <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='641.başlangıç tarihi'></cfsavecontent>
                                        <cfinput  validate="#validate_style#" message="#message#" type="text" name="start_date" style="width:200px" maxlength="10" value="#dateformat(get_orientation.START_DATE,dateformat_style)#">
                                        <cf_wrk_date_image date_field="start_date">
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td><cf_get_lang_main no='90.Bitiş'></td>
                                    <td>
                                        <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='288.bitis tarihi'></cfsavecontent>
                                        <cfinput  validate="#validate_style#" message="#message#" type="text" name="finish_date" style="width:200px" maxlength="10" value="#dateformat(get_orientation.FINISH_DATE,dateformat_style)#">
                                        <cf_wrk_date_image date_field="finish_date">
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td><cf_get_lang_main no='1983.Katılımcı'></td>
                                    <td>
                                        <cfif LEN(get_orientation.ATTENDER_EMP)>
                                            <cfquery name="GET_EMP_NAME" datasource="#DSN#">
                                                SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #get_orientation.ATTENDER_EMP#
                                            </cfquery>
                                            <input type="hidden" name="emp_id" id="emp_id" value="<cfoutput>#get_orientation.ATTENDER_EMP#</cfoutput>">
                                            <input type="text" name="emp_name" id="emp_name" value="<cfoutput>#GET_EMP_NAME.EMPLOYEE_NAME# #GET_EMP_NAME.EMPLOYEE_SURNAME#</cfoutput>" style="width:200px">
                                        <cfelse> 
                                            <input type="hidden" name="emp_id" id="emp_id" value="">
                                            <input type="text" name="emp_name" id="emp_name" value="" style="width:200px">
                                        </cfif> 
                                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_orientation.emp_id&field_name=add_orientation.emp_name&select_list=1</cfoutput>','list');">
                                        <img src="/images/plus_thin.gif"  border="0" align="absmiddle">
                                        </a> 
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>
                                        <input type="checkbox" name="IS_ABSENT" id="IS_ABSENT" value="" <cfif get_orientation.IS_ABSENT is 1>checked</cfif>>Mazeretli / Katılmadı					
                                    </td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td><cf_get_lang_main no='132.Sorumlu'></td>
                                    <td>
                                        <cfif LEN(get_orientation.TRAINER_EMP)>
                                            <cfquery name="GET_EMP_NAME" datasource="#DSN#">
                                                SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = #get_orientation.TRAINER_EMP#
                                            </cfquery>
                                            <input type="hidden" name="trainer_emp_id" id="trainer_emp_id" value="<cfoutput>#get_orientation.TRAINER_EMP#</cfoutput>">
                                            <input type="text" name="trainer_emp_name" id="trainer_emp_name" value="<cfoutput>#GET_EMP_NAME.EMPLOYEE_NAME# #GET_EMP_NAME.EMPLOYEE_SURNAME#</cfoutput>" style="width:200px">
                                        <cfelse> 
                                            <input type="hidden" name="trainer_emp_id" id="trainer_emp_id" value="">
                                            <input type="text" name="trainer_emp_name" id="trainer_emp_name" value="" style="width:200px">
                                        </cfif> 
                                        <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_orientation.trainer_emp_id&field_name=add_orientation.trainer_emp_name&select_list=1</cfoutput>','list');">
                                            <img src="/images/plus_thin.gif"  border="0" align="absmiddle">
                                        </a> 
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top">&nbsp;</td>
                                    <td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                                    <td><cfsavecontent variable="message"><cf_get_lang_main no='1687.Fazla karakter syaısı'></cfsavecontent>
                                        <textarea name="detail" id="detail" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="<cfoutput>#message#</cfoutput>" style="width:200px;height:70"><cfoutput>#get_orientation.DETAIL#</cfoutput></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:right;">&nbsp;</td>
                                    <td style="text-align:right;">&nbsp;</td>
                                    <td height="35" style="text-align:right;">
                                        <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=training_management.emptypopup_del_orientation&orientation_id=#attributes.orientation_id#'>&nbsp;&nbsp;&nbsp;&nbsp;
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</cfform>
