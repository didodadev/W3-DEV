<cftransaction>
	<cfquery name="ADD_QUIZ" datasource="#dsn#">
		INSERT INTO	EMPLOYEE_QUIZ
		(
			<cfif isDefined("POSITION_CAT_ID")>POSITION_CAT_ID,</cfif>
			<cfif isDefined("POSITION_ID")>POSITION_ID,</cfif>
			<cfif len(QUIZ_OBJECTIVE)>QUIZ_OBJECTIVE,</cfif>
			QUIZ_HEAD, 
			COMMETHOD_ID,
			IS_ACTIVE,
			STAGE_ID,
			IS_APPLICATION,
			IS_EDUCATION,
			IS_TRAINER,
			RECORD_EMP, 
			RECORD_IP
		)
		VALUES
		(
			<cfif isDefined("POSITION_CAT_ID")>',#POSITION_CAT_ID#',</cfif>
			<cfif isDefined("POSITION_ID")>'#POSITION_ID#',</cfif>
			<cfif len(QUIZ_OBJECTIVE)>'#QUIZ_OBJECTIVE#',</cfif>
			'#QUIZ_HEAD#', 
			#COMMETHOD_ID#,
			<cfif IsDefined("attributes.IS_ACTIVE")>1<cfelse>0</cfif>,
			#STAGE_ID#,
			<cfif attributes.IS_TYPE is 'IS_APPLICATION'>1<cfelse>0</cfif>,
			<cfif attributes.IS_TYPE is 'IS_EDUCATION'>1<cfelse>0</cfif>,
			<cfif attributes.IS_TYPE is 'IS_TRAINER'>1<cfelse>0</cfif>,
			#SESSION.EP.USERID#, 
			'#CGI.REMOTE_ADDR#'
		)
	</cfquery>
	
	<cfquery name="GET_QUIZ" datasource="#dsn#">
		SELECT 
			MAX(QUIZ_ID) AS QUIZ_ID
		FROM
			EMPLOYEE_QUIZ
	</cfquery>
</cftransaction>
<cflocation addtoken="no" url="#request.self#?fuseaction=training_management.dsp_eval_quiz&quiz_id=#GET_QUIZ.QUIZ_ID#">
