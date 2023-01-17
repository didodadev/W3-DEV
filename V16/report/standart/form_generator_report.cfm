<!--- 20131025 SM - FORM RAPORU --->
<cfsetting showdebugoutput="no">
<cf_get_lang_set module_name="report">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.report_type" default="">
<cfparam name="attributes.quiz_id" default="">
<cfparam name="attributes.quiz_name" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.position_cats" default="">
<cfparam name="attributes.is_excel" default="">
<cfquery name="get_position_cats" datasource="#dsn#">
	SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT ORDER BY POSITION_CAT 
</cfquery>
<cfquery name="get_branch" datasource="#dsn#">
	SELECT 
		BRANCH_ID,
		BRANCH_NAME
	FROM 
		BRANCH 
	WHERE 
		BRANCH_STATUS = 1 AND 
		COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> 
		<cfif not session.ep.ehesap>
			AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
		</cfif>
	ORDER BY 
		BRANCH_NAME
</cfquery>
<cfquery name="get_department" datasource="#dsn#">
	SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>BRANCH_ID IN (#attributes.branch_id#)<cfelse>1=0</cfif> AND DEPARTMENT_STATUS = 1 ORDER BY DEPARTMENT_HEAD
</cfquery>
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="get_type" datasource="#dsn#">
		SELECT TYPE FROM SURVEY_MAIN WHERE SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.quiz_id#">
	</cfquery>
	<cfif attributes.report_type neq 1>
		<cfquery name="check_table" datasource="#dsn#">
			IF EXISTS(SELECT * FROM tempdb.sys.tables where name = '####get_all_result_#session.ep.userid#')
			BEGIN
				DROP TABLE ####get_all_result_#session.ep.userid#
			END     
		</cfquery>
	</cfif>
	<cfquery name="get_emp_results" datasource="#dsn#">
		SELECT
			E.EMPLOYEE_ID,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			PC.POSITION_CAT,
			D.DEPARTMENT_HEAD,
			B.BRANCH_NAME,
			SR.SURVEY_MAIN_RESULT_ID,
			SR.SURVEY_MAIN_ID,
			SR.PROCESS_ROW_ID,
			SR.ACTION_TYPE,
			SR.ACTION_ID,
			SR.COMPANY_ID,
			SR.PARTNER_ID,
			SR.CONSUMER_ID,
			SR.EMP_ID,
			SR.APPLY_EMP,
			SR.START_DATE,
			SR.FINISH_DATE,
			SR.SCORE_RESULT,
			SR.RESULT_NOTE,
			SR.COMMENT,
			SR.MANAGER1_EMP_ID,
			SR.MANAGER1_POS,
			SR.MANAGER2_EMP_ID,
			SR.MANAGER2_POS,
			SR.MANAGER3_EMP_ID,
			SR.MANAGER3_POS,
			SR.VALID,
			SR.VALID1,
			SR.VALID2,
			SR.VALID3,
			SR.VALID4,
			SR.VALID1_EMP,
			SR.VALID1_DATE,
			SR.VALID2_EMP,
			SR.VALID2_DATE,
			SR.VALID3_EMP,
			SR.VALID3_DATE,
			SR.SCORE_RESULT_EMP,
			SR.SCORE_RESULT_MANAGER1,
			SR.SCORE_RESULT_MANAGER2,
			SR.SCORE_RESULT_MANAGER3,
			SR.SCORE_RESULT_MANAGER4,
			SM.IS_MANAGER_0,
			SM.IS_MANAGER_1,
			SM.IS_MANAGER_2,
			SM.IS_MANAGER_3,
			SM.IS_MANAGER_4,
			SM.EMP_QUIZ_WEIGHT,
			SM.MANAGER_QUIZ_WEIGHT_1,
			SM.MANAGER_QUIZ_WEIGHT_2,
			SM.MANAGER_QUIZ_WEIGHT_3,
			SM.MANAGER_QUIZ_WEIGHT_4
		<cfif attributes.report_type neq 1>
			INTO ####get_all_result_#session.ep.userid#
		</cfif>
		FROM
			EMPLOYEES E
			INNER JOIN EMPLOYEE_POSITIONS EP ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID
			INNER JOIN SURVEY_MAIN_RESULT SR ON E.EMPLOYEE_ID = SR.ACTION_ID
			INNER JOIN SURVEY_MAIN SM ON SR.SURVEY_MAIN_ID = SM.SURVEY_MAIN_ID
			LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EP.DEPARTMENT_ID
			LEFT JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
			LEFT JOIN SETUP_POSITION_CAT PC ON EP.POSITION_CAT_ID = PC.POSITION_CAT_ID
		WHERE
			SR.SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.quiz_id#">
			AND EP.IS_MASTER = 1
			<!---AND SR.ACTION_TYPE IN(6,8,10)--->
			<cfif len(attributes.branch_id)>
				AND B.BRANCH_ID IN (#attributes.branch_id#)
			</cfif>
			<cfif not session.ep.ehesap>
				AND B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#)
			</cfif>
			<cfif len(attributes.department_id)>
				AND EP.DEPARTMENT_ID IN (#attributes.department_id#)
			</cfif>
			<cfif len(attributes.position_cats)>
				AND EP.POSITION_CAT_ID IN (#attributes.position_cats#)
			</cfif>
		ORDER BY
			E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME
	</cfquery>
	<!---<cfif attributes.report_type eq 2>
		<cfquery name="get_emp_results" datasource="#dsn#">
			SELECT * FROM ####get_all_result_#session.ep.userid#
		</cfquery>
		<cfquery name="get_chapter" datasource="#dsn#">
			SELECT DISTINCT
				SURVEY_CHAPTER_CODE
			FROM
				SURVEY_CHAPTER
			WHERE
				SURVEY_MAIN_ID IN(SELECT SURVEY_MAIN_ID FROM ####get_all_result_#session.ep.userid#)
			ORDER BY
				SURVEY_CHAPTER_CODE
		</cfquery>
		<cfquery name="get_results" datasource="#dsn#">
			SELECT
				<cfif isdefined("attributes.is_rate")>
					ISNULL(SURVEY_OPTION_POINT_EMP,0) SCORE_RESULT_EMP,
					ISNULL(SURVEY_OPTION_POINT_MANAGER1,0) SCORE_RESULT_MANAGER1,
					ISNULL(SURVEY_OPTION_POINT_MANAGER2,0) SCORE_RESULT_MANAGER2,
					ISNULL(SURVEY_OPTION_POINT_MANAGER3,0) SCORE_RESULT_MANAGER3,
					ISNULL(SURVEY_OPTION_POINT_MANAGER4,0) SCORE_RESULT_MANAGER4,
					SM.IS_MANAGER_0,
					SM.IS_MANAGER_1,
					SM.IS_MANAGER_2,
					SM.IS_MANAGER_3,
					SM.IS_MANAGER_4,
					SM.EMP_QUIZ_WEIGHT,
					SM.MANAGER_QUIZ_WEIGHT_1,
					SM.MANAGER_QUIZ_WEIGHT_2,
					SM.MANAGER_QUIZ_WEIGHT_3,
					SM.MANAGER_QUIZ_WEIGHT_4,
					SC.SURVEY_CHAPTER_WEIGHT,
				<cfelse>
					SUM(ISNULL(SURVEY_OPTION_POINT_EMP,0)+ISNULL(SURVEY_OPTION_POINT_MANAGER3,0)+ISNULL(SURVEY_OPTION_POINT_MANAGER1,0)+ISNULL(SURVEY_OPTION_POINT_MANAGER4,0)+ISNULL(SURVEY_OPTION_POINT_MANAGER2,0)) OPTION_POINT,
				</cfif>
				SC.SURVEY_CHAPTER_CODE,
				SC.SURVEY_MAIN_ID,
				SR.ACTION_ID EMPLOYEE_ID
			FROM
				SURVEY_QUESTION_RESULT SRR,
				SURVEY_QUESTION S,
				SURVEY_CHAPTER SC,
				SURVEY_MAIN_RESULT SR,
				SURVEY_MAIN SM
			WHERE
				SC.SURVEY_MAIN_ID = SR.SURVEY_MAIN_ID
				AND SRR.SURVEY_QUESTION_ID = S.SURVEY_QUESTION_ID
				AND S.SURVEY_CHAPTER_ID = SC.SURVEY_CHAPTER_ID
				AND SC.SURVEY_MAIN_ID = SM.SURVEY_MAIN_ID
				AND SC.SURVEY_MAIN_ID IN(SELECT SURVEY_MAIN_ID FROM ####get_all_result_#session.ep.userid#)
				AND SRR.SURVEY_OPTION_ID IS NOT NULL
			<cfif not isdefined("attributes.is_rate")>
				GROUP BY
					SC.SURVEY_CHAPTER_CODE,
					SC.SURVEY_MAIN_ID,
					SR.ACTION_ID
			</cfif>
		</cfquery>
		<cfif not isdefined("attributes.is_rate")>
			<cfoutput query="get_results">
				<cfset "emp_result_#survey_main_id#_#survey_chapter_code#_#employee_id#" = option_point>
			</cfoutput>
		</cfif>
	<cfelseif attributes.report_type eq 3>--->
	<cfif attributes.report_type eq 3>
		<cfquery name="get_emp_results" datasource="#dsn#">
			SELECT * FROM ####get_all_result_#session.ep.userid#
		</cfquery>
		<cfquery name="get_chapter" datasource="#dsn#">
			SELECT DISTINCT
				SURVEY_CHAPTER_CODE
			FROM
				SURVEY_CHAPTER
			WHERE
				SURVEY_MAIN_ID IN(SELECT SURVEY_MAIN_ID FROM ####get_all_result_#session.ep.userid#)
			ORDER BY
				SURVEY_CHAPTER_CODE
		</cfquery>
		<cfquery name="get_question" datasource="#dsn#">
			SELECT
				LINE_NUMBER,
				SURVEY_CHAPTER_CODE,
				SURVEY_QUESTION_ID,
				QUESTION_HEAD
			FROM
				SURVEY_QUESTION,
				SURVEY_CHAPTER
			WHERE
				SURVEY_QUESTION.SURVEY_MAIN_ID IN(SELECT SURVEY_MAIN_ID FROM ####get_all_result_#session.ep.userid#)
				AND SURVEY_QUESTION.SURVEY_CHAPTER_ID = SURVEY_CHAPTER.SURVEY_CHAPTER_ID
			ORDER BY
				LINE_NUMBER
		</cfquery>
		<cfquery name="get_results" datasource="#dsn#">
			SELECT	
				OPTION_POINT OPTION_POINT,
				SC.SURVEY_CHAPTER_CODE,
				SRR.SURVEY_QUESTION_ID,
				SC.SURVEY_MAIN_ID,
				SR.ACTION_ID EMPLOYEE_ID,
				SRR.SURVEY_MAIN_RESULT_ID
			FROM
				SURVEY_QUESTION_RESULT SRR,
				SURVEY_QUESTION S,
				SURVEY_CHAPTER SC,
				SURVEY_MAIN_RESULT SR,
				SURVEY_MAIN SM
			WHERE
				SC.SURVEY_MAIN_ID = SR.SURVEY_MAIN_ID
				AND SRR.SURVEY_MAIN_RESULT_ID = SR.SURVEY_MAIN_RESULT_ID
				AND SRR.SURVEY_QUESTION_ID = S.SURVEY_QUESTION_ID
				AND S.SURVEY_CHAPTER_ID = SC.SURVEY_CHAPTER_ID
				AND SC.SURVEY_MAIN_ID = SM.SURVEY_MAIN_ID
				AND SRR.SURVEY_MAIN_RESULT_ID IN(SELECT SURVEY_MAIN_RESULT_ID FROM ####get_all_result_#session.ep.userid#)
				AND SRR.SURVEY_OPTION_ID IS NOT NULL
				AND SR.ACTION_ID IS NOT NULL
		</cfquery>
		<cfoutput query="get_results">
			<cfset "emp_result_#survey_main_result_id#_#survey_main_id#_#survey_chapter_code#_#survey_question_id#_#employee_id#" = option_point>
		</cfoutput>
	</cfif>
<cfelse>
	<cfset get_emp_results.recordcount = 0>
</cfif>
<cfsavecontent variable="head"><cf_get_lang dictionary_id='47867.Performans Formu Sonuçları'></cfsavecontent>
<cfform name="form_generator_report_" method="post" action="#request.self#?fuseaction=report.form_generator_report">
	<cf_report_list_search title="#head#">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="col col-12 col-md-12 col-xs-12">
									<div class="col col-12 col-md-12 col-xs-12">
										<div class="form-group">
											<label class="col col-12"><cf_get_lang dictionary_id='29764.Form'>*</label>
											<div class="col col-12">
												<div class="input-group">
													<input type="hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
													<input type="text" name="quiz_name" value="<cfoutput>#attributes.quiz_name#</cfoutput>" readonly="true">
													<span class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_form_generators&is_form_generators=1&field_id=form_generator_report_.quiz_id&field_name=form_generator_report_.quiz_name','list');"></span>
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12"><cf_get_lang dictionary_id ='57453.Şube'></label>
											<div class="col col-12">
												<div class="multiselect-z1">
													<cf_multiselect_check 
													query_name="get_branch"  
													name="branch_id"
													width="160"
													height="200"
													option_text="#getLang('main',322)#" 
													option_value="branch_id"
													option_name="branch_name"
													value="#iif(isdefined("attributes.branch_id"),"attributes.branch_id",DE(""))#"
													onchange="get_department_list(this.value)">
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12"><cf_get_lang dictionary_id ='57572.Departman'></label>
											<div class="col col-12">
												<div class="multiselect-z1" id="DEPARTMENT_PLACE">
													<cf_multiselect_check 
													query_name="get_department"  
													name="department"
													width="160" 
													height="200"
													option_text="#getLang('main',322)#" 
													option_value="department_id"
													option_name="department_head"
													value="#iif(isdefined("attributes.department_id"),"attributes.department_id",DE(""))#">
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></label>
											<div class="col col-12">
												<div class="multiselect-z1">
													<cf_multiselect_check 
													query_name="get_position_cats"
													value="#attributes.position_cats#"  
													name="position_cats"
													width="160" 
													height="200"
													option_value="position_cat_id"
													option_name="position_cat">
												</div>
											</div>
										</div>
										<div class="form-group">
											<label class="col col-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
											<div class="col col-12">
												<select name="report_type" id="report_type" style="width:140px;" onchange="kontrol_rate();">
													<option value="1" <cfif attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57684.Sonuç'><cf_get_lang dictionary_id='58601.Bazında'></option>
													<!--- <option value="2" <cfif attributes.report_type eq 2>selected</cfif>>Bölüm<cf_get_lang dictionary_id='1189.Bazında'></option> --->
													<option value="3" <cfif attributes.report_type eq 3>selected</cfif>><cf_get_lang dictionary_id='58810.Soru'><cf_get_lang dictionary_id='58601.Bazında'></option>
												</select>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
							<input type="hidden" name="form_submitted" id="form_submitted" value="1">
							<cf_wrk_report_search_button button_type="1" is_excel='1' search_function="kontrol()">
						</div>
					</div>
				</div>
			</div> 
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>
<cfif attributes.is_excel eq 1>
	<cfset type_ = 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-8">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cfelse>
	<cfset type_ = 0>
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
		<cfset type_ = 1>
	<cfelse>
		<cfset type_ = 0>
	</cfif>
    <cf_report_list>
		<cfparam name="attributes.page" default=1>
		<cfparam name="attributes.totalrecords" default="#get_emp_results.recordcount#">
		<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
		<cfif isdefined('attributes.is_excel') and  attributes.is_excel eq 1>
			<cfset attributes.startrow=1>
			<cfset attributes.maxrows=get_emp_results.recordcount>
		</cfif>
		<thead>
			<cfif attributes.report_type eq 3>
				<tr>
					<!---<th colspan="5">&nbsp;</th>--->
					<cfoutput query="get_chapter">
						<cfquery name="get_question_row" dbtype="query">
							SELECT * FROM get_question WHERE SURVEY_CHAPTER_CODE = '#get_chapter.SURVEY_CHAPTER_CODE#'
						</cfquery>
						<th  colspan="#get_question_row.recordcount#" align="center">#SURVEY_CHAPTER_CODE#</th>
					</cfoutput>
					<cfif get_type.type eq 14>
						<th width="15">&nbsp;</th>
					</cfif>
				</tr>
			</cfif>				
			<tr>
				<th width="25"><cf_get_lang dictionary_id ='57487.No'></th>
				<th><cf_get_lang dictionary_id ='57576.Çalışan'></th>
				<th><cf_get_lang dictionary_id ='57453.Şube'></th>
				<th><cf_get_lang dictionary_id ='57572.Departman'></th>
				<th><cf_get_lang dictionary_id ='59004.Pozisyon Tipi'></th>
				<cfif attributes.report_type eq 3>
					<th></th>
				</cfif>
				<cfif attributes.report_type eq 1>
					<th ><cf_get_lang dictionary_id='57684.Sonuç'></th>
				<!---<cfelseif attributes.report_type eq 2>
					<cfoutput query="get_chapter">
						<th >#survey_chapter_code#</th>
					</cfoutput>--->
				<cfelseif attributes.report_type eq 3>
					<cfoutput query="get_chapter">
						<cfquery name="get_question_row" dbtype="query">
							SELECT * FROM get_question WHERE SURVEY_CHAPTER_CODE = '#get_chapter.SURVEY_CHAPTER_CODE#'
						</cfquery>
						<cfloop query="get_question_row">
							<th  title="#question_head#">#get_question_row.line_number#</th>
						</cfloop>
					</cfoutput>
					<cfif get_type.type eq 14>
						<th>&nbsp;</th>
					</cfif>
				</cfif>
			</tr>
		</thead>
		<tbody>
			<cfif get_emp_results.recordcount>
				<cfoutput query="get_emp_results" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#currentrow#</td>
						<td>
							<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1 >
								#employee_name#&nbsp;#employee_surname#
							<cfelse>
								<cfif action_type eq 14 and attributes.report_type eq 3>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_dsp_detailed_survey_main_result&survey_id=#survey_main_id#&result_id=#survey_main_result_id#','wide');" class="tableyazi">
										#employee_name#&nbsp;#employee_surname#
									</a>
								<cfelse>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#employee_id#','medium');" class="tableyazi">
										#employee_name#&nbsp;#employee_surname#
									</a>
								</cfif>			
							</cfif>
						</td>
						<td>#branch_name#</td>
						<td>#department_head#</td>
						<td>#position_cat#</td>
						<cfif attributes.report_type eq 3>
							<td></td>
						</cfif>
						<cfif attributes.report_type eq 1>
							<td align="right">
								<cfscript>
									user_point = 0;
									if (not len(score_result_emp))
										score_result_emp = 0;
									else
										score_result_emp = score_result_emp;
									if (not len(trim(score_result_manager1)))
										score_result_manager1 = 0;
									else
										score_result_manager1 = score_result_manager1;
									if (not len(trim(score_result_manager2)))
										score_result_manager2 = 0;
									else
										score_result_manager2 = score_result_manager2;
									if (not len(trim(score_result_manager3)))
										score_result_manager3 = 0;
									else
										score_result_manager3 = score_result_manager3;
									if (not len(trim(score_result_manager4)))
										score_result_manager4 = 0;
									else
										score_result_manager4 = score_result_manager4;
									if (is_manager_0 is 1 and len(emp_quiz_weight) and len(score_result_emp))
										user_point = user_point+(score_result_emp * emp_quiz_weight);
									if (is_manager_3 is 1 and len(manager_quiz_weight_3) and len(score_result_manager3))
										user_point = user_point+(score_result_manager3 * manager_quiz_weight_3);
									if (is_manager_1 is 1 and len(manager_quiz_weight_1) and len(score_result_manager1))
										user_point = user_point+(score_result_manager1 * manager_quiz_weight_1);
									if (is_manager_4 is 1 and len(manager_quiz_weight_4) and len(score_result_manager4))
										user_point = user_point+(score_result_manager4 * manager_quiz_weight_4);
									if (is_manager_2 is 1 and len(manager_quiz_weight_2) and len(score_result_manager2))
										user_point = user_point+(score_result_manager2 * manager_quiz_weight_2);
									user_point_ = user_point/100;
									if (action_type neq 8 and user_point_ eq 0 and len(score_result)) //performans formu degilse surec yok sonucu al
										user_point_ = user_point_ + score_result;
								</cfscript>
								#TlFormat(user_point_)# / 100
							</td>
						<!---<cfelseif attributes.report_type eq 2>
							<cfloop query="get_chapter">
								<td align="right">
									<cfif isdefined("attributes.is_rate")>
										<cfquery name="get_row_results" dbtype="query">
											SELECT * FROM get_results WHERE SURVEY_MAIN_ID = #get_emp_results.SURVEY_MAIN_ID# AND EMPLOYEE_ID = #get_emp_results.EMPLOYEE_ID# AND SURVEY_CHAPTER_CODE = '#get_chapter.SURVEY_CHAPTER_CODE#'
										</cfquery>
										<cfset total_amount = 0>
										<cfloop query="get_row_results">
											<cfif not len(get_row_results.score_result_emp)>
												<cfset score_result_emp_ = 0>
											<cfelse>
												<cfset score_result_emp_ = get_row_results.score_result_emp>
											</cfif>
											<cfif not len(trim(get_row_results.score_result_manager1))>
												<cfset score_result_manager1_ = 0>
											<cfelse>
												<cfset score_result_manager1_ = get_row_results.score_result_manager1>
											</cfif>
											<cfif not len(trim(get_row_results.score_result_manager2))>
												<cfset score_result_manager2_ = 0>
											<cfelse>
												<cfset score_result_manager2_ = get_row_results.score_result_manager2>
											</cfif>
											<cfif not len(trim(get_row_results.score_result_manager3))>
												<cfset score_result_manager3_ = 0>
											<cfelse>
												<cfset score_result_manager3_ = get_row_results.score_result_manager3>
											</cfif>
											<cfif not len(trim(get_row_results.score_result_manager4))>
												<cfset score_result_manager4_ = 0>
											<cfelse>
												<cfset score_result_manager4_ = get_row_results.score_result_manager4>
											</cfif>
											<cfif get_row_results.is_manager_0 is 1 and len(get_row_results.emp_quiz_weight) and len(score_result_emp_)>
												<cfset total_amount = total_amount+(score_result_emp_ * get_row_results.emp_quiz_weight)>
											</cfif>
											<cfif get_row_results.is_manager_3 is 1 and len(get_row_results.manager_quiz_weight_3) and len(score_result_manager3_)>
												<cfset total_amount = total_amount+(score_result_manager3_ * get_row_results.manager_quiz_weight_3)>
											</cfif>
											<cfif get_row_results.is_manager_1 is 1 and len(get_row_results.manager_quiz_weight_1) and len(score_result_manager1_)>
												<cfset total_amount = total_amount+(score_result_manager1_ * get_row_results.manager_quiz_weight_1)>
											</cfif>
											<cfif get_row_results.is_manager_4 is 1 and len(get_row_results.manager_quiz_weight_4) and len(score_result_manager4_)>
												<cfset total_amount = total_amount+(score_result_manager4_ * manager_quiz_weight_4)>
											</cfif>
											<cfif get_row_results.is_manager_2 is 1 and len(get_row_results.manager_quiz_weight_2) and len(score_result_manager2_)>
												<cfset total_amount = total_amount+(score_result_manager2_ * get_row_results.manager_quiz_weight_2)>
											</cfif>
										</cfloop>
										<cfset total_amount = total_amount/100>
									<cfelse>
										<cfif isdefined("emp_result_#get_emp_results.survey_main_id#_#get_chapter.survey_chapter_code#_#get_emp_results.employee_id#")>
											<cfset total_amount = evaluate("emp_result_#get_emp_results.survey_main_id#_#get_chapter.survey_chapter_code#_#get_emp_results.employee_id#")>
										<cfelse>
											<cfset total_amount = 0>
										</cfif>
									</cfif>
									#TlFormat(total_amount)#
								</td>
							</cfloop>--->
						<cfelseif attributes.report_type eq 3>
							<cfloop query="get_chapter">
								<cfquery name="get_question_row" dbtype="query">
									SELECT * FROM get_question WHERE SURVEY_CHAPTER_CODE = '#get_chapter.SURVEY_CHAPTER_CODE#'
								</cfquery>
								<cfloop query="get_question_row">
									<td align="right">
										<cfif isdefined("emp_result_#get_emp_results.survey_main_result_id#_#get_emp_results.survey_main_id#_#get_chapter.survey_chapter_code#_#get_question_row.survey_question_id#_#get_emp_results.employee_id#")>
											<cfset total_amount = evaluate("emp_result_#get_emp_results.survey_main_result_id#_#get_emp_results.survey_main_id#_#get_chapter.survey_chapter_code#_#get_question_row.survey_question_id#_#get_emp_results.employee_id#")>
										<cfelse>
											<cfset total_amount = 0>
										</cfif>
										#TlFormat(total_amount)#
									</td>
								</cfloop>
							</cfloop>
							<cfif action_type eq 14>
								<td>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_dsp_detailed_survey_main_result&survey_id=#survey_main_id#&result_id=#survey_main_result_id#','wide');" class="tableyazi">
										<img src="/images/update_list.gif" title="<cf_get_lang dictionary_id='60271.Form Detayı'>">
									</a>
								</td>
								
							</cfif>
						</cfif>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="6"><cf_get_lang dictionary_id ='57484.Kayıt Yok'>!</td>
				</tr>
			</cfif>
		</tbody>
    </cf_report_list>
	<cfif  isdefined("attributes.form_submitted") and attributes.totalrecords gt attributes.maxrows>
					<cfscript>
						str_link = "form_submitted=1";
						str_link = "#str_link#&quiz_id=#attributes.quiz_id#";
						str_link = "#str_link#&report_type=#attributes.report_type#";	
						str_link = "#str_link#&quiz_name=#attributes.quiz_name#";		
						str_link = "#str_link#&branch_id=#attributes.branch_id#";		
						str_link = "#str_link#&department_id=#attributes.department_id#";		
						str_link = "#str_link#&position_cats=#attributes.position_cats#";		
						if(isdefined("attributes.is_rate"))
							str_link = "#str_link#&is_rate=1";		
					</cfscript>
					<cf_paging
						page="#attributes.page#" 
						maxrows="#attributes.maxrows#" 
						totalrecords="#attributes.totalrecords#" 
						startrow="#attributes.startrow#" 
						adres="report.form_generator_report&#str_link#"> 
	</cfif>	
</cfif> 		  
<script type="text/javascript">
	function get_department_list(gelen)
	{
		checkedValues_b = $("#branch_id").multiselect("getChecked");
		var branch_id_list='';
		for(kk=0;kk<checkedValues_b.length; kk++)
		{
			if(branch_id_list == '')
				branch_id_list = checkedValues_b[kk].value;
			else
				branch_id_list = branch_id_list + ',' + checkedValues_b[kk].value;
		}
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_ajax_list_hr&is_multiselect=1&name=department&branch_id="+branch_id_list;
		AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
	}
	function kontrol()
	{	
			
		if(document.form_generator_report_.quiz_id.value == '' || document.form_generator_report_.quiz_name.value == '')
		{
			alert("<cf_get_lang dictionary_id='29764.Form'><cf_get_lang dictionary_id='57734.Seçiniz'>");
			return false;
		}
		if(document.form_generator_report_.is_excel.checked==false)
            {
                document.form_generator_report_.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
                return true;
            }
            else
                document.form_generator_report_.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_form_generator_report</cfoutput>"
		
	}
	function kontrol_rate()
	{
		if(document.form_generator_report_.report_type.value == 2)
			td_rate.style.display = '';
		else
			td_rate.style.display = 'none';
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
