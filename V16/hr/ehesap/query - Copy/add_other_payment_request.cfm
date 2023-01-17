<cfquery name="add_request" datasource="#dsn#" result="MAX_ID">
    INSERT INTO SALARYPARAM_GET_REQUESTS
        (
            COMMENT_GET,
            AMOUNT_GET,
            SHOW,
            METHOD_GET,
            PERIOD_GET, 
            START_SAL_MON,
            EMPLOYEE_ID,
            TERM,
            CALC_DAYS,
            ODKES_ID,
            FROM_SALARY,
            IN_OUT_ID,
            DETAIL,
            TAKSIT_NUMBER,
            RECORD_DATE,
            RECORD_EMP,
            RECORD_IP,
            PROCESS_STAGE
        )
    VALUES
        (
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.comment_get#">,
            <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.amount_get#">,
            <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.show#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.method_get#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.periyod_get#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#start_sal_mon#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.term#">,
            <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.calc_days#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.odkes_id#">,
            <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.from_salary#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">,
            <cfif isdefined("attributes.detail") and len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#detail#"><cfelse>NULL</cfif>,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.taksit#">,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
        )
</cfquery>
<cf_workcube_process
    is_upd='1'
    old_process_line='0'
    process_stage='#attributes.process_stage#'
    record_member='#session.ep.userid#'
    record_date='#now()#'
    action_table='SALARYPARAM_GET_REQUESTS'
    action_column='SPGR_ID'
    action_id='#MAX_ID.IDENTITYCOL#'
    action_page="#request.self#?fuseaction=ehesap.list_other_payment_requests&event=upd&id=#MAX_ID.IDENTITYCOL#"
    warning_description = 'Taksitli Avans Talebi : #MAX_ID.IDENTITYCOL#'>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script> 
