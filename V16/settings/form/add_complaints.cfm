<cf_popup_box title="#getLang('settings',118)#">
	<cfform name="add_complaint" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_complaints">
        <input type="hidden" name="is_popup" id="is_popup" value="<cfif isdefined("attributes.is_popup")><cfoutput>#attributes.is_popup#</cfoutput></cfif>" />
        <table>
            <tr>
                <td><cf_get_lang_main no='81.Aktif'></td>
                <td><input type="Checkbox" name="complaint_status" id="complaint_status" value="1" checked></td>
            </tr>
            <tr>
                <td width="70"><cf_get_lang_main no='1173.kod'></td>
                <td><cfinput type="text" name="code" style="width:250px;"></td>
            </tr>
            <tr>
                <td><cf_get_lang no='131.Tanı'></td>
                <td><cfinput type="text" name="complaint" id="complaint" style="width:250px;"></td>
            </tr>
            <tr>
                <td nowrap="nowrap" valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                <td><textarea name="description" id="description" style="width:250px;height:100px;"></textarea></td>
            </tr>
        </table>
		<cf_popup_box_footer><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cf_popup_box_footer>
    </cfform>
</cf_popup_box>
<script type="text/javascript">
function kontrol()
{
	if(document.getElementById("complaint").value == "")
	{
		alert("<cf_get_lang_main no='59.Eksik veri'> : <cf_get_lang no='131.Tanı'>!");
		return false;
	}
	return true;
}
</script>
