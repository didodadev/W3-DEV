<cfflush interval="5000">
<cfquery name="GET_HRS" datasource="#DSN#">
	SELECT 
		EMPLOYEES.EMPLOYEE_ID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_EMAIL,
		EMPLOYEES.EMPLOYEE_USERNAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES.EMPLOYEE_NO,
		EMPLOYEES.GROUP_STARTDATE,
		EMPLOYEES.EMPLOYEE_STATUS,
<!---		EMPLOYEES.IMCAT_ID,
		EMPLOYEES.IM,
        EMPLOYEES.IMCAT_ID,
		EMPLOYEES.IM,
		EMPLOYEES.IMCAT2_ID,
		EMPLOYEES.IM2,--->
		EMPLOYEES.MOBILCODE,
		EMPLOYEES.MOBILTEL,
        EMPLOYEES.PHOTO,
        ED.SEX
	FROM 
	<cfif (isDefined("attributes.BRANCH_ID") and len(attributes.BRANCH_ID)) or (isDefined("attributes.position_cat_id") and len(attributes.position_cat_id)) or (isdefined('attributes.title_id') and len(attributes.title_id)) or (isdefined("attributes.department_id") and len(attributes.department_id))>
		EMPLOYEE_POSITIONS,
		DEPARTMENT,
		BRANCH,
	</cfif>
		EMPLOYEES
        LEFT JOIN EMPLOYEES_DETAIL AS ED ON EMPLOYEES.EMPLOYEE_ID = ED.EMPLOYEE_ID
	WHERE
	<cfif isdefined("attributes.emp_status")>
		<cfif attributes.emp_status EQ 1> EMPLOYEES.EMPLOYEE_STATUS = 1
		<cfelseif attributes.emp_status EQ -1> EMPLOYEES.EMPLOYEE_STATUS = 0
		<cfelseif attributes.emp_status EQ 0> ( EMPLOYEES.EMPLOYEE_STATUS = 1 OR EMPLOYEES.EMPLOYEE_STATUS = 0 )
	</cfif>
	<cfelse>
		EMPLOYEES.EMPLOYEE_STATUS=1	
	</cfif>	

	<cfif isdefined("attributes.keyword") and LEN(attributes.keyword)>
		AND
			(
			EMPLOYEES.EMPLOYEE_NO LIKE '%#attributes.keyword#%'
			OR EMPLOYEES.EMPLOYEE_NAME + ' ' + EMPLOYEES.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
			OR EMPLOYEES.EMPLOYEE_NAME LIKE '%#attributes.keyword#%'
			OR EMPLOYEES.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
			OR ('.' + EMPLOYEES.HIERARCHY + '.') LIKE '%.#attributes.keyword#.%'
			)
	</cfif>

	<cfif (isDefined("attributes.BRANCH_ID") and len(attributes.BRANCH_ID)) or (isDefined("attributes.position_cat_id") and len(attributes.position_cat_id)) or (isdefined('attributes.title_id') and len(attributes.title_id)) or(isdefined("attributes.department_id") and len(attributes.department_id))>
		AND EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID
		AND EMPLOYEE_POSITIONS.POSITION_STATUS = 1 
		AND EMPLOYEE_POSITIONS.IS_MASTER = 1
		AND BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
		AND EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID

		<cfif isdefined("attributes.position_cat_id") and len(attributes.position_cat_id)>
			AND EMPLOYEE_POSITIONS.POSITION_CAT_ID = #attributes.position_cat_id#
		</cfif>	

		<cfif isdefined('attributes.title_id') and len(attributes.title_id)>
			AND EMPLOYEE_POSITIONS.TITLE_ID=#attributes.title_id#
		</cfif>
	
		<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
			AND BRANCH.BRANCH_ID = #attributes.branch_id#
		</cfif>
	</cfif>
	ORDER BY
		EMPLOYEES.EMPLOYEE_NAME
</cfquery>