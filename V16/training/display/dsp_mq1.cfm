<cfif get_quiz_questions.recordcount>
  <form name="make_quiz" action="<cfoutput>#xfa.submit_quiz#</cfoutput>" method="post">
    <input type="Hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
	<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#attributes.class_id#</cfoutput>">
	<input type="hidden" name="insert_type" id="insert_type" value="1">
    <cfoutput query="get_quiz_questions">
      <table width="98%" align="center">
        <tr>
          <td><strong><cf_get_lang_main no='1398.Soru'> #currentrow#:</strong> #question# </td>
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
                    <input type="Radio" name="user_answer_#currentrow#" id="user_answer_#currentrow#" value="#i#">
                    </cfcase>
                    <cfdefaultcase>
                    <input type="checkbox" name="user_answer_#currentrow#" id="user_answer_#currentrow#" value="#i#">
                    </cfdefaultcase>
                  </cfswitch>
                  <cfif len(evaluate("answer"&i&"_photo"))>
                    <img src="#file_web_path#training/#evaluate("answer"&i&"_photo")#" border="0">
                  </cfif>
                  #evaluate("answer"&i&"_text")# </td>
              </tr>
            </cfif>
          </cfloop>
          <cfelse>
          <input type="Hidden" name="open_question" id="open_question" value="1">
          <tr>
            <td><textarea name="user_answer_#currentrow#" id="user_answer_#currentrow#" cols="65" rows="4"></textarea>
            </td>
          </tr>
        </cfif>
        <cfif len(question_info)>
          <tr>
            <td><strong><cf_get_lang_main no='217.Açıklama'>: </strong> #question_info# </td>
          </tr>
        </cfif>
        <tr>
          <td><img src="/images/cizgi_yan_50.gif" width="100%" height="15"></td>
        </tr>
      </table>
      <input type="Hidden" name="user_answer_#currentrow#" id="user_answer_#currentrow#" value="">
    </cfoutput>
    <cf_popup_box_footer>
        <table align="right">
            <tr>
                <td>
                    <input type="Reset" value="Reset" style="width:65px;">
                    <cfsavecontent variable="message"><cf_get_lang no='1.Sınavı Bitir'></cfsavecontent>
                    <cf_workcube_buttons is_upd='0' insert_info='#message#'>
                </td>
            </tr>
        </table>
    </cf_popup_box_footer>
  </form>
  <cfset submit_time = get_quiz.total_time*60000>
  <script type="text/javascript">
	/*zamanlayıcı triger*/
    setTimeout("document.make_quiz.submit()", <cfoutput>#submit_time#</cfoutput>);
</script>
</cfif>

