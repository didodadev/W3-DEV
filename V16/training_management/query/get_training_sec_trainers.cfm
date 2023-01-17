<cfquery name="GET_TRAINING_SEC_TRAINERS_EMPS" datasource="#DSN#">
	SELECT
		TRAINING_SEC_TRAINER.EMP_ID,
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME
	FROM
		TRAINING_SEC_TRAINER,
		EMPLOYEES
	WHERE
		TRAINING_SEC_TRAINER.TRAINING_SEC_ID = #attributes.training_sec_id# AND
		EMPLOYEE_ID = TRAINING_SEC_TRAINER.EMP_ID AND
		TRAINING_SEC_TRAINER.EMP_ID IS NOT NULL
</cfquery>
<cfquery name="GET_TRAINING_SEC_TRAINERS_PARS" datasource="#DSN#">
	SELECT
		TRAINING_SEC_TRAINER.PAR_ID,
		TRAINING_SEC_TRAINER.COMP_ID,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY.NICKNAME
	FROM
		TRAINING_SEC_TRAINER,
		COMPANY_PARTNER,
		COMPANY
	WHERE
		TRAINING_SEC_TRAINER.TRAINING_SEC_ID = #attributes.training_sec_id# AND
		COMPANY_PARTNER.PARTNER_ID = TRAINING_SEC_TRAINER.PAR_ID AND
		COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID AND
		TRAINING_SEC_TRAINER.PAR_ID IS NOT NULL
</cfquery>
<cfquery name="GET_TRAINING_SEC_TRAINERS_GRPS" datasource="#DSN#">
	SELECT
		TRAINING_SEC_TRAINER.GRP_ID,
		USERS.GROUP_NAME
	FROM
		TRAINING_SEC_TRAINER,
		USERS
	WHERE
		TRAINING_SEC_TRAINER.TRAINING_SEC_ID = #attributes.training_sec_id# AND
		USERS.GROUP_ID = TRAINING_SEC_TRAINER.GRP_ID AND
		TRAINING_SEC_TRAINER.GRP_ID IS NOT NULL
</cfquery>

<cfset all_trainer_ids = "">

<cfloop query="get_training_sec_trainers_emps">
	<cfset all_trainer_ids = listappend(all_trainer_ids,"emp-#emp_id#")>
</cfloop>
<cfloop query="get_training_sec_trainers_pars">
	<cfset all_trainer_ids = listappend(all_trainer_ids,"par-#par_id#-#comp_id#")>
</cfloop>
<cfloop query="get_training_sec_trainers_grps">
	<cfset all_trainer_ids = listappend(all_trainer_ids,"grp-#grp_id#")>
</cfloop>
