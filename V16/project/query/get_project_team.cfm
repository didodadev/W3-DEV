<cfquery name="get_emps" datasource="#DSN#">
  SELECT 
	EMPLOYEE_POSITIONS.EMPLOYEE_ID,
	EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
	EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
	WORKGROUP_EMP_PAR.ROLE_ID
 FROM 
	EMPLOYEE_POSITIONS,
	WORKGROUP_EMP_PAR
 WHERE 
	EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND
	EMPLOYEE_POSITIONS.POSITION_CODE = WORKGROUP_EMP_PAR.POSITION_CODE AND
	<cfif isdefined('attributes.station_id')>
		WORKGROUP_EMP_PAR.STATION_ID = #attributes.station_id#
	<cfelse>
		WORKGROUP_EMP_PAR.PROJECT_ID = #attributes.id#
	</cfif>
</cfquery>
<cfquery name="get_pars" datasource="#DSN#">
	SELECT 
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY_PARTNER.COMPANY_ID,
		COMPANY_PARTNER.PARTNER_ID,
		COMPANY.NICKNAME,
		WORKGROUP_EMP_PAR.ROLE_ID
	FROM 
		COMPANY_PARTNER,
		COMPANY,
		WORKGROUP_EMP_PAR
	 WHERE 
		COMPANY_PARTNER.PARTNER_ID = WORKGROUP_EMP_PAR.PARTNER_ID AND
		COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
		<cfif isdefined('attributes.station_id')>
			WORKGROUP_EMP_PAR.STATION_ID = #attributes.station_id#
		<cfelse>
			WORKGROUP_EMP_PAR.PROJECT_ID = #attributes.ID#
		</cfif>
</cfquery> 
