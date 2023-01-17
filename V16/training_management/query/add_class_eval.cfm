<CFTRANSACTION>
	<cfquery name="get_emp_att" datasource="#dsn#">
	  SELECT EMP_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID=#attributes.CLASS_ID# AND EMP_ID IS NOT NULL AND PAR_ID IS NULL AND CON_ID IS NULL
	</cfquery>
	<cfloop query="get_emp_att">
	<cfset attributes.emp_id = get_emp_att.EMP_ID>
		<cfquery name="ADD_QUIZ_RESULT" datasource="#dsn#">
			INSERT INTO
				TRAINING_CLASS_EVAL
				(
					CLASS_ID,
					QUIZ_ID,
					EMP_ID,
					USER_POINT,
					IS_UNNAMED,
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP
				)
			VALUES
				(
					#attributes.CLASS_ID#,
					#attributes.QUIZ_ID#,
					#attributes.emp_id#,
					0,
					#Evaluate('attributes.IS_UNNAMED_'&attributes.emp_id)#,
					#session.ep.userid#,
					#Now()#,
					'#cgi.REMOTE_ADDR#'
				)
		</cfquery>	
		<cfquery name="GET_RESULT_ID" datasource="#dsn#">
			SELECT
				MAX(CLASS_EVAL_ID) AS MAX_ID
			FROM
				TRAINING_CLASS_EVAL
			WHERE
				EMP_ID=#attributes.emp_id#
				AND
				QUIZ_ID = #attributes.QUIZ_ID#
				AND
				CLASS_ID = #attributes.CLASS_ID#
		</cfquery>
		<cfset RESULTID = GET_RESULT_ID.MAX_ID> 
		<cfinclude template="../query/get_training_eval_quiz_chapters.cfm">
			<cfset puan = 0>
				<cfloop query="get_quiz_chapters">
				<cfset attributes.CHAPTER_ID = get_quiz_chapters.CHAPTER_ID>
				<cfinclude template="../query/get_training_eval_quiz_questions.cfm">
					<cfloop query="get_quiz_questions">
						
						<cfset formdaki_puan = 'FORM.USER_ANSWER_'&get_quiz_chapters.currentrow&'_'&get_quiz_questions.currentrow&'_'&attributes.emp_id>
						
						<cfif IsDefined("#formdaki_puan#") AND IsNumeric(Evaluate(formdaki_puan))>
							<cfset puan = puan + Evaluate(formdaki_puan)>
						</cfif>
						<cfoutput>puan+++#puan#</cfoutput><br/>		
						<cfquery name="ADD_RESULT_DETAIL" datasource="#dsn#">
							INSERT INTO
								TRAINING_CLASS_EVAL_DETAILS
								(
								CLASS_EVAL_ID,
								QUESTION_ID,
								
								QUESTION_POINT
								)
							VALUES
								(
								#RESULTID#,
								#GET_QUIZ_QUESTIONS.QUESTION_ID#,
								
								<cfif IsDefined("#formdaki_puan#") AND IsNumeric(Evaluate(formdaki_puan))>
									#Evaluate(formdaki_puan)#
								<cfelse>
									0
								</cfif>
								)
						</cfquery>  
					
				</cfloop> 
			<!--- </cfif> --->
		</cfloop> <cfoutput>puan#puan#</cfoutput><br/>
		 <cfquery name="UPD_RESULT" datasource="#dsn#">
			UPDATE
				TRAINING_CLASS_EVAL
			SET
				USER_POINT = #puan#,
				QUIZ_ID = #attributes.QUIZ_ID#,
				EMP_ID = #attributes.emp_id#,
				IS_UNNAMED = #Evaluate('attributes.IS_UNNAMED_'&attributes.emp_id)#,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP = '#cgi.REMOTE_ADDR#'
			WHERE
				CLASS_EVAL_ID = #RESULTID#
		</cfquery> 
	</cfloop> 
	<!--- </cfif> --->
<!--- //form sonuç kaydı --->
 
</CFTRANSACTION>

<script type="text/javascript">
wrk_opener_reload();
window.close();
</script>
