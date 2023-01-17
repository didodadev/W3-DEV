<!--- FBS 20090831 Urun ekibinde eleman varsa actigim popupta da eleman gorunmeli bence, diger ekip formatlarinda da boyle; bu sekilde duzenledim. --->
<cfquery name="get_rol" datasource="#DSN#">
	SELECT * FROM SETUP_PROJECT_ROLES ORDER BY PROJECT_ROLES
</cfquery>
<cfinclude template="../query/get_emp_par.cfm">
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','Ürün Ekibi',37079)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="worker" action="#request.self#?fuseaction=product.emptypopup_member_add_upd&pid=#url.pid#" method="post">
        <cf_grid_list>
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='57576.Çalışan'></th>
                    <th><cf_get_lang dictionary_id='57573.Görev'></th>
                </tr>
            </thead>
            <tbody>
                <cfloop index="i" from="1" to="10">
                    <tr>
                        <td>
                            <div class="form-group">
                                <div class="input-group">
                                    <cfoutput>
                                        <input type="hidden" name="position_code#i#" id="position_code#i#" value="<cfif get_emp_par.type[i] eq 1>#get_emp_par.member_value[i]#</cfif>">
                                        <input type="hidden" name="partner_id#i#" id="partner_id#i#" value="<cfif get_emp_par.type[i] eq 2>#get_emp_par.member_value[i]#</cfif>">
                                        <input type="text" name="member_name#i#" id="member_name#i#" value="#get_emp_par.member_name[i]# #get_emp_par.member_surname[i]#">
                                        <span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_partner=worker.partner_id#i#&field_code=worker.position_code#i#&field_name=worker.member_name#i#&select_list=1,2,6');"></span>
                                    </cfoutput>
                                </div> 
                            </div> 
                        </td>
                        <td>
                            <div class="form-group">
                                <select name="role_id<cfoutput>#i#</cfoutput>" id="role_id<cfoutput>#i#</cfoutput>">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfoutput query="get_rol">
                                        <option value="#project_roles_id#" <cfif get_emp_par.role_id[i] eq get_rol.project_roles_id>selected</cfif>>#project_roles#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </td>
                    </tr>
                </cfloop>
            </tbody>
        </cf_grid_list>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
function kontrol()
{
	var tanimli_ = 0;
	<cfloop index="i" from="1" to="10">
		if(<cfoutput>(document.worker.position_code#i#.value != '' || document.worker.partner_id#i#.value != '') && document.worker.member_name#i#.value != ''</cfoutput>)
			var tanimli_ = 1;
	</cfloop>
	
	if(tanimli_ == 0)
	{
		alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57576.Çalışan'>");
		return false;
	}
    <cfif isdefined("attributes.draggable")>
        loadPopupBox('worker' , <cfoutput>#attributes.modal_id#</cfoutput>);
        return false;
    </cfif>
}
</script>
