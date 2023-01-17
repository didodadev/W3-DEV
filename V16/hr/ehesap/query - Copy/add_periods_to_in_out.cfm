<!--- transaction blogundan cikarildi --->
<cfquery name="GET_EMP_ID" datasource="#dsn#">
	SELECT
		EMPLOYEE_ID
	FROM
		EMPLOYEES_IN_OUT
	WHERE
		IN_OUT_ID  = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
</cfquery>
<cfquery name="del_rows" datasource="#dsn#">
    DELETE FROM EMPLOYEES_ACCOUNTS 
    WHERE 
    	EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_id.employee_id#"> AND 
        PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#"> AND
        IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
</cfquery>
<cflock name="#createUUID()#" timeout="60">			
	<cftransaction>
		<cfquery name="control_" datasource="#dsn#">
			SELECT
				IN_OUT_ID
			FROM
				EMPLOYEES_IN_OUT_PERIOD
			WHERE
				IN_OUT_ID  = #attributes.in_out_id# AND
				PERIOD_ID = #attributes.period_id#
		</cfquery>
		<cfif control_.recordcount>
			<cfquery name="upd_" datasource="#dsn#">
				UPDATE
					EMPLOYEES_IN_OUT_PERIOD
				SET
					ACCOUNT_BILL_TYPE = <cfif len(attributes.period_code_cat)>#attributes.period_code_cat#,<cfelse>NULL,</cfif>
					ACCOUNT_CODE = <cfif isdefined("attributes.ACCOUNT_CODE") and len(attributes.ACCOUNT_CODE) and len(attributes.ACCOUNT_NAME)>'#ACCOUNT_CODE#'<cfelse>NULL</cfif>,
					ACCOUNT_NAME = <cfif isdefined("attributes.ACCOUNT_CODE") and len(attributes.ACCOUNT_CODE) and len(attributes.ACCOUNT_NAME)>'#listlast(attributes.account_name,'-')#'<cfelse>NULL</cfif>,
					EXPENSE_ITEM_ID = <cfif len(attributes.expense_item_id) and len(attributes.expense_item_name)>#attributes.expense_item_id#<cfelse>NULL</cfif>,
					EXPENSE_ITEM_NAME = <cfif len(attributes.expense_item_id) and len(attributes.expense_item_name)>'#attributes.expense_item_name#'<cfelse>NULL</cfif>,
					EXPENSE_CENTER_ID = <cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id)>#attributes.expense_center_id#<cfelse>NULL</cfif>,
					EXPENSE_CODE = <cfif isdefined("attributes.EXPENSE_CODE") and len(attributes.EXPENSE_CODE) and len(attributes.EXPENSE_CODE_NAME)>'#attributes.EXPENSE_CODE#'<cfelse>NULL</cfif>,
					EXPENSE_CODE_NAME = <cfif isdefined("attributes.EXPENSE_CODE") and len(attributes.EXPENSE_CODE) and len(attributes.EXPENSE_CODE_NAME)>'#attributes.EXPENSE_CODE_NAME#'<cfelse>NULL</cfif>,
					PERIOD_COMPANY_ID = #session.ep.company_id#,
					PERIOD_YEAR = #session.ep.period_year#,
					UPDATE_DATE = #NOW()#,
					UPDATE_EMP = #SESSION.EP.USERID#,
					UPDATE_IP = '#CGI.REMOTE_ADDR#'
				WHERE
					IN_OUT_ID  = #attributes.in_out_id# AND
					PERIOD_ID = #attributes.period_id#
			</cfquery>
		<cfelse> 
			<cfquery name="add_" datasource="#dsn#">
				INSERT INTO
					EMPLOYEES_IN_OUT_PERIOD
					(
					ACCOUNT_BILL_TYPE,
					ACCOUNT_CODE,
					ACCOUNT_NAME,
					EXPENSE_ITEM_ID,
					EXPENSE_ITEM_NAME,
					EXPENSE_CENTER_ID,
					EXPENSE_CODE,
					EXPENSE_CODE_NAME,
					PERIOD_COMPANY_ID,
					PERIOD_YEAR,
					IN_OUT_ID,
					PERIOD_ID,
					RECORD_IP,
					RECORD_DATE,
					RECORD_EMP
					)
				VALUES
					(
					<cfif len(attributes.period_code_cat)>#attributes.period_code_cat#,<cfelse>NULL,</cfif>
					<cfif isdefined("attributes.ACCOUNT_CODE") and len(attributes.ACCOUNT_CODE) and len(attributes.ACCOUNT_NAME)>'#ACCOUNT_CODE#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.ACCOUNT_CODE") and len(attributes.ACCOUNT_CODE) and len(attributes.ACCOUNT_NAME)>'#listlast(attributes.account_name,'-')#'<cfelse>NULL</cfif>,
					<cfif len(attributes.expense_item_id) and len(attributes.expense_item_name)>#attributes.expense_item_id#<cfelse>NULL</cfif>,
					<cfif len(attributes.expense_item_id) and len(attributes.expense_item_name)>'#attributes.expense_item_name#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.expense_center_id") and len(attributes.expense_center_id)>#attributes.expense_center_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.EXPENSE_CODE") and len(attributes.EXPENSE_CODE) and len(attributes.EXPENSE_CODE_NAME)>'#attributes.EXPENSE_CODE#'<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.EXPENSE_CODE") and len(attributes.EXPENSE_CODE) and len(attributes.EXPENSE_CODE_NAME)>'#attributes.EXPENSE_CODE_NAME#'<cfelse>NULL</cfif>,
					#session.ep.company_id#,
					#session.ep.period_year#,
					#attributes.in_out_id#,
					#attributes.period_id#,
					'#CGI.REMOTE_ADDR#',
					#NOW()#,
					#SESSION.EP.USERID#
					)
			</cfquery>
		</cfif>
		<!--- ilişkili hesaplar ekleniyor --->
		<cfif isdefined("attributes.record_num")>
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif isdefined("attributes.row_kontrol_#i#") and evaluate("attributes.row_kontrol_#i#") eq 1>
					<cfif Evaluate("attributes.acc_type_id_#i#") eq -1>
						<cfquery name="upd_" datasource="#dsn#">
							UPDATE
								EMPLOYEES_IN_OUT_PERIOD
							SET
								ACCOUNT_CODE = <cfif isdefined("attributes.account_code_#i#") and len(Evaluate("attributes.account_code_#i#"))>'#Evaluate("attributes.account_code_#i#")#'<cfelse>NULL</cfif>
							WHERE
								IN_OUT_ID  = #attributes.in_out_id# AND
								PERIOD_ID = #attributes.period_id#
						</cfquery>
					</cfif>
					<cfquery name="add_row" datasource="#dsn#">
						INSERT INTO EMPLOYEES_ACCOUNTS 
						(
							ACC_TYPE_ID,
							ACCOUNT_CODE,
							PERIOD_ID,
							IN_OUT_ID,
							EMPLOYEE_ID
						)
						VALUES
						(	
							#Evaluate("attributes.acc_type_id_#i#")#,
							'#Evaluate("attributes.account_code_#i#")#',
							#attributes.period_id#,
							#attributes.in_out_id#,
							#get_emp_id.employee_id#
						)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
		<!--- ilişkili masraf merkezleri ekleniyor --->
		<cfquery name="del_rows" datasource="#dsn#">
			DELETE FROM EMPLOYEES_IN_OUT_PERIOD_ROW WHERE IN_OUT_ID  = #attributes.in_out_id# AND PERIOD_ID = #attributes.period_id#
		</cfquery>
		<cfif isdefined("attributes.record_num_2")>
			<cfloop from="1" to="#attributes.record_num_2#" index="i">
				<cfif isdefined("attributes.row_kontrol_2_#i#") and evaluate("attributes.row_kontrol_2_#i#") eq 1>
					<cfquery name="add_row" datasource="#dsn#">
						INSERT INTO EMPLOYEES_IN_OUT_PERIOD_ROW 
						(
							PERIOD_ID,
							IN_OUT_ID,
							EXPENSE_CENTER_ID,
							RATE,
							ACTIVITY_TYPE_ID
						)
						VALUES
						(	
							#attributes.period_id#,
							#attributes.in_out_id#,
							#Evaluate("attributes.expense_center_id#i#")#,
							#filterNum(Evaluate("attributes.rate#i#"))#,
							<cfif len(Evaluate("attributes.expense_activity_id#i#"))>#Evaluate("attributes.expense_activity_id#i#")#<cfelse>NULL</cfif>
						)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	<cfif fusebox.circuit is 'account'>
		window.location.href="<cfoutput>#request.self#?fuseaction=account.list_employee_accounts&event=upd&in_out_id=#attributes.in_out_id#&period_id=#attributes.period_id#</cfoutput>";
	<cfelse>
		<cfif isdefined("attributes.from_upd_salary") and len(attributes.from_upd_salary)>
			<cflocation url="#request.self#?fuseaction=ehesap.list_salary&event=upd&in_out_id=#attributes.in_out_id#&employee_id=#get_emp_id.employee_id#&type=3" addtoken="No">
			location.reload();
		<cfelseif not isdefined("attributes.draggable")>
			window.location.href="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.popup_list_period&in_out_id=#attributes.in_out_id#&period_id=#attributes.period_id#</cfoutput>";
		<cfelse>
			closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
			location.reload();
		</cfif>
	</cfif>
</script>

