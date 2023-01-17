<cfquery name="get_purposes" datasource="#dsn#">
	SELECT USAGE_PURPOSE,USAGE_PURPOSE_ID FROM SETUP_USAGE_PURPOSE ORDER BY USAGE_PURPOSE ASC
</cfquery>
<cfinclude template="../query/get_assetp_cats.cfm">
<cfquery name="get_others" datasource="#dsn#">
SELECT KM_CONTROL_ID,KM_FINISH,RECORD_DATE, EMPLOYEE_ID 
FROM ASSET_P_KM_CONTROL 
WHERE ASSETP_ID = #attributes.assetp_id# ORDER BY KM_CONTROL_ID DESC
</cfquery> 
<table cellspacing="0" cellpadding="0" border="0" height="100%" width="100%">
<tr class="color-border">
<td valign="middle">
  <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
	<tr class="color-list" valign="middle">
	  <td height="35">
		<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
		  <tr>
			<td class="headbold"><cf_get_lang no ='718.KM Giriş'></td>
		  </tr>
		</table>
	  </td>
	</tr>
	<tr>
	<td class="color-row" valign="top">
			<cfform  method="post" name="add_kaza" action="#request.self#?fuseaction=assetcare.emptypopup_add_km_control">
		    <table border="0">
              <tr>
                  <td><cf_get_lang_main no='1656.Plaka'> *</td>
              <td width="180"><cfquery name="GET_ASSETP" datasource="#dsn#">
                SELECT ASSETP FROM ASSET_P WHERE ASSETP_ID = #attributes.assetp_id#
                </cfquery><cfoutput>#get_assetp.assetp#</cfoutput>
				</td>
				<td><cf_get_lang no ='219.Son KM'></td>
                <td width="170">
				<cfinput name="last_km" type="text" style="width:150px;" onKeyup="return(FormatCurrency(this,event));">
				  </td>
              </tr>
              <tr>
                <td><cf_get_lang_main no='132.Sorumlu'>&nbsp;*</td>
                <td><input type="hidden" name="employee_id"  id="employee_id" value=""><input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#attributes.assetp_id#</cfoutput>">
                  <cfsavecontent variable="message2"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='132.Sorumlu'>!</cfsavecontent>
                  <cfinput type="Text" name="employee_name" value="" readonly style="width:150px;" required="yes" message="#message2#">
                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_kaza.employee_id&field_name=add_kaza.employee_name&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='132.Sorumlu'>" align="absmiddle" border="0"></a>
				</td>
                <td><cf_get_lang_main no ='57.Son Kayıt'></td>
				<td><cfinput name="pre_record" type="text" value="#DateFormat(get_others.record_date,dateformat_style)#" readonly="yes" style="width:150px;"></td>
              </tr>
              <tr>
                <td><cf_get_lang no ='30.Kullanım Amacı'></td>
                <td><select name="usage_purpose_id" id="usage_purpose_id" style="width:150px;">
                    <option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
                    <cfoutput query="get_purposes">
                      <option value="#usage_purpose_id#">#usage_purpose#</option>
                    </cfoutput>
                  </select>
                </td>
                <td><cf_get_lang no ='719.Son Kullanan'></td>
                <td><cfinput name="pre_driver" type="text" style="width:150px;" readonly value="#get_emp_info(get_others.employee_id,0,0)#">
                  <input type="hidden" name="pre_driver_id" id="pre_driver_id" value="<cfoutput>#get_others.employee_id#</cfoutput>">
                  <input name="is_detail" id="is_detail" type="hidden" value="1"></td>
			
			  </tr>
			  <tr>
			  <td><cf_get_lang_main no='641.Başlangıç Tarihi'></td>
			  <td>
			  <cfsavecontent variable="alert"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no ='330.Tarih'></cfsavecontent>				
			  <cfinput name="start_date" type="text" message="#alert#" validate="#validate_style#" style="width:150px;">
                <cf_wrk_date_image date_field="start_date">
				</td>
			  <td><cf_get_lang no ='357.Önceki KM'></td>
			  <td><cfinput name="pre_km" type="text" style="width:150px;" readonly value="#tlformat(get_others.km_finish)#"></td>
			  </tr>
              <tr>
                <td height="21"><cf_get_lang_main no ='288.Bitiş Tarihi'></td>
                <td>
					<cfsavecontent variable="alert"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no ='330.Tarih'></cfsavecontent>				
				  <cfinput name="finish_date" type="text" style="width:150px;" validate="#validate_style#" message="#alert#">
				  <cf_wrk_date_image date_field="finish_date"></td>
                <td></td>
				<td><cf_workcube_buttons is_upd='0' add_function='kontrol()' is_cancel='0'></td>
              </tr>
          </table>
		  </cfform></td>
	</tr>
		</table>
	  </td>
	</tr>
</table>
<script type="text/javascript">
	function kontrol()
	{
			document.add_kaza.pre_km.value = filterNum(add_kaza.pre_km.value);
			document.add_kaza.last_km.value = filterNum(add_kaza.last_km.value);
			return (document.add_kaza.start_date,document.add_kaza.finish_date,"<cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no ='330.Tarih'>!");
	}
</script>
