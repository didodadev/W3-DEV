<cfinclude template="../query/get_result_detail.cfm">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" height="35">
  <tr>
    <td class="headbold"><cf_get_lang no='49.Değerlendirme'></td>
  </tr>
</table>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr class="color-border">
    <td>
      <table width="100%" border="0" cellspacing="1" cellpadding="2">
        <tr class="color-row">
          <td>
            <table>
              <form name="read_quiz" id="read_quiz" action="<cfoutput>#request.self#?fuseaction=training_management.upd_result</cfoutput>" method="post">
                <input type="Hidden" name="result_id" id="result_id" value="<cfoutput>#attributes.result_id#</cfoutput>">
                <input type="Hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
                <input type="Hidden" name="counter" id="counter" value="<cfoutput>#get_result_detail.recordcount#</cfoutput>">
                <cfoutput query="get_result_detail">
                  <cfif len(question_rights) and len(question_user_answers)>
                    <!--- kontrol --->
                    <!--- hidden D/Y --->
                    <cfif question_rights is question_user_answers>
                      <input type="Hidden" name="user_right_#currentrow#" id="user_right_#currentrow#" value="1">
                      <input type="hidden" name="point_#currentrow#" id="point_#currentrow#" value="#question_point#">
                      <cfelse>
                      <input type="Hidden" name="user_right_#currentrow#" id="user_right_#currentrow#" value="-1">
                    </cfif>
                    <cfelseif (question_rights is "") and len(question_user_answers)>
                    <!--- kullanıcı cevabını yaz radio D/Y --->
                    <cfset attributes.question_id = question_id>
                    <cfinclude template="../query/get_question.cfm">
                    <tr height="20">
                      <td width="100" class="txtbold"><cf_get_lang_main no='1398.Soru'></td>
                      <td>#get_question.question#</td>
                    </tr>
                    <tr height="20">
                      <td class="txtbold"><cf_get_lang no='50.Verilen Cevap'></td>
                      <td>#question_user_answers#</td>
                    </tr>
                    <tr>
                      <td class="txtbold"><cf_get_lang no='49.Değerlendirme'></td>
                      <td>
                        <input type="hidden" name="point_#currentrow#" id="point_#currentrow#" value="#question_point#">
                        <input type="radio" name="user_right_#currentrow#" id="user_right_#currentrow#" value="1">
                        <cf_get_lang no='51.Doğru'>
                        <input type="radio" name="user_right_#currentrow#" id="user_right_#currentrow#" value="-1">
                        <cf_get_lang no='52.Yanlış'> </td>
                    </tr>
                    <tr>
                      <td colspan="2"><HR>
                      </td>
                    </tr>
                    <cfelse>
                    <!--- boş --->
                    <input type="Hidden" name="user_right_#currentrow#" id="user_right_#currentrow#" value="0">
                  </cfif>
                </cfoutput>
                <tr height="35">
                  <td colspan="2" style="text-align:right;">
				  <cf_workcube_buttons is_upd='0'>
				  </td>
                </tr>
              </form>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

