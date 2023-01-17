<cfset xfa.submit_analysis = "#request.self#?fuseaction=crm.emptypopup_calc_analysis">
<cfif get_analysis_questions.recordcount>
  <form name="make_analysis" action="<cfoutput>#xfa.submit_analysis#</cfoutput>" method="post">
    <input type="Hidden" name="analysis_id" id="analysis_id" value="<cfoutput>#attributes.analysis_id#</cfoutput>">
  <cfif isdefined("attributes.is_popup")>
	  <input type="hidden" name="is_popup" id="is_popup" value="<cfoutput>#attributes.is_popup#</cfoutput>">
  </cfif>
    <cfoutput query="get_analysis_questions">
      <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td class="txtbold"><cf_get_lang dictionary_id="58810.Soru"> #currentrow# : #question# </td>
        </tr>
        <cfif ANSWER_NUMBER NEQ 0>
          <cfloop from="1" to="20" index="i">
            <cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
              <tr>
                <td>
                  <cfswitch expression="#QUESTION_TYPE#">
                    <cfcase value="1">
                    <input type="Radio" name="user_answer_#currentrow#" id="user_answer_#currentrow#" value="#i#">
                    </cfcase>
                    <cfcase value="2">
                    <input type="checkbox" name="user_answer_#currentrow#" id="user_answer_#currentrow#" value="#i#">
                    </cfcase>
                  </cfswitch>
                  <input type="Hidden" name="user_answer_#currentrow#_point" id="user_answer_#currentrow#_point" value="#evaluate('answer'&i&'_point')#">
                  <cfif len(evaluate("answer"&i&"_photo"))>
                    <img src="#file_web_path#member/#evaluate("answer"&i&"_photo")#" border="0">
                  </cfif>
                  #evaluate("answer"&i&"_text")# </td>
              </tr>
            </cfif>
          </cfloop>
          <cfelse>
          <input type="hidden" name="open_question" id="open_question" value="1">
          <tr>
            <td><textarea name="user_answer_#currentrow#" id="user_answer_#currentrow#" cols="45" rows="4"></textarea>
            </td>
          </tr>
        </cfif>
        <cfif len(question_info)>
          <tr>
            <td class="txtbold"><cf_get_lang_main no='144.Bilgi'>: #question_info# </td>
          </tr>
        </cfif>
        <tr>
          <td><img src="/images/cizgi_yan_50.gif" width="100%" height="15"></td>
        </tr>
      </table>
      <input type="hidden" name="user_answer_#currentrow#" id="user_answer_#currentrow#" value="">
    </cfoutput>
    <table>
      <tr>
        <td> 
		<cf_workcube_buttons is_upd='0'> 
		</td>
      </tr>
    </table>
  </form>
</cfif>

