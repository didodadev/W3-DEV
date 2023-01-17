<cfset upload_folder = "#upload_folder#ehesap#dir_seperator#">
<cfif not directoryexists("#upload_folder#ehesap#dir_seperator#")>
	<cfdirectory action="create" directory="#upload_folder#ehesap#dir_seperator#">
</cfif>

<cf_date tarih='attributes.commandment_date'>
<cf_date tarih='attributes.employee_approve_date'>
<cfset attributes.commandment_date = dateadd('h',attributes.commandment_date_hour,attributes.commandment_date)>
<cfset attributes.commandment_date = dateadd('n',attributes.commandment_date_min,attributes.commandment_date)>
<cflock timeout="60">
	<cftransaction>
		<cfquery name="add_penalty" datasource="#dsn#" result="get_max">
			INSERT INTO
				COMMANDMENT
				(
				COMMANDMENT_DATE,
				COMMANDMENT_VALUE,
				RATE_VALUE,
				PRE_COMMANDMENT_VALUE,
				EMPLOYEE_ID,
				SERIAL_NO,
				SERIAL_NUMBER,
				COMMANDMENT_DETAIL,
				COMMANDMENT_OFFICE,
				IBAN_NO,
				TYPE_ID,
				PRIORITY,
				COMMANDMENT_TYPE,
				RECORD_DATE,
				RECORD_EMP,
				ACCOUNT_CODE,
				ACC_TYPE_ID,
				ADD_PAYMENT_TYPE,
				ACCOUNT_NAME,
				PROCESS_STAGE,
				EMP_APPROVE,
				EMP_APPROVE_DATE,
                RATE_VALUE_STATIC
				)
				VALUES
				(
				#attributes.commandment_date#,
				#filternum(attributes.commandment_value)#,
				#attributes.rate_value#,
				0,
				#attributes.employee_id#,
				'#attributes.serial_no#',
				'#attributes.serial_number#',
				'#attributes.commandment_detail#',
				'#attributes.COMMANDMENT_OFFICE#',
				'#attributes.iban_no#',
				#attributes.type_id#,
				#attributes.priority#,
				#attributes.commandment_type#,
				#now()#,
				#session.ep.userid#,
				<cfif isdefined('attributes.account_code')>'#attributes.account_code#'<cfelse>NULL</cfif>,
				<cfif len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>,
				#attributes.add_payment_type#,
				'#attributes.account_name#',
				<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"><cfelse>NULL</cfif>,
				<cfif isdefined('attributes.emp_approve')>1<cfelse>0</cfif>,
				<cfif isdefined('attributes.employee_approve_date') and len(attributes.employee_approve_date)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.employee_approve_date#"><cfelse>NULL</cfif>,
                <cfif isdefined('attributes.RATE_VALUE_STATIC') and len(attributes.RATE_VALUE_STATIC)>#filternum(attributes.RATE_VALUE_STATIC)#<cfelse>0</cfif>
				)
		</cfquery>
		<cfset max_id = get_max.identitycol>

		<cfquery name="add_history" datasource="#dsn#">
			INSERT INTO
				COMMANDMENT_HISTORY
				(
				COMMANDMENT_ID,
				DETAIL,
				RECORD_DATE,
				COMMANDMENT_DATE,
				RECORD_EMP,
				COMMANDMENT_VALUE,
				COMMANDMENT_OFFICE,
				COMMANDMENT_DETAIL,
				IS_REFUSE,
				IS_APPLY,
				IS_TRANSFER,
				EMPLOYEE_ID,
				PROJECT_ID,
				SERIAL_NO,
				SERIAL_NUMBER,
				PROCESS_STAGE,
				COMMANDMENT_FILE,
				IBAN_NO,
				PRE_COMMANDMENT_VALUE,
				RATE_VALUE,
				IS_CVP,
				ODENEN,
				COMMANDMENT_TYPE,
				TYPE_ID,
				PRIORITY,
				UPDATE_DATE,
				UPDATE_EMP,
				IS_MANUEL_CLOSED,
				ACCOUNT_CODE,
				ACC_TYPE_ID,
				ADD_PAYMENT_TYPE,
				ACCOUNT_NAME,
				EMP_APPROVE,
				EMP_APPROVE_DATE,
                RATE_VALUE_STATIC
				)
				SELECT
					COMMANDMENT_ID,
					DETAIL,
					RECORD_DATE,
					COMMANDMENT_DATE,
					RECORD_EMP,
					COMMANDMENT_VALUE,
					COMMANDMENT_OFFICE,
					COMMANDMENT_DETAIL,
					IS_REFUSE,
					IS_APPLY,
					IS_TRANSFER,
					EMPLOYEE_ID,
					PROJECT_ID,
					SERIAL_NO,
					SERIAL_NUMBER,
					PROCESS_STAGE,
					COMMANDMENT_FILE,
					IBAN_NO,
					PRE_COMMANDMENT_VALUE,
					RATE_VALUE,
					IS_CVP,
					ODENEN,
					COMMANDMENT_TYPE,
					TYPE_ID,
					PRIORITY,
					UPDATE_DATE,
					UPDATE_EMP,
					IS_MANUEL_CLOSED,
					ACCOUNT_CODE,
					ACC_TYPE_ID,
					ADD_PAYMENT_TYPE,
					ACCOUNT_NAME,
					EMP_APPROVE,
					EMP_APPROVE_DATE,
                    RATE_VALUE_STATIC
				FROM
					COMMANDMENT
				WHERE
					COMMANDMENT_ID = #max_id#
		</cfquery>

		<cfif isDefined("form.commandment_file") and len(form.commandment_file)>
			<cftry>
				<cffile
					action="UPLOAD" 
					filefield="commandment_file" 
					destination="#upload_folder#" 
					mode="777" 
					nameconflict="MAKEUNIQUE"
					>
					
					<cfset file_name = 'icra_#max_id#'>
					<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
					<cfset attributes.file_ = '#file_name#.#cffile.serverfileext#'>
				<cfcatch type="Any">
					<script type="text/javascript">
						alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
					</script>
					<cfset attributes.file_ = ''>
				</cfcatch>  
			</cftry>
		<cfelse>
			<cfset attributes.file_ = ''>
		</cfif>

		<cfquery name="upd_" datasource="#dsn#">
			UPDATE
				COMMANDMENT
			SET
				COMMANDMENT_FILE = '#attributes.file_#'
			WHERE
				COMMANDMENT_ID = #max_id#
		</cfquery>

		<cfquery name="get_doc" datasource="#dsn#">
			SELECT
				*
			FROM
				COMMANDMENT
			WHERE
				COMMANDMENT_ID = #max_id#
		</cfquery>
		<cfif isdefined('attributes.process_stage') and len(attributes.process_stage)>
			<cf_workcube_process 
				is_upd='1' 
				old_process_line='0'
				process_stage='#attributes.process_stage#' 
				record_member='#session.ep.userid#' 
				record_date='#now()#' 
				action_page='#request.self#?fuseaction=ehesap.list_executions&event=upd&id=#max_id#' 
				action_id='#max_id#'
				warning_description = 'İcralar : #max_id#'>
		</cfif>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href = '<cfoutput>index.cfm?fuseaction=ehesap.list_executions&event=upd&id=#max_id#</cfoutput>';
	
</script>