<cfquery name="GET_ANALYSIS" datasource="#DSN#">
	SELECT 
		ANALYSIS_AVERAGE 
	FROM 
		MEMBER_ANALYSIS
	WHERE
		ANALYSIS_ID = #attributes.analysis_id#
</cfquery>
<cfquery name="GET_ANALYSIS_QUESTIONS" datasource="#DSN#">
	SELECT 
		QUESTION_ID,
		QUESTION_TYPE,
		ANSWER_NUMBER
	FROM 
		MEMBER_QUESTION
	WHERE
		ANALYSIS_ID = #attributes.analysis_id#
	ORDER BY
		QUESTION_ID
</cfquery>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfset puan = 0>
		<cfquery name="DEL_RESULT_DETAIL" datasource="#DSN#">
			DELETE FROM
				MEMBER_ANALYSIS_RESULTS_DETAILS
			WHERE
				RESULT_ID = #attributes.result_id#
		</cfquery>
		<cfoutput query="get_analysis_questions">
			<cfset puan0 = 0>
			<cfif isdefined("attributes.user_answer_#currentrow#") and isdefined("attributes.user_answer_#currentrow#_point")>
				<cfloop list="#evaluate('attributes.user_answer_'&currentrow)#"  index="aaa">
					<cfset puan = puan + ListGetAt(evaluate('attributes.user_answer_'&currentrow&'_point'), aaa)>
				</cfloop>
				<cfloop list="#evaluate('attributes.user_answer_'&currentrow)#"  index="aaa">
					<cfset puan0 = puan0 + ListGetAt(evaluate('attributes.user_answer_'&currentrow&'_point'), aaa)>
				</cfloop>
				<cfif isdefined("attributes.user_answer_#currentrow#")>
					<cfset temp_user_answer=evaluate("attributes.user_answer_#currentrow#")>
					<cfquery name="ADD_RESULT_DETAIL" datasource="#DSN#">
						INSERT INTO
							MEMBER_ANALYSIS_RESULTS_DETAILS
						(
							RESULT_ID,
							QUESTION_ID,
							QUESTION_POINT,
							QUESTION_USER_ANSWERS
						)
						VALUES
							(
							#attributes.result_id#,
							#get_analysis_questions.question_id#,
							#puan0#,
							'#temp_user_answer#'
						)
					</cfquery>
				</cfif>
			<cfelse>
				<!--- acik uclu soru ise kaydi yapiliyor --->	
				<cfif isdefined("attributes.user_answer_#QUESTION_ID#_#currentrow#") and isnumeric(evaluate("attributes.open_question_#currentrow#"))>
				<cfset temp_user_answer=evaluate("attributes.user_answer_#QUESTION_ID#_#currentrow#")>
					<cfquery name="ADD_RESULT_DETAIL" datasource="#DSN#">
						INSERT INTO
							MEMBER_ANALYSIS_RESULTS_DETAILS
						(
							RESULT_ID,
							QUESTION_ID,
							QUESTION_POINT,
							QUESTION_USER_ANSWERS
						)
						VALUES
						(
							#attributes.result_id#,
							#get_analysis_questions.question_id#,
							#evaluate("attributes.open_question_#currentrow#")#,
							'#temp_user_answer#'
						)
					</cfquery>
					<cfset puan = puan + evaluate("attributes.open_question_#currentrow#")>
				</cfif>
			</cfif>
		</cfoutput>
		<cfquery name="UPD_RESULT" datasource="#DSN#">
			UPDATE
				MEMBER_ANALYSIS_RESULTS
			SET
				QUESTION_COUNT = #get_analysis_questions.recordcount#,
				AVERAGE = #get_analysis.analysis_average#,
				USER_POINT = #puan#,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#'	
			WHERE
				RESULT_ID = #attributes.result_id#
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	<cfif attributes.draggable eq 1>
		location.href = document.referrer;
	<cfelse>
		wrk_opener_reload();
		window.close();
	</cfif>
</script>

