<cfquery name="GET_POSITION_EMPQUIZ" datasource="#dsn#">
    SELECT 
        QUIZ_ID,
        POSITION_ID
    FROM 
        EMPLOYEE_QUIZ
    WHERE 
        QUIZ_ID = #attributes.QUIZ_ID#
</cfquery>

<cfset new_POSITION_list = ListSort(ListDeleteAt(GET_POSITION_EMPQUIZ.POSITION_ID, ListFind(GET_POSITION_EMPQUIZ.POSITION_ID, attributes.POSITION_ID)),"numeric")>

<cfquery name="DEL_POSITION_EMPQUIZ" datasource="#dsn#">
    UPDATE 
        EMPLOYEE_QUIZ
    SET
        POSITION_ID = ',#new_POSITION_list#,'
    WHERE 
        QUIZ_ID = #attributes.QUIZ_ID#
</cfquery>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

