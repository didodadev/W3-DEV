<cfset cmp = createObject("component","V16.settings.cfc.setupDecisionmedicine") />
<cfset get_Decisionmedicine = cmp.getDecisionmedicine(decision_medicine_id:attributes.decision_medicine_id)>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
	<tr>
		<td align="left" class="headbold"><cf_get_lang no='91.Verilen İlaçlar'></td>
		<td width="100" align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_decisionmedicine"><img src="/images/plus1.gif" border="0" alt=<cf_get_lang_main no='170.Ekle'>></a></td>
	</tr>
</table>
<table border="0" cellspacing="1" cellpadding="3" width="98%" class="color-border" align="center">
	<tr class="color-row" valign="top">
		<td valign="top">
			<cfform name="upd_decision_medicine" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_decisionmedicine">
			<input name="decision_medicine_id" id="decision_medicine_id" value="<cfoutput>#attributes.decision_medicine_id#</cfoutput>" type="hidden">
			<table>
				<tr>
					<td><cf_get_lang_main no='81.Aktif'></td>
					<td><input type="Checkbox" name="medicine_status" id="medicine_status" value="1" <cfif get_Decisionmedicine.is_default eq 1> checked</cfif>>&nbsp;&nbsp;</td>
				</tr>
				<tr>
					<td width="50"><cf_get_lang_main no='221.Barkod'></td>
					<td><cfinput type="text" name="barcode" style="width:250px;" value="#get_Decisionmedicine.barcode#" maxlength="50"></td>
				</tr>
				<tr>
					<td><cf_get_lang no='116.İlaç'></td>
					<td><cfinput type="Text" name="decision_medicine" id="decision_medicine" value="#get_Decisionmedicine.decision_medicine#" style="width:250px;"></td>
				</tr>
                <tr>
					<td><cf_get_lang no='117.Etken Madde'></td>
					<td><cfinput type="Text" name="active_ingredient" value="#get_Decisionmedicine.active_ingredient#" style="width:250px;"></td>
				</tr>
				<tr>
					<td height="35">&nbsp;</td>
					<td style="text-align:right"><cf_workcube_buttons is_upd='1' is_delete='0' add_function="kontrol()"> </td>
				</tr>
				<tr>
					<td colspan="3"><p><br/>
						<cfoutput>
						<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_Decisionmedicine.record_emp,0,0)# - #dateformat(get_Decisionmedicine.record_date,dateformat_style)#<br/>
						<cfif len(get_Decisionmedicine.update_emp)><cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_Decisionmedicine.update_emp,0,0)# - #dateformat(get_Decisionmedicine.update_date,dateformat_style)#</cfif>
						</cfoutput>
					</td>
				</tr>
			</table>
			</cfform>
		</td>
	</tr>
</table>
<script type="text/javascript">
function kontrol()
{
	if(document.getElementById("decision_medicine").value == "")
	{
		alert("<cf_get_lang_main no='59.Eksik veri'> : <cf_get_lang no='116.İlaç'>!");
		return false;
	}
	return true;
}
</script>
