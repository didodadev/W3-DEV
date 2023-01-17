<cfset xfa.submit_analysis = "#request.self#?fuseaction=objects2.emptypopup_calc_analysis">
<cfif get_analysis_questions.recordcount>
	<form name="make_analysis" method="post" action="<cfoutput>#xfa.submit_analysis#</cfoutput>">
	<input type="hidden" name="analysis_id" id="analysis_id" value="<cfoutput>#attributes.analysis_id#</cfoutput>">
	<cfoutput query="get_analysis_questions">
		<table align="center" style="width:96%;">
	  		<tr>
				<td><strong>Soru #currentrow#:</strong> #question# </td>
	  		</tr>
			<cfif answer_number neq 0>
				<cfquery name="GET_QUESTION_ANSWERS" datasource="#DSN#">
					SELECT ANSWER_TEXT,ANSWER_PHOTO,ANSWER_POINT,ROW FROM MEMBER_QUESTION_ANSWERS WHERE QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_analysis_questions.question_id#"> ORDER BY ROW
				</cfquery>
				<cfloop query="get_question_answers">
					<cfif len(evaluate("answer_photo")) or len(evaluate("answer_text"))>
						<tr>
							<td>
								<cfswitch expression="#get_analysis_questions.question_type#">
									<cfcase value="1">
									  <input type="Radio" name="user_answer_#get_analysis_questions.currentrow#" id="user_answer_#get_analysis_questions.currentrow#" value="#get_question_answers.row#">
									</cfcase>
									<cfcase value="2">
									  <input type="checkbox" name="user_answer_#get_analysis_questions.currentrow#" id="user_answer_#get_analysis_questions.currentrow#" value="#get_question_answers.row#">
									</cfcase>
								</cfswitch>
								<input type="hidden" name="user_answer_#get_analysis_questions.currentrow#_point" id="user_answer_#get_analysis_questions.currentrow#_point" value="#evaluate('answer_point')#">
								#evaluate("answer_text")#
								<cfif isdefined("answer_photo") and len(evaluate("answer_photo"))>
									<cf_get_server_file output_file="member/#evaluate("answer_photo")#" output_server="#evaluate("answer_photo_server_id")#" output_type="0" image_width="40" image_height="50" image_link="1" alt="#getLang('main',668)#" title="#getLang('main',668)#">
								</cfif>
							</td>
						</tr>
					</cfif>
				</cfloop>
				<!---<cfloop from="1" to="20" index="i">
					<cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
						<tr>
							<td>
								<cfswitch expression="#question_type#">
									<cfcase value="1">
									  <input type="Radio" name="user_answer_#currentrow#" id="user_answer_#currentrow#" value="#i#">
									</cfcase>
									<cfcase value="2">
									  <input type="checkbox" name="user_answer_#currentrow#" id="user_answer_#currentrow#" value="#i#">
									</cfcase>
								</cfswitch>
								<input type="hidden" name="user_answer_#currentrow#_point" id="user_answer_#currentrow#_point" value="#evaluate('answer'&i&'_point')#">
								#evaluate("answer"&i&"_text")#
								<cfif isdefined("answer"&i&"_photo") and len(evaluate("answer"&i&"_photo"))>
									<cf_get_server_file output_file="member/#evaluate("answer"&i&"_photo")#" output_server="#evaluate("answer"&i&"_photo_server_id")#" output_type="0" image_width="40" image_height="50" image_link="1" alt="#lang_array_main.item[668]#" title="#lang_array_main.item[668]#">
								</cfif>
							</td>
						</tr>
					</cfif>
				</cfloop>--->
			<cfelse>
				<input type="hidden" name="open_question" id="open_question" value="1">
			  	<tr>
					<td><textarea name="user_answer_#currentrow#" id="user_answer_#currentrow#" cols="45" rows="4"></textarea></td>
			  	</tr>
			</cfif>
			<cfif len(question_info)>
				<tr>
				  	<td> <strong>Açıklama:</strong> #question_info# </td>
				</tr>
			</cfif>
			<tr>
			  	<td><img src="/images/cizgi_yan_50.gif" width="100%" height="15"></td>
			</tr>
		</table>
	</cfoutput>
	<table align="center" style="width:96%;">
		<tr>
			<td>
				<cf_workcube_buttons is_upd='0' add_function='kontrol_text()'>
			</td>
		</tr>
	</table>
	</form>
</cfif>
<script type="text/javascript">
	function kontrol_text()
	{
		<cfoutput query="get_analysis_questions">
			<cfif answer_number eq 0>
				x=(1000 - document.getElementById('user_answer_#currentrow#').value.length);
				if( x < 0)
				{ 
					alert ("<cf_get_lang no='385.Cevap Alanına En Fazla 1000 Karakter Girebilirsiniz'>!\n<cf_get_lang no='386.Fazla Karakter Sayısı'> :" + (x * (-1)));
					return false;
				}
			</cfif>
		</cfoutput>
	}
</script>

