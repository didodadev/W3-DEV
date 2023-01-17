<cfquery name="GET_QUIZ" datasource="#dsn#">
	SELECT 
		QUIZ_ID,
		QUIZ_HEAD,
		TRAINING_CAT_ID,
		PROCESS_STAGE,
		QUIZ_TYPE,
		QUIZ_STARTDATE,
		QUIZ_FINISHDATE,
		RANDOM,
		QUIZ_OBJECTIVE,
		MAX_QUESTIONS,
		TAKE_LIMIT,
		TIMING_STYLE,
		TOTAL_TIME,
		GRADE_STYLE,
		TOTAL_POINTS,
		SCORE1,
		COMMENT1,
		SCORE2,
		COMMENT2,
		SCORE3,
		COMMENT3,
		SCORE4,
		COMMENT4,
		SCORE5,
		COMMENT5,
		QUIZ_PARTNERS,
		QUIZ_CONSUMERS,
		QUIZ_DEPARTMENTS,
		QUIZ_POSITION_CATS,
		QUIZ_AVERAGE,
		TRAINING_SEC_ID,
		TRAINING_ID,
		RECORD_EMP,
		RECORD_PAR,
		RECORD_DATE,
		UPDATE_DATE
	FROM 
		QUIZ
	WHERE
		QUIZ_ID=#attributes.QUIZ_ID#
</cfquery>
<cfif fuseaction eq "training_management.calc_quiz">
	<cfset attributes.employee_id = session.ep.userid> 
	<cfif get_quiz.random eq 1>
		<cfinclude template="../query/calc_quiz_result_r.cfm">
	<cfelse>
		<cfinclude template="../query/get_quiz_questions.cfm">
		<cfinclude template="../query/calc_quiz_result.cfm">
	</cfif>
</cfif>			
