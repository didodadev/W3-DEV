<cfquery name="GET_BRANCHS_DEPS" datasource="#dsn#">
	SELECT 
		DEPARTMENT.DEPARTMENT_ID, 
		DEPARTMENT.DEPARTMENT_HEAD,
		BRANCH.BRANCH_NAME
	FROM 
		DEPARTMENT,
		BRANCH
	WHERE
		BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
	ORDER BY 
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD
</cfquery>
<cfquery name="GET_EXPENSE_ITEMS" datasource="#dsn2#">
	SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE IS_EXPENSE = 1 ORDER BY EXPENSE_ITEM_NAME
</cfquery>
<cfinclude template="../query/get_money.cfm">
<cf_popup_box title="#getLang('assetcare',419)#">
	<cfform name="add_ceza" action="#request.self#?fuseaction=assetcare.emptypopup_add_punishment" method="post">
	<input type="hidden" name="is_detail" id="is_detail" value="1">
	<input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#attributes.assetp_id#</cfoutput>">
		<table>
			<tr> 
				<td><cf_get_lang_main no='1656.Plaka'> *</td>
				<td><cfquery name="GET_ASSETP" datasource="#dsn#">
						SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = #attributes.assetp_id# 
					</cfquery> <cfoutput>#get_assetp.assetp#</cfoutput></td>
				<td><cf_get_lang no='414.Ceza Tipi'></td>
				<td><input type="text" name="punishment_type" id="punishment_type" style="width:150px;" maxlength="100"> 
				</td>
			</tr>
			<tr> 
				<td><cf_get_lang_main no='132.Sorumlu'> *</td>
				<cfsavecontent variable="alert"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='132.Sorumlu !'></cfsavecontent>
				<td><input type="hidden" name="driver_id" id="driver_id" value=""> <cfinput type="text" name="driver_name" style="width:150;" readonly required="yes" message="#alert#"> 
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id2=add_ceza.driver_id&field_name=add_ceza.driver_name&select_list=1','list');"> 
				<img src="/images/plus_thin.gif" align="absmiddle" alt="<cf_get_lang_main no='132.Sorumlu'>" border="0"></a></td>
				<td><cf_get_lang no='416.Ceza Tarihi'></td>
				<cfsavecontent variable="alert"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no ='416.ceza tarihi'>-<cf_get_lang_main no='786.sayısal'></cfsavecontent>
				<td><cfinput type="text" name="punishment_date" style="width:150px;" maxlength="10" validate="#validate_style#" message="#alert#"> 
					<cf_wrk_date_image date_field="punishment_date"> 
				</td>
			</tr>
			<tr> 
				<td><cf_get_lang_main no='160.Departman'></td>
				<td><select name="department_id" id="department_id" style="width:150px;">
					<option value=""><cf_get_lang_main no='160.Departman'></option>
					<cfoutput query="get_branchs_deps"> 
						<option value="#department_id#">#branch_name# / #department_head#</option>
					</cfoutput> </select></td>
				<td><cf_get_lang no='185.Son Ödeme Tarihi'></td>
				<cfsavecontent variable="alert"><cf_get_lang no ='185.Son Ödeme Tarihi Giriniz'></cfsavecontent>
				<td><cfinput type="text" name="last_payment_date" style="width:150px;" validate="#validate_style#" message="#alert#" maxlength="10"> 
				<cf_wrk_date_image date_field="last_payment_date"> 
				</td>
			</tr>
			<tr> 
				<td><cf_get_lang_main no='1139.Gider Kalemi'></td>
				<td><select name="expense_id" id="expense_id" style="width:150px;">
						<option value=""><cf_get_lang_main no='1139.Gider Kalemi'></option>
						<cfoutput query="get_expense_items"> 
							<option value="#expense_item_id#">#expense_item_name#</option>
						</cfoutput>
					</select>
				</td>
				<td><cf_get_lang no='423.Ödenen Tarih'></td>
				<cfsavecontent variable="alert"><cf_get_lang no ='723.Ödenen Tarih Formatı'></cfsavecontent>
				<td><cfinput type="text" name="paid_date" style="width:150px;" validate="#validate_style#" message="#alert#"> 
				<cf_wrk_date_image date_field="paid_date"> 
				</td>
			</tr>
			<tr> 
				<td><cf_get_lang no='415.Makbuz No'></td>
				<td><input type="text" name="receipt_id" id="receipt_id" style="width:150px;" maxlength="100"></td>
				<td><cf_get_lang no='417.Ceza Tutarı'></td>
				<cfsavecontent variable="alert"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no ='449.ödenen miktar'>-<cf_get_lang_main no='786.sayısal'></cfsavecontent>
				<td><cfinput type="text" name="punishment_amount" style="width:90px;" message="#alert#" onKeyup="return(FormatCurrency(this,event));"> 
					<select name="punishment_currency" id="punishment_currency" style="width:57px;">
						<cfoutput query="get_money"> 
							<option value="#money#">#money#</option>
						</cfoutput>
					</select>
				</td>
			</tr>
			<tr> 
				<td><cf_get_lang no='448.Ödeme Makbuz No'></td>
				<td><input type="text" name="payment_receipt_no" id="payment_receipt_no" style="width:150px;" maxlength="100"></td>
				<td><cf_get_lang no='449.Ödenen Miktar'></td>
				<cfsavecontent variable="alert"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang no ='449.ödenen miktar'>-<cf_get_lang_main no='786.sayısal'></cfsavecontent>
				<td><cfinput type="text" name="paid_amount" style="width:90px;" message="#alert#" onKeyup="return(FormatCurrency(this,event));"> 
				<select name="paid_currency" id="paid_currency" style="width:57px;">
				<cfoutput query="get_money"> 
				<option value="#money#">#money#</option>
				</cfoutput> </select></td>
			</tr>
			<tr> 
				<td><cf_get_lang no='424.Ödeme Yapan'></td>
				<td> <input type="radio" name="payer" id="payer" value="1" checked>
				<cf_get_lang_main no='162.Firma '>
				<input type="radio" name="payer" id="payer" value="2">
				<cf_get_lang_main no='2034.Kişi'></td>
				<td><cf_get_lang no='425.Ceza Kayıtlı Belge'></td>
				<td><input type="radio" name="punished_license" id="punished_license" value="1" checked>
				<cf_get_lang no='432.Ruhsat'> 
				<input type="radio" name="punished_license" id="punished_license" value="2">
				<cf_get_lang no='428.Ehliyet'> </td>
			</tr>
		</table>
		<cf_popup_box_footer><cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()' is_cancel='0'></cf_popup_box_footer>
	</cfform>
</cf_popup_box>
<script type="text/javascript">
	function kontrol()
	{
		document.add_ceza.punishment_amount.value = filterNum(document.add_ceza.punishment_amount.value);
		document.add_ceza.paid_amount.value = filterNum(document.add_ceza.paid_amount.value);
	}
</script>
