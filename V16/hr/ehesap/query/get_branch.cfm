<cfparam name="is_control" default="">

<cfquery name="GET_BRANCH" datasource="#dsn#">
	SELECT 
		BRANCH.*,
		OUR_COMPANY.COMPANY_NAME,
        OUR_COMPANY.NICK_NAME,
		OUR_COMPANY.T_NO,
        OUR_COMPANY.MERSIS_NO,
		OUR_COMPANY.ADDRESS,
		OUR_COMPANY.TEL_CODE,
		OUR_COMPANY.TEL,
		OUR_COMPANY.TAX_NO,
		OUR_COMPANY.TAX_OFFICE
		<cfif isdefined("attributes.department_id")>
		,DEPARTMENT.DEPARTMENT_HEAD
		</cfif>
	FROM 
		<cfif isdefined("attributes.department_id")>
		DEPARTMENT,
		</cfif>
		BRANCH,
		OUR_COMPANY
	WHERE
		OUR_COMPANY.COMP_ID=BRANCH.COMPANY_ID
	<cfif not isdefined("attributes.BRANCH_ID") and (isdefined("attributes.SSK_OFFICE") and len(attributes.SSK_OFFICE))>
		AND
		<cfif database_type is "MSSQL">
			SSK_OFFICE + '-' + SSK_NO + '-' + CONVERT(VARCHAR,BRANCH_ID) = '#attributes.SSK_OFFICE#'
		<cfelseif database_type is "DB2">
			SSK_OFFICE || '-' || SSK_NO|| '-' || CONVERT(VARCHAR,BRANCH_ID) = '#attributes.SSK_OFFICE#'
		</cfif>
	<cfelseif isdefined("attributes.department_id")>
		AND DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
		AND DEPARTMENT.DEPARTMENT_ID = #attributes.department_id#
	<cfelseif isdefined("attributes.branch_id")>
		AND BRANCH.BRANCH_ID IN (#attributes.BRANCH_ID#)
	</cfif>
	<cfif  isdefined("attributes.city_id") and len(attributes.city_id)>
		AND BRANCH.BRANCH_CITY = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.city_id#" >
	</cfif>
	<cfif isdefined("attributes.multi_branch_id") and len(attributes.multi_branch_id)>
		AND BRANCH.BRANCH_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.multi_branch_id#" list="yes"> )
	  </cfif>
	<cfif not session.ep.ehesap or (len(is_control) and is_control eq 2)>
		AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# )
	</cfif>
	ORDER BY BRANCH.BRANCH_NAME
</cfquery>
