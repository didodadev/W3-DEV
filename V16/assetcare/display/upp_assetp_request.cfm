<cfinclude template="../query/get_assetp_cats.cfm">
<cfinclude template="../query/get_branchs_deps.cfm">
<cfinclude template="../query/get_usage_purpose.cfm">
<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td valign="top">
      <table width="100%" cellpadding="0" cellspacing="0" border="0" align="center" height="100%">
        <tr class="color-border">
          <td>
            <table width="100%" cellpadding="2" cellspacing="1" border="0" height="100%">
              <tr class="color-list" valign="middle">
                <td height="35" class="headbold"><cf_get_lang no='125.Talep'></td>
              </tr>
              <tr>
                <td class="color-row" valign="top">
                  <cfform name="add_assetp_request" action="#request.self#?fuseaction=assetcare.emptypopup_add_assetp_request" method="post">
                    <table>
                      <tr>
                        <td><cf_get_lang_main no='74.Kategori'>*</td>
                        <td><select name="cat_id" id="cat_id" style="width:170px;">
                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfoutput query="get_assetp_cats"><option value="#assetp_catid#">#assetp_cat#</cfoutput>
                            </select></td>
                      </tr>
                      <tr>
                        <td><cf_get_lang_main no='160.Departman'> *</td>
                        <td><select name="department_id" id="department_id" style="width:170px;">
                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                            	<cfoutput query="get_branchs_deps"><option value="#department_id#">#branch_name#-#department_head#</option></cfoutput>
                            </select>
                        </td>
                      </tr>
                      <tr>
                        <td><cf_get_lang no='82.Talep Eden'> *</td>
                        <td><input type="hidden" name="employee_id" id="employee_id" value="">
                        	<cfsavecontent variable="message"><cf_get_lang_main no="59.Eksik Veri"> : <cf_get_lang no='82.Talep Eden'></cfsavecontent>
						<cfinput type="Text" name="employee" value="" style="width:170px;" required="yes" message="#message#" readonly>
                          <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_assetp_request.employee_id&field_name=add_assetp_request.employee&select_list=1</cfoutput>','list')"><img src="/images/plus_list.gif" alt="<cf_get_lang no='82.Talep Eden'>" align="absmiddle" border="0"></a></td>
                      </tr>
                      <tr>
                        <td><cf_get_lang no='127.Kullanım Amacı'> *</td>
                        <td><select name="usage_purpose_id" id="usage_purpose_id" style="width:170px;">
                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
								<cfoutput query="get_usage_purpose"><option value="#usage_purpose_id#">#usage_purpose#</cfoutput>
                            </select></td>
                      </tr>
                      <tr>
					  	<td><cf_get_lang no='123.Talep Tarihi'> *</td>
						<td><cfsavecontent variable="message"><cf_get_lang_main no='1091.Tarih Girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="request_date" value="" maxlength="10" validate="#validate_style#" message="#message#" style="width:170;" required="yes">
                          <cf_wrk_date_image date_field="request_date"></td>
					  </tr>
					  <tr>
					    <td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                        <td><textarea name="detail" id="detail" style="width:170px;height:60px;"></textarea></td>
                      </tr>
                      <tr>
                        <td></td>
                        <td><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
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
			x = document.add_assetp_request.cat_id.selectedIndex;
			if (document.add_assetp_request.cat_id[x].value == "")
			{ 
				alert ("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='74.Kategori'>");
				return false;
			}		
			y = document.add_assetp_request.department_id.selectedIndex;
			if (document.add_assetp_request.department_id[y].value == "")
			{ 
				alert ("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='160.Departman'>");
				return false;
			}		
			z = document.add_assetp_request.usage_purpose_id.selectedIndex;
			if (document.add_assetp_request.usage_purpose_id[z].value == "")
			{ 
				alert ("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang no='30.Kullanım Amacı'>");
				return false;
			}		
		}
</script>
