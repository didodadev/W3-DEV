<!--- get_emp_work_start_info.cfm --->

<!--- IC20050926...buraya bakilmali... kendini include atmiyor mu? --->

<!--- calisan varsa onun ise baslama bilgileri aliniyor --->
<cfif not  LEN(employee) and not LEN(employee_id)>
	<cfset str_emp_id=attributes.employee_id>
	<cfinclude template="get_emp_work_start_info.cfm">
</cfif>
<!--- calisan varsa onun ise baslama bilgileri alindi --->



<cfquery name="get_emp_start" datasource="#DSN#">
	SELECT
		B.BRANCH_ID,
		B.COMPANY_ID,
		D.DEPARTMENT_ID,
		ES.START_DATE
	FROM
		BRANCH B,
		DEPARTMENT D,
		EMPLOYEE_POSITIONS EP,
		EMPLOYEES_SSK ES
	WHERE
		ES.EMPLOYEE_ID=EP.EMPLOYEE_ID
		AND B.BRANCH_ID=D.BRANCH_ID
		AND EP.DEPARTMENT_ID=D.DEPARTMENT_ID
		AND EP.EMPLOYEE_ID=#str_emp_id#
</cfquery>

<cfset attributes.emp_start_date=dateformat(get_emp_start.START_DATE,dateformat_style)>
<cf_date tarih='attributes.emp_start_date'>
<cfset emp_comp_id=get_emp_start.COMPANY_ID>


<cfquery name="get_dep_comp" datasource="#DSN#">
	SELECT
		B.BRANCH_ID,
		B.COMPANY_ID
	FROM
		BRANCH B,
		DEPARTMENT D
	WHERE
		B.BRANCH_ID=D.BRANCH_ID
		AND D.DEPARTMENT_ID=#attributes.department_id#
</cfquery>
<cfif get_dep_comp.COMPANY_ID neq emp_comp_id >
	<cfquery name="upd_essk" datasource="#DSN#">
		UPDATE
			EMPLOYEES_SSK
		SET
			OLD_COMPANY_START_DATE =#attributes.emp_start_date#,
			START_DATE=#NOW()#
		WHERE
			EMPLOYEE_ID=#str_emp_id#
	</cfquery>
</cfif>
