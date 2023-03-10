<cfquery name="GET_CLASS_TRAINER_EMP" datasource="#DSN#">
	SELECT
		TRAINING_CLASS.TRAINER_EMP,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
	FROM
		TRAINING_CLASS,
		EMPLOYEES
	WHERE
		TRAINING_CLASS.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#"> AND 
        TRAINING_CLASS.TRAINER_EMP = EMPLOYEES.EMPLOYEE_ID
</cfquery>

<cfquery name="GET_CLASS_TRAINER_PAR" datasource="#DSN#">
	SELECT
		TRAINING_CLASS.TRAINER_PAR,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY.NICKNAME
	FROM
		TRAINING_CLASS,
		COMPANY_PARTNER,
		COMPANY
	WHERE
		TRAINING_CLASS.CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#"> AND 
        TRAINING_CLASS.TRAINER_PAR = COMPANY_PARTNER.PARTNER_ID AND 
        COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID
</cfquery>
