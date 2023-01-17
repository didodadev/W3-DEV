<cfquery name="get_ssk_yearly" datasource="#dsn#">
	SELECT
		ES.*,
        EIO.BRANCH_ID
	FROM
		EMPLOYEES_SALARY ES INNER JOIN EMPLOYEES_IN_OUT EIO ON ES.IN_OUT_ID = EIO.IN_OUT_ID
	WHERE
		ES.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
		AND
	<cfif isdefined("attributes.sal_year") and len(attributes.sal_year)>
		ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
	<cfelse>
		ES.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#year(now())#">
	</cfif>
		AND ES.IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#">
</cfquery>
