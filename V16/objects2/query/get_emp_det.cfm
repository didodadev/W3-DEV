<cfquery name="DETAIL_EMP" datasource="#DSN#">
	SELECT 
		EMPLOYEE_NAME,
		COMPANY_ID,
		EMPLOYEE_ID,
		EMPLOYEE_SURNAME,
		EMPLOYEE_EMAIL,
		EMPLOYEE_USERNAME,
		TASK,
		MEMBER_CODE,
<!---		IM,--->
		MOBILTEL,
		DIRECT_TELCODE,
		DIRECT_TEL,
		EXTENSION,
<!---		IMCAT_ID,--->
		MOBILCODE,
		PHOTO,
		PHOTO_SERVER_ID,
        (SELECT IMCAT_ID FROM EMPLOYEES_INSTANT_MESSAGE WHERE EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_INSTANT_MESSAGE.EMPLOYEE_ID) AS IMCAT_ID,
        (SELECT IM_ADDRESS FROM EMPLOYEES_INSTANT_MESSAGE WHERE EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_INSTANT_MESSAGE.EMPLOYEE_ID) AS IM
	FROM
		EMPLOYEES
	WHERE
		EMPLOYEES.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
</cfquery>

<cfquery name="GET_EMP_POS" datasource="#DSN#">
	SELECT 
		POSITION_CODE,
		TITLE_ID,
		DEPARTMENT_ID
	FROM
		EMPLOYEE_POSITIONS
	WHERE 
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#"> AND
		IS_MASTER = 1
</cfquery>
<cfquery name="GET_LANGUAGES" datasource="#DSN#">
	SELECT
		SETUP_LANGUAGE.LANGUAGE_SET
	FROM
		SETUP_LANGUAGE,
		MY_SETTINGS
	WHERE
	    LANGUAGE_SHORT = MY_SETTINGS.LANGUAGE_ID AND 
		MY_SETTINGS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
</cfquery>
