<cfquery name="get_in_out" datasource="#dsn#">
	SELECT * FROM EMPLOYEE_DAILY_IN_OUT WHERE ROW_ID = #attributes.row_id#
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='32320.PDKS Notu Gir'></cfsavecontent>
<cf_popup_box title="#message#">
<cfform name="add_note" action="#request.self#?fuseaction=myhome.emptypopup_edit_daily_in" method="post">
<input type="hidden" value="<cfoutput>#attributes.row_id#</cfoutput>" name="row_id" id="row_id">
    <table>
        <tr>
            <td class="txtbold" width="75"><cf_get_lang dictionary_id='57628.Giriş Tarihi'></td>
            <td><input type="text" readonly value="<cfoutput>#dateformat(get_in_out.start_date,dateformat_style)# #timeformat(get_in_out.start_date,timeformat_style)#</cfoutput>"></td>
        </tr>
        <tr>
            <td class="txtbold"><cf_get_lang dictionary_id='29438.Çıkış Tarihi'></td>
            <td><input type="text" readonly value="<cfoutput>#dateformat(get_in_out.finish_date,dateformat_style)# #timeformat(get_in_out.finish_date,timeformat_style)#</cfoutput>"></td>
        </tr>
        <tr>
            <td colspan="2" class="txtbold"><cf_get_lang dictionary_id='57629.Açıklama'></td>
        </tr>
        <tr>
            <td colspan="2">
                <textarea name="detail" id="detail" style="width:300px;height:60px;"><cfoutput>#get_in_out.detail#</cfoutput></textarea>
            </td>
        </tr>
    </table>
    <cf_popup_box_footer><cf_workcube_buttons type_format="1" is_upd='0'></cf_popup_box_footer>
</cfform>
</cf_popup_box>

