<cfquery name="UPD_QUIZ" datasource="#dsn#">
	UPDATE
		EMPLOYEE_QUIZ
	SET
	<cfif isDefined("QUIZ_OBJECTIVE")>
		QUIZ_OBJECTIVE = '#Trim(QUIZ_OBJECTIVE)#',  
	<cfelse>
		QUIZ_OBJECTIVE = NULL,  
	</cfif>
		QUIZ_HEAD = '#QUIZ_HEAD#', 
		IS_ACTIVE = <cfif IsDefined("attributes.IS_ACTIVE")>1<cfelse>0</cfif>,
		IS_APPLICATION = 1,
		IS_EDUCATION = 0,
		IS_TRAINER = 0,
		IS_INTERVIEW = 0,
		IS_TEST_TIME = 0,
		STAGE_ID = #STAGE_ID#,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #SESSION.EP.USERID#, 
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE
		QUIZ_ID = #QUIZ_ID#
</cfquery>

<script language="JavaScript">
	opener.location.reload();
	window.close();
</script>
