<cfif isDefined("attributes.member_type") and attributes.member_type eq "partner">
	<cfquery name="GET_PARTNER" datasource="#DSN#">
		SELECT 
			CP.COMPANY_PARTNER_NAME,
			CP.COMPANY_PARTNER_SURNAME,
			C.NICKNAME
		FROM
			COMPANY_PARTNER CP, 
			COMPANY C
		WHERE 
			CP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.partner_id#"> AND
			CP.COMPANY_ID = C.COMPANY_ID
	</cfquery>
<cfelseif isDefined("attributes.member_type") and attributes.member_type eq "consumer">
	<cfquery name="GET_CONSUMER" datasource="#DSN#">
		SELECT CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.consumer_id#">	
	</cfquery>
</cfif>
<cfinclude template="../../member/query/get_analysis.cfm">
<cfinclude template="../../member/query/get_analysis_questions.cfm">

<cfif isdefined("attributes.result_id")>
	<cfquery name="GET_USER_RESULTS" datasource="#DSN#">
		SELECT 
			MARD.RESULT_DETAIL_ID, 
			MARD.RESULT_ID,
			MARD.QUESTION_ID,
			MARD.QUESTION_POINT,
			MARD.QUESTION_USER_ANSWERS
		FROM
			MEMBER_ANALYSIS_RESULTS_DETAILS MARD,
			MEMBER_ANALYSIS_RESULTS MAR
		WHERE
			MAR.ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.analysis_id#"> AND
			MAR.RESULT_ID = MARD.RESULT_ID AND
			MAR.RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">
	</cfquery>
</cfif>
<cfsavecontent variable="txt"><a href="<cfoutput>#request.self#?fuseaction=objects.popup_print_files&action_id=#url.analysis_id#&action_row_id=0</cfoutput>" target="_blank"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdır'>" alt="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a></cfsavecontent>

<cfif isDefined("attributes.member_type")>
    <table>
        <tr style="height:30px;">
            <td class="txtbold">
                <cfoutput>
                <cfif attributes.member_type eq "partner">
                    &nbsp;Şirket/Yetkili: #get_partner.nickname# - #get_partner.company_partner_name# #get_partner.company_partner_surname#
                <cfelseif attributes.member_type eq "consumer">
                    &nbsp;Bireysel Üye: #get_consumer.consumer_name# #get_consumer.consumer_surname#
                </cfif>
                </cfoutput>
            </td>
        </tr>
    </table>
</cfif>
<table border="0" cellpadding="0" cellspacing="0" align="center" style="width:98%">
	<tr style="height:35px;">
		<td class="headbold">Ziyaret Formu</td>
	</tr>
</table>
<table cellpadding="2" cellspacing="1" border="0" class="color-border" align="center" style="width:98%">	
	<tr>
		<td class="color-row">
			<cfif get_analysis_questions.recordcount>
                <form name="add_member_analysis" id="add_member_analysis" method="post" action="<cfoutput>#request.self#?fuseaction=pda.emptypopup_add_member_analysis_result</cfoutput>">
                    <cfoutput>
						<cfif isDefined("attributes.is_report")>
                            <input type="hidden" name="is_report" id="is_report" value="#attributes.is_report#">
                        </cfif>
                        <input type="hidden" name="analysis_id" id="analysis_id" value="#attributes.analysis_id#">
                        <input type="hidden" name="action_type" id="action_type" value="<cfif isdefined("attributes.action_type")>#attributes.action_type#</cfif>">
                        <input type="hidden" name="action_type_id" id="action_type_id" value="<cfif isdefined("attributes.action_type_id")>#attributes.action_type_id#</cfif>">
                        <cfif isDefined("attributes.member_type") and attributes.member_type is "partner">
                            <input type="hidden" name="partner_id" id="partner_id" value="#attributes.partner_id#">
                            <input type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
                            <input type="hidden" name="consumer_id" id="consumer_id" value="">
                        <cfelseif isDefined("attributes.member_type") and attributes.member_type eq "consumer">
                            <input type="hidden" name="partner_id" id="partner_id" value="">
                            <input type="hidden" name="company_id" id="company_id" value="">
                            <input type="hidden" name="consumer_id" id="consumer_id" value="#attributes.consumer_id#">
                        </cfif>
                    </cfoutput>
                
					<cfif isDefined("attributes.is_report")>
                        <table border="0" cellspacing="0" cellpadding="0" align="center" style="width:98%">
                            <tr>
                                <td class="txtbold" style="vertical-align:top">Soru Karşılaştırma Şekli<br />
                                    <input type="radio" name="comparison_type" id="comparison_type" value="1" checked> Ve
                                    <input type="radio" name="comparison_type" id="comparison_type" value="2"> Veya
                                </td>
                            </tr>
                        </table>
                        <br/><br/>
                    </cfif>
                    <table>
					<cfoutput query="get_analysis_questions">
                        <tr>
                            <td><a onClick="gizle_goster(question#currentrow#)" style="font-size:14px; cursor:hand;">#getLang('main',1398)#</a></td>
                        </tr>
                        <tr id="question#currentrow#">
                            <td>
                                <table>
                                    <cfif isdefined("attributes.result_id")>
                                        <cfquery name="GET_THIS_QUES" dbtype="query">
                                            SELECT * FROM GET_USER_RESULTS WHERE QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#question_id#">
                                        </cfquery>
                                    </cfif>
                                    <cfif answer_number neq 0>
                                        <cfset attributes.question_id = question_id>
                                        <cfinclude template="../../member/query/get_question_answers.cfm">
                                        <tr>
                                            <td class="txtbold">#question#</td>
                                        </tr>
                                        <cfloop query="get_question_answers">
                                            <cfif len(evaluate("answer_photo")) or len(evaluate("answer_text"))>
                                                <tr>
                                                    <td style="font-size:14px;">
                                                        <cfswitch expression="#get_analysis_questions.question_type#">
                                                            <cfcase value="1">
                                                                <input type="radio" name="user_answer_#get_analysis_questions.currentrow#" id="user_answer_#get_analysis_questions.currentrow#" value="#get_question_answers.currentrow#" <cfif isdefined("get_this_ques.recordcount") and get_this_ques.question_user_answers eq get_question_answers.currentrow>checked</cfif>>
                                                            </cfcase>
                                                            <cfcase value="2">
                                                                <input type="checkbox" name="user_answer_#get_analysis_questions.currentrow#" id="user_answer_#get_analysis_questions.currentrow#" value="#get_question_answers.currentrow#" <cfif isdefined("get_this_ques.recordcount") and listfindnocase(get_this_ques.question_user_answers,get_question_answers.currentrow)>checked</cfif>>
                                                            </cfcase>
                                                        </cfswitch>
                                                        <input type="hidden" name="user_answer_#get_analysis_questions.currentrow#_point" id="user_answer_#get_analysis_questions.currentrow#_point" value="#evaluate('answer_point')#">
                                                        <cfif len(evaluate("answer_photo"))>
                                                            <cf_get_server_file output_file="member/#evaluate("get_question_answers.answer_photo")#" output_server="#evaluate("get_question_answers.answer_photo_server_id")#" output_type="0" image_width="38" image_height="35" image_link="1">
                                                        <br/>
                                                        </cfif>
                                                        #answer_text#
                                                    </td>
                                                </tr>
                                            </cfif>
                                            <cfif get_analysis_questions.answer_number eq 0 or get_analysis_questions.question_type eq 3>
                                                <input type="hidden" name="open_question" id="open_question" value="1">
                                                <tr>
                                                    <td><textarea name="user_answer_#currentrow#" id="user_answer_#currentrow#" cols="45" rows="4" maxlength="1500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="En Fazla 1500 Karakter Girebilirsiniz!"><cfif isdefined("get_this_ques.recordcount") and get_this_ques.recordcount>#get_this_ques.question_user_answers#</cfif></textarea></td>
                                                </tr>
                                            </cfif>
                                        </cfloop>
                                    </cfif>
                                </table>
                            </td>
                        </tr>
                    	<input type="hidden" name="user_answer_#currentrow#" id="user_answer_#currentrow#" value="">
                	</cfoutput>
                    </table>
                    <table>
                        <tr>
                            <td><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
                        </tr>
                    </table>
				</form>
                <br/>
			</cfif>
		</td>
	</tr>
</table>
<script language="javascript">
	function kontrol()
	{
		<cfoutput query="get_analysis_questions">
			<cfif question_type neq 3>
				var eksik_cevap = 0;
				for(i=0; i < 10; i++)
				{
					if(eval('document.add_member_analysis.user_answer_#currentrow#')[i] && (eval('document.add_member_analysis.user_answer_#currentrow#')[i].checked == true))
					{ 
						var eksik_cevap = 1;
					}
				}
				if(eksik_cevap == 0)
				{
					alert('Lütfen tüm seçim kutularını cevaplandırınız!');
					return false;
				}
			</cfif>
		</cfoutput>
	}
</script>

