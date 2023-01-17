<cfform name="add_perf_emp_info">
    <table>
        <tr>
            <td width="160"><cf_get_lang_main no='164.Calisan'> </td>
            <td width="220">
                <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
                <input type="hidden" name="position_code" id="position_code" value="<cfoutput>#session.ep.position_code#</cfoutput>">
                <input type="hidden" name="position_name" id="position_name" value="<cfoutput>#session.ep.position_name#</cfoutput>">
                <cfsavecontent variable="message"><cf_get_lang no='373.alisan seiniz'></cfsavecontent>
                <cfinput type="text" name="emp_name" value="#session.ep.name# #session.ep.surname#" required="yes" message="#message#" style="width:180px;">
                <i class="icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_perf_emp_info.employee_id&field_name=add_perf_emp_info.emp_name&field_code=add_perf_emp_info.position_code&field_pos_name=add_perf_emp_info.position_name&upper_pos_code=#session.ep.position_code#&select_list=1&keyword='+encodeURIComponent(document.add_perf_emp_info.emp_name.value)</cfoutput>,'list')"></i>				
            </td>            
        </tr>
        <tr>
            <td><cf_get_lang_main no='1060.Dönem'></td>
            <td>
            <cfif validate_style eq "eurodate">
                <cfsavecontent variable="message"><cf_get_lang no='136.Baslangi Tarihi Girmelisiniz'></cfsavecontent>
                <cfinput required="Yes" message="#message#" type="text" name="start_date" validate="#validate_style#" value="01/01/#session.ep.period_year#" style="width:89px;" readonly="readonly"><!---<cf_wrk_date_image date_field="start_date">--->
                <cfsavecontent variable="message"><cf_get_lang no='138.Bitis Tarihi Girmelisiniz'></cfsavecontent>
                <cfinput required="Yes" message="#message#" type="text" name="finish_date" validate="#validate_style#" value="31/12/#session.ep.period_year#" style="width:88px;" readonly="readonly"><!---<cf_wrk_date_image date_field="finish_date">--->
            <cfelse>
             <cfsavecontent variable="message"><cf_get_lang no='136.Baslangi Tarihi Girmelisiniz'></cfsavecontent>
                <cfinput required="Yes" message="#message#" type="text" name="start_date" validate="#validate_style#" value="01/01/#session.ep.period_year#" style="width:89px;" readonly="readonly"><!---<cf_wrk_date_image date_field="start_date">--->
                <cfsavecontent variable="message"><cf_get_lang no='138.Bitis Tarihi Girmelisiniz'></cfsavecontent>
                <cfinput required="Yes" message="#message#" type="text" name="finish_date" validate="#validate_style#" value="12/31/#session.ep.period_year#" style="width:88px;" readonly="readonly"><!---<cf_wrk_date_image date_field="finish_date">--->
            </cfif>
            </td>
        </tr>
        <tr style="display:none;">
            <td><cf_get_lang_main no="1447.Süreç"></td>
            <td><cf_workcube_process is_upd='0' process_cat_width='170' is_detail='0'></td>
        </tr>
    </table>
   	<cf_form_box_footer>
    	<cf_workcube_buttons is_upd='0' type_format="1" insert_alert='' add_function='kontrol()'>
    </cf_form_box_footer>
</cfform>
