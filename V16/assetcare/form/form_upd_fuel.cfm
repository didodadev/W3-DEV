<cfinclude template="../query/get_fuel_upd.cfm">
<cfinclude template="../query/get_fuel_type.cfm">
<cfinclude template="../query/get_document_type.cfm">
<cfinclude template="../query/get_money.cfm">
<cfset pageHead="#getLang('assetcare',393)# : #getLang('main',1656)# : #get_fuel_upd.assetp# ">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="upd_fuel" action="#request.self#?fuseaction=assetcare.emptypopup_upd_fuel" method="post">
			<input name="fuel_id" id="fuel_id" type="hidden" value="<cfoutput>#attributes.fuel_id#</cfoutput>">
			<input name="is_detail" id="is_detail" type="hidden" value="1">
			<cf_box_elements>
				<div class="col col-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-fuel_num">	
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='75.No'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="fuel_num" id="fuel_num" value="<cfoutput>#get_fuel_upd.fuel_id#</cfoutput>" readonly>
						</div>
					</div>
					<div class="form-group" id="item-assetp_id">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='1656.Plaka'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#get_fuel_upd.assetp_id#</cfoutput>"> 
								<input type="text" name="assetp_name" id="assetp_name" readonly style="width:160px;" value="<cfoutput>#get_fuel_upd.assetp#</cfoutput>"> 
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=upd_fuel.assetp_id&field_name=upd_fuel.assetp_name&field_dep_id=upd_fuel.department_id&field_dep_name=upd_fuel.department&field_emp_id=upd_fuel.employee_id&field_emp_name=upd_fuel.employee_name&list_select=2&is_active=1');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-employee_name">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='132.Sorumlu'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input name="employee_id" id="employee_id" value="<cfoutput>#get_fuel_upd.employee_id#</cfoutput>" type="hidden"> 
								<input type="text" name="employee_name" id="employee_name" value="<cfoutput>#get_emp_info(get_fuel_upd.employee_id,0,0)#</cfoutput>" readonly reqired="yes" message="#message20#"style="width:160px;"> 
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=upd_fuel.employee_id&field_name=upd_fuel.employee_name&select_list=1</cfoutput>')"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-department">
						<label class="col col-4 col-xs-12"><cf_get_lang no='170.Kullanıcı Şube'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif get_fuel_upd.department_id neq "">
									<cfquery name="get_dep" datasource="#dsn#">
										SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_fuel_upd.department_id#">
									</cfquery>
									<cfset dept_name = get_dep.department_head>
								<cfelse>
									<cfset dept_name = "">
								</cfif>
								<input type="hidden" name="department_id" id="department_id" value="<cfoutput>#get_fuel_upd.department_id#</cfoutput>"> 
								<input type="text" name="department" id="department" value="<cfoutput>#dept_name#</cfoutput>" readonly style="width:160px;"> 
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=upd_fuel.department_id&field_name=upd_fuel.department');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-fuel_date">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='467.İşlem Tarihi'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="text" name="fuel_date" id="fuel_date" value="<cfoutput>#dateformat(get_fuel_upd.fuel_date,dateformat_style)#</cfoutput>" style="width:160px;"> 
								<span class="input-group-addon"><cf_wrk_date_image date_field="fuel_date"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-fuel_comp_id">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='2320.Yakıt Şirketi'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input name="fuel_comp_id" id="fuel_comp_id" type="hidden" value="<cfoutput>#get_fuel_upd.fuel_company_id#</cfoutput>"> 
								<input type="text" name="fuel_comp_name" id="fuel_comp_name" value="<cfoutput>#get_fuel_upd.fullname#</cfoutput>" readonly style="width:160px;"> 
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=upd_fuel.fuel_comp_id&field_comp_name=upd_fuel.fuel_comp_name&is_buyer_seller=1&select_list=2</cfoutput>')"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-fuel_type_id">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='2316.Yakıt Tipi'> *</label>
						<div class="col col-8 col-xs-12">
							<select name="fuel_type_id" id="fuel_type_id" style="width:160px;">
								<option value=""></option>
								<cfoutput query="get_fuel_type">
									<option value="#fuel_id#" <cfif fuel_id eq get_fuel_upd.fuel_type_id>selected</cfif>>#fuel_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-document_type_id">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='1121.Belge Tipi'> *</label>
						<div class="col col-8 col-xs-12">
							<select name="document_type_id" id="document_type_id" style="width:160px">
								<option value=""></option>
								<cfoutput query="get_document_type">
									<option value="#document_type_id#" <cfif document_type_id eq get_fuel_upd.document_type_id>selected</cfif>>#document_type_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-document_num">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='468.Belge No'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="document_num" id="document_num" value="<cfoutput>#get_fuel_upd.document_num#</cfoutput>" style="width:160px;">
						</div>
					</div>
					<div class="form-group" id="item-fuel_amount">
						<label class="col col-4 col-xs-12"><cf_get_lang no='388.Yakıt Miktarı'> *</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="fuel_amount" id="fuel_amount" value="<cfoutput>#tlformat(get_fuel_upd.fuel_amount)#</cfoutput>" onKeyup="return(FormatCurrency(this,event));" style="width:160px;">
						</div>
					</div>
					<div class="form-group" id="item-document_num">
						<label class="col col-4 col-xs-12"><cf_get_lang no='243.KDV li Toplam Tutar'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="text" name="total_amount" id="total_amount" style="width:110px;" value="<cfoutput>#tlFormat(get_fuel_upd.total_amount)#</cfoutput>" onKeyup="return(FormatCurrency(this,event));"> 
								<span class="input-group-addon">
									<select name="total_currency" id="total_currency" style="width:48px;">
										<cfoutput query="get_money"> 
											<option value="#money#" <cfif money eq get_fuel_upd.total_currency>selected</cfif>>#money#</option>
										</cfoutput>
									</select>
								</span>
							</div>
						</div>
					</div>
				</div>	
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons type_format="1" is_upd='1' is_cancel='0'  delete_page_url='#request.self#?fuseaction=assetcare.emptypopup_del_fuel&fuel_id=#attributes.fuel_id#&plaka=#get_fuel_upd.assetp#&is_detail=1&is_popup=0' add_function='kontrol()'>
			</cf_box_footer>
		</cfform>
	</cf_box> 
 </div>
<script type="text/javascript">
function unformat_fields()
{
	document.upd_fuel.fuel_amount.value = filterNum(document.upd_fuel.fuel_amount.value);
	document.upd_fuel.total_amount.value = filterNum(document.upd_fuel.total_amount.value);
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
	unformat_fields();
	
	return true;
}
</script> 
