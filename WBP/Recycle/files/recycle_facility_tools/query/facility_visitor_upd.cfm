<cfset facility_visitor = createObject("component","WBP/Recycle/files/recycle_facility_tools/cfc/facility_visitor") />

<!--- <cfif len( attributes.visitTime )>
    <cf_date tarih="attributes.visitTime">
    <cfif isDefined( "attributes.visit_entry_hour" ) and len( attributes.visit_entry_hour )><cfset attributes.visitTime = date_add("h", attributes.visit_entry_hour - session.ep.time_zone, attributes.visitTime)></cfif>
    <cfif isDefined( "attributes.visit_entry_minute" ) and len( attributes.visit_entry_minute )><cfset attributes.visitTime = date_add("n", attributes.visit_entry_minute, attributes.visitTime)></cfif>
</cfif>

<cfif len( attributes.visitTime_exit )>
    <cf_date tarih="attributes.visitTime_exit">
    <cfif isDefined( "attributes.visit_exit_hour" ) and len( attributes.visit_exit_hour )><cfset attributes.visitTime_exit = date_add("h", attributes.visit_exit_hour - session.ep.time_zone, attributes.visitTime_exit)></cfif>
    <cfif isDefined( "attributes.visit_exit_minute" ) and len( attributes.visit_exit_minute )><cfset attributes.visitTime_exit = date_add("n", attributes.visit_exit_minute, attributes.visitTime_exit)></cfif>
</cfif> --->

<cftransaction>

    <cfset updFacilityVisitor = facility_visitor.updFacilityVisitor(
        refinery_visitor_register_id: attributes.refinery_visitor_register_id,
        visitorName: attributes.visitorName,
        tcIdentityNumber: attributes.tcIdentityNumber,
        consumer_id: attributes.consumer_id,
        company_id: attributes.company_id,
        analyze_company_name: attributes.analyze_company_name,
        member_type: attributes.member_type,
        car_number: attributes.car_number,
        special_code: attributes.special_code,
        phoneNumber: attributes.phoneNumber,
        emailAddress: attributes.emailAddress,
        employeeName: attributes.employeeName,
        employeeId: attributes.employeeId,
        <!--- visitTime: attributes.visitTime,
        visitTime_exit: attributes.visitTime_exit, --->
        visitorCartnumber: attributes.visitorCartnumber,
        visitorPurpose: attributes.visitorPurpose,
        note: attributes.note,
        isg_entry_time: attributes.isg_entry_time,
        isg_exit_time: attributes.isg_exit_time,
        process_stage: attributes.process_stage

    ) />

    <cfset attributes.actionid = attributes.refinery_visitor_register_id />

    <cf_workcube_process 
        is_upd='1' 
        data_source='#dsn#' 
        old_process_line='#attributes.old_process_line#'
        process_stage='#attributes.process_stage#' 
        record_member='#session.ep.userid#' 
        record_date='#now()#' 
        action_table='REFINERY_VISITOR_REGISTER'
        action_column='REFINERY_VISITOR_REGISTER_ID'
        action_id='#attributes.actionid#'
        action_page='#request.self#?fuseaction=recycle.facility_visitor&event=upd&#attributes.actionid#' 
        warning_description='Ziyaretçiler: #attributes.actionid#'>

</cftransaction>