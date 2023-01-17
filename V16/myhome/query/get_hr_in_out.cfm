<cfset month_day_ = daysinmonth(CREATEDATE(year(now()),month(now()),1))>
<cfset month_start_ = CREATEDATE(year(now()),month(now()),1)>
<cfset month_finish_ = CREATEODBCDATETIME(date_add("d",1,CREATEDATE(year(now()),month(now()),month_day_)))>
<cfquery name="get_in_out_det" datasource="#dsn#">
	SELECT 
		EIO.START_DATE,
		EIO.FINISH_DATE,
		E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME EMP_NAME,
		E.EMPLOYEE_ID,
		B.BRANCH_NAME,
		EP.POSITION_NAME,
		EP.COLLAR_TYPE
	FROM 
		BRANCH B
		JOIN EMPLOYEES_IN_OUT EIO ON EIO.BRANCH_ID = B.BRANCH_ID
		JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
		LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.IS_MASTER = 1 AND E.EMPLOYEE_ID = EP.EMPLOYEE_ID
		LEFT JOIN DEPARTMENT D on EIO.DEPARTMENT_ID = D.DEPARTMENT_ID
	WHERE
		<cfif attributes.in_out_selection eq 1>
			EIO.START_DATE >= #month_start_# AND
			EIO.START_DATE <= #month_finish_#
		<cfelseif attributes.in_out_selection eq 2>
			EIO.FINISH_DATE >= #month_start_# AND
			EIO.FINISH_DATE <= #now()#
		</cfif>
	ORDER BY
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		EIO.START_DATE
</cfquery>


