<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr class="color-border">
    <td valign="top">
      <table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
        <tr class="color-list" height="35">
          <td class="headbold">&nbsp;<cf_get_lang no='77.Test Kağıdı'></td>
        </tr>
        <tr class="color-row">
          <td valign="top">
            <cfinclude template="../query/get_result_detail.cfm">
            <cfoutput query="get_result_detail">
              <table width="100%">
                <tr class="formbold">
                  <td>D</td>
                  <td>C</td>
                  <td class="txtbold">&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td class="txtbold"><cf_get_lang_main no='1398.Soru'></td>
                </tr>
                <tr>
                  <td width="10">&nbsp;</td>
                  <td width="10">&nbsp;</td>
                  <td>#currentrow# : #question#</td>
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
                        <td width="10"><cfif listcontains(QUESTION_RIGHTS,i)>*</cfif></td>
                        <td width="10"><cfif listcontains(QUESTION_USER_ANSWERS,i)><font color="red">*</font></cfif></td>
                        <td>
                          <cfif len(evaluate("answer#i#_photo"))>
                            <img src="#file_web_path#training/#evaluate("answer#i#_photo")#" border="0">
                          </cfif>#evaluate("answer#i#_text")# </td>
                      </tr>
                    </cfif>
                  </cfloop>
                  <cfelse>
                  <tr>
                    <td></td>
                    <td></td>
                    <td class="txtbold"><cf_get_lang no='61.Doğru Cevap'></td>
                  </tr>
                  <tr>
                    <td width="10"></td>
                    <td width="10"></td>
                    <td>#QUESTION_RIGHTS#</td>
                  </tr>
                  <tr>
                    <td></td>
                    <td></td>
                    <td class="txtbold"><cf_get_lang no='50.Verilen Cevap'></td>
                  </tr>
                  <tr>
                    <td width="10"></td>
                    <td width="10"></td>
                    <td>#QUESTION_USER_ANSWERS#</td>
                  </tr>
                </cfif>
                <cfif LEN(question_info)>
                  <tr>
                    <td width="10"></td>
                    <td width="10"></td>
                    <td class="txtbold"> <cf_get_lang_main no='144.Bilgi'> : #question_info# </td>
                  </tr>
                </cfif>
                <tr>
                  <td colspan="3"><img src="/images/cizgi_yan_50.gif" width="100%" height="15"></td>
                </tr>
              </table>
            </cfoutput> <cfoutput query="RESULT_DETAIL">
              <table>
                <tr>
                  <td><cf_get_lang no='78.Toplam Doğru'> : #user_right_count#</td>
                </tr>
                <tr>
                  <td><cf_get_lang no='79.Toplam Yanlış'> : #user_WRONG_count#</td>
                </tr>
                <tr>
                  <td><cf_get_lang_main no='1573.Toplam Puan'> : #USER_POINT#</td>
                </tr>
                <tr>
                  <td>D:<cf_get_lang no='81.Doğru Şık'></td>
                </tr>
                <tr>
                  <td>C:<cf_get_lang no='82.Seçilen Şık'></td>
                </tr>
              </table>
            </cfoutput> </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

