<cfquery name="get_in_out_real" datasource="#dsn#">
	SELECT 
    	REAL_ID, 
        EMPLOYEE_ID, 
        BRANCH_ID, 
        START_DATE, 
        FINISH_DATE, 
        WORKED_DAY, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP, 
        UPDATE_EMP, 
        UPDATE_DATE, 
        UPDATE_IP, 
        BRANCH_NAME,
        BRANCH_ID
    FROM 
	    EMPLOYEES_IN_OUT_REAL 
    WHERE 
    	REAL_ID = #attributes.real_id#
</cfquery>

<cf_box title="#getLang('','Çalışma Süresi Dağılımı Güncelle','56764')#" add_href='#request.self#?fuseaction=hr.popup_add_employees_in_out_real'>
    <cfform name="upd_real" method="post" action="#request.self#?fuseaction=hr.emptypopup_upd_in_out_real">
        <input type="hidden" name="real_id" id="real_id" value="<cfoutput>#get_in_out_real.real_id#</cfoutput>">
        <cf_box_elements>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="form-group" >
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'>*</label>        
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_in_out_real.employee_id#</cfoutput>">
                            <input type="text" name="emp_name" id="emp_name" value="<cfoutput>#get_emp_info(get_in_out_real.employee_id,0,0)#</cfoutput>"  readonly>
                            <span class="input-group-addon btnPointer icon-ellipsis"onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_positions&field_emp_id=upd_real.employee_id&field_emp_name=upd_real.emp_name</cfoutput>')"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" >
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'>*</label>        
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="text" name="branch_name" id="branch_name" value="<cfoutput>#get_in_out_real.branch_name#</cfoutput>" readonly>
                            <input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#get_in_out_real.branch_id#</cfoutput>">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_name=upd_real.branch_name&field_branch_id=upd_real.branch_id','list','popup_list_branches')"></span>
                        </div>
                    </div>
                </div>

                <div class="form-group" >
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57501.Başlangıç'><cf_get_lang dictionary_id='57742.Tarihi'>*</label>        
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="alert"><cf_get_lang dictionary_id ='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
                                <cfinput validate="#validate_style#" required="Yes" message="#alert#" type="text" name="startdate"  value="#dateformat(get_in_out_real.start_date,dateformat_style)#">
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="startdate"></span>
                        </div>
                    </div>
                </div>

                <div class="form-group" >
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='288.Bitiş Tarihi'>*</label>        
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="alert"><cf_get_lang dictionary_id ='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
                                <cfif len(get_in_out_real.finish_date)>
                                    <cfinput validate="#validate_style#" message="#alert#" type="text" name="finishdate"  value="#dateformat(get_in_out_real.finish_date,dateformat_style)#" >
                                <cfelse>
                                    <cfinput validate="#validate_style#" message="#alert#" type="text" name="finishdate"  value="" >
                                </cfif>
                               
                            <span class="input-group-addon btnPointer"> <cf_wrk_date_image date_field="finishdate"></span>
                        </div>
                    </div>
                </div>

                <div class="form-group" >
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='56655.Gün Sayısı'></label>        
                    <div class="col col-8 col-xs-12">
                        <div class="col col-12 input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='56654.Gün Sayısı Giriniz'>!</cfsavecontent>
                            <cfinput type="text" name="worked_day" value="#get_in_out_real.worked_day#" validate="integer" message="#message#">
                        </div>
                    </div>
                </div>

            </div>

        </cf_box_elements>
        <cf_box_footer>
            <cf_record_info query_name="get_in_out_real">
            <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=hr.emptypopup_del_employees_in_out_real&real_id=#attributes.real_id#' add_function='kontrol()'>
        </cf_box_footer>
    </cfform>
</cf_box>

<script type="text/javascript">
	function kontrol()
	{
		if (upd_real.branch_id.value == '' || upd_real.branch_name.value == '')
			{
			alert("<cf_get_lang dictionary_id='57453.Şube'> !");
			return false
			}
	}
</script>
