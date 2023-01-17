<cfinclude template="../query/get_discipline_decision.cfm">
<cfsavecontent variable="right_"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_detail_discipline_decision&discipline_id=<cfoutput>#attributes.discipline_id#</cfoutput>','list');"><img src="images/print.gif"></a></cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="53299.Disiplin Kurulu Kararı"></cfsavecontent>
<cf_popup_box title="#message#" right_images="#right_#">
<cfform name="upd_discipline" action="#request.self#?fuseaction=ehesap.emptypopup_upd_discipline_decision" method="post">
  <table border="0">
    <tr>
      <td width="65"><cf_get_lang dictionary_id='53300.Toplantı No'></td>
      <td><input type="text" name="meeting_no" id="meeting_no" value="<cfoutput>#get_discipline_detail.MEETING_NO#</cfoutput>"  style="width:150px;">
      </td>
      <td><cf_get_lang dictionary_id='53305.Başkan'>*</td>
      <td>
        <cfset EMP_ID=get_discipline_detail.CHAIRMAN>
        <cfif len(EMP_ID)>
          <cfinclude template="../query/get_action_emp.cfm">
          <cfset emp_name="#get_emp.EMPLOYEE_NAME# #get_emp.EMPLOYEE_SURNAME#">
          <cfelse>
          <cfset emp_name="">
        </cfif>
        <input type="hidden" name="discipline_id" id="discipline_id" value="<cfoutput>#attributes.discipline_id#</cfoutput>">
        <input type="hidden" name="event_id" id="event_id" value="<cfoutput>#get_discipline_detail.EVENT_ID#</cfoutput>">
        <input type="hidden" name="chairman_id" id="chairman_id" value="<cfoutput>#get_discipline_detail.CHAIRMAN#</cfoutput>">
        <input type="text" name="chairman" id="chairman"    value="<cfoutput>#emp_name#</cfoutput>"  style="width:150px;">
        <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=upd_discipline.chairman_id&field_emp_name=upd_discipline.chairman','list');return false"> <img src="/images/plus_thin.gif"  align="absmiddle" border="0"> </a> </td>
    </tr>
    <tr>
      <td><cf_get_lang dictionary_id='53301.Toplantı Tarihi'></td>
      <td>
        <cfinput validate="#validate_style#" type="text" name="MEETING_DATE" value="#dateformat(get_discipline_detail.MEETING_DATE,dateformat_style)#" style="width:150px;">
        <cf_wrk_date_image date_field="MEETING_DATE"></td>
      <td><cf_get_lang dictionary_id='57658.Üye'>*</td>
      <td>
        <cfset EMP_ID=get_discipline_detail.MEMBER1>
        <cfif len(EMP_ID)>
          <cfinclude template="../query/get_action_emp.cfm">
          <cfset emp_name="#get_emp.EMPLOYEE_NAME# #get_emp.EMPLOYEE_SURNAME#">
          <cfelse>
          <cfset emp_name="">
        </cfif>
        <input type="hidden" name="member1_id" id="member1_id" value="<cfoutput>#get_discipline_detail.MEMBER1#</cfoutput>">
        <input type="text" name="member1" id="member1"   value="<cfoutput>#emp_name#</cfoutput>" style="width:150px;">
        <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=upd_discipline.member1_id&field_emp_name=upd_discipline.member1','list');return false"> <img src="/images/plus_thin.gif" align="absmiddle" border="0"> </a> </td>
    </tr>
    <tr>
      <td width="65"><cf_get_lang dictionary_id='53302.Dosya No'></td>
      <td><input type="text" name="folder_no" id="folder_no"   value="<cfoutput>#get_discipline_detail.FOLDER_NO#</cfoutput>" style="width:150px;">
      </td>
      <td><cf_get_lang dictionary_id='57658.Üye'>*</td>
      <td>
        <cfset EMP_ID=get_discipline_detail.MEMBER2>
        <cfif len(EMP_ID)>
          <cfinclude template="../query/get_action_emp.cfm">
          <cfset emp_name="#get_emp.EMPLOYEE_NAME# #get_emp.EMPLOYEE_SURNAME#">
          <cfelse>
          <cfset emp_name="">
        </cfif>
        <input type="hidden" name="member2_id" id="member2_id"  value="<cfoutput>#get_discipline_detail.MEMBER2#</cfoutput>">
        <input type="text" name="member2" id="member2" style="width:150px;"  value="<cfoutput>#emp_name#</cfoutput>">
        <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_discipline.member2_id&field_emp_name=add_discipline.member2','list');return false"> <img src="/images/plus_thin.gif"  align="absmiddle" border="0"> </a> </td>
    <tr>
      <td width="65"><cf_get_lang dictionary_id='53303.Karar No'></td>
      <td><input type="text" name="decision_no" id="decision_no"  style="width:150px;"  value="<cfoutput>#get_discipline_detail.DECISION_NO#</cfoutput>">
      </td>
      <td><cf_get_lang dictionary_id='53306.Karar Tarihi'></td>
      <td>
        <cfinput validate="#validate_style#" type="text" name="DECISION_DATE"  value="#dateformat(get_discipline_detail.DECISION_DATE,dateformat_style)#" style="width:150px;">
        <cf_wrk_date_image date_field="DECISION_DATE"></td>
    </tr>
    <tr>
    <td><cf_get_lang dictionary_id='53304.Disiplin Kuruluna Sevk Tarihi'></td>
    <td colspan="3">
    <cfinput validate="#validate_style#" type="text" name="DELIVER_DATE" value="" style="width:150px;"> 
    <cf_wrk_date_image date_field="DELIVER_DATE"> 
    </td>
    </tr>  		
    <tr>
      <td valign="top"><cf_get_lang dictionary_id='53409.Karar İçerik'></td>
      <td  colspan="3">
         <cfmodule
            template="/fckeditor/fckeditor.cfm"
            toolbarSet="WRKContent"
            basePath="/fckeditor/"
            instanceName="decision_detail"
            valign="top"
            value="#get_discipline_detail.DECISION_DETAIL#"
            width="450"
            height="300">
      </td>
    </tr>
  </table>
<cf_popup_box_footer>
	<cf_workcube_buttons 
      is_upd='1' 
      delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_upd_discipline_decision&is_del=1&del_id=#get_discipline_detail.EVENT_ID#'>
</cf_popup_box_footer>
    </cfform>
</cf_popup_box>
