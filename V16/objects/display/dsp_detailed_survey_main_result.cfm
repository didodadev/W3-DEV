<cfsetting showdebugoutput="no">
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
<cfquery name="get_survey_info" datasource="#dsn#">
	SELECT
		SC.SURVEY_CHAPTER_ID,
		SC.SURVEY_CHAPTER_HEAD,
		SC.SURVEY_CHAPTER_DETAIL,
		SQ.SURVEY_QUESTION_ID,
		SQ.QUESTION_HEAD,
		SQ.QUESTION_DETAIL,
		SQ.QUESTION_TYPE,
		SQ.QUESTION_DESIGN,
		SQ.QUESTION_IMAGE_PATH,
		SQ.IS_REQUIRED,
		SC.IS_CHAPTER_DETAIL2,
		SC.SURVEY_CHAPTER_DETAIL2,
		SC.SURVEY_CHAPTER_WEIGHT
	FROM
		SURVEY_CHAPTER SC,
		SURVEY_QUESTION SQ
	WHERE
		SC.SURVEY_CHAPTER_ID = SQ.SURVEY_CHAPTER_ID AND
		SC.SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
	ORDER BY
		SC.SURVEY_CHAPTER_ID,
		SQ.SURVEY_QUESTION_ID
</cfquery><!--- Ilgili anketin, bolum ve sorularini getirir, optionlari loop edebilmek için kullanilir --->
<cfquery name="get_main_result_info" datasource="#dsn#">
	SELECT 
		PARTNER_ID,
		CONSUMER_ID,
		COMPANY_ID,
		EMP_ID,
		START_DATE,
		COMMENT,
		PROCESS_ROW_ID,
		RESULT_NOTE,
		ACTION_TYPE,
		ACTION_ID,
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
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_EMP,
		UPDATE_DATE,
		SCORE_RESULT,
		CLASS_ATTENDER_EMP_ID,
		CLASS_ATTENDER_PAR_ID,
		CLASS_ATTENDER_CONS_ID
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
	<table class="dph" align="center" style="display:none;">	
<!--- <table class="dph" align="center"> --->
	<tr>
    	<td><h3>
		<cfset head = "">
		<cfoutput>
			(<!--- firsat--->
			<cfif get_main_result_info.action_type eq 1>
				<cfquery name="get_opp" datasource="#dsn3#">
					SELECT OPP_HEAD AS RELATION_HEAD FROM OPPORTUNITIES WHERE OPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_main_result_info.action_id#">
				</cfquery>
				<cf_get_lang dictionary_id='57612.Firsat'>
				<cfset head = get_opp.RELATION_HEAD>
			<!--- içerik--->
			<cfelseif get_main_result_info.action_type eq 2>
				<cfquery name="get_content" datasource="#dsn#">
					SELECT CONT_HEAD AS RELATION_HEAD FROM CONTENT WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_main_result_info.action_id#">
				</cfquery>
				<cf_get_lang dictionary_id='57653.Içerik'>
				<cfset head = get_content.RELATION_HEAD>
			<!---kampanya --->
			<cfelseif get_main_result_info.action_type eq 3>
				<cfquery name="get_campaign" datasource="#dsn3#">
					SELECT CAMP_HEAD AS RELATION_HEAD FROM CAMPAIGNS WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_main_result_info.action_id#">
				</cfquery>
				<cf_get_lang dictionary_id='57446.Kampanya'>
				<cfset head = get_campaign.CAMP_HEAD>
			<!--- ürün--->
			<cfelseif get_main_result_info.action_type eq 4>
				<cfquery name="get_product" datasource="#dsn3#">
					SELECT PRODUCT_NAME AS RELATION_HEAD FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_main_result_info.action_id#">
				</cfquery>
				<cf_get_lang dictionary_id='57657.Ürün'>
				<cfset head=get_product.RELATION_HEAD>
			<!--- proje--->
			<cfelseif get_main_result_info.action_type eq 5>
				<cfquery name="get_project" datasource="#dsn#">
					SELECT PROJECT_HEAD AS RELATION_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_main_result_info.action_id#">
				</cfquery>
				<cf_get_lang dictionary_id='57416.Proje'>
				<cfset head = get_project.RELATION_HEAD>
			<!--- deneme süresi--->
			<cfelseif get_main_result_info.action_type eq 6>
				<cf_get_lang dictionary_id='29776.Deneme Süresi'>
				<cfset head = get_emp_info(get_main_result_info.action_id,0,0)>
			<!--- ise alim--->
			<cfelseif get_main_result_info.action_type eq 7>
				<cfquery name="get_cv" datasource="#dsn#">
					SELECT NAME+' '+SURNAME AS RELATION_HEAD FROM EMPLOYEES_APP WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_main_result_info.action_id#">
				</cfquery>
				<cf_get_lang dictionary_id='57996.Ise Alim'>
				<cfset head = get_cv.RELATION_HEAD>
			<!--- performans--->
			<cfelseif get_main_result_info.action_type eq 8>
				<cf_get_lang dictionary_id='58003.Performans'>
				<cfset head= get_emp_info(get_main_result_info.action_id,0,0)>
			<cfelseif get_main_result_info.action_type eq 9>
				<cfquery name="get_class" datasource="#dsn#">
					SELECT CLASS_NAME AS RELATION_HEAD FROM TRAINING_CLASS WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_main_result_info.action_id#">
				</cfquery>
				<cf_get_lang dictionary_id='57419.Egitim'>
				<cfset head= get_class.RELATION_HEAD>
			<!--- isten çikis çalisan--->
			<cfelseif get_main_result_info.action_type eq 10>
				<cf_get_lang dictionary_id='29832.Isten Çikis'>
				<cfset head = get_emp_info(get_main_result_info.action_id,0,0)>
			<cfelseif get_main_result_info.action_type eq 14>
				<cf_get_lang dictionary_id='58662.Anket'>
			</cfif>)
			 #get_survey_main.survey_main_head# : #head#
		</cfoutput></h3>
		</td>
        <td style="text-align:right;">
        	<a href="<cfoutput>#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.survey_id#&action_row_id=0</cfoutput>" target="_blank"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>" alt="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a>
   		</td>
   </tr>
</table>
<cf_box
title=" #get_survey_main.survey_main_head# : #head#" 
closable="0"
print_href="#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.survey_id#&action_row_id=0"
>
	<table width="100%" border="0" cellspacing="1" cellpadding="2">
		<cfif get_survey_info.recordcount>
		<cfif get_survey_main.type eq 9 and get_survey_main.is_selected_attender eq 1 and (len(get_main_result_info.class_attender_emp_id) or len(get_main_result_info.class_attender_par_id) or len(get_main_result_info.class_attender_cons_id))>
			<tr>
				<td valign="top">
				<table>
					<tr>
						<td class="txtbold"><cf_get_lang dictionary_id='29780.Katılımcı'> *</td>
						<td>:
						<cfoutput>
							<cfif len(get_main_result_info.class_attender_emp_id)>
								#get_emp_info(get_main_result_info.class_attender_emp_id,0,0)#
							<cfelseif len(get_main_result_info.class_attender_par_id)>
								#get_par_info(get_main_result_info.class_attender_par_id,0,-1,0)#
							<cfelseif len(get_main_result_info.class_attender_cons_id)>
								#get_cons_info(get_main_result_info.class_attender_cons_id,0,0)#
							</cfif>
						</cfoutput>
						</td>
					</tr>
				</table>
				</td>
			</tr>
		</cfif>
		<tr >
			<td valign="top">
				<cfset chapter_current_row = 1>
				<cfset all_chapter_total_point = 0>
				<cfoutput query="get_survey_info" group="survey_chapter_id">
				<cf_seperator id='chapter_#chapter_current_row#' title='#survey_chapter_head#'>
				<table id='chapter_#chapter_current_row#'>
					<cfif len(survey_chapter_detail)>
					<tr>
						<td style="height:20px;">#survey_chapter_detail#</td>
					</tr>  
					</cfif>
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
						<cfif len(get_survey_option_max.MAX_OPTION_POINT)><cfset max_point_survey = get_survey_option_max.MAX_OPTION_POINT></cfif>
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
									SO.SCORE_RATE1,
									SO.SCORE_RATE2,
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
							</cfquery><!--- Doldurulan anketin seçili yada seçili olmayan tüm optionlarini getirir --->
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
								<tr valign="top">
									<td>&nbsp;</td>
									<cfloop query="get_survey_chapter_questions_options">
										<td class="txtbold" style="text-align:center">#get_survey_chapter_questions_options.option_head#</td>
									</cfloop>
									<cfif get_survey_main.type eq 8><!--- performans tipi ise secilen degerleri goster--->
										<td width="30">&nbsp;</td>
										<cfif get_survey_main.is_manager_0 eq 1><td class="txtbold" style="text-align:center;width:50px;"><cf_get_lang dictionary_id='57576.Çalışan'></td></cfif>
										<cfif get_survey_main.is_manager_3 eq 1><td class="txtbold" style="text-align:center;width:50px;"><cf_get_lang dictionary_id='29908.Görüş Bildiren'></td></cfif>
										<cfif get_survey_main.is_manager_1 eq 1><td class="txtbold" style="text-align:center;width:50px;"><cf_get_lang dictionary_id='35927.Birinci Amir'></td></cfif>
										<cfif get_survey_main.is_manager_4 eq 1><td class="txtbold" style="text-align:center;width:50px;"><cf_get_lang dictionary_id='29909.Ortak Değerlendirme'></td></cfif>
										<cfif get_survey_main.is_manager_2 eq 1><td class="txtbold" style="text-align:center;width:50px;"><cf_get_lang dictionary_id='35921.İkinci Amir'></td></cfif>
									</cfif>
								</tr>
								<!--- //options --->
								<!--- tipi skorlu-yatay olan sorularda kullanilir; belirtilen skor sayisi kadar döndürülür --->
								<cfif get_survey_info.question_type eq 4 and get_survey_info.question_design eq 2 and (survey_chapter_id neq survey_chapter_id[currentrow-1] or get_survey_info.recordcount neq 1)>
									<tr>
										<td>&nbsp;</td>
										<cfloop query="get_survey_chapter_questions_options">
										<td>
										<table>
											<tr>
											<cfloop from="#get_survey_chapter_questions_options.score_rate1#" to="#get_survey_chapter_questions_options.score_rate2#" index="xxx">
												<td style="text-align:center;width:100px">#xxx#</td>
											</cfloop>
											</tr>
										</table>
										</td>
										</cfloop>
									</tr>
								</cfif>
								<!--- //tipi skorlu-yatay olan sorularda kullanilir; belirtilen skor sayisi kadar döndürülür --->
							</cfif>
							<cfif  get_survey_info.question_design eq 2><!--- yatay --->
							<tr>
								<!--- sorular --->
								<td style="width:450px;" class="txtbold">
									<cfset soru_sayisi = soru_sayisi +1> #question_current_row# ) #question_head# <cfif is_required eq 1>*</cfif>
									<cfif len(question_detail)><a href="javascript://"><img src="/images/crm.gif" height="17" width="17" border="0" alt="#question_detail#" title="#question_detail#" align="absmiddle"></a></cfif>
								</td>
								<!--- //sorular --->
								<cfloop query="get_survey_chapter_questions_options">
									<cfquery name="get_survey_question_result" datasource="#dsn#">
										SELECT SURVEY_OPTION_ID,OPTION_POINT,CHAPTER_DETAIL2 FROM SURVEY_QUESTION_RESULT WHERE <cfif len(get_survey_info.survey_question_id)>SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> AND<cfelse>SURVEY_QUESTION_ID IS NULL AND</cfif> SURVEY_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#survey_option_id#"> AND SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#"> 
									</cfquery>
									<cfif get_survey_question_result.recordcount and len(get_survey_question_result.option_point)>
										<cfset chapter_total_point = chapter_total_point+get_survey_question_result.option_point>
									</cfif>											
									<td style="text-align:center;width:65px;">
									<cfswitch expression="#get_survey_info.question_type#">
										<cfcase value="1"><!--- tekli soru tipi --->
											<input type="radio" name="user_answer_#get_survey_info.survey_question_id#" id="user_answer_#get_survey_info.survey_question_id#" value="#survey_option_id#" <cfif ListFind(get_survey_question_result.survey_option_id,survey_option_id,",")> checked</cfif>>
										</cfcase>
										<cfcase value="2"><!--- çoklu soru tipi --->
											<input type="checkbox" name="user_answer_#get_survey_info.survey_question_id#" id="user_answer_#get_survey_info.survey_question_id#" value="#survey_option_id#" <cfif ListFind(get_survey_question_result.survey_option_id,survey_option_id,",")> checked</cfif>>
										</cfcase>
										<cfcase value="4"><!--- skor --->
											<table width="100%" border="0">
												<tr>
													<cfloop from="#get_survey_chapter_questions_options.score_rate1#" to="#get_survey_chapter_questions_options.score_rate2#" index="score_rate">
														<td style="text-align:center"><input type="radio" name="user_answer_#get_survey_info.survey_question_id#_#survey_option_id#" id="user_answer_#get_survey_info.survey_question_id#_#survey_option_id#" value="#score_rate#"<cfif ListFind(get_survey_question_result.option_point,score_rate,",")> checked</cfif>></td>
													</cfloop>
												</tr>
											</table>
										</cfcase>
									</cfswitch>
									</td>
								</cfloop>
								<cfif get_survey_chapter_questions_options.option_note eq 1>
									<cfquery name="get_survey_question_result1" datasource="#dsn#">
										SELECT OPTION_NOTE,CHAPTER_DETAIL2 FROM SURVEY_QUESTION_RESULT WHERE <cfif len(get_survey_info.survey_question_id)>SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> AND<cfelse>SURVEY_QUESTION_ID IS NULL AND</cfif> <!--- SURVEY_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#survey_option_id#">  AND---> SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#"> AND SURVEY_OPTION_ID IS NOT NULL
									</cfquery>
									<td><input type="text" name="add_note_#get_survey_info.survey_question_id#" id="add_note_#get_survey_info.survey_question_id#" value="#get_survey_question_result1.option_note#"></td>
								</cfif>
								<td>&nbsp;</td>
								<cfif get_survey_main.is_manager_0 eq 1>
									<cfquery name="get_question_result_history_emp" datasource="#dsn#" maxrows="1">
										SELECT 
											SURVEY_OPTION_GD_EMP,
											(SELECT OPTION_HEAD FROM SURVEY_OPTION WHERE SURVEY_OPTION_ID = SURVEY_OPTION_ID_EMP) AS SURVEY_OPTION_ID_EMP_,
											SURVEY_OPTION_ID_EMP,
											SURVEY_OPTION_POINT_EMP
										FROM 
											SURVEY_QUESTION_RESULT
										WHERE 
											SURVEY_QUESTION_ID = #get_survey_info.survey_question_id# AND
											SURVEY_MAIN_RESULT_ID = #attributes.result_id# AND
											((SURVEY_OPTION_ID_EMP IS NOT NULL AND SURVEY_OPTION_GD_EMP IS NOT NULL) OR (SURVEY_OPTION_ID_EMP IS NULL AND SURVEY_OPTION_GD_EMP IS NOT NULL))
										ORDER BY 
											RECORD_DATE DESC
									</cfquery>
									<td style="text-align:center;width:50px;">
										<cfif get_question_result_history_emp.survey_option_gd_emp eq 1><b>GD</b><cfelse>#get_question_result_history_emp.SURVEY_OPTION_ID_EMP_#</cfif>
									</td>
								</cfif>
								<cfif get_survey_main.is_manager_3 eq 1>
									<cfquery name="get_result_history_manag3" datasource="#dsn#">
										SELECT 
											SURVEY_OPTION_GD_MANAGER3,
											(SELECT OPTION_HEAD FROM SURVEY_OPTION WHERE SURVEY_OPTION_ID = SURVEY_OPTION_ID_MANAGER3) AS SURVEY_OPTION_ID_MANAGER3_,
											SURVEY_OPTION_ID_MANAGER3,
											SURVEY_OPTION_POINT_MANAGER3
										FROM 
											SURVEY_QUESTION_RESULT
										WHERE 
											SURVEY_QUESTION_ID = #get_survey_info.survey_question_id# AND
											SURVEY_MAIN_RESULT_ID = #attributes.result_id# AND
											((SURVEY_OPTION_ID_MANAGER3 IS NOT NULL AND SURVEY_OPTION_GD_MANAGER3 IS NOT NULL) OR (SURVEY_OPTION_ID_MANAGER3 IS NULL AND SURVEY_OPTION_GD_MANAGER3 IS NOT NULL))
										ORDER BY 
											RECORD_DATE DESC
									</cfquery>
									<td style="text-align:center;width:50px;">
										<cfif get_result_history_manag3.survey_option_gd_manager3 eq 1><b>GD</b><cfelse>#get_result_history_manag3.SURVEY_OPTION_ID_MANAGER3_#</cfif>
									</td>
								</cfif>
								<cfif get_survey_main.is_manager_1 eq 1>
									<cfquery name="get_result_history_manag1" datasource="#dsn#">
										SELECT 
											SURVEY_OPTION_GD_MANAGER1,
											(SELECT OPTION_HEAD FROM SURVEY_OPTION WHERE SURVEY_OPTION_ID = SURVEY_OPTION_ID_MANAGER1) AS SURVEY_OPTION_ID_MANAGER1_,
											SURVEY_OPTION_ID_MANAGER1,
											SURVEY_OPTION_POINT_MANAGER1
										FROM 
											SURVEY_QUESTION_RESULT
										WHERE 
											SURVEY_QUESTION_ID = #get_survey_info.survey_question_id# AND
											SURVEY_MAIN_RESULT_ID = #attributes.result_id# AND 
											((SURVEY_OPTION_ID_MANAGER1 IS NOT NULL AND SURVEY_OPTION_GD_MANAGER1 IS NOT NULL) OR (SURVEY_OPTION_ID_MANAGER1 IS NULL AND SURVEY_OPTION_GD_MANAGER1 IS NOT NULL))
										ORDER BY 
											RECORD_DATE DESC
									</cfquery>
									<td style="text-align:center;width:50px;">
										<cfif get_result_history_manag1.survey_option_gd_manager1 eq 1><b>GD</b><cfelse>#get_result_history_manag1.SURVEY_OPTION_ID_MANAGER1_#</cfif>
									</td>
								</cfif>
								<cfif get_survey_main.is_manager_4 eq 1>
									<cfquery name="get_result_history_manag4" datasource="#dsn#">
										SELECT 
											SURVEY_OPTION_GD_MANAGER4,
											(SELECT OPTION_HEAD FROM SURVEY_OPTION WHERE SURVEY_OPTION_ID = SURVEY_OPTION_ID_MANAGER4) AS SURVEY_OPTION_ID_MANAGER4_,
											SURVEY_OPTION_ID_MANAGER4,
											SURVEY_OPTION_POINT_MANAGER4
										FROM 
											SURVEY_QUESTION_RESULT
										WHERE 
											SURVEY_QUESTION_ID = #get_survey_info.survey_question_id# AND 
											SURVEY_MAIN_RESULT_ID = #attributes.result_id# AND
											((SURVEY_OPTION_ID_MANAGER4 IS NOT NULL AND SURVEY_OPTION_GD_MANAGER4 IS NOT NULL) OR (SURVEY_OPTION_ID_MANAGER4 IS NULL AND SURVEY_OPTION_GD_MANAGER4 IS NOT NULL))
										ORDER BY 
											RECORD_DATE DESC
									</cfquery>
									<td style="text-align:center;width:50px;">
										<cfif get_result_history_manag4.survey_option_gd_manager4 eq 1><b>GD</b><cfelse>#get_result_history_manag4.SURVEY_OPTION_ID_MANAGER4_#</cfif>
									</td>
								</cfif>
								<cfif get_survey_main.is_manager_2 eq 1>
									<cfquery name="get_result_history_manag2" datasource="#dsn#">
										SELECT 
											SURVEY_OPTION_GD_MANAGER2,
											(SELECT OPTION_HEAD FROM SURVEY_OPTION WHERE SURVEY_OPTION_ID = SURVEY_OPTION_ID_MANAGER2) AS SURVEY_OPTION_ID_MANAGER2_,
											SURVEY_OPTION_ID_MANAGER2,
											SURVEY_OPTION_POINT_MANAGER2
										FROM 
											SURVEY_QUESTION_RESULT
										WHERE 
											SURVEY_QUESTION_ID = #get_survey_info.survey_question_id# AND
											SURVEY_MAIN_RESULT_ID = #attributes.result_id# AND
											((SURVEY_OPTION_ID_MANAGER2 IS NOT NULL AND SURVEY_OPTION_GD_MANAGER2 IS NOT NULL) OR (SURVEY_OPTION_ID_MANAGER2 IS NULL AND SURVEY_OPTION_GD_MANAGER2 IS NOT NULL))
										ORDER BY 
											RECORD_DATE DESC
									</cfquery>
									<td style="text-align:center;width:50px;">
										<cfif get_result_history_manag2.survey_option_gd_manager2 eq 1><b>GD</b><cfelse>#get_result_history_manag2.SURVEY_OPTION_ID_MANAGER2_#</cfif>
									</td>
								</cfif>
							</tr>
							<cfelse>
							<!--- dikey --->
								<!--- sorular --->
								<tr>
									<td style="width:450px;" class="txtbold">
										#question_current_row# ) #question_head# <cfif is_required eq 1>*</cfif>
										<cfif len(question_detail)><a href="javascript://"><img src="/images/crm.gif" height="17" width="17" border="0" alt="#question_detail#" title="#question_detail#" align="absmiddle"></a></cfif>
									</td>
								</tr>
								<!--- //sorular --->
								<cfloop query="get_survey_chapter_questions_options">
									<cfquery name="get_survey_question_result" datasource="#dsn#">
										SELECT SURVEY_OPTION_ID,OPTION_POINT,CHAPTER_DETAIL2 FROM SURVEY_QUESTION_RESULT WHERE <cfif len(get_survey_info.survey_question_id)>SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> AND<cfelse>SURVEY_QUESTION_ID IS NULL AND</cfif> SURVEY_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#survey_option_id#"> AND SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">
									</cfquery>
									<tr>
										<td>
											<cfswitch expression="#get_survey_info.question_type#">
												<cfcase value="1"><!--- tekli soru tipi --->
													<input type="radio" name="user_answer_#get_survey_info.survey_question_id#" id="user_answer_#get_survey_info.survey_question_id#" value="#survey_option_id#" <cfif ListFind(get_survey_question_result.survey_option_id,survey_option_id,",")> checked</cfif>>
													#get_survey_chapter_questions_options.option_head#
												</cfcase>
												<cfcase value="2"><!--- çoklu soru tipi --->
													<input type="checkbox" name="user_answer_#get_survey_info.survey_question_id#" id="user_answer_#get_survey_info.survey_question_id#" value="#survey_option_id#"<cfif ListFind(get_survey_question_result.survey_option_id,survey_option_id,",")> checked</cfif>>
													#get_survey_chapter_questions_options.option_head#
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
															 <td style="width:400px;" valign="top" class="txtbold">#OPTION_HEAD#</td>
															 <td>#get_survey_question_result.OPTION_HEAD#</td>
														</tr>
														<cfif len(get_survey_question_result.OPTION_HEAD_EMP)>
														<tr>
															<td><cf_get_lang dictionary_id='57576.Çalışan'></td>
															<td>#get_survey_question_result.OPTION_HEAD_EMP#</td>
														</tr>
														</cfif>
														<cfif len(get_survey_question_result.OPTION_HEAD_MANAGER3)>
														<tr>
															<td><cf_get_lang dictionary_id='29908.Görüş Bildiren'></td>
															<td>#get_survey_question_result.OPTION_HEAD_MANAGER3#</td>
														</tr>
														</cfif>
														<cfif len(get_survey_question_result.OPTION_HEAD_MANAGER1)>
														<tr>
															<td><cf_get_lang dictionary_id='35927.Birinci Amir'></td>
															<td>#get_survey_question_result.OPTION_HEAD_MANAGER1#</td>
														</tr>
														</cfif>
														<cfif len(get_survey_question_result.OPTION_HEAD_MANAGER2)>
														<tr>
															<td><cf_get_lang dictionary_id='35921.İkinci Amir'></td>
															<td>#get_survey_question_result.OPTION_HEAD_MANAGER2#</td>
														</tr>
														</cfif>
														<cfif len(get_survey_question_result.OPTION_HEAD_MANAGER4)>
														<tr>
															<td><cf_get_lang dictionary_id='29909.Ortak Değerlendirme'></td>
															<td>#get_survey_question_result.OPTION_HEAD_MANAGER4#</td>
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
										</td>
									</tr>
								</cfloop>
								<cfif get_survey_chapter_questions_options.option_note eq 1>
								<tr>
									<cfquery name="get_survey_question_result1" datasource="#dsn#">
										SELECT OPTION_NOTE,CHAPTER_DETAIL2 FROM SURVEY_QUESTION_RESULT WHERE <cfif len(get_survey_info.survey_question_id)>SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> AND<cfelse>SURVEY_QUESTION_ID IS NULL AND</cfif> SURVEY_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_chapter_questions_options.survey_option_id#"> AND SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#"> AND SURVEY_OPTION_ID IS NOT NULL
									</cfquery>
									<td><input type="text" name="add_note_#get_survey_info.survey_question_id#" id="add_note_#get_survey_info.survey_question_id#" value="#get_survey_question_result1.option_note#"></td>
								</tr>
								</cfif>
							</cfif>
							<cfswitch expression="#get_survey_info.question_type#">
								<cfcase value="3"><!--- açik uçlu --->
								<tr>
									<td>
									<table width="100%" border="0" id="add_new_option_#get_survey_info.survey_question_id#">
										<cfloop query="get_survey_chapter_questions_options">
										<cfquery name="get_survey_question_result" datasource="#dsn#">
											SELECT SURVEY_OPTION_ID,OPTION_POINT,OPTION_HEAD,CHAPTER_DETAIL2 FROM SURVEY_QUESTION_RESULT WHERE <cfif len(get_survey_info.survey_question_id)>SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"> AND<cfelse>SURVEY_QUESTION_ID IS NULL AND</cfif> SURVEY_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#survey_option_id#"> AND SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">
										</cfquery>
										<tr id="add_new_option_row_#get_survey_info.survey_question_id#_#currentrow#">
											 <td width="200">#OPTION_HEAD#</td>
											<td><input type="text" name="user_answer_#get_survey_info.survey_question_id#_#survey_option_id#" id="user_answer_#get_survey_info.survey_question_id#_#survey_option_id#" value="#get_survey_question_result.OPTION_HEAD#"></td>
										</tr>
										</cfloop>
									</table>
									</td>
								</tr>
								</cfcase>
							</cfswitch>
							<cfset question_current_row = question_current_row + 1>
						
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
								<cfif get_main_result_info.action_type eq 8>
									<cfif get_chapter_result.recordcount>
										<cfif len(get_chapter_result.emp_expl)>
											<tr>
												<td valign="top" style="width:400px;"><b><cf_get_lang dictionary_id='57576.Çalışan'> <cf_get_lang dictionary_id='57629.Açıklama'></b></td>
												<td>&nbsp;#get_chapter_result.EMP_EXPL#</td>
											</tr>
										</cfif>
										<cfif len(get_chapter_result.MANAGER3_EXPL)>
											<tr>
												<td valign="top" style="width:400px;"><b><cf_get_lang dictionary_id ='29908.Görüş Bildiren'> <cf_get_lang dictionary_id='57629.Açıklama'></b></td>
												<td>&nbsp;#get_chapter_result.MANAGER3_EXPL#</td>
											</tr>
										</cfif>
										<cfif len(get_chapter_result.MANAGER1_EXPL)>
											<tr>
												<td valign="top" style="width:400px;"><b><cf_get_lang dictionary_id='35927.Birinci Amir'> <cf_get_lang dictionary_id='57629.Açıklama'></b></td>
												<td>&nbsp;#get_chapter_result.MANAGER1_EXPL#</td>
											</tr>
										</cfif>
										<cfif len(get_chapter_result.MANAGER4_EXPL)>
											<tr>
												<td valign="top" style="width:400px;"><b><cf_get_lang dictionary_id='29909.Ortak Değerlendirme'> <cf_get_lang dictionary_id='57629.Açıklama'></b></td>
												<td>&nbsp;#get_chapter_result.MANAGER4_EXPL#</td>
											</tr>
										</cfif>
										<cfif len(get_chapter_result.MANAGER2_EXPL)>
											<tr>
												<td valign="top" style="width:400px;"><b><cf_get_lang dictionary_id='35921.İkinci Amir'> <cf_get_lang dictionary_id='57629.Açıklama'></b></td>
												<td>&nbsp;#get_chapter_result.MANAGER2_EXPL#</td>
											</tr>
										</cfif>
									</cfif>
								<cfelse>
									<tr>
										<td valign="top">#get_survey_info.survey_chapter_detail2#</td>
										<td>#chapter_detail_expl#</td>
									</tr>
								</cfif>
							</table>
							</td>
						</tr>
					</cfif>
					<cfset chapter_current_row = chapter_current_row + 1>
					<cfif survey_chapter_id neq survey_chapter_id[currentrow-1]> 
						<cfif len(chapter_weight) and (max_point_survey*soru_sayisi) gt 0 and len(chapter_total_point*chapter_weight)>
							<cfset all_chapter_total_point = all_chapter_total_point+(chapter_total_point*chapter_weight/(max_point_survey*soru_sayisi))>
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
					<cf_box_elements>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='29883.Form Bilgileri'></cfsavecontent>
					<cf_seperator id='detail' title="#message#">


					<div class="row" id="detail">
						<div class="col col-12">
							<div class="col col-6 col-xs-12">
								<cfif get_main_result_info.action_type eq 8>
                                    <div class="form-group">
                                        <label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='57576.Çalışan'> : </label>
                                        <label class="col col-8 col-xs-12">#get_emp_info(get_main_result_info.action_id,0,0)#</label>
                                    </div>
                                    <div class="form-group">
                                        <cfif get_survey_main.is_manager_3 eq 1>
                                        <label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id ='29908.Görüş Bildiren'> : </label>
                                        <label class="col col-8 col-xs-12">#get_emp_info(manager3_emp_id,0,0,0)#</label>
                                        </cfif>
                                    </div>
                                </cfif>
                                <div class="form-group">
                                    <label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='57658.Üye'> : </label>
                                    <label class="col col-8 col-xs-12">
                                        <cfif len(partner_id)>
                                            <cfset company_name=get_par_info(get_main_result_info.partner_id,0,1,0)>
                                            <cfset partner_name=get_par_info(get_main_result_info.partner_id,0,-1,0)>
                                        <cfelseif len(consumer_id)>
                                            <cfquery name="GET_CONSUMER_NAME" datasource="#dsn#">
                                                SELECT COMPANY FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#consumer_id#">
                                            </cfquery>
                                            <cfset company_name=get_consumer_name.COMPANY>
                                            <cfset partner_name=get_cons_info(consumer_id,0,0,0)>
                                        </cfif>
                                        <cfif isdefined('company_name') and len(company_name)>#company_name#</cfif>
                                    </label>
                                </div>
								<div class="form-group">
									<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='29804.Uygulayan'> : </label>
									<label class="col col-8 col-xs-12"><cfif isdefined('partner_name') and len(partner_name)>#partner_name#</cfif></label>
								</div>
								<div class="form-group">
									<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='57576.Çalışan'> : </label>
									<label class="col col-8 col-xs-12">#get_emp_info(get_main_result_info.emp_id,0,0)#</label>
								</div>
								<div class="form-group">
									<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='57742.Tarih'> : </label>
									<label class="col col-8 col-xs-12">#dateformat(get_main_result_info.start_date,dateformat_style)#</label>
								</div>
								<div class="form-group">
									<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='57422.Notlar'> : </label>
									<label class="col col-8 col-xs-12">#get_main_result_info.result_note#</label>
								</div>	
								<div class="form-group">
									<label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='29805.Yorum'> : </label>
									<label class="col col-8 col-xs-12">#comment#</label>
								</div>
							</div>
							<div class="col col-6 col-xs-12">
								<cfif get_main_result_info.action_type eq 8><!--- performans formu ise amir bilgileri gelsin--->
                                    <div class="form-group">
                                        <cfif get_survey_main.is_manager_1 eq 1>
                                        <label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='35927.Birinci Amir'> : </label>
                                        <label class="col col-8 col-xs-12">#get_emp_info(get_main_result_info.manager1_emp_id,0,0,0)#</label>
                                        </cfif>
                                    </div>
                                    <div class="form-group">
                                        <cfif get_survey_main.is_manager_2 eq 1>
                                            <label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='35921.İkinci Amir'> : </label>
                                            <label class="col col-8 col-xs-12">#get_emp_info(manager2_emp_id,0,0,0)#</label>
                                        </cfif>
                                    </div>	
                                </cfif>
                                <div class="form-group">
                                    <label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='58984.Puan'> : </label>
                                    <label class="col col-8 col-xs-12">
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
                                            #TlFormat(user_point_)# / 100
                                        <cfelse>
                                            <cfif len(get_main_result_info.score_result)>
                                                <!--- #TlFormat((all_chapter_total_point*get_survey_main.total_score)/100)# --->
                                                #TlFormat(get_main_result_info.score_result)#
                                            <cfelse>
                                            </cfif>
                                        </cfif>
                                    </label>
                                </div>
                                <cfif get_main_result_info.action_type eq 8>
                                    <cfif len(get_main_result_info.score_result_emp) and get_survey_main.is_manager_0 is 1>
                                    <div class="form-group">
                                        <label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='57576.Çalışan'> : </label>
                                        <label class="col col-8 col-xs-12">#TlFormat(get_main_result_info.score_result_emp)#</label>
                                    </div>
                                    </cfif>
                                    <cfif len(get_main_result_info.score_result_manager3) and get_survey_main.is_manager_3 is 1>
                                    <div class="form-group">
                                        <label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='29908.Görüş Bildiren'> : </label>
                                        <label class="col col-8 col-xs-12">#TlFormat(get_main_result_info.score_result_manager3)#</label>
                                    </div>
                                    </cfif>
                                    <cfif len(get_main_result_info.score_result_manager1) and get_survey_main.is_manager_1 is 1>
                                    <div class="form-group">
                                        <label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='35927.Birinci Amir'> : </label>
                                        <label class="col col-8 col-xs-12">#TlFormat(get_main_result_info.score_result_manager1)#</label>
                                    </div>
                                    </cfif>
                                    <cfif len(get_main_result_info.score_result_manager4) and get_survey_main.is_manager_4 is 1>
                                    <div class="form-group">
                                        <label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='29909.Ortak Değerlendirme'> : </label>
                                        <label class="col col-8 col-xs-12">#TlFormat(get_main_result_info.score_result_manager4)#</label>
                                    </div>
                                    </cfif>
                                    <cfif len(get_main_result_info.score_result_manager2) and get_survey_main.is_manager_2 eq 1>
                                    <div class="form-group">
                                        <label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='35921.İkinci Amir'> :</label>
                                        <label class="col col-8 col-xs-12">#TlFormat(get_main_result_info.score_result_manager2)#</label>
                                    </div>
                                    </cfif>
                                </cfif>
                                <div class="form-group">
                                    <label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='58909.Max'> <cf_get_lang dictionary_id='58984.Puan'>- <cf_get_lang dictionary_id='29774.uygunluk sınırı'> :</label>
                                    <label class="col col-8 col-xs-12"> #get_survey_main.total_score#-#get_survey_main.average_score#</label>
                                </div>
							</div>
						</div>
					</div>
				</cf_box_elements>
					</td>
				</tr>
			<cfelse>
				<tr style="display:none;">
					<td>#dateformat(get_main_result_info.start_date,dateformat_style)#</td>
				</tr>
			</cfif>
		</cfoutput>
		<cfelse>
			<tr>
				<td><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
			</tr>
		</cfif>
	</table>
	<cf_box_footer>
		
					<cfif get_survey_main.IS_NOT_SHOW_SAVED eq 0>
                		<cf_record_info query_name="get_main_result_info">
                  	</cfif>
           
	</cf_box_footer>
</cf_box>
</cfif>
