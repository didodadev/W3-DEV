<cfset my_array =ArrayNew(2)>
<cfparam name="attributes.graph_type_stock" default="bar">
<cfparam name="attributes.graph_type" default="bar">

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
              <cfif GET_UNNAMED.IS_UNNAMED IS 0>
                	#GET_EMPLOYEE.EMPLOYEE_NAME# #GET_EMPLOYEE.EMPLOYEE_SURNAME#
              </cfif>
              <cfif GET_UNNAMED.IS_UNNAMED IS 1>
                <cf_get_lang no='100.İsimsiz'>
              </cfif>
            </td>
          </cfoutput> </tr>
        <cfoutput query="get_quiz_chapters">
        <cfset sayac=0>
        <cfset ANSWER_NUMBER_gelen = get_quiz_chapters.ANSWER_NUMBER>
        <cfset attributes.CHAPTER_ID = CHAPTER_ID>
        <cfinclude template="../query/get_training_eval_quiz_questions.cfm">
        <cfif get_quiz_questions.RecordCount>
          <tr height="20">
            <td class="formbold" colspan="#get_emp_att.RecordCount+1#">#chapter#</td>
          </tr>
          <cfif len(chapter_info)>
            <tr height="20">
              <td colspan="#get_emp_att.RecordCount+2#">#chapter_info# </td>
            </tr>
          </cfif>
          <!--- Sorular basliyor --->
          <cfloop query="get_quiz_questions" >
          <cfset attributes.QUESTION_ID = get_quiz_questions.QUESTION_ID>
          <tr>
            <td class="txtboldblue" nowrap width="100%">#get_quiz_questions.currentrow#- #get_quiz_questions.question# </td>
            <cfif ANSWER_NUMBER_gelen NEQ 0>
            <cfset katilim=0>
            <cfset puan=0>
            <cfloop query="get_emp_att">
              <cfset attributes.emp_id_currentrow = get_emp_att.currentrow>
              <cfset attributes.emp_id = get_emp_att.emp_id>
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
                <cfset katilim=katilim+1>
                <cfset puan=puan + point_found>
                <cfelse>
                <cfset point_found = "">
              </cfif>
              <td align="center">#point_found#</td>
            </cfloop>
            <td><cfif puan neq 0>
                #TLFormat(puan/katilim)#
              </cfif>
            </td>
          </tr>
          <cfelse>
          <td style="text-align:right;"> </td>
          </tr>
        </cfif>
        <cfif len(question_info)>
          <tr height="20">
            <td>#get_quiz_questions.question_info#</td>
          </tr>
        </cfif>
        </cfloop>
        
        <tr>
          <td colspan="#get_emp_att.RecordCount+2#" align="center" width="100%">
            <cfset colorlist="d099ff,6666cc,33cc33,cc6600,ff6600,ffcc00,ff66ff,999933,cccc99,996699,339999,ccff66,ccccff,6699ff">
            <cfchart format="jpg" chartwidth="500" fontsize="12"	labelformat="number" showlegend="yes"
				xaxistitle="Eğitim Soruları" yaxistitle="Puan" tipBGColor="0099FF" scaleto="5" font="Arial" >
            <cfchartseries	 type="#attributes.graph_type_stock#"  paintstyle="plain" colorlist="#colorlist#">
            <cfloop query="get_quiz_questions" >
              <cfset attributes.QUESTION_ID = get_quiz_questions.QUESTION_ID>
              <cfif ANSWER_NUMBER_gelen NEQ 0>
                <cfset katilim=0>
                <cfset puan=0>
                <cfloop query="get_emp_att">
                  <cfset attributes.emp_id_currentrow = get_emp_att.currentrow>
                  <cfset attributes.emp_id = get_emp_att.emp_id>
                  <cfquery name="GET_QUIZ_RESULT" datasource="#dsn#">
											SELECT 
												QUESTION_POINT 
											FROM 
												TRAINING_EX_CLASS_EVAL,
												TRAINING_EX_CLASS_EVAL_DETAILS
											WHERE 
												TRAINING_EX_CLASS_EVAL.EX_CLASS_EVAL_ID = TRAINING_EX_CLASS_EVAL_DETAILS.EX_CLASS_EVAL_ID
											AND 
												TRAINING_EX_CLASS_EVAL.EMP_ID=#attributes.emp_id# AND
												TRAINING_EX_CLASS_EVAL.QUIZ_ID = #attributes.QUIZ_ID# 
											AND 
												TRAINING_EX_CLASS_EVAL.EX_CLASS_ID = #attributes.EX_CLASS_ID# 
											AND 
												TRAINING_EX_CLASS_EVAL_DETAILS.QUESTION_ID = #attributes.QUESTION_ID#
                  </cfquery>
                  <cfif GET_QUIZ_RESULT.RECORDCOUNT AND GET_QUIZ_RESULT.QUESTION_POINT>
                    <cfset point_found = GET_QUIZ_RESULT.QUESTION_POINT>
                    <cfset katilim=katilim+1>
                    <cfset puan=puan + point_found>
                    <cfelse>
                    <cfset point_found = "">
                  </cfif>
                </cfloop><!--- #LEFT(get_quiz_questions.question,15)# --->
								<cfset my_st="Soru #currentrow# ">
                <cfchartdata  item="#my_st#" value="#evaluate(puan/katilim)#" >
              </cfif>
            </cfloop>
            </cfchartseries>
            </cfchart>
          </td>
        </tr>
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
          <td> <cf_get_lang no='85.Kayıtlı Soru Bulunamadı!'> </td>
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

