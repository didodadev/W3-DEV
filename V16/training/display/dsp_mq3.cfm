<cfif ((not get_quiz_question.recordcount) or (question_limit EQ attributes.question_row))>
	<cfif isdefined("form.view_answer")>
		<!--- veritabanına ilk kaydı gir --->
		<cfset session.quiz_start = now()>
		<cfset session.quiz_id = attributes.quiz_id>
		<cfinclude template="../query/add_quiz_result.cfm">
	</cfif>
</cfif>
<cfif (not get_quiz_question.recordcount) or (question_limit EQ attributes.question_row)>
<cfif isDefined("attributes.view_answer")>
<cfoutput>
<form method="post" action="#xfa.submit_quiz#" name="make_quiz" id="make_quiz">
<input type="Hidden" name="quiz_id" id="quiz_id" value="#attributes.quiz_id#">
<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#attributes.class_id#</cfoutput>">
</cfoutput>
<cfelse>
<form method="post" name="make_quiz" id="make_quiz">
</cfif>
<cfelse>
<form method="post" name="make_quiz" id="make_quiz">
  </cfif>
  <input type="Hidden" name="<cfoutput>user_answer_#attributes.question_row#</cfoutput>" id="<cfoutput>user_answer_#attributes.question_row#</cfoutput>" value="">
  <!--- önceki cevapları ekle --->
  <cfif isdefined("form.view_answer")>
    <cfloop from="1" to="#attributes.question_row#" index="i">
      <cfoutput>
        <input type="Hidden" name="user_answer_#i#" id="user_answer_#i#" value="#htmleditformat(evaluate("form.user_answer_#i#"))#">
      </cfoutput>
    </cfloop>
    <cfelse>
    <cfloop from="1" to="#evaluate(attributes.question_row-1)#" index="i">
      <cfoutput>
        <input type="Hidden" name="user_answer_#i#" id="user_answer_#i#" value="#htmleditformat(evaluate("form.user_answer_#i#"))#">
      </cfoutput>
    </cfloop>
  </cfif>
  <cfif isDefined("attributes.open_question")>
    <input type="Hidden" name="open_question" id="open_question" value="1">
  </cfif>
  <cfif isDefined("attributes.view_answer")>
    <input type="Hidden" name="question_row" id="question_row" value="<cfoutput>#evaluate(attributes.question_row+1)#</cfoutput>">
    <!--- cevabı görüntüle --->
    <table width="98%" align="center">
      <tr>
        <td><strong><cf_get_lang no='47.Doğru Cevaplar'>:</strong><br/>
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
                #evaluate("get_quiz_question.answer"&k&"_text")# </cfoutput> </td>
          </tr>
        </cfif>
      </cfloop>
      <cfif (not get_quiz_question.recordcount) or (question_limit EQ attributes.question_row)>
        <tr>
          <td><br/>
            <br/>
		<cfsavecontent variable="message"><cf_get_lang no='1.Sınavı Bitir'></cfsavecontent>
            <cf_workcube_buttons is_upd='0' insert_info='#message#'> <!---add_function='#xfa.submit_quiz#'---></td>
        </tr>
        <cfelse>
        <tr>
          <td><br/>
            <br/>
		<cfsavecontent variable="message"><cf_get_lang no='9.Sonraki Soru'></cfsavecontent>
			<cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='#message#'>
          </td>
        </tr>
      </cfif>
    </table>
    <cfelse>
    <input type="Hidden" name="question_row" id="question_row" value="<cfoutput>#attributes.question_row#</cfoutput>">
    <input type="Hidden" name="view_answer" id="view_answer" value="1">
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
      <table width="98%" align="center">
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
                    <input type="Radio" name="user_answer_#attributes.question_row#" id="user_answer_#attributes.question_row#" value="#i#">
                    </cfcase>
                    <cfdefaultcase>
                    <input type="checkbox" name="user_answer_#attributes.question_row#" id="user_answer_#attributes.question_row#" value="#i#">
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
          <input type="Hidden" name="open_question" id="open_question" value="1">
          <tr>
            <td><textarea name="user_answer_#attributes.question_row#" id="user_answer_#attributes.question_row#" cols="45" rows="4"></textarea>
            </td>
          </tr>
        </cfif>
        <cfif len(question_info)>
          <tr>
            <td> <br/>
              <strong><cf_get_lang_main no='217.Açıklama'>: </strong> #question_info# </td>
          </tr>
        </cfif>
        <tr>
          <td><br/>
            <br/>
		<cfsavecontent variable="message"><cf_get_lang_main no='1242.Cevap'></cfsavecontent>
			<cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='#message#'>
          </td>
        </tr>
      </table>
    </cfoutput>
  </cfif>
</form>

