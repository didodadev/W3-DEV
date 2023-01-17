<cfquery name="UPD_QUIZ" datasource="#dsn#">
	UPDATE
		EMPLOYEE_QUIZ
	SET
	<cfif isDefined("POSITION_CAT_ID")>
		POSITION_CAT_ID = ',#POSITION_CAT_ID#,', 
	<cfelse>
		POSITION_CAT_ID = NULL, 
	</cfif>
	<cfif isDefined("POSITION_ID")>
		POSITION_ID = ',#POSITION_ID#,',  
	<cfelse>
		POSITION_ID = NULL,  
	</cfif>
	<cfif isDefined("QUIZ_OBJECTIVE")>
		QUIZ_OBJECTIVE = '#Trim(QUIZ_OBJECTIVE)#',  
	<cfelse>
		QUIZ_OBJECTIVE = NULL,  
	</cfif>
		QUIZ_HEAD = '#QUIZ_HEAD#', 
		COMMETHOD_ID = #COMMETHOD_ID#,
		IS_APPLICATION = <cfif attributes.IS_TYPE IS 'IS_APPLICATION'>1<cfelse>0</cfif>,
		IS_EDUCATION = <cfif attributes.IS_TYPE IS 'IS_EDUCATION'>1<cfelse>0</cfif>,
		IS_TRAINER = <cfif attributes.IS_TYPE IS 'IS_TRAINER'>1<cfelse>0</cfif>,
		IS_ACTIVE = <cfif IsDefined("attributes.IS_ACTIVE")>1<cfelse>0</cfif>,
		STAGE_ID = #STAGE_ID#,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #SESSION.EP.USERID#, 
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE
		QUIZ_ID = #QUIZ_ID#
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
