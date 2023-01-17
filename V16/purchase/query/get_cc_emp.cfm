<cfquery name="GET_CC_EMP" datasource="#dsn#">
	SELECT
		EMPLOYEES.EMPLOYEE_ID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
	FROM 
		EMPLOYEES
	WHERE
		EMPLOYEES.EMPLOYEE_ID IN  (#LISTSORT(attributes.CC_EMPS,"NUMERIC")#)
</cfquery>
<cfset fullname = ''>
<cfloop query="get_cc_emp">
	<cfset fullname = fullname & get_cc_emp.employee_name & ' ' & get_cc_emp.employee_surname & ','>
</cfloop>
<cfif Len(fullname) gt 1>
<cfset fullname = Left(fullname,len(fullname) - 1)>
</cfif>
