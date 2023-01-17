<cfoutput>
	<iframe src="" width="1" height="1" style="display:inline;" name="add_row_frame" id="add_row_frame"></iframe>
	<cfform name="add_multi_row" id="add_multi_row" enctype="multipart/form-data" action="#request.self#?fuseaction=credit.emptypopup_add_multi_credit_row" target="add_row_frame">
		<cf_box title="Satır Çoğalt" style="width:150px;" body_style="width:150px;height:100px">
			<input type="hidden" name="type" id="type" value="<cfoutput>#attributes.type#</cfoutput>" />
			<input type="hidden" name="row_number" id="row_number" value="<cfoutput>#attributes.row_number#</cfoutput>" />
			<table border="0" align="left">
				<tr>
					<td><cf_get_lang no='7.Periyot'></td>
					<td>
						<select name="period" id="period" style="width:60px;" onChange="period_control();">
							<option value="1" selected><cf_get_lang_main no='1312.Ay'></option>
							<option value="2"><cf_get_lang_main no='78.Gün'></option>
						</select>
					</td>
				</tr>
				<tr id="day_number_" style="display:none;">
					<td><cf_get_lang no='8.Artış Günü'>*</td>
					<td>
						<input type="text" name="day_number" id="day_number" style="width:60px;">
					</td>
				</tr>
				<tr>
					<td nowrap="nowrap"><cf_get_lang no='9.Tekrar Sayısı'>*</td>
					<td>
						<input type="text" name="repetition_number" id="repetition_number" style="width:60px;" value="1">
					</td>
				</tr>
				<tr>
					<td colspan="2" style="text-align:right;">
						<input type="button" value="<cf_get_lang_main no='170.Ekle'>" onclick="control();">
					</td>
				</tr>
			</table>
		</cf_box>
	</cfform>
</cfoutput>
<script type="text/javascript">
	function period_control()
	{
		if(document.getElementById("period").value == 2)
			document.getElementById("day_number_").style.display = '';
		else
			document.getElementById("day_number_").style.display = 'none';
	}
	function control()
	{
		if(document.getElementById("day_number_").style.display != 'none' && document.getElementById("day_number").value == '')
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='8.Artış Günü'>");
			return false;
		}
		if(document.getElementById("repetition_number").value == '')
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='9.Tekrar Sayısı'>");
			return false;
		}
		document.add_multi_row.submit();
		document.getElementById('add_multi_row').style.display='none';
	}
</script>

