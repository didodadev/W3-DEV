<cfquery name="get_company_name" datasource="#DSN#">
	SELECT
		OUR_COMPANY.NICK_NAME
	FROM
		EMPLOYEE_POSITIONS,
		OUR_COMPANY
	WHERE 
		EMPLOYEE_POSITIONS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
</cfquery>