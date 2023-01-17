
<!---BU SAYFA HEM POPUP HEM BASKET OLARAK ÇAĞRILDIĞI İÇİN BASKETE GÖRE DÜZENLENMİŞTİR.--->
<!---E.A 17 temmuz 2012 select ifadeleriyle alakalı işlem uygulanmıştır.--->
<style type="text/css">
	.DynarchCalendar-topCont  {
		top:0% !important;
		margin-left:250px;
	}
</style>
<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_accident_upd.cfm">
<cfinclude template="../query/get_accident_type.cfm">
<cfinclude template="../query/get_money.cfm">
<cfinclude template="../query/get_fault_ratio.cfm">
<cfinclude template="../query/get_document_type.cfm">
<cfquery name="get_punishment" datasource="#dsn#">
	SELECT PUNISHMENT_ID FROM ASSET_P_PUNISHMENT WHERE ACCIDENT_ID = #attributes.accident_id#
</cfquery>

		<form name="upd_accident" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.emptypopup_upd_accident">
			<cf_box name="frame_accident" id="frame_accident" title="#getLang('','Kaza Güncelle',48316)#">

			<input type="hidden" name="accident_id" id="accident_id" value="<cfoutput>#attributes.accident_id#</cfoutput>">
			<input type="hidden" name="today_value_" id="today_value_" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">
					<cf_box_elements>
						<div class="col col-12" type="column" index="1" sort="true">

						<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">

							<div class="form-group" id="item-fuel_num">
								<label class="col col-4 col-xs-12"><cf_get_lang no='390.Kayıt No'></label>
								<div class="col col-6 col-xs-12">
									<input type="text" name="accident_num" id="accident_num" value="<cfoutput>#get_accident_upd.accident_id#</cfoutput>"readonly>
								</div>
							</div>

							<div class="form-group" id="item-assetp_name">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='1656.Plaka'></label>
								<div class="col col-6 col-xs-12">
									<div class="input-group">
									<input type="hidden" name="assetp_id"  id="assetp_id" value="<cfoutput>#get_accident_upd.assetp_id#</cfoutput>">
			  					<input type="text" name="assetp_name" id="assetp_name" value="<cfoutput>#get_accident_upd.assetp#</cfoutput>" maxlength="50"  readonly>
									<span class="input-group-addon icon-ellipsis"onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=upd_accident.assetp_id&field_name=upd_accident.assetp_name&field_dep_name=upd_accident.department&field_dep_id=upd_accident.department_id&field_emp_id=upd_accident.employee_id&field_emp_name=upd_accident.employee_name&list_select=2&is_active=1','list','popup_list_ship_vehicles');"></span>
									</div>
								</div>
							</div>

							<div class="form-group" id="item-employee_name">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='132.Sorumlu'></label>
								<div class="col col-6 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_accident_upd.employee_id#</cfoutput>">
										<input type="text" name="employee_name" id="employee_name" value="<cfoutput>#get_emp_info(get_accident_upd.employee_id,0,0)#</cfoutput>" readonly>
										<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=upd_accident.employee_id&field_name=upd_accident.employee_name&select_list=1&branch_related</cfoutput>','list','popup_list_positions')"></span>
									</div>
								</div>
							</div>

							<div class="form-group" id="item-department">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='41.Şube'></label>
								<div class="col col-6 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="department_id" id="department_id" value="<cfoutput>#get_accident_upd.department_id#</cfoutput>">
										<input type="text" name="department" id="department" value="<cfoutput>#get_accident_upd.branch_name# - #get_accident_upd.department_head#</cfoutput>" readonly>
										<span class="input-group-addon icon-ellipsis"  onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=upd_accident.department_id&field_dep_branch_name=upd_accident.department','list','popup_list_departments');"></span>
									</div>
								</div>
							</div>

							<div class="form-group" id="item-accident_date">
								<label class="col col-4 col-xs-12"><cf_get_lang no='395.Kaza Tarihi'></label>
								<div class="col col-6 col-xs-12">
									<div class="input-group">
										<input type="text" name="accident_date" id="accident_date" value="<cfoutput>#dateformat(get_accident_upd.accident_date,dateformat_style)#</cfoutput>" maxlength="10" >
										<span class="input-group-addon"><cf_wrk_date_image date_field="accident_date"></span>
									</div>
								</div>
							</div>

						</div>
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">

							<div class="form-group" id="item-accident_type_id">
								<label class="col col-4 col-xs-12"><cf_get_lang no='397.Kaza Tipi'></label>
								<div class="col col-6 col-xs-12">
									<select name="accident_type_id" id="accident_type_id">
										<option value=""></option>
										<cfoutput query="get_accident_type">
										<option value="#accident_type_id#" <cfif accident_type_id eq get_accident_upd.accident_type_id>selected</cfif>>#accident_type_name#</option>
										</cfoutput>
									</select>
								</div>
							</div>

							<div class="form-group" id="item-fault_ratio_id">
								<label class="col col-4 col-xs-12"><cf_get_lang no='398.Kusur Oranı'></label>
								<div class="col col-6 col-xs-12">
									<select name="fault_ratio_id" id="fault_ratio_id">
										<option value=""></option>
										<cfoutput query="get_fault_ratio">
										<option value="#fault_ratio_id#" <cfif fault_ratio_id eq get_accident_upd.fault_ratio_id>selected</cfif>>#fault_ratio_name#</option>
										</cfoutput>
									</select>
								</div>
							</div>

							<div class="form-group" id="item-document_type_id">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='1121.Belge Tipi'></label>
								<div class="col col-6 col-xs-12">
									<select name="document_type_id" id="document_type_id">
										<option value=""></option>
										<cfoutput query="get_document_type">
										<option value="#document_type_id#" <cfif document_type_id eq get_accident_upd.document_type_id>selected</cfif>>#document_type_name#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							

							<div class="form-group" id="item-document_num">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='468.Belge No'></label>
								<div class="col col-6 col-xs-12">
									<input name="document_num" id="document_num" type="text" maxlength="20" value="<cfoutput>#get_accident_upd.document_num#</cfoutput>">
								</div>
							</div>

							<div class="form-group" id="item-insurance_payment">
								<label class="col col-4 col-xs-12"><cf_get_lang no='399.Sigorta Ödemesi'></label>
								<div class="col col-6 col-xs-12">
									<input type="checkbox" name="insurance_payment" id="insurance_payment" value="1" <cfif get_accident_upd.insurance_payment eq 1>checked</cfif>>
								</div>
							</div>

							<div class="form-group" id="item-document_num">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
								<div class="col col-6 col-xs-12">
									<textarea name="accident_detail" id="accident_detail" ><cfoutput>#get_accident_upd.accident_detail#</cfoutput></textarea>
								</div>
							</div>
							
						</div>
					</div>
					<div class="col col-12" type="column" index="2" sort="true">

						<div class="col col-12" type="column" index="3" sort="true">
								<cf_get_workcube_asset asset_cat_id="-23" module_id='40' action_section='ACCIDENT_ID' action_id='#attributes.accident_id#'>
						</div>
						</div>
					</cf_box_elements>

				<cf_box_footer>
					<cf_record_info query_name="GET_ACCIDENT_UPD">
					<cfif get_punishment.recordCount>
						<cf_workcube_buttons is_upd='1' is_cancel='0' is_reset='0' is_delete='0' add_function='kontrol()'>
					<cfelse>
						<cf_workcube_buttons is_upd='1' is_cancel='0' is_reset='0' is_delete='1' delete_page_url='#request.self#?fuseaction=assetcare.emptypopup_del_accident&accident_id=#attributes.accident_id#' add_function='kontrol()'>
					</cfif>
				</cf_box_footer>

	</cf_box>
		</form>

<script type="text/javascript">
	function kontrol()
	{
		if(document.upd_accident.accident_date.value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='395.Kaza Tarihi'>!");
			return false;
		}
		
		if(!CheckEurodate(upd_accident.accident_date.value,'<cf_get_lang no ="395.Kaza Tarihi">'))
		{
			return false;
		}
		
		x = document.upd_accident.accident_type_id.selectedIndex;
		if (document.upd_accident.accident_type_id[x].value == "")
		{ 
			alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='397.Kaza Tipi'>!");
			return false;
		}
				
		tarih1_ = upd_accident.accident_date.value.substr(6,4) + upd_accident.accident_date.value.substr(3,2) + upd_accident.accident_date.value.substr(0,2);
		tarih2_ = upd_accident.today_value_.value.substr(6,4) + upd_accident.today_value_.value.substr(3,2) + upd_accident.today_value_.value.substr(0,2);
		if((upd_accident.accident_date.value != "") && (tarih1_ > tarih2_))
		{
			alert("Kaza Tarihi Bugünden Büyük Olamaz!");
			return false;
		}	

		
		if(document.upd_accident.accident_detail.value.length > 1000)
		{
			alert("<cf_get_lang_main no='13.uyarı'>:<cf_get_lang no ='2.en fazla 1000 Karakter'>!");
			return false;
		}
		return true;
	}
</script>
