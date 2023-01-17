
<cfobject name="hr_employee_mandate_component" component="V16.hr.cfc.hr_employee_mandate">
<cfset hr_employee_mandate_component.init()>
<cftry>
    <cfif isDefined("attributes.startdate")>
        <cf_date tarih="attributes.startdate"></cfif>
    <cfif isDefined("attributes.finishdate")>
        <cf_date tarih="attributes.finishdate"></cfif>
    <cfscript>
        if(len(start_hour))
        attributes.startdate = date_add('h', start_hour, attributes.startdate);
        if(len(start_min))
        attributes.startdate = date_add('n', start_min, attributes.startdate);
        if(len(end_hour))
        attributes.finishdate = date_add('h', end_hour, attributes.finishdate);
        if(len(end_min))
        attributes.finishdate = date_add('n', end_min, attributes.finishdate);
    </cfscript>  
<cfscript>
mandate_ref = hr_employee_mandate_component.mandate_update(attributes.process_stage, attributes.id?:"", attributes.employee_id, attributes.mandate_id, attributes.detail?:"", attributes.startdate?:"", attributes.finishdate?:"");
</cfscript>
<cfsavecontent variable="mandate"><cf_get_lang dictionary_id = "59872.vekalet"></cfsavecontent>
<cf_workcube_process 
    is_upd="1" 
    data_source='#dsn#'
    is_detail="#(attributes.event eq "add")?0:1#" 
    process_stage="#attributes.process_stage#" 
    record_date="#now()#" 
    old_process_line="#isDefined("attributes.old_process_line")?attributes.old_process_line:0#"
    record_member='#session.ep.userid#'
    action_table='EMPLOYEE_MANDATE'
    action_column='MANDATE_MASTER_ID'
    action_id='#mandate_ref#'
    action_page='#request.self#?fuseaction=#attributes.fuseaction#&event=upd&id=#mandate_ref#'
    warning_description='#mandate#: #attributes.employee_name# -> #attributes.mandate_name#'
    >
<cfset GetPageContext().getCFOutput().clear()>
<script type="text/javascript">document.location.href="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#&event=upd&id=#mandate_ref#</cfoutput>"</script>
<cfcatch>
<cfdump var="#cfcatch#"></cfcatch></cftry>

