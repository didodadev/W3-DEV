<cfquery name="GET_DETAIL" datasource="#dsn3#">
	SELECT 
		SERVICE_DETAIL,
		SERVICE_HISTORY_ID
	FROM
		SERVICE_HISTORY
	WHERE 
		SERVICE_HISTORY_ID = #attributes.SERVICE_HISTORY_ID#
</cfquery>
<cf_popup_box title="#getLang('service',283)#"><!--Detay Güncelle-->
    <cfform name="upd_support" action="#request.self#?fuseaction=service.emptypopup_upd_service_history_detail" method="post" >
        <input type="hidden" value="<cfoutput>#attributes.SERVICE_HISTORY_ID#</cfoutput>" name="SERVICE_HISTORY_ID" id="SERVICE_HISTORY_ID">
        <table>
            <tr>
                <td><textarea name="SERVICE_DETAIL" id="SERVICE_DETAIL" style="width:350px;height:175px;"><cfoutput>#GET_DETAIL.SERVICE_DETAIL#</cfoutput></textarea></td>
            </tr>
        </table>
    <cf_popup_box_footer><cf_workcube_buttons is_upd='0'></cf_popup_box_footer>
    </cfform>
</cf_popup_box>
