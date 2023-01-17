<cfquery name="GET_EMPLOYEE_PRIZES" datasource="#dsn#">
	SELECT 
		EP.*
 	FROM
		EMPLOYEES_PRIZE EP
	WHERE 
		EP.PRIZE_TO = #session.ep.userid#
</cfquery>
