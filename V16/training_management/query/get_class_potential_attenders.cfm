<cfquery name="get_class_potantial_attenders" datasource="#dsn#">
	SELECT 
		EMPLOYEES.EMPLOYEE_ID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		DEPARTMENT_HEAD,
		POSITION_CAT,
		NICK_NAME,
		EMPLOYEE_POSITIONS.IS_MASTER
	FROM 
		EMPLOYEES,
		EMPLOYEE_POSITIONS,
		DEPARTMENT,
		SETUP_POSITION_CAT,
		BRANCH,
		OUR_COMPANY
	WHERE 
		EMPLOYEES.EMPLOYEE_STATUS = 1
		AND OUR_COMPANY.COMP_ID=BRANCH.COMPANY_ID
		AND BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID 
		AND EMPLOYEES.EMPLOYEE_ID=EMPLOYEE_POSITIONS.EMPLOYEE_ID
		AND EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID
		AND EMPLOYEE_POSITIONS.POSITION_CAT_ID=SETUP_POSITION_CAT.POSITION_CAT_ID
<cfif isdefined("attributes.IS_POTENTIAL") AND attributes.IS_POTENTIAL IS 0>
	<cfif isdefined('relation_list_our_comp_id') and listlen(relation_list_our_comp_id,',')>
		AND OUR_COMPANY.COMP_ID IN (#relation_list_our_comp_id#)
	</cfif>
	<cfif isdefined('relation_list_dep_id') and listlen(relation_list_dep_id,',')>
		AND DEPARTMENT.DEPARTMENT_ID IN (#relation_list_dep_id#)
	</cfif>
	<cfif isdefined('relation_list_branch_id') and listlen(relation_list_branch_id,',')>
		AND BRANCH.BRANCH_ID IN (#relation_list_branch_id#)
	</cfif>
	<cfif isdefined('relation_list_pos_cat_id') and listlen(relation_list_pos_cat_id,',')>
		AND EMPLOYEE_POSITIONS.POSITION_CAT_ID IN (#relation_list_pos_cat_id#)
	</cfif>
	<cfif isdefined('relation_list_func_id') and listlen(relation_list_func_id,',')>
		AND EMPLOYEE_POSITIONS.FUNC_ID IN (#relation_list_func_id#)
	</cfif>
	<cfif isdefined('relation_list_org_step_id') and listlen(relation_list_org_step_id,',')>
		AND EMPLOYEE_POSITIONS.ORGANIZATION_STEP_ID IN (#relation_list_org_step_id#)
	</cfif>
</cfif>
	<cfif isdefined("attributes.comp_id") and len(attributes.comp_id)>
		AND OUR_COMPANY.COMP_ID = #attributes.comp_id#
	</cfif>
	<cfif isdefined("attributes.BRANCH_ID") and len(attributes.BRANCH_ID) and len(trim(attributes.BRANCH))>
		AND BRANCH.BRANCH_ID = #attributes.BRANCH_ID#
	</cfif>
	<cfif isdefined("attributes.func_id") and len(attributes.func_id)>
		AND EMPLOYEE_POSITIONS.FUNC_ID = #attributes.func_id#
	</cfif>
	<cfif isdefined("attributes.collar_type") and len(attributes.collar_type)>
		AND EMPLOYEE_POSITIONS.COLLAR_TYPE = #attributes.collar_type#
	</cfif>
	<cfif isdefined("attributes.organization_step_id") and len(attributes.organization_step_id)>
		AND EMPLOYEE_POSITIONS.ORGANIZATION_STEP_ID = #attributes.organization_step_id#
	</cfif>
	<cfif isdefined("attributes.DEPARTMENT_ID") and len(attributes.DEPARTMENT_ID) and len(trim(attributes.DEPARTMENT))>
		AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = #attributes.DEPARTMENT_ID#
	</cfif>	
	<cfif isdefined("attributes.POSITION_CAT_ID") and len(trim(attributes.POSITION_CAT_ID))>
		AND EMPLOYEE_POSITIONS.POSITION_CAT_ID = #attributes.POSITION_CAT_ID#
	</cfif>
	<cfif isdefined("attributes.keyword") and len(trim(attributes.keyword))>
		AND
		(
			EMPLOYEES.EMPLOYEE_NAME LIKE '%#attributes.keyword#%'
			OR
			EMPLOYEES.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
		)
	</cfif>
	<cfif isdefined("get_emp_att") and get_emp_att.RecordCount>
		AND EMPLOYEES.EMPLOYEE_ID NOT IN (#ListSort(ValueList(get_emp_att.EMP_ID),'numeric')#)
	</cfif>
	ORDER BY
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
</cfquery>

<!--- <cfquery name="get_class_potantial_attenders" datasource="#dsn#">
	SELECT 
		EMPLOYEES.EMPLOYEE_ID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		DEPARTMENT_HEAD,
		POSITION_CAT,
		NICK_NAME
	FROM 
		EMPLOYEES,
		EMPLOYEE_POSITIONS,
		DEPARTMENT,
		SETUP_POSITION_CAT,
		BRANCH,
		OUR_COMPANY
	WHERE 
		EMPLOYEES.EMPLOYEE_STATUS = 1
		AND OUR_COMPANY.COMP_ID=BRANCH.COMPANY_ID
		AND BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID 
		AND EMPLOYEES.EMPLOYEE_ID=EMPLOYEE_POSITIONS.EMPLOYEE_ID
		AND EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID
		AND EMPLOYEE_POSITIONS.POSITION_CAT_ID=SETUP_POSITION_CAT.POSITION_CAT_ID
		<cfif isdefined("attributes.IS_POTENTIAL") AND attributes.IS_POTENTIAL IS 0>
			<cfif IsDefined("attributes.TRAINING_ID") AND Len(Trim(attributes.TRAINING_ID))>
				<cfif ListLen(get_training_poscats_departments.TRAIN_POSITION_CATS)>
				AND
					<cfif ListLen(get_training_poscats_departments.TRAIN_DEPARTMENTS)>
				(
					</cfif>
				EMPLOYEE_POSITIONS.POSITION_CAT_ID IN (#ListSort(get_training_poscats_departments.TRAIN_POSITION_CATS,'numeric')#)
				</cfif>
				<cfif ListLen(get_training_poscats_departments.TRAIN_DEPARTMENTS)>
					<cfif ListLen(get_training_poscats_departments.TRAIN_POSITION_CATS)>
					OR EMPLOYEE_POSITIONS.DEPARTMENT_ID IN (#ListSort(get_training_poscats_departments.TRAIN_DEPARTMENTS,'numeric')#)
				)
					<cfelse>
						AND EMPLOYEE_POSITIONS.DEPARTMENT_ID IN (#listsort(get_training_poscats_departments.TRAIN_DEPARTMENTS,'numeric')#)
					</cfif>
				</cfif>
			<cfelseif isdefined("attributes.TRAINING_ID")>
				AND EMPLOYEES.EMPLOYEE_ID=0
			<cfelse>
			</cfif>
		</cfif>
		<cfif isdefined("attributes.BRANCH_ID") and len(attributes.BRANCH_ID) and len(trim(attributes.BRANCH))>
		AND BRANCH.BRANCH_ID = #attributes.BRANCH_ID#
		</cfif>
		<cfif isdefined("attributes.func_id") and len(attributes.func_id)>
		AND EMPLOYEE_POSITIONS.FUNC_ID = #attributes.func_id#
		</cfif>
		<cfif isdefined("attributes.collar_type") and len(attributes.collar_type)>
		AND EMPLOYEE_POSITIONS.COLLAR_TYPE = #attributes.collar_type#
		</cfif>
		<cfif isdefined("attributes.organization_step_id") and len(attributes.organization_step_id)>
		AND EMPLOYEE_POSITIONS.ORGANIZATION_STEP_ID = #attributes.organization_step_id#
		</cfif>
		<cfif isdefined("attributes.DEPARTMENT_ID") and len(attributes.DEPARTMENT_ID) and len(trim(attributes.DEPARTMENT))>
		AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = #attributes.DEPARTMENT_ID#
		</cfif>	
		<cfif isdefined("attributes.POSITION_CAT_ID") and len(trim(attributes.POSITION_CAT_ID))>
		AND EMPLOYEE_POSITIONS.POSITION_CAT_ID = #attributes.POSITION_CAT_ID#
		</cfif>
		<cfif isdefined("attributes.keyword") and len(trim(attributes.keyword))>
		AND
		(
			EMPLOYEES.EMPLOYEE_NAME LIKE '%#attributes.keyword#%'
			OR
			EMPLOYEES.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
		)
		</cfif>
		<cfif isdefined("get_emp_att") and get_emp_att.RecordCount>
		AND EMPLOYEES.EMPLOYEE_ID NOT IN (#ListSort(ValueList(get_emp_att.EMP_ID),'numeric')#)
		</cfif>
	ORDER BY
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
</cfquery> --->


