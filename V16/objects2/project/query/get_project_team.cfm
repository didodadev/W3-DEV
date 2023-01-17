<cfif isdefined('attributes.partner_cat_id') and len(attributes.partner_cat_id)>
	<cfif session.pp.company_category eq attributes.partner_cat_id>
		<cfquery name="GET_PROJECT" datasource="#DSN#">
			SELECT PROJECT_ID FROM WORKGROUP_EMP_PAR WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
		</cfquery>
		<cfif get_project.recordcount>
			<cfset attributes.project_id = get_project.project_id>
		</cfif>
	</cfif>
</cfif>
<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
	<cfquery name="GET_PROJECT_WORKGROUP" datasource="#DSN#" maxrows="1">
		SELECT WORKGROUP_ID FROM WORK_GROUP WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
	</cfquery>
</cfif>
<cfif isdefined('get_project_workgroup') and len(get_project_workgroup.workgroup_id)>
	<cfquery name="GET_EMPS" datasource="#DSN#">
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
			EMPLOYEE_POSITIONS.EMPLOYEE_ID = WORKGROUP_EMP_PAR.EMPLOYEE_ID AND
			WORKGROUP_EMP_PAR.WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_project_workgroup.workgroup_id#">
	</cfquery>
	<cfquery name="GET_PARS" datasource="#DSN#">
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
			COMPANY_PARTNER.COMPANY_PARTNER_STATUS = 1 AND
			WORKGROUP_EMP_PAR.WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_project_workgroup.workgroup_id#">
	</cfquery>
<cfelse>
	<cfset get_emps.recordcount = 0>
	<cfset get_pars.recordcount = 0>
</cfif>
