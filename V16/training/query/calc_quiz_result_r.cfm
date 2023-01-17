<cfif isdefined("attributes.insert_type") and attributes.insert_type eq 1>
	<!--- veritabanına ilk kaydı gir --->
	<cfset session.quiz_start = now()>
	<cfset session.quiz_id = attributes.quiz_id>
	<cfinclude template="../query/add_quiz_result.cfm">
</cfif> 
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
			QUESTION_COUNT = #QUESTION_LIMIT#,
			AVERAGE = #GET_QUIZ.QUIZ_AVERAGE#,
			IS_STOPPED_QUIZ = 0,
			FINISH_DATE = #now()#
		WHERE
			RESULT_ID = #session.result_id#
	</cfquery>
	<cfset counter = 0>
	<cfloop list="#session.random_list#" index="k">
		<cfset counter = counter+1>
		<cfset attributes.question_id = k>
		<cfinclude template="get_quiz_question2.cfm">
		<cfset rights = "">
		<cfif isDefined("form.user_answer_#counter#")>
			<cfloop from="1" to="20" index="j">
				<cfif evaluate("get_quiz_question2.answer#j#_true") eq 1>
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
					#session.result_id#,
					#K#,
					0#GET_QUIZ_QUESTION2.QUESTION_POINT#,
					'#wrk_eval("FORM.USER_ANSWER_#COUNTER#")#',
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
			<cfset temp_point = (temp_rights / #listlen(session.random_list)#)*get_quiz.total_points>
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
			RESULT_ID = #session.result_id#
	</cfquery>
	
</cfif>
<script type="text/javascript">
	window.open('<cfoutput>#request.self#?fuseaction=training.popup_user_quiz_result&result_id=#session.result_id#</cfoutput>','list');
</script>
<cfscript>
	structDelete(session,"quiz_start");
	structDelete(session,"result_id");
	structDelete(session,"quiz_id");
	structdelete(session,"random_list");
</cfscript>
<script type="text/javascript">
	window.close();
</script>
