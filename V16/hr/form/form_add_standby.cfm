<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box> 
        <cfform name="add_standby" method="post" action="#request.self#?fuseaction=hr.emptypopup_add_standby" enctype="multipart/form-data">
            <input type="hidden" name="counter" id="counter" value="">
            <input type="hidden" name="valid1" id="valid1" value="">
            <input type="hidden" name="valid2" id="valid2" value="">
            <cf_box_elements>
                <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-position_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55498.Pozisyonun Çalışanı'> *</label>
                        <div class="col col-4 col-xs-12">
                            <cfif isdefined("attributes.position_id")>
                                <cfquery name="GET_POSITION" datasource="#dsn#">
                                    SELECT
                                        EMPLOYEE_POSITIONS.DEPARTMENT_ID,
                                        DEPARTMENT.DEPARTMENT_HEAD,
                                        EMPLOYEE_POSITIONS.POSITION_ID,
                                        EMPLOYEE_POSITIONS.POSITION_CODE,
                                        EMPLOYEE_POSITIONS.POSITION_NAME,
                                        EMPLOYEE_POSITIONS.EMPLOYEE_ID,
                                        EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
                                        EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
                                        EMPLOYEES.EMPLOYEE_EMAIL
                                    FROM
                                        EMPLOYEE_POSITIONS,
                                        EMPLOYEES,
                                        DEPARTMENT
                                    WHERE
                                        EMPLOYEE_POSITIONS.POSITION_ID = #attributes.POSITION_ID#
                                        AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
                                        AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID
                                        AND EMPLOYEE_POSITIONS.POSITION_STATUS = 1
                                </cfquery>				
                            </cfif>
                            <cfif isdefined("attributes.position_id")>
                                <input name="position_code" type="hidden" id="position_code" value="<cfoutput query="GET_POSITION">#position_code#</cfoutput>">
                            <cfelse>
                                <input name="position_code" type="hidden" id="position_code">
                            </cfif>

                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58497.Pozisyon'></cfsavecontent>
                            <cfif isdefined("attributes.position_id")>
                                <cfinput name="position_emp" type="text" id="position_employee" required="yes" message="#message#" value="#GET_POSITION.employee_name# #GET_POSITION.employee_surname#">
                            <cfelse>
                                <cfinput name="position_emp" type="text" id="position_employee" required="yes" message="#message#">
                            </cfif>
                        </div>
                        <div class="col col-4 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58497.Pozisyon'></cfsavecontent>
                                <cfif isdefined("attributes.position_id")>
                                    <cfinput name="position_name" type="text" id="position_name" required="yes" message="#message#" value="#GET_POSITION.position_name#">
                                <cfelse>
                                    <cfinput name="position_name" type="text" id="position_name" required="yes" message="#message#">
                                </cfif>
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=add_standby.position_code&field_emp_name=add_standby.position_emp&field_pos_name=add_standby.position_name');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-chief1_emp2">
                        <label class="col col-12 bold"><cf_get_lang dictionary_id='55490.Amirler'></label>
                    </div>
                    <div class="form-group" id="item-chief1_emp">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56110.Birinci Amir'>*</label>
                        <div class="col col-4 col-xs-12">
                            <input name="chief1_code" type="hidden" id="chief1_code">
                            <input name="chief1_emp" id="chief1_emp" type="text" readonly>
                        </div>
                        <div class="col col-4 col-xs-12">
                            <div class="input-group">
                                <input name="chief1_name" type="text" id="chief1_name" readonly>
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=add_standby.chief1_code&field_emp_name=add_standby.chief1_emp&field_pos_name=add_standby.chief1_name');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-chief2_emp">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56111.İkinci Amir'></label>
                        <div class="col col-4 col-xs-12">
                            <input name="chief2_code" type="hidden" id="chief2_code">
                            <input name="chief2_emp" id="chief2_emp" type="text" readonly>
                        </div>
                        <div class="col col-4 col-xs-12">
                            <div class="input-group">
                                <input name="chief2_name" type="text" id="chief2_name" readonly> 
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=add_standby.chief2_code&field_emp_name=add_standby.chief2_emp&field_pos_name=add_standby.chief2_name');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-chief3_emp">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56070.Görüş Bildirecek'></label>
                        <div class="col col-4 col-xs-12">
                            <input name="chief3_code" type="hidden" id="chief3_code">
                            <input name="chief3_emp" id="chief3_emp" type="text" readonly>
                        </div>
                        <div class="col col-4 col-xs-12">
                            <div class="input-group">
                                <input name="chief3_name" type="text" id="chief3_name" readonly> 
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=add_standby.chief3_code&field_emp_name=add_standby.chief3_emp&field_pos_name=add_standby.chief3_name');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-replacement">
                        <label class="col col-12 bold"><cf_get_lang dictionary_id='55491.Yedekler'></label>
                    </div>
                    <div class="form-group" id="item-CANDIDATE_POS_1_EMP">
                        <label class="col col-4 col-xs-12">1.<cf_get_lang dictionary_id='55499.Yedek Pozisyon'></label>
                        <div class="col col-4 col-xs-12">
                            <input name="CANDIDATE_POS_1" type="hidden" id="CANDIDATE_POS_1">
                            <cfinput name="CANDIDATE_POS_1_EMP" type="text" id="CANDIDATE_POS_1_EMP"> 
                        </div>
                        <div class="col col-4 col-xs-12">
                            <div class="input-group">
                                <cfinput name="CANDIDATE_POS_1_NAME" type="text" id="CANDIDATE_POS_1_NAME">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=add_standby.CANDIDATE_POS_1&field_emp_name=add_standby.CANDIDATE_POS_1_EMP&field_pos_name=add_standby.CANDIDATE_POS_1_NAME');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-CANDIDATE_POS_2_EMP">
                        <label class="col col-4 col-xs-12">2.<cf_get_lang dictionary_id='55499.Yedek Pozisyon'></label>
                        <div class="col col-4 col-xs-12">
                            <input name="CANDIDATE_POS_2" type="hidden" id="CANDIDATE_POS_2">
                            <input name="CANDIDATE_POS_2_EMP" type="text" id="CANDIDATE_POS_2_EMP">
                        </div>
                        <div class="col col-4 col-xs-12">
                            <div class="input-group">
                                <input name="CANDIDATE_POS_2_NAME" type="text" id="CANDIDATE_POS_2_NAME">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=add_standby.CANDIDATE_POS_2&field_emp_name=add_standby.CANDIDATE_POS_2_EMP&field_pos_name=add_standby.CANDIDATE_POS_2_NAME');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-CANDIDATE_POS_3_EMP">
                        <label class="col col-4 col-xs-12">3.<cf_get_lang dictionary_id='55499.Yedek Pozisyon'></label>
                        <div class="col col-4 col-xs-12">
                            <input name="CANDIDATE_POS_3" type="hidden" id="CANDIDATE_POS_3">
                            <input name="CANDIDATE_POS_3_EMP" type="text" id="CANDIDATE_POS_3_EMP">
                        </div>
                        <div class="col col-4 col-xs-12">
                            <div class="input-group">
                                <input name="CANDIDATE_POS_3_NAME" type="text" id="CANDIDATE_POS_3_NAME">
                                <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_code=add_standby.CANDIDATE_POS_3&field_emp_name=add_standby.CANDIDATE_POS_3_EMP&field_pos_name=add_standby.CANDIDATE_POS_3_NAME');"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons type_format="1" is_upd='0' add_function='control()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
function control()
{	
	if (add_standby.chief1_name.value == '')
	{
	alert("1.<cf_get_lang dictionary_id='56071.Amiri Seçmelisiniz'>");
	return false;
	}
	return true;
}
</script>
