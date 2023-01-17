<cf_date tarih='attributes.start_date'>
<cf_date tarih='attributes.finish_date'>
<cfquery name="GET_EMP_QUIZ_ANSWERS" datasource="#dsn#">
	SELECT 
		<!--- EMPLOYEE_QUIZ_RESULTS_DETAILS.*, ---> 
		EQD.RESULT_DETAIL_ID,
		EQD.RESULT_ID,
		EQD.QUESTION_ID,
		<cfif session.ep.userid eq attributes.emp_id>
		EQD.EMP_GD AS GD,
		EQD.QUESTION_EMP_ANSWERS AS QUESTION_USER_ANSWERS,
		<cfelseif len(get_perf_detail.manager_1_emp_id) and session.ep.userid eq get_perf_detail.manager_1_emp_id>
		EQD.MANAGER1_GD AS GD,
		EQD.QUESTION_MANAGER1_ANSWERS AS QUESTION_USER_ANSWERS,
		<cfelseif len(get_perf_detail.manager_2_emp_id) and session.ep.userid eq get_perf_detail.manager_2_emp_id>
		EQD.MANAGER2_GD AS GD,
		EQD.QUESTION_MANAGER2_ANSWERS AS QUESTION_USER_ANSWERS,
		<cfelseif len(get_perf_detail.manager_3_emp_id) and session.ep.userid eq get_perf_detail.manager_3_emp_id>
		EQD.MANAGER3_GD AS GD,
		EQD.QUESTION_MANAGER3_ANSWERS AS QUESTION_USER_ANSWERS,
		<cfelse>
		EQD.GD,
		EQD.QUESTION_USER_ANSWERS,
		</cfif>
		EQD.EMP_GD AS CALISAN_GD,
		EQD.QUESTION_EMP_ANSWERS AS CALISAN_ANSWERS,
		EQD.MANAGER1_GD AS MANAGER1_GD,
		EQD.QUESTION_MANAGER1_ANSWERS AS MANAGER1_ANSWERS,
		EQD.MAN_EMP_GD AS MAN_EMP_GD,
		EQD.QUESTION_MAN_EMP_ANSWERS AS MAN_EMP_ANSWERS,
		EQD.MANAGER2_GD AS MANAGER2_GD,
		EQD.QUESTION_MANAGER2_ANSWERS AS MANAGER2_ANSWERS,
		EMPLOYEE_QUIZ_RESULTS.USER_POINT,
		EQD.MANAGER3_GD AS MANAGER3_GD,
		EQD.QUESTION_MANAGER3_ANSWERS AS MANAGER3_ANSWERS,
		EMPLOYEE_QUIZ_RESULTS.USER_POINT
	FROM 
		EMPLOYEE_QUIZ_RESULTS_DETAILS EQD, 
		EMPLOYEE_QUIZ_RESULTS
	WHERE
		EQD.RESULT_ID = EMPLOYEE_QUIZ_RESULTS.RESULT_ID AND
		EQD.RESULT_ID = #GET_PERF_DETAIL.RESULT_ID#
</cfquery>

<!--- IN 
			(
			SELECT 
				RESULT_ID 
			FROM 
				EMPLOYEE_QUIZ_RESULTS 
			WHERE 
				QUIZ_ID=#attributes.QUIZ_ID# AND 
				EMP_ID = #attributes.EMP_ID#
				<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
				AND START_DATE = #attributes.start_date#
				</cfif>
				<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
				AND FINISH_DATE = #attributes.finish_date#
				</cfif>
			) --->
