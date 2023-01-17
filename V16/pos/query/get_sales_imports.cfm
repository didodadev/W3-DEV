<cfquery name="GET_SALES_IMPORTS" datasource="#DSN#">
	SELECT
		FI.I_ID,
		FI.PRODUCT_COUNT,
		FI.PROBLEMS_COUNT,
		FI.FILE_NAME,
		FI.FILE_SERVER_ID,
		FI.FILE_SIZE,
		FI.STARTDATE,
		FI.FINISHDATE,
		FI.SOURCE_SYSTEM,
		FI.INVOICE_ID,
		FI.IMPORTED,
		FI.IS_MUHASEBE,
		FI.IMPORT_DETAIL,
		FI.RECORD_DATE,
		FI.RECORD_EMP,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		B.BRANCH_ID,
		B.BRANCH_NAME,
		D.DEPARTMENT_HEAD
	FROM
		#dsn2_alias#.FILE_IMPORTS AS FI,
		EMPLOYEES E,
		DEPARTMENT D,
		BRANCH B
	WHERE
	<cfif isdefined('import_process_type') and len(import_process_type)>
		FI.PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#import_process_type#"> AND
	<cfelse>
		FI.PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="-2"> AND<!--- satis --->
	</cfif>
	<cfif len(attributes.startdate) and (not len(attributes.finishdate))>
		FI.STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
	<cfelseif len(attributes.finishdate)  and (not len(attributes.startdate))>
		FI.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
	<cfelseif len(attributes.startdate) and len(attributes.finishdate)>
		FI.STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
		FI.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
	</cfif>
	<cfif session.ep.isBranchAuthorization>
		D.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#"> AND
	</cfif>
	<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
		B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> AND
	</cfif>
	<cfif isdefined("attributes.target_pos") and len(attributes.target_pos)>
		FI.SOURCE_SYSTEM = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.target_pos#"> AND
	</cfif>
		FI.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		B.BRANCH_ID = D.BRANCH_ID AND
		FI.RECORD_EMP = E.EMPLOYEE_ID AND
		<!--- yetkili oldugu subelerin gelmesi icin eklendi BK 20090609 --->
		B.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
	ORDER BY
		FI.IMPORTED,
		FI.RECORD_DATE DESC
</cfquery>
