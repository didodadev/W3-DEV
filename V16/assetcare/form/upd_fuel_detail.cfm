<cfinclude template="../query/get_fuel_upd.cfm">
<cfinclude template="../query/get_fuel_type.cfm">
<cfinclude template="../query/get_document_type.cfm">
<cfinclude template="../query/get_money.cfm">
<cfsavecontent variable="right">
	<cfoutput><a href="javascript://" onclick="yakit_kayit();"><img src="/images/plus1.gif" align="absmiddle" alt="<cf_get_lang_main no='170.Ekle'>" title="<cf_get_lang_main no='170.Ekle'>" border="0"></a></cfoutput>
</cfsavecontent>
<cf_popup_box title="#getLang('assetcare',393)#" right_images="#right#">
<cfform name="upd_fuel" action="#request.self#?fuseaction=assetcare.emptypopup_upd_fuel" onsubmit="return(unformat_fields());">
<input name="fuel_id" id="fuel_id" type="hidden" value="<cfoutput>#attributes.fuel_id#</cfoutput>">
<input name="is_detail" id="is_detail" type="hidden" value="1">
	<table>
		<tr> 
			<td width="85"><cf_get_lang_main no='75.No'></td>
			<td width="190"> <input type="text" name="fuel_num" id="fuel_num" value="<cfoutput>#get_fuel_upd.fuel_id#</cfoutput>" readonly style="width:160px;"></td>
			<td><cf_get_lang no='267.Yakıt Tipi'> *</td>
			<td>
            	<select name="fuel_type_id" id="fuel_type_id" style="width:160px;">
				<option value=""></option>
					<cfoutput query="get_fuel_type">
						<option value="#fuel_id#" <cfif fuel_id eq get_fuel_upd.fuel_type_id>selected</cfif>>#fuel_name#</option>
					</cfoutput>
				</select>
            </td>
		</tr>
		<tr> 
			<td><cf_get_lang_main no='1656.Plaka'> *</td>
			<td><input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#get_fuel_upd.assetp_id#</cfoutput>"> 
			<input type="text" name="assetp_name" id="assetp_name" readonly style="width:160px;" value="<cfoutput>#get_fuel_upd.assetp#</cfoutput>"> 
			<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=upd_fuel.assetp_id&field_name=upd_fuel.assetp_name&field_dep_id=upd_fuel.department_id&field_dep_name=upd_fuel.department&field_emp_id=upd_fuel.employee_id&field_emp_name=upd_fuel.employee_name&list_select=2&is_active=1','list');"><img src="/images/plus_thin.gif"  alt="<cf_get_lang_main no='1656.Plaka'>" border="0" align="absmiddle"></a></td>
			<td><cf_get_lang_main no='1121.Belge Tipi'> *</td>
			<td>
            	<select name="document_type_id" id="document_type_id" style="width:160px">
				<option value=""></option>
					<cfoutput query="get_document_type">
						<option value="#document_type_id#" <cfif document_type_id eq get_fuel_upd.document_type_id>selected</cfif>>#document_type_name#</option>
					</cfoutput>
				</select>
            </td>
		</tr>
		<tr> 
			<td><cf_get_lang_main no='132.Sorumlu'> *</td>
			<cfset x = "">
			<cfif get_fuel_upd.department_id neq "">
			<cfquery name="get_dep" datasource="#dsn#">
			SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = #get_fuel_upd.department_id# 
			</cfquery>
			<cfset x = get_dep.department_head>
			</cfif>
			<td><input name="employee_id" id="employee_id" value="<cfoutput>#get_fuel_upd.employee_id#</cfoutput>" type="hidden"> 
			<input type="text" name="employee_name" id="employee_name" value="<cfoutput>#get_emp_info(get_fuel_upd.employee_id,0,0)#</cfoutput>" readonly reqired="yes" message="#message20#"style="width:160px;"> 
			<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=upd_fuel.employee_id&field_name=upd_fuel.employee_name&select_list=1</cfoutput>','list')"><img src="/images/plus_thin.gif" alt="" align="absmiddle" border="0"></a></td>
			<td><cf_get_lang_main no='468.Belge No'></td>
			<td><input type="text" name="document_num" id="document_num" value="<cfoutput>#get_fuel_upd.document_num#</cfoutput>" style="width:160px;"></td>
		</tr>
		<tr> 
			<td><cf_get_lang no='170.Kullanıcı Şube'> *</td>
			<td><input type="hidden" name="department_id" id="department_id" value="<cfoutput>#get_fuel_upd.department_id#</cfoutput>"> 
			<input type="text" name="department" id="department" value="<cfoutput>#x#</cfoutput>" readonly style="width:160px;"> 
			<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=upd_fuel.department_id&field_name=upd_fuel.department','list');"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='170.Kullanıcı Şube'>" align="absmiddle" border="0"></a></td>
			<td><cf_get_lang no='388.Yakıt Miktarı'> *</td>
			<td><input type="text" name="fuel_amount" id="fuel_amount" value="<cfoutput>#tlformat(get_fuel_upd.fuel_amount)#</cfoutput>" onKeyup="return(FormatCurrency(this,event));" style="width:160px;"></td>
		</tr>
		<tr> 
			<td><cf_get_lang_main no='467.İşlem Tarihi'> *</td>
			<td><input type="text" name="fuel_date" id="fuel_date" value="<cfoutput>#dateformat(get_fuel_upd.fuel_date,dateformat_style)#</cfoutput>" style="width:160px;"> 
			<cf_wrk_date_image date_field="fuel_date"></td>
			<td><cf_get_lang no='243.KDV li Toplam Tutar'></td>
			<td><input type="text" name="total_amount" id="total_amount" style="width:110px;" value="<cfoutput>#tlFormat(get_fuel_upd.total_amount)#</cfoutput>" onKeyup="return(FormatCurrency(this,event));"> 
				<select name="total_currency" id="total_currency" style="width:48px;">
					<cfoutput query="get_money"> 
						<option value="#money#" <cfif money eq get_fuel_upd.total_currency>selected</cfif>>#money#</option>
					</cfoutput>
				</select>
            </td>
		</tr>
		<tr>
			<td><cf_get_lang no='387.Yakıt Şirketi'> *</td>
			<td><input name="fuel_comp_id" id="fuel_comp_id" type="hidden" value="<cfoutput>#get_fuel_upd.fuel_company_id#</cfoutput>"> 
			<input type="text" name="fuel_comp_name" id="fuel_comp_name" value="<cfoutput>#get_fuel_upd.fullname#</cfoutput>" readonly style="width:160px;"> 
			<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=upd_fuel.fuel_comp_id&field_comp_name=upd_fuel.fuel_comp_name&is_buyer_seller=1&select_list=2</cfoutput>','list')"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='387.Yakıt Şirketi'>" align="absmiddle" border="0"></a></td>
		</tr>
	</table>
	<cf_popup_box_footer><cf_workcube_buttons type_format="1" is_upd='1' is_cancel='0' is_delete='1' delete_page_url='#request.self#?fuseaction=assetcare.emptypopup_del_fuel&fuel_id=#attributes.fuel_id#&plaka=#get_fuel_upd.assetp#&is_detail=1' add_function='kontrol()'></cf_popup_box_footer>
</cfform>
</cf_popup_box>
<script type="text/javascript">
function unformat_fields()
{
	document.upd_fuel.fuel_amount.value = filterNum(document.upd_fuel.fuel_amount.value);
	document.upd_fuel.total_amount.value = filterNum(document.upd_fuel.total_amount.value);
}
function yakit_kayit()
	{
		window.opener.parent.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.form_add_fuel';
		window.close();
	}
function kontrol()
{
	if(document.upd_fuel.assetp_name.value == "")
	{
		alert("<cf_get_lang no='224.Plaka Girmelisiniz'>!");
		return false;
	}
	
	if(document.upd_fuel.employee_name.value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='132.Sorumlu'>!");
		return false;
	}
	
	if(document.upd_fuel.department.value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='170.Kullanıcı Şube'>!");
		return false;
	}
	
	if(document.upd_fuel.fuel_date.value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='286.İşlem Tarihi'>!");
		return false;
	}
	
	if(!CheckEurodate(document.upd_fuel.fuel_date.value,"<cf_get_lang_main no='467.İşlem Tarihi'>"))
	{
		return false;
	}

	if(document.upd_fuel.fuel_comp_name.value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='470.Akaryakıt Şirketi'>!");
		return false;
	}		
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
	
	if(document.upd_fuel.fuel_amount.value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='388.Yakıt Miktarı'>!");
		return false;
	}
	
	return true;
}
</script>
