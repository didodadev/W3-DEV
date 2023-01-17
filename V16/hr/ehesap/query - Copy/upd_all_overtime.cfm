<cfquery name="upd_overtime" datasource="#dsn#">
    UPDATE
        EMPLOYEES_OVERTIME
    SET
        EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">,
        IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">,
        OVERTIME_PERIOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.term#">,
        OVERTIME_MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.start_mon#">,
        OVERTIME_VALUE_0 = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.overtime_value0#">,  
        OVERTIME_VALUE_1 = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.overtime_value1#">,  
        OVERTIME_VALUE_2 = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.overtime_value2#">,  
        OVERTIME_VALUE_3 = <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.overtime_value3#">, 
        UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
        UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
    WHERE
    	WORKTIMES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.overtime_id#">
</cfquery>
<script type="text/javascript">
	window_opener_reload();
</script>
