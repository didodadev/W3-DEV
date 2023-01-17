<cfset all_trainer_ids = "">
<cfif isdefined("attributes.employee_ids") and len(listsort(attributes.employee_ids,"numeric"))>
	<cfquery name="get_class_trainer_emps" datasource="#dsn#">
		SELECT
			TRAINING_EX_CLASS_TRAINER.EMP_ID,
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME
		FROM
			TRAINING_EX_CLASS_TRAINER,
			EMPLOYEES
		WHERE
			TRAINING_EX_CLASS_TRAINER.EX_CLASS_ID = #attributes.EX_CLASS_ID#
			AND TRAINING_EX_CLASS_TRAINER.EMP_ID IN (#LISTSORT(attributes.EMPLOYEE_IDS,"NUMERIC")#)
			AND EMPLOYEE_ID = TRAINING_EX_CLASS_TRAINER.EMP_ID
			AND TRAINING_EX_CLASS_TRAINER.EMP_ID IS NOT NULL
		ORDER BY EMPLOYEE_NAME
	</cfquery>
	<cfloop query="get_class_trainer_emps">
		<cfset all_trainer_ids = listappend(all_trainer_ids,"emp-#emp_id#")>
	</cfloop>
</cfif>
<cfif isDefined("attributes.PARTNER_IDS") and len(LISTSORT(attributes.PARTNER_IDS,"NUMERIC"))>
	<cfquery name="get_class_trainer_pars" datasource="#dsn#">
		SELECT
			COMPANY_PARTNER.COMPANY_PARTNER_NAME,
			COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
			COMPANY_PARTNER.PARTNER_ID,
			COMPANY.NICKNAME,
			COMPANY.COMPANY_ID
		FROM
		    TRAINING_EX_CLASS_TRAINER,
			COMPANY_PARTNER,
			COMPANY
		WHERE
			TRAINING_EX_CLASS_TRAINER.PAR_ID IN (#LISTSORT(attributes.PARTNER_IDS,"NUMERIC")#)
			AND COMPANY_PARTNER.PARTNER_ID = TRAINING_EX_CLASS_TRAINER.PAR_ID
			AND COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID
			AND TRAINING_EX_CLASS_TRAINER.PAR_ID IS NOT NULL
		ORDER BY COMPANY_PARTNER.COMPANY_PARTNER_NAME
	</cfquery>
	<cfloop query="get_class_trainer_pars">
		<cfset all_trainer_ids = listappend(all_trainer_ids,"par-#PARTNER_ID#-#COMPANY_ID#")>
	</cfloop>
</cfif>
