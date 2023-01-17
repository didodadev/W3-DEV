<!--- Fazla mesai xml --->
<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
<cfset get_day_control = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.list_ext_worktimes',
    property_name : 'is_day_control'
    )
>
<!--Muzaffer Bas-->
<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
    <cfset Akdi_Gun_FM = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.form_upd_program_parameters',
    property_name : 'x_akdi_day_work'
    )>
	<cfset x_akdi_day_work = Akdi_Gun_FM.PROPERTY_VALUE>

	<cfset Hafta_tatili_FM = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.form_upd_program_parameters',
    property_name : 'x_weekly_day_work'
    )>
	<cfset x_weekly_day_work = Hafta_tatili_FM.PROPERTY_VALUE>

	<cfset Resmi_Tatil_Gun = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.form_upd_program_parameters',
    property_name : 'x_official_day_work'
    )>
	<cfset x_official_day_work = Resmi_Tatil_Gun.PROPERTY_VALUE>

	<cfset Arefe_Gun_FM = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.form_upd_program_parameters',
    property_name : 'x_Arefe_day_work'
    )>
	<cfset x_Arefe_day_work = Arefe_Gun_FM.PROPERTY_VALUE>

	<cfset Dini_Gun_FM = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.form_upd_program_parameters',
    property_name : 'x_Dini_day_work'
    )>
	<cfset x_Dini_day_work = Dini_Gun_FM.PROPERTY_VALUE>
<!--Muzaffer Bit-->
<cfif get_day_control.recordcount>
	<cfset is_day_control = get_day_control.property_value>
<cfelse>
	<cfset is_day_control = 0>
</cfif>
<cf_catalystHeader>
<div class="col col-12 col-xs-12">	
	<cf_box>
		<cfform name="add_worktime" action="#request.self#?fuseaction=ehesap.emptypopup_add_ext_worktime" method="post">	
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-employee_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57576.Çalışan'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfif isDefined("attributes.employee_id") and isdefined("attributes.in_out_id")>
									<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
									<input type="hidden" name="in_out_id" id="in_out_id" value="<cfoutput>#attributes.in_out_id#</cfoutput>">
									<cfinclude template="../query/get_hr_name.cfm">
									<input type="hidden" name="EMPLOYEE" id="EMPLOYEE" value="<cfoutput>#get_hr_name.employee_name# #get_hr_name.employee_surname#</cfoutput>">
									<cfoutput><b>#get_hr_name.employee_name# #get_hr_name.employee_surname#</b></cfoutput>
								<cfelse>
									<input type="hidden" name="employee_id" id="employee_id" value="">
									<input type="hidden" name="in_out_id" id="in_out_id" value="">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57576.Çalışan'></cfsavecontent>
									<cfinput name="EMPLOYEE" id="EMPLOYEE" type="text" required="yes" message="#message#" readonly="yes">
									<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emp_in_out&field_in_out_id=add_worktime.in_out_id&field_emp_name=add_worktime.EMPLOYEE&field_emp_id=add_worktime.employee_id&is_active=1');"></span>
								</cfif>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-process_stage">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'>*</label>
						<div class="col col-8 col-xs-12">
							<cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
						</div>
					</div>
					<div class="form-group" id="item-Shift_Status">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30866.Mesai'><cf_get_lang dictionary_id='42004.Karşılığı'></label>
						<div class="col col-8 col-xs-12">                   
							<select name="Shift_Status" id="Shift_Status" onchange="tik();">
								<option value=""><cf_get_lang Dictionary_id='57734.Seçiniz'></option>
								<option value="1"><cf_get_lang dictionary_id='63585.Serbest Zaman'></option>
								<option value="2"><cf_get_lang dictionary_id='59683.Ucret eklensin'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-Working_Location">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='32327.Çalışmak istediği yer'></label>
						<div class="col col-8 col-xs-12">                   
							<select name="Working_Location" id="Working_Location">
								<option value=""><cf_get_lang Dictionary_id='57734.Seçiniz'></option>
								<option value="1"><cf_get_lang Dictionary_id='38672.Kurum İçi'></option>
								<option value="2"><cf_get_lang dictionary_id='38449.Kurum Dışı'><cf_get_lang dictionary_id='38447.Şehir İçi'></option>
								<option value="3"><cf_get_lang dictionary_id='38449.Kurum Dışı'><cf_get_lang dictionary_id='38448.Yurt İçi'></option>
								<option value="4"><cf_get_lang dictionary_id='38449.Kurum Dışı'><cf_get_lang dictionary_id='39476.Yurt Dışı'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-work_startdate">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55753.Çalışma Günü'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="work_startdate" id="work_startdate" value="" maxlength="10" validate="#validate_style#" message="#getLang('','Çalışma Günü',55753)#" required="yes">
								<span class="input-group-addon">
									<cfif is_day_control eq 1>
										<cf_wrk_date_image date_field="work_startdate" call_function="control">
									<cfelse>
										<cf_wrk_date_image date_field="work_startdate">
									</cfif>
								</span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-startdate">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60723.Bordro Tarihi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='60723.Bordro Tarihi'></cfsavecontent>
								<cfinput type="text" name="startdate" id="startdate" value="" maxlength="10" validate="#validate_style#" message="#message#" required="yes">
								<span class="input-group-addon">
									<cf_wrk_date_image date_field="startdate">
								</span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-start_hour">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57501.Başlangıç'></label>
						<div class="col col-4 col-xs-12">
							<cf_wrkTimeFormat name="start_hour" value="0">
						</div>
						<div class="col col-4 col-xs-12">
							<select name="start_min" id="start_min">
								<option value="0"><cf_get_lang dictionary_id='58827.Dk'></option>
								<cfloop from="1" to="59" index="i">
									<cfoutput>
									<option value="#i#">#i#</option>
									</cfoutput>
								</cfloop>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-end_hour">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57502.Bitiş'></label>
						<div class="col col-4 col-xs-12">
							<cf_wrkTimeFormat name="end_hour" value="0">
						</div>
						<div class="col col-4 col-xs-12">
							<select name="end_min" id="end_min">
								<option value="0"><cf_get_lang dictionary_id='58827.Dk'></option>
								<cfloop from="1" to="59" index="i">
									<cfoutput>
									<option value="#i#">#i#</option>
									</cfoutput>
								</cfloop>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-day_type1">
						<label class="col col-4 col-xs-12"></label>
						<div class="col col-8 col-xs-12">
							<input type="radio" name="day_type" id="day_type" value="0" checked><cf_get_lang Dictionary_id='53727.Çalışma Günü'>
						</div>
					</div>
					<div class="form-group" id="item-day_type2">
						<label class="col col-4 col-xs-12"></label>
						<div class="col col-8 col-xs-12">
							<input type="radio" name="day_type" id="day_type" value="1"><cf_get_lang Dictionary_id='58867.Hafta Tatili'>
						</div>
					</div>
					<div class="form-group" id="item-day_type3">
						<label class="col col-4 col-xs-12"></label>
						<div class="col col-8 col-xs-12">
							<input type="radio" name="day_type" id="day_type" value="2"><cf_get_lang Dictionary_id='31473.Resmi Tatil'>
						</div>
					</div>
					<div class="form-group" id="item-day_type4">
						<label class="col col-4 col-xs-12"></label>
						<div class="col col-8 col-xs-12">
							<input type="radio" name="day_type" id="day_type" value="3"><cf_get_lang Dictionary_id='54251.Gece Çalışması'>
						</div>
					</div>
					<cfif x_akdi_day_work eq 1>
						<div class="form-group" id="item-day_type4">
							<label class="col col-4 col-xs-12"></label>
							<div class="col col-8 col-xs-12">
								<input type="radio" name="day_type" id="day_type" value="-9"><cf_get_lang dictionary_id='65393.Akdi Tatil'> - <cf_get_lang dictionary_id='57490.Gün'>
							</div>
						</div>
					</cfif>
					<cfif x_official_day_work eq 1>
						<div class="form-group" id="item-day_type4">
							<label class="col col-4 col-xs-12"></label>
							<div class="col col-8 col-xs-12">
								<input type="radio" name="day_type" id="day_type" value="-10"><cf_get_lang dictionary_id='56022.Resmi Tatil'> - <cf_get_lang dictionary_id='57490.Gün'>
							</div>
						</div>
					</cfif>
					<cfif x_Arefe_day_work eq 1>
						<div class="form-group" id="item-day_type4">
							<label class="col col-4 col-xs-12"></label>
							<div class="col col-8 col-xs-12">
								<input type="radio" name="day_type" id="day_type" value="-11"><cf_get_lang dictionary_id='65394.Arefe Tatil'> - <cf_get_lang dictionary_id='57490.Gün'>
							</div>
						</div>
					</cfif>
					<cfif x_Dini_day_work eq 1>
						<div class="form-group" id="item-day_type4">
							<label class="col col-4 col-xs-12"></label>
							<div class="col col-8 col-xs-12">
								<input type="radio" name="day_type" id="day_type" value="-12"><cf_get_lang dictionary_id='65395.Dini Bayram'> - <cf_get_lang dictionary_id='57490.Gün'>	
							</div>
						</div>
					</cfif>
					<div class="form-group" id="item-valid_detail">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="valid_detail" id="valid_detail" style="width:150px;height:60px;"></textarea>
						</div>
					</div>
					<div class="form-group" id="item-is_puantaj_off">
						<label class="col col-4 col-xs-12"></label>
						<div class="col col-8 col-xs-12">
							<input type="checkbox" value="1" name="is_puantaj_off" id="is_puantaj_off"><cf_get_lang no ='716.Puantajda Görüntülenmesin'>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>	
				<cf_workcube_buttons is_upd='0' add_function='check_()'>
			</cf_box_footer>		
		</cfform>
	</cf_box>
</div>	
	
<script type="text/javascript">
	function myfisherdatefixer(date) { let d = date.split('/'); return d[1]+'/'+d[0]+'/'+d[2]; } 
	function tik()
	{
		if (document.getElementById('Shift_Status').value == 1)
		{  
			document.getElementById('is_puantaj_off').checked = true;
		}
		else
		{
			document.getElementById('is_puantaj_off').checked = false;
		}
		
	}

	function check_()
	{
		if (document.getElementById('start_hour').value > document.getElementById('end_hour').value)
		{
			alert("<cf_get_lang dictionary_id='53594.Başlangıç Saati Bitiş saatinden büyük olamaz'> !");
			return false;
		}
		else if ((document.getElementById('start_hour').value == document.getElementById('end_hour').value) && (document.getElementById('start_min').value >= document.getElementById('end_min').value))
		{
			alert("<cf_get_lang dictionary_id='53595.Başlangıç Saati Bitiş saatinden büyük veya eşit olamaz'> !");
			return false;
		}
		<cfif attributes.fuseaction neq 'ehesap.list_ext_worktimes'>
		return process_cat_control();
		<cfelse>
		return true;
		</cfif>
	}
	function control()
	{
		startdate = $("#work_startdate").val();
		parameters = startdate;
		
		//Hafta Sonu Kontrolü
		startdate_format = myfisherdatefixer( $("#work_startdate").val());
		date_format = new Date(startdate_format);
		dayofweek = date_format.getDay();

		//Resmi Tatil Kontrolü
		get_shift_conflict = wrk_safe_query('get_general_offtimes','dsn',0,parameters);

		//Vardiya Kontrolü
        is_shift_holiday = 0;
        employee_id = $("#employee_id").val();
        startdate = $("#work_startdate").val();
        finishdate = $("#work_startdate").val();
        is_shift_holiday = shift_holiday_control(employee_id, startdate,finishdate);

		if(get_shift_conflict.recordcount > 0)
		{
			$("input[name=day_type][value=2]").prop("checked", true);
		}
		else if(((dayofweek == 6 || dayofweek == 0) && is_shift_holiday == 0) || is_shift_holiday == 1)
		{
			$("input[name=day_type][value=1]").prop("checked", true);
		}
		else
		{
			$("input[name=day_type][value=0]").prop("checked", true);
		}     
	}
</script>
