<cfquery name="get_process" datasource="#dsn2#">
    SELECT PROCESS_CAT,INVOICE_NUMBER FROM INVOICE WHERE INVOICE_CAT=69 AND INVOICE_ID = #attributes.invoice_id#
</cfquery>
<cfinclude template="../../invoice/query/get_bill_process_cat.cfm">
<cflock name="#CreateUUID()#" timeout="20">
    <cftransaction>
        <cfinclude template="../../finance/query/upd_daily_zreport6.cfm">
        <cfif len(get_process_type.action_file_name)>
            <cf_workcube_process_cat 
                process_cat="#form.process_cat#"
                action_id = #form.invoice_id#
                is_action_file = 1
                action_file_name='#get_process_type.action_file_name#'
                action_page='#request.self#?fuseaction=#fusebox.circuit#.list_daily_zreport'
                action_db_type = '#dsn2#'
                is_template_action_file = '#get_process_type.action_file_from_template#'>
        </cfif>
        <cf_add_log  log_type="-1" action_id="#form.invoice_id#" action_name="#form.invoice_number#" paper_no="#get_process.invoice_number#" process_stage="#get_process.process_cat#" process_type="#form.old_process_type#" data_source="#dsn2#">
    </cftransaction>
</cflock>