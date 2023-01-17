<cfinclude template="../query/get_money.cfm">
<cfinclude template="../query/get_punishment_type.cfm">
<cfquery name="GET_ACCIDENT" datasource="#dsn#">
	SELECT
		ASSET_P.ASSETP,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		ASSET_P_ACCIDENT.ACCIDENT_ID,
		ASSET_P_ACCIDENT.EMPLOYEE_ID,
		ASSET_P_ACCIDENT.DEPARTMENT_ID,
		ASSET_P_ACCIDENT.ACCIDENT_DATE,
		ASSET_P_ACCIDENT.ASSETP_ID,
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_HEAD
	FROM
		ASSET_P_ACCIDENT,
		ASSET_P,
		EMPLOYEES,
		BRANCH,
		DEPARTMENT
	WHERE
		ASSET_P_ACCIDENT.ACCIDENT_ID = #attributes.accident_id# AND
		ASSET_P.ASSETP_ID = ASSET_P_ACCIDENT.ASSETP_ID AND
		EMPLOYEES.EMPLOYEE_ID = ASSET_P_ACCIDENT.EMPLOYEE_ID AND
		ASSET_P_ACCIDENT.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
</cfquery>

<cf_box title="#getLang('','Ceza Kayıt',48021)# #get_accident.assetp# - #dateformat(get_accident.accident_date,dateformat_style)# #getLang('assetcare',450)#">

			<form name="add_punishment" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.emptypopup_add_punishment&is_detail" onSubmit="return unformat_fields();">
				<input type="hidden" name="accident_id" id="accident_id" value="<cfoutput>#attributes.accident_id#</cfoutput>">
				<input type="hidden" name="accident_date" id="accident_date" value="<cfoutput>#dateformat(get_accident.accident_date,dateformat_style)#</cfoutput>">
				<input type="hidden" name="is_detail" id="is_detail" value="1">
  				<cf_box_elements>
				
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">


							<div class="form-group" id="item-assetp_id">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='1656.Plaka'></label>
								<div class="col col-6 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="assetp_id"  id="assetp_id" value="<cfoutput>#get_accident.assetp_id#</cfoutput>"> 
										<input type="text" name="assetp_name" id="assetp_name" value="<cfoutput>#get_accident.assetp#</cfoutput>" readonly style="width:145px;"> 
										<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=add_punishment.assetp_id&field_name=add_punishment.assetp_name','list','popup_list_ship_vehicles');"></span>
									</div>
								</div>
							</div>

							<div class="form-group" id="item-employee_id">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='132.Sorumlu'></label>
								<div class="col col-6 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#get_accident.employee_id#</cfoutput>"> 
										<input type="text" name="employee_name" id="employee_name" value="<cfoutput>#get_accident.employee_name# #get_accident.employee_surname#</cfoutput>" style="width:145px;"> 
										<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=add_punishment.employee_id&field_name=add_punishment.employee_name&select_list=1','list','popup_list_positions');"></span>
									</div>
								</div>
							</div>

							<div class="form-group" id="item-department_id">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='41.Şube'></label>
								<div class="col col-6 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="department_id" id="department_id" value="<cfoutput>#get_accident.department_id#</cfoutput>"> 
										<input type="text" name="department" id="department" value="<cfoutput>#get_accident.branch_name# - #get_accident.department_head#</cfoutput>" readonly style="width:145px;"> 
										<span class="input-group-addon icon-ellipsis"onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=add_punishment.department_id&field_name=add_punishment.department','list','popup_list_departments');"></span>
									</div>
								</div>
							</div>

							<div class="form-group" id="item-punishment_type_id">
								<label class="col col-4 col-xs-12"><cf_get_lang no='414.Ceza Tipi'></label>
								<div class="col col-6 col-xs-12">
									<select name="punishment_type_id" id="punishment_type_id" style="width:145px;">
										<option value=""></option>
										<cfoutput query="get_punishment_type"> 
											<option value="#punishment_type_id#">#punishment_type_name#</option>
										</cfoutput>
									</select>
								</div>
							</div>

							<div class="form-group" id="item-receipt_num">
								<label class="col col-4 col-xs-12"><cf_get_lang no='415.Makbuz No'></label>
								<div class="col col-6 col-xs-12">
									<input type="text" name="receipt_num" id="receipt_num" value="" maxlength="100" style="width:145px;">
								</div>
							</div>

							<div class="form-group" id="item-punishment_date">
								<label class="col col-4 col-xs-12"><cf_get_lang no='416.Ceza Tarihi'></label>
								<div class="col col-6 col-xs-12">
									<div class="input-group">
										<input type="text" name="punishment_date" id="punishment_date" value="" maxlength="10" style="width:145px;"> 
										<span class="input-group-addon"><cf_wrk_date_image date_field="punishment_date"></span>
									</div>
								</div>
							</div>

					</div>

					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="2" type="column" sort="true">

							<div class="form-group" id="item-punishment_amount">
								<label class="col col-4 col-xs-12"><cf_get_lang no='417.Ceza Tutarı'></label>
								
									<div class="col col-5 col-xs-12">
										<input type="text" name="punishment_amount" id="punishment_amount" style="width:94px;" value="" onKeyup="return FormatCurrency(this,event);"> 
									</div>
									<div class="col col-3 col-xs-12">
										<span>
											<select name="punishment_amount_currency" id="punishment_amount_currency" style="width:48px;">
											<cfoutput query="get_money"> 
												<option value="#money#">#money#</option>
											</cfoutput>
											</select>
										</span>
									</div>

							</div>

							<div class="form-group" id="item-last_payment_date">
								<label class="col col-4 col-xs-12"><cf_get_lang no='185.Son Ödeme Tarihi'></label>
								<div class="col col-6 col-xs-12">
									<div class="input-group">
										<input type="text" name="last_payment_date" id="last_payment_date" value="" maxlength="10" style="width:145px;"> 
										<span class="input-group-addon"><cf_wrk_date_image date_field="last_payment_date"></span>
									</div>
								</div>
							</div>

							<div class="form-group" id="item-paid_amount">
								<label class="col col-4 col-xs-12"><cf_get_lang no='418.Ödenen Tutar'></label>
									<div class="col col-5 col-xs-12">
										<input type="text" name="paid_amount" id="paid_amount"  value="" onKeyup="return FormatCurrency(this,event);"> 
									</div>
									<div class="col col-3 col-xs-12">
									<span >
											<select name="paid_amount_currency" id="paid_amount_currency" >
											<cfoutput query="get_money"> 
												<option value="#money#">#money#</option>
											</cfoutput>
										</select>
									</span>
								</div>

									
							</div>

							<div class="form-group" id="item-punishment_type_id">
								<label class="col col-4 col-xs-12"><cf_get_lang no='423.Ödenen Tarih'></label>
								<div class="col col-6 col-xs-12">
									<div class="input-group">
										<input type="text" name="paid_date" id="paid_date" value="" maxlength="10" style="width:145px;"> 
										<span class="input-group-addon"><cf_wrk_date_image date_field="paid_date"></span>
									</div>
								</div>
							</div>

							<div class="form-group" id="item-payer">
								<label class="col col-4 col-xs-12"><cf_get_lang no='424.Ödeme Yapan'></label>
								<div class="col col-4 col-xs-6">
									<input type="radio" name="payer" id="payer" value="1" checked>
									<cf_get_lang_main no='162.Firma '>
								</div>
								<div class="col col-4 col-xs-6">
									<input type="radio" name="payer" id="payer" value="2">
									<cf_get_lang_main no='2034.Kişi'>
								</div>
							</div>

							<div class="form-group" id="item-punished_license">
								<label class="col col-4 col-xs-12"><cf_get_lang no='425.Ceza Kayıtlı Belge'></label>
								<div class="col col-4 col-xs-6">
									<input type="radio" name="punished_license" id="punished_license" value="1" checked>
									<cf_get_lang no='432.Ruhsat'> 
								</div>
								<div class="col col-4 col-xs-6">
									<input type="radio" name="punished_license" id="punished_license" value="2">
									<cf_get_lang no='428.Ehliyet'>
								</div>
							</div>

					</div>

				</cf_box_elements>

					<cf_popup_box_footer>
						<cf_workcube_buttons type_format='1' is_upd='0' is_cancel='1' add_function="kontrol()">
					</cf_popup_box_footer>
			</form>
	
</cf_box>
<script type="text/javascript">
	function unformat_fields()
	{
	  	document.add_punishment.punishment_amount.value = filterNum(document.add_punishment.punishment_amount.value);
		document.add_punishment.paid_amount.value = filterNum(document.add_punishment.paid_amount.value);
	}
	
	function kontrol()
	{		
		x = document.add_punishment.punishment_type_id.selectedIndex;
		if (document.add_punishment.punishment_type_id[x].value == "")
		{ 
			alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='414.Ceza Tipi'>!");
			return false;
		}
		
		if(document.add_punishment.receipt_num.value == "") 
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='415.Makbuz No'>!");
			return false;
		}

		if(document.add_punishment.punishment_date.value == "")
		{
			alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='416.Ceza Tarihi'>!");
			return false;
		}
		
		if(!CheckEurodate(document.add_punishment.punishment_date.value,"<cf_get_lang no='416.Ceza Tarihi'>"))
			return false;
		
		if(!CheckEurodate(document.add_punishment.paid_date.value,"<cf_get_lang no='423.Ödenen Tarih'>"))
			return false;
		
		if(!CheckEurodate(document.add_punishment.last_payment_date.value,"<cf_get_lang no='185.Son Ödeme Tarihi'>"))
		{
			return false;
		}
		
		if(document.add_punishment.last_payment_date.value != "" && !date_check_hiddens(document.add_punishment.punishment_date,document.add_punishment.last_payment_date,"<cf_get_lang no='185.Son Ödeme Tarihi'><cf_get_lang no='676.Kontrol Ediniz'>!"))
			return false;

		if(document.add_punishment.paid_date.value != "" && !date_check_hiddens(document.add_punishment.punishment_date,document.add_punishment.paid_date,"<cf_get_lang no='423.Ödenen Tarih'><cf_get_lang no='676.Kontrol Ediniz'>!"))
			return false;
		
		if(!date_check_hiddens(document.add_punishment.accident_date,document.add_punishment.punishment_date,"<cf_get_lang no='677.Kaza Tarihi Ceza Tarihinden Önce Olmamalıdır'>!"))
			return false;
		return true;
	}
</script>
