<cfparam name="attributes.modal_id" default="">
<cfquery name="get_rol" datasource="#DSN3#">
	SELECT 
		* 
	FROM 
		SETUP_CAMPAIGN_ROLES
	ORDER BY
		CAMPAIGN_ROLE
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Ekip',41475)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform action="#request.self#?fuseaction=campaign.emptypopup_team_member_add&campaign_id=#url.campaign_id#" method="post" name="worker">
            <cf_grid_list table_width="600">
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='57576.Çalışan'></th>
                        <th><cf_get_lang dictionary_id='49329.Rol'></th>
                    </tr>
                </thead>
                <tbody>
                    <cfloop index="i" from="1" to="10"> 
                        <tr>
                            <td width="185">
                                <cfoutput>
                                    <input type="hidden" name="POSITION_CODE#i#" id="POSITION_CODE#i#" value="">
                                    <input type="hidden" name="PARTNER_ID#i#" id="PARTNER_ID#i#" value="">
                                    <div class="form-group">
                                        <div class="input-group">
                                            <input type="text" name="emp_par_name#i#" id="emp_par_name#i#" value="">
                                            <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1,2&field_partner=worker.PARTNER_ID#i#&field_code=worker.POSITION_CODE#i#&field_name=worker.emp_par_name#i#</cfoutput>');">
                                        </div>  
                                    </div>
                                </cfoutput>
                            </td>
                            <td>
                                <div class="form-group">
                                    <select name="get_rol<cfoutput>#i#</cfoutput>" id="get_rol<cfoutput>#i#</cfoutput>">
                                        <option value=""><cf_get_lang dictionary_id='49484.Rol Seçiniz'></option>
                                        <cfif get_rol.recordcount>
                                            <cfoutput query="get_rol">
                                            <option value="#CAMPAIGN_ROLE_ID#">#CAMPAIGN_ROLE#</option>
                                            </cfoutput>
                                        </cfif>
                                    </select>
                                </div>
                            </td>
                        </tr>
                    </cfloop>
                </tbody>
            </cf_grid_list>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('worker' , #attributes.modal_id#)"),DE(""))#">
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
