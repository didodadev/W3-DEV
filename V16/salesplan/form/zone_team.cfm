<!--- Ekip --->
<cfinclude template="../query/get_emp_par.cfm">
<cfsavecontent variable="text"><cf_get_lang no='54.Ekibi'></cfsavecontent>
<!---<cf_box id="zone_team_" 
title="#text#"
add_href="#request.self#?fuseaction=salesplan.popup_form_add_worker&sz_id=#url.sz_id#"
closable="0">--->
<cfset CCS = ""> 
<cf_ajax_list>
<tbody>
	<cfoutput query="GET_EMPS">
	<tr>
		<td>
			<cfif len(ROLE_ID)>	
				<cfquery name="GET_ROL_NAME" datasource="#DSN#">
					SELECT 
						PROJECT_ROLES
					FROM 
						SETUP_PROJECT_ROLES 
					WHERE 
						PROJECT_ROLES_ID = #ROLE_ID#
				</cfquery>
			</cfif>				
			<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#EMPLOYEE_ID#','medium');" class="tableyazi">#employee_name# #employee_surname#</a>-<cfif len(role_id) and (GET_ROL_NAME.recordcount)>#GET_ROL_NAME.PROJECT_ROLES#</cfif>
		</td>	
		<td width="15">
			<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=salesplan.emptypopup_member_del_emp&position_code=#position_code#&sz_id=#url.sz_id#','small');"><img src="/images/delete_list.gif" border="0"></a>
		</td>
	</tr>
	</cfoutput>				 
	<cfoutput query="get_PARS">
	<tr>
		<td>
			<cfif len(ROLE_ID)>
				<cfquery name="GET_ROL_NAME2" datasource="#DSN#">
					SELECT 
						PROJECT_ROLES 
					FROM 
						SETUP_PROJECT_ROLES 
					WHERE 
						PROJECT_ROLES_ID = #ROLE_ID#
				</cfquery>
			</cfif>				
			<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#PARTNER_ID#','medium');" class="tableyazi">#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_NAME# - #nickname#</a>-<cfif len(ROLE_ID) and (GET_ROL_NAME2.recordcount)>#GET_ROL_NAME2.PROJECT_ROLES#</cfif>
		</td>			  
		<td width="15" style="text-align:right;">
			<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=salesplan.emptypopup_member_del_par&partner_id=#partner_id#&sz_id=#url.sz_id#','small');"><img src="/images/delete_list.gif" border="0"></a>
		</td>				   
	 </tr>
	</cfoutput>
  </tbody>
</cf_ajax_list>
<!--- Ekip --->
