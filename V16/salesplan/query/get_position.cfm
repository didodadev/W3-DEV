<cfquery name="GET_POSITION" datasource="#dsn#">
	SELECT
		EMPLOYEE_POSITIONS.POSITION_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
		EMPLOYEE_POSITIONS.DEPARTMENT_ID,
		EMPLOYEES.EMPLOYEE_EMAIL,
		EMPLOYEE_POSITIONS.EMPLOYEE_ID,
		EMPLOYEE_POSITIONS.POSITION_CODE		
	FROM
		EMPLOYEE_POSITIONS,
		EMPLOYEES
	WHERE
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID
		AND
		EMPLOYEE_POSITIONS.POSITION_STATUS = 1
	<cfif isDefined("attributes.EMPLOYEE_ID") and len(attributes.EMPLOYEE_ID)>
		AND
		EMPLOYEES.EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
	</cfif>
	<cfif isDefined("attributes.POSITION_CODE") and len(attributes.POSITION_CODE)>
		AND
		EMPLOYEE_POSITIONS.POSITION_CODE = #attributes.POSITION_CODE#
	</cfif>
</cfquery>
