<cfquery name="GET_MY_POSITION_CODE" datasource="#dsn#">
	SELECT 
		POSITION_CODE
	FROM 
	    EMPLOYEE_POSITIONS
	WHERE
		EMPLOYEE_ID = #session.ep.userid#
</cfquery>
