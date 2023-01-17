<cfinclude template="../query/get_campaign_team.cfm">
<table cellspacing="1" cellpadding="2" border="0" style="width:100%">	
	<cfif get_emps.recordcount or get_pars.recordcount>
  		<cfoutput query="get_emps">
			<tr>
	  			<td>
					<cfif isdefined("session.pp.userid") and get_workcube_app_user(get_emps.employee_id, 0).recordcount>
					  <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_message&employee_id=#get_emps.employee_id#','small');" title="<cf_get_lang_main no='1899.Mesaj Gönder'>"><img src="/images/onlineuser.gif"  border="0" alt="<cf_get_lang_main no='1899.Mesaj Gönder'>"/></a>
					<cfelse>
					  <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_add_nott&public=1&employee_id=#get_emps.employee_id#','small');" title="<cf_get_lang no ='1140.Not Bırak'>"><img src="/images/visit_note.gif"  border="0" alt="<cf_get_lang no ='1140.Not Bırak'>"/></a>
					</cfif>
	 			</td>
	  			<td>
					<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects2.popup_emp_det&emp_id=#encrypt(employee_id,"WORKCUBE","BLOWFISH","Hex")#','medium');" class="tableyazi">
						#employee_name# #employee_surname# -
					</a>
					<cfif len(ROLE_ID)>
						<cfquery name="GET_ROL_NAME" datasource="#DSN3#">
							SELECT 
								CAMPAIGN_ROLE 
							FROM 
								SETUP_CAMPAIGN_ROLES 
							WHERE 
								CAMPAIGN_ROLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#role_id#">
						</cfquery>
						#get_rol_name.campaign_role#
					</cfif>
	  			</td>
			</tr>
  		</cfoutput> 
  		<cfoutput query="get_pars">
			<tr>
	  			<td>&nbsp;</td>
	  			<td>
	  				<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects2.popup_par_det&par_id=#partner_id#','medium');" class="tableyazi">
	  					#nickname# / #company_partner_name# #company_partner_surname# -
		  			</a>
					<cfif len(ROLE_ID)>
						<cfquery name="GET_ROL_NAME2" datasource="#DSN3#">
							SELECT 
								CAMPAIGN_ROLE 
							FROM 
								SETUP_CAMPAIGN_ROLES
							WHERE 
								CAMPAIGN_ROLE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ROLE_ID#">
						</cfquery>
						#get_rol_name2.campaign_role#
					</cfif>
				</td>
			</tr>
  		</cfoutput>
	</cfif>
</table>

