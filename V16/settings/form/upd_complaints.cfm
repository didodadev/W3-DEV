<cfset cmp = createObject("component","V16.settings.cfc.setupComplaints") />
<cfset get_Complaint = cmp.getComplaints(complaint_id:attributes.complaint_id)>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
	<tr>
		<td align="left" class="headbold"><cf_get_lang no='118.Tanı'></td>
		<td width="100" align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_complaints"><img src="/images/plus1.gif" border="0" alt=<cf_get_lang_main no='170.Ekle'>></a></td>
	</tr>
</table>
<table border="0" cellspacing="1" cellpadding="3" width="98%" class="color-border" align="center">
	<tr class="color-row" valign="top">
		<td valign="top">
			<cfform name="upd_complaint" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_complaints">
			<input name="complaint_id" id="complaint_id" value="<cfoutput>#attributes.complaint_id#</cfoutput>" type="hidden">
			<table>
				<tr>
					<td><cf_get_lang_main no='81.Aktif'></td>
					<td><input type="Checkbox" name="complaint_status" id="complaint_status" value="1" <cfif get_Complaint.is_default eq 1> checked</cfif>></td>
				</tr>
				<tr>
					<td width="50"><cf_get_lang_main no='1173.kod'></td>
					<td><cfinput type="text" name="code" style="width:250px;" value="#get_Complaint.code#" maxlength="50"></td>
				</tr>
				<tr>
					<td><cf_get_lang no='131.Tanı'></td>
					<td><cfinput type="Text" name="complaint" id="complaint" value="#get_Complaint.complaint#" style="width:250px;"></td>
				</tr>
                <tr>
					<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
					<td><textarea name="description" id="description" style="width:250px;height:100px;"><cfoutput>#get_Complaint.description#</cfoutput></textarea></td>
				</tr>
				<tr>
					<td height="35">&nbsp;</td>
					<td style="text-align:right"><cf_workcube_buttons is_upd='1' is_delete='0' add_function="kontrol()"> </td>
				</tr>
				<tr>
					<td colspan="3"><p><br/>
						<cfoutput>
						<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_Complaint.record_emp,0,0)# - #dateformat(get_Complaint.record_date,dateformat_style)#<br/>
						<cfif len(get_Complaint.update_emp)><cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_Complaint.update_emp,0,0)# - #dateformat(get_Complaint.update_date,dateformat_style)#</cfif>
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
	if(document.getElementById("complaint").value == "")
	{
		alert("<cf_get_lang_main no='59.Eksik veri'> : <cf_get_lang no='131.Tanı'>!");
		return false;
	}
	return true;
}
</script>
