<cfsavecontent variable="txt">
<cfif fusebox.circuit is 'hr'><cf_get_lang dictionary_id ='56564.PDKS Ekle'><cfelse><cf_get_lang dictionary_id='56564.Pdks ekle'></cfif>
</cfsavecontent>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
        <cfform name="add_in_out" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_add_emp_daily_in_out" method="post">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                    <div class="form-group" id="item-employee_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57576.Çalışan'> *</label>
                        <div class="col col-8 col-xs-12">
                            <cfif fusebox.circuit is 'hr'>
                                <cfif isDefined("attributes.employee_id") and isdefined("attributes.in_out_id")>
                                    <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
                                    <input type="hidden" name="in_out_id" id="in_out_id" value="<cfoutput>#attributes.in_out_id#</cfoutput>">
                                    <cfquery name="get_emp_branch" datasource="#dsn#" maxrows="1">
                                        SELECT 
                                            B.BRANCH_ID 
                                        FROM 
                                            BRANCH B
                                            INNER JOIN DEPARTMENT D ON D.BRANCH_ID = B.BRANCH_ID
                                            INNER JOIN EMPLOYEES_IN_OUT EIO ON D.DEPARTMENT_ID = EIO.DEPARTMENT_ID 
                                        WHERE 
                                            EIO.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
                                    </cfquery>
                                    <input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#get_emp_branch.branch_id#</cfoutput>">
                                    <cfinclude template="../query/get_hr_name.cfm">
                                    <input type="hidden" name="emp_name" id="emp_name" value="<cfoutput>#get_hr_name.employee_name# #get_hr_name.employee_surname#</cfoutput>">
                                    <cfoutput><label class="bold">#get_hr_name.employee_name# #get_hr_name.employee_surname#</label></cfoutput>
                                <cfelse>
                                    <div class="input-group">
                                        <input type="hidden" name="employee_id" id="employee_id" value=""> 
                                        <input type="hidden" name="in_out_id" id="in_out_id" value="">
                                        <input type="hidden" name="branch_id" id="branch_id" value="">
                                        <input type="text" name="emp_name" id="emp_name" value="" readonly> 
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=add_in_out.in_out_id&field_emp_name=add_in_out.emp_name&field_emp_id=add_in_out.employee_id&field_branch_id=add_in_out.branch_id');"></span>
                                    </div>
                                </cfif>
                            <cfelse>
                                <div class="input-group">
                                    <input type="hidden" name="partner_id" id="partner_id" value="" />
                                    <input type="hidden" name="member_type" id="member_type" value="partner" /> 
                                    <input type="text" name="partner_name" id="partner_name" value="" readonly />
                                    <input type="hidden" name="emp_name" id="emp_name" value="" readonly />
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_id=add_in_out.partner_id&field_name=add_in_out.partner_name&field_type=add_in_out.member_type&select_list=7');"></span>
                                </div>
                            </cfif>
                        </div>
                    </div>
                    <div class="form-group" id="item-is_week_rest_day">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='29496.Gün Tipi'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="is_week_rest_day" id="is_week_rest_day">
                                <option value=""><cf_get_lang dictionary_id="55753.Çalışma Günü"></option>
                                <option value="0"><cf_get_lang dictionary_id="58867.Hafta Tatili"></option>
                                <option value="1"><cf_get_lang dictionary_id="29482.Genel Tatil	"></option>
                                <option value="2"><cf_get_lang dictionary_id="55837.Genel Tatil - Hafta Tatili"></option>
                                <option value="3"><cf_get_lang dictionary_id="55840.Ücretli İzin - Hafta Tatili	"></option>
                                <option value="4"><cf_get_lang dictionary_id="55844.Ücretsiz İzin - Hafta Tatili"></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-startdate">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57628.Giriş Tarihi'></label>
                        <div class="col col-4 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="startdate" id="startdate" value="" validate="#validate_style#" maxlength="10">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                            </div>
                        </div>
                        <div class="col col-2 col-xs-12">
                            <cf_wrkTimeFormat name="start_hour" value="">
                        </div>
                        <div class="col col-2 col-xs-12">
                            <select name="start_minute" id="start_minute">
                                <option value="0" selected><cf_get_lang dictionary_id='58827.dk'></option>
                                <cfloop from="1" to="59" index="i">
                                    <cfoutput>
                                        <option value="#i#">#i#</option>
                                    </cfoutput>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-finishdate">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='29438.Çıkış Tarihi'></label>
                        <div class="col col-4 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" name="finishdate" id="finishdate" value="" validate="#validate_style#" maxlength="10">
                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finishdate"></span>
                            </div>
                        </div>
                        <div class="col col-2 col-xs-12">
                            <cf_wrkTimeFormat name="finish_hour" value="">
                        </div>
                        <div class="col col-2 col-xs-12">
                            <select name="finish_min" id="finish_min">
                                <option value="0" selected><cf_get_lang dictionary_id='58827.dk'></option>
                                <cfloop from="1" to="59" index="i">
                                    <cfoutput>
                                        <option value="#i#">#i#</option>
                                    </cfoutput>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-detail">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57629.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <textarea name="detail" id="detail" style="width:140px;height:45px;"></textarea>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{
		if (document.getElementById('emp_name').value == "" && document.getElementById('partner_name').value == "")
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

