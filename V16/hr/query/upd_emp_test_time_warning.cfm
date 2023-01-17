<cfif len(caution_time) and (caution_time neq 0)>
	<cfquery name="get_pos_code_member" datasource="#dsn#">
		SELECT 
			POSITION_CODE,
			UPPER_POSITION_CODE
		FROM 
			EMPLOYEE_POSITIONS
		WHERE 
			EMPLOYEE_ID = #attributes.emp_id# 
	</cfquery>
	<cfif len(caution_emp_id) and isdefined('attributes.control_upd') and len(attributes.control_upd) and attributes.control_upd eq 1>
		<cfquery name="get_survey_main" datasource="#dsn#">
			SELECT SURVEY_MAIN_RESULT_ID FROM SURVEY_MAIN_RESULT WHERE ACTION_ID = #attributes.EMP_ID# AND SURVEY_MAIN_ID = #quiz_id#
		</cfquery>
		<cfif get_survey_main.recordCount>
			<cfquery name="upd_survey_result" datasource="#dsn#">
				UPDATE
					SURVEY_MAIN_RESULT
				SET
					ACTION_TYPE = 6,
					EMP_ID = #caution_emp_id#,
					UPDATE_DATE = #now()#,
					UPDATE_EMP = #session.ep.userid#,
					UPDATE_IP = '#cgi.REMOTE_ADDR#',
					PROCESS_ROW_ID = #attributes.process_stage#
				WHERE 
					SURVEY_MAIN_RESULT_ID = #get_survey_main.survey_main_result_id#
			</cfquery>
		<cfelse>
			<!--- deneme süresi için kayıt oluşturuluyor--->
			<cfquery name="add_survey_result" datasource="#dsn#" result="SURVEY_MAIN">
				INSERT INTO
				SURVEY_MAIN_RESULT
				(
					SURVEY_MAIN_ID,
					ACTION_TYPE,
					ACTION_ID,
					EMP_ID,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP,
					PROCESS_ROW_ID
				)
				VALUES
				(
					#quiz_id#,
					6,<!--- deneme süresi tipi--->
					#attributes.EMP_ID#,
					#caution_emp_id#,
					<cfif isdefined("warning_date") and len(warning_date)>#warning_date#<cfelse>#now()#</cfif>,
					#session.ep.userid#,
					'#cgi.REMOTE_ADDR#',
					#attributes.process_stage#
				)
			</cfquery>
		</cfif>
		<cfif get_survey_main.recordCount>
			<cfquery name="get_process_stage" datasource="#dsn#">
				SELECT PROCESS_ROW_ID FROM SURVEY_MAIN_RESULT WHERE SURVEY_MAIN_RESULT_ID = #get_survey_main.survey_main_result_id#
			</cfquery>
		<cfelse>
			<cfquery name="get_process_stage" datasource="#dsn#">
				SELECT PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = #attributes.process_stage#
			</cfquery>
		</cfif>
		
		<cfquery name="get_pos_code" datasource="#dsn#">
			SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #caution_emp_id# 
		</cfquery>
		<cfif len(get_pos_code_member.UPPER_POSITION_CODE) and get_pos_code_member.UPPER_POSITION_CODE eq get_pos_code.POSITION_CODE>
			<!---<cfset url_link ='#request.self#?fuseaction=myhome.form_add_perf_emp_info&employee_id=#attributes.EMP_ID#&period_year=#session.ep.period_year#&quiz_id=#quiz_id#'>--->
			<cfset url_link = '#request.self#?fuseaction=myhome.list_employee_detail_survey_form'>
		<cfelse>
			<cfset url_link ='#request.self#?fuseaction=myhome.list_employee_detail_survey_form'><!---değerlendirme formları raporuna gitsin --->
		</cfif>
		<cfset pos_code = get_pos_code.position_code>
		<cfset all_time = test_time - caution_time>
		<CF_DATE tarih="attributes.work_start_date">
		<cfset caution_date = date_add("D",all_time,attributes.work_start_date)>
		<cfset title = 'Deneme süresi dolan '&'#get_employee.employee_name# #get_employee.employee_surname#'&' için değerlendirme bekleniyor'>
		<cfif isdefined('attributes.control_upd') and len(attributes.control_upd) and attributes.control_upd eq 1>
			<cfquery name="add_warning" datasource="#DSN#" result="GET_WARNINGS"> <!--- Onay Ve Uyarılar Listesine ekleme yapılıyor --->
				INSERT INTO
				PAGE_WARNINGS
					(
						ACTION_TABLE,
						ACTION_COLUMN,
						URL_LINK,
						WARNING_HEAD,
						WARNING_DESCRIPTION,
						EMAIL_WARNING_DATE,
						LAST_RESPONSE_DATE,
						RECORD_DATE,
						RECORD_IP,
						RECORD_EMP,
						POSITION_CODE,
						IS_ACTIVE,
						IS_PARENT,
						IS_CAUTION_ACTION,
						RESPONSE_ID,
						ACTION_ID,
						ACTION_STAGE_ID,
						OUR_COMPANY_ID,
						PERIOD_ID
					)
					VALUES
					(
						'SURVEY_MAIN_RESULT',
						'SURVEY_MAIN_RESULT_ID',
						'#url_link#',
						'#title#',
						'#test_detail#',
						#caution_date#,
						#caution_date#,
						<cfif isdefined("warning_date") and len(warning_date)>#warning_date#<cfelse>#now()#</cfif>,
						'#CGI.REMOTE_ADDR#',
						#SESSION.EP.USERID#,
						#pos_code#,
						1,
						1,
						1,
						0,
						<cfif get_survey_main.recordCount>#get_survey_main.survey_main_result_id#<cfelse>#SURVEY_MAIN.IDENTITYCOL#</cfif>,
						<cfif len(get_process_stage.PROCESS_ROW_ID)>#get_process_stage.PROCESS_ROW_ID#<cfelse>NULL</cfif>,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
					)
			</cfquery>
			<cfquery name="UPD_WARNINGS" datasource="#dsn#">
				UPDATE PAGE_WARNINGS SET PARENT_ID = #GET_WARNINGS.IDENTITYCOL# WHERE W_ID = #GET_WARNINGS.IDENTITYCOL#			
			</cfquery>
		</cfif>
	</cfif> 
</cfif>
