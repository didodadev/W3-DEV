<cfquery name="GET_EMP_DETAIL" datasource="#dsn#">
	SELECT
		E.EMPLOYEE_USERNAME,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.EMPLOYEE_EMAIL,
		E.MOBILCODE,
		E.MOBILTEL,
		ST.TITLE
	FROM
		EMPLOYEES E,
		EMPLOYEE_POSITIONS EP,
		SETUP_TITLE ST
	WHERE
		<cfif isdefined("emp_id") and len(emp_id)>
			EP.EMPLOYEE_ID=#emp_id# AND
		</cfif>
		<cfif isdefined("employee_id_list") and len(employee_id_list)>
			EP.EMPLOYEE_ID IN (#employee_id_list#) AND
		</cfif>
		EP.EMPLOYEE_ID=E.EMPLOYEE_ID AND
		EP.TITLE_ID=ST.TITLE_ID
</cfquery>
