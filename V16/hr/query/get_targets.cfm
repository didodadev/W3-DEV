<cfif isdefined('attributes.start_date') and len(attributes.start_date)><cf_date tarih='attributes.start_date'></cfif>
<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)><cf_date tarih='attributes.finish_date'></cfif>
<cfif isdefined('attributes.is_sec') and len(attributes.is_sec)>
	<cfquery name="get_targets" datasource="#dsn#">
		SELECT 
				TARGET.TARGET_ID,
				TARGET.OUR_COMPANY_ID,
				TARGET.STARTDATE,
				TARGET.FINISHDATE,
				TARGET.TARGET_HEAD,
				TARGET.TARGET_NUMBER,
				TARGET.TARGETCAT_ID,
				TARGET_CAT.TARGETCAT_NAME,
				TARGET.TARGET_EMP,
				TARGET.RECORD_EMP,
                TARGET.TARGET_WEIGHT
			FROM 
				TARGET,
				TARGET_CAT
			WHERE
				TARGET_CAT.TARGETCAT_ID = TARGET.TARGETCAT_ID	
				<cfif isdefined('attributes.is_sec') and attributes.is_sec eq 1>
				AND TARGET.OUR_COMPANY_ID IS NOT NULL
				<cfelseif isdefined('attributes.is_sec') and attributes.is_sec eq 2>
				AND TARGET.DEPARTMENT_ID IS NOT NULL
				</cfif>
				<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
				AND TARGET.OUR_COMPANY_ID = #attributes.company_id#
				</cfif>
				<cfif isdefined('attributes.department_id') and len(attributes.department_id) and isdefined('attributes.department_name') and len(attributes.department_name)>
				AND TARGET.DEPARTMENT_ID = #attributes.department_id#
				</cfif>
				<cfif isdefined ('attributes.branch_id') and len(attributes.branch_id) and isdefined('attributes.branch_name') and len(attributes.branch_name)>
				AND TARGET.BRANCH_ID=#attributes.branch_id#
				</cfif> 
				<cfif isdefined("attributes.keyword") and len(attributes.keyword)>AND TARGET_HEAD LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI</cfif>
				<cfif isdefined('attributes.targetcat_id') and len(attributes.targetcat_id)>AND TARGET.TARGETCAT_ID = #attributes.targetcat_id#</cfif>
				<cfif isdefined('attributes.start_date') and len(attributes.start_date)>AND STARTDATE >= #attributes.start_date#</cfif>
				<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>AND FINISHDATE <= #attributes.finish_date#</cfif>
			ORDER BY TARGET.STARTDATE DESC
	</cfquery>
<cfelse>
	<cfquery name="GET_TARGETS" datasource="#dsn#">
		SELECT 
			TARGET.TARGET_ID,
			TARGET.POSITION_CODE,
			TARGET.STARTDATE,
			TARGET.FINISHDATE,
			TARGET.TARGET_HEAD,
			TARGET.TARGET_NUMBER,
			TARGET.TARGETCAT_ID,
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_ID,
			TARGET_CAT.TARGETCAT_NAME,
            TARGET.TARGET_EMP,
			TARGET.RECORD_EMP,
            TARGET.TARGET_WEIGHT,
            E.EMPLOYEE_NAME +' '+ E.EMPLOYEE_SURNAME AS TARGET_EMP_NAME
		FROM 
			TARGET
            LEFT JOIN EMPLOYEES E ON E.EMPLOYEE_ID = TARGET.TARGET_EMP,
			TARGET_CAT,
			EMPLOYEE_POSITIONS,
			DEPARTMENT,
			BRANCH,
			OUR_COMPANY
		WHERE
			TARGET.POSITION_CODE IS NOT NULL AND
			TARGET_CAT.TARGETCAT_ID = TARGET.TARGETCAT_ID AND
			EMPLOYEE_POSITIONS.POSITION_CODE = TARGET.POSITION_CODE AND
			EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
			DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
			BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
			<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
			AND OUR_COMPANY.COMP_ID = #attributes.company_id#
			</cfif>
			<cfif isdefined('attributes.department_id') and len(attributes.department_id) and isdefined('attributes.department_name') and len(attributes.department_name)>
			AND DEPARTMENT.DEPARTMENT_ID = #attributes.department_id#
			<cfelseif isdefined('attributes.department_id') and len(attributes.department_id) and not isdefined('attributes.department_name')>
			AND DEPARTMENT.DEPARTMENT_ID = #attributes.department_id#
			</cfif>
			<cfif isdefined ('attributes.branch_id') and len(attributes.branch_id) and isdefined('attributes.branch_name') and len(attributes.branch_name)>
			AND DEPARTMENT.BRANCH_ID=#attributes.branch_id#
			</cfif> 
			<cfif isdefined('attributes.position_cat_id') and len(attributes.position_cat_id)>
			AND EMPLOYEE_POSITIONS.POSITION_CAT_ID = #attributes.position_cat_id#
			</cfif>
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND (TARGET_HEAD LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR E.EMPLOYEE_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI OR E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI)
			</cfif>
			<cfif isdefined('attributes.targetcat_id') and len(attributes.targetcat_id)>AND TARGET.TARGETCAT_ID = #attributes.targetcat_id#</cfif>
			<cfif isdefined('attributes.start_date') and len(attributes.start_date)>AND STARTDATE >= #attributes.start_date#</cfif>
			<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>AND FINISHDATE <= #attributes.finish_date#</cfif>
		ORDER BY TARGET.STARTDATE DESC
	</cfquery>
</cfif>