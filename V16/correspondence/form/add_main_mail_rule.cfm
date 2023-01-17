<cfsetting showdebugoutput="no">
<cf_box title="Kural Ekle" collapsable="0" style="position:absolute;width:300px;">
<table>
	<cfform name="employee_main_mail_rules" action="#request.self#?fuseaction=correspondence.emptypopup_main_mail_rules_setting" method="post">
	<tr>
		<td><cf_get_lang no='253.İlgili Mail'></td>
		<td>
			<cfsavecontent variable="message"><cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang no='253.İlgili Mail'></cfsavecontent>
			<cfinput type="text" name="rule_name" message="#message#" required="Yes" style="width:150px;">
		</td>
	</tr>
	<tr>
		<td><cf_get_lang_main no='218.Tip'></td>
		<td>
		<select name="type" id="type" style="width:150px;">
			<option value="0"><cf_get_lang_main no='1562.Gelen'></option>
			<option value="1"><cf_get_lang_main no='1563.Giden'></option>
		</select>	
		</td>
	</tr>	
	<tr>
		<td><cf_get_lang no='254.Aktarılacak Mailler'></td>
		<td>
			<cfsavecontent variable="message"><cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang no='254.Aktarılacak Mailler'></cfsavecontent>
			<cfinput type="text" name="action" required="Yes" message="#message#" style="width:150px;"></td>
	</tr>
	<tr height="35">
		<td></td>
		<td  style="text-align:right;"><cf_workcube_buttons is_upd='0' is_cancel="0"></td>
	</tr>	
	</cfform>
</table>
</cf_box>
