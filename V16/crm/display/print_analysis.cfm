<cfinclude template="../query/get_analysis.cfm">
<cfset attributes.names = 1>
<cfinclude template="../query/get_analysis_questions.cfm">
 <!-- sil -->
<table cellpadding="0" cellspacing="0" width="100%">
<tr>
<cf_workcube_file_action pdf='1' mail='1' doc='0' print='1'>
</tr>
</table>
 <!-- sil -->
<table width="700" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td>
				<table>
                    <tr height="20">
                      <td class="txtbold" nowrap><cf_get_lang_main no='148.Analiz'></td>
                      <td width="615">: <cfoutput>#get_analysis.analysis_head#</cfoutput></td>
                    </tr>					
                    <tr height="20">
                      <td class="txtbold">Sınır/<cf_get_lang no='150.Puan'></td>
                      <td>: <cfoutput>% #get_analysis.ANALYSIS_AVERAGE# / #get_analysis.TOTAL_POINTS#</cfoutput></td>
                    </tr>
                    <cfif LEN(get_analysis.PRODUCT_ID)>
                      <tr height="20">
                        <td class="txtbold"><cf_get_lang_main no='245.Ürün'></td>
                        <td>: <cfoutput>#get_product_name(product_id:get_analysis.PRODUCT_ID)#</cfoutput></td>
                      </tr>
                    </cfif>
					 <tr height="20">
                      <td class="txtbold"><cf_get_lang no='140.Hazırlayan'></td>
                      <td>:
					  <cfif len(get_analysis.record_emp)>
                          <cfoutput>#get_emp_info(get_analysis.record_emp,0,0)#</cfoutput>
                        </cfif>
                      </td>
                    </tr>
                    <tr height="20">
                      <td class="txtbold"><cf_get_lang_main no='215.Kayıt Tarihi'></td>
                      <td>: <cfoutput>#dateformat(get_analysis.record_date,dateformat_style)#</cfoutput></td>
                    </tr>                    
                     <tr height="20">
                        <td class="txtbold" colspan="2"><cf_get_lang no='139.Amaç'></td>
                      </tr> 
					 <tr height="20">
                      <td colspan="2"><cfoutput>#get_analysis.ANALYSIS_OBJECTIVE#</cfoutput></td>
                    </tr>
					  <tr height="20">
                        <td class="txtbold" colspan="2"><cf_get_lang no='13.Puan Yorumları'></td>
                      </tr>                    
					  <tr height="20">
                        <td colspan="2">
						<cfif len(get_analysis.COMMENT1)><cfoutput>#get_analysis.SCORE1# - <strong>#get_analysis.COMMENT1#</strong></cfoutput>,&nbsp;&nbsp;</cfif>
						<cfif len(get_analysis.COMMENT2)><cfoutput>#get_analysis.SCORE2# - <strong>#get_analysis.COMMENT2#</strong></cfoutput>,&nbsp;&nbsp;</cfif>
						<cfif len(get_analysis.COMMENT3)><cfoutput>#get_analysis.SCORE3# - <strong>#get_analysis.COMMENT3#</strong></cfoutput>,&nbsp;&nbsp;</cfif>
						<cfif len(get_analysis.COMMENT4)><cfoutput>#get_analysis.SCORE4# - <strong>#get_analysis.COMMENT4#</strong></cfoutput>,&nbsp;&nbsp;</cfif>
						<cfif len(get_analysis.COMMENT5)><cfoutput>#get_analysis.SCORE5# - <strong>#get_analysis.COMMENT5#</strong></cfoutput>,&nbsp;&nbsp;</cfif>						
						</td>
                      </tr>                                      
                  </table>	
				 <hr> 
 </td>
  </tr>
</table>

<table width="700" cellpadding="0" cellspacing="0" align="center">
  <tr>
    <td valign="top">
      <cfset attributes.employee_id = session.ep.userid>
                  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td class="formbold" height="25"><cf_get_lang_main no='675.Sorular'></td>
                    </tr>
                  </table>
              <cfif get_analysis_questions.recordcount>
                <cfoutput query="get_analysis_questions">
                      <table width="100%">
                        <tr>
                          <td class="txtbold" height="20"><cf_get_lang_main no='1398.Soru'>#currentrow# : #question# </td>
                        </tr>
                  <cfif ANSWER_NUMBER NEQ 0>               
				    <cfloop from="1" to="20" index="i">
                      <cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
                        <tr>
                          <td>
                            <cfif question_type eq 1>
                              <input type="Radio" name="user_answer_#currentrow#" id="user_answer_#currentrow#">
                              <cfelseif question_type eq 2>
                              <input type="checkbox" name="user_answer_#currentrow#" id="user_answer_#currentrow#">
                            </cfif>
                            <cfif len(evaluate("answer"&i&"_photo"))>
                              <img src="#upload_folder#member/#evaluate("answer"&i&"_photo")#" border="0">
                            </cfif>
                            #evaluate('answer#i#_text')#
                            <cfif len(evaluate('ANSWER#i#_PRODUCT_ID'))>
                              <cfset PRODUCT_ID = evaluate('ANSWER#i#_PRODUCT_ID')>
                              <cfinclude template="../query/get_product_name.cfm">
                              <cfif get_product_name.recordCount>
                                (#get_product_name.PRODUCT_NAME#)
                              </cfif>
                            </cfif>
                          </td>
                        </tr>
                      </cfif>
                    </cfloop>				
                    <cfelse>               
				    <tr height="35">
                      <td>&nbsp;</td>
                    </tr>				
                  </cfif>
                  <cfif len(question_info)>
                    <tr height="20">
                      <td class="txtbold"><cf_get_lang_main no='144.Bilgi'>: #question_info# </td>
                    </tr>
                  </cfif>
                </cfoutput>
				</table>
              <cfelse>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr height="20" class="color-row">
                  <td><cf_get_lang no='160.Kayıtlı Soru Bulunamadı !'></td>
                </tr>
				</table>
              </cfif>            
          </td>
        </tr>
      </table>

