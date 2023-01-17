<cfquery name="GET_KM" datasource="#DSN#" maxrows="1">
	SELECT KM_FINISH,FINISH_DATE,KM_CONTROL_ID FROM ASSET_P_KM_CONTROL WHERE ASSETP_ID = #url.assetp_id# ORDER BY KM_CONTROL_ID DESC
</cfquery>
<cf_popup_box title="#getLang('assetcare',704)#">
	<cfform name="add_km_counter_change" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_add_vehicle_km_counter_change">
	<input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#url.assetp_id#</cfoutput>">		
	<input type="hidden" name="pre_km"  id="pre_km" value="<cfoutput>#get_km.km_finish#</cfoutput>">				  
		<table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td width="100"><cf_get_lang no='356.Önceki KM Tarihi'> *</td>
				<td><cfoutput>#dateformat(get_km.finish_date,dateformat_style)#</cfoutput><input type="hidden" name="start_date" id="start_date" value="<cfoutput>#dateformat(get_km.finish_date,dateformat_style)#</cfoutput>" style="width:100px;" readonly></td>
			</tr>
			<tr>
				<td><cf_get_lang no='359.Son KM Tarihi'> *</td>
				<td>
				<input type="text" name="finish_date" id="finish_date" value="<cfoutput>#dateformat(get_km.finish_date,dateformat_style)#</cfoutput>" style="width:100px;" maxlength="10">
				<cf_wrk_date_image date_field="finish_date" date_form="add_km_counter_change">
				</td>
			</tr>
			<tr>
				<td width="75"><cf_get_lang no='219.Son KM '> *</td>
				<td><input type="text" name="last_km" id="last_km" style="width:100px;" onKeyup="return(FormatCurrency(this,event,0));"></td>
			</tr>
		</table>
		<cf_popup_box_footer><cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'></cf_popup_box_footer>
	</cfform>
</cf_popup_box>
<script type="text/javascript">
function kontrol()
{
	if(document.add_km_counter_change.finish_date.value == "") 
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='359.Son KM Tarihi'>!");
		return false;
	}
	
	if(document.add_km_counter_change.last_km.value == "") 
	{
		alert("Son KM Değerini Girmelisiniz !");
		return false;
	}
	
	if(!date_check(document.add_km_counter_change.start_date,document.add_km_counter_change.finish_date,"<cf_get_lang_main no='394.Tarih Aralığını Kontrol Ediniz'>!"))
		return false;
	
	a = parseInt(filterNum(document.add_km_counter_change.pre_km.value));
	b = parseInt(filterNum(document.add_km_counter_change.last_km.value));
	
	if(a <= b)
	{
		alert("<cf_get_lang no='624.Km Aralığını Kontrol Ediniz'>!");
		return false;
	}
	
	if (!CheckEurodate(document.add_km_counter_change.finish_date.value,"<cf_get_lang_main no='288.Bitiş Tarihi'>"))
	{
		return false;
	}
	
	document.add_km_counter_change.pre_km.value = filterNum(document.add_km_counter_change.pre_km.value);
	document.add_km_counter_change.last_km.value = filterNum(document.add_km_counter_change.last_km.value);
	return true;
}
</script>
