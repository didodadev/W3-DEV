<cfabort>
<!--- kağıdı gönder --->
	<cfquery name="ADD_RESULT" datasource="#dsn#">
		UPDATE
			MEMBER_ANALYSIS_RESULTS
		SET
			ANALYSIS_ID = #SESSION.ANALYSIS_ID#,
			<cfif session.member_type EQ "partner">
				PARTNER_ID = #SESSION.memberid#,
			<cfelse>
				CONSUMER_ID = #SESSION.memberid#,
			</cfif>
			QUESTION_COUNT = #GET_ANALYSIS_QUESTIONS.RecordCount#,
			AVERAGE = #GET_ANALYSIS.ANALYSIS_AVERAGE#
		WHERE
			RESULT_ID = #SESSION.RESULT_ID#
	</cfquery>
	<cfset puan = 0>
	<cfoutput query="get_analysis_questions">
	<cfset puan0 = 0>
		<cfif IsDefined("FORM.user_answer_#currentrow#") and IsDefined("FORM.user_answer_#currentrow#_point")>
			#EVALUATE('FORM.user_answer_'&currentrow)# - 
			#EVALUATE('FORM.user_answer_'&currentrow&'_point')#
			 *** 
			<cfloop list="#EVALUATE('FORM.user_answer_'&currentrow)#"  index="aaa">
				<cfset puan = puan + #ListGetAt(EVALUATE('FORM.user_answer_'&currentrow&'_point'), aaa)#>
			</cfloop>
			<cfloop list="#EVALUATE('FORM.user_answer_'&currentrow)#"  index="aaa">
				<cfset puan0 = puan0 + #ListGetAt(EVALUATE('FORM.user_answer_'&currentrow&'_point'), aaa)#>
			</cfloop>
			<cfif isDefined("form.user_answer_#currentrow#")>
				<cfquery name="ADD_RESULT_DETAIL" datasource="#dsn#">
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
						#SESSION.RESULT_ID#,
						#GET_ANALYSIS_QUESTIONS.QUESTION_ID#,
						#puan0#,
						'#wrk_eval("FORM.USER_ANSWER_#CURRENTROW#")#'
						)
				</cfquery>
			</cfif>
		<cfelse>
		<!--- açık uçlu soru ise kaydı yapılıyor --->	
			<cfif isDefined("form.user_answer_#currentrow#")>
				<cfquery name="ADD_RESULT_DETAIL" datasource="#dsn#">
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
						#SESSION.RESULT_ID#,
						#GET_ANALYSIS_QUESTIONS.QUESTION_ID#,
						0,
						'#wrk_eval("FORM.USER_ANSWER_#CURRENTROW#")#'
						)
				</cfquery>
			</cfif>
		</cfif>
		<br/>
	</cfoutput>
<!--- // kağıdı gönder --->
	<cfset attributes.result_id = session.result_id>
	<!--- sonucu veritabanına gönder --->
	<cfquery name="UPD_RESULT" datasource="#dsn#">
		UPDATE
			MEMBER_ANALYSIS_RESULTS
		SET
			USER_POINT = #puan#,
			RECORD_DATE = #now()#,
			RECORD_IP = '#CGI.REMOTE_ADDR#'
		WHERE
			RESULT_ID = #SESSION.RESULT_ID#
	</cfquery>
<cfscript>
	structDelete(session,"memberid");
	structDelete(session,"member_type");
	structDelete(session,"result_id");
	structDelete(session,"analysis_id");
</cfscript>
<cfif isdefined("attributes.is_popup")>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script> 
<cfelse>
	<script type="text/javascript">
		opener.location.href='<cfoutput>#request.self#?fuseaction=crm.analysis_results&analysis_id=#attributes.analysis_id#</cfoutput>';
		window.close();
	</script> 
</cfif>
