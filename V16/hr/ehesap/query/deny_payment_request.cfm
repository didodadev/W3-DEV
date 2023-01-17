<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfif attributes.upd_id eq 1>
			<cfquery name="DENY_PR" datasource="#DSN#">
				UPDATE
					CORRESPONDENCE_PAYMENT
				SET
					IN_OUT_ID = #attributes.employee_in_out_id#,
					STATUS=#upd_id#,
					VALID_EMP=#SESSION.EP.USERID#,
					VALID_DATE=#NOW()#
				WHERE
					ID=#attributes.payment_id#		
			</cfquery>
			<cfquery name="get_payment" datasource="#dsn#">
				SELECT SPG_ID FROM SALARYPARAM_GET WHERE PAYMENT_ID = #attributes.payment_id#
			</cfquery>
			<cfif get_payment.recordcount>
				<cfquery name="upd_pay" datasource="#DSN#">
					UPDATE
						SALARYPARAM_GET
					SET
						IN_OUT_ID = #attributes.employee_in_out_id#
					WHERE
						SPG_ID=#get_payment.SPG_ID#		
				</cfquery>
			<cfelse>
				<cfquery name="get_demand" datasource="#dsn#">
					SELECT 
                        ID, 
                        PROCESS_STAGE, 
                        PRIORITY,
                        SUBJECT, 
                        DUEDATE, 
                        PAYMETHOD_ID, 
                        TO_EMPLOYEE_ID, 
                        AMOUNT, 
                        MONEY, 
                        DETAIL,
                        STATUS,
                        VALID_EMP, 
                        VALID_DATE, 
                        PERIOD_ID, 
                        IN_OUT_ID, 
                        VALID_1, 
                        VALIDATOR_POSITION_CODE_1, 
                        VALID_2, 
                        VALIDATOR_POSITION_CODE_2, 
                        VALID_1_DETAIL, 
                        VALID_2_DETAIL, 
                        ACTION_ID, 
                        RECORD_IP, 
                        RECORD_EMP, 
                        RECORD_DATE, 
                        UPDATE_EMP, 
                        UPDATE_DATE, 
                        UPDATE_IP ,
						(SELECT SHOW FROM SETUP_PAYMENT_INTERRUPTION WHERE ODKES_ID = CORRESPONDENCE_PAYMENT.DEMAND_TYPE) SHOW,
						(SELECT ACC_TYPE_ID FROM SETUP_PAYMENT_INTERRUPTION WHERE ODKES_ID = CORRESPONDENCE_PAYMENT.DEMAND_TYPE) ACC_TYPE_ID,
						(SELECT ACC_TYPE_NAME FROM SETUP_ACC_TYPE WHERE ACC_TYPE_ID = ISNULL((SELECT ACC_TYPE_ID FROM SETUP_PAYMENT_INTERRUPTION WHERE ODKES_ID =CORRESPONDENCE_PAYMENT.DEMAND_TYPE),-2)) ACC_TYPE_NAME
                    FROM 
	                    CORRESPONDENCE_PAYMENT 
                    WHERE 
                    	ID = #attributes.payment_id#
				</cfquery>
				<cfscript>
					last_month_1 = CreateDateTime(year(get_demand.duedate), month(get_demand.duedate),1,0,0,0);
					last_month_30 = CreateDateTime(year(get_demand.duedate), month(get_demand.duedate),daysinmonth(last_month_1),23,59,59);
				</cfscript>
				<cfquery name="get_in_out_id" datasource="#dsn#">
					SELECT 
						EIO.IN_OUT_ID,
						PUANTAJ_GROUP_IDS,
						BRANCH_ID
					FROM
						EMPLOYEES_IN_OUT EIO
					WHERE
						EIO.IN_OUT_ID = #attributes.employee_in_out_id#
				</cfquery>
				<cfset attributes.sal_mon = MONTH(get_demand.duedate)>
				<cfset attributes.sal_year = YEAR(get_demand.duedate)>
				<cfset attributes.group_id = "">
				<cfif len(get_in_out_id.puantaj_group_ids)>
					<cfset attributes.group_id = "#get_in_out_id.PUANTAJ_GROUP_IDS#,">
				</cfif>
				<cfset attributes.branch_id = get_in_out_id.branch_id>
				<cfset not_kontrol_parameter = 1>
				<cfinclude template="../query/get_program_parameter.cfm">
				<cfquery name="add_row" datasource="#dsn#">
					INSERT INTO
						SALARYPARAM_GET
					(
						COMMENT_GET,
						AMOUNT_GET,
						TOTAL_GET,
						SHOW,
						METHOD_GET,
						PERIOD_GET, 
						START_SAL_MON,
						END_SAL_MON,
						EMPLOYEE_ID,
						TERM,
						CALC_DAYS,
						FROM_SALARY,
						IN_OUT_ID,
						IS_INST_AVANS,
						DETAIL,
						ACCOUNT_CODE,
						ACCOUNT_NAME,
						COMPANY_ID,
						CONSUMER_ID,
						ACC_TYPE_ID,
						MONEY,
						PAYMENT_ID,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
					VALUES
					(
						'#get_demand.ACC_TYPE_NAME#',
						#get_demand.AMOUNT#,
						#get_demand.AMOUNT#,
						<cfif isDefined("get_demand.show") and len(get_demand.show)>#get_demand.show#<cfelseif get_program_parameters.recordcount and get_program_parameters.is_avans_off>0<cfelse>1</cfif>,
						1,
						1,
						#month(get_demand.duedate)#,
						#month(get_demand.duedate)#,
						#get_demand.to_employee_id#,
						#year(get_demand.duedate)#,
						0,
						0,
						#attributes.employee_in_out_id#,
						0,
						<cfif isdefined("get_payment.detail") and len(get_payment.detail)>'#get_payment.detail#'<cfelse>NULL</cfif>,
						<cfif isDefined("get_program_parameters.account_code") and len(get_program_parameters.account_code)>'#get_program_parameters.account_code#'<cfelse>NULL</cfif>,
						<cfif isDefined("get_program_parameters.account_name") and len(get_program_parameters.account_name)>'#get_program_parameters.account_name#'<cfelse>NULL</cfif>,
						<cfif isDefined("get_program_parameters.company_id") and len(get_program_parameters.company_id)>#get_program_parameters.company_id#<cfelse>NULL</cfif>,
						<cfif isDefined("get_program_parameters.consumer_id") and len(get_program_parameters.consumer_id)>#get_program_parameters.consumer_id#<cfelse>NULL</cfif>,
						<cfif isDefined("get_demand.acc_type_id") and len(get_demand.acc_type_id)>#get_demand.acc_type_id#<cfelseif isDefined("get_program_parameters.acc_type_id") and len(get_program_parameters.acc_type_id)>#get_program_parameters.acc_type_id#<cfelse>NULL</cfif>,
						<cfif isdefined("get_payment.money")>'#get_payment.money#'<cfelse>NULL</cfif>,
						#attributes.payment_id#,
						#NOW()#,
						#SESSION.EP.USERID#,
						'#CGI.REMOTE_ADDR#'
					)
				</cfquery>
			</cfif>
		<cfelseif attributes.upd_id eq 0>
			<cfquery name="DENY_PR" datasource="#DSN#">
				UPDATE
					CORRESPONDENCE_PAYMENT
				SET
					STATUS=#upd_id#,
					VALID_EMP=#SESSION.EP.USERID#,
					VALID_DATE=#NOW()#
				WHERE
					ID=#attributes.payment_id#		
			</cfquery>
		</cfif>
		<cfquery name="get_payment" datasource="#dsn#">
			SELECT 
                ID, 
                PROCESS_STAGE, 
                PRIORITY,
                SUBJECT, 
                DUEDATE, 
                PAYMETHOD_ID, 
                TO_EMPLOYEE_ID, 
                AMOUNT, 
                MONEY, 
                DETAIL,
                STATUS,
                VALID_EMP, 
                VALID_DATE, 
                PERIOD_ID, 
                IN_OUT_ID, 
                VALID_1, 
                VALIDATOR_POSITION_CODE_1, 
                VALID_2, 
                VALIDATOR_POSITION_CODE_2, 
                VALID_1_DETAIL, 
                VALID_2_DETAIL, 
                ACTION_ID, 
                RECORD_IP, 
                RECORD_EMP, 
                RECORD_DATE, 
                UPDATE_EMP, 
                UPDATE_DATE, 
                UPDATE_IP 
            FROM 
	            CORRESPONDENCE_PAYMENT 
            WHERE 
            	ID = #attributes.payment_id#
		</cfquery>
	</cftransaction>
</cflock>
<cf_workcube_process
	is_upd='1'
	old_process_line='0'
	process_stage='#get_payment.process_stage#'
	record_member='#session.ep.userid#'
	record_date='#now()#'
	action_table='CORRESPONDENCE_PAYMENT'
	action_column='ID'
	action_id='#attributes.payment_id#'
	action_page='#request.self#?fuseaction=ehesap.list_payment_requests'
	warning_description = 'Konu : #get_payment.subject#'>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

