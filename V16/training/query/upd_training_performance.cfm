<cf_date tarih='attributes.INTERVIEW_DATE'>

<!--- <cfif IsDefined("attributes.perf_salary_check")>
	<cfset IS_PERF_SALARY = 1>
<cfelse>
	<cfset IS_PERF_SALARY = 0>
</cfif> --->

<cfquery name="GET_QUIZ_CHAPTERS" datasource="#dsn#">
	SELECT 
		*
	FROM 
		EMPLOYEE_QUIZ_CHAPTER
	WHERE
		QUIZ_ID=#attributes.QUIZ_ID#
</cfquery>

<!--- ******************************************************* --->
<!--- <cfset TOPLAM_chaptergecerli = 0> --->
<cfset TOPLAM_chaptergecerli_agirlik = 0>
<cfloop query="get_quiz_chapters">
	<cfset attributes.CHAPTER_ID = get_quiz_chapters.CHAPTER_ID>
	<cfquery name="GET_QUIZ_QUESTIONS" datasource="#dsn#">
		SELECT 
			*
		FROM 
			EMPLOYEE_QUIZ_QUESTION
		WHERE
			CHAPTER_ID=#attributes.CHAPTER_ID#
	</cfquery>
	<cfset TOPLAM_sorugecerli = 0>
	<cfloop query="get_quiz_questions">
		<cfif IsDefined('FORM.USER_ANSWER_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#')>
			<cfif not IsDefined('FORM.gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#')>
				<cfset sorugecerli = 1>
			<cfelse>
				<cfset sorugecerli = 0>
			</cfif>
			<cfset TOPLAM_sorugecerli = TOPLAM_sorugecerli + sorugecerli>
		</cfif>	
	</cfloop>
	<cfset "TOPLAM_sorugecerli_#attributes.CHAPTER_ID#" = TOPLAM_sorugecerli>
	<cfif TOPLAM_sorugecerli gte (GET_QUIZ_QUESTIONS.RecordCount/2)>
		<cfset "perfsalarycheck_chapter_#attributes.CHAPTER_ID#" = 1>
		<!--- <cfset chaptergecerli = 1> --->
		<cfif len(get_quiz_chapters.CHAPTER_WEIGHT)><cfset chaptersgirlik = get_quiz_chapters.CHAPTER_WEIGHT><cfelse><cfset chaptersgirlik = 1></cfif>
		<cfset chaptergecerli_agirlik = chaptersgirlik>
	<cfelse>
		<cfset "perfsalarycheck_chapter_#attributes.CHAPTER_ID#" = 0>
		<!--- <cfset chaptergecerli = 0> --->
		<cfset chaptergecerli_agirlik = 0>
	</cfif> 
	<!--- <cfset TOPLAM_chaptergecerli = TOPLAM_chaptergecerli + chaptergecerli> --->
	<cfset TOPLAM_chaptergecerli_agirlik = TOPLAM_chaptergecerli_agirlik + chaptergecerli_agirlik>
</cfloop>
<!--- <cfif TOPLAM_chaptergecerli gte (get_quiz_chapters.RecordCount/2)> --->
<!--- <cfif TOPLAM_chaptergecerli_agirlik gte 50>
	<cfset IS_PERF_SALARY_RESULTING = 1>
<cfelse>
	<cfset IS_PERF_SALARY_RESULTING = 0>
</cfif> --->

<cfset quiz_point = 0>
<cfoutput query="get_quiz_chapters">
	<cfif evaluate("perfsalarycheck_chapter_#CHAPTER_ID#")>
		<cfset answer_number_gelen = get_quiz_chapters.ANSWER_NUMBER>
		<cfset attributes.CHAPTER_ID = CHAPTER_ID>
		<cfif len(get_quiz_chapters.CHAPTER_WEIGHT)>
			<cfset chapterweight = get_quiz_chapters.CHAPTER_WEIGHT>
		<cfelse>
			<cfset chapterweight = 1>
		</cfif>
		  <cfscript>
			for (i=1; i lte 20; i = i+1)
				{
				"a#i#" = evaluate("get_quiz_chapters.answer#i#_text");
				"b#i#" = evaluate("get_quiz_chapters.answer#i#_photo");
				"c#i#" = evaluate("get_quiz_chapters.answer#i#_point");
				}
		  </cfscript>
		  <cfquery name="GET_QUIZ_QUESTIONS" datasource="#dsn#">
			SELECT 
				*
			FROM 
				EMPLOYEE_QUIZ_QUESTION
			WHERE
				CHAPTER_ID=#attributes.CHAPTER_ID#
		</cfquery>
		  <cfif get_quiz_questions.recordcount>
			<cfloop query="get_quiz_questions">
				<cfif not IsDefined('FORM.gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#') and IsDefined('FORM.USER_ANSWER_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#')>
					 <cfif answer_number_gelen neq 0>
						<cfset listem = "">
						  <cfloop from="1" to="#answer_number_gelen#" index="i">
							  <cfif len(evaluate("b#i#")) or len(evaluate("a#i#"))>
								<cfset listem = listem&evaluate("c#i#")&','>
							  </cfif>
						  </cfloop>
							<!--- testte alınabilecek en yüksek puan hesaplanıyor --->
							<cfif not len(listem)><cfset listem=0></cfif><!--- şık yoksa yukardaki döngüye girmiyor boş değerdede altaki hesaplama hataveriyordu o yüzden eklendi--->
							<cfset hesaplanan = chapterweight / evaluate("TOPLAM_sorugecerli_#attributes.CHAPTER_ID#") * ListLast(ListSort(listem,'numeric'))>
							<cfset quiz_point = quiz_point + hesaplanan>				 
					 </cfif>
				</cfif>
			
			</cfloop>	
		</cfif>
	</cfif>
</cfoutput>
<!--- /////////////////////////////////////////////////////// --->

<cfset puan = 0>
<cfquery name="ADD_RESULT_DETAIL_CHAPTER" datasource="#dsn#">
	DELETE FROM
		EMPLOYEE_QUIZ_RESULTS_DETAILS
	WHERE	
		RESULT_ID = #RESULT_ID#
</cfquery> 	
<cfloop query="get_quiz_chapters">
	<cfset attributes.CHAPTER_ID = get_quiz_chapters.CHAPTER_ID>
	<cfif len(get_quiz_chapters.CHAPTER_WEIGHT)>
		<cfset chapterweight = get_quiz_chapters.CHAPTER_WEIGHT>
	<cfelse>
		<cfset chapterweight = 1>
	</cfif>
	<cfquery name="ADD_RESULT_DETAIL_CHAPTER" datasource="#dsn#">
		UPDATE
			EMPLOYEE_QUIZ_CHAPTER_EXPL
		SET
			EXPLANATION = '#Replace(EVALUATE("FORM.expl_#get_quiz_chapters.currentrow#"),"'"," ","all")#'
		WHERE	
			RESULT_ID = #RESULT_ID# AND
			CHAPTER_ID=#attributes.CHAPTER_ID#
	</cfquery> 
	<cfquery name="GET_QUIZ_QUESTIONS" datasource="#dsn#">
		SELECT 
			*
		FROM 
			EMPLOYEE_QUIZ_QUESTION
		WHERE
			CHAPTER_ID=#attributes.CHAPTER_ID#
	</cfquery>
	<cfloop query="get_quiz_questions">
		<cfif IsDefined('FORM.USER_ANSWER_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#')>
			<cfif evaluate("TOPLAM_sorugecerli_#attributes.CHAPTER_ID#") gt 0 and not IsDefined('FORM.gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#') and evaluate("perfsalarycheck_chapter_#CHAPTER_ID#")>
				<cfset yeni_puan = ListGetAt(
					EVALUATE('FORM.USER_ANSWER_'&get_quiz_chapters.currentrow&'_'&get_quiz_questions.currentrow&'_POINT'), 
					EVALUATE('FORM.USER_ANSWER_'&get_quiz_chapters.currentrow&'_'&get_quiz_questions.currentrow))
					* chapterweight / evaluate("TOPLAM_sorugecerli_#attributes.CHAPTER_ID#")>
			<cfelse>
				<cfset yeni_puan = 0>
			</cfif>
			<cfif not IsDefined('FORM.gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#')>
				<cfset GD = 0>
			<cfelse>
				<cfset GD = 1>
			</cfif>
			<cfquery name="ADD_RESULT_DETAIL" datasource="#dsn#">
				INSERT INTO
					EMPLOYEE_QUIZ_RESULTS_DETAILS
					(
					RESULT_ID,
					QUESTION_ID,
					QUESTION_POINT,
					QUESTION_USER_ANSWERS,
					GD
					)
				VALUES
					(
					#RESULT_ID#,
					#GET_QUIZ_QUESTIONS.QUESTION_ID#,
					#yeni_puan#,
					'#wrk_eval("FORM.USER_ANSWER_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)#',
					#GD#
					)
			</cfquery> 
		<cfelse>
			<cfset yeni_puan = 0>
			<cfquery name="ADD_RESULT_DETAIL" datasource="#dsn#">
				INSERT INTO
					EMPLOYEE_QUIZ_RESULTS_DETAILS
					(
					RESULT_ID,
					QUESTION_ID,
					QUESTION_POINT,
					QUESTION_USER_ANSWERS,
					GD
					)
				VALUES
					(
					#RESULT_ID#,
					#GET_QUIZ_QUESTIONS.QUESTION_ID#,					
					0,					
					'',
					1
					)
			</cfquery> 
		</cfif>	
		<cfset puan = puan + yeni_puan>		
	</cfloop> 
</cfloop> 

<cfquery name="UPD_RESULT" datasource="#dsn#">
	UPDATE
		EMPLOYEE_QUIZ_RESULTS
	SET
		USER_POINT = #puan#,
		<cfif IsDefined("session.ep.userid")>
		UPDATE_EMP = #session.ep.userid#,
		<cfelseif IsDefined("session.pp.userid")>
		UPDATE_PAR = #session.pp.userid#,
		</cfif>
		UPDATE_DATE = #now()#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE
		RESULT_ID = #RESULT_ID#
</cfquery>  

<cfif len(puan) and puan and quiz_point>
	<cfset user_point_over_5_raw = 5*puan / quiz_point>
	<cfset user_point_over_5_raw = round(user_point_over_5_raw*100)/100>
	<cfif user_point_over_5_raw gte 0 and user_point_over_5_raw lte 1.24>
		<cfset user_point_over_5 = 1>
	<cfelseif user_point_over_5_raw gte 1.25 and user_point_over_5_raw lte 1.74>
		<cfset user_point_over_5 = 1.5>
	<cfelseif user_point_over_5_raw gte 1.75 and user_point_over_5_raw lte 2.24>
		<cfset user_point_over_5 = 2>
	<cfelseif user_point_over_5_raw gte 2.25 and user_point_over_5_raw lte 2.74>
		<cfset user_point_over_5 = 2.5>
	<cfelseif user_point_over_5_raw gte 2.75 and user_point_over_5_raw lte 3.24>
		<cfset user_point_over_5 = 3>
	<cfelseif user_point_over_5_raw gte 3.25 and user_point_over_5_raw lte 3.74>
		<cfset user_point_over_5 = 3.5>
	<cfelseif user_point_over_5_raw gte 3.75 and user_point_over_5_raw lte 4.24>
		<cfset user_point_over_5 = 4>
	<cfelseif user_point_over_5_raw gte 4.25 and user_point_over_5_raw lte 4.74>
		<cfset user_point_over_5 = 4.5>
	<cfelseif user_point_over_5_raw gte 4.75><!---  and user_point_over_5_raw lte 5 --->
		<cfset user_point_over_5 = 5>
	</cfif>
</cfif>

<cfquery name="upd_perform" datasource="#dsn#">
	UPDATE
		TRAINING_PERFORMANCE
	SET	
		ENTRY_EMP_ID = #entry_employee_id#,
	<cfif len(quiz_point)>
		PERFORM_POINT = #quiz_point#,
	</cfif>
	<cfif len(puan) and puan and quiz_point>
		USER_POINT = #puan#,
		USER_POINT_OVER_5 = #user_point_over_5#,
	<cfelse>
		USER_POINT = NULL,
		USER_POINT_OVER_5 = NULL,
	</cfif>
		RESULT_ID = #RESULT_ID#,
		INTERVIEW_DATE = #attributes.INTERVIEW_DATE#,
		TRAINING_QUIZ_ID = #attributes.QUIZ_ID#,
		UPDATE_EMP = '#SESSION.EP.USERID#',
		UPDATE_IP = '#CGI.REMOTE_ADDR#',
		UPDATE_DATE = #now()#
	WHERE
		TRAINING_PERFORMANCE_ID = #attributes.TRAINING_PER_ID#
</cfquery> 
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

