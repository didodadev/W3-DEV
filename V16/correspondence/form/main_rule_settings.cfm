<cfsetting showdebugoutput="no">
<script type="text/javascript">
function rule_delete()
		{
		document.employee_main_mail_rules.operation.value='del';
		}
</script>
<cf_box title="Güncelleme" collapsable="0" style="position:absolute;width:300px;">
	<cfform action="#request.self#?fuseaction=correspondence.emptypopup_upd_main_rule_settings&rule_id=#attributes.rule_id#" method="post" name="employee_main_mail_rules">
		<input type="hidden" name="operation" id="operation" value="upd" />
		<cfquery name="upd_main_rule" datasource="#dsn#">
			SELECT * FROM CUBE_MAIL_MAIN_RULES WHERE RULE_ID = #attributes.rule_id#
		</cfquery>
		<table>
			<tr>
				<td><cf_get_lang no='253.İlgili Mail'></td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang no='253.İlgili Mail'></cfsavecontent>
					<cfinput type="text" name="rule_name" required="Yes" message="#message#" value="#upd_main_rule.RULE_NAME#" style="width:150px;">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='218.Tip'></td>
				<td>
				<select name="type" id="type" style="width:150px;">
					<option value="0" <cfif upd_main_rule.TYPE eq 0>selected</cfif>><cf_get_lang_main no='1562.Gelen'></option>
					<option value="1" <cfif upd_main_rule.TYPE eq 1>selected</cfif>><cf_get_lang_main no='1563.Giden'></option>	
				</select>
				</td>
			</tr>	
			<tr>
				<td><cf_get_lang no='254.Aktarılacak Mailler'></td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang_main no='782.Girilmesi Zorunlu Alan'> : <cf_get_lang no='254.Aktarılacak Mailler'></cfsavecontent>
					<cfinput type="text" name="action" required="Yes" message="message" value="#upd_main_rule.ACTION#" style="width:150px;"></td>
			</tr>
			<tr height="35">
				<td colspan="3"  style="text-align:right;">
				<cf_workcube_buttons is_upd='1' del_function="rule_delete()" is_cancel="0"></td>
			</tr>	
		</table>
	</cfform>
</cf_box>
