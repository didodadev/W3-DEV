<cftransaction>
	<cfquery name="ADD_RESULT" datasource="#dsn#">
		UPDATE
			MEMBER_ANALYSIS_RESULTS
		SET
			ANALYSIS_ID = #attributes.analysis_id#,
			<cfif session.member_type EQ "partner">
				PARTNER_ID = #SESSION.memberid#,
			<cfelse>
				CONSUMER_ID = #SESSION.memberid#,
			</cfif>
			QUESTION_COUNT = #GET_ANALYSIS_QUESTIONS.RecordCount#,
			AVERAGE = #GET_ANALYSIS.ANALYSIS_AVERAGE#
		WHERE
			RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.result_id#">
	</cfquery>
	<cfset puan = 0>
	<cfquery name="DEL_RESULT_DETAIL" datasource="#dsn#">
		DELETE FROM
			MEMBER_ANALYSIS_RESULTS_DETAILS
		WHERE
			RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.result_id#">
	</cfquery>
	<cfoutput query="get_analysis_questions">
	<cfset puan0 = 0>
		<cfif IsDefined("FORM.user_answer_#currentrow#") and IsDefined("FORM.user_answer_#currentrow#_point")>
			#EVALUATE('FORM.user_answer_'&currentrow)# - 
			#EVALUATE('FORM.user_answer_'&currentrow&'_point')#
			 *** 
			 <br/>
			ilk puan#puan#
			 <br/>
			ilk puan0#puan0#
			<cfloop list="#EVALUATE('FORM.user_answer_'&currentrow)#"  index="aaa">
				<cfset puan = puan + #ListGetAt(EVALUATE('FORM.user_answer_'&currentrow&'_point'), aaa)#>
			</cfloop>
			 <br/>
			sonra puan#puan#
			<cfloop list="#EVALUATE('FORM.user_answer_'&currentrow)#"  index="aaa">
				<cfset puan0 = puan0 + #ListGetAt(EVALUATE('FORM.user_answer_'&currentrow&'_point'), aaa)#>
			</cfloop>
			 <br/>
			 sonra puan0#puan0#
	
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
						#EVALUATE("FORM.open_question_#CURRENTROW#")#,
						'#wrk_eval("FORM.USER_ANSWER_#CURRENTROW#")#'
						)
				</cfquery>
				<cfset puan = puan + EVALUATE("FORM.open_question_#CURRENTROW#")>
			 <br/>
		en	sonra puan#puan#
			</cfif>
		</cfif>
		<br/>
		<br/>MEMBER_ANALYSIS_RESULTS 1111 en	sonra puan#puan#
	</cfoutput>
<!--- // kağıdı gönder --->

	<!--- sonucu veritabanına gönder --->
	<cfquery name="UPD_RESULT" datasource="#dsn#">
		UPDATE
			MEMBER_ANALYSIS_RESULTS
		SET
			USER_POINT = #puan#,
			RECORD_DATE = #now()#,
			RECORD_IP = '#CGI.REMOTE_ADDR#'
		WHERE
			RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.result_id#">
	</cfquery>
		<br/>MEMBER_ANALYSIS_RESULTS en	sonra puan#puan#
		
<cfscript>
	structDelete(session,"member_type");
	structDelete(session,"memberid");
	structDelete(session,"result_id");
	structDelete(session,"analysis_id");
</cfscript>
<cflocation url="#request.self#?fuseaction=objects2.analysis" addtoken="no">
