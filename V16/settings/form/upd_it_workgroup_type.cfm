<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
  <tr>
    <td class="headbold"><cf_get_lang no ='3096.IT İş Grubu Güncelle'></td>
    <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.add_it_workgroup_type"><img src="/images/plus1.gif" border="0" align="absmiddle" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
  </tr>
</table>
<table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
	<tr class="color-row">
		<td valign="top" width="250" class="txtbold">
			<cfinclude template="../display/list_it_workgroup_type.cfm">
		</td> 
		<td valign="top">
			<table border="0">
			  <cfform name="upd_it_workgroup_type" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_it_workgroup_type">
				<input type="hidden" name="workgroup_type_id" id="workgroup_type_id" value="<cfoutput>#attributes.workgroup_type_id#</cfoutput>">
				<cfquery name="get_it_workgroup_type" datasource="#dsn#">
					SELECT
						WORKGROUP_TYPE_ID,
						WORKGROUP_TYPE_NAME,
						INTERNAL_GROUP,
						EXTERNAL_GROUP
					FROM
						SETUP_IT_WORKGROUP_TYPE
					WHERE 
						WORKGROUP_TYPE_ID = #attributes.workgroup_type_id#
					ORDER BY
						WORKGROUP_TYPE_NAME
				</cfquery>
				<tr>
					<td width="100"><cf_get_lang_main no='219.Ad'> *</td>
					<td><input type="hidden" name="workgroup_type_id_" id="workgroup_type_id_" value="<cfoutput>#get_it_workgroup_type.workgroup_type_id#</cfoutput>">
						<input type="text" name="workgroup_type_name_" id="workgroup_type_name_" value="<cfoutput>#get_it_workgroup_type.workgroup_type_name#</cfoutput>" style="width:150px;">
					</td>
				</tr>
				<tr>
					<td><cf_get_lang no='3097.İç Grup'></td>
					<td><input type="checkbox" name="internal_group" id="internal_group" value="1" <cfif get_it_workgroup_type.internal_group eq 1>checked</cfif>></td>
				</tr>
				<tr>
					<td><cf_get_lang no='3098.Dış Grup'></td>
					<td><input type="checkbox" name="external_group" id="external_group" value="1" <cfif get_it_workgroup_type.external_group eq 1>checked</cfif>></td>
				</tr>
				<tr>
				  <td></td>
				  <td height="35"><cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'></td>
				</tr>
			  </cfform>
			</table>
		</td>
	</tr>
</table>
<script type="text/javascript">
function kontrol()
{
	if(document.upd_it_workgroup_type.workgroup_type_name_.value == "")
	{
		alert("<cf_get_lang_main no='1527.Ad Girmelisiniz'> !");
		return false;
	}	
	return true;	
}
</script>
<br/>
