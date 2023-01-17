<cfquery name="get_class" datasource="#dsn#">
	SELECT
		*
	FROM
		TRAINING_CLASS
	WHERE
		CLASS_ID IS NOT NULL
	<cfif isDefined("attributes.action_id") and len(attributes.action_id)>
		AND CLASS_ID = #attributes.action_id#
	</cfif>
</cfquery>
<cfif LEN(get_class.__TRAINER_EMP)>
	<cfset attributes.EMPLOYEE_ID=get_class.__TRAINER_EMP>
	<cfquery name="GET_EMPLOYEE" datasource="#dsn#">
		SELECT 
			EMPLOYEES.EMPLOYEE_ID,
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME,
			EMPLOYEE_POSITIONS.DEPARTMENT_ID,
			EMPLOYEE_POSITIONS.POSITION_NAME,		
			D.DEPARTMENT_HEAD,
			EMPLOYEES.EMPLOYEE_EMAIL
		FROM 
			EMPLOYEES ,
			EMPLOYEE_POSITIONS,
			DEPARTMENT D
		WHERE 
			EMPLOYEE_POSITIONS.DEPARTMENT_ID=D.DEPARTMENT_ID  AND
			EMPLOYEES.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
			EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID
		ORDER BY 
			EMPLOYEES.EMPLOYEE_NAME
	</cfquery>
	<cfset email_value = GET_EMPLOYEE.EMPLOYEE_EMAIL>
<cfelseif LEN(get_class.__TRAINER_PAR)>
	<cfset attributes.PARTNER_ID = get_class.__TRAINER_PAR>
	<cfquery name="GET_PARTNER" datasource="#dsn#">
		SELECT 
			CP.PARTNER_ID,	
			CP.COMPANY_PARTNER_NAME,
			CP.COMPANY_PARTNER_SURNAME,
			CP.COMPANY_ID,
			C.FULLNAME,
			C.COMPANY_ID,
			CP.COMPANY_PARTNER_EMAIL
		FROM 
			COMPANY_PARTNER AS CP,
			COMPANY AS C
		WHERE
			CP.PARTNER_ID = #attributes.PARTNER_ID#
		AND
			C.COMPANY_ID=CP.COMPANY_ID
	</cfquery>
	<cfset email_value = GET_PARTNER.COMPANY_PARTNER_EMAIL>
<cfelse>
	<cfset email_value = "">
</cfif> 
<form name="mail_list">
		<input name="mails" id="mails" type="hidden" value="<cfoutput>#email_value#</cfoutput>">
</form>	  
