<cfset puan = 0>
<cf_date tarih='attributes.INTERVIEW_DATE'>
<cfif isDefined("attributes.INTERVIEW_ID") and len(attributes.INTERVIEW_ID)>
		<cfquery name="upd_employees_interview" datasource="#dsn#">
			UPDATE
				EMPLOYEES_INTERVIEW
			SET
			   INTERVIEW_EMP_ID = <cfif isdefined("attributes.INTERVIEW_EMP_ID") and len(attributes.INTERVIEW_EMP_ID)>#attributes.INTERVIEW_EMP_ID#<cfelse>NULL</cfif>,
			   INTERVIEW_DATE = <cfif isdefined("attributes.INTERVIEW_DATE") and isdate(attributes.INTERVIEW_DATE)>#attributes.INTERVIEW_DATE#<cfelse>NULL</cfif>,
			   EMPLOYEE_ID =  #attributes.EMPLOYEE_ID#,
			   QUIZ_ID =  #attributes.QUIZ_ID#,
			   NOTES = <cfif isdefined("attributes.notes") and len(attributes.notes)>'#attributes.notes#'<cfelse>NULL</cfif>
			WHERE
				INTERVIEW_ID = #attributes.INTERVIEW_ID#
		</cfquery>
		<cfset RESULTID = attributes.INTERVIEW_ID>
		<cfquery name="DELETE_INTERVIEW_DETAIL" datasource="#dsn#">
			DELETE FROM
				EMPLOYEES_INTERVIEW_DETAIL
			WHERE	
				INTERVIEW_ID = #RESULTID#
		</cfquery> 	
		<cfinclude template="../query/get_quiz_chapters.cfm">
		<cfloop query="get_quiz_chapters">
		<cfset attributes.CHAPTER_ID = get_quiz_chapters.CHAPTER_ID>
		<cfquery name="get_result_detail_chapter" datasource="#dsn#">
			SELECT 
				RESULT_ID
			FROM
				EMPLOYEE_QUIZ_CHAPTER_EXPL
			WHERE	
					RESULT_ID = #RESULTID# AND
					CHAPTER_ID=#attributes.CHAPTER_ID#
		</cfquery>
		<cfif get_result_detail_chapter.recordcount>
			<cfquery name="ADD_RESULT_DETAIL_CHAPTER" datasource="#dsn#">
				UPDATE
					EMPLOYEE_QUIZ_CHAPTER_EXPL
				SET
					RESULT_ID = #RESULTID#
					<cfif isdefined("attributes.exp1_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp1_#get_quiz_chapters.currentrow#"))>
					,EXPLANATION1 = '#Replace(EVALUATE("attributes.exp1_#get_quiz_chapters.currentrow#"),"'"," ","all")#'
					<cfelseif isdefined("attributes.exp1_#get_quiz_chapters.currentrow#") and not len(evaluate("attributes.exp1_#get_quiz_chapters.currentrow#"))>
					,EXPLANATION1 = NULL
					</cfif>
					<cfif isdefined("attributes.exp2_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp2_#get_quiz_chapters.currentrow#"))>
					,EXPLANATION2 ='#Replace(EVALUATE("attributes.exp2_#get_quiz_chapters.currentrow#"),"'"," ","all")#'
					<cfelseif isdefined("attributes.exp2_#get_quiz_chapters.currentrow#") and not len(evaluate("attributes.exp2_#get_quiz_chapters.currentrow#"))>
					,EXPLANATION2 = NULL
					</cfif>
					<cfif isdefined("attributes.exp3_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp3_#get_quiz_chapters.currentrow#"))>
					,EXPLANATION3 = '#Replace(EVALUATE("attributes.exp3_#get_quiz_chapters.currentrow#"),"'"," ","all")#'
					<cfelseif isdefined("attributes.exp3_#get_quiz_chapters.currentrow#") and not len(evaluate("attributes.exp3_#get_quiz_chapters.currentrow#"))>
					,EXPLANATION3 = NULL
					</cfif> 
					<cfif isdefined("attributes.exp4_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp4_#get_quiz_chapters.currentrow#"))>
					,EXPLANATION4 = '#Replace(EVALUATE("attributes.exp4_#get_quiz_chapters.currentrow#"),"'"," ","all")#'
					<cfelseif isdefined("attributes.exp4_#get_quiz_chapters.currentrow#") and not len(evaluate("attributes.exp4_#get_quiz_chapters.currentrow#"))>
					,EXPLANATION4 = NULL
					</cfif> 
				WHERE	
					RESULT_ID = #RESULTID# AND
					CHAPTER_ID=#attributes.CHAPTER_ID#
			</cfquery>
		<cfelse>
			<cfif isdefined("attributes.exp1_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp1_#get_quiz_chapters.currentrow#")) or isdefined("attributes.exp2_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp2_#get_quiz_chapters.currentrow#")) or isdefined("attributes.exp3_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp3_#get_quiz_chapters.currentrow#")) or isdefined("attributes.exp4_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp4_#get_quiz_chapters.currentrow#"))>
				<cfquery name="ADD_RESULT_DETAIL_CHAPTER" datasource="#dsn#">
					INSERT INTO
						EMPLOYEE_QUIZ_CHAPTER_EXPL
						(
						RESULT_ID,
						CHAPTER_ID
						<cfif isdefined("attributes.exp1_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp1_#get_quiz_chapters.currentrow#"))>,EXPLANATION1</cfif>
						<cfif isdefined("attributes.exp2_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp2_#get_quiz_chapters.currentrow#"))>,EXPLANATION2</cfif>
						<cfif isdefined("attributes.exp3_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp3_#get_quiz_chapters.currentrow#"))>,EXPLANATION3</cfif>
						<cfif isdefined("attributes.exp4_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp4_#get_quiz_chapters.currentrow#"))>,EXPLANATION4</cfif>
						)
					VALUES
						(
						#RESULTID#,
						#attributes.CHAPTER_ID#
						<cfif isdefined("attributes.exp1_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp1_#get_quiz_chapters.currentrow#"))>,'#replace(evaluate("attributes.exp1_#get_quiz_chapters.currentrow#"),"'"," ","all")#'</cfif>
						<cfif isdefined("attributes.exp2_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp2_#get_quiz_chapters.currentrow#"))>,'#replace(evaluate("attributes.exp2_#get_quiz_chapters.currentrow#"),"'"," ","all")#'</cfif>
						<cfif isdefined("attributes.exp3_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp3_#get_quiz_chapters.currentrow#"))>,'#replace(evaluate("attributes.exp3_#get_quiz_chapters.currentrow#"),"'"," ","all")#'</cfif>
						<cfif isdefined("attributes.exp4_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp4_#get_quiz_chapters.currentrow#"))>,'#replace(evaluate("attributes.exp4_#get_quiz_chapters.currentrow#"),"'"," ","all")#'</cfif>
						)
				</cfquery>
			</cfif>
		</cfif>
		<cfinclude template="../query/get_quiz_questions.cfm">
			<cfloop query="get_quiz_questions">
				<cfif isdefined("FORM.USER_ANSWER_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#")>
					<cfif not IsDefined('attributes.gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#')>
							<cfset puan = ListGetAt(
									EVALUATE('FORM.USER_ANSWER_'&get_quiz_chapters.currentrow&'_'&get_quiz_questions.currentrow&'_POINT'), 
									EVALUATE('FORM.USER_ANSWER_'&get_quiz_chapters.currentrow&'_'&get_quiz_questions.currentrow))>
					<cfelse>
						<cfset puan = 0>
					</cfif>
					<cfif not IsDefined('attributes.gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#')>
						<cfset GD = 0>
					<cfelse>
						<cfset GD = 1>
					</cfif>
						<cfquery name="ADD_RESULT_DETAIL" datasource="#dsn#">
							INSERT INTO
								EMPLOYEES_INTERVIEW_DETAIL
								(
								INTERVIEW_ID,
								QUESTION_ID,
								QUESTION_POINT,
								QUESTION_USER_ANSWER,
								GD
								)
							VALUES
								(
								#RESULTID#,
								#GET_QUIZ_QUESTIONS.QUESTION_ID#,
								#puan#,
								'#wrk_eval("FORM.USER_ANSWER_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)#',
								#GD#
								)
						</cfquery>
				<cfelse>
					<cfif not IsDefined('attributes.gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#')>
						<cfset GD = 0>
					<cfelse>
						<cfset GD = 1>
					</cfif>
					<cfset puan = 0>
					<cfquery name="ADD_RESULT_DETAIL" datasource="#dsn#">
						INSERT INTO
								EMPLOYEES_INTERVIEW_DETAIL
								(
								INTERVIEW_ID,
								QUESTION_ID,
								QUESTION_POINT,
								QUESTION_USER_ANSWER,
								GD
								)
							VALUES
								(
								#RESULTID#,
								#GET_QUIZ_QUESTIONS.QUESTION_ID#,
								#puan#,
								NULL,
								#GD#
								)
					</cfquery>
				</cfif>
			</cfloop>
		</cfloop>
<cfelse>
	<cfquery name="ADD_INTERVIEW" datasource="#DSN#">
	  INSERT INTO 
		EMPLOYEES_INTERVIEW
	  (
	   INTERVIEW_EMP_ID,
	   EMPLOYEE_ID,
	   INTERVIEW_DATE,
	   QUIZ_ID,
	   NOTES
	  )
	  VALUES
	  (
	   #attributes.INTERVIEW_EMP_ID#,
	   #attributes.EMPLOYEE_ID#,
	   <cfif isdefined('attributes.INTERVIEW_DATE') and isdate(attributes.INTERVIEW_DATE)>#attributes.INTERVIEW_DATE#<cfelse>NULL</cfif>,
	   #attributes.QUIZ_ID#,
	   <cfif isdefined("attributes.notes") and len(attributes.notes)>'#attributes.notes#'<cfelse>NULL</cfif>
	  )
	</cfquery>
	<cfquery name="GET_RESULTID" datasource="#dsn#">
		SELECT
			MAX(INTERVIEW_ID) AS MAX_ID
		FROM
			EMPLOYEES_INTERVIEW
		WHERE
			EMPLOYEE_ID=#attributes.EMPLOYEE_ID#
			AND
			QUIZ_ID = #attributes.QUIZ_ID#
	</cfquery>
	<cfset RESULTID = GET_RESULTID.MAX_ID> 
	<cfinclude template="../query/get_quiz_chapters.cfm">
		<cfloop query="get_quiz_chapters">
		<cfif isdefined("attributes.exp1_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp1_#get_quiz_chapters.currentrow#")) or isdefined("attributes.exp2_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp2_#get_quiz_chapters.currentrow#")) or isdefined("attributes.exp3_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp3_#get_quiz_chapters.currentrow#")) or isdefined("attributes.exp4_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp4_#get_quiz_chapters.currentrow#"))>
			<cfquery name="ADD_RESULT_DETAIL_CHAPTER" datasource="#dsn#">
				INSERT INTO
					EMPLOYEE_QUIZ_CHAPTER_EXPL
					(
					RESULT_ID,
					CHAPTER_ID
					<cfif isdefined("attributes.exp1_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp1_#get_quiz_chapters.currentrow#"))>,EXPLANATION1</cfif>
					<cfif isdefined("attributes.exp2_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp2_#get_quiz_chapters.currentrow#"))>,EXPLANATION2</cfif>
					<cfif isdefined("attributes.exp2_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp2_#get_quiz_chapters.currentrow#"))>,EXPLANATION3</cfif>
					<cfif isdefined("attributes.exp4_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp4_#get_quiz_chapters.currentrow#"))>,EXPLANATION4</cfif>
					)
				VALUES
					(
					#RESULTID#,
					#attributes.CHAPTER_ID#
					<cfif isdefined("attributes.exp1_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp1_#get_quiz_chapters.currentrow#"))>,'#replace(evaluate("attributes.exp1_#get_quiz_chapters.currentrow#"),"'"," ","all")#'</cfif>
					<cfif isdefined("attributes.exp2_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp2_#get_quiz_chapters.currentrow#"))>,'#replace(evaluate("attributes.exp2_#get_quiz_chapters.currentrow#"),"'"," ","all")#'</cfif>
					<cfif isdefined("attributes.exp3_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp3_#get_quiz_chapters.currentrow#"))>,'#replace(evaluate("attributes.exp3_#get_quiz_chapters.currentrow#"),"'"," ","all")#'</cfif>
					<cfif isdefined("attributes.exp4_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp4_#get_quiz_chapters.currentrow#"))>,'#replace(evaluate("attributes.exp4_#get_quiz_chapters.currentrow#"),"'"," ","all")#'</cfif>
					)
			</cfquery>
		</cfif>
		<cfset attributes.CHAPTER_ID = get_quiz_chapters.CHAPTER_ID>
		<cfinclude template="../query/get_quiz_questions.cfm">
			<cfloop query="get_quiz_questions">
				<cfif IsDefined('FORM.USER_ANSWER_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#')>
					<cfif not IsDefined('FORM.gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#')>
						<cfset puan = ListGetAt(
								EVALUATE('FORM.USER_ANSWER_'&get_quiz_chapters.currentrow&'_'&get_quiz_questions.currentrow&'_POINT'), 
								EVALUATE('FORM.USER_ANSWER_'&get_quiz_chapters.currentrow&'_'&get_quiz_questions.currentrow))>
					<cfelse>
						<cfset puan =0>
					</cfif>
					<cfif not IsDefined('FORM.gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#')>
						<cfset GD = 0>
					<cfelse>
						<cfset GD = 1>
					</cfif>
						<cfquery name="ADD_RESULT_DETAIL" datasource="#dsn#">
							INSERT INTO
								EMPLOYEES_INTERVIEW_DETAIL
								(
								INTERVIEW_ID,
								QUESTION_ID,
								QUESTION_POINT,
								QUESTION_USER_ANSWER,
								GD
								)
							VALUES
								(
								#RESULTID#,
								#GET_QUIZ_QUESTIONS.QUESTION_ID#,
								#puan#,
								'#wrk_eval("FORM.USER_ANSWER_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)#',
								#GD#
								)
						</cfquery>
					<cfelse>
						<cfif not IsDefined('FORM.gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#')>
							<cfset GD = 0>
						<cfelse>
							<cfset GD = 1>
						</cfif>
						<cfset puan = 0>
						<cfquery name="ADD_RESULT_DETAIL" datasource="#dsn#">
							INSERT INTO
								EMPLOYEES_INTERVIEW_DETAIL
								(
								INTERVIEW_ID,
								QUESTION_ID,
								QUESTION_POINT,
								QUESTION_USER_ANSWER,
								GD
								)
							VALUES
								(
								#RESULTID#,
								#GET_QUIZ_QUESTIONS.QUESTION_ID#,
								#puan#,
								0,
								#GD#
								)
						</cfquery>
					</cfif>
			</cfloop>
		</cfloop>
</cfif>
<script type="text/javascript">
  wrk_opener_reload();
  window.close();
</script>
