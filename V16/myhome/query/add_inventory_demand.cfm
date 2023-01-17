<cfquery name="add_inventory_demand" datasource="#dsn#" result="MAX_ID">
	INSERT INTO
    	EMPLOYEES_INVENTORY_DEMAND
        (
        	FORM_TYPE,
            DEMAND_STAGE,
        	EMPLOYEE_ID,
            COMPANY_ID,
            BRANCH_ID,
            DEPARTMENT_ID,
            STARTDATE,
            FINISHDATE,
            POSITION_ID,
            UPPER_POSITION_CODE,
            EMP_TABLE,
            RCD_DEFINITION,
            MOBILE_CODE,
            MOBILE_TEL,
            INTERCOM,
            RECORD_DATE,
            RECORD_EMP,
            RECORD_IP
        )
        VALUES
        (
        	<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.form_type#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
        	<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dept_id#">,
            <cfif isdefined('attributes.start_date') and len(attributes.start_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"><cfelse>NULL</cfif>,
            <cfif isdefined('attributes.finish_date') and len(attributes.finish_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"><cfelse>NULL</cfif>,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_id#">,
            <cfif isdefined("attributes.upper_position_code") and len(attributes.upper_position_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_position_code#"><cfelse>NULL</cfif>,
            <cfif isdefined("attributes.emp_table") and len(attributes.emp_table)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.emp_table#"><cfelse>NULL</cfif>,
            <cfif isdefined("attributes.rcd_definition") and len(attributes.rcd_definition)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.rcd_definition#"><cfelse>NULL</cfif>,
            <cfif isdefined("attributes.mobile_code") and len(attributes.mobile_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.mobile_code#"><cfelse>NULL</cfif>,
            <cfif isdefined("attributes.mobile_tel") and len(attributes.mobile_tel)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.mobile_tel#"><cfelse>NULL</cfif>,
            <cfif isdefined("attributes.intercom") and len(attributes.intercom)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.intercom#"><cfelse>NULL</cfif>,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
        )
</cfquery>
<cfquery name="get_max_id" datasource="#DSN#">
	SELECT
		MAX(INVENTORY_DEMAND_ID) AS MAX_ITEM_ID
	FROM
		EMPLOYEES_INVENTORY_DEMAND
</cfquery>
<cfset max_row = get_max_id.MAX_ITEM_ID>

<cfquery name="add_inventory_demand_history" datasource="#dsn#" result="MAX_ID">
	INSERT INTO
    	EMPLOYEES_INVENTORY_DEMAND_HISTORY
        (
        	INVENTORY_DEMAND_ID,
        	FORM_TYPE,
            DEMAND_STAGE,
        	EMPLOYEE_ID,
            COMPANY_ID,
            BRANCH_ID,
            DEPARTMENT_ID,
            STARTDATE,
            POSITION_ID,
            UPPER_POSITION_CODE,
            EMP_TABLE,
            RCD_DEFINITION,
            MOBILE_CODE,
            MOBILE_TEL,
            INTERCOM,
            RECORD_DATE,
            RECORD_EMP,
            RECORD_IP
        )
        VALUES
        (
        	#max_row#,
        	<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.form_type#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
        	<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.dept_id#">,
            <cfif isdefined('attributes.start_date') and len(attributes.start_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"><cfelse>NULL</cfif>,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_id#">,
            <cfif isdefined("attributes.upper_position_code") and len(attributes.upper_position_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.upper_position_code#"><cfelse>NULL</cfif>,
            <cfif isdefined("attributes.emp_table") and len(attributes.emp_table)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.emp_table#"><cfelse>NULL</cfif>,
            <cfif isdefined("attributes.rcd_definition") and len(attributes.rcd_definition)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.rcd_definition#"><cfelse>NULL</cfif>,
            <cfif isdefined("attributes.mobile_code") and len(attributes.mobile_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.mobile_code#"><cfelse>NULL</cfif>,
            <cfif isdefined("attributes.mobile_tel") and len(attributes.mobile_tel)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.mobile_tel#"><cfelse>NULL</cfif>,
            <cfif isdefined("attributes.intercom") and len(attributes.intercom)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.intercom#"><cfelse>NULL</cfif>,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
        )
</cfquery>
<cfquery name="get_max_id_history" datasource="#DSN#">
	SELECT
		MAX(HISTORY_ID) AS MAX_ITEM_ID
	FROM
		EMPLOYEES_INVENTORY_DEMAND_HISTORY
</cfquery>
<cfset max_row_history = get_max_id_history.MAX_ITEM_ID>


<cfif isdefined("attributes.inventory_cat_id_count") and listlen(attributes.inventory_cat_id_count)>
	<cfloop from="1" to="#attributes.inventory_cat_id_count#" index="i">
		<cfif isdefined('attributes.inventory_cat_id_#i#') and len(evaluate("attributes.inventory_cat_id_#i#"))>
            <cfquery name="add_inventory_demand_rows" datasource="#dsn#">
                INSERT INTO
                    EMPLOYEES_INVENTORY_DEMAND_ROWS
                    (
                        INVENTORY_DEMAND_ID,
                        INVENTORY_CAT_ID,
                        INVENTORY_VALUE,
                        REASON_TYPE,
                        REASON_DEFINITION,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP
                    )
                    VALUES
                    (
                        #max_row#,
                        #evaluate("attributes.inventory_cat_id_#i#")#,
                        <cfif isdefined('attributes.inventory_cat_value_#i#') and len(evaluate("attributes.inventory_cat_value_#i#"))>'#evaluate("attributes.inventory_cat_value_#i#")#'<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.reason_type") and len(attributes.reason_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.reason_type#"><cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.definition") and len(attributes.definition)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.definition#"><cfelse>NULL</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
                    )	
            </cfquery>
            <cfquery name="add_inventory_demand_rows" datasource="#dsn#">
                INSERT INTO
                    EMPLOYEES_INVENTORY_DEMAND_ROWS_HISTORY
                    (
                    	HISTORY_ID,
                        INVENTORY_DEMAND_ID,
                        INVENTORY_CAT_ID,
                        INVENTORY_VALUE,
                        REASON_TYPE,
                        REASON_DEFINITION,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP
                    )
                    VALUES
                    (
                    	#max_row_history#,
                        #max_row#,
                        #evaluate("attributes.inventory_cat_id_#i#")#,
                        <cfif isdefined('attributes.inventory_cat_value_#i#') and len(evaluate("attributes.inventory_cat_value_#i#"))>'#evaluate("attributes.inventory_cat_value_#i#")#'<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.reason_type") and len(attributes.reason_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.reason_type#"><cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.definition") and len(attributes.definition)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.definition#"><cfelse>NULL</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
                    )	
            </cfquery>
       	</cfif>
	</cfloop>
</cfif>
<cfif isdefined("attributes.another_cat_id_count") and listlen(attributes.another_cat_id_count)>
    <cfloop from="1" to="#attributes.another_cat_id_count#" index="i">
		<cfif isdefined('attributes.another_cat_id_#i#') and len(evaluate("attributes.another_cat_id_#i#"))>
            <cfquery name="add_inventory_demand_rows" datasource="#dsn#">
                INSERT INTO
                    EMPLOYEES_INVENTORY_DEMAND_ROWS
                    (
                        INVENTORY_DEMAND_ID,
                        INVENTORY_CAT_ID,
                        INVENTORY_VALUE,
                        REASON_TYPE,
                        REASON_DEFINITION,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP
                    )
                    VALUES
                    (
                        #max_row#,
                        #evaluate("attributes.another_cat_id_#i#")#,
                        <cfif isdefined('attributes.another_value_#i#') and len(evaluate("attributes.another_value_#i#"))>'#evaluate("attributes.another_value_#i#")#'<cfelse>NULL</cfif>, 
						<cfif isdefined("attributes.reason_type") and len(attributes.reason_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.reason_type#"><cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.definition") and len(attributes.definition)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.definition#"><cfelse>NULL</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
                    )	
            </cfquery>
            <cfquery name="add_inventory_demand_rows" datasource="#dsn#">
                INSERT INTO
                    EMPLOYEES_INVENTORY_DEMAND_ROWS_HISTORY
                    (
                    	HISTORY_ID,
                        INVENTORY_DEMAND_ID,
                        INVENTORY_CAT_ID,
                        INVENTORY_VALUE,
                        REASON_TYPE,
                        REASON_DEFINITION,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP
                    )
                    VALUES
                    (
                    	#max_row_history#,
                        #max_row#,
                        #evaluate("attributes.another_cat_id_#i#")#,
                        <cfif isdefined('attributes.another_value_#i#') and len(evaluate("attributes.another_value_#i#"))>'#evaluate("attributes.another_value_#i#")#'<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.reason_type") and len(attributes.reason_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.reason_type#"><cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.definition") and len(attributes.definition)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.definition#"><cfelse>NULL</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
                    )	
            </cfquery>
       	</cfif>
	</cfloop>
</cfif>
<cf_workcube_process 
	is_upd='1' 
	data_source='#dsn#' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#' 
	record_date='#now()#' 
	action_table='EMPLOYEES_INVENTORY_DEMAND'
	action_column='INVENTORY_DEMAND_ID'
	action_id='#MAX_ID.IDENTITYCOL#'
	action_page='#request.self#?fuseaction=ehesap.list_inventory_demands' 
	warning_description='Envanter Talebi: #MAX_ID.IDENTITYCOL#'>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
