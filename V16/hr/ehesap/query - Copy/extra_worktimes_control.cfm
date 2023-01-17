<!---
    Author : Esma R. Uysal <esmauysal@workcube.com>
    Date : 12.08.2020
    Description : Fazla Mesai Kontrolleri Ortak Dosya
--->
<cfset company_start_hour = timeformat('#get_hours.start_hour#:#get_hours.start_min#',timeformat_style)>
<cfset company_finish_hour = timeformat('#get_hours.end_hour#:#get_hours.end_min#',timeformat_style)>
<cfset midnight_before = timeformat('23:59',timeformat_style)>
<cfset midnight_after = timeformat('00:01',timeformat_style)>

<!--- Fazla mesai xml --->
<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
<cfset get_is_control = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.list_ext_worktimes',
    property_name : 'is_control'
    )
	>

<cfif get_is_control.recordcount and len(get_is_control.property_value) and get_is_control.property_value eq 1><!--- Esnek Çalışma, İzin ve Vardiya kontrolleri yapılsın mı? --->

	<!--- İzin --->
	<cfset get_ext_cmp = createObject("component","V16.myhome.cfc.offtimes")>
	<cfset get_offtime = get_ext_cmp.GET_OFFTIME_DATE(employee_id : attributes.employee_id, startdate : startdate, finishdate : finishdate)>

	<!--- Esnek Çalışma --->
	<cfset get_flexible_cmp = createObject("component","V16.myhome.cfc.flexible_worktime")>
	<cfset get_flexible = get_flexible_cmp.GET_WORKTIME_FLEXIBLE_ROW_DATE_CONTROL(employee_id : attributes.employee_id, startdate : startdate)>

	<!---- Vardiya --->
	<cfset get_shift_cmp = createObject("component","V16.hr.cfc.get_employee_shift")>
	<cfset start_shift = startdate_>
	<cfset finish_shift= DateAdd("d",1, startdate_)>
	
	<cfset get_shift = get_shift_cmp.get_emp_shift(employee_id : attributes.employee_id, start_date : start_shift, finish_date : finish_shift,control : 2)>

	<cfif get_flexible.recordcount gt 0>
		<cfset flexible_start_hour = timeformat('#get_flexible.FLEXIBLE_START_HOUR#:#get_flexible.FLEXIBLE_START_MINUTE#',timeformat_style)>
		<cfset flexible_finish_hour = timeformat('#get_flexible.FLEXIBLE_FINISH_HOUR#:#get_flexible.FLEXIBLE_FINISH_MINUTE#',timeformat_style)>	
	<cfelse>
		<cfset flexible_start_hour = company_start_hour>
		<cfset flexible_finish_hour = company_finish_hour>	
	</cfif>

	<cfif get_shift.recordcount gt 0>
		<cfset shift_start_hour = timeformat('#get_shift.start_hour#:#get_shift.start_min#',timeformat_style)>
		<cfset shift_finish_hour = timeformat('#get_shift.end_hour#:#get_shift.end_min#',timeformat_style)>
	<cfelse>
		<cfset shift_start_hour = company_start_hour>
		<cfset shift_finish_hour = company_finish_hour>
	</cfif>
	<cfif attributes.day_type eq 0 and get_offtime.recordcount gt 0 and ((start_hour_format gte company_start_hour and end_hour_format lte company_finish_hour) or (start_hour_format gte company_start_hour and start_hour_format lte company_finish_hour) or (end_hour_format gte company_start_hour and end_hour_format lte company_finish_hour))>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='61123.Çalışanın belirtilen saatler içerisinde izini olduğu için çalışma saatleri içinde Fazla Mesai Giremezsiniz!'>");
			window.location.href="<cfoutput>#request.self#?fuseaction=#hr#</cfoutput>";
		</script>
		<cfabort>
	<cfelseif attributes.day_type eq 0 and get_flexible.recordcount gt 0 and ((start_hour_format gte flexible_start_hour and end_hour_format lte flexible_finish_hour) or (start_hour_format gte flexible_start_hour and start_hour_format lte flexible_finish_hour) or (end_hour_format gte flexible_start_hour and end_hour_format lte flexible_finish_hour))>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='61124.Esnek Çalışma saatleri içinde Fazla Mesai Giremezsiniz!'>");
			window.location.href="<cfoutput>#request.self#?fuseaction=#hr#</cfoutput>";
		</script>
		<cfabort>
	<cfelseif attributes.day_type eq 0 and get_shift.recordcount gt 0 and ((start_hour_format gte shift_start_hour and end_hour_format lte shift_finish_hour) or (start_hour_format gte shift_start_hour and start_hour_format lte shift_finish_hour) or (end_hour_format gte shift_start_hour and end_hour_format lte shift_finish_hour) or (shift_start_hour gt shift_finish_hour and ((start_hour_format gte shift_start_hour and shift_start_hour lte midnight_before) or (start_hour_format gte midnight_after and start_hour_format lte shift_finish_hour))))>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='61125.Vardiya Çalışma saatleri içinde Fazla Mesai Giremezsiniz!'>");
			window.location.href="<cfoutput>#request.self#?fuseaction=#hr#</cfoutput>";
		</script>		
		<cfabort>
	<cfelseif attributes.day_type eq 0 and not (get_offtime.recordcount gt 0 or get_flexible.recordcount gt 0 or get_shift.recordcount gt 0) and ((start_hour_format gte company_start_hour and end_hour_format lte company_finish_hour) or (start_hour_format gte company_start_hour and start_hour_format lte company_finish_hour) or (end_hour_format gte company_start_hour and end_hour_format lte company_finish_hour))>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='61126.Çalışma saatleri içinde Fazla Mesai Giremezsiniz!'>");
			window.location.href="<cfoutput>#request.self#?fuseaction=#hr#</cfoutput>";
		</script>
		<cfabort>
	</cfif>
</cfif>