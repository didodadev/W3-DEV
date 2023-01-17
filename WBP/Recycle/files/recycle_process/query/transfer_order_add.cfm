<cfset transfer_order = createObject("component","WBP/Recycle/files/recycle_process/cfc/transfer_order") />

<cftransaction>

    <cfset addTransferOrder = transfer_order.addTransferOrder(
        process_stage: attributes.process_stage,
        transport_ordering_employee_id: attributes.transport_ordering_employee_id,
        transport_ordering_name: attributes.transport_ordering_name,
        operator_employee_id: attributes.operator_employee_id,
        operator_name: attributes.operator_name,
        department_exit_name: attributes.department_exit_name,
        location_exit_id: attributes.location_exit_id,
        department_exit_id: attributes.department_exit_id,
        branch_exit_id: attributes.branch_exit_id,
        department_entry_name: attributes.department_entry_name,
        location_entry_id: attributes.location_entry_id,
        department_entry_id: attributes.department_entry_id,
        branch_entry_id: attributes.branch_entry_id,
        product_id: attributes.product_id,
        product_name: attributes.product_name,
        transport_quantity : attributes.amount,
        unit_product_id : attributes.unit_product_id,
        unit_product_name : attributes.unit_product_name,
        transport_quantity : attributes.amount,
        stock_id : attributes.stock_id
    ) />

    <cfset attributes.actionid = addTransferOrder.identitycol />

    <cf_workcube_process 
        is_upd='1' 
        data_source='#dsn#' 
        old_process_line='0'
        process_stage='#attributes.process_stage#' 
        record_member='#session.ep.userid#' 
        record_date='#now()#' 
        action_table='REFINERY_TRANSPORT_ORDERS'
        action_column='REFINERY_TRANSPORT_ID'
        action_id='#attributes.actionid#'
        action_page='#request.self#?fuseaction=refinery_transport_id&event=upd&refinery_transport_id=#attributes.actionid#' 
        warning_description='Transfer Emirleri: #attributes.actionid#'>

</cftransaction>