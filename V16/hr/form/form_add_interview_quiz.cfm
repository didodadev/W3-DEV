<!--- <cfset attributes.quiz_id = 7> --->
<cf_popup_box>
<cfform name="form_interview" action="#request.self#?fuseaction=hr.emptypopup_add_emp_interview_quiz" method="post">
<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
<input type="hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
<input type="hidden" name="period_id" id="period_id" value="0">
<input type="hidden" name="PERIOD_PART_ID" id="PERIOD_PART_ID" value="0">
<cfinclude template="../query/get_quiz_chapters.cfm">
<table>
<cfif get_quiz_chapters.recordcount>
		<cfoutput query="get_quiz_chapters">
        <cfset ANSWER_NUMBER_gelen = get_quiz_chapters.ANSWER_NUMBER>
        <cfset attributes.CHAPTER_ID = CHAPTER_ID>
        <cfscript>
        for (i=1; i lte 20; i = i+1)
            {
            "a#i#" = evaluate("get_quiz_chapters.answer#i#_text");
            "b#i#" = evaluate("get_quiz_chapters.answer#i#_photo");
            "c#i#" = evaluate("get_quiz_chapters.answer#i#_point");
            }
        </cfscript>
        <tr>
        <td>
          <table width="100%" border="0">
            <tr>
              <td class="txtboldblue"> #chapter#</td>
            </tr>
            <cfif len(chapter_info)>
              <tr>
                <td> #chapter_info# </td>
              </tr>
            </cfif>
          </table>
        </td>
        </tr>
        <cfinclude template="../query/get_quiz_questions.cfm">
        <cfif get_quiz_questions.RecordCount>
                <tr>
                <td>
                  <table width="100%" border="0">
                    <tr>
                      <td class="formbold"> </td>
                      <!--- Eger cevaplar yan yana gelecekse, üst satira cevaplar yaziliyor --->
                      <cfif get_quiz_chapters.ANSWER_NUMBER NEQ 0>
                        <cfloop from="1" to="20" index="i">
                          <cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
                            <td class="txtbold" align="center" width="70">
                              <cfif len(evaluate("answer"&i&"_photo"))>
                                <cf_get_server_file output_file="hr/#evaluate("answer"&i&"_photo")#" output_server="#evaluate("answer"&i&"_photo_server_id")#" output_type="0"  image_link="1">
                              </cfif>
                              #evaluate('answer#i#_text')# &nbsp; </td>
                          </cfif>
                        </cfloop>
                      </cfif>
                    </tr>
                    <!--- Sorular basliyor --->
                    <cfloop query="get_quiz_questions">
                      <tr>
                        <td class="txtboldblue"> #get_quiz_questions.currentrow#- #get_quiz_questions.question# </td>
                        <cfif ANSWER_NUMBER_gelen NEQ 0>
                        <cfloop from="1" to="20" index="i">
                          <cfif len(evaluate("b#i#")) or len(evaluate("a#i#"))>
                            <td  align="center">
                              <input type="Radio" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" value="#i#" checked ><!--- calc_user_point('#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#',#i#,#evaluate('c#i#')#); --->
                              <input type="Hidden" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" value="#evaluate('c#i#')#" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" value="#evaluate('c#i#')#"><!--- evaluate('get_quiz_chapters.answer'&i&'_point') --->
                            </td>
                          </cfif>
                        </cfloop>
                      </tr>
                      <cfelse>
                      <td  style="text-align:right;"> </td>
                      </tr>
                      <cfloop from="1" to="20" index="i">
                        <cfif len(evaluate("get_quiz_questions.answer#i#_photo")) or len(evaluate("get_quiz_questions.answer#i#_text"))>
                          <tr>
                            <td>
                              <input type="Radio" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" value="#i#" checked>
                              <input type="Hidden" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" value="#evaluate('get_quiz_questions.answer'&i&'_point')#">
                              <cfif len(evaluate("answer"&i&"_photo"))>
                                <cf_get_server_file output_file="hr/#evaluate("get_quiz_questions.answer"&i&"_photo")#" output_server="#evaluate("get_quiz.questions.answer"&i&"_photo_server_id")#" output_type="0"  image_link="1">
                              </cfif>
                              #evaluate('get_quiz_questions.answer#i#_text')#<br/>
                            </td><td></td>
                          </tr>
                        </cfif>
                      </cfloop>
                      </cfif>
                      <cfif len(question_info)>
                        <tr>
                          <td> #get_quiz_questions.question_info# </td>
                        </tr>
                      </cfif>
                    </cfloop>
                  </table>
                </td>
                </tr>
            </table>
            <cf_popup_box_footer><cf_workcube_buttons is_upd='0'></cf_popup_box_footer>
        <cfelse>
          <tr>
            <td><cf_get_lang dictionary_id='55829.Kayıtlı Soru Bulunamadı!'></td>
          </tr>
		</table>
        </cfif>
<!--- </table>  --->
</cfoutput>
<cfelse>
    <tr>
      <td><cf_get_lang dictionary_id='55830.Kayıtlı Bölüm Bulunamadı!'></td>
    </tr>
</table>
</cfif>
</cfform>
</cf_popup_box>
