<cfset get_component = createObject('component','V16.report.cfc.additional_allowance')><!--- Ek Ödenekler Component--->
<cfloop from="1" to="#listLen(attributes.check_list)#" index="check_in_out_id">
    <cfset get_emp_id = get_component.GET_EMP_ID_FROM_INOUT(in_out_id : listgetat(check_list,check_in_out_id,','))>
    <cfset set_insert = get_component.SET_ADD_ALLOWANCE(
        employee_id : get_emp_id.employee_id,
        in_out_id : listgetat(attributes.check_list,check_in_out_id,','),
        odkes_id : attributes.odkes_id_0,
        period_years : attributes.period_years,
        start_mon : attributes.start_mon,
        finish_mon : attributes.finish_mon
    )>
</cfloop>
<script>
	window.location ="<cfoutput>#request.self#</cfoutput>?fuseaction=report.additional_allowance_report";	
</script>