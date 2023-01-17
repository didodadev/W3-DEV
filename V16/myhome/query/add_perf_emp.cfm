<cfset attributes.start_date_1= attributes.start_date>
<cfset attributes.finish_date_1= attributes.finish_date>
<cf_date tarih='attributes.start_date_1'>
<cf_date tarih='attributes.finish_date_1'>
<cfquery name="get_perf_1" datasource="#dsn#">
	SELECT 
		EMPLOYEE_PERFORMANCE.PER_ID,
		EMPLOYEE_PERFORMANCE.PER_STAGE,
		EMPLOYEE_QUIZ_RESULTS.RESULT_ID,
		EMPLOYEE_QUIZ_RESULTS.QUIZ_ID
	FROM 
		EMPLOYEE_QUIZ_RESULTS,
		EMPLOYEE_PERFORMANCE
	WHERE
		EMPLOYEE_PERFORMANCE.EMP_ID=EMPLOYEE_QUIZ_RESULTS.EMP_ID
		AND EMPLOYEE_QUIZ_RESULTS.EMP_ID=#attributes.EMP_ID#
		AND EMPLOYEE_QUIZ_RESULTS.QUIZ_ID=#attributes.QUIZ_ID#
		AND EMPLOYEE_PERFORMANCE.PER_TYPE=1
		AND EMPLOYEE_PERFORMANCE.RECORD_TYPE=#attributes.record_type#
		AND EMPLOYEE_PERFORMANCE.START_DATE = #attributes.start_date_1#
		AND	EMPLOYEE_PERFORMANCE.FINISH_DATE = #attributes.finish_date_1#
	ORDER BY 
		EMPLOYEE_PERFORMANCE.PER_ID DESC
</cfquery>
<cfif get_perf_1.recordcount>
	<!--- bu calisan icin ayni form dolduruldu ise guncellemeli --->
	<cfset attributes.old_process_line=1>
	<cfset result_id=get_perf_1.RESULT_ID>
	<cfset attributes.per_id=get_perf_1.PER_ID>
	<cfset attributes.quiz_id=get_perf_1.QUIZ_ID>
	<cfinclude template="upd_perf_emp.cfm">
<cfelse>
	<cf_date tarih='attributes.start_date'>
	<cf_date tarih='attributes.finish_date'>
	<cf_date tarih='attributes.eval_date'>
	<cfinclude template="../query/get_quiz_chapters.cfm">
	<!--- ******************************************************* --->
	<cfset toplam_chaptergecerli_agirlik = 0>
	<cfset toplam_chaptergecerli_agirlik_calisan = 0>
	<cfset toplam_chaptergecerli_agirlik_yonetici = 0>
	<cfloop query="get_quiz_chapters">
		<cfset attributes.chapter_id = get_quiz_chapters.chapter_id>
		<cfinclude template="../query/get_quiz_questions.cfm">
		<cfset toplam_sorugecerli = 0>
		<cfset toplam_sorugecerli_calisan = 0>
		<cfset toplam_sorugecerli_yonetici = 0>
		<cfloop query="get_quiz_questions">
		<!---ortak değerlendirme gecerli soru sayısı--->
			<cfif isdefined('attributes.user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#')>
				<cfif not isdefined('attributes.gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#')>
					<cfset sorugecerli = 1>
				<cfelse>
					<cfset sorugecerli = 0>
				</cfif>
				<cfset toplam_sorugecerli = toplam_sorugecerli + sorugecerli>
			</cfif>
		</cfloop>
		<cfset "toplam_sorugecerli_#attributes.chapter_id#" = toplam_sorugecerli>
		<cfif toplam_sorugecerli gte (get_quiz_questions.recordcount/2)>
			<cfset "perfsalarycheck_chapter_#attributes.CHAPTER_ID#" = 1>
			<cfif len(get_quiz_chapters.chapter_weight)>
				<cfset chaptergecerli_agirlik = get_quiz_chapters.chapter_weight>
			<cfelse>
				<cfset chaptergecerli_agirlik=1>
			</cfif>
		<cfelse>
			<cfset "perfsalarycheck_chapter_#attributes.chapter_id#" = 0>
			<cfset chaptergecerli_agirlik = 0>
		</cfif> 
		<cfset toplam_chaptergecerli_agirlik = toplam_chaptergecerli_agirlik + chaptergecerli_agirlik>
	</cfloop>
	<cfset quiz_point = 0>
	<cfoutput query="get_quiz_chapters">
		<cfset attributes.chapter_id = chapter_id>
		<cfif len(get_quiz_chapters.chapter_weight)>
			<cfset chapterweight = get_quiz_chapters.chapter_weight>
		<cfelse>
			<cfset chapterweight = 1>
		</cfif>
		<cfset answer_number_gelen = get_quiz_chapters.answer_number>
		<cfinclude template="../query/get_quiz_questions.cfm">
		<cfif evaluate("perfsalarycheck_chapter_#chapter_id#")>
			  <cfscript>
				for (i=1; i lte 20; i = i+1)
					{
					"a#i#" = evaluate("get_quiz_chapters.answer#i#_text");
					"b#i#" = evaluate("get_quiz_chapters.answer#i#_photo");
					"c#i#" = evaluate("get_quiz_chapters.answer#i#_point");
					}
			  </cfscript>
			  <cfif get_quiz_questions.recordcount>
				<cfloop query="get_quiz_questions">
					<cfif not isdefined('attributes.gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#') and isdefined('attributes.user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#')>
						 <cfif answer_number_gelen neq 0>
							<cfset listem = "">
							  <cfloop from="1" to="#answer_number_gelen#" index="i">
								  <cfif len(evaluate("b#i#")) or len(evaluate("a#i#"))>
									<cfset listem = listem&evaluate("c#i#")&','>
								  </cfif>
							  </cfloop>
							<!--- testte alınabilecek en yüksek puan hesaplanıyor --->
							<cfif not len(listem)><cfset listem=0></cfif><!--- şık yoksa yukardaki döngüye girmiyor boş değerdede altaki hesaplama hataveriyordu o yüzden eklendi--->
							<cfset hesaplanan = chapterweight / evaluate("toplam_sorugecerli_#attributes.chapter_id#") * listlast(listsort(listem,'numeric'))>
							<cfset quiz_point = quiz_point + hesaplanan>				 
						 </cfif>
					</cfif>
				</cfloop>	
			</cfif>
		</cfif>
	</cfoutput>
	<cfif toplam_chaptergecerli_agirlik gte 50><!--- formda gecerli bolumlerin agirligi 50 yi gecmiyorsa form gecersiz olur puanlar 0 olarak kayit olur--->
		<cfset IS_PERF_SALARY_RESULTING = 1>
	<cfelse>
		<cfset IS_PERF_SALARY_RESULTING = 0>
	</cfif>
	<!--- /////////////////////////////////////////////////////// --->
	<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfquery name="ADD_QUIZ_RESULT" datasource="#dsn#">
			INSERT INTO
				EMPLOYEE_QUIZ_RESULTS
				(
				QUIZ_ID,
				EMP_ID,
				USER_POINT,
				START_DATE,
				FINISH_DATE
				)
			VALUES
				(
				#attributes.QUIZ_ID#,
				#attributes.EMP_ID#,
				0,
				#attributes.start_date#,
				#attributes.finish_date#
				)
		</cfquery>	
		<cfquery name="GET_RESULT_ID" datasource="#dsn#">
			SELECT
				MAX(RESULT_ID) AS MAX_ID
			FROM
				EMPLOYEE_QUIZ_RESULTS
			WHERE
				EMP_ID=#attributes.EMP_ID# AND
				QUIZ_ID = #attributes.QUIZ_ID# AND
				START_DATE = #attributes.start_date# AND
				FINISH_DATE = #attributes.finish_date#
		</cfquery>
		<cfset RESULTID = GET_RESULT_ID.MAX_ID> 
	</cftransaction>
	</cflock>
	<!--- form sonuç kaydı --->
	<cfinclude template="../query/get_quiz_info.cfm">
			<cfset puan = 0>
			<cfset puan_yonetici =0>
			<cfset puan_calisan =0>
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
						EXPLANATION1,
						EXPLANATION2,
						EXPLANATION3,
						EXPLANATION4
						)
					VALUES
						(
						#RESULTID#,
						#attributes.CHAPTER_ID#,
						<cfif isdefined("attributes.exp1_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp1_#get_quiz_chapters.currentrow#"))>'#replace(evaluate("attributes.exp1_#get_quiz_chapters.currentrow#"),"'"," ","all")#'<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.exp2_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp2_#get_quiz_chapters.currentrow#"))>'#replace(evaluate("attributes.exp2_#get_quiz_chapters.currentrow#"),"'"," ","all")#'<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.exp3_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp3_#get_quiz_chapters.currentrow#"))>'#replace(evaluate("attributes.exp3_#get_quiz_chapters.currentrow#"),"'"," ","all")#'<cfelse>NULL</cfif>,
						<cfif isdefined("attributes.exp4_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp4_#get_quiz_chapters.currentrow#"))>'#replace(evaluate("attributes.exp4_#get_quiz_chapters.currentrow#"),"'"," ","all")#'<cfelse>NULL</cfif>
						)
				</cfquery>
				<cfinclude template="../query/get_quiz_questions.cfm">
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
									<cfif session.ep.userid eq attributes.emp_id>
										QUESTION_POINT_EMP,
										<cfif isdefined("FORM.USER_ANSWER_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)>
										QUESTION_EMP_ANSWERS,
										<cfelse>
										QUESTION_EMP_OPENED_ANSWERS,
										</cfif>
										EMP_GD
									<cfelseif isdefined('attributes.manager_1_emp_id') and len(attributes.manager_1_emp_id) and isdefined('attributes.manager_1_pos_name') and len(attributes.manager_1_pos_name) and session.ep.userid eq attributes.manager_1_emp_id>
										QUESTION_POINT_MANAGER1,
										<cfif isdefined("FORM.USER_ANSWER_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)>
										QUESTION_MANAGER1_ANSWERS,
										<cfelse>
										QUESTION_MANAGER1_OPENED_ANSWERS,
										</cfif>
										MANAGER1_GD
									<cfelseif isdefined('attributes.manager_2_emp_id') and len(attributes.manager_2_emp_id) and isdefined('attributes.manager_2_pos_name') and len(attributes.manager_2_pos_name) and session.ep.userid eq attributes.manager_2_emp_id>
										QUESTION_POINT_MANAGER2,
										<cfif isdefined("FORM.USER_ANSWER_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)>
										QUESTION_MANAGER2_ANSWERS,
										<cfelse>
										QUESTION_MANAGER2_OPENED_ANSWERS,
										</cfif>
										MANAGER2_GD
									<cfelseif isdefined('attributes.manager_3_emp_id') and len(attributes.manager_3_emp_id) and isdefined('attributes.manager_3_pos_name') and len(attributes.manager_3_pos_name) and session.ep.userid eq attributes.manager_3_emp_id>
										QUESTION_POINT_MANAGER3,
										<cfif isdefined("FORM.USER_ANSWER_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)>
										QUESTION_MANAGER3_ANSWERS,
										<cfelse>
										QUESTION_MANAGER3_OPENED_ANSWERS,
										</cfif>
										MANAGER3_GD
									<cfelse>
										QUESTION_POINT,
										<cfif isdefined("FORM.USER_ANSWER_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)>
										QUESTION_USER_ANSWERS,
										<cfelse>
										QUESTION_USER_OPENED_ANSWERS,
										</cfif>
										GD
									</cfif>
									)
								VALUES
									(
									#RESULTID#,
									#GET_QUIZ_QUESTIONS.QUESTION_ID#,
									#yeni_puan#,
									<cfif isdefined("FORM.USER_ANSWER_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)>
										#EVALUATE("FORM.USER_ANSWER_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)#,
									<cfelseif  isdefined("FORM.gd_opened_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)>
										'#EVALUATE("FORM.gd_opened_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)#',
									</cfif>
									#GD#
									)
							</cfquery> 
							<cfquery name="upd_result_detail" datasource="#dsn#">
								UPDATE
									EMPLOYEE_QUIZ_RESULTS_DETAILS
								SET
									QUESTION_POINT = #yeni_puan#,
									QUESTION_USER_ANSWERS = #EVALUATE("FORM.USER_ANSWER_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)#,
									GD = #GD#
								WHERE
									RESULT_ID = #RESULTID# AND 
									QUESTION_ID = #GET_QUIZ_QUESTIONS.QUESTION_ID#
							</cfquery>	
						<cfelse>
							<cfif not IsDefined('FORM.gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#')>
								<cfset GD = 0>
							<cfelse>
								<cfset GD = 1>
							</cfif>
							<cfset yeni_puan = 0>
							<cfquery name="ADD_RESULT_DETAIL" datasource="#dsn#">
								INSERT INTO
									EMPLOYEE_QUIZ_RESULTS_DETAILS
									(
									RESULT_ID,
									QUESTION_ID,
									<cfif session.ep.userid eq attributes.emp_id>
										QUESTION_POINT_EMP,
										<cfif isdefined("FORM.USER_ANSWER_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)>
										QUESTION_EMP_ANSWERS,
										<cfelseif  isdefined("FORM.gd_opened_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)>
										QUESTION_EMP_OPENED_ANSWERS,
										</cfif>
										EMP_GD
									<cfelseif isdefined('attributes.manager_1_emp_id') and len(attributes.manager_1_emp_id) and isdefined('attributes.manager_1_pos_name') and len(attributes.manager_1_pos_name) and session.ep.userid eq attributes.manager_1_emp_id>
										QUESTION_POINT_MANAGER1,
										<cfif isdefined("FORM.USER_ANSWER_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)>
										QUESTION_MANAGER1_ANSWERS,
										<cfelseif  isdefined("FORM.gd_opened_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)>
										QUESTION_MANAGER1_OPENED_ANSWERS,
										</cfif>
										MANAGER1_GD
									<cfelseif isdefined('attributes.manager_2_emp_id') and len(attributes.manager_2_emp_id) and isdefined('attributes.manager_2_pos_name') and len(attributes.manager_2_pos_name) and session.ep.userid eq attributes.manager_2_emp_id>
										QUESTION_POINT_MANAGER2,
										<cfif isdefined("FORM.USER_ANSWER_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)>
										QUESTION_MANAGER2_ANSWERS,
										<cfelseif  isdefined("FORM.gd_opened_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)>
										QUESTION_MANAGER2_OPENED_ANSWERS,
										</cfif>
										MANAGER2_GD
									<cfelseif isdefined('attributes.manager_3_emp_id') and len(attributes.manager_3_emp_id) and isdefined('attributes.manager_3_pos_name') and len(attributes.manager_3_pos_name) and session.ep.userid eq attributes.manager_3_emp_id>
										QUESTION_POINT_MANAGER3,
										<cfif isdefined("FORM.USER_ANSWER_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)>
										QUESTION_MANAGER3_ANSWERS,
										<cfelse>
										QUESTION_MANAGER3_OPENED_ANSWERS,
										</cfif>
										MANAGER3_GD
									<cfelse>
									QUESTION_POINT,
									QUESTION_USER_ANSWERS,
									GD
									</cfif>
									)
								VALUES
									(
									#RESULTID#,
									#GET_QUIZ_QUESTIONS.QUESTION_ID#,
									0,
									<cfif isdefined("FORM.USER_ANSWER_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)>
										#EVALUATE("FORM.USER_ANSWER_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)#,
									<cfelseif  isdefined("FORM.gd_opened_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)>
										'#EVALUATE("FORM.gd_opened_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)#',
									</cfif>
									#GD#
									)
							</cfquery>
							<cfquery name="upd_result_detail" datasource="#dsn#">
								UPDATE
									EMPLOYEE_QUIZ_RESULTS_DETAILS
								SET
									QUESTION_POINT = 0,
									QUESTION_USER_ANSWERS = 0,
									GD = #GD#
								WHERE
									RESULT_ID = #RESULTID# AND 
									QUESTION_ID = #GET_QUIZ_QUESTIONS.QUESTION_ID#
							</cfquery>	
						</cfif>
						<cfset puan = puan + yeni_puan>
					</cfloop> 
				<!--- </cfif> --->
		</cfloop>
		<!--- // kağıdı gönder --->
		
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
				<cfset user_point_over_5 = 0>
			</cfif>
			
	<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		  <cfquery name="add_perform" datasource="#dsn#">
			 INSERT INTO
				EMPLOYEE_PERFORMANCE
				(
				EMP_ID,
				PER_TYPE,
				EMP_POSITION_NAME,
				MANAGER_1_POS,
				MANAGER_2_POS,
				MANAGER_3_POS,
				MANAGER_1_EMP_ID,
				MANAGER_2_EMP_ID,
				MANAGER_3_EMP_ID,
				START_DATE,
				FINISH_DATE,
				POWERFUL_ASPECTS,
				TRAIN_NEED_ASPECTS,
				MANAGER_2_EVALUATION,
				MANAGER_3_EVALUATION,
				EMPLOYEE_OPINION,
				EMPLOYEE_OPINION_ID,
				LUCK_TRAIN_SUBJECT_1,
				LUCK_TRAIN_SUBJECT_2,
				LUCK_TRAIN_SUBJECT_3,
				LUCK_TRAIN_SUBJECT_4,
				LUCK_TRAIN_SUBJECT_5,
				LUCK_TRAIN_SUBJECT_6,
				LUCK_TRAIN_SUBJECT_7,
				LUCK_TRAIN_SUBJECT_8,
			<cfif len(quiz_point)>
			<cfif session.ep.userid eq attributes.emp_id>
			EMP_PERFORM_POINT,
			<cfelseif isdefined('attributes.manager_1_emp_id') and len(attributes.manager_1_emp_id) and isdefined('attributes.manager_1_pos_name') and len(attributes.manager_1_pos_name) and session.ep.userid eq attributes.manager_1_emp_id>
			MANAGER_PERFORM_POINT,
			<cfelseif isdefined('attributes.manager_3_emp_id') and len(attributes.manager_3_emp_id) and isdefined('attributes.manager_3_pos_name') and len(attributes.manager_3_pos_name) and session.ep.userid eq attributes.manager_3_emp_id>
			MANAGER3_PERFORM_POINT,
			<cfelse>
			PERFORM_POINT,
			</cfif>
			</cfif>
			<cfif len(puan) and puan and quiz_point>
				<cfif session.ep.userid eq attributes.emp_id>
				EMP_POINT,
				EMP_POINT_OVER_5,
				<cfelseif isdefined('attributes.manager_1_emp_id') and len(attributes.manager_1_emp_id) and isdefined('attributes.manager_1_pos_name') and len(attributes.manager_1_pos_name) and session.ep.userid eq attributes.manager_1_emp_id>
				MANAGER_POINT,
				MANAGER_POINT_OVER_5,
				<cfelseif isdefined('attributes.manager_3_emp_id') and len(attributes.manager_3_emp_id) and isdefined('attributes.manager_3_pos_name') and len(attributes.manager_3_pos_name) and session.ep.userid eq attributes.manager_3_emp_id>
				MANAGER3_POINT,
				MANAGER3_POINT_OVER_5,
				<cfelse>
				USER_POINT,
				USER_POINT_OVER_5,
				</cfif>
			</cfif>
				PERFORM_POINT_ID,
				IS_PERF_SALARY_RESULTING,
			<cfif isdefined('attributes.valid1') and len(attributes.valid1)>
				VALID_1,
				VALID_1_EMP,
				VALID_1_DATE,
			</cfif>
			<cfif isdefined('attributes.valid2') and len(attributes.valid2)>
				VALID_2,
				VALID_2_EMP,
				VALID_2_DATE,
			</cfif>
			<cfif isdefined('attributes.valid3') and len(attributes.valid3)>
				VALID_3,
				VALID_3_EMP,
				VALID_3_DATE,
			</cfif>
			<cfif isdefined('attributes.valid') and len(attributes.valid)>
				VALID,
			</cfif>
			<cfif isdefined('attributes.valid4') and len(attributes.valid4)>
				VALID_4,
			</cfif>
				RESULT_ID,
				EVAL_DATE,
				EMP_CAREER_STATUS,
				EMP_CAREER_EXP,
				OTHER_CAREER_EXP,
				MANAGER_CAREER_STATUS,
				MANAGER_3_CAREER_STATUS,
				MANAGER_CAREER_EXP,
				MANAGER_3_CAREER_EXP,
				EMP_TRAINING_CAT,
				EMP_TRAINING_EXP,
				OTHER_TRAINING_EXP,
				MANAGER_TRAINING_CAT,
				MANAGER_3_TRAINING_CAT,
				MANAGER_TRAINING_EXP,
				MANAGER_3_TRAINING_EXP,
				RECORD_TYPE,
				RECORD_KEY,
				RECORD_IP,
				RECORD_DATE,
				PER_STAGE
				)
				VALUES
				(
				#attributes.EMP_ID#,
				1,
				'#attributes.POSITION_NAME#',
				<cfif isdefined('MANAGER_1_POS') and  len(MANAGER_1_POS)>#MANAGER_1_POS#,<cfelse>NULL,</cfif>
				<cfif isdefined('MANAGER_2_POS') and len(MANAGER_2_POS)>#MANAGER_2_POS#,<cfelse>NULL,</cfif>
				<cfif isdefined('MANAGER_3_POS') and len(MANAGER_3_POS)>#MANAGER_3_POS#,<cfelse>NULL,</cfif>
				<cfif isdefined('MANAGER_1_EMP_ID') and len(MANAGER_1_EMP_ID)>#MANAGER_1_EMP_ID#,<cfelse>NULL,</cfif>
				<cfif isdefined('MANAGER_2_EMP_ID') and len(MANAGER_2_EMP_ID)>#MANAGER_2_EMP_ID#,<cfelse>NULL,</cfif>
				<cfif isdefined('MANAGER_3_EMP_ID') and len(MANAGER_3_EMP_ID)>#MANAGER_3_EMP_ID#,<cfelse>NULL,</cfif>
				#attributes.start_date#,
				#attributes.finish_date#,
				<cfif isdefined('POWERFUL_ASPECTS')>'#POWERFUL_ASPECTS#',<cfelse>NULL,</cfif>
				<cfif isdefined('TRAIN_NEED_ASPECTS')>'#TRAIN_NEED_ASPECTS#',<cfelse>NULL,</cfif>
				<cfif isdefined('MANAGER_2_EVALUATION')>'#MANAGER_2_EVALUATION#',<cfelse>NULL,</cfif>
				<cfif isdefined('MANAGER_3_EVALUATION')>'#MANAGER_3_EVALUATION#',<cfelse>NULL,</cfif>
				<cfif isdefined('attributes.EMPLOYEE_OPINION')>'#attributes.EMPLOYEE_OPINION#',<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.EMPLOYEE_OPINION_ID")>#attributes.EMPLOYEE_OPINION_ID#<cfelse>NULL</cfif>,
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				'',
				<cfif len(quiz_point)>
					#quiz_point#,
				</cfif>
			<cfif IS_PERF_SALARY_RESULTING eq 1><!--- form gecersizse aldigi puanlara 0 kaydediyoruz--->
				<cfif len(puan) and puan and quiz_point>
					#puan/10#,
					#user_point_over_5#,
				</cfif>
			<cfelse>
				<cfif len(puan) and puan and quiz_point>
					NULL,
					NULL,
				</cfif>
			</cfif>
				#PERFORM_POINT_ID#,
				#IS_PERF_SALARY_RESULTING#,
			<cfif isdefined('attributes.valid1') and len(attributes.valid1)>
				#attributes.valid1#,
				#session.ep.userid#,
				#now()#,
			</cfif>
			<cfif isdefined('attributes.valid2') and len(attributes.valid2)>
				#attributes.valid2#,
				#session.ep.userid#,
				#now()#,
			</cfif>
			<cfif isdefined('attributes.valid3') and len(attributes.valid3)>
				#attributes.valid3#,
				#session.ep.userid#,
				#now()#,
			</cfif>
			<cfif isdefined('attributes.valid') and len(attributes.valid)>
				#attributes.valid#,
			</cfif>
			<cfif isdefined('attributes.valid4') and len(attributes.valid4)>
				#attributes.valid4#,
			</cfif>
				#RESULTID#,
				#attributes.eval_date#,
				<cfif isdefined('attributes.emp_career_status') and len(attributes.emp_career_status)>
					#attributes.emp_career_status#,
				<cfelse>
					NULL,
				</cfif>
				<cfif isdefined("attributes.emp_career_exp")>'#attributes.emp_career_exp#',<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.other_career_exp")>'#attributes.other_career_exp#',<cfelse>NULL,</cfif>
				<cfif isdefined('attributes.manager_career_status') and len(attributes.manager_career_status)>
					#attributes.manager_career_status#,
				<cfelse>
					NULL,
				</cfif>
				<cfif isdefined('attributes.manager_3_career_status') and len(attributes.manager_3_career_status)>
					#attributes.manager_3_career_status#,
				<cfelse>
					NULL,
				</cfif>
				<cfif isdefined("attributes.manager_career_exp")>'#attributes.manager_career_exp#',<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.manager_3_career_exp")>'#attributes.manager_3_career_exp#',<cfelse>NULL,</cfif>
				<cfif isdefined('attributes.emp_training_cat')>',#attributes.emp_training_cat#,',<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.emp_training_exp")>'#attributes.emp_training_exp#',<cfelse>NULL,</cfif>
				<cfif isdefined("attributes.other_training_exp")>'#attributes.other_training_exp#',<cfelse>NULL,</cfif>
				<cfif isdefined('attributes.manager_training_cat')>',#attributes.manager_training_cat#,',<cfelse>NULL,</cfif>
				<cfif isdefined('attributes.manager_3_training_cat')>',#attributes.manager_3_training_cat#,',<cfelse>NULL,</cfif>
				<cfif isdefined('attributes.manager_training_exp')>'#attributes.manager_training_exp#',<cfelse>NULL,</cfif>
				<cfif isdefined('attributes.manager_3_training_exp')>'#attributes.manager_3_training_exp#',<cfelse>NULL,</cfif>
				<cfif isdefined('attributes.record_type') and len(attributes.record_type)>
					#attributes.record_type#,
				<cfelse>
					NULL,
				</cfif>
					'#SESSION.EP.USERKEY#',
					'#CGI.REMOTE_ADDR#',
					#now()#,
					<cfif len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>
				)
		 </cfquery> 
		 <cfquery name="get_perform" datasource="#dsn#">
			 SELECT MAX(PER_ID) AS MAX_PER_ID FROM EMPLOYEE_PERFORMANCE WHERE EMP_ID = #attributes.EMP_ID#
		 </cfquery>
		 <cfquery name="upd_perf" datasource="#dsn#">
			UPDATE
				EMPLOYEE_PERFORMANCE
			SET
				PERFORM_POINT = <cfif len(quiz_point)>#quiz_point#<cfelse>NULL</cfif>,
				USER_POINT = <cfif len(puan) and IS_PERF_SALARY_RESULTING eq 1>#puan#<cfelse>NULL</cfif>,
				USER_POINT_OVER_5 = <cfif len(user_point_over_5) and IS_PERF_SALARY_RESULTING eq 1>#user_point_over_5#<cfelse>NULL</cfif>
			WHERE
				PER_ID = #get_perform.max_per_id#
		</cfquery>
	</cftransaction>
	</cflock>
		<cf_workcube_process 
			is_upd='1' 
			old_process_line='0'
			process_stage='#attributes.process_stage#' 
			record_member='#session.ep.userid#' 
			record_date='#now()#'
			action_table='EMPLOYEE_PERFORMANCE'
			action_column='PER_ID'
			action_id='#get_perform.MAX_PER_ID#'
			action_page='#request.self#?fuseaction=myhome.list_perform'
			warning_description='Performans Değerlendirme Formu'>
</cfif>
<cflocation addtoken="no" url="#request.self#?fuseaction=myhome.list_perform">
