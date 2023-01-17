<cfif isdefined("attributes.is_stopped_quiz") and len(attributes.is_stopped_quiz) and attributes.is_stopped_quiz eq 1>
	<!--- <cfif isdefined("attributes.insert_type") and attributes.insert_type eq 1> --->
		<cfinclude template="../query/add_quiz_result.cfm">
	<!--- </cfif> --->
	
	<cfinclude template="../query/get_user_join_quiz.cfm">
	<cfinclude template="../query/get_quiz_question_count.cfm">
	<!--- kaç soru var --->
	<cfif get_quiz_question_count.counted LT get_quiz.max_questions>
		<cfset question_limit = get_quiz_question_count.counted>
	<cfelse>
		<cfset question_limit = get_quiz.max_questions>
	</cfif>
	
	<!--- kaðýdý gönder --->
		
		<cfquery name="ADD_RESULT" datasource="#dsn#">
			UPDATE
				QUIZ_RESULTS
			SET
				IS_STOPPED_QUIZ = 1,
				AVERAGE = #GET_QUIZ.QUIZ_AVERAGE#,
				FINISH_DATE = NULL
			WHERE
				RESULT_ID = #SESSION.RESULT_ID#
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
						#SESSION.RESULT_ID#,
						#K#,
						#GET_QUIZ_QUESTION2.QUESTION_POINT#,
						'#wrk_eval("FORM.USER_ANSWER_#COUNTER#")#',
						'#RIGHTS#'
						)
				</cfquery>
			</cfif>
	
		</cfloop>
	<!--- // kaðýdý gönder --->
	
	<!--- eðer açýk uçlu yok ise --->
	<cfif not isDefined("form.open_question")>
		<!--- cevaplarla karþýlaþtýr --->
	
		<cfset attributes.result_id = session.result_id>
		<cfinclude template="get_detailed_result.cfm">
	
		<cfset temp_point = 0>
		<cfset temp_rights = 0>
		<cfset temp_wrongs = 0>
	
		<!--- sonucu hesapla --->
		<cfloop query="get_detailed_result">
			<cfset len_question_user_answers = len(question_user_answers)>
			<cfif len_question_user_answers gt 1>
				<cfif question_rights is listlast(question_user_answers,',')>
					<cfset temp_rights = temp_rights + 1>
					<cfif get_quiz.grade_style eq 0>
						<cfset temp_point = temp_point + question_point>
					</cfif>
				<cfelse>
					<!--- cevap vermemiþ olabilir --->
					<cfif len(question_user_answers)>
						<cfset temp_wrongs = temp_wrongs + 1>
					</cfif>
				</cfif>
			<cfelse>
				<cfif question_rights is question_user_answers>
					<cfset temp_rights = temp_rights + 1>
					<cfif get_quiz.grade_style eq 0>
						<cfset temp_point = temp_point + question_point>
					</cfif>
				<cfelse>
					<!--- cevap vermemiþ olabilir --->
					<cfif len(question_user_answers)>
						<cfset temp_wrongs = temp_wrongs + 1>
					</cfif>
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
		<!--- sonucu veritabanýna gönder --->
	
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
		structdelete(session,"random_list");
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
<cfelse>
	<cfinclude template="../query/add_quiz_result.cfm">
	<cfinclude template="../query/get_user_join_quiz.cfm">
	<cfinclude template="../query/get_quiz_question_count.cfm">
	
	<!--- kaç soru var --->
	<cfif get_quiz_question_count.counted LT get_quiz.max_questions>
		<cfset question_limit = get_quiz_question_count.counted>
	<cfelse>
		<cfset question_limit = get_quiz.max_questions>
	</cfif>
	
	<!--- kaðýdý gönder --->
		<cfquery name="ADD_RESULT" datasource="#dsn#">
			UPDATE
				QUIZ_RESULTS
			SET
				QUESTION_COUNT = #QUESTION_LIMIT#,
				AVERAGE = #GET_QUIZ.QUIZ_AVERAGE#,
				FINISH_DATE = #now()#
			WHERE
				RESULT_ID = #SESSION.RESULT_ID#
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
					#SESSION.RESULT_ID#,
					#K#,
					#GET_QUIZ_QUESTION2.QUESTION_POINT#,
					'#wrk_eval("FORM.USER_ANSWER_#COUNTER#")#',
					'#RIGHTS#'
					)
			</cfquery>
		</cfif>
	
	</cfloop>
	<!--- // kaðýdý gönder --->
	
	<!--- eðer açýk uçlu yok ise --->
	<cfif not isDefined("form.open_question")>
		<!--- cevaplarla karþýlaþtýr --->
	
		<cfset attributes.result_id = session.result_id>
		<cfinclude template="get_detailed_result.cfm">
	
		<cfset temp_point = 0>
		<cfset temp_rights = 0>
		<cfset temp_wrongs = 0>
			
		<!--- sonucu hesapla --->
		<cfloop query="get_detailed_result">
		<cfset len_question_user_answers = len(question_user_answers)>
			<cfif len_question_user_answers gt 1>
				<cfif question_rights is listlast(question_user_answers,',')>
					<cfset temp_rights = temp_rights + 1>
					<cfif get_quiz.grade_style eq 0>
						<cfset temp_point = temp_point + question_point>
					</cfif>
				<cfelse>
					<!--- cevap vermemiþ olabilir --->
					<cfif len(question_user_answers)>
						<cfset temp_wrongs = temp_wrongs + 1>
					</cfif>
				</cfif>
			<cfelse>
				<cfif question_rights is question_user_answers>
					<cfset temp_rights = temp_rights + 1>
					<cfif get_quiz.grade_style eq 0>
						<cfset temp_point = temp_point + question_point>
					</cfif>
				<cfelse>
					<!--- cevap vermemiþ olabilir --->
					<cfif len(question_user_answers)>
						<cfset temp_wrongs = temp_wrongs + 1>
					</cfif>
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
		<!--- sonucu veritabanýna gönder --->
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
		structdelete(session,"random_list");
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
</cfif>
