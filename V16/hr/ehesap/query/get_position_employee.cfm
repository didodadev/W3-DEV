<cfquery name="GET_POSITION_EMPLOYEE" datasource="#dsn#">
		SELECT 
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME
		FROM 
			EMPLOYEE_POSITIONS EP,
			EMPLOYEES E
		WHERE
			EP.POSITION_CODE = #attributes.POSITION_CODE#
			AND
			EP.EMPLOYEE_ID = E.EMPLOYEE_ID
</cfquery>
