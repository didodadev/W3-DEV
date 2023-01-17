<cfquery name="GET_SERVICE_SUB_STATUS" datasource="#DSN3#">
	SELECT
		SERVICE_SUBSTATUS_ID,
		SERVICE_SUBSTATUS
	FROM
		SERVICE_SUBSTATUS
</cfquery>
<cfquery name="GET_SERVICE_CARE_CAT" datasource="#DSN3#">
	SELECT
		SERVICE_CARECAT_ID,
		SERVICE_CARE
	FROM
		SERVICE_CARE_CAT
</cfquery>
<cf_popup_box title="#getLang('service',76)#">
	<cfform name="service_contract" action="#request.self#?fuseaction=service.emptypopup_add_service_care_contract" method="post" enctype="multipart/form-data">
		<table>
			<td>&nbsp;</td>
			<td><cf_get_lang_main no='68.Başlık'>*</td>
			<td><cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no='68.Başlık'></cfsavecontent>
				<cfinput type="text" name="contract_head" id="contract_head" style="width:150px;" maxlength="100" required="yes" message="#message#">
			</td>
			<td style="width:100px;"><cf_get_lang no='118.Destek Belgesi'></td>
			<td style="vertical-align:top"><input type="file" name="document" id="document" style="width:150px;">
			<tr>
				<td></td>
				<td style="width:100px;"><cf_get_lang_main no='245.Ürün'> *</td>
				<td style="width:200px;">
					<!--- <cf_wrk_products form_name = 'service_contract' product_name='product_name' product_id='product_id'> --->
					<input type="hidden" name="product_id" id="product_id" value="">
					<cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no='245.Ürün'></cfsavecontent>
					<cfinput type="text" name="product_name" id="product_name" style="width:150px;" value="" required="yes" message="#message#" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','','3','200');" autocomplete="off">
					<cfif get_module_user(47)>
					  <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=service_contract.product_id&field_name=service_contract.product_name','list');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
					</cfif>
				</td>
				<td><cf_get_lang no='78.Bakım tipi'></td>
				<td>
					<select name="service_care" id="service_care" style="width:150px;">
						<option value=""><cf_get_lang_main no='322.Seçiniz'>   
						<cfoutput query="get_service_care_cat">
							<option value="#service_carecat_id#">#service_care# 
						</cfoutput>
				  </select>
			   </td>
			</tr>
			<tr>
				<td height="26"></td>
				<td><cf_get_lang_main no='225.Seri No'>*</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no='225.Seri No'></cfsavecontent>
					<cfinput type="text" style="width:150px;" name="serial_no" maxlength="100" required="yes" message="#message#">
				</td>
				<td><cf_get_lang_main no='1561.Alt Aşama'></td>
				<td>
					<select name="service_substatus" id="service_substatus" style="width:150px;">
						<option value=""><cf_get_lang_main no='322.Seçiniz'>   
						<cfoutput query="get_service_sub_status">
							<option value="#service_substatus_id#">#service_substatus#
						</cfoutput>
					</select>
				</td>
			</tr>
			<tr>
				<td></td>
				<td><cf_get_lang no='115.Servis Firması'></td>
				<td>
					<input type="hidden" name="service_member_id" id="service_member_id" value="">
					<input type="hidden" name="service_member_type" id="service_member_type" value="">
					<input type="text" name="service_company" id="service_company" style="width:150px;" value="" readonly>
					<cfif get_module_user(47)>
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_id=service_contract.service_member_id&field_comp_name=service_contract.service_company&field_name=service_contract.service_member_name&field_type=service_contract.service_member_type&select_list=2,3,5,6','list');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
					</cfif>
				</td>
				<td rowspan="4" valign="top"><cf_get_lang_main no ='217.Açıklama'></td>
				<td rowspan="4" valign="top"><textarea style="width:150px;height:90" name="detail" id="detail"></textarea></td>
			</tr>
			<tr>
				<td></td>
				<td><cf_get_lang no='116.Servis Yetkili'></td>
				<td>
					<cfinput type="Text" name="service_member_name" style="width:150px;" value="">
				</td>
			</tr>
			<tr>
				<td></td>
				<td><cf_get_lang no='114.Servis Çalışan'> 1</td>
				<td>
					<input type="hidden" name="employee_id" id="employee_id">
					<input type="text" name="employee" id="employee" value="" style="width:150px;" readonly>
					<cfif get_module_user(47)>
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=service_contract.employee_id&field_name=service_contract.employee&select_list=1','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
					</cfif>
				</td>
			</tr>
			<tr>
				<td></td>
				<td><cf_get_lang no='114.Servis Çalışan'> 2</td>
				<td>
					<input type="hidden" name="employee_id2" id="employee_id2">
					<input type="text" name="employee2" id="employee2" value="" style="width:150px;" readonly>
					<cfif get_module_user(47)>
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=service_contract.employee_id2&field_name=service_contract.employee2&select_list=1','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
					</cfif>
				</td>
			</tr>
			<tr>
				<td></td>
				<td><cf_get_lang no='43.Bakım Tarihi'> *</td>
				<td>
					<cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang no='43.Bakım Tarihi'></cfsavecontent>
					<cfinput type="text" name="service_date" validate="#validate_style#" maxlength="10" style="width:150px;" message="#message#" required="yes">
					<cf_wrk_date_image date_field="service_date">
				</td>
			</tr>
		</table>
		<cf_popup_box_footer><cf_workcube_buttons is_upd='0'></cf_popup_box_footer>
	</cfform>
</cf_popup_box>

