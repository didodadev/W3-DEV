<cf_date tarih='attributes.INTERVIEW_DATE'>
<!--- <cfif perf_salary_check>
	<cfset IS_PERF_SALARY = 1>
<cfelse>
	<cfset IS_PERF_SALARY = 0>
</cfif> --->
<!--- <cfquery name="check" datasource="#dsn#">
	SELECT
		PER_ID
	FROM
		EMPLOYEE_PERFORMANCE
	WHERE
		EMP_ID = #attributes.EMP_ID#
		AND
		RESULT_ID IN (	SELECT RESULT_ID FROM EMPLOYEE_QUIZ_RESULTS 
						WHERE 
							EMP_ID = #attributes.EMP_ID#
					)
</cfquery>

<cfif check.recordcount>
	<script type="text/javascript">
		alert('Bir çalışan için performans değerlendirmesi iki kez yapılamaz !');
		history.back();
	</script>
	<CFABORT>
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
		<cfif len(get_quiz_chapters.CHAPTER_WEIGHT)>
			<cfset chaptergecerli_agirlik = get_quiz_chapters.CHAPTER_WEIGHT>
		<cfelse>
			<cfset chaptergecerli_agirlik=1>
		</cfif>
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
		  <cfif get_quiz_questions.RecordCount>
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
<cflock name="#CreateUUID()#" timeout="60">
<cftransaction>
	<cfquery name="add_perform_training" datasource="#dsn#">
	 INSERT INTO
		TRAINING_PERFORMANCE
		(
        	<cfif isdefined("attributes.class_id")>
				CLASS_ID,
            </cfif>
			ENTRY_EMP_ID,
			PERFORM_POINT,
			USER_POINT,
			USER_POINT_OVER_5,
			RESULT_ID,
			RECORD_EMP,
			RECORD_IP,
			RECORD_DATE,
			TRAINING_QUIZ_ID,
			INTERVIEW_DATE
		)
		VALUES
		(
	        <cfif isdefined("attributes.class_id")>
				#attributes.class_id#,
            </cfif>
			#entry_employee_id#,
			NULL,
			NULL,
			NULL,
			NULL,
			'#SESSION.EP.USERID#',
			'#CGI.REMOTE_ADDR#',
			#now()#,
			#attributes.QUIZ_ID#,
			#attributes.INTERVIEW_DATE#
		)
	 </cfquery> 
</cftransaction>
</cflock>
<cfquery name="get_training_perf_id" datasource="#dsn#">
	SELECT
		MAX(TRAINING_PERFORMANCE_ID) AS MAX_ID
	FROM
		TRAINING_PERFORMANCE
</cfquery>
<cflock name="#CreateUUID()#" timeout="20">
<cftransaction>
	<cfquery name="ADD_QUIZ_RESULT" datasource="#dsn#">
		INSERT INTO
			EMPLOYEE_QUIZ_RESULTS
			(
			QUIZ_ID,
			USER_POINT,
			TRAINING_PERFORMANCE_ID
			)
		VALUES
			(
			#attributes.QUIZ_ID#,
			0,
			#get_training_perf_id.MAX_ID#
			)
	</cfquery>			
	<cfquery name="GET_RESULT_ID" datasource="#dsn#">
		SELECT
			MAX(RESULT_ID) AS MAX_ID
		FROM
			EMPLOYEE_QUIZ_RESULTS
		WHERE
			TRAINING_PERFORMANCE_ID=#get_training_perf_id.MAX_ID# AND
			QUIZ_ID = #attributes.QUIZ_ID#
	</cfquery>
	<cfset RESULTID = GET_RESULT_ID.MAX_ID>
</cftransaction>
</cflock>
	
	<cfset puan = 0>
		<cfloop query="get_quiz_chapters">
		<cfset attributes.CHAPTER_ID = get_quiz_chapters.CHAPTER_ID>
		<cfif len(get_quiz_chapters.CHAPTER_WEIGHT)>
			<cfset chapterweight = get_quiz_chapters.CHAPTER_WEIGHT>
		<cfelse>
			<cfset chapterweight = 1>
		</cfif>
		<cfquery name="ADD_RESULT_DETAIL_CHAPTER" datasource="#dsn#">
			INSERT INTO
				EMPLOYEE_QUIZ_CHAPTER_EXPL
				(
				RESULT_ID,
				CHAPTER_ID,
				EXPLANATION
				)
			VALUES
				(
				#RESULTID#,
				#attributes.CHAPTER_ID#,
				'#Replace(EVALUATE("FORM.expl_#get_quiz_chapters.currentrow#"),"'"," ","all")#'
				)
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
					<cfif not IsDefined('FORM.gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#') and evaluate("perfsalarycheck_chapter_#CHAPTER_ID#")>
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
							#RESULTID#,
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
							#RESULTID#,
							#GET_QUIZ_QUESTIONS.QUESTION_ID#,
							0,
							'',
							1
							)
					</cfquery> 
				</cfif>	

				<cfset puan = puan + yeni_puan>		

			</cfloop> 
			<!--- </cfif> --->
	</cfloop>
	<!--- // kağıdı gönder --->
	<!--- <cfif not isDefined("form.open_question")>
			<cfoutput> 
				<cfset puan = 0>
				<cfloop query="get_quiz_questions">
					question_id#question_id# =	#EVALUATE("FORM.USER_ANSWER_#CURRENTROW#")#<br/>
					<cfloop list="#EVALUATE("FORM.USER_ANSWER_#CURRENTROW#")#" index="aa">
					#aa#-#ListGetAt(EVALUATE("FORM.user_answer_#currentrow#_point"), aa)#<br/>
					<cfset puan = puan + #ListGetAt(EVALUATE("FORM.user_answer_#currentrow#_point"), aa)#>
					</cfloop>
				</cfloop>
				 puan = #puan# 
			 </cfoutput>  --->
		<!--- sonucu veritabanına gönder --->
		 <cfquery name="UPD_RESULT" datasource="#dsn#">
			UPDATE
				EMPLOYEE_QUIZ_RESULTS
			SET
				USER_POINT = #puan#,
				RECORD_DATE = #now()#,
				RECORD_IP = '#CGI.REMOTE_ADDR#'
			WHERE
				RESULT_ID = #RESULTID#
		</cfquery>  
	<!--- </cfif> --->
<!--- //form sonuç kaydı --->

		<cfif len(puan) and puan and quiz_point>
			<cfset user_point_over_5_raw = 5*puan / quiz_point>
			<cfset user_point_over_5_raw = round(user_point_over_5_raw*100)/100>
			<cfif user_point_over_5_raw gte 0 and user_point_over_5_raw lte 1.24><!--- gte 1 --->
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
		<cfelse>
			
		</cfif>
<cfquery name="UPD_TRAINING_PERFORMANCE" datasource="#dsn#">
	UPDATE
		TRAINING_PERFORMANCE
	SET
		<cfif len(puan) and puan and quiz_point>
			USER_POINT = #puan#,
			USER_POINT_OVER_5 = #user_point_over_5#,
		<cfelse>
			USER_POINT = NULL,
			USER_POINT_OVER_5 = NULL,
		</cfif>
		<cfif len(quiz_point)>
			PERFORM_POINT = #quiz_point#,
		</cfif>
		RESULT_ID = #RESULTID#
	WHERE
		TRAINING_PERFORMANCE_ID=#get_training_perf_id.MAX_ID# AND
		TRAINING_QUIZ_ID = #attributes.QUIZ_ID#
</cfquery>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

