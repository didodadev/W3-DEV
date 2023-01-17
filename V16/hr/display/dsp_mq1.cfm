<cfif get_quiz_questions.recordcount>
	<form name="make_quiz" id="make_quiz" action="<cfoutput>#xfa.submit_quiz#</cfoutput>" method="post">
	<input type="Hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
	<cfoutput query="get_quiz_questions">
	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td class="txtbold"><cf_get_lang_main no='1398.Soru'> #currentrow# : #question# </td>
	  	</tr>
		<cfif ANSWER_NUMBER NEQ 0>
		  <cfloop from="1" to="20" index="i">
			  <cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
				  <tr>
					  <td>
						  <cfswitch expression="#ANSWER_TYPE#">
							  <cfcase value="1">
								<input type="Radio" name="user_answer_#currentrow#" id="user_answer_#currentrow#" value="#i#">
							  </cfcase><!--- ,#evaluate("answer"&i&"_point")# --->
							  <cfdefaultcase>
								<input type="checkbox" name="user_answer_#currentrow#" id="user_answer_#currentrow#" value="#i#">
							  </cfdefaultcase>
						  </cfswitch>
							
						  <cfif len(evaluate("answer"&i&"_photo"))>
							  <img src="#file_web_path#hr/#evaluate("answer"&i&"_photo")#" border="0">
						  </cfif>					
						  #evaluate("answer"&i&"_text")#
						  <input type="hidden" name="user_answer_#currentrow#_point" id="user_answer_#currentrow#_point" value="#evaluate("answer"&i&"_point")#">
					  </td>
				  </tr>
			  </cfif>
		  </cfloop>
		<cfelse>
			<input type="Hidden" name="open_question" id="open_question" value="1">
			<tr>
				<td>
				<textarea name="user_answer_#currentrow#" id="user_answer_#currentrow#" cols="45" rows="4"></textarea>
				<!--- <input type="hidden" name="user_answer_#currentrow#_point" value="#evaluate("answer"&i&"_point")#"> --->
				</td>
			</tr>
		</cfif>
		<cfif len(question_info)>
			<tr>
				<td class="txtbold">
				<cf_get_lang no='246.Bilgi'> :
				#question_info#
				</td>
			</tr>
		</cfif>
		<tr>
			<td><img src="/images/cizgi_yan_50.gif" width="100%" height="15"></td>
		</tr>
	</table>
		<input type="Hidden" name="user_answer_#currentrow#" id="user_answer_#currentrow#" value="">
	</cfoutput>			
	<table>
	  <tr>
		  <td>
		  <cfsavecontent variable="message"><cf_get_lang dictionary_id="55569.Formu Bitir"></cfsavecontent>
		  <cf_workcube_buttons is_upd='0' insert_info='#message#'>
			<input type="Reset" value="Sıfırla" style="width:65px;">
		  </td>
	  </tr>
	 </table>
	</form>
 </cfif>
