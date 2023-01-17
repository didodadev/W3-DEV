<cfquery name="GET_EMPLOYEE_NAME" datasource="#dsn#">
	SELECT 
		EMPLOYEE_ID,
		EMPLOYEE_NAME ,
		EMPLOYEE_SURNAME 
	FROM 
		EMPLOYEES		
	WHERE 
		<cfif isdefined("attributes.employee_id")>
		EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		<cfelse>
		EMPLOYEE_ID IN (#LISTSORT(attributes.EMP_IDS,"NUMERIC")#)
		</cfif>
</cfquery>
