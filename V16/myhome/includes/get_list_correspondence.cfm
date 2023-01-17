<cfquery name="get_list_correspondence" datasource="#dsn#">
	SELECT 
		CORRESPONDENCE.*,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES.EMPLOYEE_ID
	FROM 
		CORRESPONDENCE,
		EMPLOYEES
	WHERE
		YEAR(CORRESPONDENCE.RECORD_DATE) = #session.ep.period_year# AND
		EMPLOYEES.EMPLOYEE_ID = #SESSION.EP.USERID# AND
		( TO_EMP LIKE '%,#session.ep.userid#,%' OR CC_EMP LIKE '%,#session.ep.userid#,%' ) AND
		(
			(
				CORRESPONDENCE.RECORD_DATE < #DATEADD("D",1,now())# AND
				CORRESPONDENCE.RECORD_DATE > #DATEADD("D",-1,now())#
			)
			OR CORRESPONDENCE.RECORD_DATE <= #DATEADD("D",-1,now())#
		) AND
		CORRESPONDENCE.IS_READ <> 1
	ORDER BY
		CORRESPONDENCE.COR_STARTDATE DESC
</cfquery>
