<cfsetting showdebugoutput="no">
<input type="hidden" name="campaign_id" id="campaign_id" value="<cfoutput>#attributes.camp_id#</cfoutput>">
<cfinclude template="../query/get_campaign_team.cfm">
<cf_flat_list>
	<thead>
        <tr>
            <th colspan="2"><cf_get_lang dictionary_id="57576.çalışan"></th>
        </tr>
    </thead>
    <tbody>
	<cfif GET_EMPS.recordcount OR GET_PARS.RECORDCOUNT>
      <cfoutput query="GET_EMPS">
        <tr id="__erase__#camp_id#_#currentrow#">
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
			<div id="erase#camp_id#" style="display:none;"></div>
			 <cfsavecontent variable="message_del"><cf_get_lang dictionary_id='57533.Silmek Istediginizden Emin Misiniz'></cfsavecontent>
			<td width="20"><a style="cursor:pointer;" onClick="javascript:if (confirm('#message_del#')){AjaxPageLoad('#request.self#?fuseaction=campaign.emptypopup_camp_team_del_emp&position_code=#position_code#&campaign_id=#attributes.camp_id#&is_ajax_delete','erase#camp_id#');gizle(__erase__#camp_id#_#currentrow#);}"><img src="/images/delete_list.gif" alt="Sil"></a></td>
        </tr>
      </cfoutput> 
      <cfoutput query="GET_PARS">
        <tr>
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
		  <cfsavecontent variable="message_del"><cf_get_lang dictionary_id='57533.Silmek Istediginizden Emin Misiniz'></cfsavecontent>
  		  <td width="20"><a style="cursor:pointer;" onClick="javascript:if (confirm('#message_del#')){AjaxPageLoad('#request.self#?fuseaction=campaign.emptypopup_camp_team_del_par&partner_id=#partner_id#&campaign_id=#attributes.camp_id#&is_ajax_delete','erase#camp_id#');gizle(__erase__#camp_id#_#currentrow#);}"><img src="/images/delete_list.gif" alt="Sil"></a></td>
        </tr>
      </cfoutput>
      <cfelse>
      <tr>
        <td colspan="2"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'>!</td>
      </tr>
    </cfif>
    </tbody>
</cf_flat_list>

