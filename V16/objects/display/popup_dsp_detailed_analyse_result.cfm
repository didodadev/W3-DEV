<cfquery name="survey_result_detail" datasource="#dsn#">
	SELECT 
		SM.SURVEY_MAIN_HEAD ,
		SMR.SCORE_RESULT,
		SMR.SURVEY_MAIN_ID,
		SM.SCORE1,
		SM.SCORE2,
		SM.SCORE3,
		SM.SCORE4,
		SM.SCORE5
	FROM 
		SURVEY_MAIN SM, 
		SURVEY_MAIN_RESULT SMR 
	WHERE 
		SM.SURVEY_MAIN_ID = SMR.SURVEY_MAIN_ID AND 
		SMR.SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
</cfquery>
<!--- İlgili anketin, bolum ve sorularini getirir, optionları loop edebilmek için kullanılır --->
<cfquery name="get_survey_info" datasource="#dsn#">
	SELECT
		SC.SURVEY_MAIN_ID,
		SC.SURVEY_CHAPTER_ID,
		SC.SURVEY_CHAPTER_HEAD,
		SQ.SURVEY_QUESTION_ID,
		SQ.QUESTION_HEAD,
		SQ.QUESTION_TYPE
	FROM
		SURVEY_CHAPTER SC,
		SURVEY_QUESTION SQ
	WHERE
		SC.SURVEY_CHAPTER_ID = SQ.SURVEY_CHAPTER_ID AND
		SC.SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
	ORDER BY
		SC.SURVEY_CHAPTER_ID,
		SQ.SURVEY_QUESTION_ID
</cfquery>
<cfquery name="get_options_record" datasource="#dsn#">
	SELECT 
		SURVEY_OPTION_ID 
	FROM 
		SURVEY_QUESTION_RESULT 
	WHERE 
		SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='57560.Analiz'></cfsavecontent>
<cf_popup_box title="#message# : #survey_result_detail.survey_main_head#">
	<table width="98%" align="center">
		<tr>
			<td class="txtbold" height="22" colspan="2"><cf_get_lang dictionary_id='51943.Katılım'> : <cfoutput>#survey_result_detail.RecordCount#</cfoutput></td>
		</tr>
		<tr>
			<td width="300">
				<cfif survey_result_detail.recordcount>
					<cfchart show3d="yes" labelformat="number" pieslicestyle="solid" format="jpg"> 
					<cfchartseries type="bar" >    
						<cfloop from="6" to="2" index="scr" step="-1">
							<cfif scr eq 6>
								<cfset "new_score6" = 0>
								<cfset "new_score#scr-1#" = Evaluate("survey_result_detail.score#scr-1#")>
							</cfif>
							<cfif scr neq 6>
								<cfset "new_score#scr#" = Evaluate("survey_result_detail.score#scr#")>
								<cfset "new_score#scr-1#" = Evaluate("survey_result_detail.score#scr-1#")>
							</cfif>
							<cfif not len(Evaluate("new_score#scr#"))><cfset "new_score#scr#" = 0></cfif>
							<cfif not len(Evaluate("new_score#scr-1#"))><cfset "new_score#scr-1#" = 0></cfif>
							<cfquery name="get_count_survey" datasource="#dsn#">
								SELECT 
									COUNT(ISNULL(SMR.SCORE_RESULT,0)) AS SCORE_RESULT
								FROM 
									SURVEY_MAIN_RESULT SMR,
									SURVEY_MAIN SM
								 WHERE 
									SM.SURVEY_MAIN_ID = SMR.SURVEY_MAIN_ID AND
									SMR.SCORE_RESULT BETWEEN (#Evaluate("new_score#scr#")#) AND (#Evaluate("new_score#scr-1#")-1#)
									AND SMR.SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
							</cfquery>
							<cfquery name="get_survey" datasource="#dsn#">
								SELECT COMMENT1,COMMENT2,COMMENT3,COMMENT4,COMMENT5 FROM SURVEY_MAIN WHERE SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.survey_id#">
							</cfquery>
							  <cfchartdata item="#Evaluate('get_survey.comment#scr-1#')#" value="#get_count_survey.score_result#">    
						</cfloop>
						</cfchartseries>
					</cfchart>    
				</cfif>
			</td>
		</tr>
		<cfset chapter_current_row = 1>
		<cfoutput query="get_survey_info" group="survey_chapter_id"><!--- bolumler --->
			<tr>
				<td class="txtbold"><h5><cf_get_lang dictionary_id='57995.Bölüm'> #chapter_current_row# : #survey_chapter_head#</h5></td>
			</tr>
			<cfquery name="get_survey_questions" dbtype="query"> <!--- ilgili bölümün sorularını getirir --->
				SELECT SURVEY_QUESTION_ID, QUESTION_HEAD, QUESTION_TYPE FROM GET_SURVEY_INFO WHERE SURVEY_CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#survey_chapter_id#">
			</cfquery>
			 <cfloop query="get_survey_questions">
				<cfquery name="get_survey_options" datasource="#dsn#"><!--- ilgili sorunun optionlarını getirir --->
					SELECT 
						SO.SURVEY_OPTION_ID, 
						SO.OPTION_HEAD,
						SO.SURVEY_QUESTION_ID
					FROM  
						SURVEY_OPTION SO, 
						SURVEY_QUESTION SQ,
						SURVEY_QUESTION_RESULT SOR
					WHERE 
						SQ.SURVEY_QUESTION_ID = SO.SURVEY_QUESTION_ID AND 
						SOR.SURVEY_MAIN_ID = SQ.SURVEY_MAIN_ID AND
						SO.SURVEY_QUESTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#survey_question_id#">
					GROUP BY
						SO.SURVEY_OPTION_ID,
						SO.SURVEY_QUESTION_ID,
						SO.OPTION_HEAD
				</cfquery>
				<tr>
					<td class="txtboldblue" height="15" valign="top"><cf_get_lang dictionary_id='58810.Soru'> #currentrow# : #question_head#</td><!--- bolumun sorularını dondurur --->
				</tr>
				<tr>
					<td width="300">
						<cfif get_survey_questions.question_type neq 3> 
						<cfchart show3d="yes" labelformat="number" pieslicestyle="solid" format="jpg"> 
						<cfchartseries type="bar" >
							<cfloop query="get_survey_options">
								<cfquery name="get_options_record_" dbtype="query">
									SELECT SURVEY_OPTION_ID FROM GET_OPTIONS_RECORD WHERE SURVEY_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#survey_option_id#">
								</cfquery>
								<cfchartdata item="#get_survey_options.option_head#" value="#get_options_record_.recordcount#">
							</cfloop>
						</cfchartseries>
						</cfchart>
						</cfif>
					</td>
					<td>
						<table>
							<cfif get_survey_questions.question_type neq 3>
								<cfloop query="get_survey_options">
									<cfquery name="get_options_record_" dbtype="query">
										SELECT SURVEY_OPTION_ID FROM GET_OPTIONS_RECORD WHERE SURVEY_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#survey_option_id#">
									</cfquery>
									<tr>
										<td>#OPTION_HEAD# :</td>
										<td>#get_options_record_.recordcount# <br /></td>
									</tr>
								</cfloop>  
							<cfelse>
								<tr>
									<td colspan="2">&nbsp;<cf_get_lang dictionary_id='29796.Açık Uçlu'></td>
								</tr> 
							</cfif>
						</table>
					</td>
				</tr>
			</cfloop> 
			<cfset chapter_current_row = chapter_current_row + 1>
		</cfoutput>
	</table>
</cf_popup_box>
