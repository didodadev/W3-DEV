<cfif isdefined("attributes.record_num")>
    <cfloop from="1" to="#attributes.record_num#" index="i">
        <cfif evaluate("attributes.row_kontrol_#i#") eq 1 and len(evaluate("attributes.employee_id#i#")) and len(evaluate("attributes.comment_pay#i#"))>
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
                    #evaluate('attributes.odkes_id#i#')#,
                    '#evaluate('attributes.comment_pay#i#')#',
                    <cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.amount_pay#i#')#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.start_sal_mon#i#')#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.end_sal_mon#i#')#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.employee_id#i#')#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.term#i#')#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.employee_in_out_id#i#')#">,
                    <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.society_type#i#')#">
                    )
            </cfquery>
        </cfif>
    </cfloop>
</cfif>
<script>
    <cfif len(attributes.draggable1)>
        location.href = document.referrer;
    <cfelse>
        window.close();
    </cfif>
</script>