<cfquery name="GET_CC_EMP" datasource="#dsn#">
	SELECT
		EMPLOYEES.EMPLOYEE_ID,
		<cfif database_type eq "MSSQL">
			EMPLOYEES.EMPLOYEE_NAME + " " + EMPLOYEES.EMPLOYEE_SURNAME AS FULLNAME,
		<cfelseif database_type eq "DB'">
			EMPLOYEES.EMPLOYEE_NAME || " " || EMPLOYEES.EMPLOYEE_SURNAME AS FULLNAME,
		</cfif>
		EMPLOYEE_EMAIL
	FROM 
		EMPLOYEES
	WHERE
		EMPLOYEES.EMPLOYEE_ID IN  (#LISTSORT(attributes.CC_EMPS,"NUMERIC")#)
</cfquery>
<cfset cc_id = "">
<cfloop query="GET_CC_EMP">
<cfif len(EMPLOYEE_EMAIL)>
	<cfset cc_id = '#EMPLOYEE_EMAIL#,'>
</cfif>
</cfloop>
	<cfif len(cc_id)>
	<cfset cc_id = #Left(cc_id,(Len(cc_id) -1))# >
</cfif>	
