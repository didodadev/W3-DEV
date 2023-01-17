<cfquery name="GET_POSITION_EMPQUIZ" datasource="#dsn#">
SELECT 
	QUIZ_ID,
	EMPAPP_ID,
	APP_POS_ID
FROM 
	EMPLOYEE_QUIZ
WHERE 
    QUIZ_ID = #attributes.QUIZ_ID#
</cfquery>

<cfif ListContains(GET_POSITION_EMPQUIZ.EMPAPP_ID, attributes.EMPAPP_ID) eq 0>
	<cfset new_EMPAPP_list = ListSort(ListAppend(GET_POSITION_EMPQUIZ.EMPAPP_ID, attributes.EMPAPP_ID),"numeric")>
	<cfquery name="UPD_POSITION_EMPQUIZ" datasource="#dsn#">
	UPDATE 
		EMPLOYEE_QUIZ
	SET
		EMPAPP_ID = ',#new_EMPAPP_list#,'
	WHERE 
		QUIZ_ID = #attributes.QUIZ_ID#
	</cfquery>
</cfif>

<cfif ListContains(GET_POSITION_EMPQUIZ.APP_POS_ID, attributes.APP_POS_ID) eq 0>
	<cfset new_APP_POS_list = ListSort(ListAppend(GET_POSITION_EMPQUIZ.APP_POS_ID, attributes.APP_POS_ID),"numeric")>
	<cfquery name="UPD_POSITION_EMPQUIZ" datasource="#dsn#">
	UPDATE 
		EMPLOYEE_QUIZ
	SET
		APP_POS_ID = ',#new_APP_POS_list#,'
	WHERE 
		QUIZ_ID = #attributes.QUIZ_ID#
	</cfquery>
</cfif>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

