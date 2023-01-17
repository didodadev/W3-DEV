<cfquery name="ADD_QUIZ_RESULT" datasource="#dsn#">
	INSERT INTO
		QUIZ_RESULTS
		(
		QUIZ_ID,
		EMP_ID,
		USER_POINT,
		USER_RIGHT_COUNT,
		USER_WRONG_COUNT,
 		START_DATE,
		IS_STOPPED_QUIZ,
		RECORD_EMP
		,RECORD_IP 
		,RECORD_DATE
		)
	VALUES
		(
		#SESSION.QUIZ_ID#,
		#attributes.employee_id#,
		0,
		0,
		0,
 		#now()#,
		<cfif isdefined("attributes.is_stopped_quiz") and len(attributes.is_stopped_quiz) and attributes.is_stopped_quiz eq 1>
			1,
		<cfelse>
			0,
		</cfif>
		#SESSION.EP.USERID#,
		'#CGI.REMOTE_USER#',
		#NOW()#			
		)
</cfquery>	

<cfquery name="GET_RESULT_ID" datasource="#dsn#">
	SELECT
		MAX(RESULT_ID) AS MAX_ID
	FROM
		QUIZ_RESULTS
	WHERE
		EMP_ID=#attributes.employee_id#
		AND
		QUIZ_ID = #SESSION.QUIZ_ID#
</cfquery>

<cfset SESSION.RESULT_ID = GET_RESULT_ID.MAX_ID>
