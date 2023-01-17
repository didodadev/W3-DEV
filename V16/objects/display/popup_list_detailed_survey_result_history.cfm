<cfsetting showdebugoutput="no">
<cfquery name="get_survey_main_result_history" datasource="#dsn#">
	SELECT
		RES.OPTION_NOTE,
		RES.RECORD_DATE,
		RES.OPTION_NOTE,
		RES.OPTION_POINT,
		RES.OPTION_HEAD AS OPT_HEAD,
		RES.SURVEY_RESULT_HISTORY_ID,
		RES.SURVEY_OPTION_ID,
		SO.OPTION_HEAD,
		SQ.QUESTION_HEAD,
		SQ.SURVEY_QUESTION_ID,
		SQ.QUESTION_TYPE,
		SQ.SURVEY_QUESTION_ID
	FROM
		SURVEY_QUESTION_RESULT_HISTORY RES,
		SURVEY_OPTION SO,
		SURVEY_QUESTION SQ
	WHERE
		SO.SURVEY_OPTION_ID = RES.SURVEY_OPTION_ID AND 
		SQ.SURVEY_QUESTION_ID = SO.SURVEY_QUESTION_ID AND 
		RES.SURVEY_MAIN_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.result_id#">
	ORDER BY	
		RES.SURVEY_RESULT_HISTORY_ID
</cfquery>
<cfset history_id_list = ListSort(listDeleteDuplicates(ValueList(get_survey_main_result_history.SURVEY_RESULT_HISTORY_ID,',')),'numeric','asc',',')>
<table width="100%" height="100%" cellpadding="2" cellspacing="1" class="color-border" align="center">
	<tr class="color-list">
		<td class="headbold" height="35"><cf_get_lang dictionary_id='57473.Tarihçe'></td>
	</tr>
	<tr class="color-row">
		<td valign="top">
			<table width="99%">
				<cfif get_survey_main_result_history.recordcount>
					<cfloop list="#history_id_list#" index="xx">
						<cfquery name="get_all_question_id" dbtype="query">
							SELECT SURVEY_QUESTION_ID,RECORD_DATE FROM get_survey_main_result_history WHERE SURVEY_RESULT_HISTORY_ID = #xx#
						</cfquery>
						<cfset question_id_list = ListSort(listDeleteDuplicates(ValueList(get_all_question_id.survey_question_id,',')),'numeric','asc',',')>
						<table width="100%" border="0" cellspacing="1" cellpadding="2">
							<cfloop list="#question_id_list#" index="qid">
								<cfquery name="get_question_head" datasource="#dsn#">
									SELECT QUESTION_HEAD FROM SURVEY_QUESTION WHERE SURVEY_QUESTION_ID = #qid#
								</cfquery>
								<tr height="20">
									<td class="txtboldblue"><cfoutput>#get_question_head.question_head#</cfoutput></td>
								</tr>
								 <cfquery name="get_all_option_id" dbtype="query">
									SELECT SURVEY_OPTION_ID FROM get_survey_main_result_history WHERE SURVEY_RESULT_HISTORY_ID = #xx# AND SURVEY_QUESTION_ID = #qid#	
								</cfquery>
								 <cfset option_id_list = ListSort(listDeleteDuplicates(ValueList(get_all_option_id.survey_option_id,',')),'numeric','asc',',')> 
								 <cfloop list="#option_id_list#" index="opt_id">
									<cfquery name="get_option_head" dbtype="query">
										SELECT * FROM get_survey_main_result_history WHERE SURVEY_RESULT_HISTORY_ID = #xx# AND SURVEY_OPTION_ID = #opt_id# 
									</cfquery>
									<tr height="20">
										<td><cfoutput>
												#get_option_head.option_head# 
												<cfif get_option_head.question_type eq 4 and isdefined('get_option_head.option_point') and len(get_option_head.option_point)>
													(#get_option_head.option_point#)
												<cfelseif get_option_head.question_type eq 3 and isdefined('get_option_head.opt_head') and len(get_option_head.opt_head)>
													(#get_option_head.opt_head#)
												</cfif>
												<cfif isdefined('get_option_head.option_note') and len(get_option_head.option_note)>(#get_option_head.option_note#)</cfif>
											</cfoutput>
										</td>
									</tr>
								</cfloop>
							</cfloop>
							 <tr>
								<td class="txtbold"><cf_get_lang dictionary_id='55055.Güncelleme Tarihi'> : <cfoutput>#dateformat(get_all_question_id.record_date,dateformat_style)#</cfoutput></td>
							</tr> 
							<tr>
								<td><img src="/images/cizgi_yan_50.gif" alt="" width="100%" height="15"></td>
							</tr>
						</table>
					</cfloop>
				<cfelse>
					<tr height="20">
						<td valign="top"></td><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td></tr>
					</tr>
				</cfif>
			</table>
		</td>
	</tr> 
</table>

