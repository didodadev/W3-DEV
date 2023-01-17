<cfif isdefined("attributes.record_num")>
	<cflock timeout="60" name="#CreateUUID()#">
		<cftransaction>	
			<cfif len(attributes.documentdate)>
				<cfset paper_date = attributes.documentdate>
				<cf_date tarih ="attributes.documentdate">
			<cfelse>
				<cfset paper_date = now()>
			</cfif>
			<cf_papers paper_type="additional_allowance">
			<cfset employee_id = attributes.employee_id>
			<cfset employee_id = employee_id.Split("_")>
			<cfset totalValues = 0>
			<cfset action_list_id = ''>

			<cfset attributes.employee_id = employee_id[1]>
			<cfquery name="UPD_BONUS_PAYROLL" datasource="#dsn#">
				UPDATE
					BONUS_PAYROLL
				SET
					PAPER_NO = <cfif len(attributes.PAPER_NO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.paper_no#"><cfelse>NULL</cfif>,
					PROCESS_ID	= <cfif len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
					PROCESS_CAT = <cfif len(attributes.process_cat)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#"><cfelse>NULL</cfif>,
					EMPLOYEE_ID = <cfif len(attributes.employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"><cfelse>NULL</cfif>,	
					PAPER_DATE = <cfif len(attributes.documentdate)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.documentdate#"><cfelse>NULL</cfif>,
					DETAIL = <cfif len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>,
					RECORD_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
					RECORD_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
				WHERE
					BONUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bonus_id#">
			</cfquery>
			<cfquery name="DEL_BONUS" datasource="#dsn#">
				DELETE FROM SALARYPARAM_PAY WHERE BONUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bonus_id#">
			</cfquery>
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif evaluate("attributes.row_kontrol_#i#") eq 1 and len(evaluate("attributes.employee_id#i#")) and len(evaluate("attributes.comment_pay#i#"))>
					<cfquery name="get_types" datasource="#dsn#">
						SELECT 
							ODKES_ID, 
							COMMENT_PAY, 
							PERIOD_PAY,
							METHOD_PAY, 
							AMOUNT_PAY, 
							SSK, 
							TAX, 
							SHOW, 
							START_SAL_MON, 
							END_SAL_MON, 
							IS_ODENEK, 
							CALC_DAYS, 
							FROM_SALARY, 
							IS_KIDEM, 
							RECORD_DATE, 
							RECORD_EMP, 
							RECORD_IP,
							UPDATE_EMP,
							UPDATE_DATE, 
							UPDATE_IP, 
							IS_ISSIZLIK, 
							IS_DAMGA, 
							SSK_EXEMPTION_RATE, 
							TAX_EXEMPTION_RATE, 
							TAX_EXEMPTION_VALUE, 
							IS_AYNI_YARDIM, 
							MONEY, 
							IS_INCOME,
							SSK_EXEMPTION_TYPE, 
							AMOUNT_MULTIPLIER,
							FACTOR_TYPE,
							COMMENT_TYPE,
							SSK_STATUE,
							STATUE_TYPE
						FROM 
							SETUP_PAYMENT_INTERRUPTION 
						WHERE 
							ODKES_ID = #evaluate("attributes.odkes_id#i#")# AND IS_ODENEK = 1
					</cfquery>
					<cfquery name="add_row" datasource="#dsn#">
						INSERT INTO SALARYPARAM_PAY
							(
							COMMENT_PAY,
							COMMENT_PAY_ID,
							AMOUNT_PAY,
							AMOUNT_MULTIPLIER,
							SSK,
							TAX,
							IS_DAMGA,
							IS_ISSIZLIK,
							METHOD_PAY,
							PERIOD_PAY,
							START_SAL_MON,
							END_SAL_MON,
							EMPLOYEE_ID,
							TERM,
							CALC_DAYS,
							IS_KIDEM,
							SHOW,
							FROM_SALARY,
							IN_OUT_ID,
							IS_AYNI_YARDIM,
							SSK_EXEMPTION_RATE,
							SSK_EXEMPTION_TYPE,
							TAX_EXEMPTION_VALUE,
							MONEY,
							IS_INCOME,
							FACTOR_TYPE,
							COMMENT_TYPE,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP,
							BONUS_ID,
							PROJECT_ID,
							SSK_STATUE,
							STATUE_TYPE,
							PROCESS_STAGE
							)
						VALUES
							(
							<cfif len(get_types.comment_pay)>'#get_types.comment_pay#'<cfelse>NULL</cfif>,
							#evaluate("attributes.odkes_id#i#")#,
							#evaluate("attributes.amount_pay#i#")#,
							<cfif len(get_types.AMOUNT_MULTIPLIER)>#get_types.AMOUNT_MULTIPLIER#<cfelse>NULL</cfif>,
							<cfif len(get_types.ssk)>#get_types.ssk#<cfelse>0</cfif>,
							<cfif len(get_types.tax)>#get_types.tax#<cfelse>0</cfif>,
							1,
							<cfif len(get_types.IS_ISSIZLIK)>#get_types.IS_ISSIZLIK#<cfelse>0</cfif>,
							<cfif len(get_types.method_pay)>#get_types.method_pay#<cfelse>0</cfif>,
							<cfif len(get_types.period_pay)>#get_types.period_pay#<cfelse>0</cfif>,
							#evaluate("attributes.start_sal_mon#i#")#,
							#evaluate("attributes.end_sal_mon#i#")#,
							#evaluate("attributes.employee_id#i#")#,
							#evaluate("attributes.term#i#")#,
							#get_types.calc_days#,
							#get_types.is_kidem#,
							#get_types.show#,
							#get_types.from_salary#,
							<cfif isdefined("attributes.employee_in_out_id#i#") and len(evaluate("attributes.employee_in_out_id#i#"))>#evaluate("attributes.employee_in_out_id#i#")#<cfelse>NULL</cfif>,
							0,
							<cfif len(get_types.SSK_EXEMPTION_RATE)>#get_types.SSK_EXEMPTION_RATE#<cfelse>NULL</cfif>,
							<cfif len(get_types.SSK_EXEMPTION_TYPE)>#get_types.SSK_EXEMPTION_TYPE#<cfelse>NULL</cfif>,
							<cfif len(get_types.TAX_EXEMPTION_VALUE)>#get_types.TAX_EXEMPTION_VALUE#<cfelse>NULL</cfif>,
							'#session.ep.money#',
							<cfif len(get_types.IS_INCOME)>#get_types.IS_INCOME#<cfelse>0</cfif>,
							<cfif len(get_types.FACTOR_TYPE)>#get_types.FACTOR_TYPE#<cfelse>NULL</cfif>,
							<cfif len(get_types.COMMENT_TYPE)>#get_types.COMMENT_TYPE#<cfelse>1</cfif>,
							#now()#,
							#session.ep.userid#,
							'#cgi.REMOTE_ADDR#',
							<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.bonus_id#">,
							<cfif isdefined("attributes.project_id#i#") and len(evaluate("attributes.project_id#i#")) and len(evaluate("attributes.project_head#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("attributes.project_id#i#")#"><cfelse>NULL</cfif>,
							<cfif len(get_types.SSK_STATUE)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_types.SSK_STATUE#"><cfelse>1</cfif>,
							<cfif len(get_types.SSK_STATUE) and len(get_types.STATUE_TYPE) and get_types.SSK_STATUE eq 2><cfqueryparam cfsqltype="cf_sql_integer" value="#get_types.STATUE_TYPE#"><cfelse>0</cfif>,
							<cfif len(evaluate("attributes.process_stage_#i#"))><cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate('attributes.process_stage_#i#')#"><cfelse></cfif>
						)
					</cfquery>
					<cfset totalValues = totalValues + evaluate("attributes.amount_pay#i#")>
					<cfset action_list_id = listAppend(action_list_id, evaluate("attributes.employee_in_out_id#i#"))>
				</cfif>
			</cfloop>
			<cfset totalValues_ = structNew()>
			<cfset totalValues_ = {
					total_pay : totalValues
				}>
            <cf_workcube_process 
                is_upd='1' 
                old_process_line='0'
                process_stage='#attributes.process_stage#' 
                record_member='#session.ep.userid#' 
                record_date='#now()#'
                action_table='BONUS_PAYROLL'
                action_column='BONUS_ID'
                action_id='#attributes.bonus_id#'
                action_page='#request.self#?fuseaction=ehesap.list_payments&event=bonus&bonus_id=#attributes.bonus_id#' 
                warning_description='Prim Odemesi'>
		</cftransaction>
	</cflock>
</cfif>

<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=ehesap.list_payments&event=bonus&bonus_id=#attributes.bonus_id#</cfoutput>";
</script>