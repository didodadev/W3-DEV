<cfif isdefined("attributes.pos_code") and len(attributes.pos_code)>
	<cfquery name="get_emp_id" datasource="#dsn#">	
		SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #attributes.pos_code#
	</cfquery>
	<cfparam name="attributes.emp_id" default="#get_emp_id.employee_id#">
</cfif>
<cfquery name="DETAIL_EMP" datasource="#DSN#">
	SELECT
		EMPLOYEES.EMPLOYEE_ID,
		EMPLOYEE_NAME,
		COMPANY_ID,
		EMPLOYEE_SURNAME,
		EMPLOYEE_EMAIL,
		EMPLOYEE_USERNAME,
		TASK,
		SEX,
		MEMBER_CODE,
		MOBILTEL,
		DIRECT_TELCODE,
		DIRECT_TEL,
		EXTENSION,
		MOBILCODE,
        CORBUS_TEL,
		PHOTO,
		PHOTO_SERVER_ID,
        (SELECT TOP 1 IMCAT_ID FROM EMPLOYEES_INSTANT_MESSAGE WHERE EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_INSTANT_MESSAGE.EMPLOYEE_ID) AS IMCAT_ID,
        (SELECT TOP 1 IM_ADDRESS FROM EMPLOYEES_INSTANT_MESSAGE WHERE EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_INSTANT_MESSAGE.EMPLOYEE_ID) AS IM
	FROM
		EMPLOYEES
	LEFT JOIN 
		EMPLOYEES_DETAIL
	ON 
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_DETAIL.EMPLOYEE_ID
	WHERE
		<cfif isdefined("attributes.pos_code") and len(attributes.pos_code)>
			EMPLOYEES.EMPLOYEE_ID = #get_emp_id.employee_id#
		<cfelse>
			EMPLOYEES.EMPLOYEE_ID = #attributes.emp_id#
		</cfif>
</cfquery>
<cfquery name="GET_EMP_POS" datasource="#DSN#">
	SELECT 
		POSITION_CODE,
		TITLE_ID,
		DEPARTMENT_ID
	FROM
		EMPLOYEE_POSITIONS
	WHERE 
		<cfif isdefined("attributes.pos_code") and len(attributes.pos_code)>
			EMPLOYEE_ID = #get_emp_id.employee_id# AND
		<cfelse>
			EMPLOYEE_ID = #attributes.emp_id# AND
		</cfif>
		IS_MASTER = 1
</cfquery>
<cfquery name="GET_LANGUAGES" datasource="#DSN#">
	SELECT
		SETUP_LANGUAGE.*
	FROM
		SETUP_LANGUAGE,
		MY_SETTINGS
	WHERE
	    LANGUAGE_SHORT = MY_SETTINGS.LANGUAGE_ID AND 
		<cfif isdefined("attributes.pos_code") and len(attributes.pos_code)>
			MY_SETTINGS.EMPLOYEE_ID = #get_emp_id.employee_id#
		<cfelse>
			MY_SETTINGS.EMPLOYEE_ID = #attributes.emp_id#
		</cfif>
</cfquery>
