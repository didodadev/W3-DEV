<cfif isdefined('attributes.quiz_id')><!--- formdan gelmiyorsa sorun olmaması için konuldu--->
	<cf_date tarih='attributes.start_date'>
	<cf_date tarih='attributes.finish_date'>
	<cf_date tarih='attributes.old_start_date'>
	<cf_date tarih='attributes.old_finish_date'>
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
		<!--- ortak değerlendirme gecerli soru sayısı--->
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
			<cfset "perfsalarycheck_chapter_#attributes.chapter_id#" = 1>
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
								<cfset hesaplanan = chapterweight / evaluate("toplam_sorugecerli_#attributes.chapter_id#") * ListLast(ListSort(listem,'numeric'))>
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
	<!---YÖNETİCİ VE CALIŞAN PUANLAMASI--->
	<cfinclude template="../query/get_quiz_info.cfm">
	
	<cfset puan = 0>
	<cfloop query="get_quiz_chapters">
		<cfset attributes.chapter_id = get_quiz_chapters.chapter_id>
		<cfif len(get_quiz_chapters.chapter_weight)>
			<cfset chapterweight = get_quiz_chapters.CHAPTER_weight>
		<cfelse>
			<cfset chapterweight = 1>
		</cfif>
		<cfquery name="get_result_detail_chapter" datasource="#dsn#">
		SELECT 
			RESULT_ID
		FROM
			EMPLOYEE_QUIZ_CHAPTER_EXPL
		WHERE	
				RESULT_ID = #RESULT_ID# AND
				CHAPTER_ID=#attributes.CHAPTER_ID#
		</cfquery>
		<cfif get_result_detail_chapter.recordcount>
			<cfquery name="ADD_RESULT_DETAIL_CHAPTER" datasource="#dsn#">
				UPDATE
					EMPLOYEE_QUIZ_CHAPTER_EXPL
				SET
					RESULT_ID = #RESULT_ID#
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
					RESULT_ID = #RESULT_ID# AND
					CHAPTER_ID=#attributes.CHAPTER_ID#
			</cfquery>
		<cfelse>
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
					#RESULT_ID#,
					#attributes.CHAPTER_ID#
					<cfif isdefined("attributes.exp1_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp1_#get_quiz_chapters.currentrow#"))>,'#replace(evaluate("attributes.exp1_#get_quiz_chapters.currentrow#"),"'"," ","all")#'</cfif>
					<cfif isdefined("attributes.exp2_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp2_#get_quiz_chapters.currentrow#"))>,'#replace(evaluate("attributes.exp2_#get_quiz_chapters.currentrow#"),"'"," ","all")#'</cfif>
					<cfif isdefined("attributes.exp3_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp3_#get_quiz_chapters.currentrow#"))>,'#replace(evaluate("attributes.exp3_#get_quiz_chapters.currentrow#"),"'"," ","all")#'</cfif>
					<cfif isdefined("attributes.exp4_#get_quiz_chapters.currentrow#") and len(evaluate("attributes.exp4_#get_quiz_chapters.currentrow#"))>,'#replace(evaluate("attributes.exp4_#get_quiz_chapters.currentrow#"),"'"," ","all")#'</cfif>
					)
			</cfquery>
		</cfif>
		<cfinclude template="../query/get_quiz_questions.cfm">
		<cfloop query="get_quiz_questions">
			<cfif IsDefined('attributes.user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#')>
				<cfif not IsDefined('attributes.gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#') and evaluate("perfsalarycheck_chapter_#chapter_id#")>
					<cfset yeni_puan = ListGetAt(
						EVALUATE('attributes.user_answer_'&get_quiz_chapters.currentrow&'_'&get_quiz_questions.currentrow&'_point'), 
						EVALUATE('attributes.user_answer_'&get_quiz_chapters.currentrow&'_'&get_quiz_questions.currentrow))
						* chapterweight / evaluate("toplam_sorugecerli_#attributes.chapter_id#")>			
				<cfelse>
					<cfset yeni_puan = 0>
				</cfif>
				<cfif not IsDefined('attributes.gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#')>
					<cfset GD = 0>
				<cfelse>
					<cfset GD = 1>
				</cfif>
				<cfquery name="UPD_RESULT_DETAIL" datasource="#dsn#">
					UPDATE
						EMPLOYEE_QUIZ_RESULTS_DETAILS
					SET
						<cfif session.ep.userid eq attributes.emp_id>
						QUESTION_POINT_EMP = #yeni_puan#,
						QUESTION_EMP_ANSWERS = #EVALUATE("attributes.user_answer_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)#,
						EMP_GD = #GD#,
						<cfelseif len(amir_onay) and  amir_onay is 1 and get_quiz_info.form_open_type eq 1 and isdefined('attributes.manager_1_emp_id') and len(attributes.manager_1_emp_id) and isdefined('attributes.manager_1_pos_name') and len(attributes.manager_1_pos_name) and session.ep.userid eq attributes.manager_1_emp_id>
						QUESTION_POINT_MAN_EMP = #yeni_puan#,
						QUESTION_MAN_EMP_ANSWERS = #EVALUATE("attributes.user_answer_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)#,
						MAN_EMP_GD = #GD#,
						<cfelseif isdefined('attributes.manager_1_emp_id') and len(attributes.manager_1_emp_id) and isdefined('attributes.manager_1_pos_name') and len(attributes.manager_1_pos_name) and session.ep.userid eq attributes.manager_1_emp_id>
						QUESTION_POINT_MANAGER1 = #yeni_puan#,
						QUESTION_MANAGER1_ANSWERS = #EVALUATE("attributes.user_answer_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)#,
						MANAGER1_GD = #GD#,
						<cfelseif isdefined('attributes.manager_2_emp_id') and len(attributes.manager_2_emp_id) and isdefined('attributes.manager_2_pos_name') and len(attributes.manager_2_pos_name) and session.ep.userid eq attributes.manager_2_emp_id>
						QUESTION_POINT_MANAGER2 = #yeni_puan#,
						QUESTION_MANAGER2_ANSWERS = #EVALUATE("attributes.user_answer_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)#,
						MANAGER2_GD = #GD#,
						<cfelseif isdefined('attributes.manager_3_emp_id') and len(attributes.manager_3_emp_id) and isdefined('attributes.manager_3_pos_name') and len(attributes.manager_3_pos_name) and session.ep.userid eq attributes.manager_3_emp_id>
						QUESTION_POINT_MANAGER3 = #yeni_puan#,
						QUESTION_MANAGER3_ANSWERS = #EVALUATE("attributes.user_answer_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)#,
						MANAGER3_GD = #GD#,
						</cfif>
						QUESTION_POINT = #yeni_puan#, 
						QUESTION_USER_ANSWERS = #EVALUATE("attributes.user_answer_"&get_quiz_chapters.currentrow&"_"&get_quiz_questions.currentrow)#,
						GD = #GD#
					WHERE
						RESULT_ID = #RESULT_ID# AND
						QUESTION_ID = #QUESTION_ID#
				</cfquery>
			<cfelse>
				<cfif not IsDefined('attributes.gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#')>
					<cfset GD = 0>
				<cfelse>
					<cfset GD = 1>
				</cfif>
				<cfset yeni_puan = 0>
				<cfquery name="UPD_RESULT_DETAIL" datasource="#dsn#">
					UPDATE 
						EMPLOYEE_QUIZ_RESULTS_DETAILS
					SET
						<cfif session.ep.userid eq attributes.emp_id>
						QUESTION_POINT_EMP = 0,	
						QUESTION_EMP_ANSWERS = NULL,
						EMP_GD = #GD#,				
						<cfelseif len(amir_onay) and  amir_onay is 1 and get_quiz_info.form_open_type eq 1 and isdefined('attributes.manager_1_emp_id') and len(attributes.manager_1_emp_id) and isdefined('attributes.manager_1_pos_name') and len(attributes.manager_1_pos_name) and session.ep.userid eq attributes.manager_1_emp_id>
						QUESTION_POINT_MAN_EMP = 0,
						QUESTION_MAN_EMP_ANSWERS =NULL,
						MAN_EMP_GD = #GD#,
						<cfelseif isdefined('attributes.manager_1_emp_id') and len(attributes.manager_1_emp_id) and isdefined('attributes.manager_1_pos_name') and len(attributes.manager_1_pos_name) and session.ep.userid eq attributes.manager_1_emp_id>
						QUESTION_POINT_MANAGER1 = 0,
						QUESTION_MANAGER1_ANSWERS =NULL,
						MANAGER1_GD = #GD#,
						<cfelseif isdefined('attributes.manager_2_emp_id') and len(attributes.manager_2_emp_id) and isdefined('attributes.manager_2_pos_name') and len(attributes.manager_2_pos_name) and session.ep.userid eq attributes.manager_2_emp_id>
						QUESTION_POINT_MANAGER2 = 0,
						QUESTION_MANAGER2_ANSWERS =NULL,
						MANAGER2_GD = #GD#,
						<cfelseif isdefined('attributes.manager_3_emp_id') and len(attributes.manager_3_emp_id) and isdefined('attributes.manager_3_pos_name') and len(attributes.manager_3_pos_name) and session.ep.userid eq attributes.manager_3_emp_id>
						QUESTION_POINT_MANAGER3 = 0,
						QUESTION_MANAGER3_ANSWERS =NULL,
						MANAGER3_GD = #GD#,
						</cfif>
						QUESTION_POINT = 0,
						QUESTION_USER_ANSWERS = NULL,
						GD = #GD#
					WHERE	
						RESULT_ID = #RESULT_ID# AND
						QUESTION_ID = #QUESTION_ID#
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
			<cfif isdefined("session.ep.userid")>
			UPDATE_EMP = #session.ep.userid#,
			<cfelseif isdefined("session.pp.userid")>
			UPDATE_PAR = #session.pp.userid#,
			</cfif>
			UPDATE_DATE = #now()#,
			UPDATE_IP = '#CGI.REMOTE_ADDR#',
			START_DATE = #attributes.start_date#,
			FINISH_DATE = #attributes.finish_date#
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
	<cfelse>
		<cfset user_point_over_5 = 0>
	</cfif>
	<cf_workcube_process 
		is_upd='1' 
		old_process_line='#attributes.old_process_line#'
		process_stage='#attributes.process_stage#' 
		record_member='#session.ep.userid#' 
		record_date='#now()#' 
		action_table='EMPLOYEE_PERFORMANCE'
		action_column='PER_ID'
		action_id='#attributes.PER_ID#'
		action_page='#request.self#?fuseaction=hr.form_upd_perf_emp&per_id=#attributes.PER_ID#'
		warning_description = 'Ölçme Değerlendirme : #attributes.PER_ID#'>
	<cfquery name="upd_perform" datasource="#dsn#">
		UPDATE
			EMPLOYEE_PERFORMANCE
		SET	
			<cfif isdefined('MANAGER_1_EMP_ID') and len(MANAGER_1_EMP_ID) and isdefined('MANAGER_1_POS_NAME') and len(MANAGER_1_POS_NAME)>
				MANAGER_1_EMP_ID = #MANAGER_1_EMP_ID#,
			<cfelse>
				MANAGER_1_EMP_ID = NULL,
			</cfif>
			<cfif isdefined('MANAGER_2_EMP_ID') and len(MANAGER_2_EMP_ID) and isdefined('MANAGER_2_POS_NAME') and len(MANAGER_2_POS_NAME)>
				MANAGER_2_EMP_ID = #MANAGER_2_EMP_ID#,
			<cfelse>
				MANAGER_2_EMP_ID = NULL,
			</cfif>
			<cfif isdefined('MANAGER_3_EMP_ID') and len(MANAGER_3_EMP_ID) and isdefined('MANAGER_3_POS_NAME') and len(MANAGER_3_POS_NAME)>
				MANAGER_3_EMP_ID = #MANAGER_3_EMP_ID#,
			<cfelse>
				MANAGER_3_EMP_ID = NULL,
			</cfif>
			<cfif isdefined('MANAGER_1_POS') and len(MANAGER_1_POS) and isdefined('MANAGER_1_POS_NAME') and len(MANAGER_1_POS_NAME)>
				MANAGER_1_POS = #MANAGER_1_POS#,
			<cfelse>
				MANAGER_1_POS = NULL,
			</cfif>
			<cfif isdefined('MANAGER_2_POS') and len(MANAGER_2_POS) and isdefined('MANAGER_2_POS_NAME') and len(MANAGER_2_POS_NAME)>
				MANAGER_2_POS = #MANAGER_2_POS#,
			<cfelse>
				MANAGER_2_POS = NULL,
			</cfif>
			<cfif isdefined('MANAGER_3_POS') and len(MANAGER_3_POS) and isdefined('MANAGER_3_POS_NAME') and len(MANAGER_3_POS_NAME)>
				MANAGER_3_POS = #MANAGER_3_POS#,
			<cfelse>
				MANAGER_3_POS = NULL,
			</cfif>
			<cfif isdefined('POWERFUL_ASPECTS')>POWERFUL_ASPECTS = '#POWERFUL_ASPECTS#',</cfif>
			<cfif isdefined('TRAIN_NEED_ASPECTS')>TRAIN_NEED_ASPECTS = '#TRAIN_NEED_ASPECTS#',</cfif>
			<cfif isdefined('MANAGER_2_EVALUATION')>MANAGER_2_EVALUATION = '#MANAGER_2_EVALUATION#',</cfif>
			<cfif isdefined('MANAGER_3_EVALUATION')>MANAGER_3_EVALUATION = '#MANAGER_3_EVALUATION#',</cfif>
			<cfif isdefined('EMPLOYEE_OPINION')>EMPLOYEE_OPINION = '#attributes.EMPLOYEE_OPINION#',</cfif>
			<cfif isdefined("attributes.EMPLOYEE_OPINION_ID")>EMPLOYEE_OPINION_ID = #attributes.EMPLOYEE_OPINION_ID#,</cfif>
		<cfif len(quiz_point)>
		<cfif session.ep.userid eq attributes.emp_id>
			EMP_PERFORM_POINT = #quiz_point#, 
		<cfelseif len(amir_onay) and amir_onay is 1 and get_quiz_info.form_open_type eq 1 and isdefined('MANAGER_1_EMP_ID') and len(MANAGER_1_EMP_ID) and isdefined('MANAGER_1_POS_NAME') and len(MANAGER_1_POS_NAME) and session.ep.userid eq MANAGER_1_EMP_ID>
			MAN_EMP_PERFORM_POINT = #quiz_point#,
		<cfelseif isdefined('MANAGER_1_EMP_ID') and len(MANAGER_1_EMP_ID) and isdefined('MANAGER_1_POS_NAME') and len(MANAGER_1_POS_NAME) and session.ep.userid eq MANAGER_1_EMP_ID>
			MANAGER_PERFORM_POINT = #quiz_point#,
		<cfelseif isdefined('MANAGER_3_EMP_ID') and len(MANAGER_3_EMP_ID) and isdefined('MANAGER_3_POS_NAME') and len(MANAGER_3_POS_NAME) and session.ep.userid eq MANAGER_3_EMP_ID>
			MANAGER3_PERFORM_POINT = #quiz_point#,
		</cfif>
			PERFORM_POINT = #quiz_point#,
		</cfif>
		<cfif len(puan) and puan and quiz_point and IS_PERF_SALARY_RESULTING eq 1>
			<cfif session.ep.userid eq attributes.emp_id>
			EMP_POINT = #puan#,
			EMP_POINT_OVER_5 = #user_point_over_5#,
			<cfelseif len(amir_onay) and amir_onay is 1 and get_quiz_info.form_open_type eq 1 and isdefined('MANAGER_1_EMP_ID') and len(MANAGER_1_EMP_ID) and isdefined('MANAGER_1_POS_NAME') and len(MANAGER_1_POS_NAME) and session.ep.userid eq MANAGER_1_EMP_ID>
			MAN_EMP_POINT = #puan#,
			MAN_EMP_POINT_OVER_5 = #user_point_over_5#,
			<cfelseif isdefined('MANAGER_1_EMP_ID') and len(MANAGER_1_EMP_ID) and isdefined('MANAGER_1_POS_NAME') and len(MANAGER_1_POS_NAME) and session.ep.userid eq MANAGER_1_EMP_ID>
			MANAGER_POINT = #puan#,
			MANAGER_POINT_OVER_5 = #user_point_over_5#,
			<cfelseif isdefined('MANAGER_3_EMP_ID') and len(MANAGER_3_EMP_ID) and isdefined('MANAGER_3_POS_NAME') and len(MANAGER_3_POS_NAME) and session.ep.userid eq MANAGER_3_EMP_ID>
			MANAGER3_POINT = #puan#,
			MANAGER3_POINT_OVER_5 = #user_point_over_5#,
			</cfif>
			USER_POINT = #puan#,
			USER_POINT_OVER_5 = #user_point_over_5#,
		<cfelse>
			<cfif session.ep.userid eq attributes.emp_id>
			EMP_POINT = NULL,
			EMP_POINT_OVER_5 = NULL,
			<cfelseif len(amir_onay) and amir_onay is 1 and get_quiz_info.form_open_type eq 1 and isdefined('MANAGER_1_EMP_ID') and len(MANAGER_1_EMP_ID) and isdefined('MANAGER_1_POS_NAME') and len(MANAGER_1_POS_NAME) and session.ep.userid eq MANAGER_1_EMP_ID>
			MAN_EMP_POINT = NULL,
			MAN_EMP_POINT_OVER_5 = NULL,
			<cfelseif isdefined('MANAGER_1_EMP_ID') and len(MANAGER_1_EMP_ID) and isdefined('MANAGER_1_POS_NAME') and len(MANAGER_1_POS_NAME) and session.ep.userid eq MANAGER_1_EMP_ID>
			MANAGER_POINT = NULL,
			MANAGER_POINT_OVER_5 = NULL,
			<cfelseif isdefined('MANAGER_3_EMP_ID') and len(MANAGER_3_EMP_ID) and isdefined('MANAGER_3_POS_NAME') and len(MANAGER_3_POS_NAME) and session.ep.userid eq MANAGER_3_EMP_ID>
			MANAGER3_POINT = NULL,
			MANAGER3_POINT_OVER_5 = NULL,
			</cfif>
			USER_POINT = NULL,
			USER_POINT_OVER_5 = NULL,
		</cfif>
			PERFORM_POINT_ID = #PERFORM_POINT_ID#,
			IS_PERF_SALARY_RESULTING = #IS_PERF_SALARY_RESULTING#,
		<cfif isdefined('valid1') and len(valid1)>
			VALID_1 = #valid1#,
			VALID_1_EMP = #session.ep.userid#,
			VALID_1_DATE = #now()#,
		</cfif>
		<cfif isdefined('valid2') and len(valid2)>
			VALID_2 = #valid2#,
			VALID_2_EMP = #session.ep.userid#,
			VALID_2_DATE = #now()#,
		</cfif>
		<cfif isdefined('valid3') and len(valid3)>
			VALID_3 = #valid3#,
			VALID_3_EMP = #session.ep.userid#,
			VALID_3_DATE = #now()#,
		</cfif>
		<cfif isdefined('valid') and len(valid)>
			VALID = #valid#,
		</cfif>
		<cfif isdefined('valid4') and len(valid4)>
			VALID_4 = #valid4#,
		</cfif>
			START_DATE = #attributes.start_date#,
			FINISH_DATE = #attributes.finish_date#,
			EVAL_DATE = #attributes.eval_date#,
		<cfif isdefined('attributes.record_type') and len(attributes.record_type)>
			RECORD_TYPE = #attributes.record_type#,
		<cfelse>
			RECORD_TYPE = NULL,
		</cfif>
		<cfif isdefined("attributes.emp_career_status") and len(attributes.emp_career_status)>
			EMP_CAREER_STATUS=#attributes.emp_career_status#,
		<cfelse>
			EMP_CAREER_STATUS=NULL,
		</cfif>
		<cfif isdefined("attributes.emp_career_exp")>EMP_CAREER_EXP='#attributes.emp_career_exp#',</cfif>
		<cfif isdefined("attributes.other_career_exp")>OTHER_CAREER_EXP='#attributes.other_career_exp#',</cfif>
		<cfif isdefined("attributes.manager_career_status") and len(attributes.manager_career_status)>
			MANAGER_CAREER_STATUS=#attributes.manager_career_status#,
		<cfelse>
			MANAGER_CAREER_STATUS=NULL,
		</cfif>
		<cfif isdefined("attributes.manager_3_career_status") and len(attributes.manager_3_career_status)>
			MANAGER_3_CAREER_STATUS=#attributes.manager_3_career_status#,
		<cfelse>
			MANAGER_3_CAREER_STATUS=NULL,
		</cfif>
		<cfif isdefined("attributes.manager_career_exp")>MANAGER_CAREER_EXP='#attributes.manager_career_exp#',</cfif>
		<cfif isdefined("attributes.manager_3_career_exp")>MANAGER_3_CAREER_EXP='#attributes.manager_3_career_exp#',</cfif>
		<cfif isdefined("attributes.emp_training_cat") and len(attributes.emp_training_cat)>
			EMP_TRAINING_CAT=',#attributes.emp_training_cat#,',
		<cfelse>
			EMP_TRAINING_CAT=NULL,
		</cfif>
		<cfif isdefined("attributes.emp_training_exp")>EMP_TRAINING_EXP='#attributes.emp_training_exp#',</cfif>
		<cfif isdefined("attributes.other_training_exp")>OTHER_TRAINING_EXP='#attributes.other_training_exp#',</cfif>
		<cfif isdefined("attributes.manager_training_cat") and len(attributes.manager_training_cat)>
			MANAGER_TRAINING_CAT = ',#attributes.manager_training_cat#,',
		<cfelse>
			MANAGER_TRAINING_CAT = NULL,
		</cfif>
		<cfif isdefined("attributes.manager_3_training_cat") and len(attributes.manager_3_training_cat)>
			MANAGER_3_TRAINING_CAT = ',#attributes.manager_3_training_cat#,',
		<cfelse>
			MANAGER_3_TRAINING_CAT = NULL,
		</cfif>
		<cfif isdefined("attributes.manager_training_exp")>MANAGER_TRAINING_EXP='#attributes.manager_training_exp#',</cfif>
		<cfif isdefined("attributes.manager_3_training_exp")>MANAGER_3_TRAINING_EXP='#attributes.manager_3_training_exp#',</cfif>
		HR_INFO = '#attributes.hr_info#',
		HR_CAREER_INFO  = '#attributes.hr_career_info#',
		
		<cfif isdefined("attributes.manager_career_status") and listfindnocase('3,4,5',attributes.manager_career_status)>
			POSITION_CAT_ID_1 = <cfif isdefined("attributes.POSITION_CAT_ID_1") and len(attributes.POSITION_CAT_ID_1)>#attributes.POSITION_CAT_ID_1#<cfelse>NULL</cfif>,
			POSITION_CAT_ID_2 = <cfif isdefined("attributes.POSITION_CAT_ID_2") and len(attributes.POSITION_CAT_ID_2)>#attributes.POSITION_CAT_ID_2#<cfelse>NULL</cfif>,
			POSITION_CAT_ID_3 = <cfif isdefined("attributes.POSITION_CAT_ID_3") and len(attributes.POSITION_CAT_ID_3)>#attributes.POSITION_CAT_ID_3#<cfelse>NULL</cfif>,
		<cfelse>
			POSITION_CAT_ID_1 = NULL,
			POSITION_CAT_ID_2 = NULL,
			POSITION_CAT_ID_3 = NULL,
		</cfif>
		
		UPDATE_KEY = '#SESSION.EP.USERKEY#',
			UPDATE_IP = '#CGI.REMOTE_ADDR#',
			UPDATE_DATE = #now()#,
			PER_STAGE = <cfif len(attributes.process_stage)>#attributes.process_stage#<cfelse>NULL</cfif>
		WHERE
			PER_ID = #attributes.PER_ID#
	</cfquery>
</cfif>
<cflocation url="#cgi.HTTP_REFERER#" addtoken="no">
