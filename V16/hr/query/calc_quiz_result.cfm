<cfinclude template="../query/get_quiz.cfm">
<cfset attributes.employee_id = session.ep.userid>
<cfinclude template="../query/get_user_join_quiz.cfm">
<cfinclude template="../query/get_quiz_question_count.cfm">
<cfinclude template="../query/get_quiz_questions.cfm">
<cftransaction>
<!--- kaç soru var --->
	<cfset question_limit = get_quiz_question_count.counted>

<!--- kağıdı gönder --->
	<cfquery name="ADD_RESULT" datasource="#dsn#">
		UPDATE
			EMPLOYEE_QUIZ_RESULTS
		SET
			QUIZ_ID = #SESSION.QUIZ_ID#,
			EMP_ID = #SESSION.EP.USERID#,
			QUESTION_COUNT = #QUESTION_LIMIT#,
			AVERAGE = #GET_QUIZ.QUIZ_AVERAGE#,
			FINISH_DATE = #now()#
		WHERE
			RESULT_ID = #SESSION.RESULT_ID#
	</cfquery>
		
	<cfloop query="get_quiz_questions">
		<!--- <cfset rights = ""> --->

		<cfif isDefined("form.user_answer_#currentrow#")>

			<!--- <cfoutput> --->
				<cfset puan1 = 0>
				<!--- <cfloop query="get_quiz_questions"> --->
					
					<!--- question_id#question_id# =	#EVALUATE("FORM.USER_ANSWER_#CURRENTROW#")#<br/> --->
					<cfloop list="#EVALUATE("FORM.USER_ANSWER_#CURRENTROW#")#" index="bb">
					<!--- #aa#-#ListGetAt(EVALUATE("FORM.user_answer_#currentrow#_point"), aa)#<br/> --->
					<cfset puan1 = puan1 + #ListGetAt(EVALUATE("FORM.user_answer_#currentrow#_point"), bb)#>
					</cfloop>
				<!--- </cfloop> --->
				<!--- puan = #puan# --->
			<!--- </cfoutput> --->
			
			<cfquery name="ADD_RESULT_DETAIL" datasource="#dsn#">
				INSERT INTO
					EMPLOYEE_QUIZ_RESULTS_DETAILS
					(
					RESULT_ID,
					QUESTION_ID,
					QUESTION_POINT,
					QUESTION_USER_ANSWERS
					)
				VALUES
					(
					#SESSION.RESULT_ID#,
					#GET_QUIZ_QUESTIONS.QUESTION_ID#,
					#puan1#,
					'#wrk_eval("FORM.USER_ANSWER_#CURRENTROW#")#'
					)
			</cfquery>
		</cfif>

	</cfloop>
<!--- // kağıdı gönder --->

<!--- eğer açık uçlu yok ise --->
<cfif not isDefined("form.open_question")>
	<!--- cevaplarla karşılaştır --->

			<cfset puan = 0>
			<cfloop query="get_quiz_questions">
				
				<!--- question_id#question_id# =	#EVALUATE("FORM.USER_ANSWER_#CURRENTROW#")#<br/> --->
				<cfloop list="#EVALUATE("FORM.USER_ANSWER_#CURRENTROW#")#" index="aa">
				<!--- #aa#-#ListGetAt(EVALUATE("FORM.user_answer_#currentrow#_point"), aa)#<br/> --->
				<cfset puan = puan + #ListGetAt(EVALUATE("FORM.user_answer_#currentrow#_point"), aa)#>
				</cfloop>
			</cfloop>
			<!--- puan = #puan# --->
		<!--- </cfoutput> --->
	
	<!--- sonucu veritabanına gönder --->

	<cfquery name="UPD_RESULT" datasource="#dsn#">
		UPDATE
			EMPLOYEE_QUIZ_RESULTS
		SET
			USER_POINT = #puan#,
			RECORD_DATE = #now()#,
			RECORD_IP = '#CGI.REMOTE_ADDR#'
		WHERE
			RESULT_ID = #SESSION.RESULT_ID#
	</cfquery>
	
</cfif>

</cftransaction>

<cfscript>
	structDelete(session,"quiz_start");
	structDelete(session,"result_id");
	structDelete(session,"quiz_id");
</cfscript>
<script type="text/javascript">
	opener.location.href='<cfoutput>#request.self#?fuseaction=hr.quiz_results&quiz_id=#attributes.quiz_id#</cfoutput>';
	window.close();
</script>
