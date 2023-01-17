<cf_date tarih='attributes.start_date'>
<cf_date tarih='attributes.finish_date'>
<cfquery name="GET_EMP_QUIZ_ANSWERS" datasource="#dsn#">
	SELECT 
		EQD.RESULT_DETAIL_ID,
		EQD.RESULT_ID,
		EQD.QUESTION_ID,
		<cfif session.ep.userid eq attributes.emp_id>
			EQD.EMP_GD AS GD,
			EQD.QUESTION_EMP_ANSWERS AS QUESTION_USER_ANSWERS,
		<cfelseif len(get_perf_detail.manager_1_emp_id) and session.ep.userid eq get_perf_detail.manager_1_emp_id and get_perf_detail.valid_1 neq 1>
			EQD.MANAGER1_GD AS GD,
			EQD.QUESTION_MANAGER1_ANSWERS AS QUESTION_USER_ANSWERS,
		<cfelseif len(get_perf_detail.manager_1_emp_id) and session.ep.userid eq get_perf_detail.manager_1_emp_id and get_perf_detail.valid_1 eq 1 and get_perf_detail.valid_4 neq 1>
			EQD.MAN_EMP_GD AS GD,
			EQD.QUESTION_MAN_EMP_ANSWERS AS QUESTION_USER_ANSWERS,
		<cfelseif len(get_perf_detail.manager_2_emp_id) and session.ep.userid eq get_perf_detail.manager_2_emp_id and get_perf_detail.valid_2 neq 1>
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
		EQD.QUESTION_EMP_OPENED_ANSWERS,
		EQD.MANAGER3_GD AS MANAGER3_GD,
		EQD.QUESTION_MANAGER3_ANSWERS AS MANAGER3_ANSWERS,
		EQD.MANAGER1_GD AS MANAGER1_GD,
		EQD.QUESTION_MANAGER1_ANSWERS AS MANAGER1_ANSWERS,
		EQD.MAN_EMP_GD AS MAN_EMP_GD,
		EQD.QUESTION_MAN_EMP_ANSWERS AS MAN_EMP_ANSWERS,
		EQD.MANAGER2_GD AS MANAGER2_GD,
		EQD.QUESTION_MANAGER2_ANSWERS AS MANAGER2_ANSWERS,
		EMPLOYEE_QUIZ_RESULTS.USER_POINT,
		EQD.QUESTION_MANAGER1_OPENED_ANSWERS,
		EQD.QUESTION_MANAGER2_OPENED_ANSWERS,
		EQD.QUESTION_MANAGER3_OPENED_ANSWERS
	FROM 
		EMPLOYEE_QUIZ_RESULTS_DETAILS EQD, 
		EMPLOYEE_QUIZ_RESULTS
	WHERE
		EQD.RESULT_ID = EMPLOYEE_QUIZ_RESULTS.RESULT_ID AND
		EQD.RESULT_ID = #GET_PERF_DETAIL.RESULT_ID#
</cfquery>

