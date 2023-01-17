<cfset xfa.submit_analysis = "#request.self#?fuseaction=crm.emptypopup_upd_calc_analysis">
<cfquery name="RESULT_DETAIL" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		MEMBER_ANALYSIS_RESULTS 
	WHERE 
		MEMBER_ANALYSIS_RESULTS.RESULT_ID = #attributes.RESULT_ID#
</cfquery>
<script type="text/javascript">
<!--
function reloadOpener(){
	wrk_opener_reload();
}	
-->
</script>
<cfif attributes.member_type IS "partner">
	<cfset session.member_type = "partner">
	<cfset session.memberid = attributes.partner_id>
	<cfset url.pid = attributes.partner_id>
	<cfinclude template="../query/get_partner.cfm">
	<cfset NAME = get_partner.company_partner_name>
	<cfset SURNAME = get_partner.company_partner_surname>
	<cfset NICKNAME = get_partner.NICKNAME>
<cfelseif attributes.member_type IS "consumer">
	<cfset session.member_type = "consumer">
	<cfset session.memberid = attributes.consumer_id>
	<cfinclude template="../query/get_consumer.cfm">
	<cfset NAME = get_CONSUMER.CONSUMER_NAME>
	<cfset SURNAME = get_CONSUMER.CONSUMER_SURNAME>
</cfif>
<cfset SESSION.RESULT_ID = attributes.RESULT_ID>
<cfinclude template="../query/get_analysis.cfm">
<cfinclude template="../query/get_analysis_questions.cfm">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
  <tr class="color-border">
    <td valign="top">
      <table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
        <tr class="color-list" height="35">
          <td class="headbold"><cf_get_lang no='148.Analiz'> : <cfoutput>#get_analysis.ANALYSIS_HEAD#</cfoutput></td>
        </tr>
        <tr class="color-row">
          	<td valign="top" class="txtboldblue">&nbsp;<cf_get_lang_main no='162.Firma'> / <cf_get_lang_main no='166.Yetkili'>:
		  	<cfoutput>
              <cfif attributes.member_type IS "partner">
                #NICKNAME# -
              </cfif>
              #NAME# #SURNAME#
			</cfoutput>
		  	</td>
        </tr>
        <tr class="color-row">
          <td valign="top">
            <form name="make_analysis" action="<cfoutput>#xfa.submit_analysis#</cfoutput>" method="post">
              <input type="hidden" name="analysis_id" id="analysis_id" value="<cfoutput>#attributes.analysis_id#</cfoutput>">
			  <cfif isdefined("attributes.is_popup")>
				  <input type="hidden" name="is_popup" id="is_popup" value="<cfoutput>#attributes.is_popup#</cfoutput>">
			  </cfif>
              <cfoutput query="get_analysis_questions">
                <cfinclude template="../query/get_result_detail.cfm">
                <!--- get_result_detail --->
                <table width="100%">
                  <tr>
                    <td class="txtbold" width="50"><cf_get_lang_main no='1572.Puan'></td>
                    <td class="txtbold"><cf_get_lang_main no='1398.Soru'> #currentrow# : #question#</td>
                  </tr>
                  <cfif ANSWER_NUMBER NEQ 0>
                    <cfloop from="1" to="20" index="i">
                      <cfif len(evaluate("answer#i#_photo")) or len(evaluate("answer#i#_text"))>
                        <tr>
                          <td>(#evaluate('answer'&i&'_point')#)</td>
                          <!--- #QUESTION_POINT# --->
                          <td>
                            <cfswitch expression="#QUESTION_TYPE#">
                              <cfcase value="1">
                              <input type="Radio" name="user_answer_#currentrow#" id="user_answer_#currentrow#" value="#i#" <cfif ListFind(get_result_detail.QUESTION_USER_ANSWERS,i,",")>checked</cfif>>
                              </cfcase>
                              <cfcase value="2">
                              <input type="checkbox" name="user_answer_#currentrow#" id="user_answer_#currentrow#" value="#i#" <cfif ListFind(get_result_detail.QUESTION_USER_ANSWERS,i,",")>checked</cfif>>
                              </cfcase>
                            </cfswitch>
                            <input type="hidden" name="user_answer_#currentrow#_point" id="user_answer_#currentrow#_point" value="#evaluate('answer'&i&'_point')#">
                            <cfif len(evaluate("answer"&i&"_photo"))>
							  <cf_get_server_file output_file="member/#evaluate("answer"&i&"_photo")#" output_server="#evaluate("answer"&i&"_photo_server_id")#" output_type="0" image_width="35" image_height="33" image_link="1">
                            </cfif>
                            #evaluate("answer"&i&"_text")# </td>
                        </tr>
                      </cfif>
                    </cfloop>
                  <cfelse>
                    <tr>
                      <td>
					  	<cfif get_result_detail.RecordCount>
							<input type="text" name="open_question_#currentrow#" id="open_question_#currentrow#" value="<cfif get_result_detail.QUESTION_POINT neq ''>#get_result_detail.QUESTION_POINT#<cfelse>0</cfif>" style="width:25px"> 
						<cfelse>
							<input type="text" name="open_question_#currentrow#" id="open_question_#currentrow#" value="0" style="width:25px"> 
						</cfif>
						</td>
                      <td><textarea name="user_answer_#currentrow#" id="user_answer_#currentrow#" cols="45" rows="4">#get_result_detail.QUESTION_USER_ANSWERS#</textarea>
                      </td>
                    </tr>
                  </cfif>
                  <cfif LEN(question_info)>
                    <tr>
                      <td></td>
                      <td class="txtbold"><cf_get_lang_main no='144.Bilgi'>: #question_info# </td>
                    </tr>
                  </cfif>
                  <tr>
                    <td colspan="2"><img src="/images/cizgi_yan_50.gif" width="100%" height="15"></td>
                  </tr>
                </table>
              </cfoutput> 
			  <cfoutput query="RESULT_DETAIL">
                <table>
                  <tr>
                    <td class="txtbold"><cf_get_lang_main no='1573.Toplam Puan'> : #USER_POINT#</td>
                  </tr>
                </table>
              </cfoutput>
              <table>
                <tr>
                  <td><cf_workcube_buttons is_upd='0'></td>
                </tr>
              </table>
            </form>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

