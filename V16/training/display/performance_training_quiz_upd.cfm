<input type="hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
<cfquery name="GET_QUIZ_CHAPTERS" datasource="#dsn#">
	SELECT 
		*
	FROM 
		EMPLOYEE_QUIZ_CHAPTER
	WHERE
		QUIZ_ID=#attributes.QUIZ_ID#
</cfquery>
<cfif get_quiz_chapters.recordcount>
  <cfoutput query="get_quiz_chapters">
  <cfset ANSWER_NUMBER_gelen = get_quiz_chapters.ANSWER_NUMBER>
  <cfset attributes.CHAPTER_ID = CHAPTER_ID>
	<cfquery datasource="#dsn#" name="chapter_expl">
		SELECT
			EXPLANATION 
		FROM
			EMPLOYEE_QUIZ_CHAPTER_EXPL
		WHERE
			CHAPTER_ID = #CHAPTER_ID#
			AND RESULT_ID = #GET_TRAINING_PERF_DETAIL.RESULT_ID#
	</cfquery>
  <cfscript>
	for (i=1; i lte 20; i = i+1)
		{
		"a#i#" = evaluate("get_quiz_chapters.answer#i#_text");
		"b#i#" = evaluate("get_quiz_chapters.answer#i#_photo");
		"c#i#" = evaluate("get_quiz_chapters.answer#i#_point");
		}
  </cfscript>
  <tr class="color-list">
    <td>
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr height="20">
          <td class="txtboldblue"><cf_get_lang no='202.Bölüm'>#get_quiz_chapters.currentrow#: #chapter#</td>
        </tr>
        <cfif len(chapter_info)>
          <tr height="20" class="color-list">
            <td>#chapter_info#</td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
  <cfquery name="GET_QUIZ_QUESTIONS" datasource="#dsn#">
		SELECT 
			*
		FROM 
			EMPLOYEE_QUIZ_QUESTION
		WHERE
			CHAPTER_ID=#attributes.CHAPTER_ID#
		ORDER BY QUESTION_ID
	</cfquery>
  <cfif get_quiz_questions.RecordCount>
  <tr class="color-row">
    <td>
      <table width="100%" border="0">
        <tr class="color-list">
          <td width="40"></td>
		   <td class="formbold" width="25">GD</td>
          <!--- Eger cevaplar yan yana gelecekse, üst satira cevaplar yaziliyor --->
          <cfif get_quiz_chapters.ANSWER_NUMBER NEQ 0>
            <cfloop from="1" to="20" index="i">
              <cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
                <td class="txtbold" width="75">
                  <cfif len(evaluate("answer"&i&"_photo"))>
                    <!--- <img src="#file_web_path#hr/#evaluate("answer"&i&"_photo")#" border="0"> --->
					<cf_get_server_file output_file="hr/#evaluate("answer"&i&"_photo")#" output_server="#evaluate("answer"&i&"_photo_server_id")#" output_type="0" image_width="38" image_height="35" image_link="1">
                  </cfif>
                  #evaluate('answer#i#_text')#&nbsp;</td>
              </cfif>
            </cfloop>
			<cfelse>
				<td>&nbsp;</td>
          </cfif>
        </tr>
        <!--- Sorular basliyor --->
        <cfloop query="get_quiz_questions">
          <cfset q_id = get_quiz_questions.QUESTION_ID>
          <tr class="color-list" height="20">
            <td class="txtboldblue">#get_quiz_questions.currentrow#-#get_quiz_questions.question#</td>
            <td class="txtboldblue">
				<input type="checkbox" name="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" value="1"
					<cfloop query="GET_EMP_QUIZ_ANSWERS">
						<cfif isdefined("GET_EMP_QUIZ_ANSWERS") and 
						isdefined("GET_EMP_QUIZ_ANSWERS.RESULT_ID") and 
						GET_EMP_QUIZ_ANSWERS.QUESTION_ID is q_id and 
						GET_EMP_QUIZ_ANSWERS.GD is 1> checked
						</cfif>
					</cfloop>
				> 
			</td>
            <cfif ANSWER_NUMBER_gelen neq 0>
            <cfloop from="1" to="20" index="i">
              <cfif len(evaluate("b#i#")) or len(evaluate("a#i#"))>
                <td>
                  <input type="Radio" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" value="#i#" 
					<cfloop query="GET_EMP_QUIZ_ANSWERS">
					<cfif isdefined("GET_EMP_QUIZ_ANSWERS") and 
						isdefined("GET_EMP_QUIZ_ANSWERS.RESULT_ID") and 
						GET_EMP_QUIZ_ANSWERS.QUESTION_ID is q_id and 
						GET_EMP_QUIZ_ANSWERS.QUESTION_USER_ANSWERS is i>checked</cfif>
					</cfloop>
				  >
                  <input type="hidden" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" value="#evaluate('c#i#')#"><!--- value="#evaluate('get_quiz_chapters.answer'&i&'_point')#" --->
                </td>
              </cfif>
            </cfloop>
          </tr>
          <cfelse>
          <td></td>
          </tr>
          <cfloop from="1" to="20" index="i">
            <cfif len(evaluate("get_quiz_questions.answer#i#_photo")) or len(evaluate("get_quiz_questions.answer#i#_text"))>
              <tr class="color-list">
	            <td></td>
				<td><!--- <input type="checkbox" name="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" value="1" > ---></td>
                <td>
                  <input type="Radio" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" value="#i#">
					<cfloop query="GET_EMP_QUIZ_ANSWERS">
					<cfif IsDefined("GET_EMP_QUIZ_ANSWERS") AND 
						IsDefined("GET_EMP_QUIZ_ANSWERS.RESULT_ID") AND 
						GET_EMP_QUIZ_ANSWERS.QUESTION_ID IS q_id AND 
						GET_EMP_QUIZ_ANSWERS.QUESTION_USER_ANSWERS IS i>checked</cfif>
					</cfloop>

                  <input type="Hidden" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" value="#evaluate('get_quiz_questions.answer'&i&'_point')#">
                  <cfif len(evaluate("answer"&i&"_photo"))>
                    <!--- <img src="#file_web_path#hr/#evaluate("get_quiz_questions.answer"&i&"_photo")#" border="0"> --->
					<cf_get_server_file output_file="hr/#evaluate("get_quiz_questions.answer"&i&"_photo")#" output_server="#evaluate("get_quiz_questions.answer"&i&"_photo_server_id")#" output_type="0" image_width="38" image_height="35" image_link="1">
                  </cfif>
                  #evaluate('get_quiz_questions.answer#i#_text')#<br/>
                </td>
              </tr>
            </cfif>
          </cfloop>
          </cfif>
          <cfif len(question_info)>
            <tr height="20" class="color-list">
              <td colspan="7"> #get_quiz_questions.question_info# </td>
            </tr>
          </cfif>
        </cfloop>
      </table>
    </td>
  </tr>
  <tr class="color-list">
    <td>
      <table width="100%" border="0">
        <tr>
			<td class="txtboldblue" width="40">Açıklama</td>
			<td><textarea name="expl_#get_quiz_chapters.currentrow#" id="expl_#get_quiz_chapters.currentrow#" value="" cols="70" rows="2">#chapter_expl.EXPLANATION#</textarea></td>
          </tr>
      </table>
    </td>
  </tr>
  <cfelse>
  <tr height="20" class="color-row">
    <td><cf_get_lang no='744.Kayıtlı Soru Bulunamadı!'></td>
  </tr>
</cfif>
</cfoutput>
<cfelse>
<tr height="20" class="color-row">
  <td><cf_get_lang no='745.Kayıtlı Bölüm Bulunamadı!'></td>
</tr>
</cfif>
<script type="text/javascript">
	
</script>
