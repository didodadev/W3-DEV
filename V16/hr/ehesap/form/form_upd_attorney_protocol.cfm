<cfquery NAME="GET_EMPLOYEE_EVENT_ATTORNEY_PROTOCOL" DATASOURCE="#DSN#">
	SELECT
		*
	FROM
		EMPLOYEE_EVENT_ATTORNEY_PROTOCOL
	WHERE
		ATTORNEY_PROTOCOL_ID=#attributes.ATTORNEY_PROTOCOL_ID#
</cfquery>
<cfsavecontent variable="img"><a href="<cfoutput>#request.self#?fuseaction=ehesap.popup_form_add_attorney_protocol&event_id=#event_id#</cfoutput>"><img src="/images/plus1.gif" border="0" align="absmiddle" title="<cf_get_lang dictionary_id='57582.Ekle'>"></a></cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="53183.Savcılığa Bildirim Yazısı"></cfsavecontent>
<cf_popup_box title="#message#" right_images="#img#">
<cfform name="upd_attorney_protocol" action="#request.self#?fuseaction=ehesap.emptypopup_upd_attorney_protocol" method="post">
  <table>
    <tr>
      <td width="65"><cf_get_lang dictionary_id='57480.Konu'>*</td>
      <td><cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.başlık girmelisiniz'></cfsavecontent>
      <cfinput type="text" name="PROTOCOL_HEAD" value="#GET_EMPLOYEE_EVENT_ATTORNEY_PROTOCOL.PROTOCOL_HEAD#" style="width:150px;" required="yes" message="#message#"></td>
     </tr>
     <tr>
      <td><cf_get_lang dictionary_id='57742.Tarih'></td>
      <td>
      <input type="hidden" name="event_id" id="event_id" value="<cfoutput>#attributes.event_id#</cfoutput>">
      <input type="hidden" name="attorney_protocol_id" id="attorney_protocol_id" value="<cfoutput>#attributes.attorney_protocol_id#</cfoutput>">
        <cfinput validate="#validate_style#" type="text" name="PROTOCOL_DATE"  value="#dateformat(GET_EMPLOYEE_EVENT_ATTORNEY_PROTOCOL.PROTOCOL_DATE,dateformat_style)#" style="width:150px;">
        <cf_wrk_date_image date_field="PROTOCOL_DATE"></td>
    </tr>
    <tr>
    <td>&nbsp;</td>
    <td><input type="checkbox" name="IS_ATTORNEY" id="IS_ATTORNEY" <cfif isdefined("GET_EMPLOYEE_EVENT_ATTORNEY_PROTOCOL.IS_ATTORNEY")>checked</cfif>><cf_get_lang dictionary_id='32164.Olay Tutanağı Ekle'></td>
    </tr>
    <tr>
      <td valign="top"><cf_get_lang dictionary_id='57629.Açıklama'></td>
      <td  colspan="3">
             <cfmodule
                template="/fckeditor/fckeditor.cfm"
                toolbarSet="WRKContent"
                basePath="/fckeditor/"
                instanceName="detail"
                valign="top"
                value="#GET_EMPLOYEE_EVENT_ATTORNEY_PROTOCOL.DETAIL#"
                width="500"
                height="300">	
         </td>
    </tr>
  </table>
  <cf_popup_box_footer><cf_workcube_buttons is_upd='1' is_delete='0'></cf_popup_box_footer>
</cfform>
</cf_popup_box>
