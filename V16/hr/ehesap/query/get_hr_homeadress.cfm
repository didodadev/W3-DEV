<cfquery name="GET_HR_HOMEADRESS" datasource="#dsn#">
	SELECT 
		EMPLOYEES_DETAIL.HOMEADDRESS, 
		EMPLOYEES_DETAIL.HOMECOUNTY, 
		EMPLOYEES_DETAIL.HOMECITY, 
		EMPLOYEES_DETAIL.HOMEPOSTCODE,
		EMPLOYEES_DETAIL.HOMETEL_CODE,
		EMPLOYEES_DETAIL.HOMETEL,
		EMPLOYEES_IDENTY.BIRTH_DATE,
		EMPLOYEES_IDENTY.BIRTH_PLACE,
		EMPLOYEES_IDENTY.CITY,
		EMPLOYEES_IDENTY.FATHER,
		EMPLOYEES_IDENTY.SERIES,
		EMPLOYEES_IDENTY.NUMBER,
		EMPLOYEES.DIRECT_TELCODE,
		EMPLOYEES.DIRECT_TEL,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
	FROM 
		EMPLOYEES,
		EMPLOYEES_IDENTY,
		EMPLOYEES_DETAIL,		
		EMPLOYEE_POSITIONS EP
	WHERE 
	<cfif isdefined("attributes.POSITION_CODE") and len(attributes.POSITION_CODE)>
		EP.POSITION_CODE = #attributes.POSITION_CODE#
		AND
	<cfelseif isdefined("attributes.EMPLOYEE_ID") and len(attributes.EMPLOYEE_ID)>
		EP.EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		AND
	</cfif>
		EMPLOYEES.EMPLOYEE_ID = EP.EMPLOYEE_ID
		AND
		EMPLOYEES_DETAIL.EMPLOYEE_ID = EP.EMPLOYEE_ID
		AND
		EMPLOYEES_IDENTY.EMPLOYEE_ID = EP.EMPLOYEE_ID
</cfquery>
