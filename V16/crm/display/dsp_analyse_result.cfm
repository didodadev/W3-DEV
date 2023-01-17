<cfquery name="RESULT_DETAIL" datasource="#dsn#">
	SELECT 
		*
	FROM 
		MEMBER_ANALYSIS_RESULTS
	WHERE
		ANALYSIS_ID = #attributes.analysis_id#
	ORDER BY
		USER_POINT DESC
</cfquery>
<cfinclude template="../query/get_analysis.cfm">
<cfinclude template="../query/get_analysis_questions.cfm">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr class="color-border">
    <td valign="top">
      <table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
        <tr class="color-list" height="35">
          <td class="headbold"><cf_get_lang_main no='148.Analiz'>: <cfoutput>#GET_ANALYSIS.ANALYSIS_HEAD# - #ListValueCount("1,1,1,1,111","1")#</cfoutput></td>

        <tr class="color-row">
          <td valign="top">
		   <table width="98%" align="center">
		          </tr>
					<tr class="color-row">
					<td class="txtbold" height="22" colspan="2"><cf_get_lang no='496.Katılım'>: <cfoutput>#RESULT_DETAIL.RecordCount#</cfoutput></td>
					</tr>
              <cfoutput query="get_analysis_questions">
                <cfinclude template="../query/get_analysis_questions_result.cfm">
                <!--- get_result_detail --->
                  <tr>
                    <td class="txtbold" height="30" valign="top" colspan="2"><cf_get_lang_main no='1398.Soru'> #currentrow# : #question#</td>
                  </tr>
                  <cfif ANSWER_NUMBER NEQ 0>
                        <tr>
                          <td width="300"> 
							<cfchart show3d="yes" labelformat="number" pieslicestyle="solid" format="jpg"> 
								<cfchartseries type="bar" itemcolumn="deneme">
									<cfloop from="1" to="20" index="i">
										<cfif len(evaluate("answer#i#_text"))>
											<cfchartdata item='#evaluate("answer"&i&"_text")#' value="#ListValueCount(ValueList(GET_ANALYSIS_QUESTIONS_RESULT.QUESTION_USER_ANSWERS), i)#">
										</cfif>	
									</cfloop>
								</cfchartseries>
							</cfchart>
						  </td>
                          <td valign="top"> 
							<cfloop from="1" to="20" index="i">
								<cfif len(evaluate("answer#i#_text"))>
									#evaluate("answer"&i&"_text")# : #ListValueCount(ValueList(GET_ANALYSIS_QUESTIONS_RESULT.QUESTION_USER_ANSWERS), i)#<br/><br/>
								</cfif>	
							</cfloop>
						  </td>
                        </tr>
                  <cfelse>
					<tr>
						<td colspan="2">&nbsp;<cf_get_lang_main no='1999.Açık Uçlu'><br/></td>
					</tr>
                  </cfif>
               
              </cfoutput> 
			   </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

