<cflock timeout="20">
	<cftransaction>
		<cfset attributes.action_section="EMPLOYEE_ID">
		<cfset attributes.action_id=attributes.EMPLOYEE_ID>
		<cfinclude template="../../objects/query/del_assets.cfm">
		<cfquery name="GET_POSITION" datasource="#DSN#">
			SELECT * FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		</cfquery>
		<cfquery name="GET_EMP_NAME" datasource="#DSN#">
			SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_STAGE FROM EMPLOYEES WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		</cfquery>
		<cfif GET_POSITION.recordcount>
				<cfquery name="upd_position" datasource="#dsn#">
					UPDATE 
						EMPLOYEE_POSITIONS
					SET
						EMPLOYEE_ID = 0,
						EMPLOYEE_NAME = NULL,
						EMPLOYEE_SURNAME = NULL,
						EMPLOYEE_EMAIL = NULL,
						POSITION_STATUS = 0,
						VALID_DATE = NULL,
						VALID_MEMBER = NULL,
						VALID = NULL
					WHERE 
						EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
				</cfquery>
			<cfloop query="GET_POSITION">
				<cfquery name="add_position_history" datasource="#dsn#">
					INSERT INTO 
						EMPLOYEE_POSITIONS_HISTORY
						(
						POSITION_ID,
						POSITION_CODE,
						EMPLOYEE_ID,
						EMPLOYEE_NAME,
						EMPLOYEE_SURNAME,
						EMPLOYEE_EMAIL,
						POSITION_NAME,
						DETAIL,
						START_DATE,
						FINISH_DATE,
						POSITION_STATUS,
						DEPARTMENT_ID,
						LEVEL_ID,
						USER_GROUP_ID,
						ISFULL
						)
					VALUES
						(
						#GET_POSITION.POSITION_ID#,
						#GET_POSITION.POSITION_CODE#,
						0,
						NULL,
						NULL,
						NULL,
						'#GET_POSITION.POSITION_NAME#',
						'#GET_POSITION.DETAIL#',
						#NOW()#,
						NULL,
						0,
						#GET_POSITION.DEPARTMENT_ID#,
						'#GET_POSITION.LEVEL_ID#',
					<cfif len(GET_POSITION.USER_GROUP_ID)>
						#GET_POSITION.USER_GROUP_ID#,
					<cfelse>
						NULL,
					</cfif>
						0
						)
				</cfquery>
			</cfloop>
			<cfquery name="del_emp" datasource="#dsn#">
				DELETE FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #GET_POSITION.POSITION_CODE#
			</cfquery>
			<cfquery name="del_emp" datasource="#dsn#">
				DELETE FROM EMPLOYEE_POSITION_PERIODS WHERE POSITION_ID = #GET_POSITION.POSITION_ID#
			</cfquery>
		</cfif>
		<cfquery name="del_emp_pos_bank_accounts" datasource="#dsn#">
			DELETE FROM EMPLOYEES_BANK_ACCOUNTS WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		</cfquery>
		<cfquery name="del_emp_salary_history" datasource="#dsn#">
			DELETE FROM EMPLOYEES_SALARY_HISTORY WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		</cfquery>
		<cfquery name="del_emp_pro_work_history" datasource="#dsn#">
			DELETE FROM PRO_WORKS_HISTORY WHERE PROJECT_EMP_ID = #attributes.EMPLOYEE_ID#
		</cfquery>
		<cfquery name="del_emp_pro_project_history" datasource="#dsn#">
			DELETE FROM PRO_HISTORY WHERE PROJECT_EMP_ID = #attributes.EMPLOYEE_ID#
		</cfquery>
		<cfquery name="del_emp1" datasource="#dsn#">
			DELETE FROM EMPLOYEE_HEALTY WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		</cfquery>
		<cfquery name="del_emp2" datasource="#dsn#">
			DELETE FROM EMPLOYEE_HEALTY_REPORT WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		</cfquery>
		<cfquery name="del_emp3" datasource="#dsn#">
			DELETE FROM EMPLOYEE_PERFORMANCE WHERE EMP_ID = #attributes.EMPLOYEE_ID#
		</cfquery>
		<cfquery name="del_emp5" datasource="#dsn#">
			DELETE FROM EMPLOYEE_REQUIREMENTS WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		</cfquery>
		<cfquery name="del_emp6" datasource="#dsn#">
			DELETE FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		</cfquery>
		<cfquery name="del_emp7" datasource="#dsn#">
			DELETE FROM OFFTIME WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		</cfquery>
		<cfquery name="del_emp9" datasource="#dsn#">
			DELETE FROM EMPLOYEES_CAUTION WHERE CAUTION_TO = #attributes.EMPLOYEE_ID#
		</cfquery>
		<cfquery name="del_emp10" datasource="#dsn#">
			DELETE FROM EMPLOYEES_PRIZE WHERE PRIZE_TO = #attributes.EMPLOYEE_ID#
		</cfquery>
		<cfquery name="del_emp4" datasource="#dsn#">
			DELETE FROM EMPLOYEES_IDENTY WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		</cfquery>
		<cfquery name="del_emp8" datasource="#dsn#">
			DELETE FROM MY_SETTINGS WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		</cfquery>
		<cfquery name="del_emp_pos_bank_accounts" datasource="#dsn#">
			DELETE FROM EMPLOYEES_DETAIL WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		</cfquery>
		<cfquery name="del_emp" datasource="#dsn#">
			DELETE FROM EMPLOYEES WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		</cfquery>
		<!--- İş Tecrübeleri --->
		<cfquery name="employees_app_work_list" datasource="#dsn#">
			SELECT * FROM EMPLOYEES_APP_WORK_INFO WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		</cfquery>
		<cfif employees_app_work_list.recordcount>
			<cfquery name="del_employees_app_work" datasource="#dsn#">
				DELETE FROM EMPLOYEES_APP_WORK_INFO WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
			</cfquery>
		</cfif>
		<cf_add_log  log_type="-1" action_id="#attributes.employee_id#" action_name="#attributes.head#" process_stage="#get_emp_name.employee_stage#">
	</CFTRANSACTION>
</CFLOCK>
<script type="text/javascript">
	alert("<cf_get_lang no ='1744.Silme İşlemi Başarı İle Tamamlandı'>!");
	window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=hr.list_hr';
</script>
<cfabort>
<cflocation url="#request.self#?fuseaction=hr.list_hr" addtoken="No">
