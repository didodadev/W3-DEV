<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
 <tr>
	<td class="headbold" height="35">Devir Sayım Belgesi Oluştur</td>
</tr>
</table>
	 <table width="98%" align="center" cellpadding="2" cellspacing="1" class="color-border">
		<cfform name="form_basket" action="#request.self#?fuseaction=store.display_file_phl" method="post" enctype="multipart/form-data">
		<input type="hidden" name="file_format" id="file_format" value="1">
			<tr class="color-row">
			<td valign="top">
				<table>
				  <tr>
					<td><cf_get_lang_main no='56.Belge'>*</td>
					<td width="220"><input type="file" name="uploaded_file" id="uploaded_file" style="width:200;"></td>
					<td>Şube *</td>
					<td>
						<input type="hidden" name="branch_id" id="branch_id">
						<input type="hidden" name="location_in" id="location_in">							
						<input type="hidden" name="department_in" id="department_in">
						<input type="text" name="txt_departman_in" id="txt_departman_in" style="width:150px;">
						<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_stores_locations&form_name=form_basket&is_branch=1&field_name=txt_departman_in&field_id=department_in&field_location_id=location_in&branch_id=branch_id','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
					</td>
				  </tr>
				  <tr>
					<td>Açıklama</td>
					<td width="220"><input type="text" name="description" id="description" style="width:200;"></td>
					<td>Belge Ayracı</td>
					<td>
					<select name="seperator_type" id="seperator_type" style="width:150;">
					<option value="59">Noktalı Virgül</option>
					<option value="44">Virgül</option>
					</select>
					</td>
					<td style="text-align:right;">
						<input type="button"  name="listele" id="listele" value="Listele" onClick="ekle_form_action();">
					</td>
				</tr>
			  	</table>
			</td>
		  </tr>

	</cfform>
</table>
<script type="text/javascript">
function ekle_form_action(){
	form_basket.submit();
}
</script>
