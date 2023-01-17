<cfparam name="employee_id" default="">
<cfparam name="is_detail" default="">
<cfinclude template="../query/get_km_upd.cfm">
<cfsavecontent variable="right">
	<a href="javascript://" onclick="km_kayit();"><img src="/images/plus1.gif" align="absmiddle" alt="<cf_get_lang no='374.Km Güncelleme'>" title="<cf_get_lang_main no='170.Ekle'>" border="0"></a>
</cfsavecontent>
<cf_popup_box title="#getLang('assetcare',374)#" right_images="#right#">
<form name="upd_km" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.emptypopup_upd_km&km_control_id=<cfoutput>#attributes.km_control_id#</cfoutput>" onSubmit="return unformat_fields();">
<input type="hidden" name="is_detail" id="is_detail" value="1">
	<table>
		<tr>
			<td width="60"><cf_get_lang_main no='1656.Plaka'> *</td>
			<td width="200">
				<input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#get_km_upd.assetp_id#</cfoutput>">
				<input name="assetp_name" id="assetp_name" type="text" readonly value="<cfoutput>#get_km_upd.assetp#</cfoutput>" style="width:150px;">
			</td>
			<td width="80"><cf_get_lang no='356.Önceki KM Tarihi'></td>
			<td width="140"><input name="start_date" id="start_date" type="text" value="<cfoutput>#dateformat(get_km_upd.start_date,dateformat_style)#</cfoutput>" readonly style="width:150px;"></td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='132.Sorumlu'> *</td>
			<td>
				<input name="employee_id" id="employee_id" type="hidden" value="<cfoutput>#get_km_upd.employee_id#</cfoutput>">
				<input type="text" name="employee_name" id="employee_name" value="<cfoutput>#get_emp_info(get_km_upd.employee_id,0,0)#</cfoutput>" style="width:150px;">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=upd_km.employee_id&field_name=upd_km.employee_name&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='132.Sorumlu'>" align="absmiddle" border="0"></a>
			</td>
			<td><cf_get_lang no='357.Önceki KM'></td>
			<td>
				<input name="pre_km" id="pre_km" type="text" value="<cfoutput>#tlformat(get_km_upd.km_start,0)#</cfoutput>" readonly style="width:150px;">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_assetp.position_code&field_name=add_assetp.position</cfoutput>','list')"></a>
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='41.Şube'> *</td>
			<td>
				<input type="hidden" name="department_id" id="department_id" value="<cfoutput>#get_km_upd.department_id#</cfoutput>">
				<input type="text" name="department" id="department" readonly value="<cfoutput>#get_km_upd.branch_name# - #get_km_upd.department_head#</cfoutput>" style="width:150px;">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=upd_km.department_id&field_name=upd_km.department','list');"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='41.Şube'>" align="absmiddle" border="0"></a>
			</td>
			<td><cf_get_lang no='359.Son KM Tarihi'></td>
			<td>
				<input type="text" name="finish_date" id="finish_date" style="width:150px;" value="<cfoutput>#dateformat(get_km_upd.finish_date,dateformat_style)#</cfoutput>">
				<cf_wrk_date_image date_field="finish_date">
			</td>
		</tr>
		<tr>
			<td><cf_get_lang_main no='217.Açıklama'></td>
			<td><input type="text" name="detail" id="detail" style="width:150px" maxlength="200" value="<cfoutput>#get_km_upd.detail#</cfoutput>"></td>
			<td><cf_get_lang no='219.Son KM'></td>
			<td><input type="text" name="last_km" id="last_km" value="<cfoutput>#tlformat(get_km_upd.km_finish,0)#</cfoutput>" onKeyup="return(FormatCurrency(this,event,0));" style="width:150px;" ></td>
		</tr>
		<tr>
			<td><cf_get_lang no='358.Mesai Dışı'></td>
			<td><input name="is_offtime" id="is_offtime" type="checkbox" value="1" <cfif get_km_upd.is_offtime eq 1>checked</cfif>></td>
		</tr>
	</table>
	<cf_popup_box_footer><cf_workcube_buttons type_format="1" is_upd='1' is_cancel='0' is_reset='0' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=assetcare.emptypopup_del_km&km_control_id=#attributes.km_control_id#&plaka=#get_km_upd.assetp#&is_detail=1'></cf_popup_box_footer>
</form>
</cf_popup_box>
<script type="text/javascript">
function unformat_fields()
{
	document.upd_km.pre_km.value = filterNum(document.upd_km.pre_km.value);
	document.upd_km.last_km.value = filterNum(document.upd_km.last_km.value);
}
function km_kayit()
{
	window.opener.parent.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.form_add_km';
	window.close();
}
function kontrol()
{	
	if(document.upd_km.assetp_name.value == "")
	{
		alert("Plaka Girmelisiniz!");
		return false;
	}
	
	if(document.upd_km.employee_name.value == "")
	{
		alert("Sorumlu Girmelisiniz!");
		return false;
	}
	
	if(document.upd_km.department.value == "")
	{
		alert("Şube Girmelisiniz!");
		return false;
	}
	
	if(!CheckEurodate(document.upd_km.start_date.value,'Başlangıç Tarihi'))
	{
		return false;
	}
	
	if(!CheckEurodate(document.upd_km.finish_date.value,'Bitiş Tarihi'))
	{
		return false;
	}

	if(!date_check(document.upd_km.start_date,document.upd_km.finish_date,"Tarih Aralığını Kontrol Ediniz!"))
	{	
		return false;
	}
	
	a = parseInt(filterNum(document.upd_km.pre_km.value));
	b = parseInt(filterNum(document.upd_km.last_km.value));
	
	if(a >= b)
	{
		alert("Km Aralığını Kontrol Ediniz!");
		return false;
	}
	return true;
}
</script>
