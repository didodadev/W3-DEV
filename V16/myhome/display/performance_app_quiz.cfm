<input type="hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
<!--- <cfinclude template="../query/get_quiz_chapters.cfm"> --->
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
  <cfset answer_number_gelen = get_quiz_chapters.answer_number>
  <cfset attributes.CHAPTER_ID = CHAPTER_ID>
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
      <table width="100%" border="0">
        <tr>
          <td class="txtboldblue"><cf_get_lang dictionary_id='57995.Bölüm'> #get_quiz_chapters.currentrow#: #chapter#</td>
        </tr>
        <cfif len(chapter_info)>
          <tr height="20" class="color-list">
            <td> #chapter_info# </td>
          </tr>
        </cfif>
      </table>
    </td>
  </tr>
<!---   <cfinclude template="../query/get_quiz_questions.cfm"> --->
<cfquery name="GET_QUIZ_QUESTIONS" datasource="#dsn#">
	SELECT 
		*
	FROM 
		EMPLOYEE_QUIZ_QUESTION
	WHERE
		CHAPTER_ID=#attributes.CHAPTER_ID#
</cfquery>

  <cfif get_quiz_questions.RecordCount>
  <tr class="color-row">
    <td>
      <table width="100%" border="0">
        <tr class="color-list">
          <td width="40"></td>
		   <td class="formbold" width="25">GD</td>
          <!--- Eger cevaplar yan yana gelecekse, üst satira cevaplar yaziliyor --->
          <cfif get_quiz_chapters.answer_number neq 0>
            <cfloop from="1" to="20" index="i">
              <cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
                <td class="txtbold" align="center" width="75">
				#evaluate('answer#i#_text')#
                  <cfif len(evaluate("answer"&i&"_photo"))>
                    <!--- <img src="#file_web_path#hr/#evaluate("answer"&i&"_photo")#" border="0"> --->
					<cf_get_server_file output_file="hr/#evaluate("answer"&i&"_photo")#" output_server="#evaluate("answer"&i&"_photo_server_id")#" output_type="0" image_width="40" image_height="50" image_link="1">
                  </cfif>
                  &nbsp;</td>
              </cfif>
            </cfloop>
          </cfif>
		   <!--- <td class="formbold"><cf_get_lang_main no='217.Açıklama'></td> --->
        </tr>
        <!--- Sorular basliyor --->
        <cfloop query="get_quiz_questions">
          <tr class="color-list">
            <td class="txtboldblue">#get_quiz_questions.currentrow# - #get_quiz_questions.question#</td>
            <td class="txtboldblue">
				<input type="checkbox" name="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" value="1">
			</td>
          <cfif answer_number_gelen neq 0>
            <cfloop from="1" to="20" index="i">
			  <cfif len(evaluate("b#i#")) or len(evaluate("a#i#"))>
                <td align="center" width="75">
                  <input type="Radio" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" value="#i#"><!--- calc_user_point('#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#',#i#,#evaluate('c#i#')#); --->
                  <input type="Hidden" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" value="#evaluate('c#i#')#"><!--- evaluate('get_quiz_chapters.answer'&i&'_point') --->
                </td>
              </cfif>
            </cfloop>
          </tr>
          <cfelse>
          <td  style="text-align:right;"></td>
          </tr>
          <cfloop from="1" to="20" index="i">
            <cfif len(evaluate("get_quiz_questions.answer#i#_photo")) or len(evaluate("get_quiz_questions.answer#i#_text"))>
              <tr class="color-list">
			  	<td class="txtboldblue"><input type="checkbox" name="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="gd_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" value="1"> </td>
                <td width="75">
                  <input type="Radio" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#" value="#i#">
                  <input type="Hidden" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" id="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_point" value="#evaluate('get_quiz_questions.answer'&i&'_point')#">
                   #evaluate('get_quiz_questions.answer#i#_text')#
				   <cfif len(evaluate("answer"&i&"_photo"))>
                    <!--- <img src="#file_web_path#hr/#evaluate("get_quiz_questions.answer"&i&"_photo")#" border="0"> --->
					<cf_get_server_file output_file="hr/#evaluate("get_quiz_questions.answer"&i&"_photo")#" output_server="#evaluate("get_quiz_questions.answer"&i&"_photo_server_id")#" output_type="0" image_width="40" image_height="50" image_link="1">
                  </cfif>
                 <br/>
                </td>
              </tr>
            </cfif>
          </cfloop>
          </cfif>
          <cfif len(question_info)>
            <tr height="20" class="color-list">
              <td> #get_quiz_questions.question_info# </td>
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
			<td class="txtboldblue" width="40"><cf_get_lang dictionary_id='57629.Açıklama'></td>
			<td class="txtboldblue"><textarea name="expl_#get_quiz_chapters.currentrow#" id="expl_#get_quiz_chapters.currentrow#"  value="" cols="70" rows="2"></textarea></td>
          </tr>
      </table>
    </td>
  </tr>
  <cfelse>
  <tr height="20" class="color-row">
    <td><cf_get_lang dictionary_id='55829.Kayıtlı Soru Bulunamadı!'></td>
  </tr>
</cfif>
<!--- </table>  --->
</cfoutput>
<cfelse>
<tr height="20" class="color-row">
  <td><cf_get_lang dictionary_id='55830.Kayıtlı Bölüm Bulunamadı!'></td>
</tr>
</cfif>
