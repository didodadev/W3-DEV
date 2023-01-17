<cfquery name="GET_TO_EMP" datasource="#DSN#">
	SELECT
		EMPLOYEE_ID,
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		EMPLOYEE_EMAIL
	FROM 
		EMPLOYEES
	WHERE
		EMPLOYEES.EMPLOYEE_ID  IN  (#ListSort(attributes.to_emps,"NUMERIC")#)
</cfquery>
<cfset to_id = "">
<cfloop query="get_to_emp">
   <cfif len(employee_email)>
	   <cfset to_id = '#employee_email#,'>
   </cfif>
</cfloop>
<cfif len(to_id)>
     <cfset to_id = Left(to_id,(Len(to_id) -1))>
</cfif>
<cfset get_to_emp_fullname = "">
<cfoutput query="get_to_emp">
       <cfset get_to_emp_fullname = get_to_emp_fullname & "," & employee_name & " " & employee_surname>
</cfoutput>

