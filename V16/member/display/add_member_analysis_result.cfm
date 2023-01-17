<cfif isDefined("attributes.member_type") and attributes.member_type eq "partner">
	<cfquery name="GET_PARTNER" datasource="#DSN#">
		SELECT 
			CP.COMPANY_PARTNER_NAME,
			CP.COMPANY_PARTNER_SURNAME,
			C.NICKNAME
		FROM
			COMPANY_PARTNER CP, 
			COMPANY C
		WHERE 
			CP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.partner_id#"> AND
			CP.COMPANY_ID = C.COMPANY_ID
	</cfquery>
<cfelseif isDefined("attributes.member_type") and attributes.member_type eq "consumer">
	<cfquery name="GET_CONSUMER" datasource="#DSN#">
		SELECT CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.consumer_id#">	
	</cfquery>
</cfif>
<cfinclude template="../query/get_analysis.cfm">
<cfinclude template="../query/get_analysis_questions.cfm">

<cfif isdefined("attributes.result_id")>
	<cfquery name="GET_USER_RESULTS" datasource="#DSN#">
		SELECT 
			MARD.RESULT_DETAIL_ID, 
			MARD.RESULT_ID,
			MARD.QUESTION_ID,
			MARD.QUESTION_POINT,
			MARD.QUESTION_USER_ANSWERS
		FROM
			MEMBER_ANALYSIS_RESULTS_DETAILS MARD,
			MEMBER_ANALYSIS_RESULTS MAR
		WHERE
			MAR.ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.analysis_id#"> AND
			MAR.RESULT_ID = MARD.RESULT_ID AND
			MAR.RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">
	</cfquery>
</cfif>

<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','Analiz',57560)# : #get_analysis.analysis_head#"
	popup_box="1" 
	closable="1"
	resize="1"
	print_href="#request.self#?fuseaction=objects.popup_print_files&action_id=#url.analysis_id#&action_row_id=0" 
	is_blank="0">
<div>
	<cf_box_elements>
		
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
			<cfif isDefined("attributes.member_type")>
				<div class="form-group" id="item-get-partner">
					<div class="col col-6 col-md-6 col-sm-12 col-xs-12">
						<cf_get_lang dictionary_id='62332.Muhatap'>:
						<cfif attributes.member_type eq "partner">
							<cfoutput>#get_partner.company_partner_name# #get_partner.company_partner_surname# - #get_partner.nickname#</cfoutput>
						<cfelseif attributes.member_type eq "consumer">
							<cfoutput>#get_consumer.consumer_name# #get_consumer.consumer_surname#</cfoutput>
						</cfif>
					</div>
				</div>
			</cfif>
			<cfif get_analysis_questions.recordcount>
				<cfform name="add_member_analysis" method="post" action="#request.self#?fuseaction=member.emptypopup_add_member_analysis_result">
					<cfoutput>
						<cfif isDefined("attributes.is_report")><input type="hidden" name="is_report" id="is_report" value="#attributes.is_report#"></cfif><!--- Silmeyin rapordan baglanti saglaniyor --->
						<input type="hidden" name="analysis_id" id="analysis_id" value="#attributes.analysis_id#">
						<input type="hidden" name="period" id="period" value="<cfif isdefined("attributes.period")>#attributes.period#</cfif>">
						<input type="hidden" name="attendance_date" id="attendance_date" value="<cfif isdefined("attributes.attendance_date")>#attributes.attendance_date#</cfif>">
						<input type="hidden" name="action_type" id="action_type" value="<cfif isdefined("attributes.action_type")>#attributes.action_type#</cfif>">
						<input type="hidden" name="action_type_id" id="action_type_id" value="<cfif isdefined("attributes.action_type_id")>#attributes.action_type_id#</cfif>">
					
						<cfif isDefined("attributes.member_type") and attributes.member_type is "partner">
							<input type="hidden" name="partner_id" id="partner_id" value="#attributes.partner_id#">
							<input type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
							<input type="hidden" name="consumer_id" id="consumer_id" value="">
						<cfelseif isDefined("attributes.member_type") and attributes.member_type eq "consumer">
							<input type="hidden" name="partner_id" id="partner_id" value="">
							<input type="hidden" name="company_id" id="company_id" value="">
							<input type="hidden" name="consumer_id" id="consumer_id" value="#attributes.consumer_id#">
						</cfif>
					</cfoutput>
					<cfif isDefined("attributes.is_report")>
						<div class="form-group" id="item-get-comarison-type">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='30229.Soru Karşılaştırma Şekli'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<label><cf_get_lang dictionary_id ='57989.Ve'><input type="radio" name="comparison_type" id="comparison_type" value="1" checked></label>
								<label><cf_get_lang dictionary_id ='57998.Veya'><input type="radio" name="comparison_type" id="comparison_type" value="2"></label>
							</div>
						</div>
					</cfif>
					<cfoutput query="get_analysis_questions">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="58810.Soru"></cfsavecontent>
						<cf_seperator header="#question#" id="question#currentrow#" is_closed="1">
						<cf_flat_list id="question#currentrow#">
							<cfif isdefined("attributes.result_id")>
								<cfquery name="get_this_ques" dbtype="query">
									SELECT * FROM get_user_results WHERE QUESTION_ID = #question_id#
								</cfquery>
							</cfif>
							<cfif answer_number neq 0>
								<cfset attributes.question_id = question_id>
								<cfinclude template="../query/get_question_answers.cfm">
								<cfloop query="get_question_answers">
									<cfif len(evaluate("answer_photo")) or len(evaluate("answer_text"))>
										<tr>
											<cfswitch expression="#get_analysis_questions.question_type#">
												<cfcase value="1">
													<td><input type="radio" name="user_answer_#get_analysis_questions.currentrow#" id="user_answer_#get_analysis_questions.currentrow#" value="#get_question_answers.currentrow#" <cfif isdefined("get_this_ques.recordcount") and get_this_ques.QUESTION_USER_ANSWERS eq get_question_answers.currentrow>checked</cfif>>#answer_text#</td>
												</cfcase>
												<cfcase value="2">
													<td><input type="checkbox" name="user_answer_#get_analysis_questions.currentrow#" id="user_answer_#get_analysis_questions.currentrow#" value="#get_question_answers.currentrow#" <cfif isdefined("get_this_ques.recordcount") and listfindnocase(get_this_ques.QUESTION_USER_ANSWERS,get_question_answers.currentrow)>checked</cfif>>#answer_text#</td>
												</cfcase>
											</cfswitch>
											<input type="hidden" name="user_answer_#get_analysis_questions.currentrow#_point" id="user_answer_#get_analysis_questions.currentrow#_point" value="#evaluate('answer_point')#">
											<cfif len(evaluate("answer_photo"))>
												<td><cf_get_server_file output_file="member/#evaluate("get_question_answers.answer_photo")#" output_server="#evaluate("get_question_answers.answer_photo_server_id")#" output_type="0" image_width="38" image_height="35" image_link="1"></td>
											</cfif>
										</tr>
									</cfif>
								</cfloop>
							<cfelseif get_analysis_questions.answer_number eq 0 or get_analysis_questions.question_type eq 3>
								<input type="hidden" name="open_question" id="open_question" value="1">
								<tr>
									<td><textarea name="user_answer_#currentrow#" id="user_answer_#currentrow#" cols="45" rows="4" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="En Fazla 1500 Karakter Girebilirsiniz!"><cfif isdefined("get_this_ques.recordcount") and get_this_ques.recordcount>#get_this_ques.QUESTION_USER_ANSWERS#</cfif></textarea></td>
								</tr>
							</cfif>
							<cfif len(question_info)>
								<tr>
									<td><cf_get_lang dictionary_id='57556.Bilgi'>:</td>
								</tr>
								<tr>
									<td>#question_info#</td>
								</tr>
							</cfif>
						</cf_flat_list>
						<input type="hidden" name="user_answer_#currentrow#" id="user_answer_#currentrow#" value="">
					</cfoutput>
					<cf_box_footer>
						<cf_workcube_buttons is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_member_analysis' , #attributes.modal_id#)"),DE(""))#">
					</cf_box_footer>
				</cfform>
			</cfif>
		</div>
	</cf_box_elements>
</div>
</cf_box>