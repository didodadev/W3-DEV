<cfsetting showdebugoutput="no">
<script type="text/javascript">
function mail_rule()
{		
	if(employee_mail_rules.name.value == "")
	{
		alert("<cf_get_lang no='248.Kural İsmini Boş Bırakmayın'>!");
		return false;
	}
	if(employee_mail_rules.words.value == "")
	{
		alert("<cf_get_lang no='249.Aranacak Kelimeyi Boş Bırakmayın'>!");
		return false;
	}
	return true;		 
}
		
function rule_delete()
{
	document.employee_mail_rules.operation.value='del';
}
	
</script>
<cfsavecontent variable="mailaccount"><cf_get_lang no ='102.Mail Account'></cfsavecontent>
<cf_box title="Güncelleme" style="position:absolute;width:350px;" collapsable="0">
<cfform action="#request.self#?fuseaction=correspondence.emptypopup_upd_rule_settings&rule_id=#attributes.rule_id#&employee_id=#attributes.employee_id#" method="post" name="employee_mail_rules">
	<input type="Hidden" name="employee_id" id="employee_id" value="#attributes.employee_id#">
	<input type="hidden" name="operation" id="operation" value="upd" />
	<cfquery name="up_rule" datasource="#DSN#">
		SELECT * FROM CUBE_MAIL_RULES WHERE RULE_ID = #attributes.rule_id#
	</cfquery>
	<table> 
	<cfif up_rule.recordcount>  
	<cfoutput query="up_rule">
		<tr>
			<td><cf_get_lang no='246.Kural Tanımı'></td>
			<td><cfinput type="text" name="name" value="#RULE_NAME#" style="width:150px;" maxlength="50"></td>
		</tr>
		<tr>
			<td><cf_get_lang no='226.Arama Tipi'></td>
			<td>
			 <select name="type" id="type" style="width:150px;">
                 <option value="1" <cfif up_rule.RULE_TYPE eq 1>selected</cfif>><cf_get_lang no='235.Mail Kimden Satırında Ara'></option>
                 <option value="2" <cfif up_rule.RULE_TYPE eq 2>selected</cfif>><cf_get_lang no='236.Mail İçeriğinde Ara'></option>
                 <option value="3" <cfif up_rule.RULE_TYPE eq 3>selected</cfif>><cf_get_lang no='237.Mail Başlığında Ara'></option>
                 <option value="4" <cfif up_rule.RULE_TYPE eq 4>selected</cfif>><cf_get_lang no='238.Mail Kime Satırında Ara'></option>
			 </select></td>
		</tr>
		<tr>
			<td><cf_get_lang no='227.Kelime'></td>
			<td><cfinput type="text" name="words" required="Yes" message="" value="#RULE_CASE#" style="width:150px;" maxlength="50"> </td>
		</tr>
	</cfoutput>
	<cfinclude template="../query/get_folders.cfm">
		<tr><td><cf_get_lang no='228.Taşınacak Klasör'></td>
			<td>
				<select name="folder" id="folder" style="width:150px;">
					<cfoutput query="get_folders">
						<cfif folder_id gt 0>
							<option value="#folder_id#" <cfif up_rule.folder_id eq folder_id>selected</cfif>>#folder_name#</option>
						</cfif>
					</cfoutput>
				</select >
				</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no="73.Öncelik"></td>
			<td>
				<select name="priority" id="priority">
				<option value="0"><cf_get_lang_main no="322.Seçiniz"></option>
				<option value="1" <cfif up_rule.priority eq 1>selected</cfif>>1</option>
				<option value="2" <cfif up_rule.priority eq 2>selected</cfif>>2</option>
				<option value="3" <cfif up_rule.priority eq 3>selected</cfif>>3</option>
				<option value="4" <cfif up_rule.priority eq 4>selected</cfif>>4</option>
				<option value="5" <cfif up_rule.priority eq 5>selected</cfif>>5</option>
				<option value="6" <cfif up_rule.priority eq 6>selected</cfif>>6</option>
				<option value="7" <cfif up_rule.priority eq 7>selected</cfif>>7</option>
				<option value="8" <cfif up_rule.priority eq 8>selected</cfif>>8</option>
				<option value="9" <cfif up_rule.priority eq 9>selected</cfif>>9</option>
				<option value="10" <cfif up_rule.priority eq 10>selected</cfif>>10</option>
				</select>
			</td>
		</tr>
		<tr height="35">
			<td colspan="3"  style="text-align:right;">
			<cf_workcube_buttons is_upd='1' del_function="rule_delete()" is_cancel="0" add_function="mail_rule()"></td>
		</tr>	
	</cfif>
	</table>
</cfform>
</cf_box>

