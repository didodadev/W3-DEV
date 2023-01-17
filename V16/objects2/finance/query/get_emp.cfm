<cfquery name="GET_EMP" datasource="#dsn#">
	SELECT 
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME
	FROM 
		EMPLOYEES
	WHERE 
	<cfif isDefined("VAR_EMP")>
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#var_emp#">
	<cfelse>
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
	</cfif>
</cfquery>
