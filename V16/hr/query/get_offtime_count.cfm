<cfquery name="GET_OFFTIME_COUNT" datasource="#DSN#">
	SELECT 
		COUNT(EMPLOYEE_ID) AS TOPLAM
	FROM 
		OFFTIME
	WHERE
		VALID=1
		AND
		#NOW()# BETWEEN STARTDATE AND FINISHDATE
</cfquery>
