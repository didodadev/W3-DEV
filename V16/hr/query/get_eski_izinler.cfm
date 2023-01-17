<cfquery name="get_eski_izinler" datasource="#DSN#">
	SELECT 
		EP.*,
		B.BRANCH_NAME,
		O.NICK_NAME
	FROM 
		EMPLOYEE_PROGRESS_PAYMENT EP,
		BRANCH B,
		OUR_COMPANY O
	WHERE
		EP.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
		EP.BRANCH_ID = B.BRANCH_ID AND
		EP.COMP_ID = O.COMP_ID
	ORDER BY STARTDATE
</cfquery>