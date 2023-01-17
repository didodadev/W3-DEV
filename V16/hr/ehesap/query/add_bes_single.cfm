<cfquery name="add_row" datasource="#dsn#">
INSERT INTO SALARYPARAM_BES
    (
    COMMENT_BES_ID,
    COMMENT_BES,
    RATE_BES,
    START_SAL_MON,
    END_SAL_MON,
    EMPLOYEE_ID,
    TERM,
    IN_OUT_ID,
    RECORD_DATE,
    RECORD_EMP,
    RECORD_IP,
    SOCIETY_TYPE
    )
VALUES
    (
    #attributes.odkes_id0#,
    '#attributes.comment_pay0#',
    <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(attributes.amount_pay0)#">,
    <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.start_sal_mon0#">,
    <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.end_sal_mon0#">,
    <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">,
    <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.term0#">,
    <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_in_out_id#">,
    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
    <cfif isDefined('attributes.society_type') and len(attributes.society_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.society_type#"><cfelse>NULL</cfif>
    )
</cfquery>
<script>
    <cfif not isdefined("attributes.draggable")>
        location.href = document.referrer;
    <cfelse>
        closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
        location.reload();
    </cfif>
</script>