<cfform name="power_user" method="post" action="#request.self#?fuseaction=objects.emptypopup_upd_employee&id=power_user&employee_id=#attributes.employee_id#&position_id=#attributes.position_id#">
	<input type="hidden" name="old_power_user" id="old_power_user" value="<cfif get_hr.power_user eq 1>1<cfelse>0</cfif>">
	<input type="hidden" name="page_type" id="page_type" value="<cfif isdefined('attributes.type') and len(attributes.type)><cfoutput>#attributes.type#</cfoutput></cfif>">
	<input type="hidden" name="auth_emps_pos" id="auth_emps_pos" value="">
	<input type="hidden" name="auth_emps_id" id="auth_emps_id" value="">
	<table>
		<tr>
			<td>
				<table>
					<tr>
						<td><cfsavecontent variable="extra_"><input type="checkbox" name="all_power_user" id="all_power_user" value="1" onclick="hepsi_power_user_sec();"><cf_get_lang dictionary_id ='33746.Hepsini Seç'></cfsavecontent></td>
					</tr>
					<cfparam name="attributes.mode" default="4">
					<cfparam name="attributes.page" default=1>		
					<cfset attributes.startrow=1>
					<cfset attributes.maxrows = get_modules.recordcount>
					<cfoutput query="get_modules" startrow="#attributes.startrow#" maxrows="#attributes.MAXROWS#">
						<cfif ((currentrow mod attributes.mode is 1)) or (currentrow eq 1)>
							<tr>
						</cfif>
						<td>
							<cfif listlen(get_position_detail.power_user_level_id) and (listlen(get_position_detail.power_user_level_id) gte module_id) and (listgetat(get_position_detail.power_user_level_id,module_id) eq 1)>
								<cfif session.ep.admin>
									<input type="checkbox" name="POWER_USER_LEVEL_ID_#module_id#" id="POWER_USER_LEVEL_ID_#module_id#" value="1" checked>
								<cfelse>
									<input type="hidden" name="POWER_USER_LEVEL_ID_#module_id#" id="POWER_USER_LEVEL_ID_#module_id#" value="1">+
								</cfif>
							<cfelse>
								<cfif session.ep.admin>
									<input type="checkbox" name="POWER_USER_LEVEL_ID_#module_id#" id="POWER_USER_LEVEL_ID_#module_id#" value="1">
								<cfelse>
									<input type="hidden" name="POWER_USER_LEVEL_ID_#module_id#" id="POWER_USER_LEVEL_ID_#module_id#" value="0">-
								</cfif>
							</cfif>
						</td>
						<td width="175"><cfif module_lang_type eq 0>#module_name#<cfelse>#module_name_tr#</cfif> - #module_id# *</td>
						<cfif ((currentrow mod attributes.mode is 0)) or (currentrow eq recordcount)>
							</tr>
						</cfif>                  
					</cfoutput>
					&nbsp;&nbsp;<input type="checkbox" name="all_power_user" id="all_power_user" value="1" onclick="hepsi_power_user_sec();"><cf_get_lang dictionary_id ='33746.Hepsini Seç'>
			   </table>
			</td>
		</tr>
	</table>
	<cf_popup_box_footer><cf_record_info query_name="get_position_detail"><cfif session.ep.admin><cf_workcube_buttons is_upd="0" add_function="get_auth_emps(1,1,0)"></cfif></cf_popup_box_footer>
</cfform>

