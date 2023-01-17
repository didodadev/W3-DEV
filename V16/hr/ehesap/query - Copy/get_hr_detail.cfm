<cfquery name="GET_HR_DETAIL" datasource="#dsn#">
	SELECT 
		ED.*,
		EIO.SOCIALSECURITY_NO,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		EI.BIRTH_DATE,
		EI.BIRTH_PLACE,
		EI.FATHER,
		EI.MOTHER
	FROM 
		EMPLOYEES_DETAIL ED,
		EMPLOYEES_IN_OUT EIO,
		EMPLOYEES E,
		EMPLOYEES_IDENTY EI
	WHERE 
		ED.EMPLOYEE_ID=#attributes.EMPLOYEE_ID#
		AND ED.EMPLOYEE_ID = EIO.EMPLOYEE_ID
		AND E.EMPLOYEE_ID = ED.EMPLOYEE_ID
		AND EI.EMPLOYEE_ID = ED.EMPLOYEE_ID
</cfquery>