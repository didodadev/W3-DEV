<cfquery name="GET_EMP_ROLE" datasource="#DSN#">
	SELECT 
		SPR.PROJECT_ROLES 
	FROM 
		WORKGROUP_EMP_PAR WEP,
		SETUP_PROJECT_ROLES SPR 
	WHERE 
		WEP.COMPANY_ID IS NOT NULL AND
		WEP.COMPANY_ID = #attributes.company_id# AND 
		WEP.POSITION_CODE = #session.ep.position_code# AND
		WEP.OUR_COMPANY_ID = #session.ep.company_id# AND
		SPR.PROJECT_ROLES_ID = WEP.ROLE_ID
</cfquery>
