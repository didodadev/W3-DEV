<!--- Gunluk, Haftalik, Aylik Ajandada ve Olay Aramada Kullanilan, Sube ve Departman Yetkilerimin Kontrolu --->
<cfquery name="get_all_agenda_department_branch" datasource="#dsn#">
	SELECT
		EMPLOYEE_POSITIONS.EMPLOYEE_ID,
		EMPLOYEE_POSITIONS.POSITION_ID,
		EMPLOYEE_POSITIONS.POSITION_CODE,
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_ID,
		DEPARTMENT.DEPARTMENT_HEAD
	FROM
		EMPLOYEE_POSITIONS,
		DEPARTMENT,
		BRANCH
	WHERE
		EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND 
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
		<cfif isDefined("session_userid_") and Len(session_userid_)><!--- Ajanda Olay Aramada Kullaniliyor --->
			AND EMPLOYEE_POSITIONS.IS_MASTER = 1
			AND EMPLOYEE_POSITIONS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_userid_#">
		<cfelse>
			AND EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
		</cfif>
</cfquery>

<cfquery name="GET_AGENDA_COMPANY" datasource="#DSN#">
    SELECT DISTINCT
        SETUP_PERIOD.OUR_COMPANY_ID
    FROM
        EMPLOYEE_POSITION_PERIODS,
        EMPLOYEE_POSITIONS,
        SETUP_PERIOD
    WHERE
        EMPLOYEE_POSITIONS.POSITION_ID = EMPLOYEE_POSITION_PERIODS.POSITION_ID
        AND EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
        AND SETUP_PERIOD.PERIOD_ID = EMPLOYEE_POSITION_PERIODS.PERIOD_ID
</cfquery>
<cfif GET_AGENDA_COMPANY.recordCount>
	<cfset my_comp_list = VALUELIST(GET_AGENDA_COMPANY.OUR_COMPANY_ID)>
<cfelse>
	<cfset my_comp_list = 0><!--- hiç yetkisi yoksa hata vermemesi için 0 atıldı--->
</cfif>
