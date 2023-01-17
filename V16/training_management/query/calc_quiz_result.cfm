<cfinclude template="../query/get_user_join_quiz.cfm">
<cfinclude template="../query/get_quiz_question_count.cfm">
<cfinclude template="../query/add_quiz_result.cfm">
<!--- kaç soru var --->
<cfif get_quiz_question_count.counted LT get_quiz.max_questions>
	<cfset question_limit = get_quiz_question_count.counted>
<cfelse>
	<cfset question_limit = get_quiz.max_questions>
</cfif>

<!--- kağıdı gönder --->
	<cfquery name="ADD_RESULT" datasource="#dsn#">
		UPDATE
			QUIZ_RESULTS
		SET
			QUIZ_ID = #SESSION.QUIZ_ID#,
			EMP_ID = #attributes.employee_id#,
			<cfif isdefined("attributes.is_stopped_quiz") and len(attributes.is_stopped_quiz) and attributes.is_stopped_quiz eq 1>
				IS_STOPPED_QUIZ = 1,
				AVERAGE = #GET_QUIZ.QUIZ_AVERAGE#,
				FINISH_DATE = NULL
			<cfelse>
				IS_STOPPED_QUIZ = 0,
				QUESTION_COUNT = #QUESTION_LIMIT#,
				AVERAGE = #GET_QUIZ.QUIZ_AVERAGE#,
				FINISH_DATE = #now()#
			</cfif>
		WHERE
			RESULT_ID = #SESSION.RESULT_ID#
	</cfquery>
		
	<cfloop query="get_quiz_questions">
		<cfset rights = "">

		<cfif isDefined("form.user_answer_#currentrow#")>

			<cfloop from="1" to="20" index="j">
				<cfif evaluate("get_quiz_questions.answer#j#_true") eq 1>
					<cfset rights = ListAppend(rights,j)>
				</cfif>
			</cfloop>

			<cfquery name="ADD_RESULT_DETAIL" datasource="#dsn#">
				INSERT INTO
					QUIZ_RESULTS_DETAILS
					(
					RESULT_ID,
					QUESTION_ID,
					QUESTION_POINT,
					QUESTION_USER_ANSWERS,
					QUESTION_RIGHTS
					)
				VALUES
					(
					#SESSION.RESULT_ID#,
					#GET_QUIZ_QUESTIONS.QUESTION_ID#,
					0#GET_QUIZ_QUESTIONS.QUESTION_POINT#,
					'#wrk_eval("FORM.USER_ANSWER_#CURRENTROW#")#',
					'#RIGHTS#'
					)
			</cfquery>
		</cfif>

	</cfloop>
<!--- // kağıdı gönder --->

<!--- eğer açık uçlu yok ise --->
<cfif not isDefined("form.open_question")>
	<!--- cevaplarla karşılaştır --->

	<cfset attributes.result_id = session.result_id>
	<cfinclude template="get_detailed_result.cfm">

	<cfset temp_point = 0>
	<cfset temp_rights = 0>
	<cfset temp_wrongs = 0>

	<!--- sonucu hesapla --->
	<cfloop query="get_detailed_result">
		<cfif question_rights is question_user_answers>
			<cfset temp_rights = temp_rights + 1>
			<cfif get_quiz.grade_style eq 0>
				<cfset temp_point = temp_point + question_point>
			</cfif>
		<cfelse>
			<!--- cevap vermemiş olabilir --->
			<cfif len(question_user_answers)>
				<cfset temp_wrongs = temp_wrongs + 1>
			</cfif>
		</cfif>
	</cfloop>

	<cfif get_quiz.grade_style eq 1>
		<cfif temp_rights neq 0>
			<cfset temp_point = (temp_rights / get_quiz_questions.recordcount)*get_quiz.total_points>
		<cfelse>
			<cfset temp_point = 0>
		</cfif>
	</cfif>
	
	<!--- sonucu veritabanına gönder --->

	<cfquery name="UPD_RESULT" datasource="#dsn#">
		UPDATE
			QUIZ_RESULTS
		SET
			USER_POINT = #TEMP_POINT#,
			USER_RIGHT_COUNT = #TEMP_RIGHTS#,
			USER_WRONG_COUNT = #TEMP_WRONGS#,
			RECORD_DATE = #now()#,
			RECORD_IP = '#CGI.REMOTE_ADDR#'
		WHERE
			RESULT_ID = #SESSION.RESULT_ID#
	</cfquery>
	
</cfif>
<cfscript>
	structDelete(session,"quiz_start");
	structDelete(session,"result_id");
	structDelete(session,"quiz_id");
</cfscript>

<cfif attributes.page_type eq 1>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
<cfelseif attributes.page_type eq 2>
	<script type="text/javascript">
		opener.location.href='<cfoutput>#request.self#?fuseaction=training_management.list_quizs&event=results&quiz_id=#attributes.quiz_id#</cfoutput>';
		window.close();
	</script>
</cfif>

