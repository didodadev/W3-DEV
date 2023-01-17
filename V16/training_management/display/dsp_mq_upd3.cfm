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
	<input type="hidden" name="<cfoutput>user_answer_#attributes.question_row#</cfoutput>" id="<cfoutput>user_answer_#attributes.question_row#</cfoutput>" value="">
	<input type="hidden" name="is_end_quiz" id="is_end_quiz" value="">
	<cfif isdefined("form.view_answer")>
		<cfloop from="1" to="#attributes.question_row#" index="i">
		  <cfoutput>
			<input type="hidden" name="user_answer_#i#" id="user_answer_#i#" value="#htmleditformat(evaluate("form.user_answer_#i#"))#">
		  </cfoutput>
		</cfloop>
    <cfelse>
		<cfloop from="1" to="#evaluate(attributes.question_row-1)#" index="i">
		  <cfoutput>
			<input type="hidden" name="user_answer_#i#" id="user_answer_#i#" value="#htmleditformat(evaluate("form.user_answer_#i#"))#">
		  </cfoutput>
		</cfloop>
  </cfif>
  <cfif isDefined("attributes.open_question")>
    <input type="hidden" name="open_question" id="open_question" value="1">
  </cfif>
  <cfif isDefined("attributes.view_answer")>
    <input type="hidden" name="question_row" id="question_row" value="<cfoutput>#evaluate(attributes.question_row+1)#</cfoutput>">
    <!--- cevabı görüntüle --->
    <table class="txtbold">
      <tr>
        <td><cf_get_lang no='48.Doğru Cevaplar'> :<br/>
          <br/>
        </td>
      </tr>
      <cfloop from="1" to="#get_quiz_question.ANSWER_NUMBER#" index="k">
        <cfset temp_bool = evaluate("get_quiz_question.answer#k#_true")>
        <cfif temp_bool eq 1>
          <tr>
            <td>
              <cfset temp_photo = evaluate("get_quiz_question.answer#k#_photo")>
              <cfoutput>
                <cfif len(temp_photo)>
                  <img src="#file_web_path#training/#evaluate("get_quiz_question.answer#k#_photo")#" border="0">
                </cfif>
                #evaluate("get_quiz_question.answer"&k&"_text")# </cfoutput></td>
          </tr>
        </cfif>
      </cfloop>
      <cfif (not get_quiz_question.recordcount) or (question_limit EQ attributes.question_row)>
        <tr>
          <td>
		  <br/>
            <br/>
	  		<cfsavecontent variable="message"><cf_get_lang no='251.Sınavı Bitir'></cfsavecontent>
            <input type="button" onClick="is_end_quiz_function();" value="<cfoutput>#message#</cfoutput>" name="end" style="width:75px;"> 
			</td>
        </tr>
        <cfelse>
        <tr>
          <td>
		  <br/>
            <br/>
			<cfsavecontent variable="message6"><cf_get_lang no="97.Önceki Soru"></cfsavecontent>
			<input type="button" onClick="history.go(-1);" value="<cfoutput>#message6#</cfoutput>" name="Back" style="width:75px;">
	  		<cfsavecontent variable="message1"><cf_get_lang no='252.Sonraki Soru'></cfsavecontent>
            <cf_workcube_buttons is_upd='0' insert_info='#message1#'> </td>
        </tr>
      </cfif>
    </table>
    <cfelse>
    <input type="hidden" name="question_row" id="question_row" value="<cfoutput>#attributes.question_row#</cfoutput>">
    <input type="hidden" name="view_answer" id="view_answer" value="1">
    <!--- toplam süre yada soru süresi hesabı sonucu tek değişkene at --->
    <cfif get_quiz.total_time is "">
      <cfset submit_time = get_quiz_question.question_time>
      <cfelse>
      <cfif get_quiz.max_questions LTE get_quiz_question_count.counted>
        <cfset submit_time = round(get_quiz.total_time/get_quiz.max_questions)*60000>
        <cfelse>
        <cfset submit_time = round(get_quiz.total_time/get_quiz_question_count.counted)*60000>
      </cfif>
    </cfif>
    <!--- soruyu görüntüle --->
    <cfoutput query="get_quiz_question">
      <script type="text/javascript">
			/*zamanlayıcı triger*/
		    setTimeout("document.make_quiz.submit()", #submit_time#);
		</script>
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="txtbold">
        <tr>
          <td><cf_get_lang_main no='1398.Soru'> #attributes.question_row# : #question# <br/>
            <br/>
          </td>
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
                  #evaluate("answer"&i&"_text")# </td>
              </tr>
            </cfif>
          </cfloop>
          <cfelse>
          <input type="hidden" name="open_question" id="open_question" value="1">
          <tr>
            <td><textarea name="user_answer_#attributes.question_row#" id="user_answer_#attributes.question_row#" cols="45" rows="4"></textarea>
            </td>
          </tr>
        </cfif>
        <cfif len(question_info)>
          <tr>
            <td> <br/>
              <cf_get_lang_main no='144.Bilgi'>:#question_info# </td>
          </tr>
        </cfif>
        <tr>
          <td>
		  <br/>
            <br/>
			<cfif attributes.question_row gt 1>
				<cfsavecontent variable="message6"><cf_get_lang_main no="20.Geri"></cfsavecontent>
				<input type="button" onClick="history.go(-1);" value="<cfoutput>#message6#</cfoutput>" name="Back" style="width:75px;">
			</cfif>
	  		<cfsavecontent variable="message3"><cf_get_lang_main no="1242.Cevap"></cfsavecontent>
           <cf_workcube_buttons is_upd='0' insert_info='#message3#'>
			</td>
        </tr>
      </table>
    </cfoutput>
  </cfif>
</form>
<script type="text/javascript">
	function is_end_quiz_function()
	{
		document.make_quiz.is_end_quiz.value = 1;
		document.make_quiz.action = "<cfoutput>#request.self#?fuseaction=training_management.emptypopup_upd_calc_quiz_result&result_id=#attributes.result_id#&quiz_id=#attributes.QUIZ_ID#&page_type=1&employee_id=#attributes.employee_id#</cfoutput>";
		document.make_quiz.submit();
	}
</script>
