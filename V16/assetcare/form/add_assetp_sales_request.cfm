<cfinclude template="../query/get_branchs_deps.cfm">
<cfinclude template="../query/get_usage_purpose.cfm">
<cfquery name="GET_ASSETP_CATS" datasource="#DSN#">
	SELECT ASSETP_CATID, ASSETP_CAT FROM ASSET_P_CAT WHERE MOTORIZED_VEHICLE = 1 ORDER BY ASSETP_CAT
</cfquery>
<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td valign="top">
      <table width="100%" cellpadding="0" cellspacing="0" border="0" align="center" height="100%">
        <tr class="color-border">
          <td>
            <table width="100%" cellpadding="2" cellspacing="1" border="0" height="100%">
              <tr class="color-list" valign="middle">
                <td height="35" class="headbold"><cf_get_lang no='161.Satış Talebi'></td>
              </tr>
              <tr>
                <td class="color-row" valign="top">
                  <cfform name="add_assetp_sales_request" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_add_assetp_sales_request">
                    <table>
                      <tr>
                        <td width="75px"><cf_get_lang_main no='74.Kategori'>*</td>
                        <td><select name="cat_id" id="cat_id" style="width:150px;">
                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                            <cfoutput query="get_assetp_cats">
                              <option value="#assetp_catid#">#assetp_cat#
                            </cfoutput>
                          </select></td>
                        <td width="50px"><cf_get_lang_main no='344.Durum'></td>
                        <td><select name="status" id="status" style="width:150px;"></select></td>
                      </tr>
                      <tr>
                        <td><cf_get_lang_main no='160.Departman'> *</td>
                        <td><input type="hidden" name="department_id" id="department_id" value="">
                          	<cfinput type="text" name="department" value="" required="yes" message="Departman Seçiniz !" readonly style="width:150px;">
                          	<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=add_assetp_sales_request.department_id&field_name=add_assetp_sales_request.department','list');">
						  	<img src="/images/plus_thin.gif"  alt="<cf_get_lang_main no='160.Departman'>" align="absmiddle" border="0"></td>
                        <td><cf_get_lang no='123.Talep Tarihi'> *</td>
                        <td><cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='330.Tarih'> !</cfsavecontent>
                          	<cfinput type="text" name="request_date" value="#dateformat(now(),dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" style="width:150px;" required="yes">
                          	<cf_wrk_date_image date_field="request_date"></td>
                      </tr>
                      <tr>
                        <td><cf_get_lang no='82.Talep Eden'> *</td>
                        <td><input type="hidden" name="employee_id" id="employee_id" value="">
                        	<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang no='82.Talep Eden'></cfsavecontent>
                          	<cfinput type="text" name="employee" value="" required="yes" message="#message#" readonly style="width:150px;">
                          	<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_assetp_sales_request.employee_id&field_name=add_assetp_sales_request.employee&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='82.Talep Eden'>" align="absmiddle" border="0"></a></td>
                        <td></td>
                        <td></td>
                      </tr>
                      <tr>
                        <td colspan="4"><cf_get_lang_main no='217.Açıklama'></td>
                      </tr>
                      <tr>
                        <td colspan="4"><textarea name="detail" id="detail" style="width:490px;height:60px;"></textarea>
                        </td>
                      </tr>
                      <tr>
                        <td colspan="4"><cfinclude template="../form/add_vehicle_sales_row.cfm"></td>
                      </tr>
                      <tr>
                        <td colspan="3"></td>
                        <td colspan="4" style="text-align:right;"><cf_workcube_buttons is_upd='0' add_function='kontrol()'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                      </tr>
                    </table>
                  </cfform>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
  </tr>
  </td>
</table>

<script type="text/javascript">
	function kontrol()
	{
		x = document.add_assetp_sales_request.cat_id.selectedIndex;
		if (document.add_assetp_sales_request.cat_id[x].value == "")
		{ 
			alert ("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='74.Kategori'>");
			return false;
		}		
		return true;
	}
</script>
