<cfquery name="get_control" datasource="#dsn#">
	SELECT 
    	WORKTIMES_ID 
    FROM 
    	EMPLOYEES_OVERTIME
    WHERE
    	IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"> AND
        OVERTIME_PERIOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.term#"> AND
        OVERTIME_MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.start_mon#">
</cfquery>
<cfif get_control.recordcount>
	<script type="text/javascript">
		alert("Bu aya ait kayıt daha önce eklenmiş.Lütfen kontrol ediniz!");
        window.close();
    </script>
<cfelse>
    <cfquery name="add_overtime" datasource="#dsn#">
        INSERT INTO 
            EMPLOYEES_OVERTIME
        (
            EMPLOYEE_ID,
            IN_OUT_ID,
            OVERTIME_PERIOD,
            OVERTIME_MONTH,
            OVERTIME_VALUE_0,
            OVERTIME_VALUE_1,
            OVERTIME_VALUE_2,
            OVERTIME_VALUE_3,
            RECORD_EMP,
            RECORD_DATE,
            RECORD_IP
        )
        VALUES
        (	
            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.term#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.start_mon#">,
            <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.overtime_value0#">,  
            <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.overtime_value1#">,  
            <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.overtime_value2#">,  
            <cfqueryparam cfsqltype="cf_sql_float" value="#attributes.overtime_value3#">,  
            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
        )					 
    </cfquery>	
	<script type="text/javascript">
        window_opener_reload();
    </script>
</cfif>
