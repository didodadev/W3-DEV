<CFTRANSACTION>
<cfif isdefined('attributes.app_per_id')>
	<cfquery name="get_employee_performance" datasource="#dsn#">
		SELECT
			RESULT_ID,
			EMP_APP_ID,
			EMP_APP_QUIZ_ID
		FROM
			EMPLOYEE_PERFORMANCE_APP
		WHERE
			APP_PER_ID = #attributes.app_per_id#
	</cfquery>
	<cfif IsNumeric(get_employee_performance.result_id)>
		<cfquery name="del_EMPLOYEE_QUIZ_CHAPTER_EXPL" datasource="#dsn#">
			DELETE FROM
				EMPLOYEE_QUIZ_CHAPTER_EXPL
			WHERE
				RESULT_ID = #get_employee_performance.result_id#
		</cfquery>		
		<cfquery name="del_EMPLOYEE_QUIZ_RESULTS_DETAILS" datasource="#dsn#">
			DELETE FROM
				EMPLOYEE_QUIZ_RESULTS_DETAILS
			WHERE
				RESULT_ID = #get_employee_performance.result_id#
		</cfquery>
		<cfquery name="del_EMPLOYEE_QUIZ_RESULTS" datasource="#dsn#">
			DELETE FROM
				EMPLOYEE_QUIZ_RESULTS
			WHERE
				RESULT_ID = #get_employee_performance.result_id#
		</cfquery>
	</cfif>
	<cfquery name="del_EMPLOYEE_PERFORMANCE" datasource="#dsn#">
		DELETE FROM
			EMPLOYEE_PERFORMANCE_APP
		WHERE
			APP_PER_ID = #attributes.app_per_id#
	</cfquery>
	<cfquery name="del_EMPLOYEE_PERFORMANCE" datasource="#dsn#">
		DELETE FROM
			EMPLOYEES_APP_QUIZ
		WHERE
			EMPAPP_ID=#get_employee_performance.emp_app_id# AND
			EMP_APP_QUIZ_ID = #get_employee_performance.emp_app_quiz_id#
	</cfquery>
<cfelse>
<!--- puanlamadan silinecekse--->
	<cfquery name="del_employee_performance" datasource="#dsn#">
		DELETE FROM
			EMPLOYEES_APP_QUIZ
		WHERE
			EMP_APP_QUIZ_ID = #attributes.emp_app_quiz_id#
	</cfquery>
</cfif>
</CFTRANSACTION>
<script type="text/javascript">
	window.opener.location.reload()
	window.close();
</script>
<!--- <cflocation url="#request.self#?fuseaction=hr.list_perform" addtoken="no"> --->
