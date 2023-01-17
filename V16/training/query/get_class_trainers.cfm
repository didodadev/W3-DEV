<cfquery name="get_class_trainer_emps" datasource="#dsn#">
	SELECT
		TRAINING_CLASS_TRAINER.EMP_ID,
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		EMPLOYEE_ID
	FROM
		TRAINING_CLASS_TRAINER,
		EMPLOYEES
	WHERE
		TRAINING_CLASS_TRAINER.CLASS_ID = #attributes.CLASS_ID# AND
		EMPLOYEE_ID = TRAINING_CLASS_TRAINER.EMP_ID AND
		TRAINING_CLASS_TRAINER.EMP_ID IS NOT NULL
	ORDER BY 
    	EMPLOYEE_NAME
</cfquery>
<cfquery name="get_class_trainer_pars" datasource="#dsn#">
	SELECT
		TRAINING_CLASS_TRAINER.PAR_ID,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY.NICKNAME,
		COMPANY.COMPANY_ID,
		COMPANY_PARTNER.PARTNER_ID
	FROM
		TRAINING_CLASS_TRAINER,
		COMPANY_PARTNER,
		COMPANY
	WHERE
		TRAINING_CLASS_TRAINER.CLASS_ID = #attributes.CLASS_ID# AND
		COMPANY_PARTNER.PARTNER_ID = TRAINING_CLASS_TRAINER.PAR_ID AND
		COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID AND
		TRAINING_CLASS_TRAINER.PAR_ID IS NOT NULL
	ORDER BY 
    	COMPANY_PARTNER.COMPANY_PARTNER_NAME
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
	ORDER BY 
    	USERS.GROUP_NAME
</cfquery>

<cfset all_trainer_ids = "">

<cfloop query="get_class_trainer_emps">
	<cfset all_trainer_ids = listappend(all_trainer_ids,"emp-#emp_id#")>
</cfloop>
<cfloop query="get_class_trainer_pars">
	<cfset all_trainer_ids = listappend(all_trainer_ids,"par-#par_id#-#company_id#")>
</cfloop>
<cfloop query="get_class_trainer_grps">
	<cfset all_trainer_ids = listappend(all_trainer_ids,"grp-#grp_id#")>
</cfloop>
