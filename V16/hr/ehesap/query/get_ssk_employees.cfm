<cfquery name="GET_SSK_EMPLOYEES" datasource="#DSN#">
	SELECT
		EMPLOYEES_IN_OUT.SHIFT_ID,
		EMPLOYEES_IN_OUT.IS_PUANTAJ_OFF,
		EMPLOYEES_IN_OUT.IN_OUT_ID,
		EMPLOYEES_IN_OUT.EMPLOYEE_ID,
		EMPLOYEES_IN_OUT.POSITION_CODE,
		EMPLOYEES_IN_OUT.FINISH_DATE,
		EMPLOYEES_IN_OUT.VALID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES_IN_OUT.SOCIALSECURITY_NO,
		EMPLOYEES_IN_OUT.PUANTAJ_GROUP_IDS,
		SSK_STATUTE,
		BRANCH.BRANCH_ID
	FROM 
		EMPLOYEES_IN_OUT
		<cfif isDefined("attributes.statue_type_individual") and attributes.statue_type_individual neq 0>
			INNER JOIN SALARYPARAM_PAY SP ON SP.IN_OUT_ID = EMPLOYEES_IN_OUT.IN_OUT_ID
		</cfif>,
		BRANCH,
		EMPLOYEES
	WHERE
	<cfif isdefined("attributes.action_type") and (attributes.action_type is "puantaj_aktarim_personal")>
		EMPLOYEES_IN_OUT.POSITION_CODE = #attributes.POSITION_CODE# AND
	</cfif>
		BRANCH.BRANCH_STATUS = 1 AND
		BRANCH.BRANCH_ID = #attributes.SSK_OFFICE# AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
	<cfif not session.ep.ehesap>
		AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# )
	</cfif>
	<cfif isdefined("hierarchy_emp_list") and len(hierarchy_emp_list)>
		AND EMPLOYEES.EMPLOYEE_ID IN(#hierarchy_emp_list#)
	</cfif>
		<cfif (isdefined("get_program_parameters.FIRST_DAY_MONTH") and len(get_program_parameters.FIRST_DAY_MONTH) and not(get_program_parameters.FIRST_DAY_MONTH eq 1 and get_program_parameters.LAST_DAY_MONTH eq 0)) >
			AND EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam CFSQLType = "cf_sql_timestamp" value = "#finish_date_new#">
			AND
			(
				(EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam CFSQLType = "cf_sql_timestamp" value = "#start_date_new#">) OR EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
			)
		<cfelse>
			AND EMPLOYEES_IN_OUT.START_DATE <= #CREATEDATE(attributes.sal_year,attributes.SAL_MON,DAYSINMONTH(CREATEDATE(attributes.sal_year,attributes.SAL_MON,1)))#
			AND
			(
				(EMPLOYEES_IN_OUT.FINISH_DATE >= #CREATEDATE(attributes.sal_year,attributes.SAL_MON,1)#) OR EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
			)
		</cfif>
		AND BRANCH.BRANCH_ID = EMPLOYEES_IN_OUT.BRANCH_ID
		<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)>
			AND EMPLOYEES.EMPLOYEE_ID =  #attributes.employee_id#
		</cfif>
		<cfif isdefined("attributes.in_out_id") and len(attributes.in_out_id)>
			AND EMPLOYEES_IN_OUT.IN_OUT_ID = #attributes.in_out_id#
		</cfif>
		<cfif isdefined("from_ajax_view_puantaj") and len(from_ajax_view_puantaj)>
			AND ISNULL(EMPLOYEES_IN_OUT.IS_PUANTAJ_OFF,0) <> 1
		</cfif>
		<cfif isdefined("attributes.ssk_statue") and len(attributes.ssk_statue)>
			AND EMPLOYEES_IN_OUT.USE_SSK = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ssk_statue#">
			<cfif isdefined("attributes.statue_type") and attributes.statue_type eq 5 and IsDefined("start_date_new") and len(start_date_new)>
				AND EMPLOYEES_IN_OUT.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#start_date_new#">
			</cfif>
        </cfif>
		<cfif isdefined("attributes.ssk_statue") and len(attributes.ssk_statue) AND isdefined("attributes.statue_type") AND attributes.statue_type eq 6>
			AND EMPLOYEES_IN_OUT.JURY_MEMBERSHIP = <cfqueryparam CFSQLType = "cf_sql_bit" value = "1">
		</cfif>
		<cfif isdefined("attributes.ssk_statue") and len(attributes.ssk_statue) AND isdefined("attributes.statue_type") AND attributes.statue_type eq 7>
			AND ISNULL(EMPLOYEES_IN_OUT.LAND_COMPENSATION_SCORE,0) <> <cfqueryparam CFSQLType = "cf_sql_bit" value = "0">
		</cfif>
		<cfif isdefined("attributes.ssk_statue") and len(attributes.ssk_statue) and attributes.ssk_statue eq 2 and attributes.statue_type eq 8>
			AND ADMINISTRATIVE_ACADEMIC = <cfqueryparam CFSQLType = "cf_sql_integer" value = "3">
		<cfelseif isdefined("attributes.ssk_statue") and len(attributes.ssk_statue) and attributes.ssk_statue eq 2>
			AND ISNULL(ADMINISTRATIVE_ACADEMIC,0) <> <cfqueryparam CFSQLType = "cf_sql_integer" value = "3">
		</cfif>
		<cfif isdefined("attributes.ssk_statue") and len(attributes.ssk_statue) AND isdefined("attributes.statue_type") AND attributes.statue_type eq 10 and isdefined("attributes.statue_type_individual") and attributes.statue_type_individual neq 0>
			AND SP.COMMENT_PAY_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.statue_type_individual#">
		</cfif>
	ORDER BY
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES_IN_OUT.IN_OUT_ID ASC
</cfquery>

