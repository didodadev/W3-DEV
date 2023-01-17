<cfinclude template="../query/get_asset_state.cfm">
<cfinclude template="../query/get_assetp_groups.cfm">
<cfquery name="GET_BRANCHS_DEPS" datasource="#DSN#">
	SELECT 
		DEPARTMENT.DEPARTMENT_ID, 
		DEPARTMENT.BRANCH_ID,
		DEPARTMENT.DEPARTMENT_HEAD,
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME
	FROM 
		BRANCH,
		DEPARTMENT 
	WHERE
		BRANCH.BRANCH_ID=DEPARTMENT.BRANCH_ID
	ORDER BY
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD
</cfquery>
<cfquery name="GET_ASSETP_CATS" datasource="#DSN#">
	SELECT 
		ASSETP_CATID, ASSETP_CAT FROM ASSET_P_CAT WHERE MOTORIZED_VEHICLE = 1 ORDER BY ASSETP_CAT
</cfquery>
<cfquery name="GET_PURPOSE" datasource="#DSN#">
	SELECT USAGE_PURPOSE_ID, USAGE_PURPOSE FROM SETUP_USAGE_PURPOSE WHERE MOTORIZED_VEHICLE = 1 ORDER BY USAGE_PURPOSE
</cfquery>
<cfquery name="GET_BRAND" datasource="#DSN#">
	SELECT BRAND_ID,BRAND_NAME FROM SETUP_BRAND WHERE MOTORIZED_VEHICLE = 1 ORDER BY BRAND_NAME
</cfquery>
<table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td class="headbold"><cf_get_lang no='766.Plaka Ekle'></td>
  </tr>
</table>
<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr class="color-border">
      <td>
        <table width="100%" align="center" cellpadding="2" cellspacing="1" border="0">
          <tr class="color-row">
            <td><table border="0">
              <cfform name="add_assetp" method="post"action="#request.self#?fuseaction=assetcare.emptypopup_add_assetp_vehicle">
                <tr>
                  <td width="100px"><cf_get_lang no='143.Mülkiyet'></td>
                  <td width="250px"><input type="checkbox" name="property" id="property"></td>
                  <td width="100px"><cf_get_lang_main no='344.Durum'></td>
                  <td><select name="state" id="state" style="width:200">
                      <option value=""><cf_get_lang_main no='322.Seçiniz'></option>   
 					  <cfoutput query="get_asset_state">
                      	<option value="#asset_state_id#">#asset_state# 
                      </cfoutput></select></td>
                </tr>
                <tr>
                  <td><cf_get_lang_main no='1466.Demirbaş No'> *</td>
                  <td><cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1466.Demirbaş No'></cfsavecontent>                      
                      <cfinput type="text" name="inventory_number" required="yes" message="#message#" style="width:200px;" maxlength="50"></td>
                  <td><cf_get_lang no='30.Kullanım Amacı'></td>
                  <td><select name="usage_purpose_id" id="usage_purpose_id" style="width:200px;">
                      <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                      <cfoutput query="get_purpose">
                        <option value="#usage_purpose_id#">#usage_purpose#</option>
                      </cfoutput>
                    </select></td>
                </tr>
                <tr>
                  <td><cf_get_lang_main no='221.Barkod'></td>
                  <td><cfinput type="text" name="barcode" value="" maxlength="100" style="width:200px;"></td>
                  <td><cf_get_lang no='149.Varlık Grubu'></td>
                  <td><select name="assetp_group" id="assetp_group" style="width:200px;">
                      <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                      <cfoutput query="get_assetp_groups">
                        <option value="#group_id#">#group_name#</option>
                      </cfoutput>
                    </select></td>
                </tr>
                <tr>
                  <td><cf_get_lang_main no='1656.Plaka'> *</td>
                  <td><cfinput type="text" name="assetp" style="width:200px;" value="" maxlength="50"></td>
                  <td><cf_get_lang_main no='225.Seri No'></td>
                  <td><cfinput type="text" name="serial_number" maxlength="50" value="" style="width:200px"></td>
                </tr>
                <tr>
                  <td><cf_get_lang_main no='74.Kategori'>*</td>
                  <td>
                    <select name="assetp_catid" id="assetp_catid" style="width:200px;">
						<cfoutput query="get_assetp_cats">
                        <option value="#assetp_catid#">#assetp_cat# </cfoutput>
                    </select>
                  </td>
                  <td><cf_get_lang_main no='1435.Marka'> *</td>
                  <td><select name="brand" id="brand" style="width:200px;">
                      <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                      <cfoutput query="get_brand">
                      <option value="#brand_id#">#brand_name# </cfoutput>
                    </select></td>
                </tr>
                <tr>
                  <td><cf_get_lang no='144.Kayıtlı Departman'> *</td>
                  <td><select name="department_id" id="department_id" style="width:200px;">
                      <cfoutput query="get_branchs_deps">
                        <option value="#department_id#">#branch_name#-#department_head#</option>
                      </cfoutput>
                    </select>
                  </td>
                  <td><cf_get_lang_main no='813.Model'>\<cf_get_lang_main no='1043.Yıl'></td>
                  <td><cfinput type="text" name="model" value="" maxlength="50" style="width:100px">
                      <select name="make_year" id="make_year" style="width:97px;">
                        <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                        <cfset yil = dateformat(date_add("yyyy",1,now()),"yyyy")>
                        <cfoutput>
                          <cfloop from="#yil#" to="1970" index="i" step="-1">
                            <option value="#i#">#i#</option>
                          </cfloop>
						</cfoutput>
						</select></td>
                </tr>
                <tr>
                  <td><cf_get_lang no='145.Kullanıcı Departman'></td>
                  <td><select name="department_id2" id="department_id2" style="width:200px;">
                      <option value=""><cf_get_lang no='71.Department Seçiniz'></option>
                      <cfoutput query="get_branchs_deps">
                        <option value="#department_id#">#branch_name#-#department_head#</option>
                      </cfoutput>
                    </select></td>
				  <td><cf_get_lang_main no='377.Özel Kod'></td>                  
                  <td><cfinput type="text" name="ozel_kod" value="" maxlength="50" style="width:200px"></td>
                </tr>
                <tr>
                  <td><cf_get_lang_main no='132.Sorumlu'> *</td>
                  <td><input type="hidden" name="position_code" id="position_code" value="">
                      <input type="Text" name="position" id="position" value="" readonly style="width:200px;">
                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=add_assetp.position_code&field_name=add_assetp.position</cfoutput>','list')"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='132.Sorumlu'>" align="absmiddle" border="0"></a></td>
                  
				  <td><cf_get_lang no='27.Servis Çalışanı'></td>			
				  <td><input type="hidden" name="employee_id" id="employee_id" value="">
                      <input type="text" name="employee" id="employee" value="" readonly="" style="width:200px">
                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=add_assetp.employee_id&field_name=add_assetp.employee&select_list=1','list');"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='27.Servis Çalışanı'>" border="0" align="absmiddle"></a></td>  
                </tr>
                <tr>
                  <td><cf_get_lang_main no='132.Sorumlu'> 2</td>
                  <td><input type="hidden" name="position_code2" id="position_code2" id="position_code2" value="">
                      <input type="text" name="position2" id="position2" value="" readonly style="width:200px;">
                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=add_assetp.position_code2&field_name=add_assetp.position2</cfoutput>','list')"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='132.Sorumlu'>" align="absmiddle" border="0"></a></td>
				  <td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
				  <td rowspan="3"><textarea name="assetp_detail" id="assetp_detail" style="width:200px;height:65px;"></textarea></td>
                </tr>
                <tr>
                  <td><cf_get_lang no='21.Alınan Firma'></td>
                  <td><input type="hidden" name="get_company_id" id="get_company_id">
                      <input type="text" name="get_company" id="get_company" value=""  readonly="" style="width:200px">
                    <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=add_assetp.get_company&field_comp_id=add_assetp.get_company_id&select_list=2,3','list');"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='21.Alınan Firma'>" border="0" align="absmiddle"></a></td>
				  <td></td>
                </tr>
                <tr>
                  <td><cf_get_lang no='22.Alım Tarihi'></td>
                  <td><cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='22.Alım Tarihi !'></cfsavecontent>
                      <cfinput type="text" name="get_date" value="" maxlength="10" validate="#validate_style#" message="#message#" style="width:200px">
                    <cf_wrk_date_image date_field="get_date"></td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td><cf_get_lang_main no='1641.Çıkış Tarihi'></td>
                  <td><cfsavecontent variable="message"><cf_get_lang no='147.Çıkış Tarihi Girmelisiniz !'></cfsavecontent>
		              <cfinput type="text" name="exit_date" value="" maxlength="10" validate="#validate_style#" message="#message#" style="width:200px">
                    <cf_wrk_date_image date_field="exit_date"></td>
                  <td></td>
                  <td ><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
                </tr>
              </cfform>
            </table></td>
          </tr>
        </table>
      </td>
    </tr>
</table>
<script type="text/javascript">
function kontrol()
{
	x = document.add_assetp.department_id.selectedIndex;
	if (document.add_assetp.department_id[x].value == "")
	{ 
		alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='160.Departman'>");
		return false;
	}
	if ( (document.add_assetp.position_code.value == "") || ((document.add_assetp.position.value == "")) )
	{ 
		alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='132.Sorumlu !'>");
		return false;
	}
	if (document.add_assetp.assetp.value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1655.Varlık'> <cf_get_lang_main no='485.adı'> !");
		return false;
	}
	y = document.add_assetp.brand.selectedIndex;
	if (document.add_assetp.brand[y].value == "")
	{ 
		alert ("Zorunlu Alan : Marka !");
		return false;
	}
	return true;
}
</script>
