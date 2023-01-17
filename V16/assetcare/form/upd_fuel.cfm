<cfinclude template="../query/get_fuel_upd.cfm">
<cfinclude template="../query/get_fuel_type.cfm">
<cfinclude template="../query/get_document_type.cfm">
<cfinclude template="../query/get_money.cfm">
<cfform name="upd_fuel" action="#request.self#?fuseaction=assetcare.emptypopup_upd_fuel" onsubmit="return(unformat_fields());">
	<table border="0">
		<input name="fuel_id" id="fuel_id" type="hidden" value="<cfoutput>#attributes.fuel_id#</cfoutput>">
		<tr> 
			<td><cf_get_lang_main no='75.No'></td>
			<td width="220"><cfinput type="text" name="fuel_num" value="#get_fuel_upd.fuel_id#" readonly style="width:170px;"></td>
			<td><cf_get_lang no='216.İşlem Tarihi'> *</td>
				<cfsavecontent variable="alert"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='330.Tarih'></cfsavecontent>
			<td width="220"><cfinput type="text" name="fuel_date" value="#dateformat(get_fuel_upd.fuel_date,dateformat_style)#" validate="#validate_style#" required="yes" message="#alert#" style="width:170px;"> 
			  <cf_wrk_date_image date_field="fuel_date" date_form="upd_fuel">	
			</td>
			<td width="75"><cf_get_lang_main no='468.Belge No'></td>
			<td><cfinput type="text" name="document_num" value="#get_fuel_upd.document_num#"style="width:170px;"></td>
		</tr>
		<tr> 
			<td><cf_get_lang_main no='1656.Plaka'> *</td>
			<td><input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#get_fuel_upd.assetp_id#</cfoutput>"> 
			  <cfsavecontent variable="message19"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1656.Plaka'>!</cfsavecontent>
			  <cfinput type="text" name="assetp_name" readonly style="width:170px;" value="#get_fuel_upd.assetp#" reqired="yes" message="#message19#"> 
			  <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&fuel_type_id=upd_fuel.fuel_type_id&field_id=upd_fuel.assetp_id&field_name=upd_fuel.assetp_name&list_select=2&field_dep_id=upd_fuel.department_id&field_dep_name=upd_fuel.department&field_emp_id=upd_fuel.employee_id&field_emp_name=upd_fuel.employee_name&&is_active=1&field_fuel_id=upd_fuel.fuel_type_id','list','popup_list_ship_vehicles');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></td>
			<td><cf_get_lang no='387.Yakıt Şirketi'> *</td>
			<td><input name="fuel_comp_id" id="fuel_comp_id" type="hidden" value="<cfoutput>#get_fuel_upd.fuel_company_id#</cfoutput>"> 
            	<cfsavecontent variable="message"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang no='387.Yakıt Şirketi'></cfsavecontent>
                <cfinput type="text" name="fuel_comp_name" value="#get_fuel_upd.fullname#" readonly required="yes" message="#message#" style="width:170px;"> 
                <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=upd_fuel.fuel_comp_id&field_comp_name=upd_fuel.fuel_comp_name&is_buyer_seller=1&select_list=2</cfoutput>','list','popup_list_pars')"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='387.Yakıt Şirketi'>" align="absmiddle" border="0"></a>	
			</td>
			<td><cf_get_lang no='388.Yakıt Miktarı'> (Lt) *</td>
			<td><cfsavecontent variable="message25"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='388.Yakıt Miktarı'> !</cfsavecontent>
				<cfinput type="text" name="fuel_amount" value="#tlformat(get_fuel_upd.fuel_amount)#" required="yes" message="#message25#" onKeyup="return(FormatCurrency(this,event));" style="width:170px;"></td>
		</tr>
		<tr> 
			<td><cf_get_lang_main no='132.Sorumlu'> * </td>
			<cfset x = "">
			<cfif get_fuel_upd.department_id neq "">
			  <cfquery name="get_dep" datasource="#dsn#">
			  SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = #get_fuel_upd.department_id# 
			  </cfquery>
			  <cfset x = get_dep.department_head>
			</cfif>
			<td><input name="employee_id" id="employee_id" value="<cfoutput>#get_fuel_upd.employee_id#</cfoutput>" type="hidden"> 
			  <cfsavecontent variable="message20"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='132.Sorumlu'>!</cfsavecontent>
			  <cfinput type="Text" name="employee_name" value="#get_emp_info(get_fuel_upd.employee_id,0,0)#" readonly reqired="yes" message="#message20#"style="width:170px;"> 
			  <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=upd_fuel.employee_id&field_name=upd_fuel.employee_name&select_list=1&branch_related</cfoutput>','list','popup_list_positions')"><img src="/images/plus_thin.gif" alt="" align="absmiddle" border="0"></a></td>
			<td><cf_get_lang no='267.Yakıt Tipi'> *</td>
			<td>
            	<select name="fuel_type_id" id="fuel_type_id" style="width:170px;">
                    <option value=""></option>
                    <cfoutput query="get_fuel_type"> 
                      <option value="#fuel_id#" <cfif fuel_id eq get_fuel_upd.fuel_type_id>selected</cfif>>#fuel_name#</option>
                    </cfoutput>
                </select>
            </td>
			<td><cf_get_lang no='243.KDV li Toplam Tutar'></td>
			<td><cfinput type="text" name="total_amount" value="#tlFormat(get_fuel_upd.total_amount)#" onKeyup="return(FormatCurrency(this,event));" style="width:120px;"> 
			  <select name="total_currency" id="total_currency" style="width:48px;">
				<cfoutput query="get_money"> 
				  <option value="#money#" <cfif money eq get_fuel_upd.total_currency>selected</cfif>>#money#</option>
				</cfoutput> 
			  </select> 
			</td>
		</tr>
		<tr> 
			<td><cf_get_lang no='170.Kullanıcı Şube'> *</td>
			<td><input type="hidden" name="department_id" id="department_id" value="<cfoutput>#get_fuel_upd.department_id#</cfoutput>"> 
            <cfsavecontent variable="message1"><cf_get_lang_main no="782.Zorunlu Alan"> : <cf_get_lang_main no="74.Kategori"></cfsavecontent>
			  <cfinput type="text" name="department" required="yes" message="#message1#" value="#x#" readonly style="width:170px;"> 
			  <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=upd_fuel.department_id&field_name=upd_fuel.department','list','popup_list_departments');"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='170.Kullanıcı Şube'>" align="absmiddle" border="0"></a></td>
			<td><cf_get_lang_main no='1121.Belge Tipi'> *</td>
			<td>
            	<select name="document_type_id" id="document_type_id" style="width:170px">
                    <option value=""></option>
                    <cfoutput query="get_document_type"> 
                      <option value="#document_type_id#" <cfif document_type_id eq get_fuel_upd.document_type_id>selected</cfif>>#document_type_name#</option>
                    </cfoutput> 
                </select>
            </td>
			<td>&nbsp;</td>
		</tr>
	</table>
	<cf_basket_form_button><cf_workcube_buttons is_upd='1' is_cancel='0' is_reset='0' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=assetcare.emptypopup_del_fuel&fuel_id=#attributes.fuel_id#&plaka=#get_fuel_upd.assetp#'></cf_basket_form_button>
</cfform>
<script type="text/javascript">
	function unformat_fields()
	{
	  document.upd_fuel.fuel_amount.value = filterNum(document.upd_fuel.fuel_amount.value);
	  document.upd_fuel.total_amount.value = filterNum(document.upd_fuel.total_amount.value);
	}
	function kontrol()
	{
		x = document.upd_fuel.fuel_type_id.selectedIndex;
		if (document.upd_fuel.fuel_type_id[x].value == "")
		{ 
			alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='2316.Yakıt Tipi'>!");
			return false;
		}
		y = document.upd_fuel.document_type_id.selectedIndex;
		if (document.upd_fuel.document_type_id[y].value == "")
		{ 
			alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1121.Belge Tipi'>!");
			return false;
		}
		return true;
	}
</script>
