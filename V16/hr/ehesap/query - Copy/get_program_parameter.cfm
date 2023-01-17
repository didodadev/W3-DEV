<cfset cmp = createObject("component","V16.hr.ehesap.cfc.get_program_parameters")>
<cfset cmp.dsn = dsn/>

<cfif isdefined("attributes.sal_mon") and isdefined("attributes.sal_year")>
	<cfscript>
		parameter_last_month_1 = CreateDateTime(attributes.sal_year,attributes.sal_mon,1,0,0,0);
		parameter_last_month_30 = CreateDateTime(attributes.sal_year,attributes.sal_mon,daysinmonth(createdate(attributes.sal_year,attributes.sal_mon,1)),23,59,59);
	</cfscript>
	<cfif isdefined("attributes.branch_id") and not isdefined("attributes.group_id")>
	<cfset get_program_parameters = cmp.get_program_parameter(
									start_:parameter_last_month_1,
									finish_:parameter_last_month_30,
									branch_id:attributes.branch_id)>
	<cfelseif isdefined("attributes.branch_id") and isdefined("attributes.group_id") and len(attributes.group_id)>
	<cfset get_program_parameters = cmp.get_program_parameter(
									start_:parameter_last_month_1,
									finish_:parameter_last_month_30,
									branch_id:attributes.branch_id,
									group_id:attributes.group_id)>
	
	<cfelseif isdefined("attributes.branch_id") and len(attributes.branch_id)>
		<cfset get_program_parameters = cmp.get_program_parameter(
										start_:parameter_last_month_1,
										finish_:parameter_last_month_30,
										branch_id:attributes.branch_id)>							
	<cfelse>
		<cfset get_program_parameters = cmp.get_program_parameter(
									start_:parameter_last_month_1,
									finish_:parameter_last_month_30,
									group_id : isdefined("attributes.group_id") ? attributes.group_id : ""
									)>
	</cfif>
<cfelse>
	<cfset get_program_parameters = cmp.get_program_parameter()>
</cfif>
<cfif not isdefined("not_kontrol_parameter") and attributes.fuseaction neq "ehesap.form_upd_program_parameters" and (not isdefined("get_program_parameters.recordcount") or not get_program_parameters.recordcount)>
	<cfif isdefined("from_step_payroll") and len(from_step_payroll)>
		<cfif isdefined("GET_SSK_EMPLOYEES.employee_name")>
			<cfset pp_error = "Seçtiğiniz Tarihi Kapsayan Program Akış Parametresi Bulunamamıştır! Lütfen Program Akış Parametrelerini Giriniz! Çalışan : #GET_SSK_EMPLOYEES.employee_name# #GET_SSK_EMPLOYEES.employee_surname#">
		<cfelse>
			<cfset pp_error = "Seçtiğiniz Tarihi Kapsayan Program Akış Parametresi Bulunamamıştır! Lütfen Program Akış Parametrelerini Giriniz'>!">
		</cfif>
	<cfelse>
		<script type="text/javascript">
			<cfoutput>
				<cfif isdefined("GET_SSK_EMPLOYEES.employee_name")>
					alert("<cf_get_lang dictionary_id ='58748.Seçtiğiniz Tarihi Kapsayan Program Akış Parametresi Bulunamamıştır! Lütfen Program Akış Parametrelerini Giriniz'>! \n\n Çalışan : #GET_SSK_EMPLOYEES.employee_name# #GET_SSK_EMPLOYEES.employee_surname#");
				<cfelse>
					alert("<cf_get_lang dictionary_id ='58748.Seçtiğiniz Tarihi Kapsayan Program Akış Parametresi Bulunamamıştır! Lütfen Program Akış Parametrelerini Giriniz'>!");
				</cfif>
			</cfoutput>
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfif len(get_program_parameters.cast_style)>
	<cfset this_cast_style_ = get_program_parameters.cast_style>
<cfelse>
	<cfset this_cast_style_ = 0>
</cfif>
