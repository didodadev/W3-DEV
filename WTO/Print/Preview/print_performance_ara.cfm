<cf_get_lang_set module_name="hr"><!--- sayfanin en altinda kapanisi var --->
<cfset attributes.per_id = attributes.iid>
<cfquery name="GET_PERF_DETAIL" datasource="#dsn#">
	SELECT 
		EMPLOYEE_PERFORMANCE.*,
		EMPLOYEE_QUIZ_RESULTS.QUIZ_ID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
	FROM 
		EMPLOYEE_PERFORMANCE,
		EMPLOYEE_QUIZ_RESULTS,
		EMPLOYEES
	WHERE
		EMPLOYEE_PERFORMANCE.PER_ID = #attributes.PER_ID# AND
		EMPLOYEE_PERFORMANCE.RESULT_ID = EMPLOYEE_QUIZ_RESULTS.RESULT_ID AND
		EMPLOYEE_PERFORMANCE.EMP_ID = EMPLOYEES.EMPLOYEE_ID 
</cfquery>
<cfif len(GET_PERF_DETAIL.MANAGER_1_EMP_ID)>
	<cfquery name="GET_EMP_MANG_1" datasource="#dsn#">
		SELECT 
			EMPLOYEE_ID,POSITION_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME
		FROM 
			EMPLOYEE_POSITIONS
		WHERE
			EMPLOYEE_ID = #GET_PERF_DETAIL.MANAGER_1_EMP_ID# 
	</cfquery>
</cfif>
<cfif len(GET_PERF_DETAIL.MANAGER_2_EMP_ID)>
	<cfquery name="GET_EMP_MANG_2" datasource="#dsn#">
		SELECT 
			EMPLOYEE_ID, POSITION_ID, EMPLOYEE_NAME, EMPLOYEE_SURNAME
		FROM 
			EMPLOYEE_POSITIONS
		WHERE
			EMPLOYEE_ID = #GET_PERF_DETAIL.MANAGER_2_EMP_ID# 
	</cfquery>
</cfif>
<cfif len(GET_PERF_DETAIL.MANAGER_3_EMP_ID)>
	<cfquery name="GET_EMP_MANG_3" datasource="#dsn#">
		SELECT 
			EMPLOYEE_ID, POSITION_ID, EMPLOYEE_NAME, EMPLOYEE_SURNAME
		FROM 
			EMPLOYEE_POSITIONS
		WHERE
			EMPLOYEE_ID = #GET_PERF_DETAIL.MANAGER_3_EMP_ID# 
	</cfquery>
</cfif>
<cfscript>
	attributes.emp_id = get_perf_detail.emp_id;
	attributes.employee_id = get_perf_detail.emp_id;
	attributes.quiz_id = get_perf_detail.quiz_id;
	quiz_id = get_perf_detail.quiz_id;
	attributes.position_name = get_perf_detail.EMP_POSITION_NAME;
	attributes.employee_name = get_perf_detail.employee_name;
	attributes.employee_surname = get_perf_detail.employee_surname;
</cfscript>
<cfquery name="GET_QUIZ_INFO" datasource="#dsn#">
	SELECT 
		QUIZ_HEAD,
		IS_EXTRA_RECORD,
		IS_EXTRA_RECORD_EMP,
		IS_RECORD_TYPE,
		IS_VIEW_QUESTION,
		IS_EXTRA_QUIZ,
		IS_MANAGER_1,
		IS_MANAGER_2,
		IS_MANAGER_3,
		IS_CAREER,
		IS_TRAINING,
		IS_OPINION,
		FORM_OPEN_TYPE
	FROM 
		EMPLOYEE_QUIZ
	WHERE
		QUIZ_ID=#attributes.QUIZ_ID#
</cfquery>
<cf_date tarih='attributes.start_date'>
<cf_date tarih='attributes.finish_date'>
<cfquery name="GET_EMP_QUIZ_ANSWERS" datasource="#dsn#">
	SELECT 
		<!--- EMPLOYEE_QUIZ_RESULTS_DETAILS.*, ---> 
		EQD.RESULT_DETAIL_ID,
		EQD.RESULT_ID,
		EQD.QUESTION_ID,
		<cfif session.ep.userid eq attributes.emp_id>
		EQD.EMP_GD AS GD,
		EQD.QUESTION_EMP_ANSWERS AS QUESTION_USER_ANSWERS,
		<cfelseif len(get_perf_detail.manager_1_emp_id) and session.ep.userid eq get_perf_detail.manager_1_emp_id and get_perf_detail.valid_1 neq 1>
		EQD.MANAGER1_GD AS GD,
		EQD.QUESTION_MANAGER1_ANSWERS AS QUESTION_USER_ANSWERS,
		<cfelseif len(get_perf_detail.manager_1_emp_id) and session.ep.userid eq get_perf_detail.manager_1_emp_id and get_perf_detail.valid_1 eq 1 and get_perf_detail.valid_4 neq 1>
		EQD.MAN_EMP_GD AS GD,
		EQD.QUESTION_MAN_EMP_ANSWERS AS QUESTION_USER_ANSWERS,
		<cfelseif len(get_perf_detail.manager_2_emp_id) and session.ep.userid eq get_perf_detail.manager_2_emp_id and get_perf_detail.valid_2 eq 1>
		EQD.MANAGER2_GD AS GD,
		EQD.QUESTION_MANAGER2_ANSWERS AS QUESTION_USER_ANSWERS,
		<cfelseif len(get_perf_detail.manager_3_emp_id) and session.ep.userid eq get_perf_detail.manager_3_emp_id>
		EQD.MANAGER3_GD AS GD,
		EQD.QUESTION_MANAGER3_ANSWERS AS QUESTION_USER_ANSWERS,
		<cfelse>
		EQD.GD,
		EQD.QUESTION_USER_ANSWERS,
		</cfif>
		EQD.EMP_GD AS CALISAN_GD,
		EQD.QUESTION_EMP_ANSWERS AS CALISAN_ANSWERS,
		EQD.MANAGER1_GD AS MANAGER1_GD,
		EQD.QUESTION_MANAGER1_ANSWERS AS MANAGER1_ANSWERS,
		EQD.MAN_EMP_GD AS MAN_EMP_GD,
		EQD.QUESTION_MAN_EMP_ANSWERS AS MAN_EMP_ANSWERS,
		EQD.MANAGER2_GD AS MANAGER2_GD,
		EQD.QUESTION_MANAGER2_ANSWERS AS MANAGER2_ANSWERS,
		EQD.MANAGER3_GD AS MANAGER3_GD,
		EQD.QUESTION_MANAGER3_ANSWERS AS MANAGER3_ANSWERS,
		EMPLOYEE_QUIZ_RESULTS.USER_POINT
	FROM 
		EMPLOYEE_QUIZ_RESULTS_DETAILS EQD, 
		EMPLOYEE_QUIZ_RESULTS
	WHERE
		EQD.RESULT_ID = EMPLOYEE_QUIZ_RESULTS.RESULT_ID AND
		EQD.RESULT_ID = #GET_PERF_DETAIL.RESULT_ID#
</cfquery>
<cfset chapter_not_gd='1205,1206,1207,1208,1201,1202,1203,1204,1193,1194,1195,1196,1189,1190,1191,1192,1169,1170,1171,1172,1197,1198,1199,1200,1182,1183,1184,1186,1178,1179,1180,1185'>
<table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td class="headbold"><cf_get_lang no='115.Form'>: <cfoutput>#get_quiz_info.QUIZ_HEAD#</cfoutput></td>
		<td>&nbsp;</td>
	</tr>
</table>
<table width="98%" align="center" cellpadding="0" cellspacing="0">
<tr>
  <td valign="top">
	<table width="100%" cellspacing="0" cellpadding="0">
	  <tr class="color-border">
		<td>
		  <table width="100%" cellspacing="1" cellpadding="2">
			<tr class="color-row">
			  <td height="22" class="txtboldblue"><cf_get_lang_main no='217.Açıklama'>/<cf_get_lang no='858.Örnek Olaylar: Bekleneni Karşılıyor (3) dışında değerlendirdiğiniz davranış ifadeleri için Açıklama kısımlarını doldurunuz'></td>
			</tr>
			<tr>
			  <td class="color-row">
			  	<table>
				  <tr>
					<td width="100"><cf_get_lang_main no='164.Çalışan'> </td>
					<td width="200"><cfoutput>#attributes.employee_name# #attributes.employee_surname#</cfoutput></td>
					<cfif get_quiz_info.is_manager_1 is 1>
					<td width="100">1.<cf_get_lang no='407.Amir'></td>
					<td><cfif len(get_perf_detail.MANAGER_1_EMP_ID)><cfoutput>#GET_EMP_MANG_1.employee_name# #GET_EMP_MANG_1.employee_surname#</cfoutput></cfif></td>
					</cfif>
				  </tr>
				  <tr>
					<td><cf_get_lang no='18.Pozisyon'></td>
					<td><cfoutput>#attributes.position_name#</cfoutput></td>
					<cfif get_quiz_info.is_manager_2 is 1>
					<td>2.<cf_get_lang no='407.Amir'></td>
					<td><cfif len(get_perf_detail.MANAGER_2_EMP_ID)><cfoutput>#GET_EMP_MANG_2.employee_name# #GET_EMP_MANG_2.employee_surname#</cfoutput></cfif></td>
					</cfif>
				  </tr>
				  <tr>
					<td><cf_get_lang no='463.Dönem'> *</td>
					<td><cfoutput>#DateFormat(get_perf_detail.start_date,dateformat_style)#	- #DateFormat(get_perf_detail.finish_date,dateformat_style)#</cfoutput></td>
					<cfif get_quiz_info.is_manager_3 is 1>
					<td><cf_get_lang_main no='2111.Görüş Bildiren'></td>
					<td><cfif len(get_perf_detail.MANAGER_3_EMP_ID)><cfoutput>#GET_EMP_MANG_3.employee_name# #GET_EMP_MANG_3.employee_surname#</cfoutput></cfif></td>
					</cfif>
				  </tr>
				  <tr>
					<td><cf_get_lang no='859.Değerlendirme Tarihi'></td>
					<td><cfoutput>#DateFormat(get_perf_detail.eval_date,dateformat_style)#</cfoutput>
					<td><cf_get_lang no='1151.Kayıt tipi'></td>
					<td>
						<cfif get_perf_detail.record_type is 1><cf_get_lang no='930.Asıl'>
						<cfelseif get_perf_detail.record_type is 2><cf_get_lang no='931.Görüş'> 1
						<cfelseif get_perf_detail.record_type is 3><cf_get_lang no='931.Görüş'> 2
						<cfelseif get_perf_detail.record_type is 4><cf_get_lang no='1156.Ara Değerlendirme'>
						</cfif>
					</td>
				  </tr>
				  <tr>
					<td colspan="4">
						<cf_get_lang_main no='71.Kayıt'>: <cfoutput>#get_emp_info(ListLast(GET_PERF_DETAIL.RECORD_KEY,'-'),0,0)# #DateFormat(date_add('h',session.ep.time_zone,GET_PERF_DETAIL.RECORD_DATE),dateformat_style)# #TimeFormat(date_add('h',session.ep.time_zone,GET_PERF_DETAIL.RECORD_DATE),'HH:mm:ss')#</cfoutput>
						&nbsp;<cfif len(GET_PERF_DETAIL.UPDATE_KEY)>
						<cf_get_lang no='607.Güncelleme'>: 
						<cfoutput>#get_emp_info(ListLast(GET_PERF_DETAIL.UPDATE_KEY,'-'),0,0)# #DateFormat(date_add('h',session.ep.time_zone,GET_PERF_DETAIL.UPDATE_DATE),dateformat_style)# #TimeFormat(date_add('h',session.ep.time_zone,GET_PERF_DETAIL.UPDATE_DATE),'HH:mm:ss')#</cfoutput>
						</cfif>
					</td>
				  </tr>
				</table>
			  </td>
			</tr>
			<!--- seçilen form --->
			<cfquery name="GET_QUIZ_CHAPTERS" datasource="#dsn#">
				SELECT 
					*
				FROM 
					EMPLOYEE_QUIZ_CHAPTER
				WHERE
					QUIZ_ID=#attributes.QUIZ_ID#
			</cfquery>
			<cfif get_quiz_chapters.recordcount>
 				<cfoutput query="get_quiz_chapters">
					<cfset ANSWER_NUMBER_gelen = get_quiz_chapters.ANSWER_NUMBER>
					<cfset attributes.CHAPTER_ID = CHAPTER_ID>
					<cfquery name="chapter_exp_#get_quiz_chapters.currentrow#" datasource="#dsn#">
						SELECT EXPLANATION,MANAGER_EXPLANATION,EXPLANATION1,EXPLANATION2,EXPLANATION3,EXPLANATION4 FROM EMPLOYEE_QUIZ_CHAPTER_EXPL WHERE CHAPTER_ID=#CHAPTER_ID# AND RESULT_ID=<cfif isdefined('GET_PERF_DETAIL.RESULT_ID')and len(GET_PERF_DETAIL.RESULT_ID)>#GET_PERF_DETAIL.RESULT_ID#<cfelse>#GET_APP_PERF_DETAIL.RESULT_ID#</cfif>
					</cfquery>
					<cfscript>
						for (i=1; i lte 20; i = i+1)
						{
							"a#i#" = evaluate("get_quiz_chapters.answer#i#_text");
							"b#i#" = evaluate("get_quiz_chapters.answer#i#_photo");
							"c#i#" = evaluate("get_quiz_chapters.answer#i#_point");
						}
					</cfscript>
					<tr class="color-list">
					   <td>
						  <table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr height="20">
							  <td class="txtboldblue"> <cf_get_lang no='202.Bölüm'> #get_quiz_chapters.currentrow#: #chapter# </td>
							</tr>
							<cfif len(chapter_info)>
							  <tr height="20" class="color-list">
								<td>#chapter_info# </td>
							  </tr>
							</cfif>
						  </table>
					   </td>
					</tr>
					<tr class="color-row">
				 	  <td>
						  <table width="100%" cellpadding="0" cellspacing="0">
							<cfquery name="GET_QUIZ_QUESTIONS" datasource="#dsn#">
								SELECT 
									*
								FROM 
									EMPLOYEE_QUIZ_QUESTION
								WHERE
									CHAPTER_ID=#attributes.CHAPTER_ID#
							</cfquery>
							<cfif get_quiz_questions.recordcount>
							  <cfif not listfind(chapter_not_gd,attributes.CHAPTER_ID,',')>
							  <tr class="color-row">
								<td>
								  <table border="0">
									<tr class="color-list" align="center">
										<td></td>
										<td width="30">&nbsp;</td>
									</tr>
									<!--- Sorular basliyor --->
									<cfloop query="get_quiz_questions">
									  <cfset q_id = get_quiz_questions.QUESTION_ID>
									  <tr class="color-list" height="20">
										<td class="txtbold"><cfif get_quiz_info.IS_VIEW_QUESTION is 1>#get_quiz_questions.currentrow#-#get_quiz_questions.question#<cfelse>D-#get_quiz_questions.currentrow#</cfif></td>
										<cfif ANSWER_NUMBER_gelen neq 0>
											<cfloop from="1" to="20" index="i">
											  <cfif len(evaluate("b#i#")) or len(evaluate("a#i#"))>
												<td  align="center">
													<cfloop query="GET_EMP_QUIZ_ANSWERS">
														<cfif IsDefined("GET_EMP_QUIZ_ANSWERS") and IsDefined("GET_EMP_QUIZ_ANSWERS.RESULT_ID") and GET_EMP_QUIZ_ANSWERS.QUESTION_ID IS q_id and GET_EMP_QUIZ_ANSWERS.QUESTION_USER_ANSWERS is i> * </cfif>
													</cfloop>
												</td>
											  </cfif>
											</cfloop>
											<td width="30">&nbsp;</td>
									 	 </tr>
									  <cfelse>
									  <td></td>
									  </tr>
									  <cfloop from="1" to="20" index="i">
										<cfif len(evaluate("get_quiz_questions.answer#i#_photo")) or len(evaluate("get_quiz_questions.answer#i#_text"))>
										  <tr class="color-list">
											<td align="center"><!--- GD ---><cf_get_lang no="785.Gözlemlenemedi"></td>
											<td>
												<cfloop query="GET_EMP_QUIZ_ANSWERS">
													<cfif isdefined("GET_EMP_QUIZ_ANSWERS") and	isdefined("GET_EMP_QUIZ_ANSWERS.RESULT_ID") and	GET_EMP_QUIZ_ANSWERS.QUESTION_ID IS q_id>
														#GET_EMP_QUIZ_ANSWERS.QUESTION_USER_ANSWERS#
													</cfif>
												</cfloop>
												<cfif len(evaluate("answer"&i&"_photo"))>
													<cf_get_server_file output_file="hr/#evaluate("get_quiz_questions.answer"&i&"_photo")#" output_server="#evaluate("get_quiz_questions.answer"&i&"_photo_server_id")#" output_type="0"  image_link="1">
												</cfif>
												#evaluate('get_quiz_questions.answer#i#_text')#<br/>
											</td>
										  </tr>
										</cfif>
									  </cfloop>
									  </cfif>
									  <cfif len(question_info)>
										<tr height="20">
										  <td colspan="11"> #get_quiz_questions.question_info#</td>
										</tr>
									  </cfif>
									</cfloop>
									</cfif>
									<cfset gorus = 0>
									<cfif (attributes.emp_id eq session.ep.userid and get_quiz_chapters.is_emp_exp1 neq 1) or (get_perf_detail.manager_3_emp_id eq session.ep.userid and get_quiz_chapters.is_chief3_exp1 neq 1) or (get_perf_detail.manager_1_emp_id eq session.ep.userid and get_quiz_chapters.is_chief1_exp1 neq 1) or (get_perf_detail.manager_2_emp_id eq session.ep.userid and get_quiz_chapters.is_chief2_exp1 neq 1) or (session.ep.userid neq attributes.emp_id and get_perf_detail.manager_1_emp_id neq session.ep.userid and get_perf_detail.manager_3_emp_id neq session.ep.userid and get_perf_detail.manager_2_emp_id neq session.ep.userid)>
										<cfif session.ep.userid neq get_perf_detail.manager_3_emp_id and get_quiz_chapters.is_emp_exp1 eq 1 and get_quiz_chapters.is_chief1_exp1 eq 1 and get_quiz_chapters.is_chief2_exp1 eq 1 and get_quiz_chapters.is_chief3_exp1 neq 1>
											<cfset gorus = 1>
										</cfif>
										<cfif (get_quiz_chapters.is_exp1 eq 1) and len(get_quiz_chapters.exp1_name) and gorus neq 1>
										<tr>
											<td colspan="11" valign="top">#get_quiz_chapters.exp1_name#&nbsp;</td>
										</tr>
										<tr>
											<td colspan="11" valign="top">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.EXPLANATION1")#</td>
										</tr>
										</cfif>
									</cfif>
									<cfif (attributes.emp_id eq session.ep.userid and get_quiz_chapters.is_emp_exp2 neq 1) or (get_perf_detail.manager_3_emp_id eq session.ep.userid and get_quiz_chapters.is_chief3_exp2 neq 1) or (get_perf_detail.manager_1_emp_id eq session.ep.userid and get_quiz_chapters.is_chief1_exp2 neq 1) or (get_perf_detail.manager_2_emp_id eq session.ep.userid and get_quiz_chapters.is_chief2_exp2 neq 1) or (session.ep.userid neq attributes.emp_id and get_perf_detail.manager_1_emp_id neq session.ep.userid and get_perf_detail.manager_3_emp_id neq session.ep.userid and get_perf_detail.manager_2_emp_id neq session.ep.userid)>
										<cfif  session.ep.userid neq get_perf_detail.manager_3_emp_id and get_quiz_chapters.is_emp_exp2 eq 1 and get_quiz_chapters.is_chief1_exp2 eq 1 and get_quiz_chapters.is_chief2_exp2 eq 1 and get_quiz_chapters.is_chief3_exp2 neq 1>
											<cfset gorus = 1>
										</cfif>
										<cfif (get_quiz_chapters.is_exp2 eq 1) and len(get_quiz_chapters.exp2_name) and gorus neq 1>
										<tr>
											<td colspan="11" valign="top">#get_quiz_chapters.exp2_name#&nbsp;</td>
										</tr>
										<tr>
											<td colspan="11" valign="top">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.EXPLANATION2")#</td>
										</tr>
										</cfif>
									</cfif>
									<cfif (attributes.emp_id eq session.ep.userid and get_quiz_chapters.is_emp_exp3 neq 1) or (get_perf_detail.manager_3_emp_id eq session.ep.userid and get_quiz_chapters.is_chief3_exp3 neq 1) or (get_perf_detail.manager_1_emp_id eq session.ep.userid and get_quiz_chapters.is_chief1_exp3 neq 1) or (get_perf_detail.manager_2_emp_id eq session.ep.userid and get_quiz_chapters.is_chief2_exp3 neq 1) or (session.ep.userid neq attributes.emp_id and get_perf_detail.manager_1_emp_id neq session.ep.userid and get_perf_detail.manager_3_emp_id neq session.ep.userid and get_perf_detail.manager_2_emp_id neq session.ep.userid)>
										<cfif  session.ep.userid neq get_perf_detail.manager_3_emp_id and get_quiz_chapters.is_emp_exp3 eq 1 and get_quiz_chapters.is_chief1_exp3 eq 1 and get_quiz_chapters.is_chief2_exp3 eq 1 and get_quiz_chapters.is_chief3_exp3 neq 1>
											<cfset gorus = 1>
										</cfif>
										<cfif (get_quiz_chapters.is_exp3 eq 1) and len(get_quiz_chapters.exp3_name) and gorus neq 1>
										<tr>
											<td colspan="11" valign="top">#get_quiz_chapters.exp3_name#&nbsp;</td>
										</tr>
										<tr>
											<td colspan="11" valign="top">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.EXPLANATION3")#</td>
										</tr>
										</cfif>
									</cfif>
									<cfif (attributes.emp_id eq session.ep.userid and get_quiz_chapters.is_emp_exp4 neq 1) or (get_perf_detail.manager_3_emp_id eq session.ep.userid and get_quiz_chapters.is_chief3_exp4 neq 1) or (get_perf_detail.manager_1_emp_id eq session.ep.userid and get_quiz_chapters.is_chief1_exp4 neq 1) or (get_perf_detail.manager_2_emp_id eq session.ep.userid and get_quiz_chapters.is_chief2_exp4 neq 1) or (session.ep.userid neq attributes.emp_id and get_perf_detail.manager_1_emp_id neq session.ep.userid and get_perf_detail.manager_3_emp_id neq session.ep.userid and get_perf_detail.manager_2_emp_id neq session.ep.userid)>
										<cfif  session.ep.userid neq get_perf_detail.manager_3_emp_id and get_quiz_chapters.is_emp_exp4 eq 1 and get_quiz_chapters.is_chief1_exp4 eq 1 and get_quiz_chapters.is_chief2_exp4 eq 1 and get_quiz_chapters.is_chief3_exp4 neq 1>
											<cfset gorus = 1>
										</cfif>
										<cfif (get_quiz_chapters.is_exp4 eq 1) and len(get_quiz_chapters.exp4_name) and gorus neq 1>
										<tr>
											<td colspan="11" valign="top">#get_quiz_chapters.exp4_name#&nbsp;</td>
										</tr>
										<tr>
											<td colspan="11" valign="top">#EVALUATE("chapter_exp_#get_quiz_chapters.currentrow#.EXPLANATION4")#</td>
										</tr>
										</cfif>
									</cfif>
								  </table>
								</td>
							  </tr>
						  </table>
				        </td>
				    </tr>
				  <cfelse>
				  <tr height="20" class="color-row">
					<td><cf_get_lang no='744.Kayıtlı Soru Bulunamadı!'></td>
				  </tr>
				</cfoutput>
			</cfif>
				
			<cfelse>
				<tr height="20" class="color-row">
				  <td><cf_get_lang no='745.Kayıtlı Bölüm Bulunamadı!'></td>
				</tr>
			</cfif>
			<!--- görüşler --->
			<cfif get_quiz_info.is_opinion is 1>
			<tr class="color-list" height="22">
			  <td height="22" class="txtboldblue"><cf_get_lang no='442.Genel Görüşler'></td>
			</tr>
			<tr>
			  <td class="color-row">
				<table>
				  <cfif get_perf_detail.manager_3_emp_id neq session.ep.userid>
				  <tr>
					<td><cf_get_lang no='1225.Birinci Değerlendirme Yöneticisinin Görüş ve Düşünceleri'></td>
				  </tr>
				  <tr>
					<td><cfoutput>#get_perf_detail.POWERFUL_ASPECTS#</cfoutput></td>
				  </tr>
				  </cfif>
				  <cfif get_perf_detail.manager_3_emp_id neq session.ep.userid>
				  <tr>
					<td><cf_get_lang no='1226.ikinci Değerlendirme Yöneticisinin Görüş ve Düşünceleri'></td>
				  </tr>
				  <tr>
					<td><cfoutput>#get_perf_detail.MANAGER_2_EVALUATION#</cfoutput></td>
				  </tr>
				  </cfif>
				  <cfif get_perf_detail.MANAGER_3_EMP_ID eq session.ep.userid>
				  <tr>
					<td><cf_get_lang no='1631.Görüş Bildirenin Görüş ve Düşünceleri'></td>
				  </tr>
				  <tr>
					<td><cfoutput>#get_perf_detail.MANAGER_3_EVALUATION#</cfoutput></td>
				  </tr>
				  </cfif>
				  <cfif get_quiz_info.form_open_type neq 2>
				  <cfif get_perf_detail.manager_3_emp_id neq session.ep.userid>
				  <tr>
					<td><cf_get_lang no='1224.Çalışanın Görüş ve Düşünceleri'></td>
				  </tr>
				  <tr>
					<td><cfoutput>#get_perf_detail.EMPLOYEE_OPINION#</cfoutput></td>
				  </tr>
				  </cfif>
				  </cfif>
				  <cfif get_quiz_info.form_open_type neq 2>
				  <cfif get_perf_detail.manager_3_emp_id neq session.ep.userid>
				  <tr>
					<td><cfif get_perf_detail.EMPLOYEE_OPINION_ID is 1><cf_get_lang no='458.Değerlendirmeye Katılıyorum'><cfelseif get_perf_detail.EMPLOYEE_OPINION_ID is 0><cf_get_lang no='459.Değerlendirmeye Katılmıyorum'></cfif></td>
				  </tr>
				  </cfif>
				  </cfif>
				</table>
			  </td>
			</tr>
			</cfif>
			<!--- görüşler Bitti --->
			<cfif get_quiz_info.is_career is 1>
			<tr class="color-list" height="22">
				<td height="22" class="txtboldblue"><cf_get_lang no='1632.Kariyer Durumu'></td>
			</tr>
			<tr>
				<td class="color-row">
					<table id="b_carrer">
						<tr align="center" class="color-list">
							<cfif get_quiz_info.form_open_type neq 2 and get_perf_detail.manager_3_emp_id neq session.ep.userid>
							<td class="txtboldblue"><cf_get_lang_main no='164.Çalışan'></td>
							<td>
							  <cfif get_perf_detail.emp_career_status eq 1><cf_get_lang no='1633.Bir Üst Görev İçin Uygun Değildir'>
							  <cfelseif get_perf_detail.emp_career_status eq 2><cf_get_lang no='1634.Bir Üst Görev İçin Henüz Yetişmektedir'>
							  <cfelseif get_perf_detail.emp_career_status eq 3><cf_get_lang no='1635.Bir Üst Görev İçin Yetişmiştir'>
							  <cfelseif get_perf_detail.emp_career_status eq 4><cf_get_lang no='1636.Bir Üst Göreve Yükseltilebilir'>
							  <cfelseif get_perf_detail.emp_career_status eq 5><cf_get_lang no='1637.Bir Üst Göreve Yükseltilmesi Gereklidir'>
							  </cfif>		
							</td>
							</cfif>
							<cfif get_perf_detail.manager_3_emp_id neq session.ep.userid>
							<td class="txtboldblue"><cf_get_lang_main no='1714.Yönetici'></td>
							<td>
							  <cfif get_perf_detail.manager_career_status eq 1><cf_get_lang no='1633.Bir Üst Görev İçin Uygun Değildir'>
							  <cfelseif get_perf_detail.manager_career_status eq 2><cf_get_lang no='1634.Bir Üst Görev İçin Henüz Yetişmektedir'>	
							  <cfelseif get_perf_detail.manager_career_status eq 3><cf_get_lang no='1635.Bir Üst Görev İçin Yetişmiştir'>
							  <cfelseif get_perf_detail.manager_career_status eq 4><cf_get_lang no='1636.Bir Üst Göreve Yükseltilebilir'>
							  <cfelseif get_perf_detail.manager_career_status eq 5><cf_get_lang no='1637.Bir Üst Göreve Yükseltilmesi Gereklidir'>
							  </cfif>		
							</td>
							</cfif>
						</tr>
						<tr class="color-list">
							<td class="txtboldblue"><cf_get_lang_main no='744.Diğer'></td>
							<td colspan="10"><cfoutput>#get_perf_detail.other_career_exp#</cfoutput></td>
						</tr>
						<cfif get_quiz_info.form_open_type neq 2 and get_perf_detail.manager_3_emp_id neq session.ep.userid>
						<tr class="color-list">
							<td class="txtboldblue"><cf_get_lang no='1673.Çalışan Açıklama'></td>
							<td colspan="10"><cfoutput>#get_perf_detail.emp_career_exp#</cfoutput></td>
						</tr>
						</cfif>
						<cfif get_perf_detail.manager_3_emp_id eq session.ep.userid>
						<tr class="color-list">
							<td class="txtboldblue"><cf_get_lang no='1638.Görüş Bildiren Açıklama'></td>
							<td colspan="10"><cfoutput>#get_perf_detail.manager_3_career_exp#</cfoutput></td>
						</tr>
						</cfif>
						<cfif get_perf_detail.manager_3_emp_id neq session.ep.userid>
						<tr class="color-list">
							<td class="txtboldblue"><cf_get_lang no='1674.Yönetici Açıklama'></td>
							<td colspan="10"><cfoutput>#get_perf_detail.manager_career_exp#</cfoutput></td>
						</tr>
						</cfif>
					</table>
				</td>
			</tr>
			</cfif>
			<cfif get_quiz_info.is_training is 1>
			<tr class="color-list" height="22"  onClick="gizle_goster(b_gelisim);" style="cursor:pointer;">
				<td height="22" class="txtboldblue"><cf_get_lang no='1374.Gelişim'></td>
			</tr>
			<tr>
				<td class="color-row">
				<cfquery name="get_training_cat" datasource="#dsn#">
					SELECT TRAINING_CAT_ID,TRAINING_CAT FROM TRAINING_CAT
				</cfquery>
					<table id="b_gelisim">
						<tr class="color-list">
							<td class="txtbold"><cf_get_lang_main no='2115.Eğitimler'></td>
							<cfif get_quiz_info.form_open_type neq 2 and get_perf_detail.manager_3_emp_id neq session.ep.userid><td class="txtbold" align="center"><cf_get_lang_main no='164.Çalışan'></td></cfif>
							<cfif get_perf_detail.manager_3_emp_id neq session.ep.userid><td class="txtbold" align="center"><cf_get_lang_main no='1714.Yönetici'></td></cfif>
							<cfif get_perf_detail.manager_3_emp_id eq session.ep.userid><td class="txtbold" align="center"><cf_get_lang_main no='2111.Görüş Bildiren'></td></cfif>
						</tr>
						<cfoutput query="get_training_cat">
						<tr class="color-list">
							<td class="txtboldblue">#get_training_cat.training_cat#</td>
							<cfif get_quiz_info.form_open_type neq 2 and get_perf_detail.manager_3_emp_id neq session.ep.userid><td align="center"><cfif listfind(get_perf_detail.emp_training_cat,get_training_cat.training_cat_id,',')>*</cfif></td></cfif>
							<cfif get_perf_detail.manager_3_emp_id neq session.ep.userid><td align="center"><cfif listfind(get_perf_detail.manager_training_cat,get_training_cat.training_cat_id,',')>*</cfif></td></cfif>
							<cfif get_perf_detail.manager_3_emp_id eq session.ep.userid><td align="center"><cfif listfind(get_perf_detail.manager_3_training_cat,get_training_cat.training_cat_id,',')>*</cfif></td></cfif>
						</tr>
						</cfoutput>
						<tr class="color-list">
							<td class="txtboldblue"><cf_get_lang_main no='744.Diğer'></td>
							<td colspan="2"><cfoutput>#get_perf_detail.other_training_exp#</cfoutput></td>
						</tr>
						<cfif get_quiz_info.form_open_type neq 2 and get_perf_detail.manager_3_emp_id neq session.ep.userid>
						<tr class="color-list">
							<td class="txtboldblue"><cf_get_lang no='1673.Çalışan Açıklama'></td>
							<td colspan="2"><cfoutput>#get_perf_detail.emp_training_exp#</cfoutput></td>
						</tr>
						</cfif>
						<cfif get_perf_detail.manager_3_emp_id eq session.ep.userid>
						<tr class="color-list">
							<td class="txtboldblue"><cf_get_lang no='1638.Görüş Bildiren Açıklama'></td>
							<td colspan="2"><cfoutput>#get_perf_detail.manager_3_training_exp#</cfoutput></td>
						</tr>
						</cfif>
						<cfif get_perf_detail.manager_3_emp_id neq session.ep.userid>
						<tr class="color-list">
							<td class="txtboldblue"><cf_get_lang no='1674.Yönetici Açıklama'></td>
							<td colspan="2"><cfoutput>#get_perf_detail.manager_training_exp#</cfoutput></td>
						</tr>
						</cfif>
					</table>
				</td>
			</tr>
			</cfif>
			<cfif not isdefined("attributes.is_myhome") and not isdefined("attributes.is_no_point")>
				<tr class="color-header" height="22">
				  <td height="22" class="form-title"><cf_get_lang no='447.Genel Değerlendirme (İK Departmanı)'></td>
				</tr>
				<tr class="color-header" height="22">
				  <td valign="top" class="color-row">
					<table width="320">
					  <tr>
						<td><cf_get_lang no='448.Kişinin Aldığı Puan / Toplam Puan'></td>
						<td>
							<cfif not len(get_perf_detail.USER_POINT)><cfset get_perf_detail.USER_POINT=0></cfif>
						  <cfoutput>#wrk_round(get_perf_detail.USER_POINT)# / #get_perf_detail.perform_point#</cfoutput>
						</td> 
					  </tr>
						<cfif get_quiz_info.is_extra_record_emp is 1>
						  <tr>
							<td><cf_get_lang no='1683.Çalışandan Aldığı Puan'> / <cf_get_lang_main no='1573.Toplam Puan'></td>
							<td>
							  <cfif not len(get_perf_detail.emp_point)><cfset get_perf_detail.emp_point=0></cfif>
							  <cfoutput>#wrk_round(get_perf_detail.emp_point)# / #get_perf_detail.emp_perform_point#</cfoutput>
							</td> 
						  </tr>
					   </cfif>
					   <cfif get_quiz_info.is_extra_record is 1>
						  <tr>
							<td><cf_get_lang no='1685.Yöneticiden Aldığı Puan'> / <cf_get_lang_main no='1573.Toplam Puan'></td>
							<td>
							  <cfif not len(get_perf_detail.manager_point)><cfset get_perf_detail.manager_point=0></cfif>
							  <cfoutput>#wrk_round(get_perf_detail.manager_point)# / #get_perf_detail.emp_perform_point#</cfoutput>
							</td> 
						  </tr>
					  </cfif>
					  <cfif isnumeric(get_perf_detail.USER_POINT) and isnumeric(get_perf_detail.perform_point)>
						  <tr>
							<td><cf_get_lang no='861.Kişinin Aldığı Değerlendirme Puanı'><!---  (5 üzerinden) ---></td>
							<td><strong>(<cfoutput>#get_perf_detail.USER_POINT_OVER_5#</cfoutput> / 5)</strong></td>
						  </tr>
					  </cfif>
					  <cfif get_quiz_info.is_extra_record_emp is 1>
						  <cfif isnumeric(get_perf_detail.emp_point) and isnumeric(get_perf_detail.perform_point)>
							  <tr>
								<td><cf_get_lang no='1686.Çalışandan Aldığı Değerlendirme Puanı'><!---  (5 üzerinden) ---></td>
								<td><strong>(<cfoutput>#get_perf_detail.emp_point_over_5#</cfoutput> / 5)</strong></td>
							  </tr>
						  </cfif>
					  </cfif>
					  <cfif get_quiz_info.is_extra_record is 1>
						 <cfif isnumeric(get_perf_detail.manager_point) and isnumeric(get_perf_detail.perform_point)>
							  <tr>
								<td><cf_get_lang no='1687.'><cf_get_lang no='1687.Yöneticiden Aldığı Değerlendirme Puanı'><!---  (5 üzerinden) ---></td>
								  <td><strong>(<cfoutput>#get_perf_detail.manager_point_over_5#</cfoutput> / 5)</strong></td>
							  </tr>
						  </cfif>
					  </cfif>
					</table>
				  </td>
				</tr>
			</cfif>
			<tr class="color-row">
				<td>
					<table width="320">
						<tr>
							<td><strong><cf_get_lang_main no='164.Çalışan'></strong><br/><cf_get_lang_main no='1545.İmza'></td>
							<td><strong>1.<cf_get_lang_main no='1869.Amir'></strong><br/><cf_get_lang_main no='1545.İmza'></td>
						</tr>
						<tr height="25">
							<td></td>
						</tr>
					</table>
				</td>
			</tr>
           </table>
        </td>
      </tr>
    </table>
   </td>
</tr>
</table>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
