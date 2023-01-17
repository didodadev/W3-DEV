<CFQUERY name="get_asset_name" datasource="#DSN#">
	SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = #url.assetp_id#
</CFQUERY>
<cf_popup_box title="#getLang('assetcare',230)#">
<cfform name="km_control" action="#request.self#?fuseaction=assetcare.emptypopup_add_vehicle_km_kontrol&asset_id=#url.assetp_id#" method="post" enctype="multipart/form-data">
	<table>
		<tr>
			<input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#url.assetp_id#</cfoutput>">
			<td><cf_get_lang_main no='1656.Plaka'></td>
			<td><cfinput type="text" style="width:150;" name="assetp" value="#get_asset_name.ASSETP#">
			</td>
		</tr>
		<tr>
			<td width="110"><cf_get_lang_main no='243.Başlama Tarih'></td>
			<td width="185">
			<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='641.Başlangıç Tarihi !'></cfsavecontent>
			<cfinput type="text" name="start_date" validate="#validate_style#" maxlength="10" style="width:150;" message="#message#">
			<cf_wrk_date_image date_field="start_date">  
			</td>
		</tr>
		<tr>
			<td width="100"><cf_get_lang_main no='288.Bitiş Tarih'></td>
			<td width="185">
			<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='288.Bitiş Tarihi !'> !</cfsavecontent>
			<cfinput type="text" name="finish_date" validate="#validate_style#" maxlength="10" style="width:150;" message="#message#">
			<cf_wrk_date_image date_field="finish_date">  
			</td>
		</tr>
		<tr>
			<td><cf_get_lang no='231.Başlama KM'></td>
			<td><cfinput type="text" name="start_km" value="" style="width:150;"></td>
		</tr>
		<tr>
			<td><cf_get_lang no='237.Bitiş KM'></td>
			<td><cfinput type="text" name="finish_km" value="" style="width:150;"></td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='132.Sorumlu'></td>
			<td>
				<input type="hidden" name="EMPLOYEE_ID" id="EMPLOYEE_ID" value="">
				<input type="hidden" name="PARTNER_ID" id="PARTNER_ID" value="">
				<cfinput type="text" name="made_application" style="width:150px;"  value="">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=km_control.EMPLOYEE_ID&field_partner=km_control.PARTNER_ID&field_name=km_control.made_application&select_list=1,2</cfoutput>','list');"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='15.Lider Seç'>" title="<cf_get_lang no='15.Lider Seç'>" align="absmiddle" border="0"></a>						
			</td>
		</tr>
		<tr>
			<td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
			<td><textarea name="detail" id="detail" style="width:150px;height:50px;"></textarea></td>
		</tr>
	</table>
	<cf_popup_box_footer><cf_workcube_buttons type_format="1" is_upd='0'></cf_popup_box_footer>
</cfform>
</cf_popup_box>


