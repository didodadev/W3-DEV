<cfquery name="GET_EMPLOYEE_CAUTIONS" datasource="#dsn#">
	SELECT 
		EC.*
 	FROM
		EMPLOYEES_CAUTION EC
	WHERE 
		EC.CAUTION_TO = #session.ep.userid#
</cfquery>
