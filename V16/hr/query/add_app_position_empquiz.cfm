<cfquery name="GET_POSITION_EMPQUIZ" datasource="#dsn#">
	SELECT 
		QUIZ_ID,
		APP_POSITION_ID
	FROM 
		EMPLOYEE_QUIZ
	WHERE 
		QUIZ_ID = #attributes.QUIZ_ID#
</cfquery>
<cfif isdefined('attributes.POSITION_ID') and ListContains(GET_POSITION_EMPQUIZ.APP_POSITION_ID, attributes.POSITION_ID) eq 0>
	<cfset new_POSITION_list = ListSort(ListAppend(GET_POSITION_EMPQUIZ.APP_POSITION_ID, attributes.POSITION_ID),"numeric")>
	<cfquery name="UPD_POSITION_EMPQUIZ" datasource="#dsn#">
		UPDATE 
			EMPLOYEE_QUIZ
		SET
			APP_POSITION_ID = ',#new_POSITION_list#,'
		WHERE 
			QUIZ_ID = #attributes.QUIZ_ID#
	</cfquery>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
