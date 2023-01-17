<!--- Analiz Sablonu --->
<style>
	.txtbold {font-weight:bold;}
</style>
<cfset attributes.result_id = attributes.action_row_id>
<cfset attributes.survey_id = attributes.action_id>
<cfquery name="get_survey_main" datasource="#dsn#">
	SELECT 
		TYPE,
		SURVEY_MAIN_HEAD,
		SURVEY_MAIN_DETAILS, 
		AVERAGE_SCORE, 
		TOTAL_SCORE,
		PROCESS_ID,
		IS_MANAGER_0,
		IS_MANAGER_1,
		IS_MANAGER_2,
		IS_MANAGER_3,
		IS_MANAGER_4,
		EMP_QUIZ_WEIGHT,
		MANAGER_QUIZ_WEIGHT_1,
		MANAGER_QUIZ_WEIGHT_2,
		MANAGER_QUIZ_WEIGHT_3,
		MANAGER_QUIZ_WEIGHT_4,
		IS_SELECTED_ATTENDER,
        IS_NOT_SHOW_SAVED
	FROM 
		SURVEY_MAIN 
	WHERE 
		SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
</cfquery>
<!--- Doldurulacak anketin, bilgilerini getirir --->
<cfquery name="get_survey_info" datasource="#dsn#">
	SELECT
		SC.SURVEY_CHAPTER_ID,
		SC.SURVEY_CHAPTER_HEAD,
		SC.SURVEY_CHAPTER_DETAIL,
		SC.IS_CHAPTER_DETAIL2,
		SC.SURVEY_CHAPTER_DETAIL2,
		SC.SURVEY_CHAPTER_WEIGHT,
		SC.IS_SHOW_GD,
		SQ.SURVEY_QUESTION_ID,
		SQ.QUESTION_HEAD,
		SQ.QUESTION_DETAIL,
		SQ.QUESTION_TYPE,
		SQ.QUESTION_DESIGN,
		SQ.QUESTION_IMAGE_PATH,
		SQ.IS_REQUIRED,
		SQ.IS_SHOW_GD AS QUESTION_GD
	FROM
		SURVEY_CHAPTER SC,
		SURVEY_QUESTION SQ
	WHERE
		SC.SURVEY_CHAPTER_ID = SQ.SURVEY_CHAPTER_ID AND
		SC.SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
	ORDER BY
		SC.SURVEY_CHAPTER_ID,
		SQ.SURVEY_QUESTION_ID
</cfquery><!--- İlgili anketin, bolum ve sorularini getirir, optionları loop edebilmek için kullanılır --->
<cfquery name="get_main_result_info" datasource="#dsn#">
	SELECT 
		PARTNER_ID,
		CONSUMER_ID,
		COMPANY_ID,
		EMP_ID,
		START_DATE,
		FINISH_DATE,
		COMMENT,
		PROCESS_ROW_ID,
		RESULT_NOTE,
		ACTION_TYPE,
		ACTION_ID,
		VALID,
		VALID1,
		VALID2,
		VALID3,
		VALID4,
		MANAGER1_EMP_ID,
		MANAGER1_POS,
		MANAGER2_EMP_ID,
		MANAGER2_POS,
		MANAGER3_EMP_ID,
		MANAGER3_POS,
		SCORE_RESULT_EMP,
		SCORE_RESULT_MANAGER1,
		SCORE_RESULT_MANAGER2,
		SCORE_RESULT_MANAGER3,
		SCORE_RESULT_MANAGER4,
		SCORE_RESULT,
		IS_CLOSED,
		CLASS_ATTENDER_EMP_ID,
		CLASS_ATTENDER_CONS_ID,
		CLASS_ATTENDER_PAR_ID,
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_EMP,
		UPDATE_DATE
	FROM 
		SURVEY_MAIN_RESULT 
	WHERE 
		SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">
</cfquery> <!--- ilgili anketin result_id sini verir --->
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
<cfelse>
	<cfset attributes.start_date = wrk_get_today()>
</cfif>
<cfif get_main_result_info.recordCount>
<table width="98%" cellpadding="0" cellspacing="1" border="0" align="center">
	<tr>
    	<td>
			<cfset head = "">
			<cfoutput>
				<cfif get_main_result_info.action_type eq 1>
					<cfquery name="get_opp" datasource="#dsn3#">
						SELECT OPP_HEAD AS RELATION_HEAD FROM OPPORTUNITIES WHERE OPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_main_result_info.action_id#">
					</cfquery>
					<cfset head=get_opp.relation_head>
				<cfelseif get_main_result_info.action_type eq 2>
					<cfquery name="get_content" datasource="#dsn#">
						SELECT CONT_HEAD AS RELATION_HEAD FROM CONTENT WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_main_result_info.action_id#">
					</cfquery>
					<cfset head=get_content.relation_head>
				<cfelseif get_main_result_info.action_type eq 3>
					<cfquery name="get_campaign" datasource="#dsn3#">
						SELECT CAMP_HEAD AS RELATION_HEAD FROM CAMPAIGNS WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#relation_cat#">
					</cfquery>
					<cfset head=get_campaign.camp_head>
				<cfelseif get_main_result_info.action_type eq 4>
					<cfquery name="get_product" datasource="#dsn3#">
						SELECT PRODUCT_NAME AS RELATION_HEAD FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_main_result_info.action_id#">
					</cfquery>
					<cfset head=get_product.relation_head>
				<cfelseif get_main_result_info.action_type eq 5>
					<cfquery name="get_project" datasource="#dsn#">
						SELECT PROJECT_HEAD AS RELATION_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_main_result_info.action_id#">
					</cfquery>
					<cfset head=get_project.relation_head>
				<cfelseif get_main_result_info.action_type eq 6 or get_main_result_info.action_type eq 8 or get_main_result_info.action_type eq 10 or get_main_result_info.action_type eq 12 or get_main_result_info.action_type eq 13>
					<cfset head=get_emp_info(get_main_result_info.action_id,0,0)>
				<cfelseif get_main_result_info.action_type eq 7>
					<cfquery name="get_cv" datasource="#dsn#">
						SELECT NAME+' '+SURNAME AS RELATION_HEAD FROM EMPLOYEES_APP WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_main_result_info.action_id#">
					</cfquery>
					<cfset head=get_cv.relation_head>
				<cfelseif get_main_result_info.action_type eq 9>
					<cfquery name="get_class" datasource="#dsn#">
						SELECT CLASS_NAME AS RELATION_HEAD FROM TRAINING_CLASS WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_main_result_info.action_id#">
					</cfquery>
					<cfset head=get_class.relation_head>
				</cfif>
				<b>#get_survey_main.survey_main_head# : #head#</b>
			</cfoutput>
		</td>
   </tr>
</table>
<table width="100%" border="0" cellspacing="1" cellpadding="2">
	<cfif get_survey_main.type eq 9 and get_survey_main.is_selected_attender eq 1 and (len(get_main_result_info.class_attender_emp_id) or len(get_main_result_info.class_attender_par_id) or len(get_main_result_info.class_attender_cons_id))>
		<tr class="color-list">
			<td valign="top">
				<table>
					<tr>
						<td class="txtbold">Katılımcı *</td>
						<td>:
							<cfoutput>
								<cfif len(get_main_result_info.class_attender_emp_id)>
									<cfset user_name = '#get_emp_info(get_main_result_info.class_attender_emp_id,0,0)#'>
								<cfelseif len(get_main_result_info.class_attender_par_id)>
									<cfset user_name = '#get_par_info(get_main_result_info.class_attender_par_id,0,-1,0)#'>
								<cfelseif len(get_main_result_info.class_attender_cons_id)>
									<cfset user_name = '#get_cons_info(get_main_result_info.class_attender_cons_id,0,0)#'>
								<cfelse>
									<cfset user_name = ''>
								</cfif>
								#user_name#
							</cfoutput>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</cfif>
	<cfif get_survey_info.recordcount>
		<tr class="color-list">
			<td valign="top">
				<cfset chapter_current_row = 1>
				<cfset all_chapter_total_point = 0>
				<cfoutput query="get_survey_info" group="survey_chapter_id">
					<table id="chapter_#chapter_current_row#">
						<cfif len(survey_chapter_detail)>
							<tr><td>#survey_chapter_detail#</td></tr>  
						</cfif>
						<tr height="20"><td>&nbsp;</td></tr>
						<cfset question_current_row = 1>
						<tr>
							<td>
								<table border="0">
									<cfset chapter_total_point = 0>
									<cfset chapter_weight = get_survey_info.SURVEY_CHAPTER_WEIGHT>
									<cfset max_point_survey = 0>
									<cfset soru_sayisi = 0>
									<cfquery name="get_survey_option_max" datasource="#dsn#">
										SELECT MAX(OPTION_POINT) AS MAX_OPTION_POINT FROM SURVEY_OPTION WHERE SURVEY_CHAPTER_ID = #get_survey_info.SURVEY_CHAPTER_ID#
									</cfquery>
									<cfset max_point_survey = get_survey_option_max.MAX_OPTION_POINT>
									<cfoutput>
										<cfquery name="get_opt_question_id" datasource="#dsn#">
											SELECT SURVEY_QUESTION_ID FROM SURVEY_OPTION WHERE SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#">
										</cfquery>
										<cfquery name="get_survey_chapter_questions_options" datasource="#dsn#">
											SELECT
												SO.SURVEY_CHAPTER_ID,
												SO.SURVEY_QUESTION_ID,
												SO.SURVEY_OPTION_ID,
												SO.OPTION_POINT,
												SO.OPTION_NOTE,
												SO.OPTION_HEAD,
												'' OPTION_HEAD_RESULT,
												0 SURVEY_QUESTION_RESULT_ID,
												0 RESULT_NUMBER,
												SO.OPTION_IMAGE_PATH,
												SO.OPTION_DETAIL
											FROM
												SURVEY_OPTION SO
											WHERE
												<cfif len(survey_question_id) and len(get_opt_question_id.SURVEY_QUESTION_ID)>SO.SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#survey_question_id#">AND</cfif> 
												SO.SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_chapter_id#">
											<cfif get_survey_info.question_type eq 3>
											ORDER BY 
												RESULT_NUMBER
											</cfif>
										</cfquery><!--- Doldurulan anketin seçili yada seçili olmayan tüm optionlarını getirir --->
										<cfif get_survey_info.question_type eq 3><!--- Acik uclu soruda satir sayisinin artirilabilirligi icin kullaniliyor --->
											<cfset Record_ = get_survey_chapter_questions_options.recordcount>
										</cfif>
										<cfif len(get_survey_info.question_image_path)>
											<tr>
												<td>
													<table width="100%">
														<tr>
															<td>
																<cf_get_server_file output_file="helpdesk/#dir_seperator##get_survey_info.question_image_path#" output_server="1" output_type="0" image_width = "100" image_height="50">
															</td>
														</tr> 
													</table>
												</td>
											</tr>
										</cfif>
										<cfif get_survey_info.question_type neq 3 and get_survey_info.question_design eq 2 and (survey_chapter_id neq survey_chapter_id[currentrow-1] or len(get_survey_chapter_questions_options.survey_question_id))>
										<!--- options --->
											<tr valign="top" height="20">
												<td>&nbsp;</td>
												<td class="txtbold"><cfif get_survey_info.is_show_gd eq 1 or get_survey_info.question_gd eq 1>GD</cfif></td>
												<cfloop query="get_survey_chapter_questions_options">
													<td class="txtbold" style="text-align:center">#get_survey_chapter_questions_options.option_head#</td>
												</cfloop>
												<cfif get_survey_main.type eq 8><!--- performans tipi ise secilen degerleri goster--->
													<td width="30">&nbsp;</td>
													<cfif get_survey_main.is_manager_0 eq 1><td class="txtbold" style="text-align:center;width:50px;"><cf_get_lang_main no='164.Çalışan'></td></cfif>
													<cfif get_survey_main.is_manager_3 eq 1><td class="txtbold" style="text-align:center;width:50px;"><cf_get_lang_main no ='2111.Görüş Bildiren'></td></cfif>
													<cfif get_survey_main.is_manager_1 eq 1><td class="txtbold" style="text-align:center;width:50px;">1.<cf_get_lang_main no='1869.Amir'></td></cfif>
													<cfif get_survey_main.is_manager_4 eq 1><td class="txtbold" style="text-align:center;width:50px;"><cf_get_lang_main no ='2112.Ortak Değerlendirme'></td></cfif>
													<cfif get_survey_main.is_manager_2 eq 1><td class="txtbold" style="text-align:center;width:50px;">2.<cf_get_lang_main no='1869.Amir'></td></cfif>
												</cfif>
											</tr>
										</cfif>
										<cfif  get_survey_info.question_design eq 2><!--- yatay --->
											<tr class="color-list">
												<!--- sorular --->
												<td style="width:400px;" class="txtbold">
													<cfset soru_sayisi = soru_sayisi+1>
													#question_current_row#) #question_head# <cfif is_required eq 1>*</cfif>
													<cfif len(question_detail)><a href="javascript://"><img src="/images/crm.gif" height="17" width="17" border="0" alt="#question_detail#" title="#question_detail#" align="absmiddle"></a></cfif>
												</td>
												<!--- //sorular --->
												<td>
													<cfif get_survey_info.is_show_gd eq 1 or get_survey_info.question_gd eq 1><!--- soruda veya seçenekler de GD işaretli ise--->
														<cfquery name="get_gd" datasource="#dsn#" maxrows="1">
															SELECT GD_OPTION FROM SURVEY_QUESTION_RESULT WHERE GD_OPTION = 1 AND SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#"> AND SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> ORDER BY SURVEY_QUESTION_RESULT_ID DESC
														</cfquery>
														<input type="radio" name="user_answer_#get_survey_info.survey_question_id#" id="user_answer_#get_survey_info.survey_question_id#" value="-1" disabled="disabled" <cfif get_gd.gd_option eq 1>checked</cfif>>
														<cfif get_gd.gd_option eq 1><!--- gözlem dışı seçildiğinde değerlendirmeye max puanı ata--->
															<cfset chapter_total_point = chapter_total_point+max_point_survey>
														</cfif>
													</cfif>
												</td>
												<cfloop query="get_survey_chapter_questions_options">
													<cfquery name="get_survey_question_result" datasource="#dsn#">
														SELECT SURVEY_OPTION_ID,OPTION_POINT,CHAPTER_DETAIL2,GD_OPTION FROM SURVEY_QUESTION_RESULT WHERE <cfif len(get_survey_info.survey_question_id)>SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> AND<cfelse>SURVEY_QUESTION_ID IS NULL AND</cfif> SURVEY_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#survey_option_id#"> AND SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#"> 
													</cfquery>
													<cfif get_survey_question_result.recordcount and len(get_survey_question_result.option_point)>
														<cfset chapter_total_point = chapter_total_point+get_survey_question_result.option_point>
													</cfif>
													<td style="text-align:center;width:65px;">
														<cfswitch expression="#get_survey_info.question_type#">
															<cfcase value="1"><!--- tekli soru tipi --->
																<input type="radio" name="user_answer_#get_survey_info.survey_question_id#" id="user_answer_#get_survey_info.survey_question_id#" value="#survey_option_id#" disabled="disabled"  <cfif ListFind(get_survey_question_result.survey_option_id,survey_option_id,",")> checked</cfif>>
															</cfcase>
															<cfcase value="2"><!--- çoklu soru tipi --->
																<input type="checkbox" name="user_answer_#get_survey_info.survey_question_id#" id="user_answer_#get_survey_info.survey_question_id#" value="#survey_option_id#" disabled="disabled" <cfif ListFind(get_survey_question_result.survey_option_id,survey_option_id,",")> checked</cfif>>
															</cfcase>
														</cfswitch>
													</td>
												</cfloop>
												<td>&nbsp;</td>
												<cfif get_survey_main.is_manager_0 eq 1>
													<cfquery name="get_question_result_history_emp" datasource="#dsn#">
														SELECT 
															SURVEY_OPTION_GD_EMP,
															(SELECT OPTION_HEAD FROM SURVEY_OPTION WHERE SURVEY_OPTION_ID = SURVEY_OPTION_ID_EMP) AS SURVEY_OPTION_ID_EMP_,
															SURVEY_OPTION_ID_EMP,
															SURVEY_OPTION_POINT_EMP
														FROM 
															SURVEY_QUESTION_RESULT
														WHERE 
															SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> AND
															SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#"> AND
															(SURVEY_OPTION_ID_EMP IS NOT NULL OR SURVEY_OPTION_GD_EMP = 1) AND
															((SURVEY_OPTION_ID_EMP IS NOT NULL AND SURVEY_OPTION_GD_EMP IS NOT NULL) OR (SURVEY_OPTION_ID_EMP IS NULL AND SURVEY_OPTION_GD_EMP IS NOT NULL))
														ORDER BY 
															RECORD_DATE DESC
													</cfquery>
													<td style="text-align:center;width:50px;">
														<cfif get_question_result_history_emp.survey_option_gd_emp eq 1><b>GD</b><cfelse>#get_question_result_history_emp.SURVEY_OPTION_ID_EMP_#</cfif>
													</td>
												</cfif>
												<cfif get_survey_main.is_manager_3 eq 1>
													<cfquery name="get_result_history_manag3" datasource="#dsn#" maxrows="1">
														SELECT 
															SURVEY_OPTION_GD_MANAGER3,
															(SELECT OPTION_HEAD FROM SURVEY_OPTION WHERE SURVEY_OPTION_ID = SURVEY_OPTION_ID_MANAGER3) AS SURVEY_OPTION_ID_MANAGER3_,
															SURVEY_OPTION_ID_MANAGER3,
															SURVEY_OPTION_POINT_MANAGER3
														FROM 
															SURVEY_QUESTION_RESULT
														WHERE 
															SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> AND
															SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#"> AND
															(SURVEY_OPTION_POINT_MANAGER3 IS NOT NULL OR SURVEY_OPTION_GD_MANAGER3 = 1) AND
															((SURVEY_OPTION_ID_MANAGER3 IS NOT NULL AND SURVEY_OPTION_GD_MANAGER3 IS NOT NULL) OR (SURVEY_OPTION_ID_MANAGER3 IS NULL AND SURVEY_OPTION_GD_MANAGER3 IS NOT NULL))
														ORDER BY 
															RECORD_DATE DESC
													</cfquery>
													<td style="text-align:center;width:50px;">
														<cfif get_result_history_manag3.survey_option_gd_manager3 eq 1><b>GD</b><cfelse>#get_result_history_manag3.survey_option_id_manager3_#</cfif>
													</td>
												</cfif>
												<cfif get_survey_main.is_manager_1 eq 1>
													<cfquery name="get_result_history_manag1" datasource="#dsn#" maxrows="1">
														SELECT 
															SURVEY_OPTION_GD_MANAGER1,
															(SELECT OPTION_HEAD FROM SURVEY_OPTION WHERE SURVEY_OPTION_ID = SURVEY_OPTION_ID_MANAGER1) AS SURVEY_OPTION_ID_MANAGER1_,
															SURVEY_OPTION_ID_MANAGER1,
															SURVEY_OPTION_POINT_MANAGER1,
															SURVEY_QUESTION_ID,
															SURVEY_MAIN_RESULT_ID
														FROM 
															SURVEY_QUESTION_RESULT
														WHERE 
															SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> AND
															SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#"> AND 
															(SURVEY_OPTION_POINT_MANAGER1 IS NOT NULL  OR SURVEY_OPTION_GD_MANAGER1 = 1) AND
															((SURVEY_OPTION_ID_MANAGER1 IS NOT NULL AND SURVEY_OPTION_GD_MANAGER1 IS NOT NULL) OR (SURVEY_OPTION_ID_MANAGER1 IS NULL AND SURVEY_OPTION_GD_MANAGER1 IS NOT NULL))
														ORDER BY 
															RECORD_DATE DESC
													</cfquery>
													<td style="text-align:center;width:50px;">
														<cfif get_result_history_manag1.survey_option_gd_manager1 eq 1><b>GD</b><cfelse>#get_result_history_manag1.SURVEY_OPTION_ID_MANAGER1_#</cfif>
													</td>
												</cfif>
												<cfif get_survey_main.is_manager_4 eq 1>
													<cfquery name="get_result_history_manag4" datasource="#dsn#" maxrows="1">
														SELECT 
															SURVEY_OPTION_GD_MANAGER4,
															(SELECT OPTION_HEAD FROM SURVEY_OPTION WHERE SURVEY_OPTION_ID = SURVEY_OPTION_ID_MANAGER4) AS SURVEY_OPTION_ID_MANAGER4_,
															SURVEY_OPTION_ID_MANAGER4,
															SURVEY_OPTION_POINT_MANAGER4
														FROM 
															SURVEY_QUESTION_RESULT
														WHERE 
															SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> AND 
															SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#"> AND
															(SURVEY_OPTION_POINT_MANAGER4 IS NOT NULL  OR SURVEY_OPTION_GD_MANAGER4 = 1) AND
															((SURVEY_OPTION_ID_MANAGER4 IS NOT NULL AND SURVEY_OPTION_GD_MANAGER4 IS NOT NULL) OR (SURVEY_OPTION_ID_MANAGER4 IS NULL AND SURVEY_OPTION_GD_MANAGER4 IS NOT NULL))
														ORDER BY 
															RECORD_DATE DESC
													</cfquery>
													<td style="text-align:center;width:50px;">
														<cfif get_result_history_manag4.survey_option_gd_manager4 eq 1><b>GD</b><cfelse>#get_result_history_manag4.SURVEY_OPTION_ID_MANAGER4_#</cfif>
													</td>
												</cfif>
												<cfif get_survey_main.is_manager_2 eq 1>
													<cfquery name="get_result_history_manag2" datasource="#dsn#" maxrows="1">
														SELECT 
															SURVEY_OPTION_GD_MANAGER2,
															(SELECT OPTION_HEAD FROM SURVEY_OPTION WHERE SURVEY_OPTION_ID = SURVEY_OPTION_ID_MANAGER2) AS SURVEY_OPTION_ID_MANAGER2_,
															SURVEY_OPTION_ID_MANAGER2,
															SURVEY_OPTION_POINT_MANAGER2
														FROM 
															SURVEY_QUESTION_RESULT
														WHERE 
															SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> AND
															SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#"> AND
															(SURVEY_OPTION_ID_MANAGER2 IS NOT NULL OR SURVEY_OPTION_GD_MANAGER2 = 1) AND
															((SURVEY_OPTION_ID_MANAGER2 IS NOT NULL AND SURVEY_OPTION_GD_MANAGER2 IS NOT NULL) OR (SURVEY_OPTION_ID_MANAGER2 IS NULL AND SURVEY_OPTION_GD_MANAGER2 IS NOT NULL))
														ORDER BY 
															RECORD_DATE DESC
													</cfquery>
													<td style="text-align:center;width:50px;">
														<cfif get_result_history_manag2.survey_option_gd_manager2 eq 1><b>GD</b><cfelse>#get_result_history_manag2.SURVEY_OPTION_ID_MANAGER2_#</cfif>
													</td>
												</cfif>
											</tr>
										<cfelse><!--- dikey --->
											<!--- sorular --->
											<tr>
												<td style="width:400px;" class="txtbold">
													#question_current_row#) #question_head# <cfif is_required eq 1>*</cfif>
													<cfif len(question_detail)><a href="javascript://"><img src="/images/crm.gif" height="17" width="17" border="0" alt="#question_detail#" title="#question_detail#" align="absmiddle"></a></cfif>
												</td>
											</tr>
											<!--- //sorular --->
											<cfloop query="get_survey_chapter_questions_options">
												<cfquery name="get_survey_question_result" datasource="#dsn#">
													SELECT SURVEY_OPTION_ID,OPTION_POINT,CHAPTER_DETAIL2,GD_OPTION FROM SURVEY_QUESTION_RESULT WHERE <cfif len(get_survey_info.survey_question_id)>SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> AND<cfelse>SURVEY_QUESTION_ID IS NULL AND</cfif> SURVEY_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#survey_option_id#"> AND SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">
												</cfquery>
												<tr>
													<td>
														<cfswitch expression="#get_survey_info.question_type#">
															<cfcase value="1"><!--- tekli soru tipi --->
																<input type="radio" name="user_answer_#get_survey_info.survey_question_id#" id="user_answer_#get_survey_info.survey_question_id#" value="#survey_option_id#" disabled="disabled" <cfif ListFind(get_survey_question_result.survey_option_id,survey_option_id,",")> checked</cfif>>
																#get_survey_chapter_questions_options.option_head#
															</cfcase>
															<cfcase value="2"><!--- çoklu soru tipi --->
																<input type="checkbox" name="user_answer_#get_survey_info.survey_question_id#" id="user_answer_#get_survey_info.survey_question_id#" value="#survey_option_id#" disabled="disabled" <cfif ListFind(get_survey_question_result.survey_option_id,survey_option_id,",")> checked</cfif>>
																#get_survey_chapter_questions_options.option_head#
															</cfcase>
														</cfswitch>
													</td>
												</tr>
											</cfloop>
										</cfif>
										<cfswitch expression="#get_survey_info.question_type#">
											<cfcase value="3"><!--- açık uçlu --->
												<tr>
													<td>
													<table width="100%" border="0" id="add_new_option_#get_survey_info.survey_question_id#">
														<cfloop query="get_survey_chapter_questions_options">
															<cfquery name="get_survey_question_result" datasource="#dsn#">
																SELECT SURVEY_OPTION_ID,OPTION_POINT,OPTION_HEAD,CHAPTER_DETAIL2,GD_OPTION FROM SURVEY_QUESTION_RESULT WHERE <cfif len(get_survey_info.survey_question_id)>SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> AND<cfelse>SURVEY_QUESTION_ID IS NULL AND</cfif> SURVEY_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#survey_option_id#"> AND SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">
															</cfquery>
															<tr id="add_new_option_row_#get_survey_info.survey_question_id#_#currentrow#">
																<td width="200">#option_head#</td>
																<td>#get_survey_question_result.option_head#</td>
															</tr>
														</cfloop>
													</table>
													</td>
												</tr>
											</cfcase>
											<cfcase value="5"><!--- paragraf metin--->
												<tr>
													<td>
														<table width="100%" border="0" id="add_new_option_#get_survey_info.survey_question_id#">
															<cfloop query="get_survey_chapter_questions_options">
																<cfquery name="get_survey_question_result" datasource="#dsn#">
																	SELECT 
																		SURVEY_OPTION_ID,
																		OPTION_POINT,
																		OPTION_HEAD,
																		CHAPTER_DETAIL2,
																		GD_OPTION,
																		OPTION_HEAD_EMP,
																		OPTION_HEAD_MANAGER1,
																		OPTION_HEAD_MANAGER2,
																		OPTION_HEAD_MANAGER3,
																		OPTION_HEAD_MANAGER4
																	FROM 
																		SURVEY_QUESTION_RESULT WHERE <cfif len(get_survey_info.survey_question_id)>SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> AND<cfelse>SURVEY_QUESTION_ID IS NULL AND</cfif> SURVEY_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#survey_option_id#"> AND SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">
																</cfquery>
																<tr id="add_new_option_row_#get_survey_info.survey_question_id#_#currentrow#">
																	 <td colspan="2" class="txtbold">&nbsp;#option_head#</td>
																</tr>
																<cfif len(get_survey_question_result.option_head_emp)>
																	<tr>
																		<td>Çalışan</td>
																		<td>#get_survey_question_result.option_head_emp#</td>
																	</tr>
																</cfif>
																<cfif len(get_survey_question_result.option_head_manager3)>
																	<tr>
																		<td>Görüş Bildiren</td>
																		<td>#get_survey_question_result.option_head_manager3#</td>
																	</tr>
																</cfif>
																<cfif len(get_survey_question_result.option_head_manager1)>
																	<tr>
																		<td>1.Amir</td>
																		<td>#get_survey_question_result.option_head_manager1#</td>
																	</tr>
																</cfif>
																<cfif len(get_survey_question_result.option_head_manager2)>
																	<tr>
																		<td>2.Amir</td>
																		<td>#get_survey_question_result.option_head_manager2#</td>
																	</tr>
																</cfif>
																<cfif len(get_survey_question_result.option_head_manager4)>
																	<tr>
																		<td>Ortak Değerlendirme</td>
																		<td>#get_survey_question_result.option_head_manager4#</td>
																	</tr>
																</cfif>
																<tr>
																	<td>&nbsp;</td>
																</tr>
															</cfloop>
														</table>
													</td>
												</tr>
											</cfcase>
										</cfswitch>
										<cfset question_current_row = question_current_row + 1>
										<tr>
											<td colspan="20" style="width:1000px;"><hr /></td>
										</tr>
									</cfoutput>
								</table>
							</td>
						</tr>
						<cfquery name="get_survey_question_result_det" datasource="#dsn#">
							SELECT CHAPTER_DETAIL2 FROM SURVEY_QUESTION_RESULT WHERE <cfif len(get_survey_info.survey_question_id)>SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> AND<cfelse>SURVEY_QUESTION_ID IS NULL AND</cfif>  SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#"> AND CHAPTER_DETAIL2 IS NOT NULL
						</cfquery>
						<cfif get_survey_info.is_chapter_detail2 eq 1>
							<tr>
								<td>
									<table>
										<cfset chapter_detail_expl = get_survey_question_result_det.CHAPTER_DETAIL2>
										<cfif get_main_result_info.action_type eq 8>
											<cfquery name="get_chapter_result" datasource="#dsn#">
												SELECT EXPLANATION,EMP_EXPL,MANAGER1_EXPL,MANAGER2_EXPL,MANAGER3_EXPL,MANAGER4_EXPL FROM SURVEY_CHAPTER_RESULT WHERE SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#"> AND SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#survey_chapter_id#">
											</cfquery>
											<cfif get_survey_main.is_manager_0 is 1 and session.ep.userid eq get_main_result_info.action_id><!--- calisan kendi aciklamasini gorecek--->
												<cfset chapter_detail_expl = get_chapter_result.EMP_EXPL>
											<cfelseif get_survey_main.is_manager_3 eq 1 and session.ep.userid eq get_main_result_info.manager3_emp_id>
												<cfset chapter_detail_expl = get_chapter_result.MANAGER3_EXPL>
											<cfelseif get_survey_main.is_manager_1 eq 1 and session.ep.userid eq get_main_result_info.manager1_emp_id>
												<cfset chapter_detail_expl = get_chapter_result.MANAGER1_EXPL>
											<cfelseif get_survey_main.is_manager_4 eq 1 and get_main_result_info.valid1 eq 1 and session.ep.userid eq get_main_result_info.manager1_emp_id>
												<cfset chapter_detail_expl = get_chapter_result.MANAGER4_EXPL>
											<cfelseif get_survey_main.is_manager_2 eq 1 and session.ep.userid eq get_main_result_info.manager2_emp_id>
												<cfset chapter_detail_expl = get_chapter_result.MANAGER2_EXPL>
											<cfelse>
												<cfset chapter_detail_expl = get_chapter_result.EXPLANATION>
											</cfif>
										</cfif>
										<tr>
											<td valign="top" style="width:375px;" class="txtbold">#get_survey_info.survey_chapter_detail2#</td>
											<td>#chapter_detail_expl#</td>
										</tr>
										<cfif get_main_result_info.action_type eq 8>
											<cfif get_chapter_result.recordcount>
												<cfif len(get_chapter_result.emp_expl)>
													<tr>
														<td valign="top" style="width:375px;"><b><cf_get_lang_main no='164.Çalışan'> <cf_get_lang_main no='217.Açıklama'></b></td>
														<td>&nbsp;#get_chapter_result.EMP_EXPL#</td>
													</tr>
												</cfif>
												<cfif len(get_chapter_result.MANAGER3_EXPL)>
													<tr>
														<td valign="top" style="width:375px;"><b><cf_get_lang_main no ='2111.Görüş Bildiren'> <cf_get_lang_main no='217.Açıklama'></b></td>
														<td>&nbsp;#get_chapter_result.MANAGER3_EXPL#</td>
													</tr>
												</cfif>
												<cfif len(get_chapter_result.MANAGER1_EXPL)>
													<tr>
														<td valign="top" style="width:375px;"><b>1.<cf_get_lang_main no='1869.Amir'> <cf_get_lang_main no='217.Açıklama'></b></td>
														<td>&nbsp;#get_chapter_result.MANAGER1_EXPL#</td>
													</tr>
												</cfif>
												<cfif len(get_chapter_result.MANAGER4_EXPL)>
													<tr>
														<td valign="top" style="width:375px;"><b><cf_get_lang_main no='2112.Ortak Değerlendirme'> <cf_get_lang_main no='217.Açıklama'></b></td>
														<td>&nbsp;#get_chapter_result.MANAGER4_EXPL#</td>
													</tr>
												</cfif>
												<cfif len(get_chapter_result.MANAGER2_EXPL)>
													<tr>
														<td valign="top" style="width:375px;"><b>2.<cf_get_lang_main no='1869.Amir'> <cf_get_lang_main no='217.Açıklama'></b></td>
														<td>&nbsp;#get_chapter_result.MANAGER2_EXPL#</td>
													</tr>
												</cfif>
											</cfif>
										</cfif>
									</table>
								</td>
							</tr>
						</cfif>
						<cfset chapter_current_row = chapter_current_row + 1>
						<cfif survey_chapter_id neq survey_chapter_id[currentrow-1]>
							<cfif len(chapter_weight) and (soru_sayisi gt 0) and len(max_point_survey) and (max_point_survey*soru_sayisi) gt 0>
								<cfset all_chapter_total_point = all_chapter_total_point+((chapter_total_point*chapter_weight)/(max_point_survey*soru_sayisi))>
							</cfif>
						</cfif>
					</table>
				</cfoutput>
			</td>
		</tr>	
		<cfoutput query="get_main_result_info">
			<cfif not (isdefined("session.pp") or isdefined("session.ww"))>
				<tr>
					<td>
						<table border="0" id="detail">
							<tr>
								<td valign="top">
									<table>
										<cfif get_main_result_info.action_type eq 8>
											<tr>
												<td><cf_get_lang_main no='164.Çalışan'></td>
												<td nowrap="nowrap">: #get_emp_info(get_main_result_info.action_id,0,0)#</td>
											</tr>
											<tr>
												<cfif get_survey_main.is_manager_3 eq 1>
												<td><cf_get_lang_main no ='2111.Görüş Bildiren'></td>
												<td>: #get_emp_info(manager3_emp_id,0,0,0)#</td>
												</cfif>
											</tr>
										</cfif>
										<tr>
											<cfif get_main_result_info.action_type eq 8>
												<td><cf_get_lang_main no='1060.Dönem'></td>
												<td>
													: #dateformat(get_main_result_info.start_date,dateformat_style)# - #dateformat(get_main_result_info.finish_date,dateformat_style)#
												</td>
											<cfelse>
												<td><cf_get_lang_main no='330.Tarih'></td>
												<td>: #dateformat(get_main_result_info.start_date,dateformat_style)#</td>
											</cfif>
										</tr>
										<tr>
											<td valign="top"><cf_get_lang_main no='10.Notlar'></td>
											<td valign="top" width="250">: #get_main_result_info.result_note#</td>
										</tr>
										<tr>
											<td valign="top"><cf_get_lang_main no='2008.Yorum'></td>
											<td valign="top" width="250">: #comment#</td>
										</tr>
									</table>
								</td>
								<td valign="top">
									<table>
										<cfif get_main_result_info.action_type eq 8><!--- performans formu ise amir bilgileri gelsin--->
											<tr>
												<cfif get_survey_main.is_manager_1 eq 1>
													<td>1.<cf_get_lang_main no='1869.Amir'></td>
													<td>: #get_emp_info(get_main_result_info.manager1_emp_id,0,0,0)#</td>
												</cfif>
											</tr>
											<tr>
												<cfif get_survey_main.is_manager_2 eq 1>
													<td>2.<cf_get_lang_main no='1869.Amir'></td>
													<td>: #get_emp_info(manager2_emp_id,0,0,0)#</td>
												</cfif>
											</tr>	
										</cfif>
										<cfif len(get_survey_main.process_id)>
											<tr>
												<td><cf_get_lang_main no="1447.Süreç"></td>
												<cfif len(get_main_result_info.process_row_id)>
													<cfquery name="get_process_name" datasource="#dsn#">
														SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID =#get_main_result_info.process_row_id# 
													</cfquery>
												</cfif>
												<td><cfif len(get_main_result_info.process_row_id)>: #get_process_name.stage#</cfif></td>
											</tr>
										</cfif>
										<tr>
											<td><cf_get_lang_main no='1572.Puan'></td>
											<td>
												<cfset user_point = 0>
												<cfif get_survey_main.type eq 8><!--- performans değerlendirme ise--->
													<cfif not len(get_main_result_info.score_result_emp)><cfset get_main_result_info.score_result_emp = 0></cfif>
													<cfif not len(get_main_result_info.score_result_manager1)><cfset get_main_result_info.score_result_manager1 = 0></cfif>
													<cfif not len(get_main_result_info.score_result_manager2)><cfset get_main_result_info.score_result_manager2 = 0></cfif>
													<cfif not len(get_main_result_info.score_result_manager3)><cfset get_main_result_info.score_result_manager3 = 0></cfif>
													<cfif not len(get_main_result_info.score_result_manager4)><cfset get_main_result_info.score_result_manager4 = 0></cfif>
													<!--- çalışan--->
													<cfif get_survey_main.is_manager_0 is 1 and len(get_survey_main.emp_quiz_weight)>
														<cfset user_point = user_point+(get_main_result_info.score_result_emp * get_survey_main.emp_quiz_weight)>
													</cfif>
													<!--- görüş bildiren--->
													<cfif get_survey_main.is_manager_3 is 1 and len(get_survey_main.manager_quiz_weight_3)>
														<cfset user_point = user_point+(get_main_result_info.score_result_manager3 * get_survey_main.manager_quiz_weight_3)>
													</cfif>
													<!--- 1.amir--->
													<cfif get_survey_main.is_manager_1 is 1 and len(get_survey_main.manager_quiz_weight_1)>
														<cfset user_point = user_point+(get_main_result_info.score_result_manager1 * get_survey_main.manager_quiz_weight_1)>
													</cfif>
													<!--- ortak değerlendirme--->
													<cfif get_survey_main.is_manager_4 is 1 and len(get_survey_main.manager_quiz_weight_4)>
														<cfset user_point = user_point+(get_main_result_info.score_result_manager4 * get_survey_main.manager_quiz_weight_4)>
													</cfif>
													<!--- 2.amir--->
													<cfif get_survey_main.is_manager_2 is 1 and len(get_survey_main.manager_quiz_weight_2)>
														<cfset user_point = user_point+(get_main_result_info.score_result_manager2 * get_survey_main.manager_quiz_weight_2)>
													</cfif>
													<!--- <cfset user_point_ = ((get_main_result_info.score_result_emp * get_survey_main.emp_quiz_weight)+(get_main_result_info.score_result_manager3*get_survey_main.manager_quiz_weight_3)+(get_main_result_info.score_result_manager2*get_survey_main.manager_quiz_weight_2)+(get_main_result_info.score_result_manager1*get_survey_main.manager_quiz_weight_1)+(get_main_result_info.score_result_manager4*get_survey_main.manager_quiz_weight_4))/100> --->
													<cfset user_point_ = user_point/100>
													: #TlFormat(user_point_)# / 100
												<cfelse>
													<cfif len(get_main_result_info.score_result)>
														: #TlFormat(get_main_result_info.score_result)#
													</cfif>
												</cfif>
											</td>
										</tr>
										<cfif get_main_result_info.action_type eq 8>
											<cfif len(get_main_result_info.score_result_emp) and get_survey_main.is_manager_0 is 1>
												<tr>
													<td><cf_get_lang_main no='164.Çalışan'></td>
													<td>: #TlFormat(get_main_result_info.score_result_emp)#</td>
												</tr>
											</cfif>
											<cfif len(get_main_result_info.score_result_manager3) and get_survey_main.is_manager_3 is 1>
												<tr>
													<td><cf_get_lang_main no='2111.Görüş Bildiren'></td>
													<td>: #TlFormat(get_main_result_info.score_result_manager3)#</td>
												</tr>
											</cfif>
											<cfif len(get_main_result_info.score_result_manager1) and get_survey_main.is_manager_1 is 1>
												<tr>
													<td>1.<cf_get_lang_main no='1869.Amir'></td>
													<td>: #TlFormat(get_main_result_info.score_result_manager1)#</td>
												</tr>
											</cfif>
											<cfif len(get_main_result_info.score_result_manager4) and get_survey_main.is_manager_4 is 1>
												<tr>
													<td><cf_get_lang_main no='2112.Ortak Değerlendirme'></td>
													<td>: #TlFormat(get_main_result_info.score_result_manager4)#</td>
												</tr>
											</cfif>
											<cfif len(get_main_result_info.score_result_manager2) and get_survey_main.is_manager_2 eq 1>
												<tr>
													<td>2.<cf_get_lang_main no='1869.Amir'></td>
													<td>: #TlFormat(get_main_result_info.score_result_manager2)#</td>
												</tr>
											</cfif>
										</cfif>
										<tr>
											<td><cf_get_lang_main no='1497.Max'> <cf_get_lang_main no='1572.Puan'>/<cf_get_lang_main no='1977.uygunluk sınırı'></td>
											<td>: #get_survey_main.total_score# / #get_survey_main.average_score#</td>
										</tr>
										<tr>
											<td></td>
											<td></td>
										</tr> 
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			<cfelse>
				<tr style="display:none;">
					<td>
						<cf_workcube_process is_upd='0' select_value = '#get_main_result_info.process_row_id#' process_cat_width='130' is_detail='1'>
						#dateformat(get_main_result_info.start_date,dateformat_style)#
					</td>
				</tr>
			</cfif>
		</cfoutput>
	</cfif>
</table>
</cfif>
<br />

