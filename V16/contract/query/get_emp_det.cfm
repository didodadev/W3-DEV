<cfquery name="GET_EMP_DET" datasource="#dsn#">
	SELECT 
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME,
			POSITION_CODE,
			EMPLOYEE_ID
	FROM 
		EMPLOYEE_POSITIONS
	WHERE 
		POSITION_CODE IN (#LISTSORT(attributes.EMP,"NUMERIC")#)
	AND
		POSITION_STATUS = 1
</cfquery>
<cfset FULLNAME = "">
<cfloop query="GET_EMP_DET">
		<cfset FULLNAME =  FULLNAME & ',' & "#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#">
</cfloop>


