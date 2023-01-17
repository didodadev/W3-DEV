
<cfinclude template="../query/get_fuel_type.cfm">
<cfinclude template="../query/get_document_type.cfm">
<cfinclude template="../query/get_money.cfm">
<cfquery name="GET_MAX_FUEL" datasource="#DSN#">
	SELECT MAX(FUEL_ID) AS MAX_FUEL_ID FROM ASSET_P_FUEL
</cfquery>
<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.assetp_id") and len(attributes.assetp_id)>
	<cfquery name="get_vehicles" datasource="#DSN#">
		SELECT
        	ASSET_P.DEPARTMENT_ID,
            ASSET_P.ASSETP_ID,
            ASSET_P.ASSETP,
            ASSET_P.EMPLOYEE_ID,
            ASSET_P.POSITION_CODE,
            ASSET_P.COMPANY_PARTNER_ID
        FROM 
        	ASSET_P
        WHERE
        	ASSETP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.assetp_id#">
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
				DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_vehicles.department_id#"> AND
				BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
		</cfquery>
	</cfif>
    <cfset pageHead="#getLang('assetcare',198)# : #getLang('main',1656)# : #get_vehicles.assetp# ">
<cfelse>
	<cfset pageHead="#getLang('assetcare',198)#">
</cfif>
<cfif len(get_max_fuel.max_fuel_id)>
	<cfset max_fuel_id = get_max_fuel.max_fuel_id+1>
<cfelse>
	<cfset max_fuel_id = 1>
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>			
		<cfform name="add_fuel" action="#request.self#?fuseaction=assetcare.emptypopup_add_fuel" onsubmit="return(unformat_fields());">
			<cf_box_elements>
				<input name="is_detail" id="is_detail" type="hidden" value="0">
				<div class="col col-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-fuel_date">
						<label class="col col-4 col-xs-12"><cf_get_lang no='216.İşlem Tarihi'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="alert"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no ='330.Tarih'></cfsavecontent>
								<cfinput type="text" name="fuel_date" id="start_date" maxlength="10" validate="#validate_style#" required="yes" message="#alert#"> 
								<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-assetp_name">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='1656.Plaka'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="assetp_id" id="assetp_id" value="<cfif isdefined("get_vehicles.assetp_id") and len(get_vehicles.assetp_id)><cfoutput>#get_vehicles.assetp_id#</cfoutput></cfif>">
								<cfsavecontent variable="message19"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1656.Plaka'> !</cfsavecontent>
								<cfif isdefined("get_vehicles.assetp") and len(get_vehicles.assetp)>
									<cfinput type="text" name="assetp_name" value="#get_vehicles.assetp#" readonly required="yes" message="#message19#">
								<cfelse>
									<cfinput type="text" name="assetp_name" readonlyrequired="yes" message="#message19#">
								</cfif>
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&fuel_type_id=add_fuel.fuel_type_id&field_id=add_fuel.assetp_id&field_name=add_fuel.assetp_name&field_emp_id=add_fuel.employee_id&field_emp_name=add_fuel.employee_name&field_dep_name=add_fuel.department&field_dep_id=add_fuel.department_id&list_select=2&is_active=1&field_fuel_id=add_fuel.fuel_type_id');"><!--- 'popup_list_ship_vehicles' --->
								</span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-employee_name">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='132.Sorumlu'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("get_vehicles.employee_id") and len(get_vehicles.employee_id)><cfoutput>#get_vehicles.employee_id#</cfoutput></cfif>">
								<cfsavecontent variable="message20"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='132.Sorumlu'> !</cfsavecontent>
								<cfif isdefined("attributes.assetp_id") and len(attributes.assetp_id) and isdefined("get_vehicles.position_code") and len(get_vehicles.position_code)>
									<cfinput type="text" name="employee_name" value="#get_emp_info(get_vehicles.position_code,1,0)#" required="yes" message="#message20#" readonly><!--- <cfelseif len(get_vehicles.company_partner_id)>#get_par_info(get_vehicles.company_partner_id,0,0,0)# ---> 
								<cfelse>
									<cfinput type="text" name="employee_name" value="" required="yes" message="#message20#" readonly> 
								</cfif>
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_fuel.employee_id&field_name=add_fuel.employee_name&select_list=1&branch_related</cfoutput>')"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-department">
						<label class="col col-4 col-xs-12"><cf_get_lang no='170.Kullanıcı Şube'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="department_id" id="department_id" value="<cfif isdefined("get_vehicles.department_id") and len(get_vehicles.department_id)><cfoutput>#get_vehicles.department_id#</cfoutput></cfif>">
								<cfif isdefined("get_vehicles.department_id") and len(get_vehicles.department_id)>
									<cfinput type="text" name="department" value="#get_branchs_deps.branch_name# - #get_branchs_deps.department_head#" message="Şube Seçiniz !" readonly>
								<cfelse>
									<cfinput type="text" name="department" message="Şube Seçiniz !" readonly>
								</cfif> 
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=add_fuel.department_id&field_dep_branch_name=add_fuel.department');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-fuel_amount">
						<label class="col col-4 col-xs-12"><cf_get_lang no='388.Yakıt Miktarı'> (Lt) *</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message25"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='388.Yakıt Miktarı'> !</cfsavecontent>
							<cfinput type="text" name="fuel_amount" maxlength="500" required="yes" message="#message25#" onKeyup="return(FormatCurrency(this,event));">
						</div>
					</div>
				</div>
				<div class="col col-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-total_amount">
						<label class="col col-4 col-xs-12"><cf_get_lang no='243.KDV li Toplam Tutar'></label>
						<div class="col col-8 col-xs-12">
							<div class="col col-9 col-xs-12">
								<cfinput name="total_amount" type="text" class="col col-6 col-xs-12 moneybox" onKeyup="return(FormatCurrency(this,event));">
							</div>
							<div class="col col-3 col-xs-12">
								<select name="total_currency" id="total_currency" class="col col-4 col-xs-12">
									<cfoutput query="get_money"> 
										<option value="#money#"<cfif money eq session.ep.money>selected</cfif>>#money#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-fuel_comp_name">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='2320.Yakıt Şirketi'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input name="fuel_comp_id" id="fuel_comp_id" type="hidden" value="">
								<cfinput type="text" name="fuel_comp_name" readonly required="yes" message="Yakıt Şirketi Seçmelisiniz !"> 
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=add_fuel.fuel_comp_id&field_comp_name=add_fuel.fuel_comp_name&is_buyer_seller=1&select_list=2')"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-get_fuel_type">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='2316.Yakıt Tipi'> *</label>
						<div class="col col-8 col-xs-12">
							<select name="fuel_type_id" id="fuel_type_id">
							<option value=""></option>
							<cfoutput query="get_fuel_type"> 
								<option value="#fuel_id#">#fuel_name#</option>
							</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-get_document_type">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='1121.Belge Tipi'> *</label>
						<div class="col col-8 col-xs-12">
							<select name="document_type_id" id="document_type_id">
							<option value=""></option>
							<cfoutput query="get_document_type"> 
								<option value="#document_type_id#">#document_type_name#</option>
							</cfoutput> 
							</select>
						</div>
					</div>
					<div class="form-group" id="item-document_num">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='468.Belge No'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="document_num" id="document_num" maxlength="500">
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0'  is_cancel='0' is_reset='1' add_function='kontrol()'>
			</cf_box_footer>
		</cfform>
	</cf_box> 
 </div>  
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
