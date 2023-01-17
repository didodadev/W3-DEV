<cf_date tarih='attributes.INTERVIEW_DATE'>

<!--- <cfinclude template="../query/get_quiz_chapters.cfm"> --->
<cfquery name="GET_QUIZ_CHAPTERS" datasource="#dsn#">
	SELECT 
		*
	FROM 
		EMPLOYEE_QUIZ_CHAPTER
	WHERE
		QUIZ_ID=#attributes.QUIZ_ID#
</cfquery>

<!--- ******************************************************* --->
<cfset TOPLAM_chaptergecerli_agirlik = 0>
<cfloop query="get_quiz_chapters">
	<cfset attributes.CHAPTER_ID = get_quiz_chapters.CHAPTER_ID>
	<!--- <cfinclude template="../query/get_quiz_questions.cfm"> --->
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
		<cfif isdefined('FORM.USER_ANSWER_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#')>
			<cfif not isdefined('FORM.gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#')>
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
		<!---   <cfinclude template="../query/get_quiz_questions.cfm"> --->
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
	<cfquery name="ADD_QUIZ_RESULT" datasource="#dsn#">
		INSERT INTO
			EMPLOYEE_QUIZ_RESULTS
			(
			QUIZ_ID,
			APP_EMP_ID,
			USER_POINT,
			APP_POS_ID
			)
		VALUES
			(
			#attributes.QUIZ_ID#,
			#attributes.empapp_id#,
			0,
		<cfif isdefined('attributes.app_pos_id')>
			#attributes.app_pos_id#
		<cfelse>
			NULL
		</cfif>
			)
	</cfquery>
	<cfquery name="GET_RESULT_ID" datasource="#dsn#">
		SELECT
			MAX(RESULT_ID) AS MAX_ID
		FROM
			EMPLOYEE_QUIZ_RESULTS
		WHERE
			APP_EMP_ID=#attributes.empapp_id# AND
			QUIZ_ID = #attributes.QUIZ_ID# AND
			APP_POS_ID <cfif isdefined('attributes.app_pos_id')>= #attributes.app_pos_id#<cfelse>IS NULL</cfif>
	</cfquery>
	<cfset RESULTID = GET_RESULT_ID.MAX_ID> 
	<cfquery name="add_app_quiz" datasource="#dsn#">
		UPDATE
			EMPLOYEES_APP_QUIZ
		SET
			QUIZ_RESULT_ID = #RESULTID#
		WHERE 
			EMP_APP_QUIZ_ID = #attributes.emp_app_quiz_id#
	</cfquery>

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
		<!--- <cfinclude template="../query/get_quiz_questions.cfm"> --->
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
	</cfloop> <cfoutput><cf_get_lang_main no='1572.puan'>#puan#</cfoutput>
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
<cflock name="#CreateUUID()#" timeout="60">
<cftransaction>
	<cfquery name="add_perform" datasource="#dsn#">
	 INSERT INTO
		EMPLOYEE_PERFORMANCE_APP
		(
			EMP_APP_ID,
		<cfif isdefined('attributes.app_pos_id')>
			APP_POS_ID,
		</cfif>	
			MEET_POS_CODE,
			ENTRY_EMP_ID,
			NOTES,
			REF_CONTROL,
		<cfif len(quiz_point)>
			PERFORM_POINT,
		</cfif>
			USER_POINT,
			USER_POINT_OVER_5,
			PERFORM_POINT_ID,
			RESULT_ID,
			RECORD_EMP,
			RECORD_IP,
			RECORD_DATE,
			EMP_APP_QUIZ_ID,
			INTERVIEW_DATE,
			ENG_TEST_RESULT,
			ABILITY_TEST_RESULT,
			OTHER_POSITION_CODE,
			IS_VIEW
		)
		VALUES
		(
			#attributes.empapp_id#,
		<cfif isdefined('attributes.app_pos_id')>
			#attributes.app_pos_id#,
		</cfif>	
			#meet_position_code#,
			#entry_employee_id#,
			'#notes#',
			'#ref_control#',
		<cfif len(quiz_point)>
			#quiz_point#,
		</cfif>
		<cfif len(puan) and puan and quiz_point>
			#puan#,
			#user_point_over_5#,
		<cfelse>
			NULL,
			NULL,
		</cfif>
			#PERFORM_POINT_ID#,
			#RESULTID#,
			'#SESSION.EP.USERID#',
			'#CGI.REMOTE_ADDR#',
			#now()#,
			#attributes.emp_app_quiz_id#,
			#attributes.INTERVIEW_DATE#,
			'#attributes.eng_test_result#',
			'#attributes.ability_test_result#',
			<cfif len(other_position_code)>#attributes.other_position_code#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.is_view") and attributes.is_view eq 1>#attributes.is_view#<cfelse>0</cfif>
		)
	 </cfquery> 
</cftransaction>
</cflock>

<cfif isdefined('attributes.is_cv') or isdefined('attributes.is_app')>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
	<cfabort>
</cfif>
