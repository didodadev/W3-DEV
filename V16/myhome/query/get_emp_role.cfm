<cfquery name="GET_EMP_ROLE" datasource="#DSN#">
	SELECT 
		SPR.PROJECT_ROLES 
	FROM 
		WORKGROUP_EMP_PAR WEP,
		SETUP_PROJECT_ROLES SPR 
	WHERE 
		<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
		WEP.COMPANY_ID = #attributes.company_id# AND 
		WEP.COMPANY_ID IS NOT NULL AND
		<cfelse>
		WEP.CONSUMER_ID = #attributes.consumer_id# AND
		WEP.CONSUMER_ID IS NOT NULL AND
		</cfif>
		WEP.POSITION_CODE = #session.ep.position_code# AND
		WEP.OUR_COMPANY_ID = #session.ep.company_id# AND
		SPR.PROJECT_ROLES_ID = WEP.ROLE_ID
</cfquery>
