<cfquery name="GET_CLASS_TRAINER_EMP" datasource="#DSN#">
    SELECT
        TRAINING_CLASS.TRAINER_EMP,
        EMPLOYEES.EMPLOYEE_NAME,
        EMPLOYEES.EMPLOYEE_SURNAME
    FROM
        TRAINING_CLASS,
        EMPLOYEES
    WHERE
        TRAINING_CLASS.CLASS_ID = #attributes.CLASS_ID# AND
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
        TRAINING_CLASS.CLASS_ID = #attributes.CLASS_ID# AND
        TRAINING_CLASS.TRAINER_PAR = COMPANY_PARTNER.PARTNER_ID AND
        COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID
</cfquery>
<cfquery name="get_class_trainer_emps" datasource="#dsn#">
    SELECT
        TRAINING_CLASS_TRAINER.EMP_ID,
        EMPLOYEE_NAME,
        EMPLOYEE_SURNAME
    FROM
        TRAINING_CLASS_TRAINER,
        EMPLOYEES
    WHERE
        TRAINING_CLASS_TRAINER.CLASS_ID = #attributes.CLASS_ID# AND
        EMPLOYEE_ID = TRAINING_CLASS_TRAINER.EMP_ID AND
        TRAINING_CLASS_TRAINER.EMP_ID IS NOT NULL
</cfquery>
<cfquery name="get_class_trainer_pars" datasource="#dsn#">
	SELECT
		TRAINING_CLASS_TRAINER.PAR_ID,
		TRAINING_CLASS_TRAINER.COMP_ID,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY.NICKNAME
	FROM
		TRAINING_CLASS_TRAINER,
		COMPANY_PARTNER,
		COMPANY
	WHERE
		TRAINING_CLASS_TRAINER.CLASS_ID = #attributes.CLASS_ID# AND
		COMPANY_PARTNER.PARTNER_ID = TRAINING_CLASS_TRAINER.PAR_ID AND
		COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID AND
		TRAINING_CLASS_TRAINER.PAR_ID IS NOT NULL
</cfquery>
<cfquery name="get_class_trainer_grps" datasource="#dsn#">
	SELECT
		TRAINING_CLASS_TRAINER.GRP_ID,
		USERS.GROUP_NAME
	FROM
		TRAINING_CLASS_TRAINER,
		USERS
	WHERE
		TRAINING_CLASS_TRAINER.CLASS_ID = #attributes.CLASS_ID# AND
		USERS.GROUP_ID = TRAINING_CLASS_TRAINER.GRP_ID AND
		TRAINING_CLASS_TRAINER.GRP_ID IS NOT NULL
</cfquery>

