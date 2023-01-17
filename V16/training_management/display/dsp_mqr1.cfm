<cfif get_quiz_questions.recordcount>
<form name="make_quiz" action="<cfoutput>#xfa.submit_quiz#</cfoutput>" method="post">
<input type="Hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
<input type="Hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
<input type="Hidden" name="page_type" id="page_type" value="<cfoutput>#attributes.page_type#</cfoutput>">
<!--- <input type="hidden" name="insert_type" value="1"> --->
<cfset counter=0>
<cfloop list="#session.random_list#" index="k">
	<cfset counter = counter+1>
	<cfset attributes.question_id = k>
	<cfinclude template="../query/get_quiz_question2.cfm">
	<cfoutput query="get_quiz_question2">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="txtbold">
		  <tr>
		      <td><cf_get_lang_main no='1398.Soru'>#counter# : #question#</td>
		  </tr>
		<cfif ANSWER_NUMBER NEQ 0>
		  <cfset right_number = 0>
		  <cfloop from="1" to="#answer_number#" index="i">
				<cfif evaluate("answer#i#_true") eq 1>
					<cfset right_number = right_number + 1>
				</cfif>
		  </cfloop>
		  <cfloop from="1" to="20" index="i">
		  <cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
		  <tr>
			  <td>
			  <cfswitch expression="#right_number#">
				  <cfcase value="1">
				  	<input type="Radio" name="user_answer_#counter#" id="user_answer_#counter#" value="#i#">
				  </cfcase>
				  <cfdefaultcase>
				  	<input type="checkbox" name="user_answer_#counter#" id="user_answer_#counter#" value="#i#">
				  </cfdefaultcase>
			  </cfswitch>
			  <cfif len(evaluate("answer"&i&"_photo"))>
			  <img src="#file_web_path#training/#evaluate("answer"&i&"_photo")#" border="0">
			  </cfif>					
			  #evaluate("answer"&i&"_text")#
		      </td>
		  </tr>
		  </cfif>
		  </cfloop>
		<cfelse>
			<input type="Hidden" name="open_question" id="open_question" value="1">
			<tr>
				<td><textarea name="user_answer_#counter#" id="user_answer_#counter#" cols="45" rows="4"></textarea></td>
			</tr>
		</cfif>
		  <cfif len(question_info)>
		  <tr>
			  <td>
			  <cf_get_lang_main no='144.Bilgi'> :
			  #question_info#
		      </td>
		  </tr>
		  </cfif>
		  <tr>
		      <td><img src="/images/cizgi_yan_50.gif" width="100%" height="15"></td>
		  </tr>
		</table>
		<input type="Hidden" name="user_answer_#counter#" id="user_answer_#counter#" value="">
	</cfoutput>			
</cfloop>
<table>
  <tr>
      <td>
		<cfsavecontent variable="message1">Sınavı Durdur</cfsavecontent>
	    <input type="Reset" value="<cfoutput>#message1#</cfoutput>" name="Reset" id="Reset" style="width:75px;">
	    <cfsavecontent variable="message"><cf_get_lang no='251.Sınavı Bitir'></cfsavecontent>
		<cf_workcube_buttons is_upd='0' insert_info='#message#'>
      </td>
  </tr>
 </table>
</form>
<cfset submit_time = get_quiz.total_time*60000>
<script type="text/javascript">
	/*zamanlayıcı triger*/
    setTimeout("document.make_quiz.submit()", <cfoutput>#submit_time#</cfoutput>);
</script>
</cfif>
