<cfquery name="GET_KM" datasource="#dsn#">
	SELECT 
		ASSET_P_KM_CONTROL.*, 
		ASSET_P.ASSETP 
	FROM 
		ASSET_P_KM_CONTROL, 
		ASSET_P 
	WHERE 
		ASSET_P_KM_CONTROL.ASSETP_ID = ASSET_P.ASSETP_ID AND 
		KM_CONTROL_ID = #attributes.km_control_id#
</cfquery>
<cfquery name="GET_PURPOSES" datasource="#dsn#">
	SELECT USAGE_PURPOSE,USAGE_PURPOSE_ID FROM SETUP_USAGE_PURPOSE ORDER BY USAGE_PURPOSE ASC
</cfquery>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
  <td class="color-border">
    <table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
      <tr class="color-list">
        <td class="headbold" height="35"><cf_get_lang no='374.KM Güncelle'></td>
      </tr>
      <tr class="color-row">
      <td valign="top">
        <table border="0">
          <cfform name="add_kaza" action="#request.self#?fuseaction=assetcare.emptypopup_upd_km_control" method="post">
            <input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#get_km.assetp_id#</cfoutput>">
            <input name="is_detail" id="is_detail" type="hidden" value="1">
            <input  name="km_control_id" id="km_control_id" type="hidden" value="<cfoutput>#get_km.km_control_id#</cfoutput>">
            <tr>
              <td><cf_get_lang_main no='1656.Plaka'> *</td>
              <td width="180"><cfquery name="GET_ASSETP" datasource="#dsn#">
                SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = #get_km.assetp_id#
                </cfquery><cfoutput>#get_assetp.assetp#</cfoutput></td>
              <td><cf_get_lang no='219.Son KM'></td>
              <td><cfinput name="last_km" type="text" value="#tlformat(get_km.km_finish)#"style="width:150px;" onKeyup="return(FormatCurrency(this,event));"></td>
            </tr>
            <tr>
              <td><cf_get_lang_main no='132.Sorumlu'> *</td>
              <td><input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_km.employee_id#</cfoutput>">
                <cfsavecontent variable="message2"><cf_get_lang no='361.Lütfen Sorumlu Seçiniz'>!</cfsavecontent>
                <cfinput type="Text" name="employee_name" value="#get_emp_info(get_km.employee_id,0,0)#" readonly style="width:150px;" required="yes" message="#message2#">
                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_kaza.employee_id&field_name=add_kaza.employee_name&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='132.Sorumlu'>" align="absmiddle" border="0"></a></td>
              <td><cf_get_lang_main no='57.Son Kayıt'></td>
              <td><cfinput name="pre_record" type="text" value="#dateformat(get_km.record_date,dateformat_style)#" readonly style="width:150px;">
			  <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_assetp.position_code&field_name=add_assetp.position</cfoutput>','list')"></a></td>
            <tr>
              <td><cf_get_lang no='30.Kullanım Amacı'></td>
              <td>
              	<select name="usage_purpose_id" id="usage_purpose_id" style="width:150px;">
                  <option value=""><cf_get_lang no='30.Kullanım Amacı'></option>
                  <cfoutput query="get_purposes">
                    <option value="#usage_purpose_id#" <cfif usage_purpose_id eq get_km.usage_purpose_id>selected</cfif>>#usage_purpose#</option>
                  </cfoutput>
                </select>
              </td>
              <td><cf_get_lang no='719.Son Kull'></td>
              <td><input name="pre_driver_id" id="pre_driver_id" type="hidden" value="<cfoutput>#get_km.pre_employee_id#</cfoutput>">
                <cfinput type="text" name="pre_driver" value="#get_emp_info(get_km.employee_id,0,0)#"style="width:150px;" readonly></td>
            </tr>
            <tr>
              <td><cf_get_lang_main no='641.Başlangıç Tarihi'></td>
              <td>
              	<cfsavecontent variable="message"><cf_get_lang_main no='370.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
              	<cfinput type="text" name="start_date" value="#dateformat(get_km.start_date,dateformat_style)#"style="width:150px;" validate="#validate_style#" message="#message#!">
                <cf_wrk_date_image date_field="start_date"></td>
              <td><cf_get_lang no='357.Önceki KM'></td>
              <td><cfinput name="pre_km" type="text" value="#tlformat(get_km.km_start)#" style="width:150px;" readonly>
              </td>
            </tr>
            <tr>
              <td><cf_get_lang_main no='288.Bitiş Tarihi'></td>
              <td>
              	<cfsavecontent variable="message"><cf_get_lang_main no='370.Tarih Değerini Kontrol Ediniz'></cfsavecontent>
                <cfinput type="text" name="finish_date" value="#dateformat(get_km.finish_date,dateformat_style)#"style="width:150px;" validate="#validate_style#" message="#message#">
                <cf_wrk_date_image date_field="finish_date"></td>
              <td>&nbsp;</td>
              <td><cf_workcube_buttons is_upd='1' add_function="clear_kms()" is_delete='0' is_cancel='0'></td>
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
	function clear_kms()
		{
			document.add_kaza.pre_km.value = filterNum(add_kaza.pre_km.value);
			document.add_kaza.last_km.value = filterNum(add_kaza.last_km.value);
			return (document.add_kaza.start_date,document.add_kaza.finish_date,"<cf_get_lang_main no='394.Tarih Aralığını Kontrol Ediniz'>!");
		}
</script>

