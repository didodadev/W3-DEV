<cfsetting showdebugoutput="no">
<cf_box id="ref_member" title="Alt Üyelerin Bağlanacağı Referans Üye" style="width=260;">
<table border="0" width="250" cellpadding="2" cellspacing="1">
	<cfif isdefined("attributes.is_upd")>
		<tr>
			<td colspan="2">
				<cf_get_lang dictionary_id='59906.Taşı'>
				<input type="checkbox" name="is_ref_member" id="is_ref_member" value="1">
			</td>
		</tr>
		<tr>
			<td><cf_get_lang dictionary_id='57998.veya'></td>
		</tr>
	</cfif>
	<tr>
		<td colspan="2">
			<cf_get_lang dictionary_id='59907.Bir Üst Üyeye Bağla'>
			<input type="checkbox" name="is_upper_member" id="is_upper_member" value="1">
		</td>
	</tr>
	<tr>
		<td><cf_get_lang dictionary_id='57998.veya'></td>
	</tr>
	<tr>
		<td><cf_get_lang dictionary_id='58636.Referans Üye'></td>
		<td><input type="hidden" name="ref_pos_code_row" id="ref_pos_code_row" value="">
			<input type="text" name="ref_pos_code_name_row" id="ref_pos_code_name_row" style="width:110px;" value="">
			<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_cons&field_id=upd_consumer.ref_pos_code_row&field_consumer=upd_consumer.dsp_reference_code_row&field_name=upd_consumer.ref_pos_code_name_row&field_cons_ref_code=upd_consumer.reference_code_row&call_function=kontrol_ref_member(1)<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=3'</cfoutput>,'list','popup_list_cons')"><img src="/images/plus_list.gif" title="<cf_get_lang dictionary_id='57734.seçiniz'>" border="0" align="absmiddle"></a>
		</td>
	</tr>
	<tr>
		<td><cf_get_lang dictionary_id ='30593.Referans Kod'></td>
		<td>
			<input type="hidden" name="reference_code_row" id="reference_code_row" value="">
			<input type="text" name="dsp_reference_code_row" id="dsp_reference_code_row" value="" maxlength="250" style="width:110px;" readonly>
		</td>
	</tr>
	<tr>
		<td colspan="2"  style="text-align:right;">
			<input type="button" value="Kaydet" onClick="kontrol_row();">
		</td>
	</tr>
</table>
</cf_box>
<script type="text/javascript">
	function kontrol_row()
	{
		document.getElementById('open_process').style.display ='none';
		if(kontrol() == true)
		document.upd_consumer.submit();
	}
</script>

