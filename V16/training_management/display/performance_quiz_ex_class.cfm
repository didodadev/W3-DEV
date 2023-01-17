<input type="hidden" name="quiz_id" id="quiz_id" value="<cfoutput>#attributes.quiz_id#</cfoutput>">
<cfinclude template="../query/get_training_eval_quiz_chapters.cfm">
<tr class="color-row">
  <td valign="top" height="100%">
    <table width="100%" border="0">
      <cfif get_quiz_chapters.recordcount>
        <tr>
          <td class="txtboldblue"></td>
          <cfoutput query="get_emp_att">
            <cfquery name="GET_UNNAMED" datasource="#dsn#">
				SELECT 
					IS_UNNAMED 
				FROM 
					TRAINING_EX_CLASS_EVAL 
				WHERE 
					TRAINING_EX_CLASS_EVAL.EMP_ID=#EMP_ID# 
				AND
					TRAINING_EX_CLASS_EVAL.QUIZ_ID = #attributes.QUIZ_ID# 
				AND 
					TRAINING_EX_CLASS_EVAL.EX_CLASS_ID = #attributes.EX_CLASS_ID#
            </cfquery>
            <cfset attributes.employee_id = EMP_ID>
            <cfinclude template="../query/get_employee.cfm">
            <td  align="center" style="writing-mode : tb-rl;">
              <select name="IS_UNNAMED_#emp_id#" id="IS_UNNAMED_#emp_id#" style="writing-mode : tb-rl;table-layout : fixed;direction : inherit;vertical-align : text-top;">
                <option value="0" <cfif GET_UNNAMED.IS_UNNAMED IS 0>selected</cfif>>#GET_EMPLOYEE.EMPLOYEE_NAME# #GET_EMPLOYEE.EMPLOYEE_SURNAME#</option>
                <option value="1" <cfif GET_UNNAMED.IS_UNNAMED IS 1>selected</cfif>><cf_get_lang no='100.İsimsiz'></option>
              </select>
            </td>
          </cfoutput> </tr>
        <cfoutput query="get_quiz_chapters">
        <cfset ANSWER_NUMBER_gelen = get_quiz_chapters.ANSWER_NUMBER>
        <cfset attributes.CHAPTER_ID = CHAPTER_ID>
        <cfinclude template="../query/get_training_eval_quiz_questions.cfm">
        <cfif get_quiz_questions.RecordCount>
          <tr height="20">
            <td class="formbold" colspan="#get_emp_att.RecordCount+1#">#chapter#</td>
          </tr>
          <cfif len(chapter_info)>
            <tr height="20">
              <td colspan="#get_emp_att.RecordCount+1#">#chapter_info# </td>
            </tr>
          </cfif>
          <!--- Sorular basliyor --->
          <cfloop query="get_quiz_questions">
          
          <cfset attributes.QUESTION_ID = get_quiz_questions.QUESTION_ID>
          <tr>
            <td class="txtboldblue" nowrap width="100%">#get_quiz_questions.currentrow#- #get_quiz_questions.question# </td>
            <cfif ANSWER_NUMBER_gelen NEQ 0>
            <cfloop query="get_emp_att">
              <cfset attributes.emp_id_currentrow = get_emp_att.currentrow>
              <cfset attributes.emp_id = get_emp_att.emp_id>
              <cfif FUSEACTION CONTAINS "popup_form_upd_ex_class_eval">
                <cfquery name="GET_QUIZ_RESULT" datasource="#dsn#">
					SELECT 
						QUESTION_POINT 
					FROM 
						TRAINING_EX_CLASS_EVAL,
						TRAINING_EX_CLASS_EVAL_DETAILS
					WHERE 
						TRAINING_EX_CLASS_EVAL.EX_CLASS_EVAL_ID=TRAINING_EX_CLASS_EVAL_DETAILS.EX_CLASS_EVAL_ID
					AND 
						TRAINING_EX_CLASS_EVAL.EMP_ID=#attributes.emp_id# 
					AND
						TRAINING_EX_CLASS_EVAL.QUIZ_ID = #attributes.QUIZ_ID# 
					AND
						TRAINING_EX_CLASS_EVAL.EX_CLASS_ID = #attributes.EX_CLASS_ID# 
					AND
						TRAINING_EX_CLASS_EVAL_DETAILS.QUESTION_ID = #attributes.QUESTION_ID#
                </cfquery>
                <cfif GET_QUIZ_RESULT.RECORDCOUNT AND GET_QUIZ_RESULT.QUESTION_POINT>
                  <cfset point_found = GET_QUIZ_RESULT.QUESTION_POINT>
                  <cfelse>
                  <cfset point_found = "">
                </cfif>
                <cfelse>
                <cfset point_found = "">
              </cfif>
              <td  align="center">
			  <cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf,_get_lang_main no='55.not'>-<cf_get_lang no='8.1 ile 5 Arası !'></cfsavecontent>
                <cfinput tabindex="#attributes.emp_id_currentrow##get_quiz_chapters.currentrow##get_quiz_questions.currentrow#" type="text" name="user_answer_#get_quiz_chapters.currentrow#_#get_quiz_questions.currentrow#_#emp_id#" value="#point_found#" style="width:20px;" range="1,5" message="#message#">
              </td>
            </cfloop>
          </tr>
          <cfelse>
          <td style="text-align:right;"> </td>
          </tr>
        </cfif>
        <cfif len(question_info)>
          <tr height="20">
            <td> #get_quiz_questions.question_info#</td>
          </tr>
        </cfif>
        </cfloop>
        <tr>
          <td class="txtbold" colspan="#get_emp_att.RecordCount+1#" height="20">
            <cfif get_quiz_chapters.ANSWER_NUMBER NEQ 0>
              <cfloop from="1" to="20" index="i">
                <cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
                  <cfif len(evaluate("answer"&i&"_photo"))>
                    <img src="#file_web_path#hr/#evaluate("answer"&i&"_photo")#" border="0">
                  </cfif>
                  #evaluate('answer#i#_text')# : #evaluate('answer#i#_point')# &nbsp;
                </cfif>
              </cfloop>
            </cfif>
          </td>
        </tr>
        <br/>
        <cfelse>
        <tr>
          <td><cf_get_lang no='85.Kayıtlı Soru Bulunamadı!'></td>
        </tr>
      </cfif>
      </cfoutput>
    </table>
  </td>
</tr>
<cfelse>
<tr class="color-row">
  <td><cf_get_lang no='317.Kayıtlı Bölüm Bulunamadı!'></td>
</tr>
</cfif>

