<cfparam name="attributes.consumer_reference_code" default=""> 
<cfparam name="attributes.company_id" default=""> 
<cfparam name="attributes.consumer_id" default="">
<cfset title_box="">
<cfif isdefined('attributes.fbx') and attributes.fbx eq 'myhome'>
    <cfset attributes.survey_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.survey_id,accountKey:session.ep.userid)>
    <cfset attributes.action_type_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.action_type_id,accountKey:session.ep.userid)>
</cfif>
<cfif not (isdefined("attributes.employee_id") and Len(attributes.employee_id))>
	<cfset attributes.employee_id = session.ep.userid>
</cfif>
<cfsetting showdebugoutput="no">
<cfquery name="get_survey_main" datasource="#dsn#">
	SELECT 
		SURVEY_MAIN_HEAD,
		SURVEY_MAIN_DETAILS ,
		PROCESS_ID,
		IS_MANAGER_0,
		IS_MANAGER_1,
		IS_MANAGER_2,
		IS_MANAGER_3,
		IS_MANAGER_4,
		TYPE,
		START_DATE AS STARTDATE,
		FINISH_DATE,
		IS_SELECTED_ATTENDER
	FROM 
		SURVEY_MAIN 
	WHERE 
		SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
</cfquery>
<!--- memnuniyet anketi kontrolü SG 20131129--->
<cfif get_survey_main.type eq 14 and isdefined('attributes.is_portal')>
	<cfquery name="get_control" datasource="#dsn#">
		SELECT
			SURVEY_MAIN_RESULT_ID
		FROM
			SURVEY_MAIN_RESULT
		WHERE
			SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#"> AND
			EMPLOYEE_EMAIL = '#attributes.control_value#'
	</cfquery>
	<cfif get_control.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='59896.Bu anketi daha önce doldurdunuz'>!");
			window.close();
		</script>
		<cfabort>
	</cfif>		
</cfif>
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
		SC.SURVEY_CHAPTER_WEIGHT,
		SC.IS_SHOW_GD,
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
</cfquery>
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
<cfelse>
	<cfset attributes.start_date = wrk_get_today()>
</cfif>

<cfset head = "">
<cfset action_type_="">
<cfoutput>
	<!---Fırsat --->
	<cfsavecontent  variable="action_type_">
	<cfif get_survey_main.type eq 1>
		<cfif isdefined("attributes.action_type_id") and len(attributes.action_type_id)>
			<cfquery name="get_opp" datasource="#dsn3#">
				SELECT OPP_HEAD AS RELATION_HEAD FROM OPPORTUNITIES WHERE OPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type_id#">
			</cfquery>
			<cfset head=get_opp.RELATION_HEAD>
		</cfif>
		<cf_get_lang dictionary_id='57612.Fırsat'>
		
		<cfset action_type_="">
	<!--- İçerik--->
	<cfelseif get_survey_main.type eq 2>
		<cfif isdefined("attributes.action_type_id") and len(attributes.action_type_id)>
			<cfquery name="get_content" datasource="#dsn#">
				SELECT CONT_HEAD AS RELATION_HEAD FROM CONTENT WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type_id#">
			</cfquery>
			<cfset head=get_content.RELATION_HEAD>
		</cfif>
		<cf_get_lang dictionary_id='57653.İçerik'>
	<!---kampanya --->
	<cfelseif get_survey_main.type eq 3>
		<cfif isdefined("attributes.action_type_id") and len(attributes.action_type_id)>
			<cfquery name="get_campaign" datasource="#dsn3#">
				SELECT CAMP_HEAD AS RELATION_HEAD FROM CAMPAIGNS WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type_id#">
			</cfquery>
			<cfset head=get_campaign.RELATION_HEAD>
		</cfif>
		<cf_get_lang dictionary_id='57446.Kampanya'>
	<!--- ürün--->
	<cfelseif get_survey_main.type eq 4>
		<cfif isdefined("attributes.action_type_id") and len(attributes.action_type_id)>
			<cfquery name="get_product" datasource="#dsn3#">
				SELECT PRODUCT_NAME AS RELATION_HEAD FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type_id#">
			</cfquery>
			<cfset head=get_product.RELATION_HEAD>
		</cfif>
		<cf_get_lang dictionary_id='57657.Ürün'>
	<!--- proje--->
	<cfelseif get_survey_main.type eq 5>
		<cfif isdefined("attributes.action_type_id") and len(attributes.action_type_id)>
			<cfquery name="get_project" datasource="#dsn#">
				SELECT PROJECT_HEAD AS RELATION_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type_id#">
			</cfquery>
			<cfset head=get_project.RELATION_HEAD>
		</cfif>
		<cf_get_lang dictionary_id='57416.Proje'>
	<!--- iş--->
	<cfelseif get_survey_main.type eq 11>
		<cfif isdefined("attributes.action_type_id") and len(attributes.action_type_id)>
			<cfquery name="get_work" datasource="#dsn#">
				SELECT WORK_HEAD AS RELATION_HEAD FROM PRO_WORKS WHERE WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type_id#">
			</cfquery>
			<cfset head=get_work.RELATION_HEAD>
		</cfif>
		<cf_get_lang dictionary_id='58445.İş'>
	<!---deneme süresi --->
	<cfelseif get_survey_main.type eq 6>
		<cf_get_lang dictionary_id='29776.Deneme Süresi'>
		<!--- <cfset head=get_emp_info(get_main_result_info.action_id,0,0)> --->
	<!--- işe alım--->
	<cfelseif get_survey_main.type eq 7>
		<cfif isdefined("attributes.action_type_id") and len(attributes.action_type_id)>
			<cfquery name="get_cv" datasource="#dsn#">
				SELECT NAME+' '+SURNAME AS RELATION_HEAD FROM EMPLOYEES_APP WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type_id#">
			</cfquery>
			<cfset head=get_cv.RELATION_HEAD>
		</cfif>
		<cf_get_lang dictionary_id='57996.İşe Alım'>
	<!--- Performans--->
	<cfelseif get_survey_main.type eq 8>
		<cf_get_lang dictionary_id='58003.Performans'>
		<cfif isdefined("attributes.action_type_id") and len(attributes.action_type_id)>
			<cfset head=get_emp_info(attributes.action_type_id,0,0)>
		</cfif>
	<!--- eğitim--->
	<cfelseif get_survey_main.type eq 9>
		<cfif isdefined("attributes.action_type_id") and len(attributes.action_type_id)>
			<cfquery name="get_class" datasource="#dsn#">
				SELECT CLASS_NAME AS RELATION_HEAD FROM TRAINING_CLASS WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type_id#">
			</cfquery>
			<cfset head=get_class.RELATION_HEAD>
		</cfif>
		<cf_get_lang dictionary_id='57419.Eğitim'>
	<cfelseif get_survey_main.type eq 16>
		<cfif isdefined("attributes.action_type_id") and len(attributes.action_type_id)>
			<cfquery name="get_organization" datasource="#dsn#">
				SELECT ORGANIZATION_HEAD AS RELATION_HEAD FROM ORGANIZATION WHERE ORGANIZATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type_id#">
			</cfquery>
			<cfset head=get_organization.RELATION_HEAD>
		</cfif>
		<cf_get_lang dictionary_id='29465.Etkinlik'>
	<!--- işten çıkış çalışan--->
	<cfelseif get_survey_main.type eq 10> 
		<cfif isdefined("attributes.action_type_id") and len(attributes.action_type_id)>
			<cfset head=get_emp_info(attributes.action_type_id,0,0)>
		</cfif>
		<cf_get_lang dictionary_id='29832.İşten Çıkış'>
	<!--- satış teklif --->
	<cfelseif get_survey_main.type eq 12> 
		<cfif isdefined("attributes.action_type_id") and len(attributes.action_type_id)>
			<cfset head=get_emp_info(attributes.action_type_id,0,0)>
		</cfif>
		<cf_get_lang dictionary_id='57545.Teklif'>
	<!--- satış sipariş --->
	<cfelseif get_survey_main.type eq 13> 
		<cfif isdefined("attributes.action_type_id") and len(attributes.action_type_id)>
			<cfset head=get_emp_info(attributes.action_type_id,0,0)>
		</cfif>
		<cf_get_lang dictionary_id='57611.Sipariş'>
	<cfelseif get_survey_main.type eq 14>
		Anket

	<!--- <cfif isDefined("get_main_result_info.action_type")>
	<cfelseif get_main_result_info.action_type eq 15> 
		<cf_get_lang_main no='2251.Satınalma Teklifleri'><cfset head=get_emp_info(get_main_result_info.action_id,0,0)>
		</cfif> --->
	<!---	Satınalma Teklifleri 	--->
	<cfelseif get_survey_main.type eq 15> 
		<cf_get_lang dictionary_id='30048.Satınalma Teklifleri'>
			<!--- <cfset head=get_emp_info(attributes.action_type_id,0,0)> --->
		
	<cfelseif attributes.action_type_id eq 16> 
		<cf_get_lang dictionary_id='29465.Etkinlik'><cfset head=get_emp_info(attributes.action_type_id,0,0)>
	<!--- Mal Kabul --->
	<cfelseif attributes.action_type_id eq 17> 
		<cf_get_lang dictionary_id='60095.Mal Kabul'><cfset head=get_emp_info(attributes.action_type_id,0,0)>
	<!--- Sevkiyat --->
	<cfelseif attributes.action_type_id eq 18> 
		<cf_get_lang dictionary_id='45452.Sevkiyat'><cfset head=get_emp_info(attributes.action_type_id,0,0)>
	<!--- Call Center --->
	<cfelseif attributes.action_type_id eq 19> 
		<cf_get_lang dictionary_id='57438.Call Center'><cfset head=get_emp_info(attributes.action_type_id,0,0)>
	
	</cfif>
	
	</cfsavecontent>

</cfoutput>

<!--- <cfif len(get_survey_main.survey_main_details)>
	<cfset title_ = '#get_survey_main.survey_main_details#<br/><br/>'>
<cfelse>
	<cfset title_="">
</cfif> --->
<!---<cf_catalystHeader>--->
<cf_box title="#get_survey_main.survey_main_head#" closable="0" print_href="#isdefined('session.ep')? "#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.survey_id#&action_row_id=0":""#">
 <cfform name="survey_main_result" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_detailed_survey_main_result">	
    <input type="hidden" name="is_selected_attender" id="is_selected_attender" value="<cfoutput>#get_survey_main.is_selected_attender#</cfoutput>">
	<cfif get_survey_main.type eq 9 and get_survey_main.is_selected_attender eq 1>
		<div class="form-group" id="item-user_type">
			<label class="col col-4  col-md-4 col-xs-12"><cf_get_lang dictionary_id='29780.Katılımcı'> *</label>
			<div class="col col-8  col-md-8 col-xs-12">
				<div class="input-group">
					<input type="hidden" name="user_type" value="">
					<input type="hidden" name="user_id" id="user_id" value="">
					<input type="text" name="user_name" id="user_name" value="">
					<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_training_attenders&field_id=survey_main_result.user_id&field_name=survey_main_result.user_name&field_user_type=survey_main_result.user_type&class_id=#attributes.action_type_id#</cfoutput>','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
				</div>
			</div>
		</div>
	</cfif>
    <cfif get_survey_info.recordcount>
        <cfif isdefined('attributes.control_value')>
			<input type="hidden" name="control_value" id="control_value" value="<cfoutput>#attributes.control_value#</cfoutput>">
		</cfif>
		<input type="hidden" name="survey_id" id="survey_id" value="<cfoutput>#attributes.survey_id#</cfoutput>">
        <input type="hidden" name="empapp_id" id="empapp_id" value="<cfif isdefined("attributes.empapp_id")><cfoutput>#attributes.empapp_id#</cfoutput></cfif>">
        <cfif fuseaction contains 'popup'>
        <input type="hidden" name="is_popup" id="is_popup" value="<cfoutput>#attributes.is_popup#</cfoutput>"></cfif>
        <input type="hidden" name="action_type_id" id="action_type_id" value="<cfif isdefined('attributes.action_type_id') and len(attributes.action_type_id)><cfoutput>#attributes.action_type_id#</cfoutput></cfif>">
        <input type="hidden" name="action_type" id="action_type" value="<cfoutput><cfif isdefined('attributes.action_type') and len(attributes.action_type)>#attributes.action_type#<cfelseif len(get_survey_main.type)>#get_survey_main.type#</cfif></cfoutput>">
		<cfset chapter_current_row = 1>
			<cfoutput query="get_survey_info" group="survey_chapter_id">
				<cfif isdefined('attributes.is_portal')>
				&nbsp;<b>#chapter_current_row# : #survey_chapter_head#</b>
				<cfelse>
					<cf_seperator id='chapter_#chapter_current_row#' title='Bölüm #chapter_current_row# : #survey_chapter_head# (#getLang('','FormTipi','56000')#: #action_type_#)'>
				</cfif>
				
					<table id='chapter_#chapter_current_row#' width="50%">
						<cf_box_elements>	
						<cfif len(survey_chapter_detail)>
							<tr>
								<label><cf_get_lang dictionary_id="57629.Açıklama"> : #survey_chapter_detail#</label>
							</tr>  
						</cfif>
						<cfset question_current_row = 1>
							<tr>
								<td>
									<table>
									<cfquery name="get_survey_option_max" datasource="#dsn#">
										SELECT MAX(OPTION_POINT) AS MAX_OPTION_POINT FROM SURVEY_OPTION WHERE SURVEY_CHAPTER_ID = #get_survey_info.SURVEY_CHAPTER_ID#
									</cfquery>
									<cfset max_point_survey = get_survey_option_max.MAX_OPTION_POINT>
									<cfoutput>
										<cfquery name="get_opt_question_id" datasource="#dsn#">
											SELECT SURVEY_QUESTION_ID,QUESTION_TYPE FROM SURVEY_OPTION WHERE SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#">
										</cfquery>
										<cfquery name="get_opt_question_id_" datasource="#dsn#">
											SELECT SURVEY_QUESTION_ID,QUESTION_TYPE FROM SURVEY_OPTION WHERE SURVEY_QUESTION_ID IS NULL  AND SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_chapter_id#">
										</cfquery>
										<cfquery name="get_survey_chapter_questions_options" datasource="#dsn#">
											SELECT SURVEY_OPTION_ID,SURVEY_QUESTION_ID,OPTION_HEAD,OPTION_NOTE,SCORE_RATE1,SCORE_RATE2 FROM SURVEY_OPTION WHERE <cfif len(get_survey_info.survey_question_id) and len(get_opt_question_id.SURVEY_QUESTION_ID)>SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_question_id#"><cfelse>SURVEY_QUESTION_ID IS NULL</cfif> AND SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_survey_info.survey_chapter_id#"> ORDER BY SURVEY_OPTION_ID
										</cfquery>
										<cfif get_survey_info.question_type eq 3><!--- Acik uclu soruda satir sayisinin artirilabilirligi icin kullaniliyor --->
											<cfif len(get_survey_chapter_questions_options.survey_option_id)>
												<cfset Record_ = get_survey_chapter_questions_options.recordcount / ListLen(ListDeleteDuplicates(ValueList(get_survey_chapter_questions_options.survey_option_id)))>
											<cfelse>
												<cfset Record_ = get_survey_chapter_questions_options.recordcount>
											</cfif>
											<input type="hidden" name="record_num_result_#survey_question_id#" id="record_num_result_#survey_question_id#" value=""><!--- #Record_# --->
										</cfif>
										<cfif len(get_survey_info.question_image_path)>
										<tr>
											<td>
												<table width="100%">
													<tr>
														<td><cf_get_server_file output_file="helpdesk/#dir_seperator##get_survey_info.question_image_path#" output_server="1" output_type="0" image_width = "100" image_height="50"></td>
													</tr> 
												</table>
											</td>
										</tr>
										</cfif>
										<cfif get_survey_info.question_type neq 3>
											<!--- options-yatay ise once siklar yazilir --->
											<cfif get_survey_info.question_design eq 2 and (survey_chapter_id neq survey_chapter_id[currentrow-1] or len(get_survey_chapter_questions_options.survey_question_id))>
											<tr valign="top">
												<td>&nbsp;</td>
												<td  style="text-align:center"><cfif get_survey_info.is_show_gd eq 1 or get_survey_info.question_gd eq 1>GD</cfif></td>
												<cfloop query="get_survey_chapter_questions_options">
													<td  style="text-align:center">#get_survey_chapter_questions_options.option_head#</td>
												</cfloop>
											</tr>
											</cfif>
											<!--- //options-yatay ise once siklar yazilir --->
											<!--- tipi skorlu-yatay olan sorularda kullanılır; belirtilen skor sayısı kadar döndürülür ---> 
											<!--- <cfif get_survey_info.question_type eq 4 and get_survey_info.question_design eq 2 and (survey_chapter_id neq survey_chapter_id[currentrow-1] or get_opt_question_id_.recordcount eq 0)>
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
											</cfif> --->
											<!--- //tipi skorlu-yatay olan sorularda kullanılır; belirtilen skor sayısı kadar döndürülür --->
										</cfif>
										<cfif get_survey_info.question_design eq 2><!--- yatay --->
										<tr>
											<!--- sorular --->
											<div class="form-group">
											<td style="width:450px;" >
												
												#question_current_row#. #question_head# <cfif is_required eq 1>*</cfif>
												<cfif len(question_detail)><a href="javascript://"><img src="/images/crm.gif" height="17" width="17" border="0" alt="#question_detail#" title="#question_detail#" align="absmiddle"></a></cfif>
										
											</td>		</div>	
											<!--- //sorular --->
											<td style="text-align:center;width:65px;">
												<cfif get_survey_info.is_show_gd eq 1 or get_survey_info.question_gd eq 1>
												<input name="user_answer_#get_survey_info.survey_question_id#" id="user_answer_#get_survey_info.survey_question_id#" type="radio" value="-1">
												</cfif>
											</td>
											<cfloop query="get_survey_chapter_questions_options">
												<td style="text-align:center;width:65px;">
												<cfswitch expression="#get_survey_info.question_type#">
													<cfcase value="1"><!--- tekli soru tipi --->
														<input type="radio" name="user_answer_#get_survey_info.survey_question_id#" id="user_answer_#get_survey_info.survey_question_id#" value="#survey_option_id#">
													</cfcase>
													<cfcase value="2"><!--- çoklu soru tipi --->
														<input type="checkbox" name="user_answer_#get_survey_info.survey_question_id#" id="user_answer_#get_survey_info.survey_question_id#" value="#survey_option_id#">
													</cfcase>
													<!--- <cfcase value="4"><!--- skor --->
														<table width="100%" border="0" class="color-list">
															<tr>
																<cfloop from="#get_survey_chapter_questions_options.score_rate1#" to="#get_survey_chapter_questions_options.score_rate2#" index="score_rate">
																	<td style="text-align:center;"><input type="radio" name="user_answer_#get_survey_info.survey_question_id#_#survey_option_id#" id="user_answer_#get_survey_info.survey_question_id#_#survey_option_id#" value="#score_rate#"></td>
																</cfloop>
															</tr>
														</table>
													</cfcase> --->
												</cfswitch>
												</td>
											</cfloop>
											<!--- <cfif get_survey_chapter_questions_options.option_note eq 1>
												<td><input type="text" name="add_note_#get_survey_chapter_questions_options.survey_question_id#" id="add_note_#get_survey_chapter_questions_options.survey_question_id#" value=""></td>
											</cfif> --->
										</tr>
										<cfelse><!--- dikey --->
											<!--- sorular --->
										<tr>
										<td>
												<div class="col col-12">
													<cfif is_required eq 1>#question_current_row#. #question_head# *</cfif>
													<cfif len(question_detail)><a href="javascript://"><img src="/images/crm.gif" height="17" width="17" border="0" alt="#question_detail#" title="#question_detail#" align="absmiddle"></a></cfif>
												</div>
											</td>
											</tr>
											<!--- //sorular --->
											<cfloop query="get_survey_chapter_questions_options"> 
												<tr>
												<td>
													<cfswitch expression="#get_survey_info.question_type#">
														<cfcase value="1"><!--- tekli soru tipi --->
															<div class="form-group">
																<input type="radio" name="user_answer_#get_survey_info.survey_question_id#" id="user_answer_#get_survey_info.survey_question_id#" value="#survey_option_id#">
																<label>#get_survey_chapter_questions_options.option_head#</label>
															</div>
														</cfcase>
														<cfcase value="2"><!--- çoklu soru tipi --->
															<div class="form-group">
																<input type="checkbox" name="user_answer_#get_survey_info.survey_question_id#" id="user_answer_#get_survey_info.survey_question_id#" value="#survey_option_id#">
																<label>#get_survey_chapter_questions_options.option_head#</label>
															</div>
														</cfcase>
													<!---  <cfcase value="4"><!--- skor --->
															<table width="100%" border="0">
																<tr>
																	<td><select name="user_answer_#get_survey_info.survey_question_id#_#survey_option_id#" id="user_answer_#get_survey_info.survey_question_id#_#survey_option_id#" style="width:40px;">
																			<cfloop from="#get_survey_chapter_questions_options.score_rate1#" to="#get_survey_chapter_questions_options.score_rate2#" index="score_rate">
																				<option value="#score_rate#">#score_rate#</option>
																			</cfloop>
																		</select>
																	</td>
																</tr>
															</table>
														</cfcase> --->
													</cfswitch>
												</td>
												</tr>
											
											</cfloop>
										</cfif>
										<cfswitch expression="#get_survey_info.question_type#">
											<cfcase value="3"><!--- açık uçlu --->
											<tr>
												<td>
												<table border="0" id="add_new_option_#get_survey_info.survey_question_id#">
													<cfset sira = 0>
													<cfloop query="get_survey_chapter_questions_options">
													<cfset sira = sira + 1>
													<cfif sira mod 2 eq 1><tr></cfif>
														<td width="75" nowrap>#OPTION_HEAD#</td>
														<td style="text-align:left;"><input type="text" name="user_answer_#get_survey_info.survey_question_id#_#survey_option_id#" id="user_answer_#get_survey_info.survey_question_id#_#survey_option_id#" id="user_answer_#get_survey_info.survey_question_id#_#survey_option_id#" value=""></td>
														<td width="50" nowrap></td>
													<cfif sira mod 2 eq 0 or sira eq get_survey_chapter_questions_options.recordcount></tr></cfif>
													</cfloop>
												</table>
												</td>
											</tr>
											</cfcase>
											<cfcase value="5"><!--- paragraf metin --->
											<tr>
												<table border="0" id="add_new_option_#get_survey_info.survey_question_id#">
													<cfloop query="get_survey_chapter_questions_options">
													<div class="form-group col col-6  col-md-6 col-xs-12">
														<label><b>#OPTION_HEAD#</b></label>
														<textarea name="user_answer_#get_survey_info.survey_question_id#_#survey_option_id#" id="user_answer_#get_survey_info.survey_question_id#_#survey_option_id#" style="width:400px;height:50px;"></textarea>
													</div>
													</cfloop>
												</table>
											</tr>
											</cfcase>
										</cfswitch>
										<cfset question_current_row = question_current_row + 1>
										
									</cfoutput>
									<!--- <cfif get_survey_chapter_questions_options.option_note eq 1>
										<tr>
											<td><input type="text" name="add_note_#survey_question_id#" id="add_note_#survey_question_id#" value=""></td>
										</tr>
									</cfif> --->
									</table>
								</td>
							</tr>
						<cfif get_survey_info.is_chapter_detail2 eq 1>
							<tr>
								<table>
									<div class="form-group col col-6  col-md-6 col-xs-12">
										<label><b>Açıklama :</b> #get_survey_info.survey_chapter_detail2#</label>
										<textarea name="survey_chapter_detail2_#get_survey_info.survey_chapter_id#" id="survey_chapter_detail2_#get_survey_info.survey_chapter_id#" style="width:400px;height:50px;"></textarea><!--- survey_chapter_detail2_#survey_question_id# --->
									</div>
								</table>
							</tr>
						</cfif>
						<cfset chapter_current_row = chapter_current_row + 1>
					</cf_box_elements>	
					</table>
				
			</cfoutput>
			<cfif isdefined('session.ep')>
			
					<cfif isdefined('attributes.is_portal')>
						#getLang('main',2086)#
					<cfelse>
						<cfif not listfind('14',get_survey_main.type)>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='29883.Form Bilgileri'></cfsavecontent>
							<cf_seperator id="detail" title="#message#">
						</cfif>
					</cfif>
				
				<cf_box_elements>	
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" id="detail" style="<cfif listfind('14',get_survey_main.type)>display:none;</cfif>">
							<cfif get_survey_main.type eq 8> 
								<cfquery name="GET_STANDBYS" datasource="#DSN#">
									SELECT
										EMPLOYEE_POSITIONS.POSITION_CODE,
										EMPLOYEE_POSITIONS.EMPLOYEE_ID,		
										EMPLOYEE_POSITIONS_STANDBY.CHIEF1_CODE,
										EMPLOYEE_POSITIONS_STANDBY.CHIEF2_CODE,
										EMPLOYEE_POSITIONS_STANDBY.CHIEF3_CODE
									FROM
										EMPLOYEE_POSITIONS_STANDBY,
										EMPLOYEE_POSITIONS,
										EMPLOYEES
									WHERE
										EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID AND
										EMPLOYEE_POSITIONS.POSITION_CODE = EMPLOYEE_POSITIONS_STANDBY.POSITION_CODE AND
										EMPLOYEE_POSITIONS_STANDBY.POSITION_CODE = (SELECT TOP 1 POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #attributes.action_type_id# AND IS_MASTER=1)
								</cfquery>
								<!--- performans formu tipinden geliyorsa --->
								<input type="hidden" name="valid" id="valid" value=""><!--- calisan onay --->
								<input type="hidden" name="valid1" id="valid1" value=""><!--- 1.amir onay --->
								<input type="hidden" name="valid2" id="valid2" value=""><!--- 2.amir onay --->
								<input type="hidden" name="valid3" id="valid3" value=""><!--- gorus bildiren onay --->
								<input type="hidden" name="valid4" id="valid4" value=""><!--- ortak degerlendirme onay --->
								<div class="form-group">
									<label class="col col-4"><cf_get_lang dictionary_id='57576.Çalışan'></label>
									<div class="input-group col col-8 col-md-8 col-sm-8 col-xs-12">
										<cfoutput>#get_emp_info(attributes.action_type_id,0,0)#
											<input type="hidden" name="EMP_ID" id="EMP_ID" value="#attributes.action_type_id#">
									<cfif get_survey_main.is_manager_0 eq 1><!--- Calisan Gelmemesi ile Ilgili Eklendi --->
											<input type="hidden" name="MANAGER_0_EMP_ID" id="MANAGER_0_EMP_ID" value="#attributes.action_type_id#">
									</cfif>
									</cfoutput>
									</div>
								</div>
								<cfif get_survey_main.is_manager_3 eq 1>
									<div class="form-group">
										<label class="col col-4"><cf_get_lang dictionary_id ='29908.Görüş Bildiren'></label>
										<div class="input-group col col-8 col-md-8 col-sm-8 col-xs-12">
											<cfif IsNumeric(get_standbys.CHIEF3_CODE)>
												<cfquery name="get_chief3_name" datasource="#dsn#">
													SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE=#get_standbys.CHIEF3_CODE#
												</cfquery>
											</cfif> 
											<input readonly="yes" name="MANAGER_3_POS_NAME" type="text" id="MANAGER_3_POS_NAME" style="width:150px;" <cfif IsNumeric(get_standbys.CHIEF3_CODE)>value="<cfoutput>#get_chief3_name.EMPLOYEE_NAME# #get_chief3_name.EMPLOYEE_SURNAME#</cfoutput>"</cfif>>
											<input type="hidden" name="MANAGER_3_POS" id="MANAGER_3_POS" <cfif IsNumeric(get_standbys.CHIEF3_CODE)>value="<cfoutput>#get_standbys.CHIEF3_CODE#</cfoutput>"</cfif>>
											<input type="hidden" name="MANAGER_3_EMP_ID" id="MANAGER_3_EMP_ID"<cfif IsNumeric(get_standbys.CHIEF3_CODE)>value="<cfoutput>#get_chief3_name.EMPLOYEE_ID#</cfoutput>"</cfif>>
											<!--- <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_list_positions&field_emp_name=survey_main_result.MANAGER_3_POS_NAME&field_emp_id=survey_main_result.MANAGER_3_EMP_ID&field_code=survey_main_result.MANAGER_3_POS','list');"><img src="/images/plus_thin.gif" border="0"></a> ---> 
										</div>
									</div>
								</cfif>
								<cfif get_survey_main.is_manager_1 eq 1>
									<div class="form-group">
										<label class="col col-4"><cf_get_lang dictionary_id='35927.Birinci Amir'></label>
										<div class="input-group col col-8 col-md-8 col-sm-8 col-xs-12">
											<cfif IsNumeric(get_standbys.CHIEF1_CODE)>
												<cfquery name="get_chief1_name" datasource="#dsn#">
													SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE=#get_standbys.CHIEF1_CODE#
												</cfquery>
											</cfif> 
											<input readonly="yes" name="MANAGER_1_POS_NAME" type="text" id="MANAGER_1_POS_NAME" style="width:150px;" <cfif IsNumeric(get_standbys.CHIEF1_CODE)>value="<cfoutput>#get_chief1_name.EMPLOYEE_NAME# #get_chief1_name.EMPLOYEE_SURNAME#</cfoutput>"</cfif>>
											<input type="hidden" name="MANAGER_1_POS" id="MANAGER_1_POS" <cfif IsNumeric(get_standbys.CHIEF1_CODE)>value="<cfoutput>#get_standbys.CHIEF1_CODE#</cfoutput>"</cfif>>
											<input type="hidden" name="MANAGER_1_EMP_ID" id="MANAGER_1_EMP_ID" <cfif IsNumeric(get_standbys.CHIEF1_CODE)>value="<cfoutput>#get_chief1_name.EMPLOYEE_ID#</cfoutput>"</cfif>>
										<!---  <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_list_positions&field_emp_name=survey_main_result.MANAGER_1_POS_NAME&field_emp_id=survey_main_result.MANAGER_1_EMP_ID&field_code=survey_main_result.MANAGER_1_POS','list');"><img src="/images/plus_thin.gif" border="0"></a> ---> 
										</div>
									</div>
								</cfif>
								<cfif get_survey_main.is_manager_2 eq 1>
									<div class="form-group">
										<label class="col col-4"><cf_get_lang dictionary_id='35921.İkinci Amir'></label>
										<div class="input-group col col-8 col-md-8 col-sm-8 col-xs-12">
											<cfif IsNumeric(get_standbys.CHIEF2_CODE)>
												<cfquery name="get_chief2_name" datasource="#dsn#">
													SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE=#get_standbys.CHIEF2_CODE#
												</cfquery>
											</cfif> 
											<input readonly="yes" name="MANAGER_2_POS_NAME" type="text" id="MANAGER_2_POS_NAME" style="width:150px;" <cfif IsNumeric(get_standbys.CHIEF2_CODE)>value="<cfoutput>#get_chief2_name.EMPLOYEE_NAME# #get_chief2_name.EMPLOYEE_SURNAME#</cfoutput>"</cfif>>
											<input type="hidden" name="MANAGER_2_POS" id="MANAGER_2_POS" <cfif IsNumeric(get_standbys.CHIEF2_CODE)>value="<cfoutput>#get_standbys.CHIEF2_CODE#</cfoutput>"</cfif>>
											<input type="hidden" name="MANAGER_2_EMP_ID" id="MANAGER_2_EMP_ID"<cfif IsNumeric(get_standbys.CHIEF2_CODE)>value="<cfoutput>#get_chief2_name.EMPLOYEE_ID#</cfoutput>"</cfif>>
											<!--- <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_list_positions&field_emp_name=survey_main_result.MANAGER_2_POS_NAME&field_emp_id=survey_main_result.MANAGER_2_EMP_ID&field_code=survey_main_result.MANAGER_2_POS','list');"><img src="/images/plus_thin.gif" border="0"></a> ---> 
										</div>
									</div>
								</cfif>
								</cfif>
								<cfif fuseaction contains 'settings'> 
								<div class="form-group">
									<label class="col col-4"><cf_get_lang dictionary_id='57658.Üye'></label>
									<cfset str_linke_ait="field_partner=survey_main_result.partner_id&field_consumer=survey_main_result.consumer_id&field_comp_id=survey_main_result.company_id&field_comp_name=survey_main_result.company_name&field_name=survey_main_result.member_name">
									<input type="text" name="company_name" id="company_name" value="" style="width:150px;" onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',0,0,0','CONSUMER_ID,COMPANY_ID,PARTNER_ID','consumer_id,company_id,partner_id','','3','250');">
									<!--- <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&<cfoutput>#str_linke_ait#</cfoutput>&select_list=7,8','list','popup_list_all_pars');"><img src="/images/plus_thin.gif" alt="<cf_get_lang_main no='246.Üye'>" border="0" align="absmiddle"></a> --->
								</div>
								<div class="form-group">
									<label class="col col-4"><cf_get_lang dictionary_id='29804.Uygulayan'></label>
									<div class="input-group col col-8 col-md-8 col-sm-8 col-xs-12">
										<input type="hidden" name="consumer_id" id="consumer_id" value="">
										<input type="hidden" name="company_id" id="company_id" value="">
										<input type="hidden" name="partner_id" id="partner_id" value="">
										<input type="text" name="member_name" id="member_name" value="">
									</div>
								</div>
								<div class="form-group">
									<label class="col col-4"><cf_get_lang dictionary_id='57576.Çalışan'></label>
									<div class="input-group col col-8 col-md-8 col-sm-8 col-xs-12"><cfoutput><input type="hidden" name="employee_id" id="employee_id" value="<cfif Len(attributes.employee_id)>#attributes.employee_id#</cfif>">
										<input type="text" name="employee" id="employee" value="<cfif isDefined('session.ep.name')>#session.ep.name# #session.ep.surname#</cfif>" style="width:150px;" onFocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','135');">
										<a href="javascript://"  onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=survey_main_result.employee_id&field_name=survey_main_result.employee&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.survey_main_result.employee.value),'list');" ><img src="/images/plus_thin.gif" alt="<cf_get_lang dictionary_id='57576.Çalışan'>" border="0" align="absmiddle"></a>
										</cfoutput>
									</div>
								</div>
							</cfif>						
								<div class="form-group" id="process_stage">
									<label class="col col-4"><cf_get_lang dictionary_id="58859.Süreç"></label>
									<div class="input-group col col-8 col-md-8 col-sm-8 col-xs-12"><cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'  is_select_text='1'></div>
								</div>
							<cfoutput>
								<div class="form-group require" id="item-company">
									<label class="col col-4"><cf_get_lang dictionary_id='60002.Bilgiyi Veren Şirket'><!--- <cf_get_lang_main no='107.Cari Hesap'> ---></label>
									<div class="input-group col col-8 col-md-8 col-sm-8 col-xs-12">
										<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined('attributes.company_id') and len(attributes.company_id)>#attributes.company_id#</cfif>">
										<input type="hidden" name="consumer_reference_code" id="consumer_reference_code" value="#attributes.consumer_reference_code#">
										<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type")><cfoutput>#attributes.member_type#</cfoutput></cfif>">
										<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>#attributes.consumer_id#</cfif>">
										<input type="text" name="company" id="company" value="<cfif isdefined('attributes.company_id') and len(attributes.company_id)>#get_par_info(attributes.company_id,1,1,0)#</cfif>" readonly>	  
										<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=survey_main_result.company_id&field_partner=survey_main_result.partner_id&field_consumer=survey_main_result.consumer_id&field_comp_name=survey_main_result.company&field_name=survey_main_result.member_name&field_type=survey_main_result.member_type','list');"></span>
									</div>             
								</div>
							</cfoutput>
							<input type="hidden" name="partner_reference_code" id="partner_reference_code" value="#attributes.partner_reference_code#">
							<input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>#attributes.partner_id#<cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>#attributes.consumer_id#</cfif>">		                
							<div class="form-group require" id="item-member_name">
								<label class="col col-4"><cf_get_lang dictionary_id='60153.Bilgiyi Veren'><!--- <cf_get_lang_main no='166.Yetkili'> ---></label>
								<div class="input-group col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfoutput><input type="text" name="member_name" id="member_name" value="<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>#get_par_info(attributes.partner_id,0,-1,0)#<cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>#get_cons_info(attributes.consumer_id,0,0,0)#</cfif>"></cfoutput>       
								</div>
							</div>
							<div class="form-group require" id="item-order_employee">
								<label class="col col-4"><cf_get_lang dictionary_id='33529.Bilgiyi Alan'><!--- <cf_get_lang no='357.Satış Çalışanı'> ---></label>
									<div class="input-group col col-8 col-md-8 col-sm-8 col-xs-12">
										<cfoutput><input type="hidden" name="employee_id" id="employee_id" value="<cfif Len(attributes.employee_id)>#attributes.employee_id#</cfif>">
										<input type="text" name="employee" id="employee" value="<cfif Len(attributes.employee_id)>#get_emp_info(attributes.employee_id,0,0)#</cfif>" onFocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','order_employee_id','','3','125');" autocomplete="off">
										<cfif session.ep.isBranchAuthorization>
											<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=survey_main_result.employee_id&field_name=survey_main_result.employee&is_store_module=1&select_list=1','list','popup_list_positions');"></span>
										<cfelse>
											<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=survey_main_result.employee_id&field_name=survey_main_result.employee&select_list=1','list','popup_list_positions');"></span>
										</cfif>
									</div>
							</div>
							<cfif get_survey_main.type eq 8><!--- performans--->
								<div class="form-group">
								<label class="col col-4"><cf_get_lang dictionary_id='58472.Dönem'></label>
								<div class="input-group col col-8 col-md-8 col-sm-8 col-xs-12">
									<cfinput id="start_date" type="text" name="start_date" validate="#validate_style#" value="#dateformat(get_survey_main.startdate,dateformat_style)#" style="width:65px;">
									<cf_wrk_date_image date_field="start_date">
									<cfinput type="text" id="finish_date" name="finish_date" validate="#validate_style#" value="#dateformat(get_survey_main.finish_date,dateformat_style)#" style="width:65px;">
									<cf_wrk_date_image date_field="finish_date">					
								</div>
							<cfelse>
								<div class="form-group">
									<label class="col col-4"><cf_get_lang dictionary_id='57742.Tarih'></label>
									<div class="input-group col col-8 col-md-8 col-sm-8 col-xs-12">
										<cfinput type="text" name="start_date" id="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
										<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>
									</div>
								</div>
							</cfif>
							<cfif get_survey_main.type eq 6><!--- deneme süresi ise gelsin--->
								<div class="form-group">
									<label class="col col-3"><cf_get_lang dictionary_id='61023.Çalışan Görebilsin'></label>
									<input type="checkbox" name="is_show_employee" id="is_show_employee" value="1">
								</div>
							</cfif>
						</cfoutput>
					</div>
				</cf_box_elements>
				<cf_box_elements vertical="1">
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12">	
						<cfif isdefined('attributes.is_portal')>
							<cf_get_lang dictionary_id='57422.Notlar'>
						<cfelse>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57422.Notlar'></cfsavecontent>
						<cf_seperator title="#message#" id="notlar_"> 
						</cfif>	
					
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12">	
							<div class="form-group" id="notlar_">
								<label class="col col-4"><cf_get_lang dictionary_id='57422.Notlar'></label>
								<div class="col col-8">
									<cfif not  (isdefined("session.pp") or isdefined("session.ww"))></cfif><textarea name="notes" id="notes" ></textarea>
								</div>
							</div>
						</div>
				</div>	
				</cf_box_elements>
			<cfelse>
				<div class="form-group col col-6  col-md-6 col-xs-12">
					<div class="input-group col-12">
						<cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0'>
						<cfoutput>
							<!--- <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined('session.ww.userid')>#session.ww.userid#</cfif>">
							<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined('session.pp.userid')>#session.pp.company_id#</cfif>">
							<input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined('session.pp.userid')>#session.pp.userid#</cfif>"> --->
						</cfoutput>
					</div>
				</div>
			</div>
		</cfif>
      <cf_box_footer>
      		<cfif not isdefined('session.ep') and not isdefined('attributes.is_portal')>
            	<a href="javascript://" onclick="window.print();">
                	<input type="button" id="wrk_submit_button" value="<cf_get_lang dictionary_id='57474.Yazdır'>" style="margin-right:25px;" class="btn_1" />
                </a>
			</cfif>
			<div class="col col-12">
				<cf_workcube_buttons is_upd='0' add_function='kontrol()' is_cancel='0'>
			</div>
      </cf_box_footer>
	<cfelse>
        <table>
            <tr>
                <label><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</label>
            </tr>
        </table>
    </cfif>
 </cfform>
</cf_box>
<script type="text/javascript">
var is_add_record_ = 1;
function kontrol()
{	
	if(is_add_record_ == 1)
		{
			is_add_record_ = 0;
			if(document.getElementById('action_type').value == 9 && document.getElementById('is_selected_attender').value == 1 && (document.getElementById('user_name').value == '' || document.getElementById('user_id').value == ''))
			{
				alert("<cf_get_lang dictionary_id='29780.Katılımcı'>");
				is_add_record_ = 1;
				return false;
			}
			if(document.getElementById('company_name')!= undefined && document.getElementById('company_name').value == '' && document.getElementById('employee').value == '')
			{
				alert("<cf_get_lang dictionary_id='57658.Üye'> / <cf_get_lang dictionary_id='29498.Çalışan Girmelisiniz'> !");
				is_add_record_ = 1;
				return false;
			}
			if(document.getElementById('action_type').value == 8)
			{
				if((document.getElementById('start_date').value == '' || (document.getElementById('finish_date') != undefined && document.getElementById('finish_date').value == '')))
				{
					alert("<cf_get_lang dictionary_id='58472.Dönem'>");
					is_add_record_ = 1;
					return false;
				}
			}
			//Tekli soru tipleri icin radiobutonun secili olup olmadıgını kontrol eder
			var get_question_info = wrk_query("SELECT SURVEY_QUESTION_ID, IS_REQUIRED, QUESTION_HEAD, QUESTION_TYPE,SURVEY_CHAPTER_ID,IS_SHOW_GD FROM SURVEY_QUESTION WHERE SURVEY_MAIN_ID ="+ document.survey_main_result.survey_id.value+" ORDER BY SURVEY_QUESTION_ID","dsn");
			for (var xx=0; xx<get_question_info.recordcount; xx++)
			{	
				var get_opt_info = wrk_query("SELECT SURVEY_QUESTION_ID FROM SURVEY_OPTION WHERE SURVEY_CHAPTER_ID ="+ get_question_info.SURVEY_CHAPTER_ID[xx]+" ORDER BY SURVEY_QUESTION_ID","dsn");
				if(get_opt_info.SURVEY_QUESTION_ID[xx] == '')
					var get_option_info_ = wrk_query("SELECT SURVEY_QUESTION_ID, SURVEY_OPTION_ID FROM SURVEY_OPTION WHERE SURVEY_CHAPTER_ID ="+ get_question_info.SURVEY_CHAPTER_ID[xx],"dsn");
				else
					var get_option_info_ = wrk_query("SELECT SURVEY_QUESTION_ID, SURVEY_OPTION_ID FROM SURVEY_OPTION WHERE SURVEY_QUESTION_ID ="+ get_question_info.SURVEY_QUESTION_ID[xx] + " AND SURVEY_CHAPTER_ID ="+ get_question_info.SURVEY_CHAPTER_ID[xx],"dsn");
		
				if(get_question_info.IS_REQUIRED[xx] == 1)
				{
					if(get_question_info.QUESTION_TYPE[xx] == 1 || get_question_info.QUESTION_TYPE[xx] == 2)//Tekli yada coklu
					{
						gecti_ = 0;
						var question_id_ = get_question_info.SURVEY_QUESTION_ID[xx];
						var inputid = "user_answer_" + question_id_;
						var get_chapter = wrk_query("SELECT IS_SHOW_GD FROM SURVEY_CHAPTER WHERE SURVEY_CHAPTER_ID ="+get_question_info.SURVEY_CHAPTER_ID[xx],"DSN");
						if(get_question_info.IS_SHOW_GD[xx] == 1 || (get_chapter.recordcount >0 && get_chapter.IS_SHOW_GD[0] == 1)) //GD seçeneği geliyor ise
						{var sayac = get_opt_info.recordcount+1;}else var sayac = get_opt_info.recordcount;
						for (var yy=0; yy<sayac; yy++)
						{
							if(document.getElementsByName(inputid)[yy] != undefined && document.getElementsByName(inputid)[yy].checked == true)
							{gecti_ = 1;break;}
						}
						if(gecti_ == 0)
						{
							alert(get_question_info.QUESTION_HEAD[xx] + ' ' +"<cf_get_lang dictionary_id='29781.Lütfen Zorunlu Alanları Doldurunuz'> !");
							is_add_record_ = 1;
							return false;
							
						}
					}
					if(get_question_info.QUESTION_TYPE[xx] == 3 || get_question_info.QUESTION_TYPE[xx] == 5)//Acikuclu
					{
						var question_id = get_question_info.SURVEY_QUESTION_ID[xx];
						for (var zz=0; zz<get_option_info_.recordcount; zz++)
						{
							var inputid = "user_answer_" + question_id+'_'+get_option_info_.SURVEY_OPTION_ID[zz];
							if(document.getElementById(inputid).value == '')
							{
								alert(get_question_info.QUESTION_HEAD[xx] + ' ' +"<cf_get_lang dictionary_id='29781.Lütfen Zorunlu Alanları Doldurunuz'> !");
								is_add_record_ = 1;
								return false;
							}
						}	
					}
				}
			}
		}
		else
		{
			return false;
		}
	<cfif len(get_survey_main.process_id)>
	return process_cat_control();
	</cfif>
}
var s = 98;//Ascii kodu a harfine karsilik geliyor
function add_new_option(x,row_count_options,survey_chapter_id)
{	
	aaa = document.getElementById("record_num_result_"+row_count_options).value;
	var get_option_info = wrk_query("SELECT SURVEY_QUESTION_ID, SURVEY_OPTION_ID, SURVEY_QUESTION_ID, OPTION_HEAD, OPTION_POINT, OPTION_NOTE FROM SURVEY_OPTION WHERE SURVEY_QUESTION_ID ="+ row_count_options,"dsn");
	var newRow;
	var newCell;
	newRow = document.getElementById("add_new_option_"+row_count_options).insertRow(document.getElementById("add_new_option_"+row_count_options).rows.length);
	newRow.setAttribute("name","add_new_option_row_'+row_count_options+'_'+aaa+'");
	newRow.setAttribute("id","add_new_option_row_'+row_count_options+'_'+aaa+'");	
	newRow.setAttribute("NAME","add_new_option_row_'+row_count_options+'_'+aaa+'");
	newRow.setAttribute("ID","add_new_option_row_'+row_count_options+'_'+aaa+'");
	for (var mm=0; mm<x; mm++)
	{
		
		newRow = document.getElementById("add_new_option_"+row_count_options).insertRow(document.getElementById("add_new_option_"+row_count_options).rows.length);
		newRow.setAttribute("name","add_new_option_row_" + row_count_options);
		newRow.setAttribute("id","add_new_option_row_" + row_count_options);	
		newRow.setAttribute("NAME","add_new_option_row_" + row_count_options);
		newRow.setAttribute("ID","add_new_option_row_" + row_count_options);
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = String.fromCharCode(s)+' ) '+get_option_info.OPTION_HEAD[mm];
		var option_id = parseInt(get_option_info.SURVEY_OPTION_ID[x-1]) + parseInt(mm+1);
		alert(option_id);
		document.getElementById("record_num_result_"+row_count_options).value = option_id;
	}
	s = s + 1;
}
</script>

