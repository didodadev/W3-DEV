<cfquery name="get_rec" dbtype="query">
	SELECT
		BRANCH_ID,
		SUM(EMPLOYEE_COUNT1) AS EMPLOYEE_COUNT1,
		SUM(EMPLOYEE_COUNT2) AS EMPLOYEE_COUNT2,
		SUM(EMPLOYEE_COUNT3) AS EMPLOYEE_COUNT3,
		SUM(EMPLOYEE_COUNT4) AS EMPLOYEE_COUNT4,
		SUM(EMPLOYEE_COUNT5) AS EMPLOYEE_COUNT5,
		SUM(EMPLOYEE_COUNT6) AS EMPLOYEE_COUNT6,
		SUM(EMPLOYEE_COUNT7) AS EMPLOYEE_COUNT7,
		SUM(EMPLOYEE_COUNT8) AS EMPLOYEE_COUNT8,
		SUM(EMPLOYEE_COUNT9) AS EMPLOYEE_COUNT9,
		SUM(EMPLOYEE_COUNT10) AS EMPLOYEE_COUNT10,
		SUM(EMPLOYEE_COUNT11) AS EMPLOYEE_COUNT11,
		SUM(EMPLOYEE_COUNT12) AS EMPLOYEE_COUNT12
	FROM
		get_rec_all
	WHERE
		BRANCH_ID=#BRANCH_ID#
	GROUP BY 
		BRANCH_ID
</cfquery>			
