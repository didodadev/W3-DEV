<cf_popup_box title="#getLang('settings',91)#">
	<cfform name="add_decisine_medicine" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_decisionmedicine">
        <input type="hidden" name="is_popup" id="is_popup" value="<cfif isdefined("attributes.is_popup")><cfoutput>#attributes.is_popup#</cfoutput></cfif>" />
        <table>
            <tr>
                <td><cf_get_lang_main no='81.Aktif'></td>
                <td><input type="Checkbox" name="medicine_status" id="medicine_status" value="1" checked></td>
            </tr>
            <tr>
                <td width="70"><cf_get_lang_main no='221.Barkod'></td>
                <td><cfinput type="text" name="barcode" style="width:250px;" maxlength="50"></td>
            </tr>
            <tr>
                <td><cf_get_lang no='116.İlaç'></td>
                <td><cfinput type="text" name="decisionmedicine" id="decisionmedicine" style="width:250px;"></td>
            </tr>
            <tr>
                <td nowrap="nowrap"><cf_get_lang no='117.Etken Madde'></td>
                <td><cfinput type="text" name="active_ingredient" style="width:250px;" ></td>
            </tr>
		</table>
		<cf_popup_box_footer><cf_workcube_buttons is_upd='0' add_function='kontrol()'></cf_popup_box_footer>
    </cfform>
</cf_popup_box>
<script type="text/javascript">
function kontrol()
{
	if(document.getElementById("decisionmedicine").value == "")
	{
		alert("<cf_get_lang_main no='59.Eksik veri'> : <cf_get_lang no='116.İlaç'>!");
		return false;
	}
	return true;
}
</script>

