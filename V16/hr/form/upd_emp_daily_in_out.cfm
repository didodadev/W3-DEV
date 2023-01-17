<cfif fusebox.circuit is 'hr'>
	<cfquery name="get_emp_daily_in_out" datasource="#dsn#">
		SELECT 
			ED.*,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME 
		FROM 
			EMPLOYEE_DAILY_IN_OUT ED,
			EMPLOYEES E
		WHERE 
			ED.EMPLOYEE_ID = E.EMPLOYEE_ID AND
			ROW_ID = #attributes.row_id# AND
            ISNULL(FROM_HOURLY_ADDFARE,0) = 0
	</cfquery>
<cfelse>
	<cfquery name="get_emp_daily_in_out" datasource="#dsn#">
		SELECT 
			ED.*,
			C.COMPANY_PARTNER_NAME,
			C.COMPANY_PARTNER_SURNAME 
		FROM 
			EMPLOYEE_DAILY_IN_OUT ED,
			COMPANY_PARTNER C
		WHERE 
			ED.PARTNER_ID = C.PARTNER_ID AND
			ROW_ID = #attributes.row_id#
            AND ISNULL(ED.FROM_HOURLY_ADDFARE,0) = 0
	</cfquery>
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="upd_in_out" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_upd_emp_daily_in_out" method="post">
            <input type="hidden" name="row_id" id="row_id" value="<cfoutput>#attributes.row_id#</cfoutput>">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                    <div class="form-group" id="item-employee_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57576.Çalışan'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cfif fusebox.circuit is 'hr'>
                                <div class="input-group">
                                    <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_emp_daily_in_out.employee_id#</cfoutput>">
                                    <input type="hidden" name="in_out_id" id="in_out_id" value="<cfoutput>#get_emp_daily_in_out.in_out_id#</cfoutput>">
                                    <input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#get_emp_daily_in_out.branch_id#</cfoutput>">
                                    <input type="text" name="emp_name" id="emp_name" style="width:184px;" value="<cfoutput>#get_emp_daily_in_out.employee_name# #get_emp_daily_in_out.employee_surname#</cfoutput>" readonly> 
                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=upd_in_out.in_out_id&field_emp_name=upd_in_out.emp_name&field_emp_id=upd_in_out.employee_id&field_branch_id=upd_in_out.branch_id');"></span>
                                </div>
                            <cfelse>
                                <div class="input-group">
                                    <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_emp_daily_in_out.partner_id#</cfoutput>" />
                                    <input type="hidden" name="member_type" id="member_type" value="partner" /> 
                                    <input type="text" name="partner_name" id="partner_name" style="width:184px;" value="<cfoutput>#get_emp_daily_in_out.company_partner_name# #get_emp_daily_in_out.company_partner_surname#</cfoutput>" readonly />
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_id=upd_in_out.partner_id&field_name=upd_in_out.partner_name&field_type=upd_in_out.member_type&select_list=7');"></span>
                                </div>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-is_week_rest_day">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='29496.Gün Tipi'></label>
                        <div class="col col-8 col-xs-12">
                            <cfoutput>
                                <select name="is_week_rest_day" id="is_week_rest_day" style="width:184px">
                                    <option value=""<cfif not Len(get_emp_daily_in_out.IS_WEEK_REST_DAY)> selected</cfif>><cf_get_lang dictionary_id="55753.Çalışma Günü"></option>
                                    <option value="0"<cfif get_emp_daily_in_out.IS_WEEK_REST_DAY eq 0> selected</cfif>><cf_get_lang dictionary_id="58867.Hafta Tatili">
                                    <option value="1"<cfif get_emp_daily_in_out.IS_WEEK_REST_DAY eq 1> selected</cfif>><cf_get_lang dictionary_id="29482.Genel Tatil">
                                    <option value="2"<cfif get_emp_daily_in_out.IS_WEEK_REST_DAY eq 2> selected</cfif>><cf_get_lang dictionary_id="55837.Genel Tatil - Hafta Tatili">
                                    <option value="3"<cfif get_emp_daily_in_out.IS_WEEK_REST_DAY eq 3> selected</cfif>><cf_get_lang dictionary_id="55840.Ücretli İzin - Hafta Tatili">
                                    <option value="4"<cfif get_emp_daily_in_out.IS_WEEK_REST_DAY eq 4> selected</cfif>><cf_get_lang dictionary_id="55844.Ücretsiz İzin - Hafta Tatili">
                                </select>
                            </cfoutput>
                        </div>
                    </div>
                    <div class="form-group" id="item-startdate">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57628.Giriş Tarihi'></label>
                        <div class="col col-4 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="startdate" id="startdate" value="#dateformat(get_emp_daily_in_out.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10" style="width:70px;">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                            </div>
                        </div>
                        <div class="col col-2 col-xs-12">
                            <cfif timeformat(get_emp_daily_in_out.start_date,'HH')>
                                <cf_wrkTimeFormat name="start_hour" value="#timeformat(get_emp_daily_in_out.start_date,'HH')#">
                            <cfelse>
                                <cf_wrkTimeFormat name="start_hour" value="0">
                            </cfif>  
                        </div>
                        <div class="col col-2 col-xs-12">
                            <select name="start_min" id="start_min">
                                <option value="0"><cf_get_lang dictionary_id='58827.dk'></option>
                                <cfloop from="1" to="59" index="i">
                                    <cfoutput>
                                        <option value="#i#"<cfif timeformat(get_emp_daily_in_out.start_date,'MM') eq i>selected</cfif>>#i#</option>
                                    </cfoutput>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-finishdate">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='29438.Çıkış Tarihi'></label>
                        <div class="col col-4 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="finishdate" id="finishdate" value="#dateformat(get_emp_daily_in_out.finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10" style="width:70px;">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                            </div>
                        </div>
                        <div class="col col-2 col-xs-12">
                            <cfif timeformat(get_emp_daily_in_out.finish_date,'HH')>
                                <cf_wrkTimeFormat name="finish_hour" value="#timeformat(get_emp_daily_in_out.finish_date,'HH')#">
                            <cfelse>
                                <cf_wrkTimeFormat name="finish_hour" value="0">
                            </cfif>	
                        </div>	
                        <div class="col col-2 col-xs-12">							
                            <select name="finish_min" id="finish_min">
                                <option value="0"><cf_get_lang dictionary_id='58827.dk'></option>
                                <cfloop from="1" to="59" index="i">
                                    <cfoutput>
                                        <option value="#i#" <cfif timeformat(get_emp_daily_in_out.finish_date,'MM') eq i>selected</cfif>>#i#</option>
                                    </cfoutput>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57629.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="detail" id="detail"  style="width:184px; height:60px;"><cfoutput>#get_emp_daily_in_out.detail#</cfoutput></textarea>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <div class="col col-6 col-xs-12">
                    <cf_record_info query_name="get_emp_daily_in_out">
                </div>
                <div class="col col-6 col-xs-12">
                    <cfif len(get_emp_daily_in_out.file_id)>
                        <cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='0'>
                    <cfelse>
                        <cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=#fusebox.circuit#.emptypopup_del_emp_daily_in_out&row_id=#get_emp_daily_in_out.row_id#'>
                    </cfif>
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
function kontrol()
{
	if ($( "#emp_name" ).length && !$( "#emp_name" ).val().length|| $( "#partner_name" ).length && !$( "#partner_name" ).val().length)
	{
		alert("<cf_get_lang dictionary_id='29498.Çalışan Girmelisinz'>!");
		return false;
	}
	if (document.getElementById('startdate').value == "")
	{
		alert("<cf_get_lang dictionary_id ='57738.Başlangıç Tarihi Girmelisiniz'>!");
		return false;
	}
	if (document.getElementById('finishdate').value == "")
	{
		alert("<cf_get_lang dictionary_id ='57739.Bitiş Tarihi Girmelisiniz'>!");
		return false;
	}
	return true;
}
</script>