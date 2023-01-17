<style type="text/css">
	.txtbold {font-weight:bold; font-size:11px; color:#000000}
	.txtboldblue {font-weight: bold; font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 10px; color: #6699CC; padding-right: 1px; padding-left: 1px}
</style>
<cfset attributes.result_id = attributes.action_row_id>
<cfset attributes.analysis_id = attributes.action_id>
<cfquery name="RESULT_DETAIL" datasource="#DSN#">
	SELECT 
		RESULT_ID,
		ANALYSIS_ID,
		COMPANY_ID,
		PARTNER_ID,
		CONSUMER_ID,
		USER_POINT,
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_EMP,
		UPDATE_DATE
	FROM 
		MEMBER_ANALYSIS_RESULTS
	WHERE 
		RESULT_ID = #attributes.result_id#
</cfquery>
<cfinclude template="/V16/member/query/get_analysis.cfm">
<cfinclude template="/V16/member/query/get_analysis_questions.cfm">
<cfquery name="MEMBER_ANALYSIS_RESULTS_DETAILS_ALL" datasource="#DSN#">
	SELECT 
		RESULT_DETAIL_ID, 
		RESULT_ID,
		QUESTION_ID,
		QUESTION_POINT,
		QUESTION_USER_ANSWERS
	FROM 
		MEMBER_ANALYSIS_RESULTS_DETAILS 
	WHERE 
		RESULT_ID = #attributes.result_id#
</cfquery>
<cfoutput query="get_analysis_questions">
	<cfquery name="GET_RESULT_DETAIL" dbtype="query">
		SELECT * FROM MEMBER_ANALYSIS_RESULTS_DETAILS_ALL WHERE QUESTION_ID = #get_analysis_questions.question_id#
	</cfquery>
	<table id="puan#currentrow#" width="100%">
		<tr class="color-row" valign="top" >
				<td class="t" width="50"><cf_get_lang_main no='1572.Puan'></td>
				<td class="txtboldblue"><cf_get_lang_main no='1398.Soru'> #currentrow# : #question#</td>
		</tr>
		<cfif answer_number neq 0>
			<cfset attributes.question_id = get_analysis_questions.question_id>
			<cfinclude template="/V16/member/query/get_question_answers.cfm">
			<cfloop query="get_question_answers">	
				<cfset temp_answer_photo = evaluate('get_question_answers.answer_photo')>
				<cfset temp_answer_photo_server_id = evaluate('get_question_answers.answer_photo_server_id')>
				<cfset temp_answer_text = evaluate('get_question_answers.answer_text')>
				<cfset temp_answer_point = evaluate('get_question_answers.answer_point')>
				<cfif len(temp_answer_photo) or len(temp_answer_text)>
					<tr>
						<td>(#temp_answer_point#)</td>
						<td><cfswitch expression="#get_analysis_questions.question_type#">
								<cfcase value="1">
									<input type="radio" name="user_answer_#get_analysis_questions.currentrow#" id="user_answer_#get_analysis_questions.currentrow#" value="#get_question_answers.currentrow#" <cfif ListFind(get_result_detail.question_user_answers,get_question_answers.currentrow,",")> checked</cfif>>
								</cfcase>
								<cfcase value="2">
									<input type="checkbox" name="user_answer_#get_analysis_questions.currentrow#" id="user_answer_#get_analysis_questions.currentrow#" value="#get_question_answers.currentrow#" <cfif ListFind(get_result_detail.question_user_answers,get_question_answers.currentrow,",")> checked</cfif>>
								</cfcase>
							</cfswitch>
							<input type="hidden" name="user_answer_#get_analysis_questions.currentrow#_point" id="user_answer_#get_analysis_questions.currentrow#_point" value="#temp_answer_point#">
							<cfif len(temp_answer_photo)>
								<cf_get_server_file output_file="member/#temp_answer_photo#" output_server="#temp_answer_photo_server_id#" output_type="2" small_image="/images/photo.gif" image_link="1">
							</cfif>
							#temp_answer_text#
						</td>
					</tr>
				  </cfif>
			 </cfloop>
	   <cfelseif get_analysis_questions.answer_number eq 0 or get_analysis_questions.question_type eq 3>
			<tr>
				<td><cfif get_result_detail.recordcount>
						<input type="text" name="open_question_#currentrow#" id="open_question_#currentrow#" value="<cfif len(get_result_detail.question_point)>#get_result_detail.question_point#<cfelse>0</cfif>" style="width:25px"> 
					<cfelse>
						<input type="text" name="open_question_#currentrow#" id="open_question_#currentrow#" value="0" style="width:25px"> 
					</cfif>
				</td>
				<td><textarea name="user_answer_#question_id#_#currentrow#" id="user_answer_#question_id#_#currentrow#" cols="45" rows="4" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="En Fazla 1500 Karakter Girebilirsiniz!">#left(get_result_detail.question_user_answers,1000)#</textarea></td>   
			</tr>
		</cfif>
		<cfif len(question_info)>
			<tr>
				<td>&nbsp;</td>
				<td><b><cf_get_lang_main no='144.Bilgi'> :</b> #question_info#</td>
			</tr>
		</cfif>
	</table>
</cfoutput> 
<cfoutput query="result_detail">
	<table width="98%" border="0" cellspacing="1" cellpadding="2">
		<tr>
			<td class="txtbold"><cf_get_lang_main no='1573.Toplam Puan'>: #user_point#</td>
		</tr>
	</table>
</cfoutput>
