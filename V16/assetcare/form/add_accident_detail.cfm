
<cfquery name="GET_ACCIDENTS" datasource="#dsn#">
	SELECT ACCIDENT_TYPE_ID, ACCIDENT_TYPE_NAME FROM SETUP_ACCIDENT_TYPE ORDER BY ACCIDENT_TYPE_NAME
</cfquery>
<cfinclude template="../query/get_money.cfm">
<cf_popup_box title="#getLang('assetcare',401)#">
	<cfform  method="post" name="add_kaza" action="#request.self#?fuseaction=assetcare.emptypopup_add_kaza">
	<input name="is_detail" id="is_detail" value="1" type="hidden">
	<input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#attributes.assetp_id#</cfoutput>">
		<table width="100%" border="0">
			<tr>
				<td><cf_get_lang_main no='1656.Plaka'>*</td>
				<td width="220"><cfquery name="GET_ASSETP" datasource="#dsn#">
					SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = #attributes.assetp_id#
					</cfquery><cfoutput>#get_assetp.assetp#</cfoutput></td>
				<td width=""><cf_get_lang no='399.Sigorta Ödemesi'></td>
				<td><input type="checkbox" name="insurance_payment" id="insurance_payment"  id="insurance_payment" value="1"></td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='132.Sorumlu'> *</td>
				<td><input type="hidden" name="employee_id" id="employee_id" value="">
					<cfsavecontent variable="message2"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='132.Sorumlu'>!</cfsavecontent>
					<cfinput type="Text" name="employee_name" value="" readonly style="width:170px;" required="yes" message="#message2#">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_kaza.employee_id&field_name=add_kaza.employee_name&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='132.Sorumlu'>" align="absmiddle" border="0"></a></td>
				<td><cf_get_lang no='404.Cezai Madde'></td>
				<td><input name="penalty_item" type="text" id="penalty_item" style="width:170px;"></td>
			</tr>
			<tr>
				<td><cf_get_lang no='727.Sigorta Durumu'></td>
				<td><input name="insurance_status" type="text" id="insurance_status3" style="width:170px;" >
				</td>
				<td><cf_get_lang no='243.KDV li Tutar'></td>
				<td><cfinput name="expense_tax" type="text" style="width:102px;" onKeyup="return(FormatCurrency(this,event));">
					<select name="expense_money" id="expense_money" style="width:65px;">
						<cfoutput query="get_money">
							<option value="#money#">#money#</option>
						</cfoutput>
					</select></td>
			</tr>
			<tr>
				<td><cf_get_lang no='397.Kaza Tipi'> *</td>
				<td><select name="accident_id" id="accident_id" style="width:170px;">
						<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
						<cfoutput query="get_accidents">
							<option value="#accident_id#">#accident_name#</option>
						</cfoutput>
					</select>
				</td>
				<td><cf_get_lang_main no='217.Açıklama'></td>
				<td rowspan="4" valign="top"><textarea name="description" id="textarea2" style="width:170px;height:90px;"></textarea></td>
			</tr>
			<tr>
				<td><cf_get_lang no='395.Kaza Tarihi'> *</td><cfsavecontent variable="message17"><cf_get_lang_main no='326.Başlangıç tarihi girmelisiniz'>!</cfsavecontent>
				<td><cfinput type="text" name="accident_date" maxlength="10" validate="#validate_style#"style="width:170px" required="yes" message="#message17#">
					<cf_wrk_date_image date_field="accident_date"></td>
				<td></td>
			</tr>
			<tr>
				<td><cf_get_lang no='403.Evrak No'></td>
				<td><input name="document_num" type="text" id="document_num4" style="width:170px;" ></td>
				<td></td>
			</tr>
			<tr>
				<td><cf_get_lang no='398.Kusur Oranı'></td>
				<td><input name="fault_ratio" type="text" id="fault_ratio4" style="width:170px;"></td>
				<td></td>
			</tr>
		</table>
		<cf_popup_box_footer>
			<cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()' is_cancel='0'>
		</cf_popup_box_footer>
	</cfform>
</cf_popup_box>
<script type="text/javascript">
	function kontrol()
	{
		document.add_kaza.expense_tax.value = filterNum(add_kaza.expense_tax.value);
		x = document.add_kaza.accident_id.selectedIndex;
		if (document.add_kaza.accident_id[x].value == "")
		{ 
			alert ("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang no='397.Kaza Tipi'>");
			return false;
		}
		return true;
	}
</script>
