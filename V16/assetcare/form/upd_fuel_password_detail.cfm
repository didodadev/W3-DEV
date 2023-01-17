<cfinclude template="../query/get_fuel_password.cfm">
<cf_popup_box title="#getLang('assetcare',469)#">
<cfform name="upd_fuel_password" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_upd_fuel_password">
<input type="hidden" name="password_id" id="password_id" value="<cfoutput>#attributes.password_id#</cfoutput>">
<input type="hidden" name="is_detail" id="is_detail" value="1">
	<cfoutput query="get_fuel_password" maxrows="1" startrow="1">
		<table>
			<tr>
				<td><cf_get_lang_main no='41.Şube'> *</td>
				<td width="210"><input type="hidden" name="branch_id" id="branch_id" value="#get_fuel_password.branch_id#">
                <cfsavecontent variable="message1"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no='41.Şube'></cfsavecontent>
				<cfinput type="text" name="branch" value="#branch_name#" required="yes" message="#message1#" readonly style="width:170px;">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=upd_fuel_password.department_id&field_name=upd_fuel_password.department','list');"> <img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='41.Şube'>" align="absmiddle" border="0"></a></td>
				<td><cf_get_lang_main no='140.Şifre '>1</td>
				<td><cfinput type="text" name="password1" value="#password1#" maxlength="20" style="width:150px;"></td>
			</tr>
			<tr>
				<td><cf_get_lang no='470.Akaryakıt Şirketi'> *</td>
				<td><input type="hidden" name="company_id" id="company_id" value="#company_id#">
                <cfsavecontent variable="message2"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang no='470.Akaryakıt Şirketi'></cfsavecontent>
				<cfinput type="text" name="company_name" value="#fullname#" readonly required="yes" message="#message2#" style="width:170px">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=upd_fuel_password.company_name&field_comp_id=upd_fuel_password.company_id&select_list=2,3','list');"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='470.Akaryakıt Şirketi'> " border="0" align="absmiddle"></a></td>
				<td><cf_get_lang_main no='140.Şifre'> 2</td>
				<td><cfinput type="text" name="password2" value="#password2#" maxlength="20" message="" style="width:150px;"></td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='1110.Kullanıcı Kodu'></td>
				<td><cfinput type="text" name="user_code" value="#user_code#" maxlength="20" style="width:170px;"></td>
				<td><cf_get_lang_main no='243.Başlama Tarihi'></td>
				<cfsavecontent variable="alert"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no='243.Başlama Tarihi'></cfsavecontent>
				<td><cfinput name="start_date" type="text" value="#dateformat(start_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#alert#" style="width:150px;">
					<cf_wrk_date_image date_field="start_date">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='70.Asama'></td>
				<td><input name="status" id="status" type="checkbox" value="1" <cfif get_fuel_password.status>checked</cfif>></td>
				<td><cf_get_lang_main no='288.Bitiş Tarihi'></td>
				<cfsavecontent variable="alert"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no='288.Bitiş Tarihi'></cfsavecontent>
				<td><cfinput name="finish_date" type="text" value="#dateformat(finish_date,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#alert#" style="width:150px;">
				<cf_wrk_date_image date_field="finish_date"></td>
			</tr>
		</table>
		<cf_popup_box_footer><cf_workcube_buttons type_format="1" is_upd='1' is_delete='0' add_function='kontrol()'></cf_popup_box_footer>
	</cfoutput>
</cfform>
</cf_popup_box>
<script type="text/javascript">
	function kontrol()
	{
		if(!date_check(document.upd_fuel_password.start_date,document.upd_fuel_password.finish_date,"<cf_get_lang_main no='394.Tarih Aralığını Kontrol Ediniz'>!"))
		{
			return false;
		}
	}
</script>
