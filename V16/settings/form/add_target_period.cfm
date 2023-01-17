<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
	<td class="headbold"><cf_get_lang no='1877.Hedef Dönem Ekle'></td>
  </tr>
</table>
<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
	<tr class="color-row">
		<td width="200" valign="top"><cfinclude template="../display/list_target_period.cfm"></td>
		<td valign="top">
		<table>
		<cfform name="add_target_period" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_target_period">
			<tr>
				<td width="100"><cf_get_lang_main no='1060.Dönem'> *</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang no ='1878.Dönem Girmelisiniz'>!</cfsavecontent>
					<cfinput type="text" name="target_period" value="" maxlength="25" required="yes" message="#message#" style="width:150px;">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang no='1698.Ay Katsayısı'>*</td>
				<td>
					<select name="coefficient" id="coefficient" style="width:150px;">
						<option value=""><cf_get_lang_main no='322.Seciniz'></option>
						<option value="1">1</option>
						<option value="3">3</option>
						<option value="6">6</option>
						<option value="9">9</option>
						<option value="12">12</option>
					</select>
				</td>
			</tr>
			<tr>
				<td width="100" valign="top"><cf_get_lang_main no='217.Açıklama'></td>
				<td><textarea name="detail" id="detail" style="width:150px;height:60px;"></textarea></td>
			</tr>
		  	<tr>
				<td></td>
				<td><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
			</tr>
		</cfform>
		</table>
		</td>
	</tr>
</table>		
<script type="text/javascript">
function kontrol()
{
	if(document.add_target_period.detail.value.length>100)
	{
		alert("<cf_get_lang no ='1792.Açıklama 100 Karakterden Uzun Olamaz'> !");
		return false;
	}
	
	if(document.add_target_period.coefficient.value=="")
	{
		alert("<cf_get_lang no ='1879.Ay Katsayısı Seçmelisiniz'> !");
		return false;
	}	
	return true;
}
</script>
