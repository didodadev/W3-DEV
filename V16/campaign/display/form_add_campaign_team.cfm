<input type="hidden" name="campaign_id" id="campaign_id" value="<cfoutput>#attributes.camp_id#</cfoutput>">
<cfinclude template="../query/get_campaign_team.cfm">
<table cellspacing="1" cellpadding="2" width="98%" border="0" class="color-border">
	<tr class="color-header">
	  <td height="22" class="form-title" width="100%"><cf_get_lang no='44.Ekip'></td>
	  <td width="15"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=campaign.popup_form_add_member&campaign_id=#attributes.camp_id#</cfoutput>','medium');"><img src="/images/plus_square.gif" alt="Grup Elemanı  Ekle" border="0" title="Grup Elemanı  Ekle" align="absmiddle"></a></td>
	</tr>
<cfif GET_EMPS.recordcount OR GET_PARS.RECORDCOUNT>
  <cfoutput query="GET_EMPS">
	<tr class="color-row">
	  <td width="200"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#EMPLOYEE_ID#','medium');" class="tableyazi">#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a> -
		<cfif len(ROLE_ID)>
		  <cfquery name="GET_ROL_NAME" datasource="#DSN3#">
			  SELECT 
				  CAMPAIGN_ROLE 
			  FROM 
				  SETUP_CAMPAIGN_ROLES 
			  WHERE 
				  CAMPAIGN_ROLE_ID = #ROLE_ID#
		  </cfquery>
			  #GET_ROL_NAME.CAMPAIGN_ROLE#
		</cfif>
	  </td>
	  <cfsavecontent variable="message_del"><cf_get_lang_main no='121.Silmek Istediginizden Emin Misiniz'></cfsavecontent>
	  <td><a href="javascript://" onClick="javascript:if (confirm('#message_del#')) windowopen('#request.self#?fuseaction=campaign.emptypopup_camp_team_del_emp&position_code=#position_code#&campaign_id=#attributes.camp_id#','small');"><img src="/images/delete_list.gif" alt="Sil" border="0"></a></td>
	</tr>
  </cfoutput> 
  <cfoutput query="GET_PARS">
	<tr class="color-row">
	  <td width="200"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#partner_id#','medium');" class="tableyazi">#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_NAME#</a>/#nickname# -
		<cfif len(ROLE_ID)>
		  <cfquery name="GET_ROL_NAME2" datasource="#DSN3#">
			  SELECT 
				  CAMPAIGN_ROLE 
			  FROM 
				  SETUP_CAMPAIGN_ROLES
			  WHERE 
				  CAMPAIGN_ROLE_ID = #ROLE_ID#
		  </cfquery>
		  #GET_ROL_NAME2.CAMPAIGN_ROLE#
		</cfif>
	  </td>
	   <cfsavecontent variable="message_del"><cf_get_lang_main no='121.Silmek Istediginizden Emin Misiniz'></cfsavecontent>
	  <td><a href="javascript://" onClick="javascript:if (confirm('#message_del#')) windowopen('#request.self#?fuseaction=campaign.emptypopup_camp_team_del_par&partner_id=#partner_id#&campaign_id=#attributes.camp_id#','small');return false;"><img src="/images/delete_list.gif" alt="Sil" border="0"></a></td>
	</tr>
  </cfoutput>
  <cfelse>
  <tr class="color-row">
	<td colspan="2"><cf_get_lang_main no='72.Kayit Bulunamadi'>!</td>
  </tr>
</cfif>
</table>

