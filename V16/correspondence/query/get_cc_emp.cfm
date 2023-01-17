<cfquery name="GET_CC_EMP" datasource="#DSN#">
	SELECT
		EMPLOYEE_ID,
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		EMPLOYEE_EMAIL
	FROM 
		EMPLOYEES
	WHERE
		EMPLOYEES.EMPLOYEE_ID IN  (#ListSort(attributes.cc_emps,"NUMERIC")#)
</cfquery>

<cfset cc_id = "">
<cfloop query="get_cc_emp">
   <cfif len(employee_email)>
	   <cfset cc_id = '#employee_email#,'>
   </cfif>
</cfloop>

<cfif len(cc_id)>
	<cfset cc_id = Left(cc_id,(Len(cc_id) -1))>
</cfif>

<cfset get_cc_emp_fullname = "">
<cfoutput query="get_cc_emp">
	<cfset get_cc_emp_fullname = get_cc_emp_fullname & "," & employee_name & " " & employee_surname>
</cfoutput>	
