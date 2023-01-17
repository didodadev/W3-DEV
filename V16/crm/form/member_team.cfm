<!--- Ekip --->
<cfinclude template="../query/get_emp_par.cfm">
<table cellspacing="0" cellpadding="0" width="98%"  border="0">
  <tr class="color-border"> 
	<td> 
	  <table cellspacing="1" cellpadding="2" width="100%" border="0">
		<tr class="color-header" height="22" > 
		  <td class="form-title" width="99%"><cf_get_lang no='61.Kurumsal Üye Ekibi'></td>
		  <td width="15">
			<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=member.popup_form_add_worker&c_id=#url.cpid#&cp_id=#url.cpid#</cfoutput>','medium');"><img src="/images/plus_square.gif" border="0" title="<cf_get_lang no='307.Kurumsal Üye Temsilcileri'>" align="absmiddle"></a>
		  </td>
		</tr>
		<cfset CCS = "">
		<tr class="color-row"> 
		  <td id="td_charges" colspan="2" HEIGHT="20"> 
		 <cfoutput query="GET_EMPS">
		 <table width="100%" cellpadding="0" cellspacing="0">
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
				<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#EMPLOYEE_ID#','medium');" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a>-<cfif len(ROLE_ID) and (GET_ROL_NAME.recordcount)>#GET_ROL_NAME.PROJECT_ROLES#</cfif>
			  </td>	
			   <td width="15">
			  <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.emptypopup_member_del_emp&position_code=#position_code#&cp_id=#attributes.CPID#','small');"><img src="/images/delete_list.gif" border="0"></a>
			  </td>
			</tr>
		 </table>
		 </cfoutput>				 
		  <cfoutput query="get_PARS">
		  <table width="100%" cellpadding="0" cellspacing="0">
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
			  <td  width="15"  style="text-align:right;">
			   <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.emptypopup_member_del_par&partner_id=#partner_id#&cp_id=#attributes.CPID#','small');"><img src="/images/delete_list.gif" border="0"></a>
			  </td>				   
		     </tr>
		  </table>
		  </cfoutput>
		  </td>
		</tr>
	  </table>
	</td>
  </tr>
</table>
<!--- Ekip --->
