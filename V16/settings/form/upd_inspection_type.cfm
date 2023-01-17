<cfset cmp = createObject("component","V16.settings.cfc.setupInspectionTypes") />
<cfset get_inspection_type = cmp.getInspectionTypes(inspection_type_id:attributes.inspection_type_id)>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
	<tr>
		<td align="left" class="headbold"><cf_get_lang no='128.Muayene Tipi'></td>
		<td width="100" align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_inspection_type"><img src="/images/plus1.gif" border="0" alt=<cf_get_lang_main no='170.Ekle'>></a></td>
	</tr>
</table>
<table border="0" cellspacing="1" cellpadding="3" width="98%" class="color-border" align="center">
	<tr class="color-row" valign="top">
		<td width="250"><cfinclude template="../display/list_inspection_types.cfm"></td>
		<td valign="top">
			<cfform name="upd_inspection_type" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_inspection_type">
			<input name="inspection_type_id" id="inspection_type_id" value="<cfoutput>#attributes.inspection_type_id#</cfoutput>" type="hidden">
			<table>
				<tr>
					<td><cf_get_lang no='128.Muayene Tipi'></td>
					<td><cfinput type="Text" name="inspection_type" id="inspection_type" value="#get_inspection_type.inspection_type#" style="width:250px;"></td>
				</tr>
				<tr>
					<td height="35">&nbsp;</td>
					<td style="text-align:right"><cf_workcube_buttons is_upd='1' is_delete='0' add_function="kontrol()"> </td>
				</tr>
				<tr>
					<td colspan="3"><p><br/>
						<cfoutput>
						<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_inspection_type.record_emp,0,0)# - #dateformat(get_inspection_type.record_date,dateformat_style)#<br/>
						<cfif len(get_inspection_type.update_emp)><cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_inspection_type.update_emp,0,0)# - #dateformat(get_inspection_type.update_date,dateformat_style)#</cfif>
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
	if(document.getElementById("inspection_type").value == "")
	{
		alert("<cf_get_lang_main no='59.Eksik veri'> : <cf_get_lang no='128.Muayene Tipi'>!");
		return false;
	}
	return true;
}
</script>
