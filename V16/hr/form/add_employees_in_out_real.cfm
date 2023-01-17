<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box title="#getLang('','Çalışma Süresi Dağılımı Ekle','56656')#"  uidrop="1">
    <cfform name="add_real" method="post" action="#request.self#?fuseaction=hr.emptypopup_add_in_out_real">
        <cf_box_elements>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                <div class="form-group" >
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'>*</label>        
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.employee_id")><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
                            <input type="text" name="emp_name" id="emp_name" value="<cfif isdefined("attributes.employee_id")><cfoutput>#get_emp_info(attributes.employee_id,0,0)#</cfoutput></cfif>"  readonly>
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_positions&field_emp_id=add_real.employee_id&field_emp_name=add_real.emp_name</cfoutput>')"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" >
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'>*</label>        
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="branch_id" id="branch_id" value="">
                            <input type="text" name="branch_name" id="branch_name" value="" >
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_name=add_real.branch_name&field_branch_id=add_real.branch_id')"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" >
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57501.Başlangıç'><cf_get_lang dictionary_id='57742.Tarihi'>*</label>        
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57655.Başlangıç Tarihi'>!</cfsavecontent>
                            <cfinput validate="#validate_style#" required="Yes" message="#message#" type="text" name="startdate" >
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="startdate"></span>
                        </div>
                    </div>
                </div>

                <div class="form-group" >
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='288.Bitiş Tarihi'>*</label>        
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57700.Bitiş Tarihi'>!</cfsavecontent>
                            <cfinput validate="#validate_style#" message="#message#" type="text" name="finishdate" >
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finishdate"></span>
                        </div>
                    </div>
                </div>

                <div class="form-group" >
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='56655.Gün Sayısı'></label>        
                    <div class="col col-8 col-xs-12">
                        <div class="col col-12 input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='56654.Gün Sayısı Giriniz'>!</cfsavecontent>
                            <cfinput type="text" name="worked_day"  value="" validate="integer" message="#message#">
                        </div>
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
		if (add_real.branch_name.value == '')
			{
			alert("<cf_get_lang dictionary_id='57453.Şube'> !");
			return false
			}
	}
</script>
