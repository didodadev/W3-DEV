<!--- ilgili analizler --->
<cfquery name="GET_ANALYSIS" datasource="#DSN#">
	SELECT 
		ANALYSIS_AVERAGE,
		ANALYSIS_HEAD,
		ANALYSIS_PARTNERS,
		ANALYSIS_CONSUMERS 
	FROM 
		MEMBER_ANALYSIS 
	WHERE 
		ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.analysis_id#">
</cfquery>
<!--- Ilgili analize ait sorular --->
<cfquery name="GET_ANALYSIS_QUESTIONS" datasource="#DSN#">
	SELECT QUESTION_ID, QUESTION_TYPE FROM  MEMBER_QUESTION WHERE ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.analysis_id#"> ORDER BY QUESTION_ID
</cfquery>

<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_ANALYSIS_RESULT" datasource="#DSN#" result="MAX_ID">
			INSERT INTO
				MEMBER_ANALYSIS_RESULTS
			(
				ANALYSIS_ID,
				PARTNER_ID,
				COMPANY_ID,
				CONSUMER_ID,
				PROJECT_ID,
				OPPORTUNITY_ID,
				OFFER_ID,	
				OUR_COMPANY_ID,
				RIVAL_ID,
				RECORD_DATE,	
				RECORD_EMP,
				RECORD_IP
			)
			VALUES
			(
				#attributes.analysis_id#,
				<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>
					#attributes.partner_id#, 
					#attributes.company_id#, 
					NULL,
				<cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
					NULL, 
					NULL,
					#attributes.consumer_id#,
				<cfelse>
					NULL,
					NULL,
					NULL,
				</cfif>
				<cfif attributes.action_type eq 'PROJECT'>#attributes.action_type_id#<cfelse>NULL</cfif>,
				<cfif attributes.action_type eq 'OPPORTUNITY'>#attributes.action_type_id#<cfelse>NULL</cfif>,
				<cfif attributes.action_type eq 'OFFER'>#attributes.action_type_id#<cfelse>NULL</cfif>,
				<cfif attributes.action_type eq 'OPPORTUNITY' or attributes.action_type eq 'OFFER'>#session.ep.company_id#<cfelse>NULL</cfif>,
				<cfif attributes.action_type eq 'RIVAL'>#attributes.action_type_id#<cfelse>NULL</cfif>,
				#now()#,
				#session.pda.userid#,
				'#cgi.remote_addr#'			
			)
		</cfquery>
		<cfquery name="ADD_RESULT" datasource="#DSN#">
			UPDATE
				MEMBER_ANALYSIS_RESULTS
			SET
				QUESTION_COUNT = #get_analysis_questions.recordcount#,
				AVERAGE = #get_analysis.analysis_average#
			WHERE
				RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">
		</cfquery>

		<cfset puan = 0>
		<cfoutput query="get_analysis_questions">
			<cfset puan0 = 0>
			<cfif isdefined("attributes.user_answer_#currentrow#") and isdefined("attributes.user_answer_#currentrow#_point") and get_analysis_questions.question_type neq 3>
				<cfloop list="#evaluate('attributes.user_answer_'&currentrow)#"  index="aaa">
					<cfset puan = puan + ListGetAt(evaluate('attributes.user_answer_'&currentrow&'_point'), aaa)>
				</cfloop>
				<cfloop list="#evaluate('attributes.user_answer_'&currentrow)#"  index="aaa">
					<cfset puan0 = puan0 + ListGetAt(evaluate('attributes.user_answer_'&currentrow&'_point'), aaa)>
				</cfloop>
				<cfif isDefined("attributes.user_answer_#currentrow#")>
					<cfset temp_user_answer = evaluate("attributes.user_answer_#currentrow#")>
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
							#MAX_ID.IDENTITYCOL#,
							#get_analysis_questions.question_id#,
							#puan0#,
							'#temp_user_answer#'
						)
					</cfquery>
				</cfif>
			<cfelse>
			<!--- acik uclu soru ise kaydi yapiliyor --->	
				<cfif isDefined("attributes.user_answer_#currentrow#")>
					<cfset temp_user_answer = evaluate("attributes.user_answer_#currentrow#")>
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
							 #MAX_ID.IDENTITYCOL#,
							#get_analysis_questions.question_id#,
							0,
							'#temp_user_answer#'
						)
					</cfquery>
				</cfif>
			</cfif>
		</cfoutput>
		<!--- Sonucu guncelle --->
		<cfquery name="UPD_RESULT" datasource="#DSN#">
			UPDATE
				MEMBER_ANALYSIS_RESULTS
			SET
				USER_POINT = #puan#
			WHERE
				RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">
		</cfquery>
	</cftransaction>
</cflock>
<script>
	alert("Kaydınız Başarıyla Alınmıştır!");
	return false;
</script>
<cflocation url="#request.self#?fuseaction=pda.daily" addtoken="no">
