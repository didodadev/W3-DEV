<cfinclude template="../query/get_punishment_paper.cfm">
<cfsavecontent variable="right_"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_detail_punishment_paper&punishment_paper_id=<cfoutput>#attributes.PUNISHMENT_PAPER_ID#</cfoutput>','list');"><img border="0" src="images/print.gif"></a></cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="53456.Ceza Tebliğ Yazısı"></cfsavecontent>
<cf_popup_box title="#message#" right_images="#right_#">
<cfform  name="upd_punishment" action="#request.self#?fuseaction=ehesap.emptypopup_upd_punishment_paper" method="post">
  <table>
    <tr>
      <td><cf_get_lang dictionary_id='57480.Konu'></td>
      <td><input type="text" name="PUNISHMENT_SUBJECT" id="PUNISHMENT_SUBJECT"  style="width:150px;" value="<cfoutput>#get_punishment_paper.PUNISHMENT_SUBJECT#</cfoutput>" >
      </td>
      <td><cf_get_lang dictionary_id='53155.Kimden'></td>
      <td><input  type="text"  name="FROM_WHO" id="FROM_WHO" style="width:150px;" value="<cfoutput>#get_punishment_paper.FROM_WHO#</cfoutput>"  >
      </td>
    </tr>
    <tr>
      <td><cf_get_lang dictionary_id='58183.Yazan'> *</td>
      <td>
        <cfset EMP_ID=get_punishment_paper.MANAGER_ID>
        <cfif len(EMP_ID)>
          <cfinclude template="../query/get_action_emp.cfm">
          <cfset emp_name="#get_emp.EMPLOYEE_NAME# #get_emp.EMPLOYEE_SURNAME#">
          <cfelse>
          <cfset emp_name="">
        </cfif>
        <input type="hidden" name="PUNISHMENT_PAPER_ID" id="PUNISHMENT_PAPER_ID" value="<cfoutput>#get_punishment_paper.PUNISHMENT_PAPER_ID#</cfoutput>">
        <input type="hidden" name="event_id" id="event_id" value="<cfoutput>#get_punishment_paper.event_id#</cfoutput>">
        <input type="hidden" name="MANAGER_ID" id="MANAGER_ID" value="<cfoutput>#get_punishment_paper.MANAGER_ID#</cfoutput>">
        <input type="text" name="MANAGER" id="MANAGER"  value="<cfoutput>#emp_name#</cfoutput>" style="width:150px;">
        <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=upd_punishment.MANAGER_ID&field_emp_name=upd_punishment.MANAGER','list');return false"> <img src="/images/plus_thin.gif"  align="absmiddle" border="0"> </a> </td>
      <td><cf_get_lang dictionary_id='53157.Fesih Tarihi'></td>
      <td>
        <cfinput validate="#validate_style#" type="text" name="PUNISHMENT_DATE" value="#dateformat(get_punishment_paper.PUNISHMENT_DATE,dateformat_style)#" style="width:150px;">
        <cf_wrk_date_image date_field="PUNISHMENT_DATE"></td>
    </tr>
    <tr>
      <td colspan="4" valign="top">
         <cfmodule
            template="/fckeditor/fckeditor.cfm"
            toolbarSet="WRKContent"
            basePath="/fckeditor/"
            instanceName="PUNISHMENT_DETAIL"
            valign="top"
            value="#get_punishment_paper.PUNISHMENT_DETAIL#"
            width="500"
            height="300">					 
      </td>
    </tr>
  </table>
     <cf_popup_box_footer><cf_workcube_buttons is_upd='1'  delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_upd_punishment_paper&is_del=1&del_id=#get_punishment_paper.EVENT_ID#'></cf_popup_box_footer>
    </cfform>
</cf_popup_box>
