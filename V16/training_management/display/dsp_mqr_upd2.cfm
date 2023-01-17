<cfquery name="GET_EMP_QUIZ_ANSWERS" datasource="#dsn#">
	SELECT 
		QUIZ_RESULTS_DETAILS.*,
		QUIZ_RESULTS.USER_POINT
	FROM 
		QUIZ_RESULTS_DETAILS,
		QUIZ_RESULTS
	WHERE
		QUIZ_RESULTS_DETAILS.RESULT_ID = QUIZ_RESULTS.RESULT_ID AND
		QUIZ_RESULTS_DETAILS.RESULT_ID = #attributes.RESULT_ID# AND
		QUIZ_RESULTS.QUIZ_ID  = #attributes.QUIZ_ID# AND
		QUIZ_RESULTS_DETAILS.QUESTION_ID  = #attributes.QUESTION_ID# AND
		QUIZ_RESULTS.EMP_ID = #attributes.employee_id# AND
		QUIZ_RESULTS.IS_STOPPED_QUIZ = 1
</cfquery>
<form method="post" name="make_quiz">
<input type="Hidden" name="<cfoutput>user_answer_#attributes.question_row#</cfoutput>" id="<cfoutput>user_answer_#attributes.question_row#</cfoutput>" value="0">
<cfloop from="1" to="#evaluate(attributes.question_row-1)#" index="i">
	<cfoutput><input type="Hidden" name="user_answer_#i#" id="user_answer_#i#" value="#htmleditformat(evaluate("form.user_answer_#i#"))#"></cfoutput>
</cfloop>
<input type="Hidden" name="is_end_quiz" id="is_end_quiz" value="">
<input type="Hidden" name="question_row" id="question_row" value="<cfoutput>#evaluate(attributes.question_row+1)#</cfoutput>">
<cfoutput query="get_quiz_question2">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="txtbold">
	  <tr>
	      <td><cf_get_lang_main no='1398.Soru'> #attributes.question_row# : #question# <br/><br/></td>
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
					<input type="Radio" name="user_answer_#attributes.question_row#" id="user_answer_#attributes.question_row#" value="#i#"
							<cfif isdefined("GET_EMP_QUIZ_ANSWERS") and isdefined("GET_EMP_QUIZ_ANSWERS.RESULT_ID") and GET_EMP_QUIZ_ANSWERS.QUESTION_ID is QUESTION_ID and listlast(GET_EMP_QUIZ_ANSWERS.QUESTION_USER_ANSWERS) is i>checked</cfif>
					>
				  </cfcase>
				  <cfdefaultcase>
					<input type="checkbox" name="user_answer_#attributes.question_row#" id="user_answer_#attributes.question_row#" value="#i#"
							<cfif isdefined("GET_EMP_QUIZ_ANSWERS") and isdefined("GET_EMP_QUIZ_ANSWERS.RESULT_ID") and GET_EMP_QUIZ_ANSWERS.QUESTION_ID is QUESTION_ID and listlast(GET_EMP_QUIZ_ANSWERS.QUESTION_USER_ANSWERS) is i>checked</cfif>
					>
				  </cfdefaultcase>
			  </cfswitch>
			  <cfif len(evaluate("answer#i#_photo"))>
			  <img src="#file_web_path#training/#evaluate("answer#i#_photo")#" border="0">
			  </cfif>					
			  #evaluate("answer"&i&"_text")#
			  </td>
		  </tr>
		  </cfif>
	  </cfloop>
	<cfelse>
		<input type="Hidden" name="open_question" id="open_question" value="1">
		<tr>
			<td><textarea name="user_answer_#attributes.question_row#" id="user_answer_#attributes.question_row#" cols="45" rows="4"></textarea></td>
		</tr>
	</cfif>
	<cfif len(question_info)>
	  <tr>
		  <td>
		  <br/>
		  <cf_get_lang_main no='144.Bilgi'> :
		  #question_info#
	      </td>
	  </tr>
	</cfif>
	<tr>
	    <td>
			<cfif question_limit neq attributes.question_row>
				<!---bir önceki soruya dönmemesi icin kapatildi hitiyac olursa acilacak SG 20120718 --->
				<!---<cfsavecontent variable="message6">Geri</cfsavecontent>
				<input type="button" onClick="history.go(-1);" value="<cfoutput>#message6#</cfoutput>" name="Back" style="width:75px;">---->
				<cfsavecontent variable="message1"><cf_get_lang no='252.Sonraki Soru'></cfsavecontent>
				<cf_workcube_buttons is_upd='0' insert_info='#message1#'>
			<cfelse>
				<cfsavecontent variable="message"><cf_get_lang no='251.Sınavı Bitir'></cfsavecontent>
				<input type="button" onClick="is_end_quiz_function();" value="<cfoutput>#message#</cfoutput>" name="end" id="end" style="width:75px;"> 
			</cfif>
        </td>
	  	</tr>
	</table>
</cfoutput>
</form>

<script type="text/javascript">
	function is_end_quiz_function()
	{
		document.make_quiz.is_end_quiz.value = 1;
		document.make_quiz.action = "<cfoutput>#request.self#?fuseaction=training_management.emptypopup_upd_calc_quiz_result_r&result_id=#attributes.result_id#&quiz_id=#attributes.QUIZ_ID#&page_type=1&employee_id=#attributes.employee_id#</cfoutput>";
		document.make_quiz.submit();
	}
</script>
