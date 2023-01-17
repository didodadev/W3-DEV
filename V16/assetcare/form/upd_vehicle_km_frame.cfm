<cfinclude template="../query/get_km_update.cfm">
<cfparam name="employee_id" default="">

<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr>
    <td valign="top">
      <table width="100%" height="100%" align="center" cellpadding="2" cellspacing="1" border="0">
        <tr class="color-row">
          <td valign="top" height="100">
            <table border="0">
              <cfform name="upd_km" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_upd_km&km_control_id=#attributes.km_control_id#">
			  <input type="hidden" name="is_detail" id="is_detail" value="0">
                <tr>
				  <td width="60"><cf_get_lang_main no='1656.Plaka'> *</td>
				  <td width="200"><input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#get_km_update.assetp_id#</cfoutput>">
					<cfsavecontent variable="message1"><cf_get_lang no='360.Lütfen Plaka Seçiniz'>!</cfsavecontent>
					<cfinput name="assetp_name" type="text" readonly required="yes" message="#message1#"  value="#get_km_update.assetp#" style="width:150px;">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=upd_km.assetp_id&field_name=upd_km.assetp_name&field_emp_id=upd_km.employee_id&field_emp_name=upd_km.employee_name&field_dep_name2=upd_km.department&field_dep_id2=upd_km.department_id&field_pre_date=upd_km.start_date&field_pre_km=upd_km.pre_km&list_select=2','list');"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='1656.Plaka'>" border="0" align="absmiddle"></a></td>
				  <td width="80"><cf_get_lang no='356.Önceki KM Tarihi'></td>
				  <td width="140"><cfinput name="start_date" type="text" value="#dateformat(get_km_update.start_date,dateformat_style)#" readonly style="width:100px;"></td>
				  <td><cf_get_lang no='359.Son KM Tarihi'></td>
				  <td><cfinput type="text" name="finish_date" style="width:100px;" value="#dateformat(get_km_update.finish_date,dateformat_style)#">
					<cf_wrk_date_image date_field="finish_date"></td>
				</tr>
				<tr>
				  <td><cf_get_lang_main no='132.Sorumlu'> *</td>
				  <td><input name="employee_id" id="employee_id" type="hidden" value="<cfoutput>#get_km_update.employee_id#</cfoutput>">
					<cfsavecontent variable="message2"><cf_get_lang no='361.Lütfen Sorumlu Seçiniz'>!</cfsavecontent>
					<cfinput type="text" name="employee_name" readonly required="yes" message="#message2#" value="#get_emp_info(get_km_update.employee_id,0,0)#" style="width:150px;">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=upd_km.employee_id&field_name=upd_km.employee_name&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif"  alt="<cf_get_lang_main no='132.Sorumlu'>" align="absmiddle" border="0"></a></td>
				  <td><cf_get_lang no='357.Önceki KM'></td>
				  <td><cfinput name="pre_km" type="text" value="#tlformat(get_km_update.km_start)#" readonly style="width:100px;">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_assetp.position_code&field_name=add_assetp.position</cfoutput>','list')"></a></td>
				  <td><cf_get_lang no='219.Son KM'></td>
				  <td><cfinput type="text" name="last_km" value="#tlformat(get_km_update.km_finish)#" onKeyup="return(FormatCurrency(this,event));" style="width:100px;"></td>
				</tr>
				<tr>
				  <td><cf_get_lang_main no='41.Şube'> *</td>
				  <td><input type="hidden" name="department_id" id="department_id" value="<cfoutput>#get_km_update.department_id#</cfoutput>">
                  	<cfsavecontent variable="message"><cf_get_lang_main no='1424.Lutfen Departman Seciniz'></cfsavecontent>
					<cfinput type="text" name="department" readonly required="yes" message="#message#" value="#get_km_update.branch_name# - #get_km_update.department_head#" style="width:150px;">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=upd_km.department_id&field_name=upd_km.department','list');"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='41.Şube'>" align="absmiddle" border="0"></a></td>
				  <td><cf_get_lang no='358.Mesai Dışı'></td>
				  <td><input name="is_offtime" id="is_offtime" type="checkbox" value="1" <cfif get_km_update.is_offtime eq 1>checked</cfif>></td>
				  <td></td>
				  <td><cf_workcube_buttons is_upd='1' is_delete='0' is_reset='0' is_cancel='0' add_function='kontrol()'></td>
				</tr>
             </cfform>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<script type="text/javascript">
	function kontrol()
	{
		if(!date_check(document.upd_km.start_date,document.upd_km.finish_date,"<cf_get_lang_main no='394.Tarih Aralığını Kontrol Ediniz'>!"))
		{	
			return false;
		}
		document.upd_km.pre_km.value = filterNum(document.upd_km.pre_km.value);
		document.upd_km.last_km.value = filterNum(document.upd_km.last_km.value);
		if(parseFloat(document.upd_km.pre_km.value) >= parseFloat(document.upd_km.last_km.value))
		{
			alert("<cf_get_lang no='624.Km Aralığını Kontrol Ediniz'>!");
			return false;
		}
	}
</script>
