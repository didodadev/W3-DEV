<cfinclude template="../query/get_zimmet_detail.cfm">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55464.Demirbaş Teslim Alan"></cfsavecontent>
<cf_popup_box title="#message#">
<cfform  action="#request.self#?fuseaction=hr.emptypopup_close_zimmet" method="post" name="close_zimmet">
  <input type="hidden"  name="zimmet_id" id="zimmet_id" value="<cfoutput>#attributes.zimmet_id#</cfoutput>">
  <input type="hidden"  name="zimmet_row_id" id="zimmet_row_id" <cfif isdefined("attributes.zimmet_row_id")>value="<cfoutput>#attributes.zimmet_row_id#</cfoutput>"</cfif>>
  <input type="hidden" name="give_emp_id" id="give_emp_id" value="<cfoutput>#attributes.emp_id#</cfoutput>">
    <table>
        <tr>
            <td width="5"></td>
            <td width="65"><cf_get_lang dictionary_id='57570.Adı Soyadı'></td>
            <td>
            <input type="hidden" name="employee_id" id="employee_id" value="">
            <cfsavecontent variable="message">Ad Soyad Grimelisiniz</cfsavecontent>
            <cfinput name="employee_name"  style="width:150px;" value=""  required="yes"   message="#message#" type="text">
            <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=close_zimmet.employee_id&field_emp_name=close_zimmet.employee_name','list');return false"> <img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a> </td>
            </tr>
            <tr>
            <td width="5"></td>
            <td width="65"><cf_get_lang dictionary_id='57742.Tarih'></td>
            <td>
            <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
            <cfinput  type="text"  validate="#validate_style#" name="tarih" required="yes" message="#message#" value="#dateformat(now(),dateformat_style)#" style="width:150px;" >
            <cf_wrk_date_image date_field="tarih"></td>
        </tr>
    </table>
	<cf_popup_box_footer><cf_workcube_buttons is_upd='0'></cf_popup_box_footer>
</cfform>
</cf_popup_box>
