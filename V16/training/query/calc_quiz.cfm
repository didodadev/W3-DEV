<cfinclude template="../query/get_quiz.cfm">
<!---<cfset attributes.employee_id = session.ep.userid>--->
<cfinclude template="../query/get_user_join_quiz.cfm">
<cfinclude template="../query/get_quiz_question_count.cfm">
<cfif get_quiz.random eq 1>
	<cfinclude template="../query/calc_quiz_result_r.cfm">
<cfelse>
	<cfinclude template="../query/get_quiz_questions.cfm">
	<cfinclude template="../query/calc_quiz_result.cfm">
</cfif>
