<cfinclude template="../query/get_accident_upd.cfm">

<cfinclude template="../query/get_accident_type.cfm">
<cfinclude template="../query/get_money.cfm">
<cfinclude template="../query/get_fault_ratio.cfm">
<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">  
<tr class="color-border">
<td>
<table border="0" width="100%" height="100%" cellpadding="2" cellspacing="1">
  <tr class="color-list">
    <td height="35" class="headbold"><cf_get_lang no ='401.Kaza Ekle'></td>
  </tr>
  <tr>
    <td class="color-row" valign="top">
      <table border="0">
        <cfform name="upd_accident" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_upd_accident">
          <input type="hidden" name="accident_id" id="accident_id" value="<cfoutput>#attributes.accident_id#</cfoutput>">
		  <input type="hidden" name="is_detail" id="is_detail" value="1">
		  <tr>
		  	<td>No</td>
			<td><cfinput type="text" name="accident_num" value="" style="width:155px;"></td>
			<td><cf_get_lang no ='399.Sigorta Ödemesi'></td>
			<td><input type="checkbox" name="insurance_payment" id="insurance_payment"  value="1">
			  </td>
		  </tr>
		  <tr>
			<td width="80"><cf_get_lang_main no='1656.Plaka'>*</td>
			      <td width="200"><input type="hidden" name="assetp_id" id="assetp_id" value=""> 
				  <cfsavecontent variable="alert"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1656.Plaka'></cfsavecontent>
                    <cfinput type="text" name="assetp_name" style="width:155px;" value="" maxlength="50" required="yes" message="#alert#" readonly>
			  <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=upd_accident.assetp_id&field_name=upd_accident.assetp_name&list_select=2&is_active=1','list');"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='1656.Plaka'>" border="0" align="absmiddle"></a></td>
			      <td><cf_get_lang no ='398.Kusur Oran'></td>
			<td><select name="fault_ratio_id" id="fault_ratio_id" style="width:155px;">
                <option value=""></option>
                <cfoutput query="get_fault_ratio">
                  <option value="#fault_ratio_id#" <cfif fault_ratio_id eq get_accident_upd.fault_ratio_id>selected</cfif>>#fault_ratio_name#</option>
                </cfoutput>
              </select>
			  </td>
		  </tr>
		  <tr>
			<td><cf_get_lang_main no='132.Sorumlu'> *</td>
			<td><input type="hidden" name="employee_id" id="employee_id" value="">
			  <cfinput type="text" name="employee_name" value="" style="width:155px;">
			  <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=upd_accident.employee_id&field_name=upd_accident.employee_name&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='132.Sorumlu'>" align="absmiddle" border="0"></a></td>
			      <td><cf_get_lang_main no ='217.Aklama'></td>
			<td rowspan="3"><textarea name="accident_detail" id="textarea" style="width:155px;height:65px;"></textarea></td>
		  </tr>
		  <tr>
			<td><cf_get_lang_main no ='41.sube'> *</td>
			<td><input type="hidden" name="department_id" id="department_id" value="">
			<cfsavecontent variable="alert"><cf_get_lang no ='586.sube Seiniz'></cfsavecontent>
			  <cfinput type="text" name="department" value="" readonly required="yes" message=" !"  style="width:155px;">
			  <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=upd_accident.department_id&field_dep_branch_name=upd_accident.department','list');"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no ='41.sube'>" align="absmiddle" border="0"></a></td>
			<td></td>
		  </tr>
		  <tr>
			<td><cf_get_lang no ='395.Kaza Tarihi'> *</td>
			<cfsavecontent variable="alert"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='330.Tarih'></cfsavecontent>
			<td><cfinput type="text" name="accident_date" value="" required="yes" maxlength="10" validate="#validate_style#" message="#alert#" style="width:155px">
			  <cf_wrk_date_image date_field="accident_date"></td>
			<td></td>
          </tr>
          <tr>
			<td><cf_get_lang no ='397.Kaza Tipi'> *</td>
			<td><select name="accident_type_id" id="accident_type_id" style="width:155px;">
			  <option value=""></option>
			  <cfoutput query="get_accident_type">
				<option value="#accident_type_id#"<cfif accident_type_id eq get_accident_upd.accident_type_id>selected</cfif>>#accident_type_name#</option>
			  </cfoutput>
		      </select></td>
			<td></td>
		  </tr>
		  <tr>
			<td><cf_get_lang dictionary_id ='51635.Evrak Tipi'></td>
			<td>
              <select name="document_type_id" id="document_type_id" style="width:155px;">
                  <option value=""></option>
                  <option value="1"<cfif get_accident_upd.document_type_id eq 1>selected</cfif>><cf_get_lang no ='412.Polis Kaza Kaydi'></option>
                  <option value="2"<cfif get_accident_upd.document_type_id eq 2>selected</cfif>><cf_get_lang no ='413.Tespit Tutanagi'></option>
		      </select>
             </td>
			<td></td>
		  </tr>
		  <tr>
		    <td><cf_get_lang no ='403.Evrak No'></td>
		    <td><input name="document_num" type="text" id="document_num" style="width:155px;" value=""></td>
		    <td></td>
			<cfif (get_punishment.recordCount)>
		  	<td><cf_workcube_buttons is_upd='1' is_cancel='0' is_reset='0' is_delete='0' add_function='kontrol()'></td> 
			<cfelse>
		   	<td><cf_workcube_buttons is_upd='1' is_cancel='0' is_reset='0' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=assetcare.emptypopup_del_accident&accident_id=#attributes.accident_id#&is_detail=1'></td>
  			</cfif>
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
		x = document.upd_accident.accident_type_id.selectedIndex;
		if (document.upd_accident.accident_type_id[x].value == "")
		{ 
			alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='397.Kaza Tipi'>!");
			return false;
		}
			return true;
	}
</script>
