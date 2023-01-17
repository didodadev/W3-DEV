<!---BU SAYFA HEM POPUP HEM BASKET OLARAK ÇAĞRILDIĞI İÇİN BASKETE GÖRE DÜZENLENMİŞTİR.--->
<cfinclude template="../query/get_fuel_type.cfm">
<cfinclude template="../query/get_document_type.cfm">
<cfinclude template="../query/get_money.cfm">
<cfquery name="GET_MAX_FUEL" datasource="#DSN#">
	SELECT MAX(FUEL_ID) AS MAX_FUEL_ID FROM ASSET_P_FUEL
</cfquery>
<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.assetp_id") and len(attributes.assetp_id)>
	<cfquery name="get_vehicles" datasource="#DSN#">
		SELECT * FROM ASSET_P WHERE ASSETP_ID = #attributes.assetp_id#
	</cfquery>
	<cfif len(get_vehicles.department_id)>
		<cfquery name="GET_BRANCHS_DEPS" datasource="#DSN#">
			SELECT
				DEPARTMENT.DEPARTMENT_HEAD,
				BRANCH.BRANCH_NAME
			FROM
				BRANCH,
				DEPARTMENT
			WHERE
				DEPARTMENT.DEPARTMENT_ID = #get_vehicles.department_id# AND
				BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
		</cfquery>
	</cfif>
</cfif>
<cfif len(get_max_fuel.max_fuel_id)>
	<cfset max_fuel_id = get_max_fuel.max_fuel_id+1>
<cfelse>
	<cfset max_fuel_id = 1>
</cfif>
<cfform name="add_fuel" action="#request.self#?fuseaction=assetcare.emptypopup_add_fuel" onsubmit="return(unformat_fields());">
	<table>
		<input name="is_detail" id="is_detail" type="hidden" value="0">
		<tr> 
			<td><cf_get_lang_main no='75.No'></td>
			<td width="220"><cfinput type="text" name="fuel_num" value="#max_fuel_id#" readonly style="width:170px;"></td>
			<td><cf_get_lang no='216.İşlem Tarihi'> *</td>
				
			<td width="220">
				<cfsavecontent variable="alert"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='330.Tarih'></cfsavecontent>
            	<cfinput type="text" name="fuel_date" maxlength="10" validate="#validate_style#" required="yes" message="#alert#" style="width:170px;"> 
				<cf_wrk_date_image date_field="fuel_date" date_form="add_fuel">
           	</td>
			<td width="100"><cf_get_lang_main no='468.Belge No'></td>
			<td><cfinput type="text" name="document_num" maxlength="500" style="width:170px;"></td>
		</tr>
		<tr> 
			<td><cf_get_lang_main no='1656.Plaka'>*</td>
			<td>
            	<input type="hidden" name="assetp_id" id="assetp_id" value="<cfif isdefined("get_vehicles.assetp_id") and len(get_vehicles.assetp_id)><cfoutput>#get_vehicles.assetp_id#</cfoutput></cfif>">
				<cfsavecontent variable="message19"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1656.Plaka'> !</cfsavecontent>
				<cfif isdefined("get_vehicles.assetp") and len(get_vehicles.assetp)>
					<cfinput type="text" name="assetp_name" value="#get_vehicles.assetp#" readonly style="width:170px;" required="yes" message="#message19#">
				<cfelse>
					<cfinput type="text" name="assetp_name" readonly style="width:170px;" required="yes" message="#message19#">
				</cfif>
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&fuel_type_id=add_fuel.fuel_type_id&field_id=add_fuel.assetp_id&field_name=add_fuel.assetp_name&field_emp_id=add_fuel.employee_id&field_emp_name=add_fuel.employee_name&field_dep_name=add_fuel.department&field_dep_id=add_fuel.department_id&list_select=2&is_active=1&field_fuel_id=add_fuel.fuel_type_id','list','popup_list_ship_vehicles');"><!--- 'popup_list_ship_vehicles' --->
				<img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='1656.Plaka'>" border="0" align="absbottom"></a>
           	</td>
			<td><cf_get_lang no='387.Yakıt Şirketi'> *</td>
			<td>
            	<input name="fuel_comp_id" id="fuel_comp_id" type="hidden" value="">
				<cfinput type="text" name="fuel_comp_name" readonly required="yes" message="Yakıt Şirketi Seçmelisiniz !" style="width:170px;"> 
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=add_fuel.fuel_comp_id&field_comp_name=add_fuel.fuel_comp_name&is_buyer_seller=1&select_list=2>','list','popup_list_pars')"><img src="/images/plus_thin.gif" align="absbottom" alt="<cf_get_lang no='387.Yakıt Şirketi'>" border="0" ></a>
         	</td>
			<td><cf_get_lang no='388.Yakıt Miktarı'> (Lt) *</td>
			<td>
            	<cfsavecontent variable="message25"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='388.Yakıt Miktarı'> !</cfsavecontent>
				<cfinput type="text" name="fuel_amount" maxlength="500" style="width:170px;" required="yes" message="#message25#" onKeyup="return(FormatCurrency(this,event));">
          	</td>
		</tr>
		<tr> 
		<td><cf_get_lang_main no='132.Sorumlu'> *</td>
		<td>
        	<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("get_vehicles.employee_id") and len(get_vehicles.employee_id)><cfoutput>#get_vehicles.employee_id#</cfoutput></cfif>">
			<cfsavecontent variable="message20"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='132.Sorumlu'> !</cfsavecontent>
			<cfif isdefined("attributes.assetp_id") and len(attributes.assetp_id) and isdefined("get_vehicles.position_code") and len(get_vehicles.position_code)>
				<cfinput type="text" name="employee_name" value="#get_emp_info(get_vehicles.position_code,1,0)#" required="yes" message="#message20#" readonly style="width:170px;"><!--- <cfelseif len(get_vehicles.company_partner_id)>#get_par_info(get_vehicles.company_partner_id,0,0,0)# ---> 
			<cfelse>
				<cfinput type="text" name="employee_name" value="" required="yes" message="#message20#" readonly style="width:170px;"> 
			</cfif>
			<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_fuel.employee_id&field_name=add_fuel.employee_name&select_list=1&branch_related</cfoutput>','list','popup_list_positions')"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='132.Sorumlu'>" align="absbottom" border="0"></a>
      	</td>
		<td><cf_get_lang no='267.Yakıt Tipi'> *</td>
		<td>
        	<select name="fuel_type_id" id="fuel_type_id" style="width:170px;">
			<option value=""></option>
			<cfoutput query="get_fuel_type"> 
				<option value="#fuel_id#">#fuel_name#</option>
			</cfoutput>
			</select></td>
		<td><cf_get_lang no='243.KDV li Toplam Tutar'></td>
		<td>
		    <cfinput name="total_amount" type="text" class="moneybox" style="width:120px;" onKeyup="return(FormatCurrency(this,event));">
			<select name="total_currency" id="total_currency" style="width:48px;">
				<cfoutput query="get_money"> 
					<option value="#money#"<cfif money eq session.ep.money>selected</cfif>>#money#</option>
				</cfoutput>
		    </select>
		</td>
		</tr>
		<tr> 
			<td height="21"><cf_get_lang no='170.Kullanıcı Şube'> *</td>
			<td>
            	<input type="hidden" name="department_id" id="department_id" value="<cfif isdefined("get_vehicles.department_id") and len(get_vehicles.department_id)><cfoutput>#get_vehicles.department_id#</cfoutput></cfif>">
				<cfif isdefined("get_vehicles.department_id") and len(get_vehicles.department_id)>
					<cfinput type="text" name="department" value="#get_branchs_deps.branch_name# - #get_branchs_deps.department_head#" message="Şube Seçiniz !" readonly style="width:170px;">
				<cfelse>
					<cfinput type="text" name="department" message="Şube Seçiniz !" readonly style="width:170px;">
				</cfif> 
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=add_fuel.department_id&field_dep_branch_name=add_fuel.department','list','popup_list_departments');"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='170.Kullanıcı Şube'>" align="absbottom" border="0"></a>
           	</td>
			<td><cf_get_lang_main no='1121.Belge Tipi'> *</td>
			<td>
            	<select name="document_type_id" id="document_type_id" style="width:170px">
				<option value=""></option>
				<cfoutput query="get_document_type"> 
                    <option value="#document_type_id#">#document_type_name#</option>
                </cfoutput> 
				</select>
			</td>
		</tr>
	</table>
	<cf_basket_form_button><cf_workcube_buttons is_upd='0'  is_cancel='0' is_reset='1' add_function='kontrol()'></cf_basket_form_button>
</cfform>
<script type="text/javascript">
function unformat_fields()
{
	document.add_fuel.fuel_amount.value = filterNum(document.add_fuel.fuel_amount.value);
	document.add_fuel.total_amount.value = filterNum(document.add_fuel.total_amount.value);	
}

function kontrol()
{
	x = document.add_fuel.fuel_type_id.selectedIndex;
	if (document.add_fuel.fuel_type_id[x].value == "")
	{ 
		alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='2316.Yakıt Tipi'> !");
		return false;
	}
	y = document.add_fuel.document_type_id.selectedIndex;
	if (document.add_fuel.document_type_id[y].value == "")
	{ 
		alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1121.Belge Tipi'> !");
		return false;
	}
	return true;
}
</script>
