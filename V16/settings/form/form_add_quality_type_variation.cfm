<cfquery name="GET_CONTROL_TYPE" datasource="#DSN3#">
	SELECT
		*
	FROM
		QUALITY_CONTROL_TYPE
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
  	<tr>
    	<td class="headbold"><cf_get_lang no='732.Kalite Kontrol Alt Kategori'></td>
  	</tr>
</table>
<table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
	<tr class="color-row" valign="top">
  		<td width="200"><cfinclude template="..\display\list_quality_type_variation.cfm"></td>
		<td>
		<table border="0">
		<cfform action="#request.self#?fuseaction=settings.emptypopup_add_quality_type_variation" method="post" name="add_quality_type_variation">
			<tr>
				<td width="100"><cf_get_lang_main no='74.Kontrol Tipi'><font color=black>*</font></td>
				<td>
					<select name="quality_control_type_id" id="quality_control_type_id" style="width:150px;">
                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfoutput query="get_control_type">
                            <option value="#type_id#">#quality_control_type#</option>
                        </cfoutput>
					</select>
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='68.Başlık'><font color=black>*</font></td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang_main no='324.Başlık Girmelisiniz'></cfsavecontent>
					<cfinput type="Text" name="quality_control_row" style="width:150px;" value="" maxlength="20" required="Yes" message="#message#">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='1646.Tolarans'></td>
				<td><cfinput type="Text" name="tolerance" style="width:150px;" value="" maxlength="20"></td>
			</tr>
			<tr height="35">
				<td></td>
				<td><cf_workcube_buttons is_upd='0' add_function='control()'></td>
			</tr>
		  </cfform>
		</table>
		</td>
	</tr>
</table>
<br />

<script type="text/javascript">
function control()
{
	x = document.add_quality_type_variation.quality_control_type_id.selectedIndex;
	if (document.add_quality_type_variation.quality_control_type_id[x].value == "")
	{ 
		alert ("<cf_get_lang no='1192.Kontrol Tipi Seçmediniz !'>");
		return false;
	}
	return true;
}
</script>
