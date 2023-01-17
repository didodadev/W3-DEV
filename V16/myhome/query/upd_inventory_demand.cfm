<cfquery name="upd_inventory_demand" datasource="#dsn#">
	UPDATE
    	EMPLOYEES_INVENTORY_DEMAND
    SET	
    	FORM_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.form_type#">,
        DEMAND_STAGE = <cfif isdefined('attributes.process_stage') and len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
        EMP_TABLE = <cfif isdefined("attributes.emp_table") and len(attributes.emp_table)>'#attributes.emp_table#'<cfelse>NULL</cfif>,
        RCD_DEFINITION = <cfif isdefined("attributes.rcd_definition") and len(attributes.rcd_definition)>'#attributes.rcd_definition#'<cfelse>NULL</cfif>,
        MOBILE_CODE = <cfif isdefined("attributes.mobile_code") and len(attributes.mobile_code)>'#attributes.mobile_code#'<cfelse>NULL</cfif>,
        MOBILE_TEL = <cfif isdefined("attributes.mobile_tel") and len(attributes.mobile_tel)>'#attributes.mobile_tel#'<cfelse>NULL</cfif>,
        INTERCOM = <cfif isdefined("attributes.intercom") and len(attributes.intercom)>'#attributes.intercom#'<cfelse>NULL</cfif>,
        UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
        UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
    WHERE
    	INVENTORY_DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.inventory_demand_id#">
</cfquery>
<cfquery name="get_inventory_demand" datasource="#dsn#">
	SELECT 
        ID.INVENTORY_DEMAND_ID,
        ID.RECORD_DATE,
        ID.DEPARTMENT_ID,
        ID.COMPANY_ID,
        ID.BRANCH_ID,
        ID.MANAGER_VALID,
        ID.MANAGER_VALID_DATE,
        ID.IT_VALID,
        ID.IT_VALID_DATE,
        ID.EMPLOYEE_VALID,
        ID.EMPLOYEE_VALID_DATE,
        ID.DEMAND_STAGE,
        ID.FORM_TYPE,
        ID.EMPLOYEE_ID,
        ID.BRANCH_ID,
        ID.COMPANY_ID,
        ID.STARTDATE,
        ID.FINISHDATE,
        ID.RCD_DEFINITION,
        ID.MOBILE_CODE,
        ID.MOBILE_TEL,
        ID.INTERCOM,
        ID.EMP_TABLE,
        IDR.REASON_TYPE,
        IDR.REASON_DEFINITION,
        EP.POSITION_ID,
        EP.UPPER_POSITION_CODE
    FROM 
    	EMPLOYEES_INVENTORY_DEMAND ID LEFT JOIN EMPLOYEES_INVENTORY_DEMAND_ROWS IDR ON ID.INVENTORY_DEMAND_ID = IDR.INVENTORY_DEMAND_ID
        LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = ID.EMPLOYEE_ID
    WHERE 
    	ID.INVENTORY_DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.inventory_demand_id#">
</cfquery>
<cfquery name="get_process_stage" datasource="#dsn#">
	SELECT PRO_POSITION_ID FROM PROCESS_TYPE_ROWS_POSID WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
</cfquery>
<cfset pos_list = ValueList(get_process_stage.PRO_POSITION_ID,',')><!---süreçte yetkili pozisyonlar--->
<cfquery name="get_pos_id" datasource="#dsn#">
	SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
</cfquery>
<cfif attributes.form_type eq 3>
	<cfquery name="upd_it_valid1" datasource="#DSN#">
        UPDATE
            EMPLOYEES_INVENTORY_DEMAND
        SET	
            IT_VALID = 1,
            IT_VALID_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
        WHERE
            INVENTORY_DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.inventory_demand_id#">
    </cfquery>
<cfelse>
	<cfif session.ep.position_code eq get_inventory_demand.upper_position_code and not len(get_inventory_demand.MANAGER_VALID)>
        <cfquery name="upd_manager_valid" datasource="#DSN#">
            UPDATE
                EMPLOYEES_INVENTORY_DEMAND
            SET	
                MANAGER_VALID = 1,
                MANAGER_VALID_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            WHERE
                INVENTORY_DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.inventory_demand_id#">
        </cfquery>
    <cfelseif not len(get_inventory_demand.IT_VALID) and ListFindNoCase(pos_list,get_pos_id.POSITION_ID,',') and get_inventory_demand.MANAGER_VALID eq 1>
    	<cfquery name="upd_it_valid2" datasource="#DSN#">
            UPDATE
                EMPLOYEES_INVENTORY_DEMAND
            SET	
                IT_VALID = 1,
                IT_VALID_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            WHERE
                INVENTORY_DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.inventory_demand_id#">
        </cfquery>
    <cfelseif session.ep.userid eq get_inventory_demand.EMPLOYEE_ID and get_inventory_demand.MANAGER_VALID eq 1 and get_inventory_demand.IT_VALID eq 1>
        <cfquery name="upd_employee_valid" datasource="#DSN#">
            UPDATE
                EMPLOYEES_INVENTORY_DEMAND
            SET	
                EMPLOYEE_VALID = 1,
                EMPLOYEE_VALID_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            WHERE
                INVENTORY_DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.inventory_demand_id#">
        </cfquery>
    </cfif>
</cfif>  
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
            UPDATE_DATE,
            UPDATE_EMP,
            UPDATE_IP
        )
        VALUES
        (
        	<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.inventory_demand_id#">,
        	<cfqueryparam cfsqltype="cf_sql_integer" value="#get_inventory_demand.form_type#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#get_inventory_demand.demand_stage#">,
        	<cfqueryparam cfsqltype="cf_sql_integer" value="#get_inventory_demand.employee_id#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#get_inventory_demand.company_id#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#get_inventory_demand.branch_id#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#get_inventory_demand.department_id#">,
            <cfif isdefined("get_inventory_demand.startdate") and len(get_inventory_demand.startdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#get_inventory_demand.startdate#"><cfelse>NULL</cfif>,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#get_inventory_demand.position_id#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#get_inventory_demand.upper_position_code#">,
            <cfif isdefined("get_inventory_demand.emp_table") and len(get_inventory_demand.emp_table)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_inventory_demand.emp_table#"><cfelse>NULL</cfif>,
            <cfif isdefined("get_inventory_demand.rcd_definition") and len(get_inventory_demand.rcd_definition)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_inventory_demand.rcd_definition#"><cfelse>NULL</cfif>,
            <cfif isdefined("get_inventory_demand.mobile_code") and len(get_inventory_demand.mobile_code)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_inventory_demand.mobile_code#"><cfelse>NULL</cfif>,
            <cfif isdefined("get_inventory_demand.mobile_tel") and len(get_inventory_demand.mobile_tel)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_inventory_demand.mobile_tel#"><cfelse>NULL</cfif>,
            <cfif isdefined("get_inventory_demand.intercom") and len(get_inventory_demand.intercom)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_inventory_demand.intercom#"><cfelse>NULL</cfif>,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#"> 
        )
</cfquery>
<cfquery name="del_inventory_demand_rows" datasource="#DSN#">
    DELETE
    FROM
        EMPLOYEES_INVENTORY_DEMAND_ROWS
    WHERE
        INVENTORY_DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.inventory_demand_id#">
</cfquery>

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
                        REQUEST_NUMBER,
                        UPDATE_DATE,
                        UPDATE_EMP,
                        UPDATE_IP
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.inventory_demand_id#">,
                        #evaluate("attributes.inventory_cat_id_#i#")#,
                        <cfif isdefined('attributes.inventory_cat_value_#i#') and len(evaluate("attributes.inventory_cat_value_#i#"))>'#evaluate("attributes.inventory_cat_value_#i#")#'<cfelse>NULL</cfif>,
                        <cfif isdefined("get_inventory_demand.REASON_TYPE") and len(get_inventory_demand.REASON_TYPE)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_inventory_demand.REASON_TYPE#"><cfelse>NULL</cfif>,
                        <cfif isdefined("get_inventory_demand.REASON_DEFINITION") and len(get_inventory_demand.REASON_DEFINITION)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_inventory_demand.REASON_DEFINITION#"><cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.inventory_request_#i#") and len(evaluate("attributes.inventory_request_#i#"))>'#evaluate("attributes.inventory_request_#i#")#'<cfelse>NULL</cfif>,
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
                        REQUEST_NUMBER,
                        UPDATE_DATE,
                        UPDATE_EMP,
                        UPDATE_IP
                    )
                    VALUES
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.inventory_demand_id#">,
                        #evaluate("attributes.another_cat_id_#i#")#,
                        <cfif isdefined('attributes.another_value_#i#') and len(evaluate("attributes.another_value_#i#"))>'#evaluate("attributes.another_value_#i#")#'<cfelse>NULL</cfif>,
                        <cfif isdefined("get_inventory_demand.REASON_TYPE") and len(get_inventory_demand.REASON_TYPE)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_inventory_demand.REASON_TYPE#"><cfelse>NULL</cfif>,
                        <cfif isdefined("get_inventory_demand.REASON_DEFINITION") and len(get_inventory_demand.REASON_DEFINITION)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_inventory_demand.REASON_DEFINITION#"><cfelse>NULL</cfif>,
                        <cfif isdefined("attributes.another_request_#i#") and len(evaluate("attributes.another_request_#i#"))>#evaluate("attributes.another_request_#i#")#<cfelse>NULL</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
                    )	
            </cfquery>
       	</cfif>
	</cfloop>
</cfif>

<cfquery name="get_max_id_history" datasource="#DSN#">
    SELECT
		MAX(HISTORY_ID) AS MAX_ITEM_ID_HISTORY
	FROM
		EMPLOYEES_INVENTORY_DEMAND_HISTORY
</cfquery>
<cfquery name="get_inventory_demand_rows" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_INVENTORY_DEMAND_ROWS WHERE INVENTORY_DEMAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.inventory_demand_id#">
</cfquery>
<cfloop query="get_inventory_demand_rows">
    <cfquery name="add_inventory_demand_row_history" datasource="#DSN#">
        INSERT INTO
            EMPLOYEES_INVENTORY_DEMAND_ROWS_HISTORY
        (
        	HISTORY_ID,
            INVENTORY_DEMAND_ID,
            INVENTORY_CAT_ID,
            INVENTORY_VALUE,
            REASON_TYPE,
            REASON_DEFINITION,
            REQUEST_NUMBER,
            UPDATE_DATE,
            UPDATE_EMP,
            UPDATE_IP
        )
        VALUES
        (
            #get_max_id_history.MAX_ITEM_ID_HISTORY#,
            #get_inventory_demand_rows.INVENTORY_DEMAND_ID#,
            #get_inventory_demand_rows.INVENTORY_CAT_ID#,
            <cfif len(get_inventory_demand_rows.INVENTORY_VALUE)>'#get_inventory_demand_rows.INVENTORY_VALUE#'<cfelse>NULL</cfif>,	
            <cfif len(get_inventory_demand_rows.REASON_TYPE)>'#get_inventory_demand_rows.REASON_TYPE#'<cfelse>NULL</cfif>,		
            <cfif len(get_inventory_demand_rows.REASON_DEFINITION)>'#get_inventory_demand_rows.REASON_DEFINITION#'<cfelse>NULL</cfif>,
            <cfif len(get_inventory_demand_rows.REQUEST_NUMBER)>'#get_inventory_demand_rows.REQUEST_NUMBER#'<cfelse>NULL</cfif>,				
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
        ) 
    </cfquery>
</cfloop>
<cf_workcube_process 
	is_upd='1' 
	data_source='#dsn#' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#'
	record_date='#now()#' 
	action_table='EMPLOYEES_INVENTORY_DEMAND'
	action_column='INVENTORY_DEMAND_ID'
	action_id='#attributes.INVENTORY_DEMAND_ID#' 
	action_page='#request.self#?fuseaction=myhome.list_inventory_demands' 
	warning_description='Envanter Talebi : #attributes.INVENTORY_DEMAND_ID#'>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
