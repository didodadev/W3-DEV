<cfquery name="GET_SALARY_MONEYS" datasource="#dsn#">
	SELECT
		ESC.*,
		Z.ZONE_NAME
	FROM
		EMPLOYEES_SALARY_CHANGE ESC
		LEFT JOIN ZONE Z ON Z.ZONE_ID = ESC.ZONE_ID
	WHERE
		ESC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		<cfif Isdefined("attributes.salary_year") and attributes.salary_year neq 0>
			AND SALARY_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.salary_year#">
		</cfif>
		<cfif isdefined("attributes.salary_mon") and attributes.salary_mon neq 0>
			AND ESC.SALARY_MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.salary_mon#">
		</cfif>
		<cfif isdefined("attributes.salary_money") and len(attributes.salary_money)>
			AND ESC.MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.salary_money#">
		</cfif>
	ORDER BY
		SALARY_YEAR DESC,
		SALARY_MONTH DESC,
		MONEY DESC
</cfquery>
