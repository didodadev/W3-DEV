<cfset attributes.quiz_id = attributes.id> 
<cfinclude template="../query/get_quiz.cfm">
<cfset attributes.names = 1>
<cfif len(get_quiz.position_cat_id)>
  <cfset attributes.position_cat_id = get_quiz.position_cat_id>
	<cfquery name="GET_POSITION_CAT" datasource="#dsn#">
		SELECT 
			* 
		FROM 
			SETUP_POSITION_CAT 
		WHERE 
			POSITION_CAT_ID IN (#ListSort(attributes.POSITION_CAT_ID,"numeric")#)
	</cfquery>
</cfif>
 <cfif len(get_quiz.RECORD_EMP)>
  <cfset attributes.employee_id = get_quiz.RECORD_EMP>
  <cfinclude template="../query/get_employee.cfm">
</cfif> 
<cfif len(get_quiz.RECORD_par)>
  <cfset attributes.partner_id = get_quiz.RECORD_PAR>
  <cfinclude template="../query/get_partner.cfm">
</cfif>
<cfquery name="GET_QUIZ_CHAPTERS" datasource="#dsn#">
	SELECT 
		*
	FROM 
		EMPLOYEE_QUIZ_CHAPTER
	WHERE
		QUIZ_ID=#attributes.QUIZ_ID#
</cfquery>
<cfquery name="POSCATS" datasource="#dsn#">
SELECT 
	POSITION_CAT_ID 
FROM 
	EMPLOYEE_QUIZ 
WHERE 
	QUIZ_ID=#attributes.QUIZ_ID#
</cfquery>
<cfif len(POSCATS.POSITION_CAT_ID)>
<cfquery name="GET_QUIZ_POSCATS" datasource="#dsn#">
	SELECT 
		POSITION_CAT
	FROM 
		SETUP_POSITION_CAT
	WHERE
		POSITION_CAT_ID IN (
			#ListSort(ValueList(POSCATS.POSITION_CAT_ID),"numeric")#
		)
	ORDER BY
		POSITION_CAT
</cfquery>
</cfif>
<cfset attributes.employee_id = session.ep.userid>
<cfoutput>
<br/>
<table width="750" cellspacing="0" cellpadding="0" align="center" style="border: 1px solid CCCCCC;" bgcolor="FFFFFF">
  <tr>
    <td class="headbold" height="35">&nbsp;#get_quiz.QUIZ_HEAD#</td>
  </tr>
	<tr>
	<td height="20"><span class="formbold">&nbsp;&nbsp;<cf_get_lang_main no='217.Açıklama'></span> : #get_quiz.QUIZ_OBJECTIVE#</td>
	</tr>
	<tr>
		<td height="20">
			<cfif len(POSCATS.POSITION_CAT_ID)>
				<span class="formbold">&nbsp;<cf_get_lang_main no='367.Pozisyon Tipleri'></span> : 
				<cfloop query="GET_QUIZ_POSCATS">
				#POSITION_CAT#
				<cfif currentrow neq GET_QUIZ_POSCATS.recordcount>
				</cfif>
				</cfloop>
			</cfif>
		</td>
	</tr>
</table>
</cfoutput>
<br/>
<table width="750" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr bgcolor="CCCCCC">
    <td>
      <table width="100%" border="0" cellspacing="1" cellpadding="2">

        <cfif get_quiz_chapters.recordcount>
          <cfoutput query="get_quiz_chapters">
          <cfset ANSWER_NUMBER_gelen = get_quiz_chapters.ANSWER_NUMBER>
          <cfscript>
		  	for (i=1; i lte 20; i = i+1)
				{
				"a#i#" = evaluate("get_quiz_chapters.answer#i#_text");
				"b#i#" = evaluate("get_quiz_chapters.answer#i#_photo");
				}
		  </cfscript>
          <cfset attributes.CHAPTER_ID = CHAPTER_ID>
          <tr bgcolor="ffffff">
            <td>
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="formbold" height="25"><cf_get_lang_main no='583.Bölüm'> : #chapter#</td>
                </tr>
                <cfif len(chapter_info)>
                  <tr height="20" bgcolor="ffffff">
                    <td class="txtbold"><cf_get_lang no='414.Bölüm Açıklaması'> : #chapter_info#</td>
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
          <tr bgcolor="ffffff">
            <td>
              <table width="100%" border="0">
                <tr height="22">
                  <td class="formbold"></td>
                  <!--- Eğer cevaplar yan yana gelecekse, üst satıra cevaplar yazılıyor --->
                  <cfif get_quiz_chapters.ANSWER_NUMBER NEQ 0>
                    <cfloop from="1" to="20" index="i">
                      <cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
                        <td class="txtbold" align="center" width="70">
                          <cfif len(evaluate("answer"&i&"_photo"))>
                            <img src="#file_web_path#hr/#evaluate("answer"&i&"_photo")#" border="0">
                          </cfif>
                          #evaluate('answer#i#_text')# &nbsp; </td>
                      </cfif>
                    </cfloop>
                  </cfif>
                  <td>&nbsp;</td>
                </tr>
                <!--- Sorular başlıyor --->
                <cfloop query="get_quiz_questions">
				  <tr bgcolor="ffffff">
						<td class="formbold">#get_quiz_questions.currentrow#- #get_quiz_questions.question# </td>
						<cfif ANSWER_NUMBER_gelen NEQ 0>
						<cfloop from="1" to="20" index="i">
						  <cfif len(evaluate("b#i#")) or len(evaluate("a#i#"))>
							<td  align="center">
							  <input type="Radio" name="user_answer_#get_quiz_chapters.currentrow#" id="user_answer_#get_quiz_chapters.currentrow#">
							</td>
						  </cfif>
						</cfloop>
						<td width="5"></td>
					  </tr>
                  <cfelse>
                  <td width="5"></td>
                  </tr>                 
				<cfloop from="1" to="20" index="i">
                    <cfif len(evaluate("get_quiz_questions.answer#i#_photo")) or len(evaluate("get_quiz_questions.answer#i#_text"))>
                      <tr>
                        <td>
                          <input type="Radio" name="user_answer_#get_quiz_questions.currentrow#" id="user_answer_#get_quiz_questions.currentrow#">
                          <cfif len(evaluate("answer"&i&"_photo"))>
                            <img src="#file_web_path#hr/#evaluate("get_quiz_questions.answer"&i&"_photo")#" border="0">
                          </cfif>
                          #evaluate('get_quiz_questions.answer#i#_text')# </td>
                      </tr>
                    </cfif>					
                  </cfloop>
                  </cfif>
                  
                  <cfif len(question_info)>
                    <tr>
                      <td>#get_quiz_questions.question_info# </td>
                    </tr>
                  </cfif>
                </cfloop>
              </table>
            </td>
          </tr>
        </cfif>
        <!--- </table>  --->
        </cfoutput>
        </cfif>
      </table>
    </td>
  </tr>
</table>
<br/>
