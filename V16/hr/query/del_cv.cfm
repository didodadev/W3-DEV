<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfinclude template="get_app.cfm">
		<cfset attributes.action_section = "EMPLOYEES_APP_ID">
		<cfset attributes.action_id = ATTRIBUTES.EMPAPP_ID>
		<!--- varlıklar --->
		<cfinclude template="../../objects/query/del_assets.cfm">
		<!--- notlar --->
		<cfinclude template="../../objects/query/del_notes.cfm">
		
		<!--- yazışmalar --->
		<cfquery name="GET_EMPAPP_MAIL" datasource="#DSN#">
			DELETE FROM EMPLOYEES_APP_MAILS WHERE EMPAPP_ID = #ATTRIBUTES.EMPAPP_ID#
		</cfquery> 
		
		<!---seçim listesiden sil--->
		<cfquery name="DEL_SEL_LIST_ROW" datasource="#dsn#">
			DELETE FROM EMPLOYEES_APP_SEL_LIST_ROWS WHERE EMPAPP_ID = #ATTRIBUTES.EMPAPP_ID#
		</cfquery>
		
		<!--- mülakatlar --->
		<cfquery name="DEL_APP_INTERVIEWS" datasource="#dsn#">
			DELETE FROM EMPLOYEES_APP_INTERVIEWS WHERE EMPAPP_ID = #ATTRIBUTES.EMPAPP_ID#
		</cfquery>
		
		<!--- performans sonuçları --->
		<cfquery name="get_quiz_results_details" datasource="#dsn#">
			SELECT RESULT_ID FROM EMPLOYEE_QUIZ_RESULTS WHERE APP_EMP_ID = #ATTRIBUTES.EMPAPP_ID#
		</cfquery>
		
		<cfif get_quiz_results_details.recordcount>
			<cfquery name="del_result_details" datasource="#dsn#">
				DELETE FROM EMPLOYEE_QUIZ_RESULTS_DETAILS WHERE RESULT_ID IN (#VALUELIST(get_quiz_results_details.RESULT_ID)#)
			</cfquery>
			<cfquery name="del_results" datasource="#dsn#">
				DELETE FROM EMPLOYEE_QUIZ_RESULTS WHERE RESULT_ID IN (#VALUELIST(get_quiz_results_details.RESULT_ID)#)
			</cfquery>
		</cfif>
		
		<cfquery name="del_quiz_app" datasource="#dsn#">
			DELETE FROM EMPLOYEES_APP_QUIZ WHERE EMPAPP_ID=#attributes.empapp_id#
		</cfquery>
		<!--- başvuran fotoğrafı --->
		<cfif len(get_app.photo)>
			<cf_del_server_file output_file="hr/#get_app.photo#" output_server="#get_app.photo_server_id#">
		</cfif>
		<!--- başvuru --->
		<cfquery name="del_app_pos" datasource="#dsn#">
			DELETE FROM EMPLOYEES_APP_POS WHERE EMPAPP_ID=#attributes.empapp_id#
		</cfquery>
		<cfquery name="del_app" datasource="#dsn#">
			DELETE
			FROM
				EMPLOYEES_APP
			WHERE
				EMPAPP_ID = #attributes.empapp_id#
		</cfquery>
		<!--- diger kimlik bilgileri ---> 
		<cfquery name="del_identity" datasource="#dsn#">
			DELETE FROM EMPLOYEES_IDENTY WHERE EMPAPP_ID = #attributes.empapp_id# AND EMPLOYEE_ID IS NULL
		</cfquery>
		<!--- calisan yakini bilgileri --->
		<cfquery name="del_relatives" datasource="#dsn#">
			DELETE FROM EMPLOYEES_RELATIVES WHERE EMPAPP_ID = #attributes.empapp_id#
		</cfquery>
		
		 <!--- çalışmak istediği birim --->
		<cfquery name="del_app_unit" datasource="#dsn#">
			SELECT EMPAPP_ID FROM EMPLOYEES_APP_UNIT WHERE EMPAPP_ID = #attributes.empapp_id#
		</cfquery>
		
		<!--- değerlendirme  --->
		<cfquery name="employees_app_perf_list" datasource="#dsn#">
			SELECT 
    	        EMP_APP_QUIZ_ID, 
                EMPAPP_ID, 
                QUIZ_ID, 
                QUIZ_RESULT_ID, 
                RECORD_EMP, 
                RECORD_DATE, 
                RECORD_IP, 
                APP_POS_ID, 
                SELECT_LIST_ID 
            FROM 
	            EMPLOYEES_APP_QUIZ 
            WHERE 
            	EMPAPP_ID = #attributes.empapp_id#
		</cfquery>
		<cfif employees_app_perf_list.recordcount>
			<cfif len(employees_app_perf_list.QUIZ_RESULT_ID)>
				<cfquery name="del_result_detail" datasource="#dsn#">
					DELETE FROM EMPLOYEE_QUIZ_RESULTS_DETAILS WHERE RESULT_ID IN (#VALUELIST(employees_app_perf_list.QUIZ_RESULT_ID)#)
				</cfquery>
				<cfquery name="del_performance_app" datasource="#dsn#">
					DELETE FROM EMPLOYEE_PERFORMANCE_APP WHERE EMP_APP_QUIZ_ID IN (#VALUELIST(employees_app_perf_list.EMP_APP_QUIZ_ID)#)
				</cfquery>
			</cfif>
			<cfquery name="del_perf_app" datasource="#dsn#">
				DELETE FROM EMPLOYEES_APP_QUIZ WHERE EMPAPP_ID = #attributes.empapp_id#
			</cfquery>
		</cfif>

		<!--- History --->
		<cfquery name="del_emp_history" datasource="#dsn#">
			SELECT 
                EMPAPP_ID, 
                APP_POS_ID, 
                APP_STATUS, 
                APP_DATE, 
                NAME, 
                SURNAME, 
                STEP_NAME, 
                STARTED, 
                RECORD_DATE, 
                RECORD_IP, 
                RECORD_EMP 
            FROM 
	            EMPLOYEES_APP_HISTORY 
            WHERE 
            	EMPAPP_ID= #attributes.empapp_id#
		</cfquery>
		
		<!--- İş Tecrübeleri --->
		<cfquery name="employees_app_work_list" datasource="#dsn#">
			SELECT 
    	        EMPAPP_ROW_ID, 
                EMPAPP_ID, 
                EMPLOYEE_ID, 
                EXP, 
                EXP_POSITION, 
                EXP_START, 
                EXP_FINISH,
                EXP_FARK, 
                EXP_ADDR,
                EXP_REASON_ID, 
                EXP_REASON, 
                EXP_EXTRA, 
                EXP_TELCODE, 
                EXP_TEL, 
                EXP_SECTOR_CAT,
                EXP_SALARY, 
                EXP_EXTRA_SALARY, 
                EXP_TASK_ID, 
                IS_CONT_WORK, 
                EXP_MONEY_TYPE 
            FROM 
	            EMPLOYEES_APP_WORK_INFO 
            WHERE 
            	EMPAPP_ID = #attributes.empapp_id# 
		</cfquery>
		<cfif employees_app_work_list.recordcount>
			<cfquery name="del_employees_app_work" datasource="#dsn#">
				DELETE FROM EMPLOYEES_APP_WORK_INFO WHERE EMPAPP_ID = #attributes.empapp_id#
			</cfquery>
		</cfif>
		
		<!--- Eğitim Bilgileri --->
		<cfquery name="employees_app_edu_list" datasource="#dsn#">
			SELECT 
    	        EMPAPP_EDU_ROW_ID, 
                EMPAPP_ID, 
                EMPLOYEE_ID, 
                EDU_TYPE, 
                EDU_ID, 
                EDU_NAME, 
                EDU_PART_ID, 
                EDU_PART_NAME, 
                EDU_START, 
                EDU_FINISH, 
                EDU_RANK, 
                IS_EDU_CONTINUE 
            FROM 
	            EMPLOYEES_APP_EDU_INFO 
            WHERE 
            	EMPAPP_ID = #attributes.empapp_id# 
		</cfquery>
		<cfif employees_app_edu_list.recordcount>
			<cfquery name="del_employees_app_edu" datasource="#dsn#">
				DELETE FROM EMPLOYEES_APP_EDU_INFO WHERE EMPAPP_ID = #attributes.empapp_id#
			</cfquery>
		</cfif>
		
		<!--- Branş Bilgileri --->
		<cfquery name="del_employees_app_branch" datasource="#dsn#">
			DELETE FROM EMPLOYEES_APP_TEACHER_INFO WHERE EMPAPP_ID = #attributes.empapp_id#
		</cfquery>
		<cfquery name="del_employees_app_branch" datasource="#dsn#">
			DELETE FROM EMPLOYEES_APP_INFO WHERE EMPAPP_ID = #attributes.empapp_id#
		</cfquery>
	</cftransaction>
</cflock>

<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=hr.list_cv</cfoutput>";
</script>
