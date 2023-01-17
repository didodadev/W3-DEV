<cf_box scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfquery name="get_contract_name" datasource="#dsn#">
        SELECT 
            CONTRACT_ID, 
            CONTRACT_HEAD, 
            CONTRACT_DETAIL, 
            CONTRACT_DATE, 
            CONTRACT_FINISHDATE,
            EMPLOYEE_ID, 
            RECORD_EMP, 
            RECORD_DATE, 
            RECORD_IP, 
            UPDATE_DATE, 
            UPDATE_EMP, 
            UPDATE_IP, 
            CONTRACT_JOB, 
            CONTRACT_NO 
        FROM 
            EMPLOYEES_CONTRACT 
        WHERE 
            CONTRACT_ID = #attributes.contract_id#
    </cfquery>
    <cfif get_contract_name.RecordCount>
        <cfquery name="DEL_CONTRACT" datasource="#dsn#">
            DELETE FROM EMPLOYEES_CONTRACT WHERE CONTRACT_ID = #attributes.contract_id#
        </cfquery>
        <cf_add_log  log_type="-1" action_id="#attributes.contract_id#" action_name="#get_contract_name.employee_id#-#get_contract_name.contract_head#" paper_no="#get_contract_name.contract_no#">
        <script>
            <cfif not isdefined("attributes.draggable")>
                window.location.href='<cfoutput>#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#get_contract_name.EMPLOYEE_ID#</cfoutput>';
            <cfelseif isdefined("attributes.draggable")>
                closeBoxDraggable( 'upd_contract_box' );
                closeBoxDraggable( 'contract_box' );
                openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_employee_contract&employee_id=#get_contract_name.EMPLOYEE_ID#</cfoutput>','contract_box');
            </cfif>
        </script>
    </cfif>
</cf_box>