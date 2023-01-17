<cfif isdefined("attributes.record_num")>
<cfset totalValues = 0>
<cfset action_list_id = ''>
<cfloop from="1" to="#attributes.record_num#" index="i">
	<cfif evaluate("attributes.row_kontrol_#i#") eq 1 and len(evaluate("attributes.employee_id#i#")) and len(evaluate("attributes.comment_pay#i#"))>
		<cfquery name="get_types" datasource="#dsn#">
            SELECT 
        	    ODKES_ID, 
                COMMENT_PAY, 
                PERIOD_PAY, 
                METHOD_PAY, 
                AMOUNT_PAY, 
                SHOW, 
                TAX, 
                START_SAL_MON,
                END_SAL_MON, 
                IS_ODENEK, 
                CALC_DAYS, 
                IS_INST_AVANS, 
                FROM_SALARY, 
                RECORD_DATE, 
                RECORD_EMP, 
                RECORD_IP, 
                UPDATE_EMP, 
                UPDATE_DATE, 
                UPDATE_IP,
                COMPANY_ID, 
                ACCOUNT_CODE, 
                ACCOUNT_NAME, 
                CONSUMER_ID,
                MONEY, 
                ACC_TYPE_ID,
				IS_NET_TO_GROSS
            FROM 
    	        SETUP_PAYMENT_INTERRUPTION 
            WHERE 
	            ODKES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.odkes_id#i#')#"> 
            AND 
            	IS_ODENEK = 0
        </cfquery>
        <cfquery name="add_row" datasource="#dsn#" result="MAX_ID">
			INSERT INTO SALARYPARAM_GET
				(
				COMMENT_GET,
				AMOUNT_GET,
				METHOD_GET,
				PERIOD_GET,
				START_SAL_MON,
				END_SAL_MON,
				EMPLOYEE_ID,
				TERM,
				CALC_DAYS,
				SHOW,
				TAX,
				FROM_SALARY,
				IN_OUT_ID,
                COMPANY_ID, 
                ACCOUNT_CODE, 
                ACCOUNT_NAME, 
                CONSUMER_ID,
                ACC_TYPE_ID,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				DETAIL,
				PROCESS_STAGE,
				IS_NET_TO_GROSS
				)
			VALUES
				(
				<cfif len(get_types.comment_pay)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_types.comment_pay#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_float" value="#evaluate('attributes.amount_pay#i#')#">,
				<cfif len(get_types.method_pay)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_types.method_pay#"><cfelse>0</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#get_types.period_pay#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.start_sal_mon#i#')#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.end_sal_mon#i#')#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.employee_id#i#')#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.term#i#')#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#get_types.calc_days#">,
                <cfqueryparam cfsqltype="cf_sql_bit" value="#get_types.show#">,
				<cfif len(get_types.tax)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_types.tax#"><cfelse>0</cfif>,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#get_types.from_salary#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.employee_in_out_id#i#')#">,
				<cfif len(evaluate("attributes.sabit_company_id#i#")) and len(evaluate("attributes.sabit_member_name#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.sabit_company_id#i#')#"><cfelse>NULL</cfif>,
				<cfif len(get_types.account_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_types.account_code#"><cfelse>NULL</cfif>,
				<cfif len(get_types.account_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_types.account_name#"><cfelse>NULL</cfif>,
				<cfif len(evaluate("attributes.sabit_consumer_id#i#")) and len(evaluate("attributes.sabit_member_name#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.sabit_consumer_id#i#')#"><cfelse>NULL</cfif>,
				<cfif len(get_types.acc_type_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_types.acc_type_id#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				<cfif len(evaluate('attributes.detail#i#'))><cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('attributes.detail#i#')#"><cfelse>NULL</cfif>,
				<cfif len(evaluate('attributes.process_stage#i#'))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.process_stage#i#')#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage0#"></cfif>,
				<cfif isDefined("get_types.is_net_to_gross") and len(get_types.is_net_to_gross) and get_types.from_salary eq 1><cfqueryparam cfsqltype="cf_sql_bit" value="#get_types.is_net_to_gross#"><cfelse>0</cfif>
				)
		</cfquery>
		<cf_workcube_process 
			is_upd='1' 
			old_process_line='0'
			process_stage='#attributes.process_stage0#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#'
			action_table='SALARYPARAM_GET'
			action_column='PROCESS_STAGE'
			action_id='#MAX_ID.IDENTITYCOL#'
			action_page='#request.self#?fuseaction=ehesap.list_interruption' 
			warning_description="#getLang('','Add Deduction','53478')#">
	</cfif>
</cfloop>

</cfif>

<script type="text/javascript">
	location.href = document.referrer;
</script>
