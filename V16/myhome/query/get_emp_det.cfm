<cfquery name="GET_EMP_DET" datasource="#dsn#">
	SELECT 
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		POSITION_CODE
	FROM 
		EMPLOYEE_POSITIONS
	WHERE
		<cfif isDefined("attributes.POSITION_CODE")>
		POSITION_CODE = #attributes.POSITION_CODE#
		<cfelse>
		 POSITION_CODE IN (#LISTSORT(attributes.EMP,"NUMERIC")#)
	AND
		POSITION_STATUS = 1
		</cfif>
</cfquery>
