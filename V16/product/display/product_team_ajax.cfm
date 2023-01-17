<!--- Urun Ekibi --->
<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_emp_par.cfm">
<cfset CCS = "">
<cf_flat_list>
	<tbody>
		<cfif get_emp_par.recordcount>
			<cfoutput query="get_emp_par">
				<tr>
					<td>
						<cfif len(role_id)>	
							<cfquery name="get_rol_name" datasource="#dsn#">
								SELECT PROJECT_ROLES FROM SETUP_PROJECT_ROLES WHERE PROJECT_ROLES_ID = #role_id#
							</cfquery>
						</cfif>
						<cfif type eq 1>
							<cfset link_ = "popup_emp_det&pos_code=">
						<cfelse>
							<cfset link_ = "popup_par_det&par_id=">
						</cfif>				
						<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.#link_##member_value#');">#member_name# #member_surname# #nickname#</a> - <cfif len(role_id) and (get_rol_name.recordcount)>#get_rol_name.project_roles#</cfif>
					</td>	
					<td width="20">
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=product.emptypopup_group_del_emp_par&member_value=#member_value#&type=#type#&pid=#attributes.pid#','small');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>"></i></a>
					</td>
				</tr>
			</cfoutput>
		<cfelse>			 
			<tr>
				<td><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_flat_list>
