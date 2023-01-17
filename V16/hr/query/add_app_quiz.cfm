<cfquery name="ADD_QUIZ" datasource="#dsn#">
	INSERT INTO
		EMPLOYEE_QUIZ
		(
		QUIZ_HEAD, 
		IS_ACTIVE,
	<cfif len(QUIZ_OBJECTIVE)>
		QUIZ_OBJECTIVE,  
	</cfif>
		STAGE_ID,
		IS_APPLICATION,
		IS_EDUCATION,
		IS_TRAINER,
		IS_INTERVIEW,
		IS_TEST_TIME,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE
	)
	VALUES
	(
		'#QUIZ_HEAD#', 
		<cfif IsDefined("attributes.IS_ACTIVE")>1<cfelse>0</cfif>,
	<cfif len(QUIZ_OBJECTIVE)>
		'#QUIZ_OBJECTIVE#',  
	</cfif>
		#STAGE_ID#,
		1,
		0,
		0,
		0,
		0,
		#SESSION.EP.USERID#, 
		'#CGI.REMOTE_ADDR#',
		#Now()#
		)
</cfquery>
<cfquery name="get_max" datasource="#dsn#">
	SELECT MAX(QUIZ_ID) AS QUIZ_ID FROM EMPLOYEE_QUIZ
</cfquery>

<cflocation url="#request.self#?fuseaction=hr.quiz&quiz_id=#GET_MAX.quiz_id#" addtoken="no">
